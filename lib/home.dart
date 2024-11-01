import 'package:flutter/material.dart';
import 'package:flutter_hive_database/boxes.dart';
import 'package:flutter_hive_database/person.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController ageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade300,

      appBar: AppBar(
        backgroundColor: Colors.indigo,
        title: const Text("Tasks"),
        centerTitle: true,
      ),
      body: Column(
        children: [

          const SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  children: [
                    TextField(
                      controller: titleController,
                      keyboardType: TextInputType.text,
                      textInputAction: TextInputAction.next,
                      decoration: const InputDecoration(
                          hintText: "Title",
                          hintStyle: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w600),
                          border: OutlineInputBorder()),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextField(
                      controller: ageController,
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.done,

                      decoration: const InputDecoration(
                          hintText: "Age",
                          hintStyle: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w600),
                          border: OutlineInputBorder()),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextButton(
                        style: const ButtonStyle(backgroundColor: MaterialStatePropertyAll(Colors.indigo)),
                        onPressed:  () {
                          setState(() {
                            boxPersons.put(
                              "key_${titleController.text}",
                              Person(
                                name: titleController.text.trim(),
                                age: ageController.text.trim(),
                              ),
                            );
                          });
                          titleController.clear();
                          ageController.clear();
                        },
                        child: const Text("Add",style: TextStyle(color: Colors.white),))
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: ListView.builder(
                      itemCount: boxPersons.length,
                      itemBuilder: (context, index) {
                        Person person = boxPersons.getAt(index);

                        return ListTile(
                          leading: IconButton(
                              onPressed: () {
                                setState(() {
                                  boxPersons.deleteAt(index);
                                });
                              },
                              icon: const Icon(
                                Icons.remove,
                                color: Colors.red,
                              )),
                          title: Text(person.name),
                          subtitle: const Text(
                            "Name",
                            style: TextStyle(fontSize: 14),
                          ),
                          trailing: Text("Age: ${person.age.toString()}"),
                        );
                      }),
                ),
              ),
            ),
          ),

          const SizedBox(
            height: 15,
          ),
          GestureDetector(
            onTap: () {
              boxPersons.clear();

              setState(() {});
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
            height: 20,
          ),
        ],
      ),
    );
  }


}
