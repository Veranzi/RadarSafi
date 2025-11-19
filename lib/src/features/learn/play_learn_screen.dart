import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../widgets/radar_button.dart';

class PlayLearnScreen extends StatefulWidget {
  const PlayLearnScreen({super.key});

  @override
  State<PlayLearnScreen> createState() => _PlayLearnScreenState();
}

class _PlayLearnScreenState extends State<PlayLearnScreen> {
  bool started = false;
  int currentQuestion = 0;
  int? selectedAnswer;
  int score = 0;
  bool showSummary = false;

  final questions = const [
    QuizQuestion(
      question: 'Which is the correct way to set up a strong password?',
      answers: [
        'Numbers Only',
        'Characters Only',
        'Numbers & Characters only',
        'Numbers, characters and symbols',
      ],
      correctIndex: 3,
      explanation:
          'A combination of numbers, characters and symbols makes it harder to guess.',
    ),
    QuizQuestion(
      question: 'What should you do when a caller requests OTP codes?',
      answers: [
        'Share it if they sound legit',
        'Hang up immediately and report',
        'Ask them to call later',
        'Text it instead',
      ],
      correctIndex: 1,
      explanation: 'Legitimate institutions will never request OTP codes.',
    ),
  ];

  void _startQuiz() {
    setState(() {
      started = true;
      currentQuestion = 0;
      selectedAnswer = null;
      score = 0;
      showSummary = false;
    });
  }

  void _selectAnswer(int index) {
    if (selectedAnswer != null) return;
    setState(() {
      selectedAnswer = index;
      if (index == questions[currentQuestion].correctIndex) {
        score++;
      }
    });
  }

  void _nextQuestion() {
    if (currentQuestion < questions.length - 1) {
      setState(() {
        currentQuestion++;
        selectedAnswer = null;
      });
    } else {
      setState(() {
        showSummary = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!started) {
      return _buildLanding();
    }
    if (showSummary) {
      return _buildSummary();
    }
    return _buildQuestionCard();
  }

  Widget _buildLanding() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Play & Learn', style: AppTextStyles.title),
          const SizedBox(height: 12),
          Text(
            'Test your cyber awareness and level up with mini quizzes.',
            style: AppTextStyles.body,
          ),
          const Spacer(),
          Center(
            child: Icon(
              Icons.videogame_asset,
              size: 120,
              color: AppColors.accentGreen,
            ),
          ),
          const Spacer(),
          RadarPrimaryButton(label: 'Play Now', onPressed: _startQuiz),
          const SizedBox(height: 12),
          RadarSecondaryButton(label: 'About', onPressed: () {}),
        ],
      ),
    );
  }

  Widget _buildQuestionCard() {
    final question = questions[currentQuestion];
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          LinearProgressIndicator(
            value: (currentQuestion + 1) / questions.length,
            backgroundColor: AppColors.surface,
            color: AppColors.accentGreen,
          ),
          const SizedBox(height: 16),
          Text(
            'Question ${currentQuestion + 1}/${questions.length}',
            style: AppTextStyles.caption,
          ),
          const SizedBox(height: 12),
          Text(question.question, style: AppTextStyles.subtitle),
          const SizedBox(height: 24),
          ...List.generate(question.answers.length, (index) {
            final answer = question.answers[index];
            final isSelected = selectedAnswer == index;
            final isCorrect = question.correctIndex == index;
            Color borderColor = AppColors.outline;
            IconData? icon;

            if (selectedAnswer != null) {
              if (isCorrect) {
                borderColor = AppColors.accentGreen;
                icon = Icons.check_circle;
              } else if (isSelected && !isCorrect) {
                borderColor = AppColors.danger;
                icon = Icons.cancel;
              }
            } else if (isSelected) {
              borderColor = AppColors.accentGreen;
            }

            return GestureDetector(
              onTap: () => _selectAnswer(index),
              child: Container(
                width: double.infinity,
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 18,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: borderColor),
                  color: AppColors.surface,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        answer,
                        style: AppTextStyles.body.copyWith(
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ),
                    if (icon != null)
                      Icon(
                        icon,
                        color: isCorrect
                            ? AppColors.accentGreen
                            : AppColors.danger,
                      ),
                  ],
                ),
              ),
            );
          }),
          const SizedBox(height: 12),
          if (selectedAnswer != null)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.surfaceAlt,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    selectedAnswer == question.correctIndex
                        ? 'Answer is correct'
                        : 'Answer is not correct',
                    style: AppTextStyles.subtitle.copyWith(
                      color: selectedAnswer == question.correctIndex
                          ? AppColors.accentGreen
                          : AppColors.danger,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(question.explanation, style: AppTextStyles.body),
                ],
              ),
            ),
          const Spacer(),
          RadarPrimaryButton(
            label: currentQuestion == questions.length - 1 ? 'Finish' : 'Next',
            onPressed: selectedAnswer != null ? _nextQuestion : null,
          ),
        ],
      ),
    );
  }

  Widget _buildSummary() {
    final scorePercent = (score / questions.length) * 100;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Spacer(),
          Icon(
            scorePercent >= 70 ? Icons.celebration : Icons.psychology,
            size: 120,
            color: AppColors.accentGreen,
          ),
          const SizedBox(height: 16),
          Text(
            'You scored $score/${questions.length}',
            style: AppTextStyles.title,
          ),
          const SizedBox(height: 8),
          Text(
            scorePercent >= 70
                ? 'Great work! You are ready to spot scams.'
                : 'Keep practicing to boost your security awareness.',
            style: AppTextStyles.body,
            textAlign: TextAlign.center,
          ),
          const Spacer(),
          RadarPrimaryButton(label: 'Play Again', onPressed: _startQuiz),
          const SizedBox(height: 12),
          RadarSecondaryButton(
            label: 'Back to Home',
            onPressed: () => setState(() {
              started = false;
            }),
          ),
        ],
      ),
    );
  }
}

class QuizQuestion {
  const QuizQuestion({
    required this.question,
    required this.answers,
    required this.correctIndex,
    required this.explanation,
  });

  final String question;
  final List<String> answers;
  final int correctIndex;
  final String explanation;
}
