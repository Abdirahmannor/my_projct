class DatabaseTables {
  static const String eventsTable = '''
    CREATE TABLE events (
      id TEXT PRIMARY KEY,
      title TEXT NOT NULL,
      description TEXT,
      start_time INTEGER NOT NULL,
      end_time INTEGER NOT NULL,
      category TEXT NOT NULL,
      color INTEGER NOT NULL,
      is_all_day INTEGER DEFAULT 0,
      is_recurring INTEGER DEFAULT 0,
      recurrence_rule TEXT,
      location TEXT,
      attachments TEXT,
      reminders TEXT
    )
  ''';

  static const String resourcesTable = '''
    CREATE TABLE resources (
      id TEXT PRIMARY KEY,
      title TEXT NOT NULL,
      description TEXT,
      type TEXT NOT NULL,
      category TEXT NOT NULL,
      file_path TEXT NOT NULL,
      created_at INTEGER NOT NULL,
      modified_at INTEGER NOT NULL,
      url TEXT,
      tags TEXT,
      is_favorite INTEGER DEFAULT 0
    )
  ''';
}
