import 'package:crypto_bazar/data/model/crypto.dart';
import 'package:crypto_bazar/screens/coin_list_screen.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.white10,
        body: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'کیریپتو بازار',
                style: TextStyle(
                    fontFamily: 'mr', fontSize: 40, color: Colors.white),
              ),
              SizedBox(height: 20),
              Image(
                image: AssetImage('assets/images/logo.png'),
              ),
              SpinKitThreeInOut(
                color: Colors.white,
                size: 30,
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> getData() async {
    var response = await Dio().get('https://api.coincap.io/v2/assets');
    List<Crypto> cryptolist = response.data['data']
        .map<Crypto>((jsonMapObject) => Crypto.fromMapJson(jsonMapObject))
        .toList();

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => coinListScreen(
          cryptoList: cryptolist,
        ),
      ),
    );
  }
}
