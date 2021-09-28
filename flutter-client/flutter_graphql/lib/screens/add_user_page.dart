import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class AddUserPage extends StatefulWidget {
  @override
  _AddUserPageState createState() => _AddUserPageState();
}

class _AddUserPageState extends State<AddUserPage> {
  final _formKey = GlobalKey<FormState>();

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
            color: Colors.grey,
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