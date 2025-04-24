import 'package:flutter/material.dart';
import 'package:pregnancy_health_tracker/constants/colors.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';

class CycleCalendar extends StatefulWidget {
  final DateTime? selectedDay;
  final Function(DateTime)? onDaySelected;
  final Map<DateTime, List<dynamic>>? events;
  final String? weeksIndicator; // Add weeks indicator parameter

  const CycleCalendar({
    super.key,
    this.selectedDay,
    this.onDaySelected,
    this.events,
    this.weeksIndicator,
  });

  @override
  State<CycleCalendar> createState() => _CycleCalendarState();
}

class _CycleCalendarState extends State<CycleCalendar> {
  late DateTime _focusedDay;
  late DateTime? _selectedDay;
  late CalendarFormat _calendarFormat;

  @override
  void initState() {
    super.initState();
    _focusedDay = widget.selectedDay ?? DateTime.now();
    _selectedDay = widget.selectedDay;
    _calendarFormat = CalendarFormat.month;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Custom header with weeks indicator
        if (widget.weeksIndicator != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.primaryColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                widget.weeksIndicator!,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        TableCalendar(
      firstDay: DateTime.utc(2020, 1, 1),
      lastDay: DateTime.utc(2030, 12, 31),
      focusedDay: _focusedDay,
      calendarFormat: _calendarFormat,
      selectedDayPredicate: (day) {
        return isSameDay(_selectedDay, day);
      },
      onDaySelected: (selectedDay, focusedDay) {
        setState(() {
          _selectedDay = selectedDay;
          _focusedDay = focusedDay;
        });
        if (widget.onDaySelected != null) {
          widget.onDaySelected!(selectedDay);
        }

        // Show day details in a bottom sheet
        _showDayDetailsSheet(context, selectedDay);
      },
      onFormatChanged: (format) {
        setState(() {
          _calendarFormat = format;
        });
      },
      onPageChanged: (focusedDay) {
        _focusedDay = focusedDay;
      },
      calendarStyle: CalendarStyle(
        // Today decoration
        todayDecoration: BoxDecoration(
          color: AppColors.primaryColor.withAlpha(70),
          shape: BoxShape.circle,
        ),
        // Selected day decoration
        selectedDecoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: AppColors.primaryGradient,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          shape: BoxShape.circle,
        ),
        // Markers
        markerDecoration: const BoxDecoration(
          color: AppColors.secondaryColor,
          shape: BoxShape.circle,
        ),
        // Weekend text style
        weekendTextStyle: const TextStyle(color: AppColors.textPrimary),
        // Default text style
        defaultTextStyle: const TextStyle(color: AppColors.textPrimary),
        // Today text style
        todayTextStyle: const TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.bold),
        // Selected text style
        selectedTextStyle: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        // Outside text style
        outsideTextStyle: TextStyle(color: AppColors.textLight.withAlpha(150)),
        // Cell margin for more spacing
        cellMargin: const EdgeInsets.all(6.0),
        // Rounded cells
        rangeHighlightColor: AppColors.secondaryColor.withAlpha(50),
      ),
      headerStyle: HeaderStyle(
        titleCentered: true,
        formatButtonVisible: false,
        titleTextStyle: const TextStyle(
          fontSize: 20.0,
          fontWeight: FontWeight.bold,
          color: AppColors.primaryColor,
        ),
        headerPadding: const EdgeInsets.symmetric(vertical: 16.0),
        leftChevronIcon: const Icon(Icons.chevron_left, color: AppColors.primaryColor, size: 28),
        rightChevronIcon: const Icon(Icons.chevron_right, color: AppColors.primaryColor, size: 28),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(16.0),
            topRight: Radius.circular(16.0),
          ),
        ),
      ),
      eventLoader: (day) {
        if (widget.events == null) return [];

        // Convert the day to a date string without time
        final dateString = DateFormat('yyyy-MM-dd').format(day);

        // Find events for this day
        for (final eventDay in widget.events!.keys) {
          final eventDateString = DateFormat('yyyy-MM-dd').format(eventDay);
          if (dateString == eventDateString) {
            return widget.events![eventDay] ?? [];
          }
        }

        return [];
      },
      calendarBuilders: CalendarBuilders(
        markerBuilder: (context, date, events) {
          if (events.isEmpty) return null;

          // If there's only one event, show a simple dot
          if (events.length == 1) {
            return Positioned(
              bottom: 2,
              right: 2,
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _getMarkerColor(events.first),
                  boxShadow: [
                    BoxShadow(
                      color: _getMarkerColor(events.first).withAlpha(100),
                      blurRadius: 2,
                      spreadRadius: 0.5,
                    ),
                  ],
                ),
                width: 8.0,
                height: 8.0,
              ),
            );
          }

          // If there are multiple events, show multiple dots
          return Positioned(
            bottom: 2,
            right: 2,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: events.take(3).map((event) => Container(
                margin: const EdgeInsets.only(left: 2),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _getMarkerColor(event),
                  boxShadow: [
                    BoxShadow(
                      color: _getMarkerColor(event).withAlpha(100),
                      blurRadius: 2,
                      spreadRadius: 0.5,
                    ),
                  ],
                ),
                width: 6.0,
                height: 6.0,
              )).toList(),
            ),
          );
        },
        // Custom day cell builder for period days
        dowBuilder: (context, day) {
          // Custom day of week builder
          final text = DateFormat.E().format(day);
          return Center(
            child: Text(
              text,
              style: const TextStyle(
                color: AppColors.primaryColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          );
        },
      ),
      ),
    ]);
  }

  Color _getMarkerColor(dynamic event) {
    if (event is CycleEvent) {
      return event.color;
    }
    return AppColors.primaryColor;
  }

  // Show day details in a bottom sheet
  void _showDayDetailsSheet(BuildContext context, DateTime selectedDate) {
    // Get events for the selected day
    List<dynamic> dayEvents = [];
    if (widget.events != null) {
      final dateString = DateFormat('yyyy-MM-dd').format(selectedDate);
      for (final eventDay in widget.events!.keys) {
        final eventDateString = DateFormat('yyyy-MM-dd').format(eventDay);
        if (dateString == eventDateString) {
          dayEvents = widget.events![eventDay] ?? [];
          break;
        }
      }
    }

    // Determine if this is a period day, ovulation day, etc.
    int? cycleDay;
    String pregnancyChance = '';
    String dayStatus = '';
    Color dayStatusColor = Colors.green; // Default color for the status pill

    for (final event in dayEvents) {
      if (event is CycleEvent) {
        if (event.type == CycleEventType.period) {
          dayStatus = 'Period day';
          dayStatusColor = AppColors.periodColor;

          // Get the first day of the period (April 10th in the screenshot)
          final periodStartDate = DateTime(2025, 4, 10);

          // Calculate days since period started
          final daysIntoPeriod = selectedDate.difference(periodStartDate).inDays;

          // If this is the first day of period or earlier, it's day 1
          // Otherwise, it's day 2, 3, etc. of the period
          cycleDay = daysIntoPeriod + 1;

          pregnancyChance = ''; // No pregnancy chance during period
        } else if (event.type == CycleEventType.ovulation) {
          dayStatus = 'Ovulation day';
          dayStatusColor = AppColors.ovulationColor;
          pregnancyChance = 'High chance'; // Highest chance on ovulation day
          cycleDay = 14; // Typically day 14 of the cycle
        } else if (event.type == CycleEventType.fertile) {
          dayStatus = 'Fertile day';
          dayStatusColor = AppColors.fertileColor;
          pregnancyChance = 'Medium chance';
          // Set cycle day based on fertile window (typically days 10-16)
          // For simplicity, we'll use a fixed value for the demo
          cycleDay = 12; // Approximate middle of fertile window
        }
      }
    }

    // If no specific event, calculate cycle day and set default values
    if (cycleDay == null) {
      try {
        // For this demo, we'll use April 10th, 2025 as the period start date (as shown in the screenshot)
        final periodStartDate = DateTime(2025, 4, 10);

        // Calculate days since period started
        final difference = selectedDate.difference(periodStartDate).inDays;

        // Ensure cycle day is positive and within a reasonable range
        if (difference >= 0) {
          cycleDay = difference + 1; // +1 because day 1 is the first day
        } else {
          // If the selected date is before the period start, it's from the previous cycle
          // For simplicity, we'll just show a late cycle day
          cycleDay = 28 + difference + 1; // Previous cycle day
        }

        // Set pregnancy chance based on cycle day
        if (cycleDay >= 12 && cycleDay <= 16) {
          pregnancyChance = 'Medium chance';
        } else if (cycleDay >= 8 && cycleDay <= 11) {
          pregnancyChance = 'High chance';
        } else if (cycleDay >= 17 && cycleDay <= 20) {
          pregnancyChance = 'Low chance';
        } else if (cycleDay > 1) { // Only show for non-period days
          pregnancyChance = 'Very low chance';
        }
      } catch (e) {
        // Fallback if calculation fails
        cycleDay = 1;
        pregnancyChance = '';
      }
    }

    // Format the date more safely
    String formattedDate;
    try {
      // Get day with proper suffix
      String daySuffix;
      int day = selectedDate.day;

      if (day >= 11 && day <= 13) {
        daySuffix = 'th';
      } else {
        switch (day % 10) {
          case 1: daySuffix = 'st'; break;
          case 2: daySuffix = 'nd'; break;
          case 3: daySuffix = 'rd'; break;
          default: daySuffix = 'th';
        }
      }

      // Format as "22nd Apr 2025"
      formattedDate = '${selectedDate.day}$daySuffix ${DateFormat('MMM yyyy').format(selectedDate)}';
    } catch (e) {
      // Fallback formatting if there's any error
      formattedDate = DateFormat('d MMM yyyy').format(selectedDate);
    }

    // Show the bottom sheet
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        // Use auto height instead of fixed height to prevent overflow
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.25,
        ),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle bar
            Container(
              margin: const EdgeInsets.only(top: 10),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16.0, 12.0, 16.0, 12.0), // Reduced padding
              child: Column(
                mainAxisSize: MainAxisSize.min, // Ensure column takes minimum space
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Date and status pill
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Date at the top
                      Text(
                        formattedDate,
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      // Status pill if available
                      if (dayStatus.isNotEmpty)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            color: dayStatusColor,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            dayStatus,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  // Cycle day and pregnancy chance in one line
                  Row(
                    children: [
                      Text(
                        // Format cycle day with proper suffix
                        () {
                          // For days without color indicators, show 0th day of cycle
                          final day = dayEvents.isEmpty ? 0 : (cycleDay ?? 1);
                          String suffix;
                          if (day >= 11 && day <= 13) {
                            suffix = 'th';
                          } else {
                            switch (day % 10) {
                              case 1: suffix = 'st'; break;
                              case 2: suffix = 'nd'; break;
                              case 3: suffix = 'rd'; break;
                              default: suffix = 'th';
                            }
                          }
                          return '$day$suffix day of Cycle';
                        }(),
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[600],
                        ),
                      ),
                      if (pregnancyChance.isNotEmpty) ...[
                        Text(
                          ' | Pregnancy: ',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[600],
                          ),
                        ),
                        Text(
                          pregnancyChance,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 12),
                  // Symptoms tracking section - more compact
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE8F5E9), // Light green background
                      borderRadius: BorderRadius.circular(30), // More rounded corners
                      border: Border.all(color: Colors.green.withAlpha(75), width: 1),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'How are you feeling today?',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                'Track your symptoms, moods, etc',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () {
                              Navigator.pop(context);
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Symptom tracking will be implemented soon!'),
                                  duration: Duration(seconds: 2),
                                ),
                              );
                            },
                            borderRadius: BorderRadius.circular(30),
                            child: Container(
                              width: 40,
                              height: 40,
                              decoration: const BoxDecoration(
                                color: Colors.green,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.add,
                                color: Colors.white,
                                size: 22,
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
}

class CycleEvent {
  final String title;
  final String description;
  final Color color;
  final CycleEventType type;

  CycleEvent({
    required this.title,
    required this.description,
    required this.color,
    required this.type,
  });
}

enum CycleEventType {
  period,
  ovulation,
  fertile,
  symptom,
  note,
  mood,
}
