import 'package:flutter/material.dart';

class Shop extends StatefulWidget {
  @override
  _ShopState createState() => _ShopState();
}

class _ShopState extends State<Shop> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Shop'),
      ),
      body: ListView.builder(
          itemCount: 10,
          itemBuilder: (context, index) {
            final urlImage = 'https://picsum.photos/id/$index/410/300';
            return InkWell(
              onTap: (){
                Navigator.of(context).pushNamed('/Item', arguments: urlImage);
              },
              child: Hero(
                tag: urlImage,
                child: Card(
                  color: Colors.grey[300],
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      children: <Widget>[
                        FadeInImage(
                          image: NetworkImage(
                              'https://picsum.photos/id/$index/400/300'),
                          placeholder:
                              AssetImage("lib/assets/images/loader.gif"),
                        ),
                        Text(
                          'imagen',
                          style: TextStyle(
                              fontSize: 25, fontStyle: FontStyle.italic),
                        ),
                        Text(
                          'descripcion imagen',
                          style: TextStyle(
                            fontSize: 15,
                          ),
                        ),
                        Text(
                          '\$ 100.00',
                          style: TextStyle(
                            fontSize: 15,
                          ),
                        ),
                      ],
                    ),
                  ),
                  elevation: 2.0,
                ),
              ),
            );
          }),
    );
  }
}
