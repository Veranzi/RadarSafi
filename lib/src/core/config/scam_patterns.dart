/// Comprehensive scam and phishing patterns database
class ScamPatterns {
  /// Common phishing/scam email patterns
  static const List<String> phishingEmailPatterns = [
    // Urgency tactics
    'urgent action required',
    'immediate action needed',
    'your account will be closed',
    'suspended account',
    'verify now or lose access',
    'expires today',
    'limited time',
    'act now',
    
    // Fake security alerts
    'suspicious activity detected',
    'unauthorized login attempt',
    'verify your identity',
    'confirm your account',
    'update your security',
    'account verification required',
    
    // Financial scams
    'tax refund',
    'inheritance',
    'lottery winner',
    'prize winner',
    'congratulations you won',
    'claim your reward',
    'wire transfer',
    'send money',
    'payment required',
    'overdue payment',
    
    // Personal info requests
    'update payment information',
    'verify credit card',
    'confirm password',
    'update account details',
    'verify personal information',
    'confirm your pin',
    'verify your ssn',
    
    // Fake notifications
    'package delivery',
    'missed delivery',
    'tracking number',
    'invoice attached',
    'payment receipt',
    'order confirmation',
  ];

  /// Suspicious domain patterns
  static const List<String> suspiciousDomainPatterns = [
    // Typosquatting patterns
    'safaricom-',
    'safaricom.',
    'safaric0m',
    'safaricorn',
    'safaricom.co.ke-',
    'safaricom-support',
    'safaricom-help',
    'kplc-',
    'kplc.',
    'kenya-power',
    'equity-bank',
    'equitybank-',
    'mpesa-',
    'm-pesa-',
    'mpesa.',
  ];

  /// Suspicious URL patterns
  static const List<String> suspiciousUrlPatterns = [
    'bit.ly',
    'tinyurl.com',
    'short.link',
    'goo.gl',
    't.co',
    'ow.ly',
    'is.gd',
    'clck.ru',
    'rebrand.ly',
  ];

  /// Common scam phone number patterns (Kenyan context)
  static const List<String> scamPhonePatterns = [
    // Fake customer care
    '+254700',
    '+254800',
    '+254900',
    // Suspicious patterns
    'unknown number',
    'private number',
    'withheld',
  ];

  /// Phishing indicators in content
  static const List<String> phishingIndicators = [
    'click here',
    'click the link',
    'verify by clicking',
    'download attachment',
    'open attachment',
    'reply immediately',
    'call this number',
    'text this number',
    'whatsapp this number',
    'forward this message',
    'share with friends',
    'limited slots available',
    'first come first served',
    'exclusive offer',
    'secret deal',
    'guaranteed win',
    '100% free',
    'no credit card required',
    'act fast',
    'don\'t miss out',
  ];

  /// Check if content contains phishing patterns
  static bool containsPhishingPattern(String content) {
    final lowerContent = content.toLowerCase();
    
    // Check for phishing email patterns
    for (final pattern in phishingEmailPatterns) {
      if (lowerContent.contains(pattern)) {
        return true;
      }
    }
    
    // Check for phishing indicators
    for (final indicator in phishingIndicators) {
      if (lowerContent.contains(indicator)) {
        return true;
      }
    }
    
    return false;
  }

  /// Check if domain is suspicious
  static bool isSuspiciousDomain(String domain) {
    final lowerDomain = domain.toLowerCase();
    
    // Check for suspicious patterns
    for (final pattern in suspiciousDomainPatterns) {
      if (lowerDomain.contains(pattern)) {
        return true;
      }
    }
    
    // Check for known legitimate domains
    final legitimateDomains = [
      'safaricom.co.ke',
      'kplc.co.ke',
      'equitybank.co.ke',
      'equitybankgroup.com',
      'mpesa.safaricom.co.ke',
      'gmail.com',
      'yahoo.com',
      'outlook.com',
      'hotmail.com',
    ];
    
    // If it's not a legitimate domain and contains company names, it's suspicious
    if (lowerDomain.contains('safaricom') && !legitimateDomains.contains(lowerDomain)) {
      return true;
    }
    if (lowerDomain.contains('kplc') && !legitimateDomains.contains(lowerDomain)) {
      return true;
    }
    if (lowerDomain.contains('equity') && !legitimateDomains.contains(lowerDomain)) {
      return true;
    }
    if (lowerDomain.contains('mpesa') && !legitimateDomains.contains(lowerDomain)) {
      return true;
    }
    
    return false;
  }

  /// Check if URL is suspicious
  static bool isSuspiciousUrl(String url) {
    final lowerUrl = url.toLowerCase();
    
    // Check for URL shorteners (often used in scams)
    for (final pattern in suspiciousUrlPatterns) {
      if (lowerUrl.contains(pattern)) {
        return true;
      }
    }
    
    // Check for suspicious domain patterns in URL
    return isSuspiciousDomain(url);
  }
}

