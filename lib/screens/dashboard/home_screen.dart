import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pregnancy_health_tracker/constants/colors.dart';
import 'package:pregnancy_health_tracker/constants/styles.dart';
import 'package:pregnancy_health_tracker/models/education_content.dart';
import 'package:pregnancy_health_tracker/models/forum_models.dart';
import 'package:pregnancy_health_tracker/screens/education/education_category_screen.dart';
import 'package:pregnancy_health_tracker/screens/forum/all_posts_screen.dart';
import 'package:pregnancy_health_tracker/screens/forum/category_posts_screen.dart';
import 'package:pregnancy_health_tracker/screens/forum/create_post_screen.dart';
import 'package:pregnancy_health_tracker/screens/forum/post_detail_screen.dart';
import 'package:pregnancy_health_tracker/screens/onboarding/cycle_onboarding_screen.dart';
import 'package:pregnancy_health_tracker/screens/profile/profile_screen.dart';
import 'package:pregnancy_health_tracker/services/auth_service.dart';
import 'package:pregnancy_health_tracker/services/cycle_service.dart';
import 'package:pregnancy_health_tracker/services/forum_service.dart';
import 'package:pregnancy_health_tracker/utils/fade_animation.dart';
import 'package:pregnancy_health_tracker/widgets/cycle_calendar.dart';
import 'package:pregnancy_health_tracker/widgets/forum_post_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  int _selectedIndex = 0;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  final List<Widget> _screens = [
    const DashboardTab(),
    const CalendarTab(),
    const EducationTab(),
    const ForumTab(),
    const ProfileTab(),
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );

    _animationController.forward();

    // Check if onboarding is completed
    _checkOnboardingStatus();
  }

  Future<void> _checkOnboardingStatus() async {
    try {
      final authService = AuthService();
      final isOnboardingCompleted = await authService.isOnboardingCompleted();

      if (!isOnboardingCompleted && mounted) {
        // Navigate to onboarding screen
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (context) => const CycleOnboardingScreen(),
          ),
          (route) => false, // Remove all previous routes
        );
      }
    } catch (e) {
      // Log the error but don't block the user from using the app
      debugPrint('Error checking onboarding status: $e');
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: _screens[_selectedIndex],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          if (_selectedIndex != index) {
            _animationController.reset();
            setState(() {
              _selectedIndex = index;
            });
            _animationController.forward();
          }
        },
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: AppColors.primaryColor,
        unselectedItemColor: AppColors.textLight,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today_outlined),
            activeIcon: Icon(Icons.calendar_today),
            label: 'Calendar',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.menu_book_outlined),
            activeIcon: Icon(Icons.menu_book),
            label: 'Learn',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.forum_outlined),
            activeIcon: Icon(Icons.forum),
            label: 'Forum',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

class DashboardTab extends StatefulWidget {
  const DashboardTab({super.key});

  @override
  State<DashboardTab> createState() => _DashboardTabState();
}

class _DashboardTabState extends State<DashboardTab> with SingleTickerProviderStateMixin {
  final CycleService _cycleService = CycleService();
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FadeAnimation(
              delay: 0.2,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 18,
                        backgroundColor: AppColors.primaryColor,
                        child: const Text(
                          'AN',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Hello, Anish!',
                        style: AppStyles.greeting,
                      ),
                    ],
                  ),
                  IconButton(
                    icon: const Icon(Icons.notifications_outlined),
                    onPressed: () {},
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            FadeAnimation(
              delay: 0.3,
              child: const Text(
                'Your Health Summary',
                style: AppStyles.headingSmall,
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    FadeAnimation(
                      delay: 0.4,
                      child: _buildSummaryCard(),
                    ),
                    const SizedBox(height: 24),
                    FadeAnimation(
                      delay: 0.5,
                      child: _buildUpcomingCard(),
                    ),
                    const SizedBox(height: 24),
                    FadeAnimation(
                      delay: 0.6,
                      child: _buildTipsCard(),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryCard() {
    final currentCycle = _cycleService.getCurrentCycle();
    final nextPeriodDate = _cycleService.getNextPeriodDate();
    final cycleLength = _cycleService.getAverageCycleLength();

    // Calculate current cycle day
    int cycleDay = 0;
    if (currentCycle != null) {
      cycleDay = DateTime.now().difference(currentCycle.startDate).inDays + 1;
    }

    // Calculate progress for progress bar
    double progress = cycleDay / cycleLength;
    if (progress > 1.0) progress = 1.0;
    if (progress < 0.0) progress = 0.0;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: AppStyles.gradientCardDecoration,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.calendar_today,
                color: Colors.white,
              ),
              const SizedBox(width: 8),
              Text(
                'Cycle Day $cycleDay',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Column(
                children: [
                  const Text(
                    'Last Period',
                    style: TextStyle(
                      color: Colors.white70,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    currentCycle != null
                        ? '${currentCycle.startDate.month}/${currentCycle.startDate.day}'
                        : 'N/A',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              Column(
                children: [
                  const Text(
                    'Cycle Length',
                    style: TextStyle(
                      color: Colors.white70,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '$cycleLength days',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              Column(
                children: [
                  const Text(
                    'Next Period',
                    style: TextStyle(
                      color: Colors.white70,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    nextPeriodDate != null
                        ? '${nextPeriodDate.month}/${nextPeriodDate.day}'
                        : 'N/A',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: progress,
              backgroundColor: Colors.white.withAlpha(70),
              valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
              minHeight: 8,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUpcomingCard() {
    final currentCycle = _cycleService.getCurrentCycle();
    final nextPeriodDate = _cycleService.getNextPeriodDate();

    // Get ovulation date if available
    DateTime? ovulationDate;
    if (currentCycle != null) {
      ovulationDate = currentCycle.getOvulationDate();
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: AppStyles.cardDecoration,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Row(
                children: [
                  Icon(
                    Icons.event_note,
                    color: AppColors.primaryColor,
                  ),
                  SizedBox(width: 8),
                  Text(
                    'Upcoming',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.primaryColor.withAlpha(30),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Row(
                  children: [
                    Icon(
                      Icons.calendar_month,
                      size: 16,
                      color: AppColors.primaryColor,
                    ),
                    SizedBox(width: 4),
                    Text(
                      'View All',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryColor,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (nextPeriodDate != null)
            _buildUpcomingItem(
              icon: Icons.water_drop,
              title: 'Next Period',
              subtitle: DateFormat('MMMM d').format(nextPeriodDate),
              daysLeft: nextPeriodDate.difference(DateTime.now()).inDays,
              color: AppColors.periodColor,
            ),
          if (nextPeriodDate != null)
            const Divider(height: 24),
          if (ovulationDate != null)
            _buildUpcomingItem(
              icon: Icons.egg_alt,
              title: 'Ovulation Day',
              subtitle: DateFormat('MMMM d').format(ovulationDate),
              daysLeft: ovulationDate.difference(DateTime.now()).inDays,
              color: AppColors.ovulationColor,
            ),
        ],
      ),
    );
  }

  Widget _buildUpcomingItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    int? daysLeft,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4.0),
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      decoration: BoxDecoration(
        color: color.withAlpha(10),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: color.withAlpha(30),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withAlpha(30),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: color,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          if (daysLeft != null && daysLeft > 0)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: color.withAlpha(30),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                'In $daysLeft days',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            )
          else if (daysLeft != null && daysLeft == 0)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: color.withAlpha(30),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                'Today',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            )
          else if (daysLeft != null && daysLeft < 0)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.grey.withAlpha(30),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Text(
                'Past',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildTipsCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: AppColors.blueGradient,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20.0),
        boxShadow: [
          BoxShadow(
            color: AppColors.tertiaryColor.withAlpha(40),
            blurRadius: 15,
            spreadRadius: 1,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(
                Icons.lightbulb_outline,
                color: Colors.white,
              ),
              SizedBox(width: 8),
              Text(
                'Health Tips',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Text(
            'Stay hydrated! Drinking enough water can help reduce bloating and cramps during your period.',
            style: TextStyle(
              color: Colors.white,
              fontSize: 15,
            ),
          ),
          const SizedBox(height: 12),
          Container(
            decoration: BoxDecoration(
              color: Colors.white.withAlpha(30),
              borderRadius: BorderRadius.circular(20),
            ),
            child: TextButton.icon(
              onPressed: () {},
              icon: const Icon(
                Icons.arrow_forward,
                color: Colors.white,
                size: 16,
              ),
              label: const Text(
                'Read More Tips',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CalendarTab extends StatefulWidget {
  const CalendarTab({super.key});

  @override
  State<CalendarTab> createState() => _CalendarTabState();
}

class _CalendarTabState extends State<CalendarTab> with SingleTickerProviderStateMixin {
  DateTime? _selectedDay;
  final CycleService _cycleService = CycleService();
  Map<DateTime, List<CycleEvent>> _events = {};
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _loadEvents();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _loadEvents() {
    setState(() {
      _events = _cycleService.getAllCalendarEvents();
    });
  }

  // Calculate weeks indicator based on next period date
  String _getWeeksIndicator() {
    final nextPeriodDate = _cycleService.getNextPeriodDate();
    if (nextPeriodDate == null) return '';

    final today = DateTime.now();
    final difference = nextPeriodDate.difference(today).inDays;

    if (difference <= 0) return 'Today';
    if (difference < 7) return '$difference days';

    final weeks = (difference / 7).floor();
    return '$weeks weeks';
  }

  void _onDaySelected(DateTime day) {
    setState(() {
      _selectedDay = day;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          FadeAnimation(
            delay: 0.2,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'My Cycle',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.add, size: 20),
                    onPressed: () {
                      _showAddDialog(context);
                    },
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Column(
                children: [
                  FadeAnimation(
                    delay: 0.4,
                    child: Container(
                      decoration: AppStyles.calendarCardDecoration,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: CycleCalendar(
                          selectedDay: _selectedDay,
                          onDaySelected: _onDaySelected,
                          events: _events,
                          weeksIndicator: _getWeeksIndicator(),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: FadeAnimation(
                      delay: 0.6,
                      child: _buildEventList(),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEventList() {
    if (_selectedDay == null) {
      return Container(
        width: double.infinity,
        margin: const EdgeInsets.symmetric(horizontal: 2),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(5),
              blurRadius: 10,
              spreadRadius: 0,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 40),
            Icon(
              Icons.calendar_today,
              size: 40,
              color: AppColors.primaryColor.withAlpha(100),
            ),
            const SizedBox(height: 16),
            const Text(
              'Select a day to view events',
              style: TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w400,
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      );
    }

    final eventsForDay = _getEventsForDay(_selectedDay!);

    if (eventsForDay.isEmpty) {
      return Container(
        width: double.infinity,
        margin: const EdgeInsets.symmetric(horizontal: 2),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(5),
              blurRadius: 10,
              spreadRadius: 0,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 40),
            Icon(
              Icons.event_busy,
              size: 40,
              color: AppColors.secondaryColor.withAlpha(100),
            ),
            const SizedBox(height: 16),
            Text(
              'No events for ${DateFormat('MMMM d').format(_selectedDay!)}',
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w400,
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              onPressed: () {
                _showAddDialog(context);
              },
              icon: const Icon(Icons.add, size: 14),
              label: const Text('Add Event', style: TextStyle(fontSize: 12)),
            ),
            const SizedBox(height: 40),
          ],
        ),
      );
    }

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 2),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(5),
            blurRadius: 10,
            spreadRadius: 0,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Events for ${DateFormat('MMMM d').format(_selectedDay!)}',
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 14,
                color: AppColors.primaryColor,
              ),
            ),
          ),
          const Divider(height: 1, thickness: 0.5),
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.zero,
              itemCount: eventsForDay.length,
              itemBuilder: (context, index) {
                final event = eventsForDay[index];
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                  decoration: BoxDecoration(
                    color: event.color.withAlpha(20),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    leading: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: event.color.withAlpha(50),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        _getIconForEventType(event.type),
                        color: event.color,
                        size: 24,
                      ),
                    ),
                    title: Text(
                      event.title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(event.description),
                    onTap: () {
                      _showEventDetailsDialog(context, event);
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  List<CycleEvent> _getEventsForDay(DateTime day) {
    // Find events for the selected day
    for (final eventDay in _events.keys) {
      if (isSameDay(eventDay, day)) {
        return _events[eventDay] ?? [];
      }
    }
    return [];
  }

  bool isSameDay(DateTime? a, DateTime? b) {
    if (a == null || b == null) {
      return false;
    }
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  IconData _getIconForEventType(CycleEventType type) {
    switch (type) {
      case CycleEventType.period:
        return Icons.water_drop;
      case CycleEventType.ovulation:
        return Icons.egg_alt;
      case CycleEventType.fertile:
        return Icons.favorite;
      case CycleEventType.symptom:
        return Icons.healing;
      case CycleEventType.note:
        return Icons.note;
      case CycleEventType.mood:
        return Icons.emoji_emotions;
    }
  }

  // Event details dialog has been removed as per user request
  void _showEventDetailsDialog(BuildContext context, CycleEvent event) {
    // Do nothing - dialog has been removed
    // This prevents the dialog from appearing when clicking on events
  }

  void _showAddDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add New Entry'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ElevatedButton(
              style: AppStyles.primaryButtonStyle,
              onPressed: () {
                Navigator.of(context).pop();
                _showAddPeriodDialog(context);
              },
              child: const Text('Log Period'),
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              style: AppStyles.primaryButtonStyle,
              onPressed: () {
                Navigator.of(context).pop();
                _showAddSymptomDialog(context);
              },
              child: const Text('Log Symptom'),
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              style: AppStyles.primaryButtonStyle,
              onPressed: () {
                Navigator.of(context).pop();
                _showAddNoteDialog(context);
              },
              child: const Text('Add Note'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  void _showAddPeriodDialog(BuildContext context) {
    // This would be implemented to add a new period
    // For now, just show a message
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Period logging will be implemented in the next update'),
      ),
    );
  }

  void _showAddSymptomDialog(BuildContext context) {
    // This would be implemented to add a new symptom
    // For now, just show a message
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Symptom logging will be implemented in the next update'),
      ),
    );
  }

  void _showAddNoteDialog(BuildContext context) {
    // This would be implemented to add a new note
    // For now, just show a message
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Note adding will be implemented in the next update'),
      ),
    );
  }
}

class EducationTab extends StatefulWidget {
  const EducationTab({super.key});

  @override
  State<EducationTab> createState() => _EducationTabState();
}

class _EducationTabState extends State<EducationTab> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    _animationController.forward();
    _searchController.addListener(_onSearchChanged);
  }

  void _onSearchChanged() {
    setState(() {
      _searchQuery = _searchController.text.toLowerCase();
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 8),
              child: FadeAnimation(
                delay: 0.1,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Educational Content',
                      style: AppStyles.headingMedium,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Learn about menstrual health, fertility, pregnancy, and more',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Search bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: FadeAnimation(
                delay: 0.2,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withAlpha(13),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'Search for topics...',
                      hintStyle: TextStyle(color: Colors.grey[400]),
                      prefixIcon: Icon(Icons.search, color: Colors.grey[400]),
                      suffixIcon: _searchQuery.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.clear, color: Colors.grey),
                              onPressed: () {
                                _searchController.clear();
                              },
                            )
                          : null,
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(vertical: 15),
                    ),
                  ),
                ),
              ),
            ),

            // Categories
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 8, 24, 16),
              child: FadeAnimation(
                delay: 0.3,
                child: const Text(
                  'Categories',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
            ),

            // Category grid
            Expanded(
              child: _buildCategoryGrid(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryGrid() {
    // Filter categories based on search query
    final filteredCategories = _searchQuery.isEmpty
        ? educationCategories
        : educationCategories.where((category) {
            return category.title.toLowerCase().contains(_searchQuery) ||
                category.description.toLowerCase().contains(_searchQuery) ||
                category.items.any((item) =>
                    item.title.toLowerCase().contains(_searchQuery) ||
                    item.summary.toLowerCase().contains(_searchQuery) ||
                    item.tags.any((tag) => tag.toLowerCase().contains(_searchQuery)));
          }).toList();

    if (filteredCategories.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search_off,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              'No results found for "$_searchQuery"',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Try a different search term',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[500],
              ),
            ),
          ],
        ),
      );
    }

    return GridView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.8,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: filteredCategories.length,
      itemBuilder: (context, index) {
        final category = filteredCategories[index];
        return FadeAnimation(
          delay: 0.4 + (index * 0.1),
          child: GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EducationCategoryScreen(category: category),
                ),
              );
            },
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withAlpha(13),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Category icon
                  Container(
                    height: 100,
                    decoration: BoxDecoration(
                      color: category.color.withAlpha(25),
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      ),
                    ),
                    child: Center(
                      child: Icon(
                        category.icon,
                        size: 48,
                        color: category.color,
                      ),
                    ),
                  ),

                  // Category details
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            category.title,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            category.description,
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const Spacer(),
                          Row(
                            children: [
                              Text(
                                '${category.items.length} articles',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: category.color,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const Spacer(),
                              Icon(
                                Icons.arrow_forward,
                                size: 16,
                                color: category.color,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class ForumTab extends StatefulWidget {
  const ForumTab({super.key});

  @override
  State<ForumTab> createState() => _ForumTabState();
}

class _ForumTabState extends State<ForumTab> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  final ForumService _forumService = ForumService();
  List<ForumPost> _posts = [];
  bool _isLoading = true;
  final TextEditingController _postController = TextEditingController();
  bool _isSubmittingPost = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    _animationController.forward();
    _loadPosts();
  }

  void _loadPosts() {
    setState(() {
      _isLoading = true;
    });

    // Simulate network delay
    Future.delayed(const Duration(milliseconds: 500), () {
      setState(() {
        _posts = _forumService.getAllPosts();
        _isLoading = false;
      });
    });
  }

  void _createQuickPost() {
    if (_postController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter something to post'),
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    setState(() {
      _isSubmittingPost = true;
    });

    // Simulate network delay
    Future.delayed(const Duration(seconds: 1), () {
      if (!mounted) return;

      try {
        final newPost = _forumService.createPost(
          title: 'Post by ${_forumService.currentUserName}',
          content: _postController.text.trim(),
          categoryId: 'general', // Default to general category for quick posts
        );

        setState(() {
          _isSubmittingPost = false;
          _postController.clear();
          _posts.insert(0, newPost); // Add new post to the top of the feed
        });

        // Show success message
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Post created successfully!'),
              duration: Duration(seconds: 2),
            ),
          );
        }
      } catch (e) {
        setState(() {
          _isSubmittingPost = false;
        });

        // Show error message
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error creating post: ${e.toString()}'),
              duration: const Duration(seconds: 2),
            ),
          );
        }
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    _postController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 8),
              child: FadeAnimation(
                delay: 0.1,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Community Feed',
                      style: AppStyles.headingMedium,
                    ),
                    IconButton(
                      icon: const Icon(Icons.filter_list, color: AppColors.primaryColor),
                      onPressed: () {
                        // Show categories in a bottom sheet
                        showModalBottomSheet(
                          context: context,
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                          ),
                          builder: (context) => _buildCategoriesBottomSheet(),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),

            // Create post card
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: FadeAnimation(
                delay: 0.2,
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withAlpha(13),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      // User input row
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 20,
                            backgroundColor: Colors.grey[300],
                            child: Text(
                              _forumService.currentUserName.substring(0, 1),
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: TextField(
                              controller: _postController,
                              decoration: InputDecoration(
                                hintText: 'What\'s on your mind?',
                                hintStyle: TextStyle(color: Colors.grey[400]),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30),
                                  borderSide: BorderSide.none,
                                ),
                                filled: true,
                                fillColor: Colors.grey[100],
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 12,
                                ),
                              ),
                              minLines: 1,
                              maxLines: 3,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Action buttons
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Create detailed post button
                          TextButton.icon(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const CreatePostScreen(),
                                ),
                              ).then((_) => _loadPosts());
                            },
                            icon: const Icon(Icons.add_circle_outline, size: 18),
                            label: const Text('Create Post'),
                            style: TextButton.styleFrom(
                              foregroundColor: Colors.grey[700],
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            ),
                          ),

                          // Post button
                          ElevatedButton(
                            onPressed: _isSubmittingPost ? null : _createQuickPost,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primaryColor,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                              disabledBackgroundColor: AppColors.primaryColor.withAlpha(150),
                            ),
                            child: _isSubmittingPost
                                ? const SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                    ),
                                  )
                                : const Text('Post'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Posts feed
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _posts.isEmpty
                      ? _buildEmptyState()
                      : _buildPostsFeed(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.forum_outlined,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'No posts yet',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Be the first to start a discussion!',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[500],
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const CreatePostScreen(),
                ),
              ).then((_) => _loadPosts());
            },
            icon: const Icon(Icons.add),
            label: const Text('Create Post'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryColor,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPostsFeed() {
    return RefreshIndicator(
      onRefresh: () async {
        _loadPosts();
      },
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _posts.length,
        itemBuilder: (context, index) {
          final post = _posts[index];
          return FadeAnimation(
            delay: 0.05 * index,
            child: ForumPostCard(
              post: post,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PostDetailScreen(postId: post.id),
                  ),
                ).then((_) => _loadPosts()); // Refresh posts when returning
              },
              showReactions: true,
              onLike: () {
                setState(() {
                  _forumService.addReactionToPost(
                    postId: post.id,
                    type: ReactionType.like,
                  );
                  _loadPosts(); // Reload to get updated reactions
                });
              },
              onComment: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PostDetailScreen(postId: post.id),
                  ),
                ).then((_) => _loadPosts()); // Refresh posts when returning
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildCategoriesBottomSheet() {
    final categories = _forumService.getAllCategories();

    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Categories',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: categories.map((category) {
              return GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CategoryPostsScreen(category: category),
                    ),
                  ).then((_) => _loadPosts());
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: category.color.withAlpha(25),
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(
                      color: category.color.withAlpha(75),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        category.icon,
                        color: category.color,
                        size: 18,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        category.title,
                        style: TextStyle(
                          color: category.color,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 24),
          Center(
            child: TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AllPostsScreen(),
                  ),
                ).then((_) => _loadPosts());
              },
              style: TextButton.styleFrom(
                foregroundColor: AppColors.primaryColor,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
              child: const Text('View All Posts'),
            ),
          ),
        ],
      ),
    );
  }
}

class ProfileTab extends StatefulWidget {
  const ProfileTab({super.key});

  @override
  State<ProfileTab> createState() => _ProfileTabState();
}

class _ProfileTabState extends State<ProfileTab> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Import the ProfileScreen from the profile folder
    return const ProfileScreen();
  }
}
