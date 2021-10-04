import 'package:flutter/material.dart';
import 'package:flutter_graphql/screens/home_screen.dart';
import 'package:flutter_graphql/screens/udpate_user.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class UsersPage extends StatefulWidget {

  @override
  _UsersPageState createState() => _UsersPageState();
}

class _UsersPageState extends State<UsersPage> {
  List users = [];
  bool _isLoading = false;
  bool _isRemoveHobbies = false;
  bool _isRemovePosts = false;
  List hobbyDeleteIds = [];
  List postDeleteIds = [];

  String _query = """
    query {
      users {
        id
        name
        age
        profession
        posts {
          id
          comment
          userId
        }
        hobbies {
          id
          title
          userId
        }
      }
    }
  """;

  String removeUser () {
    return '''
      mutation RemoveUser (
        \$id: String!
      ) {
        RemoveUser (id: \$id) {
          name
        }
      }
    ''';
  }

  String removeHoddies () {
    return '''
      mutation RemoveHobbies (\$ids: [String]) {
        RemoveHobbies (ids: \$ids) {
          id
        }
      }
    ''';
  }

  @override
  Widget build(BuildContext context) {
    return Query(
      options: QueryOptions(
        document: gql(_query)
      ),
      builder: (result, {fetchMore, refetch}) {
        if (result.isLoading) {
          return Center(
            child: CircularProgressIndicator()
          );
        }

        users = result.data['users'];

        return users.isNotEmpty ?
          ListView.builder(
            itemCount: users.length,
            itemBuilder: (context, index) {
              final user = users[index];

              return Stack(
                children: [
                  Container(
                    margin: EdgeInsets.only(bottom: 23, left: 10, right: 10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          offset: Offset(0, 10),
                          color: Colors.grey.shade300,
                          blurRadius: 30
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.all(20),
                    child: InkWell(
                      child: Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  '${user['name']}',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Row(
                                  children: [
                                    InkWell(
                                      child: Container(
                                        child: Icon(
                                          Icons.edit,
                                          color: Colors.greenAccent,
                                        ),
                                      ),
                                      onTap: () async {
                                        final route = MaterialPageRoute(
                                          builder: (context) {
                                            return UpdateUser(
                                              id: user['id'],
                                              name: user['name'],
                                              age: user['age'],
                                              profession: user['profession'],
                                            );
                                          },
                                        );
                                        await Navigator.push(context, route);
                                      },
                                    ),
                                    Mutation(
                                      options: MutationOptions(
                                        document: gql(removeUser()),
                                        onCompleted: (data) {
                                          setState(() {
                                            _isLoading = false;
                                          });
                                        },
                                      ),
                                      builder: (runMutation, result) {
                                        return Padding(
                                          padding: const EdgeInsets.all(8),
                                          child: InkWell(
                                            child: Container(
                                              child: Icon(
                                                Icons.delete_forever,
                                                color: Colors.redAccent,
                                              ),
                                            ),
                                            onTap: () async {
                                              hobbyDeleteIds.clear();
                                              postDeleteIds.clear();

                                              for (var i = 0; i < user["hobbies"].length; i++) {
                                                hobbyDeleteIds.add(user["hobbies"][i]["id"]);
                                              }

                                              for (var i = 0; i < user["posts"].length; i++) {
                                                postDeleteIds.add(user["posts"][i]["id"]);
                                              }

                                              setState(() {
                                                _isRemoveHobbies = true;
                                                _isRemovePosts = true;
                                              });

                                              // print('Hobby ${hobbyDeleteIds.toString()}');
                                              // print('Post ${postDeleteIds.toString()}');
                                              runMutation({
                                                'id': user['id'],
                                              });
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
                                          ),
                                        );
                                      },
                                    ),
                                    _isRemoveHobbies
                                      ? Mutation(
                                        options: MutationOptions(
                                          document: gql(removeHoddies()),
                                          onCompleted: (data) {
                                            print(data);
                                          },
                                        ),
                                        builder: (runMutation, result) {
                                          if (hobbyDeleteIds.isNotEmpty) {
                                            try {
                                              runMutation({
                                                'ids': hobbyDeleteIds,
                                              });
                                            } catch (e) {
                                              print(e);
                                            }
                                          }
                                          return Container();
                                        },
                                      )
                                      : Container()
                                  ],
                                )
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 8, left: 8),
                              child: Text('Occupation: ${user['profession'] ?? '-' }')
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 8, left: 8),
                              child: Text('Age: ${user['age'] ?? '-' }')
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              );
            },
          ) :
          Container(
            child: Center(
              child: Text(
                'No items found',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          );
      },
    );
  }
}