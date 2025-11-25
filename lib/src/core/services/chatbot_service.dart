import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../config/api_config.dart';
import '../config/company_knowledge.dart';

class ChatbotService {
  static final ChatbotService _instance = ChatbotService._internal();
  factory ChatbotService() => _instance;
  ChatbotService._internal();

  final List<Map<String, String>> _conversationHistory = [];

  /// Get chatbot response using Google Gemini API, filtered for cybersecurity
  Future<String> getResponse(String userMessage) async {
    try {
      ApiConfig.validate();
      final apiKey = ApiConfig.googleApiKey!;

      // Note: We'll add user message to history after successful response

      // Build conversation history for context
      final contents = <Map<String, dynamic>>[];
      
      // Detect companies mentioned in user message
      final mentionedCompanies = CompanyKnowledge.detectCompanies(userMessage);
      String companyContext = '';
      
      if (mentionedCompanies.isNotEmpty) {
        companyContext = '\n\nCOMPANY-SPECIFIC KNOWLEDGE:\n';
        for (var company in mentionedCompanies) {
          final info = CompanyKnowledge.getCompanyInfo(company);
          if (info != null) {
            companyContext += '\n$company:\n';
            companyContext += 'Official Website: ${info['officialWebsite']}\n';
            companyContext += 'Customer Care: ${info['customerCare']}\n';
            companyContext += 'Common Scams: ${(info['commonScams'] as List).join(', ')}\n';
            companyContext += 'Verification Tips: ${(info['verificationTips'] as List).join(' | ')}\n';
          }
        }
      }

      // Add system instruction as first message
      contents.add({
        'role': 'user',
        'parts': [
          {
            'text': 'You are RadarSafi Agent, a cybersecurity expert focused on Kenyan companies (Safaricom, KPLC, Equity Bank, M-Pesa).\n\n'
                'YOUR ROLE:\n'
                '• Verify suspicious messages, links, emails, and phone numbers\n'
                '• Identify scams and phishing attempts\n'
                '• Provide concise, actionable security advice\n'
                '• Focus on Kenyan financial and utility services\n\n'
                'RESPONSE GUIDELINES:\n'
                '• Keep responses SHORT and CONCISE (2-4 sentences max)\n'
                '• Use bullet points only when necessary\n'
                '• Be direct and actionable\n'
                '• Avoid long explanations - get to the point quickly\n'
                '• If legitimate, say so briefly\n'
                '• If suspicious, state the risk clearly and what to do\n\n'
                'FORMATTING:\n'
                '• No markdown asterisks (*) or bold symbols\n'
                '• Use simple, clear language\n'
                '• One main point per response\n'
                '• Maximum 3-4 lines of text\n\n'
                '${companyContext.isNotEmpty ? companyContext : ''}'
                'Focus ONLY on cybersecurity. Be brief and helpful.'
          }
        ]
      });
      
      // Add previous conversation history (last 5 exchanges)
      final recentHistory = _conversationHistory.length > 10 
          ? _conversationHistory.sublist(_conversationHistory.length - 10)
          : _conversationHistory;
      
      for (var msg in recentHistory) {
        contents.add({
          'role': msg['role'] == 'user' ? 'user' : 'model',
          'parts': [
            {'text': msg['parts'] ?? msg['text'] ?? ''}
          ]
        });
      }
      
      // Add current user message
      contents.add({
        'role': 'user',
        'parts': [
          {'text': userMessage}
        ]
      });

      final requestBody = {
        'contents': contents,
        'generationConfig': {
          'temperature': 0.3, // Lower temperature for more focused, concise responses
          'topK': 20, // Reduced for more focused output
          'topP': 0.8, // Reduced for more deterministic responses
          'maxOutputTokens': 256, // Reduced from 1024 to force shorter responses
        },
        'safetySettings': [
          {
            'category': 'HARM_CATEGORY_HARASSMENT',
            'threshold': 'BLOCK_MEDIUM_AND_ABOVE'
          },
          {
            'category': 'HARM_CATEGORY_HATE_SPEECH',
            'threshold': 'BLOCK_MEDIUM_AND_ABOVE'
          },
          {
            'category': 'HARM_CATEGORY_SEXUALLY_EXPLICIT',
            'threshold': 'BLOCK_MEDIUM_AND_ABOVE'
          },
          {
            'category': 'HARM_CATEGORY_DANGEROUS_CONTENT',
            'threshold': 'BLOCK_MEDIUM_AND_ABOVE'
          }
        ]
      };

      // Use header authentication (preferred method for Gemini API)
      // Using gemini-2.0-flash-001 (stable model that supports generateContent)
      final response = await http.post(
        Uri.parse('https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash-001:generateContent'),
        headers: {
          'Content-Type': 'application/json',
          'x-goog-api-key': apiKey,
        },
        body: jsonEncode(requestBody),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        
        // Check for errors in response
        if (data['error'] != null) {
          throw Exception('API Error: ${data['error']['message']}');
        }
        
        final text = data['candidates']?[0]?['content']?['parts']?[0]?['text'] ?? '';
        
        if (text.isEmpty) {
          throw Exception('Empty response from API');
        }
        
        // Filter response to ensure it's cybersecurity-related
        final filteredResponse = _filterForCybersecurity(text, userMessage);
        
        // Clean and format the response (remove markdown asterisks, format nicely)
        final cleanedResponse = _cleanMarkdown(filteredResponse);
        
        // Add user message and assistant response to history
        _conversationHistory.add({
          'role': 'user',
          'parts': userMessage,
        });
        _conversationHistory.add({
          'role': 'model',
          'parts': cleanedResponse,
        });
        
        // Keep conversation history manageable (last 10 exchanges = 20 messages)
        if (_conversationHistory.length > 20) {
          _conversationHistory.removeRange(0, _conversationHistory.length - 20);
        }
        
        return cleanedResponse;
      } else {
        final errorBody = response.body;
        throw Exception('Chatbot API error: ${response.statusCode} - $errorBody');
      }
    } catch (e) {
      // Log error for debugging (using debugPrint for Flutter)
      debugPrint('Chatbot error: $e');
      
      // Fallback response with more helpful message
      final errorMsg = e.toString();
      if (errorMsg.contains('404')) {
        return 'RadarSafi Agent: API endpoint not found. Please ensure the Google Gemini API is enabled for your API key in Google Cloud Console.';
      } else if (errorMsg.contains('403') || errorMsg.contains('401')) {
        return 'RadarSafi Agent: API authentication failed. Please check your API key configuration.';
      } else if (errorMsg.contains('429')) {
        return 'RadarSafi Agent: API rate limit exceeded. Please try again in a moment.';
      }
      
      return 'I apologize, but I\'m having trouble processing your request right now. '
          'Error: ${errorMsg.contains("Exception:") ? errorMsg.split("Exception:")[1].trim() : "Unknown error"}. '
          'Please try again, or if you have a security concern, you can use the Report feature to verify suspicious content.';
    }
  }

  /// Filter and shorten response to ensure it's concise and cybersecurity-related
  String _filterForCybersecurity(String response, String userMessage) {
    // Make response more concise - remove unnecessary fluff
    var cleanedResponse = response.trim();
    
    // Remove common verbose phrases (case insensitive)
    final verbosePhrases = RegExp(
      r'\b(I understand|Let me|I can help|I.m here to|Please note that|It.s important to|I would like to|I want to)\b',
      caseSensitive: false,
    );
    cleanedResponse = cleanedResponse.replaceAll(verbosePhrases, '');
    cleanedResponse = cleanedResponse.replaceAll(RegExp(r'\s+'), ' '); // Remove extra spaces
    
    // Split into sentences and keep only first 2-3 most relevant
    final sentences = cleanedResponse.split(RegExp(r'[.!?]+')).where((s) => s.trim().isNotEmpty).toList();
    
    // Keep response short (max 2-3 sentences)
    if (sentences.length > 3) {
      cleanedResponse = sentences.take(3).join('. ').trim();
      if (!cleanedResponse.endsWith('.') && !cleanedResponse.endsWith('!') && !cleanedResponse.endsWith('?')) {
        cleanedResponse += '.';
      }
    }
    
    // Check if response is cybersecurity-related
    final securityKeywords = [
      'security', 'scam', 'phishing', 'fraud', 'cyber', 'hack', 'malware',
      'virus', 'password', 'authentication', 'verification', 'safe', 'unsafe',
      'legitimate', 'suspicious', 'threat', 'attack', 'vulnerability', 'privacy',
      'data protection', 'online safety', 'identity theft', 'social engineering',
      'safaricom', 'kplc', 'equity', 'mpesa', 'm-pesa'
    ];

    final responseLower = cleanedResponse.toLowerCase();
    final userMessageLower = userMessage.toLowerCase();

    // If response contains security keywords, return concise version
    if (securityKeywords.any((keyword) => responseLower.contains(keyword))) {
      return cleanedResponse;
    }

    // If user message is clearly not security-related, redirect briefly
    final nonSecurityTopics = [
      'weather', 'recipe', 'sports', 'entertainment', 'movie', 'music',
      'game', 'joke', 'story', 'history', 'science', 'math'
    ];

    if (nonSecurityTopics.any((topic) => userMessageLower.contains(topic))) {
      return 'I focus on cybersecurity and online safety. How can I help verify suspicious content?';
    }

    // Return concise response
    return cleanedResponse;
  }

  /// Clean markdown formatting from response
  String _cleanMarkdown(String text) {
    // Remove bold markdown (**text** -> text)
    text = text.replaceAllMapped(
      RegExp(r'\*\*([^*]+)\*\*'),
      (match) => match.group(1) ?? '',
    );
    
    // Remove single asterisks for emphasis (*text* -> text)
    text = text.replaceAllMapped(
      RegExp(r'(?<!\*)\*([^*]+)\*(?!\*)'),
      (match) => match.group(1) ?? '',
    );
    
    // Clean up any remaining asterisks at start/end of lines
    text = text.replaceAll(RegExp(r'^\*\s*', multiLine: true), '');
    text = text.replaceAll(RegExp(r'\s*\*$', multiLine: true), '');
    
    // Format bullet points nicely (convert - or * to bullet)
    text = text.replaceAllMapped(
      RegExp(r'^[\s]*[-*]\s+', multiLine: true),
      (match) => '• ',
    );
    
    // Clean up multiple spaces
    text = text.replaceAll(RegExp(r' {2,}'), ' ');
    
    // Clean up multiple newlines (max 2 consecutive)
    text = text.replaceAll(RegExp(r'\n{3,}'), '\n\n');
    
    return text.trim();
  }

  /// Clear conversation history
  void clearHistory() {
    _conversationHistory.clear();
  }
}

