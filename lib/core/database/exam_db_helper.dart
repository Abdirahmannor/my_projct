import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../../features/school/models/exam.dart';
import 'package:uuid/uuid.dart';

class ExamDbHelper {
  static const String tableName = 'exams';
  static Database? _database;
  static const _uuid = Uuid();

  static Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  static Future<Database> _initDatabase() async {
    final path = join(await getDatabasesPath(), 'school_manager.db');
    return openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE $tableName (
            id TEXT PRIMARY KEY,
            subject TEXT NOT NULL,
            date TEXT NOT NULL,
            time TEXT NOT NULL,
            color INTEGER NOT NULL
          )
        ''');
      },
    );
  }

  static Future<String> insertExam(Exam exam) async {
    final db = await database;
    final id = _uuid.v4();
    await db.insert(
      tableName,
      {
        'id': id,
        'subject': exam.subject,
        'date': exam.date,
        'time': exam.time,
        'color': exam.color.value,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return id;
  }

  static Future<List<Exam>> getExams() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(tableName);
    return List.generate(maps.length, (i) {
      return Exam(
        id: maps[i]['id'],
        subject: maps[i]['subject'],
        date: maps[i]['date'],
        time: maps[i]['time'],
        color: Color(maps[i]['color']),
      );
    });
  }

  static Future<void> updateExam(String id, Exam exam) async {
    final db = await database;
    await db.update(
      tableName,
      {
        'subject': exam.subject,
        'date': exam.date,
        'time': exam.time,
        'color': exam.color.value,
      },
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  static Future<void> deleteExam(String id) async {
    final db = await database;
    await db.delete(
      tableName,
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
