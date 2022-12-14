import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart';

import '../../db/database.dart';
import '../../models/people.dart';

class PeopleDatabase {

  ///Function to insert list of peoples in DB
  ///Pass [List<People>]
  ///Return [bool] of success
  Future<bool> insert(List<People> peoples) async {
    bool success = false;

    try {
      var database = await DatabaseHandler.instance.initiateDB();

      final batch = database.batch();

      for(People people in peoples){
        batch.insert('peoples', people.toMapDB(), conflictAlgorithm: ConflictAlgorithm.replace);
      }

      await batch.commit(noResult: true);

      success = true;
    } catch (err) {
      if (kDebugMode) {
        print(err);
      }
    }
    return success;
  }

  ///Function to get all Peoples from DB
  ///Pass [Nothing]
  ///Return [List<People>]
  Future<List<People>> getAll() async {
    try {
      var database = await DatabaseHandler.instance.initiateDB();

      var response = await database.query('peoples');
      
      if(response.isNotEmpty){
        return response.map((e) => People.fromMapDB(e)).toList();
      }
    } catch (err) {
      if (kDebugMode) {
        print(err);
      }
    }
    return [];
  }

  ///Function to get quantity of peoples from DB
  ///Pass [Nothing]
  ///Return [int]
  count() async {
    try{
      var database = await DatabaseHandler.instance.initiateDB();

      var response = await database.query('peoples', columns: ['count()']);

      return response[0]['count()'];
    }
    catch(err){
      if (kDebugMode) {
        print(err);
      }
    }
  }
}