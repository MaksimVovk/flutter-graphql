import 'package:flutter/material.dart';

class DetailsPage extends StatefulWidget {
  final dynamic user;

  DetailsPage({ this.user });

  @override
  _DetailsPageState createState() => _DetailsPageState();
}

  enum Lists {
    Hobbies,
    Posts,
  }

class _DetailsPageState extends State<DetailsPage> {
  Lists list = Lists.Hobbies;

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
                      list = Lists.Hobbies;
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
                    list = Lists.Posts;
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
        ],
      ),
    );
  }
}