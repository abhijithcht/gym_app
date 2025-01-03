import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';

import '../../../utilities/custom_button.dart';
import '../../../utilities/custom_slidable.dart';
import '../../../utilities/custom_textfield.dart';

class GymMembers extends StatefulWidget {
  const GymMembers({super.key});

  @override
  State<GymMembers> createState() => _GymMembersState();
}

class _GymMembersState extends State<GymMembers> {
  final CollectionReference _reference =
      FirebaseFirestore.instance.collection('member');

  TextEditingController nameController = TextEditingController();
  TextEditingController ageController = TextEditingController();
  TextEditingController mobileController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController feeController = TextEditingController();

  DateTime? selectedDate;

  Future<void> _selectDate(BuildContext context) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        selectedDate = picked;
        dateController.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  Future<void> delete(String id) async {
    await _reference.doc(id).delete();
  }

  Future<void> update(
      [DocumentSnapshot? documentSnapshot, DateTime? existingDate]) async {
    print('Update function called');
    if (documentSnapshot != null) {
      nameController.text = documentSnapshot['name'];
      ageController.text = documentSnapshot['age'].toString();
      mobileController.text = documentSnapshot['phone'];
      feeController.text = documentSnapshot['fees'].toString();
      Timestamp timestamp = documentSnapshot['date'];
      DateTime date = timestamp.toDate();
      dateController.text = DateFormat('yyyy-MM-dd').format(date);
    }
    selectedDate = existingDate;
    await showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (BuildContext context) {
          return SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 10),
                  CustomTextInputField(
                    controller: nameController,
                    hintText: 'Name',
                    prefixIcon: Icons.person,
                    keyboardType: TextInputType.name,
                  ),
                  const SizedBox(height: 10),
                  CustomTextInputField(
                    controller: ageController,
                    hintText: 'Age',
                    prefixIcon: Icons.face,
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  ),
                  const SizedBox(height: 10),
                  CustomTextInputField(
                    controller: mobileController,
                    hintText: 'Phone Number',
                    prefixIcon: Icons.phone,
                    keyboardType: TextInputType.phone,
                  ),
                  const SizedBox(height: 10),
                  CustomTextInputField(
                    controller: dateController,
                    hintText: 'Registration Date',
                    prefixIcon: Icons.calendar_today_rounded,
                    keyboardType: TextInputType.none,
                    onTap: () async {
                      await _selectDate(context);
                    },
                  ),
                  const SizedBox(height: 10),
                  CustomTextInputField(
                    controller: feeController,
                    hintText: 'Monthly Fees',
                    prefixIcon: Icons.attach_money_rounded,
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  ),
                  const SizedBox(height: 10),
                  CustomButton(
                    text: 'Update',
                    onPressed: () async {
                      await _reference.doc(documentSnapshot!.id).update({
                        'name': nameController.text,
                        'age': int.parse(ageController.text),
                        'phone': mobileController.text,
                        'date': Timestamp.fromDate(
                            DateTime.parse(dateController.text)),
                        'fees': int.parse(feeController.text),
                      });
                      nameController.clear();
                      ageController.clear();
                      mobileController.clear();
                      dateController.clear();
                      feeController.clear();
                      if (context.mounted) {
                        Navigator.pop(context);
                      }
                    },
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/newMember');
        },
        child: const Icon(Icons.add),
      ),
      body: StreamBuilder(
        stream: _reference.snapshots(),
        builder: (BuildContext context,
            AsyncSnapshot<QuerySnapshot> streamSnapshot) {
          if (streamSnapshot.hasError) {
            return const Text('Some Error has occurred.');
          }
          if (streamSnapshot.hasData && streamSnapshot.data!.docs.isNotEmpty) {
            return ListView.builder(
              itemCount: streamSnapshot.data?.docs.length,
              itemBuilder: (context, index) {
                final DocumentSnapshot documentSnapshot =
                    streamSnapshot.data!.docs[index];
                final DateTime existingDate = documentSnapshot['date'].toDate();
                return Slidable(
                  startActionPane: ActionPane(
                    motion: const StretchMotion(),
                    children: [
                      CustomSlidable(
                        onPressed: (context) async {
                          await delete(documentSnapshot.id);
                          return Future.value();
                        },
                      ),
                      CustomSlidable(
                        onPressed: (context) async {
                          await update(documentSnapshot, existingDate);
                          return Future.value();
                        },
                        backgroundColor: Colors.blue,
                        label: 'Edit',
                        icon: Icons.edit,
                      ),
                    ],
                  ),
                  child: Card(
                    margin: const EdgeInsets.all(10),
                    child: ListTile(
                      title: Text(
                        documentSnapshot['name'],
                      ),
                      subtitle: Text(
                        documentSnapshot['phone'].toString(),
                      ),
                      leading: Text(
                        '\$${documentSnapshot['fees'].toString()}',
                      ),
                      trailing: Text(
                        DateFormat('yyyy-MM-dd')
                            .format(documentSnapshot['date'].toDate()),
                      ),
                      onTap: () {},
                    ),
                  ),
                );
              },
            );
          } else if (streamSnapshot.connectionState ==
              ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return const Center(
              child: Text('No data available.'),
            );
          }
        },
      ),
    );
  }
}
