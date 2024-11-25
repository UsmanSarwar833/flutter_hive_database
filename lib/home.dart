import 'package:flutter/material.dart';
import 'package:flutter_hive/person.dart';
import 'package:intl/intl.dart';

import 'boxes.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController subTitleController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  DateTime selectedDate = DateTime.now();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        initialDatePickerMode: DatePickerMode.day,
        firstDate: DateTime.now(),
        lastDate: DateTime(2100));
    if (picked != null) {
      setState(() {
        selectedDate = picked;
        dateController.text = DateFormat("MMMM dd, yyyy").format(selectedDate);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      appBar: AppBar(
        backgroundColor: Colors.indigo,
        title: const Text(
          "Tasks",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          const SizedBox(
            height: 5,
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: Card(
                child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: ListView.builder(
                        itemCount: boxPersons.length,
                        itemBuilder: (context, index) {
                          Person person = boxPersons.getAt(index);
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 2.0),
                            child: Card(
                              color: Colors.grey.shade300,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        right: 10.0, top: 5),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Text(
                                          person.date.toString(),
                                          style: const TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 12,

                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  ListTile(
                                      leading: IconButton(
                                          onPressed: () {
                                            showDeleteTransparentDialog(context,
                                                onTap: () {
                                              setState(() {
                                                boxPersons.deleteAt(index);
                                              });
                                            },
                                                buttonTitle: 'Yes',
                                                message:
                                                    "Are you sure you want to delete task?",
                                                dialogTitle: "Delete Task");
                                          },
                                          icon: const Icon(
                                            Icons.remove,
                                            color: Colors.red,
                                          )),
                                      title: Text(
                                        person.title.toString(),
                                        style: const TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 16),
                                      ),
                                      subtitle: Text(person.subtitle.toString(),
                                          style: const TextStyle(fontSize: 14)),
                                      trailing: GestureDetector(
                                          onTap: () {
                                            _showEditDialog(
                                              person,
                                              person.title.toString(),
                                              person.subtitle.toString(),
                                              person.date.toString(),
                                              () {
                                                person.title = titleController.text.toString();
                                                person.subtitle = subTitleController.text.toString();
                                                person.date = dateController.text.toString();
                                                person.save();
                                                  Navigator.pop(context);
                                                  setState(() {

                                                  });

                                              },
                                              () {
                                                _selectDate(context);
                                              },
                                            );
                                          },
                                          child: const Icon(
                                            Icons.edit,
                                          ))),
                                ],
                              ),
                            ),
                          );
                        })),
              ),
            ),
          ),
          const SizedBox(
            height: 8,
          ),
          GestureDetector(
            onTap: () {
              showDeleteTransparentDialog(context,
                  onTap: () {
                    boxPersons.clear();

                    setState(() {

                    });
                  },
                  buttonTitle: 'Yes',
                  message:
                  "Are you sure you want to delete all tasks?",
                  dialogTitle: "Delete Tasks");


            },
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(
                  Icons.delete,
                  color: Colors.red,
                ),
                SizedBox(
                  width: 5,
                ),
                Text(
                  "Delete All",
                  style: TextStyle(
                      color: Colors.indigo,
                      fontSize: 14,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 15,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.indigo,
        onPressed: () {
          titleController.clear();
          subTitleController.clear();
          dateController.clear();
          _showADDDialog(context, titleController, subTitleController,
              dateController,  () {
            final data = Person(
              title: titleController.text.trim(),
              subtitle: subTitleController.text.trim(),
              date: dateController.text.trim(),
            );
            boxPersons.add(data);
            data.save();
            Navigator.pop(context);
            Future.delayed(const Duration(milliseconds: 100), () {
              titleController.clear();
              subTitleController.clear();
              dateController.clear();
            });

            setState(() {});
          }, () {
            _selectDate(context);
          });
        },
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }

  static _showADDDialog(
    BuildContext context,
    TextEditingController titleController,
    TextEditingController subTitleController,
    TextEditingController dateController,
    VoidCallback onPressed,
    VoidCallback onDatePressed,
  ) async {
    return showDialog(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (BuildContext context) {
        return Center(
          child: Wrap(
            children: [
              AlertDialog(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                content: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                         "Add Tasks" ,
                        style: const TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 16),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Column(
                            children: [
                              TextField(
                                textCapitalization: TextCapitalization.words,
                                controller: titleController,
                                keyboardType: TextInputType.text,
                                textInputAction: TextInputAction.next,
                                decoration: const InputDecoration(
                                    contentPadding: EdgeInsets.symmetric(
                                        vertical: 5.0, horizontal: 10),
                                    hintText: "Title",
                                    hintStyle: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600),
                                    border: OutlineInputBorder()),
                              ),
                              const SizedBox(
                                height: 15,
                              ),
                              TextField(
                                controller: subTitleController,
                                keyboardType: TextInputType.text,
                                textInputAction: TextInputAction.next,
                                decoration: const InputDecoration(
                                    contentPadding: EdgeInsets.symmetric(
                                        vertical: 5.0, horizontal: 10),
                                    hintText: "SubTitle",
                                    hintStyle: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600),
                                    border: OutlineInputBorder()),
                              ),
                              const SizedBox(
                                height: 15,
                              ),
                              TextField(
                                onTap: onDatePressed,
                                controller: dateController,
                                readOnly: true,
                                decoration: const InputDecoration(
                                    contentPadding: EdgeInsets.symmetric(
                                        vertical: 5.0, horizontal: 10),
                                    hintText: "Date",
                                    hintStyle: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600),
                                    border: OutlineInputBorder()),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              GestureDetector(
                                  onTap: onPressed,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20.0),
                                    child: Container(
                                        decoration: BoxDecoration(
                                            color: Colors.indigo,
                                            borderRadius:
                                                BorderRadius.circular(5)),
                                        height: 50,
                                        width: double.infinity,
                                        child: Center(
                                            child: Text(
                                          "Add"
                                              ,
                                          style: const TextStyle(
                                              color: Colors.white),
                                        ))),
                                  )),
                              const SizedBox(
                                height: 20,
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 1,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }


  Future<void> _showEditDialog(
      Person person,
      String title,
      String subTitle,
      String date,
      VoidCallback onPressed,
      VoidCallback onDatePressed,
      ) async {
    titleController.text = title;
    subTitleController.text = subTitle;
    dateController.text = date;
    return showDialog(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (BuildContext context) {
        return Center(
          child: Wrap(
            children: [
              AlertDialog(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                content: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                         "Update Tasks",
                        style: const TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 16),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Column(
                            children: [
                              TextField(
                                textCapitalization: TextCapitalization.words,
                                controller: titleController,
                                keyboardType: TextInputType.text,
                                textInputAction: TextInputAction.next,
                                decoration: const InputDecoration(
                                    contentPadding: EdgeInsets.symmetric(
                                        vertical: 5.0, horizontal: 10),
                                    hintText: "Title",
                                    hintStyle: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600),
                                    border: OutlineInputBorder()),
                              ),
                              const SizedBox(
                                height: 15,
                              ),
                              TextField(
                                controller: subTitleController,
                                keyboardType: TextInputType.text,
                                textInputAction: TextInputAction.next,
                                decoration: const InputDecoration(
                                    contentPadding: EdgeInsets.symmetric(
                                        vertical: 5.0, horizontal: 10),
                                    hintText: "SubTitle",
                                    hintStyle: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600),
                                    border: OutlineInputBorder()),
                              ),
                              const SizedBox(
                                height: 15,
                              ),
                              TextField(
                                onTap: onDatePressed,
                                controller: dateController,
                                readOnly: true,
                                decoration: const InputDecoration(
                                    contentPadding: EdgeInsets.symmetric(
                                        vertical: 5.0, horizontal: 10),
                                    hintText: "Date",
                                    hintStyle: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600),
                                    border: OutlineInputBorder()),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              GestureDetector(
                                  onTap: onPressed,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20.0),
                                    child: Container(
                                        decoration: BoxDecoration(
                                            color: Colors.indigo,
                                            borderRadius:
                                            BorderRadius.circular(5)),
                                        height: 50,
                                        width: double.infinity,
                                        child: Center(
                                            child: Text(
                                              "Update",
                                              style: const TextStyle(
                                                  color: Colors.white),
                                            ))),
                                  )),
                              const SizedBox(
                                height: 20,
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 1,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  static showDeleteTransparentDialog(BuildContext context,
      {required VoidCallback onTap,
      required String buttonTitle,
      required String message,
      required String dialogTitle}) async {
    return await showGeneralDialog(
        context: context,
        barrierDismissible: true,
        barrierLabel: "alert",
        transitionDuration: const Duration(milliseconds: 200),
        pageBuilder: (_, __, ___) {
          return Center(
            child: Wrap(
              children: [
                AlertDialog(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    content: SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            height: 50,
                            width: 50,
                            decoration: const BoxDecoration(
                                shape: BoxShape.circle, color: Colors.red),
                            child: const Center(
                                child: Icon(
                              Icons.check,
                              color: Colors.white,
                              size: 35,
                            )),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Text(
                            dialogTitle,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          Text(
                            message,
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.pop(context);
                                  },
                                  child: Container(
                                    height: 50,
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      color: Colors.grey.shade100,
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    child: const Center(child: Text('No')),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                width: 15,
                              ),
                              Expanded(
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.of(context).pop();
                                    onTap();
                                  },
                                  child: Container(
                                    height: 50,
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      color: Colors.red,
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    child: Center(
                                        child: Text(
                                      buttonTitle,
                                    )),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    )),
              ],
            ),
          );
        });
  }
}
