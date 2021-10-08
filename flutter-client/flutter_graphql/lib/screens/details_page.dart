import 'package:flutter/material.dart';

class DetailsPage extends StatefulWidget {
  final dynamic user;

  DetailsPage({ this.user });

  @override
  _DetailsPageState createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  List _hobbies = [];
  List _posts = [];
  bool _isHobby = false;
  bool _isPost = false;

  void _togglePostBtn () {
    setState(() {
      _isPost = true;
      _isHobby = false;
    });
  }
  void _toggleHobbyBtn () {
    setState(() {
      _isPost = false;
      _isHobby = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          widget.user['name'],
          style: TextStyle(
            color: Colors.grey,
            fontSize: 19,
            fontWeight: FontWeight.bold,
          )
        ),
      ),
      body: Column(
        children: [
          Flexible(
            flex: 1,
            fit: FlexFit.loose,
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
                  )
                ]
              ),
              child: Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${widget.user['name'].toUpperCase() ?? 'N/A'}',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8, left: 8),
                      child: Text('Occupations: ${widget.user['profession'] ?? 'N/A'}')
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: Text('Occupations: ${widget.user['age'] ?? 'N/A'}')
                    ),
                  ],
                ),
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Flexible(
                flex: 1,
                fit: FlexFit.loose,
                child: TextButton(
                  onPressed: () {
                    setState(() {
                      _toggleHobbyBtn();
                      _hobbies = widget.user['hobbies'];
                    });
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 12),
                    child: Text(
                      'Hobbies',
                      style: TextStyle(
                        color: Colors.blueGrey,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(
                      Colors.greenAccent,
                    )
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  setState(() {
                    _togglePostBtn();
                    _posts = widget.user['posts'];
                  });
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 12),
                  child: Text(
                    'Posts',
                    style: TextStyle(
                      color: Colors.blueGrey,
                      fontSize: 16
                    ),
                  ),
                ),
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(
                    Colors.greenAccent,
                  )
                ),
              )
            ],
          ),
          Visibility(
            visible: _isHobby || _isPost,
            child: Container(
              height: MediaQuery.of(context).size.height * .45,
              child: ListView.builder(
                itemCount: _isHobby ? _hobbies.length : _posts.length,
                itemBuilder: (context, index) {
                  var data = _isHobby ? _hobbies[index] : _posts[index];

                  return Stack(
                    children: [
                      Container(
                        margin: const EdgeInsets.only(bottom: 23, left: 10, right: 10, top: 20),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              offset: Offset(0, 10),
                              color: Colors.grey.shade300,
                              blurRadius: 30,
                            ),
                          ],
                        ),
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                if (_isHobby)
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text('Title: ${data['title']}'),
                                      Padding(
                                        padding: const EdgeInsets.only(top: 8, left: 10),
                                        child: Text('Description: ${data['description']}')
                                      )
                                    ]
                                  )
                                else
                                  Text('${data['comment']}'),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8),
                              child: Text(
                                'Author: ${widget.user['name'].toString()}',
                                style: TextStyle(fontStyle: FontStyle.italic),
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  );
                },
              ),
            )
          )
        ],
      ),
    );
  }
}