import 'package:flutter/material.dart';
import 'package:flutter_graphql/screens/home_screen.dart';
import 'package:flutter_graphql/styles/styles.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class UpdateUser extends StatefulWidget {
  final String id;
  final String name;
  final int age;
  final String profession;

  const UpdateUser({
    this.id,
    this.name,
    this.age,
    this.profession
  });

  @override
  _UpdateUserState createState() => _UpdateUserState();
}

class _UpdateUserState extends State<UpdateUser> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _ageController = TextEditingController();
  final _professionController = TextEditingController();

  bool _isSaving = false;

  String updateUser () {
    return '''
      mutation UpdateUser (
        \$id: String!,
        \$name: String!,
        \$profession: String!,
        \$age: Int!,
      ) {
        UpdateUser(id: \$id, name: \$name, profession: \$profession, age: \$age) {
          id
        }
      }
    ''';
  }

  @override
  void initState() {
    super.initState();

    _nameController.text = widget.name;
    _professionController.text = widget.profession;
    _ageController.text = widget.age.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'Update ${widget.name}',
          style: TextStyle(
            color: Colors.grey,
            fontSize: 19,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(24),
          margin: const EdgeInsets.symmetric(
            horizontal: 24,
            vertical: 6,
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.shade300,
                offset: Offset(0, 10),
                blurRadius: 30,
              )
            ]
          ),
          child: Column(
            children: [
              Mutation(
                options: MutationOptions(
                  document: gql(updateUser()),
                  fetchPolicy: FetchPolicy.noCache,
                  onCompleted: (data) async {
                    setState(() {
                      _isSaving = false;
                    });
                    final newRoute = MaterialPageRoute(
                      builder: (context) {
                        return HomeScreen();
                      },
                    );
                    await Navigator.pushAndRemoveUntil(context, newRoute, (route) => false);
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
                                  'id': widget.id,
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
                            style: buildButtonStyle(),
                          ),
                      ],
                    ),
                  );
                },
              ),
            ],
          )
        ),
      ),
    );
  }
}