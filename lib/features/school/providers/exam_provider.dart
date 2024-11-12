import 'package:flutter/material.dart';
import '../../../core/database/exam_db_helper.dart';
import '../models/exam.dart';

class ExamProvider extends ChangeNotifier {
  final List<Exam> _exams = [];
  bool _isLoading = false;

  bool get isLoading => _isLoading;
  List<Exam> get exams => List.unmodifiable(_exams);

  List<Exam> get upcomingExams {
    final now = DateTime.now();
    final sortedExams = List<Exam>.from(_exams)
      ..sort((a, b) => a.dateTime.compareTo(b.dateTime));

    return sortedExams.where((exam) => exam.dateTime.isAfter(now)).toList();
  }

  // Load exams from database
  Future<void> loadExams() async {
    _isLoading = true;
    notifyListeners();

    try {
      final loadedExams = await ExamDbHelper.getExams();
      _exams.clear();
      _exams.addAll(loadedExams);
    } catch (e) {
      debugPrint('Error loading exams: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Add exam to database and local state
  Future<void> addExam(Exam exam) async {
    try {
      final id = await ExamDbHelper.insertExam(exam);
      _exams.add(exam);
      notifyListeners();
    } catch (e) {
      debugPrint('Error adding exam: $e');
    }
  }

  // Remove exam from database and local state
  Future<void> removeExam(Exam exam) async {
    try {
      await ExamDbHelper.deleteExam(exam.id);
      _exams.remove(exam);
      notifyListeners();
    } catch (e) {
      debugPrint('Error removing exam: $e');
    }
  }

  // Update exam in database and local state
  Future<void> updateExam(Exam oldExam, Exam newExam) async {
    try {
      await ExamDbHelper.updateExam(oldExam.id, newExam);
      final index = _exams.indexOf(oldExam);
      if (index != -1) {
        _exams[index] = newExam;
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error updating exam: $e');
    }
  }
}
