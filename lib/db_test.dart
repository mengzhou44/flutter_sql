import 'dart:async';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

import './database.dart';
import './dog.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  var fido = Dog(
    id: 0,
    name: 'Fido',
    age: 35,
  );

  await insertDog(fido);
  print("dogs inserted:");
  print(await dogs());

  fido = Dog(
    id: fido.id,
    name: fido.name,
    age: fido.age + 7,
  );
  await updateDog(fido);
  print("dogs updated:");
  print(await dogs());

  await deleteDog(fido.id);
  print("dogs deleted");
  print(await dogs());

  runApp(new Container());
}

Future<void> insertDog(Dog dog) async {
  final Database db = await getDatabase();

  await db.insert(
    'dogs',
    dog.toMap(),
    conflictAlgorithm: ConflictAlgorithm.replace,
  );
}

Future<List<Dog>> dogs() async {
  final Database db = await getDatabase();
  final List<Map<String, dynamic>> maps = await db.query('dogs');

  return List.generate(maps.length, (i) {
    return Dog(
      id: maps[i]['id'],
      name: maps[i]['name'],
      age: maps[i]['age'],
    );
  });
}

Future<void> updateDog(Dog dog) async {
  final Database db = await getDatabase();

  await db.update(
    'dogs',
    dog.toMap(),
    where: "id = ?",
    whereArgs: [dog.id],
  );
}

Future<void> deleteDog(int id) async {
  final Database db = await getDatabase();
  await db.delete(
    'dogs',
    where: "id = ?",
    whereArgs: [id],
  );
}
