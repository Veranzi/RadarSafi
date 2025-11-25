/// Company-specific knowledge base for verification
class CompanyKnowledge {
  static const Map<String, Map<String, dynamic>> companyData = {
    'Safaricom': {
      'officialWebsite': 'https://www.safaricom.co.ke',
      'customerCare': '100',
      'officialEmail': '@safaricom.co.ke',
      'commonScams': [
        'Fake M-Pesa messages asking for PIN',
        'Phishing links claiming account suspension',
        'Fake customer care numbers',
        'Lottery/prize scams',
        'Fake M-Pesa agent registration',
      ],
      'verificationTips': [
        'Safaricom never asks for your M-Pesa PIN',
        'Official customer care is 100',
        'Check sender number - official messages come from specific short codes',
        'Verify any links on official website',
      ],
    },
    'KPLC': {
      'officialWebsite': 'https://www.kplc.co.ke',
      'customerCare': '97771 or 0703070707',
      'officialEmail': '@kplc.co.ke',
      'commonScams': [
        'Fake disconnection notices',
        'Phishing links for bill payment',
        'Fake meter reading requests',
        'Fake account suspension messages',
        'Fake refund scams',
      ],
      'verificationTips': [
        'KPLC sends official SMS from specific numbers',
        'Verify bills on official website or app',
        'Never share meter number or account details via suspicious links',
        'Official customer care: 97771',
      ],
    },
    'Equity Bank': {
      'officialWebsite': 'https://www.equitybank.co.ke',
      'customerCare': '0763 000 000',
      'officialEmail': '@equitybank.co.ke',
      'commonScams': [
        'Fake account suspension messages',
        'Phishing links for account verification',
        'Fake loan approval scams',
        'Fake transaction alerts',
        'Fake customer care numbers',
      ],
      'verificationTips': [
        'Equity Bank never asks for PIN or password via SMS/email',
        'Verify transactions through official app or branch',
        'Official customer care: 0763 000 000',
        'Check sender email domain carefully',
      ],
    },
    'M-Pesa': {
      'officialWebsite': 'https://www.safaricom.co.ke/personal/m-pesa',
      'customerCare': '234 or 100',
      'officialEmail': '@safaricom.co.ke',
      'commonScams': [
        'Fake M-Pesa PIN requests',
        'Phishing links for account verification',
        'Fake transaction reversal scams',
        'Fake agent registration',
        'Fake cashback offers',
      ],
      'verificationTips': [
        'M-Pesa NEVER asks for your PIN',
        'Official messages come from specific short codes',
        'Verify transactions via *234# or official app',
        'Never click links in suspicious messages',
      ],
    },
  };

  /// Get company information for verification
  static Map<String, dynamic>? getCompanyInfo(String companyName) {
    final normalizedName = companyName.toLowerCase();
    
    if (normalizedName.contains('safaricom') || normalizedName.contains('safari')) {
      return companyData['Safaricom'];
    } else if (normalizedName.contains('kplc') || normalizedName.contains('kenya power')) {
      return companyData['KPLC'];
    } else if (normalizedName.contains('equity') || normalizedName.contains('equity bank')) {
      return companyData['Equity Bank'];
    } else if (normalizedName.contains('mpesa') || normalizedName.contains('m-pesa')) {
      return companyData['M-Pesa'];
    }
    
    return null;
  }

  /// Check if message mentions any known companies
  static List<String> detectCompanies(String message) {
    final companies = <String>[];
    final lowerMessage = message.toLowerCase();
    
    if (lowerMessage.contains('safaricom') || lowerMessage.contains('safari')) {
      companies.add('Safaricom');
    }
    if (lowerMessage.contains('kplc') || lowerMessage.contains('kenya power')) {
      companies.add('KPLC');
    }
    if (lowerMessage.contains('equity') && lowerMessage.contains('bank')) {
      companies.add('Equity Bank');
    }
    if (lowerMessage.contains('mpesa') || lowerMessage.contains('m-pesa')) {
      companies.add('M-Pesa');
    }
    
    return companies;
  }
}

