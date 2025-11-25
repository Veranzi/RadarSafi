import 'dart:convert';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import '../config/api_config.dart';

class LLMService {
  static final LLMService _instance = LLMService._internal();
  factory LLMService() => _instance;
  LLMService._internal();

  static const String _geminiApiBaseUrl = 'https://generativelanguage.googleapis.com/v1beta/models';

  /// Analyze image for scam indicators using Gemini Vision
  Future<Map<String, dynamic>> analyzeImage({
    required Uint8List imageBytes,
    String? imageMimeType,
  }) async {
    try {
      ApiConfig.validate();
      final apiKey = ApiConfig.googleApiKey!;

      // Convert image to base64
      final base64Image = base64Encode(imageBytes);
      final mimeType = imageMimeType ?? 'image/jpeg';

      final prompt = '''
You are a cybersecurity expert analyzing an image for SCAM and PHISHING indicators. Be AGGRESSIVE in detecting scams - err on the side of caution.

CRITICAL: Mark as SCAM if you detect ANY of these:
- Urgent action requests (account suspension, verify now, etc.)
- Requests for PIN, password, or personal information
- Fake company logos or branding
- Suspicious URLs or phone numbers
- Lottery/prize win messages
- Payment requests or wire transfers
- Typosquatting domains (safaricom-xxx, kplc-xxx, etc.)
- Poor grammar/spelling (common in scams)
- Generic greetings ("Dear Customer" instead of name)
- Threats or fear tactics

For Kenyan companies, know:
- Safaricom: Official domain is safaricom.co.ke, customer care is 100, NEVER asks for M-Pesa PIN
- KPLC: Official domain is kplc.co.ke, customer care is 97771
- Equity Bank: Official domain is equitybank.co.ke, customer care is 0763 000 000
- M-Pesa: Part of Safaricom, NEVER asks for PIN

Analyze this image thoroughly. Check for:
1. Text content (urgent requests, fake logos, phishing language)
2. Company branding (is it authentic or fake?)
3. URLs visible (typosquatting, suspicious domains)
4. Phone numbers (do they match official numbers?)
5. Scam patterns (lottery wins, account suspension, etc.)

Provide a JSON response:
{
  "isScam": true/false,
  "confidence": 0.0-1.0,
  "indicators": ["specific detected indicators"],
  "company": "detected company or null",
  "analysis": "detailed analysis explaining why it's scam or legitimate",
  "advice": "specific actionable advice"
}

IMPORTANT: If uncertain, mark as SCAM with lower confidence. Better safe than sorry.
''';

      final requestBody = {
        'contents': [
          {
            'parts': [
              {'text': prompt},
              {
                'inline_data': {
                  'mime_type': mimeType,
                  'data': base64Image,
                }
              }
            ]
          }
        ],
        'generationConfig': {
          'temperature': 0.1,
          'topK': 32,
          'topP': 1,
          'maxOutputTokens': 1024,
        }
      };

      // Try with header authentication (preferred method)
      // Using gemini-2.0-flash-001 for image analysis (supports vision)
      final response = await http.post(
        Uri.parse('$_geminiApiBaseUrl/gemini-2.0-flash-001:generateContent'),
        headers: {
          'Content-Type': 'application/json',
          'x-goog-api-key': apiKey,
        },
        body: jsonEncode(requestBody),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final text = data['candidates']?[0]?['content']?['parts']?[0]?['text'] ?? '';
        return _parseLLMResponse(text, 'image');
      } else {
        final errorBody = response.body;
        throw Exception('LLM API error: ${response.statusCode} - $errorBody');
      }
    } catch (e) {
      return _getFallbackResponse('image', error: e.toString());
    }
  }

  /// Analyze URL/link for scam indicators
  Future<Map<String, dynamic>> analyzeLink({
    required String url,
  }) async {
    try {
      ApiConfig.validate();
      final apiKey = ApiConfig.googleApiKey!;

      final prompt = '''
You are a cybersecurity expert analyzing a URL for SCAM and PHISHING. Be AGGRESSIVE - mark as SCAM if suspicious.

CRITICAL SCAM INDICATORS:
- URL shorteners (bit.ly, tinyurl.com, etc.) - often used in scams
- Typosquatting: safaricom-xxx.com, kplc-xxx.com, safaric0m.com (0 instead of o)
- Suspicious domains: safaricom-support.com, kplc-help.com, etc.
- HTTP instead of HTTPS (legitimate sites use HTTPS)
- Newly registered domains (< 1 year old)
- Domains with random characters or numbers
- Subdomains claiming to be official (support.safaricom-xxx.com)

LEGITIMATE DOMAINS (Kenyan companies):
- Safaricom: safaricom.co.ke, mpesa.safaricom.co.ke
- KPLC: kplc.co.ke
- Equity Bank: equitybank.co.ke, equitybankgroup.com
- M-Pesa: mpesa.safaricom.co.ke

URL to analyze: $url

Check:
1. Domain legitimacy (matches official domains exactly?)
2. URL structure (typosquatting, suspicious patterns?)
3. HTTPS/SSL certificate
4. Known scam patterns
5. Domain age (if you can infer)

Provide JSON response:
{
  "isScam": true/false,
  "confidence": 0.0-1.0,
  "indicators": ["specific indicators found"],
  "company": "detected company or null",
  "domain": "extracted domain",
  "analysis": "detailed explanation",
  "advice": "specific actionable advice"
}

IMPORTANT: If domain doesn't match official domains exactly, mark as SCAM. Better safe than sorry.
''';

      final requestBody = {
        'contents': [
          {
            'parts': [
              {'text': prompt}
            ]
          }
        ],
        'generationConfig': {
          'temperature': 0.1,
          'topK': 32,
          'topP': 1,
          'maxOutputTokens': 1024,
        }
      };

      // Try with header authentication (preferred method)
      // Using gemini-2.0-flash-001 for text analysis (stable model)
      final response = await http.post(
        Uri.parse('$_geminiApiBaseUrl/gemini-2.0-flash-001:generateContent'),
        headers: {
          'Content-Type': 'application/json',
          'x-goog-api-key': apiKey,
        },
        body: jsonEncode(requestBody),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final text = data['candidates']?[0]?['content']?['parts']?[0]?['text'] ?? '';
        return _parseLLMResponse(text, 'link');
      } else {
        final errorBody = response.body;
        throw Exception('LLM API error: ${response.statusCode} - $errorBody');
      }
    } catch (e) {
      return _getFallbackResponse('link', error: e.toString());
    }
  }

  /// Analyze email/message content for scam indicators
  Future<Map<String, dynamic>> analyzeEmailMessage({
    required String senderEmail,
    required String messageContent,
  }) async {
    try {
      ApiConfig.validate();
      final apiKey = ApiConfig.googleApiKey!;

      final prompt = '''
You are a cybersecurity expert analyzing an EMAIL/MESSAGE for SCAM and PHISHING. Be AGGRESSIVE - mark as SCAM if suspicious.

CRITICAL SCAM INDICATORS:
- Urgent action required / account suspension / verify now
- Requests for PIN, password, credit card, personal info
- Suspicious sender email (typosquatting, fake domains)
- Generic greetings ("Dear Customer" instead of your name)
- Poor grammar/spelling (common in scams)
- Threats or fear tactics
- Lottery/prize win messages
- Payment requests or wire transfers
- Suspicious links or attachments
- Excessive urgency (act now, limited time, etc.)

LEGITIMATE EMAIL DOMAINS (Kenyan companies):
- Safaricom: @safaricom.co.ke
- KPLC: @kplc.co.ke
- Equity Bank: @equitybank.co.ke
- M-Pesa: @safaricom.co.ke

Sender email: $senderEmail
Message content: $messageContent

Check:
1. Sender email domain (matches official domains exactly?)
2. Message content (scam phrases, urgency, requests for info?)
3. Grammar/spelling quality
4. Generic vs personalized greeting
5. Suspicious links or attachments mentioned

Provide JSON response:
{
  "isScam": true/false,
  "confidence": 0.0-1.0,
  "indicators": ["specific indicators found"],
  "company": "detected company or null",
  "analysis": "detailed explanation",
  "advice": "specific actionable advice"
}

IMPORTANT: If sender domain doesn't match official domains exactly, mark as SCAM. If message contains urgent requests or asks for personal info, mark as SCAM. Better safe than sorry.
''';

      final requestBody = {
        'contents': [
          {
            'parts': [
              {'text': prompt}
            ]
          }
        ],
        'generationConfig': {
          'temperature': 0.1,
          'topK': 32,
          'topP': 1,
          'maxOutputTokens': 1024,
        }
      };

      final response = await http.post(
        Uri.parse('$_geminiApiBaseUrl/gemini-2.0-flash-001:generateContent'),
        headers: {
          'Content-Type': 'application/json',
          'x-goog-api-key': apiKey,
        },
        body: jsonEncode(requestBody),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final text = data['candidates']?[0]?['content']?['parts']?[0]?['text'] ?? '';
        return _parseLLMResponse(text, 'email');
      } else {
        throw Exception('LLM API error: ${response.statusCode}');
      }
    } catch (e) {
      return _getFallbackResponse('email', error: e.toString());
    }
  }

  /// Analyze phone number for scam indicators
  Future<Map<String, dynamic>> analyzePhoneNumber({
    required String phoneNumber,
    String? claimedCompany,
    String? reason,
  }) async {
    try {
      ApiConfig.validate();
      final apiKey = ApiConfig.googleApiKey!;

      final prompt = '''
You are a cybersecurity expert analyzing a phone number for SCAM indicators. Be AGGRESSIVE in detection.

OFFICIAL PHONE NUMBERS (Kenyan companies):
- Safaricom: 100, 234, 200
- KPLC: 97771, 0703070707
- Equity Bank: 0763 000 000
- M-Pesa: 234, 100

SCAM INDICATORS:
- Number doesn't match official customer care
- Unknown/private/withheld numbers
- Numbers asking for PIN/password
- Numbers claiming to be from companies but not official
- Premium rate numbers (starting with 700, 800, 900)
- International numbers claiming to be local companies

Phone number: $phoneNumber
Claimed company: ${claimedCompany ?? 'Not specified'}
Reason for contact: ${reason ?? 'Not specified'}

Check:
1. Does it match official customer care numbers?
2. Is it a known scam number pattern?
3. Does the reason match typical scam tactics?
4. Is the number format suspicious?

Provide JSON response:
{
  "isScam": true/false,
  "confidence": 0.0-1.0,
  "indicators": ["specific indicators"],
  "company": "actual company or null",
  "analysis": "detailed explanation",
  "advice": "specific actionable advice"
}

IMPORTANT: If number doesn't match official numbers exactly, mark as SCAM. Better safe than sorry.
''';

      final requestBody = {
        'contents': [
          {
            'parts': [
              {'text': prompt}
            ]
          }
        ],
        'generationConfig': {
          'temperature': 0.1,
          'topK': 32,
          'topP': 1,
          'maxOutputTokens': 1024,
        }
      };

      // Try with header authentication (preferred method)
      // Using gemini-2.0-flash-001 for text analysis (stable model)
      final response = await http.post(
        Uri.parse('$_geminiApiBaseUrl/gemini-2.0-flash-001:generateContent'),
        headers: {
          'Content-Type': 'application/json',
          'x-goog-api-key': apiKey,
        },
        body: jsonEncode(requestBody),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final text = data['candidates']?[0]?['content']?['parts']?[0]?['text'] ?? '';
        return _parseLLMResponse(text, 'phone');
      } else {
        throw Exception('LLM API error: ${response.statusCode}');
      }
    } catch (e) {
      return _getFallbackResponse('phone', error: e.toString());
    }
  }

  /// Parse LLM response text to extract structured data
  Map<String, dynamic> _parseLLMResponse(String text, String type) {
    try {
      // Try to extract JSON from the response
      final jsonMatch = RegExp(r'\{[\s\S]*\}').firstMatch(text);
      if (jsonMatch != null) {
        final jsonStr = jsonMatch.group(0);
        final parsed = jsonDecode(jsonStr!);
        
        // Be more aggressive: if confidence > 0.3 or has indicators, mark as scam
        final rawIsScam = parsed['isScam'] ?? false;
        final confidence = (parsed['confidence'] as num?)?.toDouble() ?? 0.5;
        final indicators = List<String>.from(parsed['indicators'] ?? []);
        
        // If there are indicators or confidence is moderate, err on side of caution
        final isScam = rawIsScam || (indicators.isNotEmpty && confidence > 0.3);
        
        return {
          'isScam': isScam,
          'confidence': confidence,
          'indicators': indicators,
          'company': parsed['company'],
          'analysis': parsed['analysis'] ?? text,
          'advice': parsed['advice'] ?? '',
          'rawResponse': text,
        };
      }

      // Fallback: parse from text - be aggressive in detection
      final lowerText = text.toLowerCase();
      final isScam = lowerText.contains('scam') ||
          lowerText.contains('fraud') ||
          lowerText.contains('suspicious') ||
          lowerText.contains('not legitimate') ||
          lowerText.contains('phishing') ||
          lowerText.contains('fake') ||
          lowerText.contains('warning') ||
          (lowerText.contains('legitimate') && !lowerText.contains('appears legitimate'));

      return {
        'isScam': isScam,
        'confidence': isScam ? 0.7 : 0.3,
        'indicators': _extractIndicators(text),
        'company': _extractCompany(text),
        'analysis': text,
        'advice': _extractAdvice(text),
        'rawResponse': text,
      };
    } catch (e) {
      return _getFallbackResponse(type, error: e.toString());
    }
  }

  List<String> _extractIndicators(String text) {
    final indicators = <String>[];
    final lowerText = text.toLowerCase();

    if (lowerText.contains('phishing')) indicators.add('Phishing attempt');
    if (lowerText.contains('fake')) indicators.add('Fake content');
    if (lowerText.contains('suspicious')) indicators.add('Suspicious activity');
    if (lowerText.contains('urgent')) indicators.add('Urgency tactics');
    if (lowerText.contains('legitimate') && !lowerText.contains('not legitimate')) {
      indicators.add('Appears legitimate');
    }

    return indicators;
  }

  String? _extractCompany(String text) {
    final companyPattern = RegExp(r'company[:\s]+([A-Z][a-zA-Z\s]+)', caseSensitive: false);
    final match = companyPattern.firstMatch(text);
    return match?.group(1)?.trim();
  }

  String _extractAdvice(String text) {
    if (text.toLowerCase().contains('advice')) {
      final adviceMatch = RegExp(r'advice[:\s]+(.+?)(?:\n|$)', caseSensitive: false).firstMatch(text);
      return adviceMatch?.group(1)?.trim() ?? 'Please verify through official channels.';
    }
    return 'Please verify through official channels.';
  }

  Map<String, dynamic> _getFallbackResponse(String type, {String? error}) {
    return {
      'isScam': false,
      'confidence': 0.5,
      'indicators': <String>[],
      'company': null,
      'analysis': 'Unable to complete analysis. ${error ?? "Please verify through official channels."}',
      'advice': 'Please verify through official channels.',
      'rawResponse': error ?? 'Analysis unavailable',
    };
  }
}

