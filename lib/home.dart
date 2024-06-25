import 'dart:convert';

import "package:flutter/material.dart";
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final channel = WebSocketChannel.connect(
    Uri.parse('wss://ws-feed.pro.coinbase.com'),
  );

  Future<void> connect() async {
    channel.sink.add(
      jsonEncode(
        {
          "type": "subscribe",
          "channels": [
            {
              "name": "ticker",
              "product_ids": [
                "BTC-USD",
              ]
            }
          ]
        },
      ),
    );
    try {
      channel.stream.listen(
        (data) {
          print(data);
        },
        onError: (error) => print("Web Socket Error: $error"),
      );
    } on Exception catch (e) {
      print("Error: $e");
    }
  }

  Future<void> disconnect() async {
    channel.sink.close();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text("Web Socket", style: TextStyle(color: Colors.white))),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image(
                image: AssetImage("assets/currency.png"),
                fit: BoxFit.contain,
                height: 120),
            StreamBuilder(
              stream: channel.stream,
              builder: (context, snapshot) {
                /// We are waiting for incoming data data
                // if (snapshot.connectionState == ConnectionState.waiting) {
                //   return const Center(
                //     child: CircularProgressIndicator(),
                //   );
                // }
                /// We have an active connection and we have received data
                if (snapshot.connectionState == ConnectionState.active &&
                    snapshot.hasData) {
                  Map myMap = json.decode(snapshot.data);
                  return Column(
                    children: [
                      Text(
                        '\$ ${myMap["price"]}',
                        style: TextStyle(
                          fontSize: 24.0,
                          color: Colors.white70,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  );
                }

                /// When we have closed the connection
                if (snapshot.connectionState == ConnectionState.done) {
                  return const Center(
                    child: Text(
                      'Disconnected!',
                      style: TextStyle(
                        color: Colors.red,
                      ),
                    ),
                  );
                }

                /// For all other situations, we display a simple "No data"
                /// message
                return const Center(
                  child: Text('No data'),
                );
              },
            ),
            SizedBox(height: 40),
            Container(
              width: 180,
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.deepPurple,
                      backgroundColor: Colors.white54,
                      side: BorderSide(color: Colors.deepPurple)),
                  onPressed: () {
                    connect();
                  },
                  child: Text("Connect")),
            ),
            Container(
              width: 180,
              child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.white54,
                      side: BorderSide(color: Colors.white54)),
                  onPressed: () {
                    disconnect();
                  },
                  child: Text("Disconnect")),
            )
          ],
        ),
      ),
    );
  }
}
