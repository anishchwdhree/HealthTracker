import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pregnancy_health_tracker/constants/colors.dart';
import 'package:pregnancy_health_tracker/models/cycle_data.dart';
import 'package:pregnancy_health_tracker/screens/dashboard/home_screen.dart';
import 'package:pregnancy_health_tracker/services/auth_service.dart';
import 'package:pregnancy_health_tracker/services/cycle_service.dart';
import 'package:pregnancy_health_tracker/utils/fade_animation.dart';
import 'package:table_calendar/table_calendar.dart';

class CycleOnboardingScreen extends StatefulWidget {
  const CycleOnboardingScreen({super.key});

  @override
  State<CycleOnboardingScreen> createState() => _CycleOnboardingScreenState();
}

class _CycleOnboardingScreenState extends State<CycleOnboardingScreen> with SingleTickerProviderStateMixin {
  final PageController _pageController = PageController();
  final CycleService _cycleService = CycleService();
  final AuthService _authService = AuthService();

  int _currentPage = 0;
  final int _totalPages = 3;

  // User's answers
  int _periodLength = 5;
  int _cycleLength = 28;
  DateTime _lastPeriodStartDate = DateTime.now().subtract(const Duration(days: 14));

  // Animation controller
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _nextPage() {
    if (_currentPage < _totalPages - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _finishOnboarding();
    }
  }

  void _previousPage() {
    if (_currentPage > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  Future<void> _finishOnboarding() async {
    try {
      // Save the user's cycle data
      final cycleData = CycleData(
        startDate: _lastPeriodStartDate,
        endDate: _lastPeriodStartDate.add(Duration(days: _periodLength - 1)),
        cycleLength: _cycleLength,
        periodLength: _periodLength,
      );

      _cycleService.addCycle(cycleData);

      // Check if the widget is still mounted
      if (!mounted) return;

      // Show loading indicator
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(
          child: CircularProgressIndicator(
            color: AppColors.primaryColor,
          ),
        ),
      );

      // Try to mark onboarding as completed, but don't block if it fails
      try {
        await _authService.setOnboardingCompleted(true);
      } catch (e) {
        debugPrint('Error setting onboarding status: $e');
        // Continue anyway
      }

      // Simulate personalization delay
      await Future.delayed(const Duration(seconds: 1));

      // Check if the widget is still mounted
      if (!mounted) return;

      // Close the loading dialog
      Navigator.of(context).pop();

      // Navigate to the home screen
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (context) => const HomeScreen(),
        ),
        (route) => false, // This removes all previous routes
      );
    } catch (e) {
      // Handle any errors
      debugPrint('Error in _finishOnboarding: $e');

      if (mounted) {
        // Try to navigate to home screen anyway
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (context) => const HomeScreen(),
          ),
          (route) => false,
        );

        // Show error message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('There was an error, but your data has been saved.'),
            backgroundColor: Colors.orange,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: _currentPage > 0
          ? IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.black),
              onPressed: _previousPage,
            )
          : null,
        actions: [
          TextButton(
            onPressed: () {
              _finishOnboarding();
            },
            child: Text(
              'Skip (${_currentPage + 1}/$_totalPages)',
              style: const TextStyle(
                color: AppColors.primaryColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Progress indicator
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: FadeAnimation(
              delay: 0.1,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: LinearProgressIndicator(
                  value: (_currentPage + 1) / _totalPages,
                  backgroundColor: AppColors.secondaryColor.withAlpha(76), // 0.3 * 255 = ~76
                  valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primaryColor),
                  minHeight: 8,
                ),
              ),
            ),
          ),

          // Page content
          Expanded(
            child: PageView(
              controller: _pageController,
              physics: const NeverScrollableScrollPhysics(),
              onPageChanged: (index) {
                setState(() {
                  _currentPage = index;
                });
                _animationController.reset();
                _animationController.forward();
              },
              children: [
                _buildPeriodLengthPage(),
                _buildCycleLengthPage(),
                _buildLastPeriodDatePage(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPeriodLengthPage() {
    return FadeTransition(
      opacity: _animationController,
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Icon
            FadeAnimation(
              delay: 0.2,
              child: Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: AppColors.primaryColor.withAlpha(25), // 0.1 * 255 = ~25
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.water_drop,
                  color: AppColors.primaryColor,
                  size: 40,
                ),
              ),
            ),

            const SizedBox(height: 32),

            // Question
            FadeAnimation(
              delay: 0.3,
              child: RichText(
                textAlign: TextAlign.center,
                text: const TextSpan(
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                  children: [
                    TextSpan(text: 'How many days does your '),
                    TextSpan(
                      text: 'period',
                      style: TextStyle(color: AppColors.primaryColor),
                    ),
                    TextSpan(text: ' usually last on average?'),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Description
            FadeAnimation(
              delay: 0.4,
              child: const Text(
                'Bleeding typically lasts 3–7 days. Enter yours for more accurate cycle predictions.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
            ),

            const SizedBox(height: 48),

            // Period length selector
            FadeAnimation(
              delay: 0.5,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [3, 4, 5, 6, 7].map((days) {
                  final isSelected = _periodLength == days;
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _periodLength = days;
                      });
                    },
                    child: Container(
                      width: 50,
                      height: 80,
                      decoration: BoxDecoration(
                        color: isSelected ? AppColors.primaryColor.withAlpha(25) : Colors.transparent, // 0.1 * 255 = ~25
                        borderRadius: BorderRadius.circular(16),
                        border: isSelected
                            ? Border.all(color: AppColors.primaryColor, width: 2)
                            : null,
                      ),
                      child: Center(
                        child: Text(
                          days.toString(),
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                            color: isSelected ? AppColors.primaryColor : Colors.grey,
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),

            const SizedBox(height: 8),

            // Label
            FadeAnimation(
              delay: 0.6,
              child: const Text(
                'Days',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryColor,
                ),
              ),
            ),

            const Spacer(),

            // Continue button
            FadeAnimation(
              delay: 0.7,
              child: SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(28),
                    ),
                  ),
                  onPressed: _nextPage,
                  child: const Text(
                    'Continue',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCycleLengthPage() {
    return FadeTransition(
      opacity: _animationController,
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Icon
            FadeAnimation(
              delay: 0.2,
              child: Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: AppColors.primaryColor.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.sync,
                  color: AppColors.primaryColor,
                  size: 40,
                ),
              ),
            ),

            const SizedBox(height: 32),

            // Question
            FadeAnimation(
              delay: 0.3,
              child: RichText(
                textAlign: TextAlign.center,
                text: const TextSpan(
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                  children: [
                    TextSpan(text: 'How many days does your '),
                    TextSpan(
                      text: 'cycle',
                      style: TextStyle(color: AppColors.primaryColor),
                    ),
                    TextSpan(text: ' usually last on average?'),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Description
            FadeAnimation(
              delay: 0.4,
              child: RichText(
                textAlign: TextAlign.center,
                text: const TextSpan(
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                  children: [
                    TextSpan(text: 'Cycle duration typically ranges from '),
                    TextSpan(
                      text: '21–35 days',
                      style: TextStyle(color: AppColors.primaryColor),
                    ),
                    TextSpan(text: '.'),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 48),

            // Cycle length selector
            FadeAnimation(
              delay: 0.5,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [26, 27, 28, 29, 30].map((days) {
                  final isSelected = _cycleLength == days;
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _cycleLength = days;
                      });
                    },
                    child: Container(
                      width: 50,
                      height: 80,
                      decoration: BoxDecoration(
                        color: isSelected ? AppColors.primaryColor.withOpacity(0.1) : Colors.transparent,
                        borderRadius: BorderRadius.circular(16),
                        border: isSelected
                            ? Border.all(color: AppColors.primaryColor, width: 2)
                            : null,
                      ),
                      child: Center(
                        child: Text(
                          days.toString(),
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                            color: isSelected ? AppColors.primaryColor : Colors.grey,
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),

            const SizedBox(height: 8),

            // Label
            FadeAnimation(
              delay: 0.6,
              child: const Text(
                'Days',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryColor,
                ),
              ),
            ),

            const Spacer(),

            // Continue button
            FadeAnimation(
              delay: 0.7,
              child: SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(28),
                    ),
                  ),
                  onPressed: _nextPage,
                  child: const Text(
                    'Continue',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLastPeriodDatePage() {
    return FadeTransition(
      opacity: _animationController,
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Icon
            FadeAnimation(
              delay: 0.2,
              child: Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: AppColors.primaryColor.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.sync,
                  color: AppColors.primaryColor,
                  size: 40,
                ),
              ),
            ),

            const SizedBox(height: 32),

            // Question
            FadeAnimation(
              delay: 0.3,
              child: RichText(
                textAlign: TextAlign.center,
                text: const TextSpan(
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                  children: [
                    TextSpan(text: 'What is the start date of your '),
                    TextSpan(
                      text: 'last period?',
                      style: TextStyle(color: AppColors.primaryColor),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 32),

            // Calendar
            FadeAnimation(
              delay: 0.4,
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.primaryColor.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    // Month selector
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.chevron_left),
                            onPressed: () {
                              setState(() {
                                _lastPeriodStartDate = DateTime(
                                  _lastPeriodStartDate.year,
                                  _lastPeriodStartDate.month - 1,
                                  _lastPeriodStartDate.day,
                                );
                              });
                            },
                          ),
                          Text(
                            DateFormat('MMMM').format(_lastPeriodStartDate),
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primaryColor,
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.chevron_right),
                            onPressed: () {
                              setState(() {
                                _lastPeriodStartDate = DateTime(
                                  _lastPeriodStartDate.year,
                                  _lastPeriodStartDate.month + 1,
                                  _lastPeriodStartDate.day,
                                );
                              });
                            },
                          ),
                        ],
                      ),
                    ),

                    // Calendar
                    TableCalendar(
                      firstDay: DateTime.now().subtract(const Duration(days: 365)),
                      lastDay: DateTime.now(),
                      focusedDay: _lastPeriodStartDate,
                      selectedDayPredicate: (day) {
                        return isSameDay(_lastPeriodStartDate, day);
                      },
                      onDaySelected: (selectedDay, focusedDay) {
                        setState(() {
                          _lastPeriodStartDate = selectedDay;
                        });
                      },
                      calendarStyle: CalendarStyle(
                        selectedDecoration: const BoxDecoration(
                          color: AppColors.primaryColor,
                          shape: BoxShape.circle,
                        ),
                        todayDecoration: BoxDecoration(
                          color: AppColors.primaryColor.withOpacity(0.3),
                          shape: BoxShape.circle,
                        ),
                        outsideDaysVisible: false,
                      ),
                      headerVisible: false,
                      calendarFormat: CalendarFormat.month,
                      daysOfWeekStyle: const DaysOfWeekStyle(
                        weekdayStyle: TextStyle(fontWeight: FontWeight.bold),
                        weekendStyle: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Period date guide
            FadeAnimation(
              delay: 0.5,
              child: TextButton.icon(
                onPressed: () {
                  // Show period date guide
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Period Date Guide'),
                      content: const Text(
                        'Select the first day of your most recent period. This helps us calculate your cycle accurately and provide personalized predictions.',
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Got it'),
                        ),
                      ],
                    ),
                  );
                },
                icon: const Icon(
                  Icons.info_outline,
                  color: AppColors.primaryColor,
                  size: 16,
                ),
                label: const Text(
                  'Period date guide',
                  style: TextStyle(
                    color: AppColors.primaryColor,
                  ),
                ),
              ),
            ),

            const Spacer(),

            // Continue button
            FadeAnimation(
              delay: 0.7,
              child: SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(28),
                    ),
                  ),
                  onPressed: _finishOnboarding,
                  child: const Text(
                    'Continue',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  bool isSameDay(DateTime? a, DateTime? b) {
    if (a == null || b == null) {
      return false;
    }
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }
}
