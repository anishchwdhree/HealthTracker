import 'package:flutter/material.dart';
import 'package:pregnancy_health_tracker/constants/colors.dart';
import 'package:pregnancy_health_tracker/widgets/cycle_calendar.dart';

class CycleData {
  final DateTime startDate;
  final DateTime? endDate;
  final int cycleLength;
  final int periodLength;
  final List<CycleSymptom> symptoms;
  final List<CycleNote> notes;

  CycleData({
    required this.startDate,
    this.endDate,
    required this.cycleLength,
    required this.periodLength,
    this.symptoms = const [],
    this.notes = const [],
  });

  // Calculate fertility window (typically 5 days before ovulation and ovulation day)
  List<DateTime> get fertilityWindow {
    final ovulationDate = getOvulationDate();
    if (ovulationDate == null) return [];

    final List<DateTime> window = [];
    for (int i = 5; i >= 0; i--) {
      window.add(ovulationDate.subtract(Duration(days: i)));
    }
    return window;
  }

  // Calculate ovulation date (typically 14 days before the next period)
  DateTime? getOvulationDate() {
    // startDate is non-nullable, so we don't need to check if it's null

    // Ovulation typically occurs 14 days before the next period
    final nextPeriodStart = startDate.add(Duration(days: cycleLength));
    return nextPeriodStart.subtract(const Duration(days: 14));
  }

  // Get period days
  List<DateTime> getPeriodDays() {
    if (endDate != null) {
      // If we have an end date, calculate the actual period days
      final List<DateTime> days = [];
      final difference = endDate!.difference(startDate).inDays;

      for (int i = 0; i <= difference; i++) {
        days.add(startDate.add(Duration(days: i)));
      }
      return days;
    } else {
      // Otherwise, use the average period length
      final List<DateTime> days = [];
      for (int i = 0; i < periodLength; i++) {
        days.add(startDate.add(Duration(days: i)));
      }
      return days;
    }
  }

  // Convert to calendar events
  Map<DateTime, List<CycleEvent>> toCalendarEvents() {
    final Map<DateTime, List<CycleEvent>> events = {};

    // Add period events
    for (final day in getPeriodDays()) {
      events[day] = [
        CycleEvent(
          title: 'Period',
          description: 'Period day',
          color: AppColors.primaryColor,
          type: CycleEventType.period,
        )
      ];
    }

    // Add ovulation event
    final ovulationDate = getOvulationDate();
    if (ovulationDate != null) {
      events[ovulationDate] = [
        CycleEvent(
          title: 'Ovulation',
          description: 'Ovulation day',
          color: AppColors.accentColor,
          type: CycleEventType.ovulation,
        )
      ];
    }

    // Add fertility window events
    for (final day in fertilityWindow) {
      if (day != ovulationDate) {  // Skip ovulation day as it's already added
        events[day] = [
          CycleEvent(
            title: 'Fertile',
            description: 'Fertile day',
            color: Colors.green,
            type: CycleEventType.fertile,
          )
        ];
      }
    }

    // Add symptom events
    for (final symptom in symptoms) {
      if (events.containsKey(symptom.date)) {
        events[symptom.date]!.add(
          CycleEvent(
            title: symptom.type.name,
            description: symptom.notes,
            color: symptom.type.color,
            type: CycleEventType.symptom,
          )
        );
      } else {
        events[symptom.date] = [
          CycleEvent(
            title: symptom.type.name,
            description: symptom.notes,
            color: symptom.type.color,
            type: CycleEventType.symptom,
          )
        ];
      }
    }

    // Add note events
    for (final note in notes) {
      if (events.containsKey(note.date)) {
        events[note.date]!.add(
          CycleEvent(
            title: 'Note',
            description: note.text,
            color: Colors.blue,
            type: CycleEventType.note,
          )
        );
      } else {
        events[note.date] = [
          CycleEvent(
            title: 'Note',
            description: note.text,
            color: Colors.blue,
            type: CycleEventType.note,
          )
        ];
      }
    }

    return events;
  }
}

class CycleSymptom {
  final DateTime date;
  final SymptomType type;
  final int severity; // 1-5 scale
  final String notes;

  CycleSymptom({
    required this.date,
    required this.type,
    this.severity = 1,
    this.notes = '',
  });
}

enum SymptomType {
  cramps(name: 'Cramps', color: Colors.red),
  headache(name: 'Headache', color: Colors.orange),
  bloating(name: 'Bloating', color: Colors.yellow),
  fatigue(name: 'Fatigue', color: Colors.brown),
  breastTenderness(name: 'Breast Tenderness', color: Colors.pink),
  acne(name: 'Acne', color: Colors.purple),
  moodSwings(name: 'Mood Swings', color: Colors.blue),
  backache(name: 'Backache', color: Colors.teal),
  nausea(name: 'Nausea', color: Colors.green);

  final String name;
  final Color color;

  const SymptomType({
    required this.name,
    required this.color,
  });
}

class CycleNote {
  final DateTime date;
  final String text;

  CycleNote({
    required this.date,
    required this.text,
  });
}
