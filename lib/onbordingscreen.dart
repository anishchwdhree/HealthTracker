import 'package:flutter/material.dart';
import 'package:pregnancy_health_tracker/constants/colors.dart';
import 'package:pregnancy_health_tracker/constants/styles.dart';
import 'package:pregnancy_health_tracker/models/onboarding_content.dart';
import 'package:pregnancy_health_tracker/screens/auth/login_screen.dart';
import 'package:pregnancy_health_tracker/utils/fade_animation.dart';
import 'package:pregnancy_health_tracker/widgets/placeholder_image.dart';

class Onbordingscreen extends StatefulWidget {
  const Onbordingscreen({super.key});

  @override
  State<Onbordingscreen> createState() => _OnbordingscreenState();
}

class _OnbordingscreenState extends State<Onbordingscreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              flex: 3,
              child: PageView.builder(
                controller: _pageController,
                itemCount: onboardingContents.length,
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
                itemBuilder: (context, index) {
                  return OnboardingPage(
                    content: onboardingContents[index],
                    index: index,
                  );
                },
              ),
            ),
            Expanded(
              flex: 1,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      onboardingContents.length,
                      (index) => buildDot(index),
                    ),
                  ),
                  const Spacer(),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        if (_currentPage != 0)
                          FadeAnimation(
                            delay: 0.2,
                            child: TextButton(
                              onPressed: () {
                                _pageController.previousPage(
                                  duration: const Duration(milliseconds: 500),
                                  curve: Curves.easeInOut,
                                );
                              },
                              child: const Text(
                                'Back',
                                style: TextStyle(
                                  color: AppColors.textSecondary,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          )
                        else
                          const SizedBox(width: 80),
                        FadeAnimation(
                          delay: 0.3,
                          child: ElevatedButton(
                            style: AppStyles.primaryButtonStyle,
                            onPressed: () {
                              if (_currentPage == onboardingContents.length - 1) {
                                // Navigate to login screen
                                Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(
                                    builder: (context) => const LoginScreen(),
                                  ),
                                );
                              } else {
                                _pageController.nextPage(
                                  duration: const Duration(milliseconds: 500),
                                  curve: Curves.easeInOut,
                                );
                              }
                            },
                            child: Text(
                              _currentPage == onboardingContents.length - 1
                                  ? 'Get Started'
                                  : 'Next',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildDot(int index) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.only(right: 8),
      height: 8,
      width: _currentPage == index ? 24 : 8,
      decoration: BoxDecoration(
        color: _currentPage == index
            ? AppColors.primaryColor
            : AppColors.textLight,
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }
}

class OnboardingPage extends StatelessWidget {
  final OnboardingContent content;
  final int index;

  const OnboardingPage({
    super.key,
    required this.content,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FadeAnimation(
            delay: 0.2,
            child: PlaceholderImage(
              imagePath: content.imagePath,
              width: 280,
              height: 280,
              icon: _getIconForIndex(index),
            ),
          ),
          const SizedBox(height: 40),
          FadeAnimation(
            delay: 0.4,
            child: Text(
              content.title,
              style: AppStyles.headingMedium,
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 16),
          FadeAnimation(
            delay: 0.6,
            child: Text(
              content.description,
              style: AppStyles.bodyMedium,
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  IconData _getIconForIndex(int index) {
    switch (index) {
      case 0:
        return Icons.calendar_month;
      case 1:
        return Icons.pregnant_woman;
      case 2:
        return Icons.menu_book;
      case 3:
        return Icons.forum;
      default:
        return Icons.image;
    }
  }
}