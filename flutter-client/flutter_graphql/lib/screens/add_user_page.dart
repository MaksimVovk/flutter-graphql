import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class AddUserPage extends StatefulWidget {
  @override
  _AddUserPageState createState() => _AddUserPageState();
}

class _AddUserPageState extends State<AddUserPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _ageController = TextEditingController();
  final _proffesionController = TextEditingController();

  String insertUser () {
    return '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Add a user',
          style: TextStyle(
            color: Colors.white,
            fontSize: 19,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.green,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(24),
          margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                offset: Offset(0, 10),
                color: Colors.grey.shade300,
                blurRadius: 30,
              ),
            ],
          ),
          child: Column(
            children: [
              Mutation(
                options: MutationOptions(
                  document: gql(insertUser()),
                  fetchPolicy: FetchPolicy.noCache,
                  onCompleted: (data) {
                    
                  },
                ),
                builder: (runMutation, result) {
                  return Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        SizedBox(height: 12,),
                        TextFormField(
                          controller: _nameController,
                          decoration: InputDecoration(
                            labelText: 'Name',
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderSide: BorderSide()
                            )
                          ),
                          validator: (v) {
                            if (v.length == 0) {
                              return 'Name can\'t be empty';
                            } else {
                              return null;
                            }
                          },
                          keyboardType: TextInputType.text,
                        ),
                        SizedBox(height: 12,),
                        TextFormField(
                          controller: _ageController,
                          decoration: InputDecoration(
                            labelText: 'Age',
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderSide: BorderSide()
                            )
                          ),
                          validator: (v) {
                            if (v.length == 0) {
                              return 'Age can\'t be empty';
                            } else {
                              return null;
                            }
                          },
                          keyboardType: TextInputType.number,
                        ),
                        SizedBox(height: 12,),
                        TextFormField(
                          controller: _proffesionController,
                          decoration: InputDecoration(
                            labelText: 'Proffesion',
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderSide: BorderSide()
                            )
                          ),
                          validator: (v) {
                            if (v.length == 0) {
                              return 'Proffesion can\'t be empty';
                            } else {
                              return null;
                            }
                          },
                          keyboardType: TextInputType.text,
                        ),
                        SizedBox(height: 12,),
                        TextButton(
                          onPressed: () {

                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 12),
                            child: Text(
                              'Save',
                              style: TextStyle(
                                color: Colors.blueGrey
                              ),
                            )
                          ),
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(
                              Colors.greenAccent,
                            )
                          ),
                        ),
                      ],
                    ),
                  );
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}