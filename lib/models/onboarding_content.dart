class OnboardingContent {
  final String title;
  final String description;
  final String imagePath;

  OnboardingContent({
    required this.title,
    required this.description,
    required this.imagePath,
  });
}

List<OnboardingContent> onboardingContents = [
  OnboardingContent(
    title: "Track Your Cycle",
    description: "Easily track your menstrual cycle, symptoms, and fertility window with our intuitive calendar.",
    imagePath: "assets/images/onboarding_1.png",
  ),
  OnboardingContent(
    title: "Monitor Your Pregnancy",
    description: "Follow your pregnancy journey week by week with personalized insights and milestone tracking.",
    imagePath: "assets/images/onboarding_2.png",
  ),
  OnboardingContent(
    title: "Learn & Grow",
    description: "Access educational resources about menstrual health, pregnancy, and women's wellness.",
    imagePath: "assets/images/onboarding_3.png",
  ),
  OnboardingContent(
    title: "Connect & Share",
    description: "Join our community forums to connect with others and get support from health professionals.",
    imagePath: "assets/images/onboarding_4.png",
  ),
];
