// Copyright 2022, the Chromium project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_ui_firestore/firebase_ui_firestore.dart';
import 'package:firebase_ui_firestore_example/firebase_options.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const FirebaseUIFirestoreExample());
}

class FirebaseUIFirestoreExample extends StatelessWidget {
  const FirebaseUIFirestoreExample({super.key});

  @override
  Widget build(BuildContext context) {
    final ColorScheme colors = Theme.of(context).colorScheme;

    final collectionRef = FirebaseFirestore.instance.collection('users');

    var converter = FirestoreConverter<User>(
      fromFirestore: (snapshot, _) => User.fromJson(snapshot.data()!),
      toFirestore: (user, _) => user.toJson(),
    );
    CollectionReference<User> collection =
        collectionRef.withFirestoreConverter(converter);

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('Contacts')),
        body: SingleChildScrollView(
          child: FirestoreDataTable<User>(
            query: collection,
            converter: converter,
            showFirstLastButtons: true,
            rowsPerPage: 8,
            canDeleteItems: true,
            enableDefaultCellEditor: true,
            showCheckboxColumn: true,
            header: Row(
              children: [
                FilterChip(
                  label: const Text("Selected filter"),
                  selected: true,
                  onSelected: (val) {},
                ),
                const SizedBox(width: 8),
                FilterChip(
                  label: const Text("Other filter"),
                  selected: false,
                  onSelected: (val) {},
                ),
              ],
            ),
            onSelectedRows: (items) {
              print("onSelectedRows $items");
            },
            onTapCell: <User>(snapshot, model, value, propertyName) {
              print("onTapCell $model");
            },
            actions: [
              IconButton(
                icon: const SizedBox(
                  height: 24,
                  width: 24,
                  child: Center(child: Icon(Icons.add)),
                ),
                onPressed: () {},
                style: IconButton.styleFrom(
                  foregroundColor: colors.onSecondaryContainer,
                  backgroundColor: colors.secondaryContainer,
                  disabledBackgroundColor: colors.onSurface.withOpacity(0.12),
                  hoverColor: colors.onSecondaryContainer.withOpacity(0.08),
                  focusColor: colors.onSecondaryContainer.withOpacity(0.12),
                  highlightColor: colors.onSecondaryContainer.withOpacity(0.12),
                ),
              ),
            ],
            columns: const {
              "firstName": DataColumn(label: Text("firstName")),
              "lastName": DataColumn(label: Text("lastName")),
              "userName": DataColumn(label: Text("userName")),
              "email": DataColumn(label: Text("email")),
              "number": DataColumn(label: Text("number")),
              "streetName": DataColumn(label: Text("streetName")),
              "zipCode": DataColumn(label: Text("zipCode")),
              "prefix": DataColumn(label: Text("prefix")),
            },
          ),
        ),
      ),
    );
  }
}

class UserTile extends StatelessWidget {
  final User user;

  const UserTile({
    super.key,
    required this.user,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          child: Text(user.firstName[0]),
        ),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '${user.firstName} ${user.lastName}',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            Text(
              user.number,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ],
    );
  }
}

class User {
  User({
    required this.city,
    required this.country,
    required this.streetName,
    required this.zipCode,
    required this.prefix,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.userName,
    required this.number,
  });

  User.fromJson(Map<String, Object?> json)
      : this(
          city: json['city'].toString(),
          country: json['country'].toString(),
          streetName: json['streetName'].toString(),
          zipCode: json['zipCode'].toString(),
          prefix: json['prefix'].toString(),
          firstName: json['firstName'].toString(),
          lastName: json['lastName'].toString(),
          email: json['email'].toString(),
          userName: json['userName'].toString(),
          number: json['number'].toString(),
        );

  final String city;
  final String country;
  final String streetName;
  final String zipCode;

  final String prefix;
  final String firstName;
  final String lastName;

  final String email;
  final String userName;
  final String number;

  Map<String, Object?> toJson() {
    return {
      'city': city,
      'country': country,
      'streetName': streetName,
      'zipCode': zipCode,
      'prefix': prefix,
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'userName': userName,
      'number': number,
    };
  }
}
