import 'package:flutter/material.dart';
import 'package:pregnancy_health_tracker/constants/colors.dart';
import 'package:pregnancy_health_tracker/models/cycle_data.dart';
import 'package:pregnancy_health_tracker/widgets/cycle_calendar.dart';

// This is a placeholder service that will be implemented with a real database later
class CycleService {
  // Singleton pattern
  static final CycleService _instance = CycleService._internal();
  factory CycleService() => _instance;
  CycleService._internal();

  // Mock data for testing
  final List<CycleData> _cycles = [
    CycleData(
      startDate: DateTime.now().subtract(const Duration(days: 14)),
      cycleLength: 28,
      periodLength: 5,
      symptoms: [
        CycleSymptom(
          date: DateTime.now().subtract(const Duration(days: 14)),
          type: SymptomType.cramps,
          severity: 3,
          notes: 'Moderate cramps in the morning',
        ),
        CycleSymptom(
          date: DateTime.now().subtract(const Duration(days: 13)),
          type: SymptomType.headache,
          severity: 2,
          notes: 'Mild headache in the afternoon',
        ),
        CycleSymptom(
          date: DateTime.now().subtract(const Duration(days: 12)),
          type: SymptomType.bloating,
          severity: 4,
          notes: 'Significant bloating all day',
        ),
      ],
      notes: [
        CycleNote(
          date: DateTime.now().subtract(const Duration(days: 14)),
          text: 'Started period. Feeling tired.',
        ),
        CycleNote(
          date: DateTime.now().subtract(const Duration(days: 10)),
          text: 'Period ending. Feeling better.',
        ),
      ],
    ),
    CycleData(
      startDate: DateTime.now().subtract(const Duration(days: 42)),
      endDate: DateTime.now().subtract(const Duration(days: 38)),
      cycleLength: 28,
      periodLength: 5,
      symptoms: [
        CycleSymptom(
          date: DateTime.now().subtract(const Duration(days: 42)),
          type: SymptomType.cramps,
          severity: 4,
          notes: 'Severe cramps in the morning',
        ),
        CycleSymptom(
          date: DateTime.now().subtract(const Duration(days: 41)),
          type: SymptomType.fatigue,
          severity: 3,
          notes: 'Very tired all day',
        ),
      ],
      notes: [
        CycleNote(
          date: DateTime.now().subtract(const Duration(days: 42)),
          text: 'Started period. Heavy flow.',
        ),
      ],
    ),
  ];

  // Get all cycles
  List<CycleData> getAllCycles() {
    return _cycles;
  }

  // Get the current or most recent cycle
  CycleData? getCurrentCycle() {
    if (_cycles.isEmpty) return null;

    // Sort cycles by start date (most recent first)
    final sortedCycles = List<CycleData>.from(_cycles)
      ..sort((a, b) => b.startDate.compareTo(a.startDate));

    return sortedCycles.first;
  }

  // Get the next expected period date
  DateTime? getNextPeriodDate() {
    final currentCycle = getCurrentCycle();
    if (currentCycle == null) return null;

    return currentCycle.startDate.add(Duration(days: currentCycle.cycleLength));
  }

  // Get all calendar events including predictions for future months
  Map<DateTime, List<CycleEvent>> getAllCalendarEvents() {
    final Map<DateTime, List<CycleEvent>> allEvents = {};

    // Add actual recorded cycles
    for (final cycle in _cycles) {
      final cycleEvents = cycle.toCalendarEvents();

      // Merge events
      for (final date in cycleEvents.keys) {
        if (allEvents.containsKey(date)) {
          allEvents[date]!.addAll(cycleEvents[date]!);
        } else {
          allEvents[date] = cycleEvents[date]!;
        }
      }
    }

    // Add predicted future cycles (6 months into the future)
    final predictedEvents = _getPredictedEvents(6);
    for (final date in predictedEvents.keys) {
      if (allEvents.containsKey(date)) {
        allEvents[date]!.addAll(predictedEvents[date]!);
      } else {
        allEvents[date] = predictedEvents[date]!;
      }
    }

    return allEvents;
  }

  // Generate predicted events for future months
  Map<DateTime, List<CycleEvent>> _getPredictedEvents(int monthsAhead) {
    final Map<DateTime, List<CycleEvent>> predictedEvents = {};
    final currentCycle = getCurrentCycle();

    if (currentCycle == null) return predictedEvents;

    final avgCycleLength = getAverageCycleLength();
    final avgPeriodLength = getAveragePeriodLength();

    // Start from the next predicted period
    DateTime nextPeriodStart = getNextPeriodDate() ??
        currentCycle.startDate.add(Duration(days: avgCycleLength));

    // Generate predictions for the specified number of months ahead
    for (int i = 0; i < monthsAhead; i++) {
      // Add period days
      for (int day = 0; day < avgPeriodLength; day++) {
        final date = nextPeriodStart.add(Duration(days: day));
        final dateKey = DateTime(date.year, date.month, date.day);

        final event = CycleEvent(
          title: 'Predicted Period',
          description: 'Day ${day + 1} of predicted period',
          color: AppColors.periodColor,
          type: CycleEventType.period,
        );

        if (predictedEvents.containsKey(dateKey)) {
          predictedEvents[dateKey]!.add(event);
        } else {
          predictedEvents[dateKey] = [event];
        }
      }

      // Add ovulation day (typically 14 days before the next period)
      final ovulationDate = nextPeriodStart.subtract(Duration(days: 14));
      final ovulationDateKey = DateTime(ovulationDate.year, ovulationDate.month, ovulationDate.day);

      final ovulationEvent = CycleEvent(
        title: 'Predicted Ovulation',
        description: 'Predicted ovulation day',
        color: AppColors.ovulationColor,
        type: CycleEventType.ovulation,
      );

      if (predictedEvents.containsKey(ovulationDateKey)) {
        predictedEvents[ovulationDateKey]!.add(ovulationEvent);
      } else {
        predictedEvents[ovulationDateKey] = [ovulationEvent];
      }

      // Add fertile window (typically 5 days before ovulation and ovulation day)
      for (int day = 5; day >= 0; day--) {
        final date = ovulationDate.subtract(Duration(days: day));
        final dateKey = DateTime(date.year, date.month, date.day);

        // Skip if it's the ovulation day (already added)
        if (day == 0) continue;

        final event = CycleEvent(
          title: 'Predicted Fertile Day',
          description: 'Part of predicted fertile window',
          color: AppColors.fertileColor,
          type: CycleEventType.fertile,
        );

        if (predictedEvents.containsKey(dateKey)) {
          predictedEvents[dateKey]!.add(event);
        } else {
          predictedEvents[dateKey] = [event];
        }
      }

      // Move to the next cycle
      nextPeriodStart = nextPeriodStart.add(Duration(days: avgCycleLength));
    }

    return predictedEvents;
  }

  // Add a new cycle
  void addCycle(CycleData cycle) {
    // Add to the beginning of the list to make it the most recent cycle
    _cycles.insert(0, cycle);

    // Log for debugging
    debugPrint('Added new cycle: ${cycle.startDate}, length: ${cycle.cycleLength} days');
  }

  // Add a symptom to the current cycle
  void addSymptom(CycleSymptom symptom) {
    final currentCycle = getCurrentCycle();
    if (currentCycle != null) {
      currentCycle.symptoms.add(symptom);
    }
  }

  // Add a note to the current cycle
  void addNote(CycleNote note) {
    final currentCycle = getCurrentCycle();
    if (currentCycle != null) {
      currentCycle.notes.add(note);
    }
  }

  // Get average cycle length
  int getAverageCycleLength() {
    if (_cycles.isEmpty) return 28; // Default

    int sum = 0;
    for (final cycle in _cycles) {
      sum += cycle.cycleLength;
    }

    return sum ~/ _cycles.length;
  }

  // Get average period length
  int getAveragePeriodLength() {
    if (_cycles.isEmpty) return 5; // Default

    int sum = 0;
    for (final cycle in _cycles) {
      sum += cycle.periodLength;
    }

    return sum ~/ _cycles.length;
  }
}
