import 'package:flutter/material.dart';
import 'package:flutter_graphql/screens/home_screen.dart';
import 'package:flutter_graphql/styles/styles.dart';
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

  final _formPostKey = GlobalKey<FormState>();
  final _postCommentController = TextEditingController();

  bool _isSaving = false;
  bool _isHobbySaving = false;
  bool _isPostSaving = false;
  bool _visible = false;

  String currentUserId;

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
    return '''
      mutation
        CreateHobby (
          \$title: String!,
          \$description: String!,
          \$userId: String!
        ) {
          CreateHobby (title: \$title, description: \$description, userId: \$userId) {
            id
            title
          }
        }
    ''';
  }

  String insertPost () {
    return '''
      mutation
        CreatePost (
          \$comment: String!,
          \$userId: String!,
        ) {
          CreatePost (comment: \$comment, userId: \$userId) {
            id
          }
        }
    ''';
  }

  void _toggle() {
    setState(() {
      _visible = !_visible;
    });
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
                      currentUserId = data['CreateUser']['id'];
                      print(currentUserId);
                      if (currentUserId.isNotEmpty) {
                        _toggle();
                      }
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
                                _nameController.clear();
                                _professionController.clear();
                                _ageController.clear();
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
                            style: buildButtonStyle(),
                          ),
                      ],
                    ),
                  );
                },
              ),
              // Add Hobby
              Visibility(
                visible: _visible,
                child: Column(
                  children: [
                    Mutation(
                      options: MutationOptions(
                        document: gql(insertHobby()),
                        fetchPolicy: FetchPolicy.noCache,
                        onCompleted: (data) {
                          print(data.toString());
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
                                        'title': _hobbyTitleController.text,
                                        'description': _descriptionController.text,
                                        'userId': currentUserId,
                                      });

                                      _hobbyTitleController.clear();
                                      _descriptionController.clear();
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
                                  style: buildButtonStyle()
                                ),
                            ],
                          ),
                        );
                      },
                    ),
                    Mutation(
                      options: MutationOptions(
                        document: gql(insertPost()),
                        fetchPolicy: FetchPolicy.noCache,
                        onCompleted: (data) {
                          print(data.toString());
                          setState(() {
                            _isPostSaving = false;
                          });
                        },
                      ),
                      builder: (runMutation, result) {
                        return Form(
                          key: _formPostKey,
                          child: Column(
                            children: [
                              SizedBox(height: 12,),
                              TextFormField(
                                controller: _postCommentController,
                                decoration: InputDecoration(
                                  labelText: 'Post Comment',
                                  fillColor: Colors.white,
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide()
                                  )
                                ),
                                validator: (v) {
                                  if (v.length == 0) {
                                    return 'Comment can\'t be empty';
                                  } else {
                                    return null;
                                  }
                                },
                                keyboardType: TextInputType.text,
                              ),
                              SizedBox(height: 12,),
                              _isPostSaving
                                ? SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 3,
                                  ),
                                )
                                : TextButton(
                                  onPressed: () {
                                    if (_formPostKey.currentState.validate()) {
                                      setState(() {
                                        _isPostSaving = true;
                                      });
                                      runMutation({
                                        'comment': _postCommentController.text,
                                        'userId': currentUserId,
                                      });
                                      _postCommentController.clear();
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
                                  style: buildButtonStyle(),
                                ),
                            ],
                          ),
                        );
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.all(18),
                      child: TextButton(
                        onPressed: () {
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (context) {
                                return HomeScreen();
                              },
                            ),
                            (route) => false
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 12),
                          child: Text(
                            'Done',
                            style: TextStyle(
                              color: Colors.blueGrey,
                              fontSize: 16,
                            ),
                          )
                        ),
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                            Colors.greenAccent
                          )
                        ),
                      ),
                    ),
                  ]
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}