import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/workout_model.dart';
import '../models/exercise_model.dart';
import '../models/user_model.dart';

class DatabaseService {
  static final DatabaseService _instance = DatabaseService._();
  static Database? _database;

  DatabaseService._();
  factory DatabaseService() => _instance;

  Future<Database> get database async {
    _database ??= await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'gymflow.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE workouts(
        id TEXT PRIMARY KEY,
        userId TEXT,
        name TEXT,
        date TEXT,
        isCompleted INTEGER
      )
    ''');

    await db.execute('''
      CREATE TABLE exercises(
        id TEXT PRIMARY KEY,
        workoutId TEXT,
        name TEXT,
        sets INTEGER,
        reps INTEGER,
        weight REAL,
        notes TEXT,
        isCompleted INTEGER,
        FOREIGN KEY (workoutId) REFERENCES workouts (id)
      )
    ''');

    await db.execute('''
      CREATE TABLE users(
        id TEXT PRIMARY KEY,
        name TEXT,
        email TEXT UNIQUE,
        password TEXT,
        weight REAL,
        height REAL,
        goal TEXT
      )
    ''');
  }

  // Métodos para Workouts
  Future<void> saveWorkout(WorkoutModel workout) async {
    final db = await database;
    await db.transaction((txn) async {
      // Salva o treino
      await txn.insert(
        'workouts',
        {
          'id': workout.id,
          'userId': workout.userId,
          'name': workout.name,
          'date': workout.date.toIso8601String(),
          'isCompleted': workout.isCompleted ? 1 : 0,
        },
        conflictAlgorithm: ConflictAlgorithm.replace,
      );

      // Salva os exercícios
      for (final exercise in workout.exercises) {
        await txn.insert(
          'exercises',
          {
            'id': exercise.id,
            'workoutId': workout.id,
            'name': exercise.name,
            'sets': exercise.sets,
            'reps': exercise.reps,
            'weight': exercise.weight,
            'notes': exercise.notes,
            'isCompleted': exercise.isCompleted ? 1 : 0,
          },
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      }
    });
  }

  Future<List<WorkoutModel>> getWorkouts() async {
    final db = await database;
    final workouts = await db.query('workouts');
    
    return Future.wait(workouts.map((workout) async {
      final exercises = await db.query(
        'exercises',
        where: 'workoutId = ?',
        whereArgs: [workout['id']],
      );

      return WorkoutModel(
        id: workout['id'] as String,
        userId: workout['userId'] as String,
        name: workout['name'] as String,
        date: DateTime.parse(workout['date'] as String),
        isCompleted: (workout['isCompleted'] as int) == 1,
        exercises: exercises.map((e) => ExerciseModel(
          id: e['id'] as String,
          name: e['name'] as String,
          sets: e['sets'] as int,
          reps: e['reps'] as int,
          weight: e['weight'] as double?,
          notes: e['notes'] as String?,
          isCompleted: (e['isCompleted'] as int) == 1,
        )).toList(),
      );
    }));
  }

  Future<void> deleteWorkout(String id) async {
    final db = await database;
    await db.transaction((txn) async {
      await txn.delete(
        'exercises',
        where: 'workoutId = ?',
        whereArgs: [id],
      );
      await txn.delete(
        'workouts',
        where: 'id = ?',
        whereArgs: [id],
      );
    });
  }

  // Adicione métodos para usuários
  Future<UserModel?> getUser(String email, String password) async {
    final db = await database;
    final users = await db.query(
      'users',
      where: 'email = ? AND password = ?',
      whereArgs: [email, password],
    );

    if (users.isEmpty) return null;
    return UserModel.fromMap(users.first);
  }

  Future<void> saveUser(UserModel user) async {
    final db = await database;
    await db.insert(
      'users',
      user.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> updateUser(UserModel user) async {
    final db = await database;
    await db.update(
      'users',
      user.toMap(),
      where: 'id = ?',
      whereArgs: [user.id],
    );
  }
} 