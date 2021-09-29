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
  final _professionController = TextEditingController();

  final _formHobbyKey = GlobalKey<FormState>();
  final _hobbyTitleController = TextEditingController();
  final _descriptionController = TextEditingController();

  bool _isSaving = false;
  bool _isHobbySaving = false;
  bool _visable = false;

  String _currentUserId;

  String insertUser () {
    return '''
      mutation
        CreateUser (
          \$name: String!,
          \$age: Int!,
          \$profession: String!
        ) {
          CreateUser (name: \$name, age: \$age, profession: \$profession) {
            id
            name
          }
        }
    ''';
  }

  String insertHobby () {
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
                    setState(() {
                      _isSaving = false;
                      _currentUserId = data['CreateUser']['id'];
                    });
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
                          controller: _professionController,
                          decoration: InputDecoration(
                            labelText: 'Profession',
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderSide: BorderSide()
                            )
                          ),
                          validator: (v) {
                            if (v.length == 0) {
                              return 'Profession can\'t be empty';
                            } else {
                              return null;
                            }
                          },
                          keyboardType: TextInputType.text,
                        ),
                        SizedBox(height: 12,),
                        _isSaving
                          ? SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 3,
                            ),
                          )
                          : TextButton(
                            onPressed: () {
                              if (_formKey.currentState.validate()) {
                                setState(() {
                                  _isSaving = true;
                                });
                                runMutation({
                                  'name': _nameController.text.trim(),
                                  'profession': _professionController.text.trim(),
                                  'age': int.parse(_ageController.text.trim()),
                                });
                              }
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
              ),
              // Add Hobby
              Visibility(
                visible: _visable,
                child: Mutation(
                  options: MutationOptions(
                    document: gql(insertHobby()),
                    fetchPolicy: FetchPolicy.noCache,
                    onCompleted: (data) {
                      setState(() {
                        _isHobbySaving = false;
                      });
                    },
                  ),
                  builder: (runMutation, result) {
                    return Form(
                      key: _formHobbyKey,
                      child: Column(
                        children: [
                          SizedBox(height: 12,),
                          TextFormField(
                            controller: _hobbyTitleController,
                            decoration: InputDecoration(
                              labelText: 'Hobby Title',
                              fillColor: Colors.white,
                              border: OutlineInputBorder(
                                borderSide: BorderSide()
                              )
                            ),
                            validator: (v) {
                              if (v.length == 0) {
                                return 'Title can\'t be empty';
                              } else {
                                return null;
                              }
                            },
                            keyboardType: TextInputType.text,
                          ),
                          SizedBox(height: 12,),
                          TextFormField(
                            controller: _descriptionController,
                            decoration: InputDecoration(
                              labelText: 'Hobby Description',
                              fillColor: Colors.white,
                              border: OutlineInputBorder(
                                borderSide: BorderSide()
                              )
                            ),
                            validator: (v) {
                              if (v.length == 0) {
                                return 'Description can\'t be empty';
                              } else {
                                return null;
                              }
                            },
                            keyboardType: TextInputType.text,
                          ),
                          SizedBox(height: 12,),
                          _isHobbySaving
                            ? SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 3,
                              ),
                            )
                            : TextButton(
                              onPressed: () {
                                if (_formHobbyKey.currentState.validate()) {
                                  setState(() {
                                    _isHobbySaving = true;
                                  });
                                  runMutation({
                                    'title': _hobbyTitleController.text.trim(),
                                    'description': _descriptionController.text.trim(),
                                    'userId': _currentUserId,
                                  });
                                }
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
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}