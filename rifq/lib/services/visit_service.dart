import 'package:rifq/models/visit_model.dart';

class VisitService {
  static const List<String> _monthAbbreviations = [
    'JAN', 'FEB', 'MAR', 'APR', 'MAY', 'JUN',
    'JUL', 'AUG', 'SEP', 'OCT', 'NOV', 'DEC',
  ];

  static VisitModel _upcomingVisit({
    required String visitName,
    required String doctorName,
    required int daysFromNow,
    required String time,
    required bool isHandled,
    required String markedByName,
  }) {
    final date = DateTime.now().add(Duration(days: daysFromNow));
    return VisitModel(
      visitName: visitName,
      doctorName: doctorName,
      day: date.day.toString().padLeft(2, '0'),
      month: _monthAbbreviations[date.month - 1],
      time: time,
      isHandled: isHandled,
      markedByName: markedByName,
    );
  }

  final List<VisitModel> _visits = [
    _upcomingVisit(
      visitName: 'Annual Checkup',
      doctorName: 'Dr. Sarah',
      daysFromNow: 6,
      time: '10:00 AM',
      isHandled: true,
      markedByName: 'Mohammed',
    ),
    _upcomingVisit(
      visitName: 'Dental Cleaning',
      doctorName: 'Dr. Khalid',
      daysFromNow: 12,
      time: '2:30 PM',
      isHandled: true,
      markedByName: 'Ahmed',
    ),
    _upcomingVisit(
      visitName: 'Eye Exam',
      doctorName: 'Dr. Noura',
      daysFromNow: 19,
      time: '11:00 AM',
      isHandled: true,
      markedByName: 'Ahmed',
    ),
    _upcomingVisit(
      visitName: 'Cardiology Follow-up',
      doctorName: 'Dr. Fahad',
      daysFromNow: 26,
      time: '9:00 AM',
      isHandled: true,
      markedByName: 'Mohammed',
    ),
    _upcomingVisit(
      visitName: 'Lab Work',
      doctorName: 'Dr. Sarah',
      daysFromNow: 32,
      time: '7:30 AM',
      isHandled: true,
      markedByName: 'Mohammed',
    ),
  ];

  List<VisitModel> getVisits() {
    return List.unmodifiable(_visits);
  }

  void addVisit(VisitModel visit) {
    _visits.add(visit);
  }
}
