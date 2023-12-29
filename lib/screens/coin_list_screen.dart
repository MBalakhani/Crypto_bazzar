import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:crypto_bazar/data/model/crypto.dart';

// ignore: must_be_immutable
class coinListScreen extends StatefulWidget {
  coinListScreen({super.key, this.cryptoList});
  List<Crypto>? cryptoList;
  @override
  State<coinListScreen> createState() => _coinListScreenState();
}

class _coinListScreenState extends State<coinListScreen> {
  List<Crypto>? cryptoList;
  bool isSerarchLoadingVisibel = false;
  @override
  void initState() {
    super.initState();
    cryptoList = widget.cryptoList;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(25, 170, 170, 170),
      appBar: AppBar(
        backgroundColor: Color.fromARGB(25, 67, 67, 67),
        title: Text(
          'کیریپتو بازار',
          style: TextStyle(
            fontFamily: 'mr',
            fontSize: 22,
          ),
        ),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Directionality(
                textDirection: TextDirection.rtl,
                child: TextField(
                  onChanged: (value) {
                    _filterList(value);
                  },
                  decoration: InputDecoration(
                    hintText: 'اسم رمز ارز خود را وارد کنید',
                    hintStyle: TextStyle(
                      fontFamily: 'mr',
                      color: Colors.black.withOpacity(.3),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(
                        style: BorderStyle.none,
                        width: 0,
                      ),
                    ),
                    filled: true,
                    fillColor: Colors.green,
                  ),
                ),
              ),
            ),
            Visibility(
              visible: isSerarchLoadingVisibel,
              child: Text(
                '...درحال دریافت اطلاعات رمز ارزها',
                style: TextStyle(
                  color: Colors.green,
                  fontFamily: 'mr',
                  fontSize: 13,
                ),
              ),
            ),
            Expanded(
              child: RefreshIndicator(
                backgroundColor: Colors.transparent,
                color: Colors.white,
                child: ListView.builder(
                  itemCount: cryptoList!.length,
                  itemBuilder: (context, index) {
                    return _getListTileItem(cryptoList![index]);
                  },
                ),
                onRefresh: () async {
                  List<Crypto> freshData = await _getData();
                  setState(() {
                    cryptoList = freshData;
                  });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _filterList(String EnterWord) async {
    if (EnterWord.isEmpty) {
      setState(() {
        isSerarchLoadingVisibel = true;
      });
      var result = await _getData();
      setState(() {
        cryptoList = result;
        isSerarchLoadingVisibel = false;
      });
      return;
    }
    List<Crypto> cryptoResultList = cryptoList!
        .where((element) =>
            element.name.toLowerCase().contains(EnterWord.toLowerCase()))
        .toList();
    setState(() {
      cryptoList = cryptoResultList;
    });
  }

  Widget _getListTileItem(Crypto crypto) {
    return ListTile(
      title: Text(
        crypto.name,
        style: TextStyle(color: Colors.white),
      ),
      subtitle: Text(
        crypto.symbol,
        style: TextStyle(color: Colors.grey),
      ),
      leading: SizedBox(
        width: 30,
        child: Center(
          child: Text(
            crypto.rank.toString(),
            style: TextStyle(color: Colors.grey),
          ),
        ),
      ),
      trailing: SizedBox(
        width: 150,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  crypto.priceUsd.toStringAsFixed(2),
                  style: TextStyle(color: Colors.grey, fontSize: 16),
                ),
                Text(
                  crypto.changePercent24hr.toStringAsFixed(2),
                  style: TextStyle(
                    color: _getColorChnageText(crypto.changePercent24hr),
                    fontSize: 13,
                  ),
                )
              ],
            ),
            SizedBox(
                width: 40,
                child: Center(
                  child: _getIconChangePercent(crypto.changePercent24hr),
                )),
          ],
        ),
      ),
    );
  }

  Future<List<Crypto>> _getData() async {
    var response = await Dio().get('https://api.coincap.io/v2/assets');
    List<Crypto> cryptolist = response.data['data']
        .map<Crypto>((jsonMapObject) => Crypto.fromMapJson(jsonMapObject))
        .toList();
    return cryptolist;
  }

  Widget _getIconChangePercent(double percentChange) {
    return percentChange <= 0
        ? Icon(
            Icons.trending_down,
            size: 24,
            color: Colors.red,
          )
        : Icon(
            Icons.trending_up,
            size: 24,
            color: Colors.green,
          );
  }

  Color _getColorChnageText(double percentChange) {
    return percentChange <= 0 ? Colors.red : Colors.green;
  }
}
