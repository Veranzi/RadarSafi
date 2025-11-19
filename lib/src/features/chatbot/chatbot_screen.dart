import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../widgets/radar_button.dart';
import '../../widgets/radar_logo.dart';
import '../chatbot/widgets/chat_message_bubble.dart';

class ChatbotScreen extends StatefulWidget {
  const ChatbotScreen({super.key});

  @override
  State<ChatbotScreen> createState() => _ChatbotScreenState();
}

class _ChatbotScreenState extends State<ChatbotScreen> {
  final messageController = TextEditingController();

  final List<_ChatMessage> messages = [
    const _ChatMessage(
      text:
          'I just got this WhatsApp message saying “Naivas supermarket is giving free vouchers for their 30th anniversary, click this link to claim yours.” Is it real?',
      isUser: true,
    ),
    const _ChatMessage(
      text:
          'This link is NOT legitimate.\n\nOur database shows this message has been reported 324 times as a scam pretending to be from Naivas.\nNaivas confirmed they are not running any online voucher promotion.\nAdvice: Do not click or forward the link. Delete it immediately.',
      isUser: false,
    ),
  ];

  void _sendMessage() {
    final text = messageController.text.trim();
    if (text.isEmpty) return;
    setState(() {
      messages.add(_ChatMessage(text: text, isUser: true));
      messages.add(
        const _ChatMessage(
          text:
              'Thanks for checking! Our agents are reviewing similar reports. Stay cautious and avoid sharing sensitive info.',
          isUser: false,
        ),
      );
    });
    messageController.clear();
  }

  @override
  void dispose() {
    messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const RadarLogo(size: 48),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Your security bot', style: AppTextStyles.caption),
                  Text('Welcome to RadarSafi', style: AppTextStyles.subtitle),
                ],
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: const [
                    Icon(
                      Icons.shield_outlined,
                      size: 18,
                      color: AppColors.accentGreen,
                    ),
                    SizedBox(width: 6),
                    Text(
                      'Secure',
                      style: TextStyle(color: AppColors.textPrimary),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Expanded(
            child: ListView.builder(
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final message = messages[index];
                return ChatMessageBubble(
                  message: message.text,
                  isUser: message.isUser,
                );
              },
            ),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(24),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: messageController,
                    style: const TextStyle(color: AppColors.textPrimary),
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Ask me anything...',
                      hintStyle: TextStyle(color: AppColors.textSecondary),
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.mic_none,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(width: 4),
                ElevatedButton(
                  onPressed: _sendMessage,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.accentGreen,
                    shape: const CircleBorder(),
                    padding: const EdgeInsets.all(12),
                  ),
                  child: const Icon(
                    Icons.send,
                    color: AppColors.backgroundDeep,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Center(
            child: RadarGhostButton(
              label: 'Need inspiration? View examples',
              onPressed: () {},
            ),
          ),
        ],
      ),
    );
  }
}

class _ChatMessage {
  const _ChatMessage({required this.text, required this.isUser});

  final String text;
  final bool isUser;
}
