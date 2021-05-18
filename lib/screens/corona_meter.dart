import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

class Check extends StateNotifier<bool>{
  Check() : super(true);
  void toggle(){
    state = false;
  }

}

class FetchData{

  Future getData() async{
    final url = 'https://worldometers.p.rapidapi.com/api/coronavirus/world';
    http.Response response = await http.get(Uri.parse(url), headers: {
      "x-rapidapi-key": "c5661785b0mshb93d5e511ef7a09p1b1e59jsn85754919cb50",
    });
    return jsonDecode(response.body);
  }

  Future getDatas(String country) async{
    final url = 'https://worldometers.p.rapidapi.com/api/coronavirus/country/$country';
    http.Response response = await http.get(Uri.parse(url), headers: {
      "x-rapidapi-key": "c5661785b0mshb93d5e511ef7a09p1b1e59jsn85754919cb50",
    });
    return jsonDecode(response.body) ;
  }

}

final checkProvider = StateNotifierProvider<Check, bool>((ref) => Check());
final worldProvider = FutureProvider((ref) => FetchData().getData());
final countryProvider = FutureProvider.family((ref, String con) => FetchData().getDatas(con));

final _form = GlobalKey<FormState>();

class CoronaMeter extends StatefulWidget  {

  @override
  _CoronaMeterState createState() => _CoronaMeterState();
}

class _CoronaMeterState extends State<CoronaMeter> {
final textController = TextEditingController();

FocusNode focusNode;

@override
  void initState() {
    focusNode = FocusNode();
    super.initState();
  }

  @override
  void dispose() {
    focusNode.dispose();
    super.dispose();
  }
@override
  Widget build(BuildContext context) {


    return Scaffold(
      appBar: AppBar(
        title: Text('Corona Meter'),
      ),
      body:  Column(
              children: [
                Form(
                  key: _form,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 30, vertical: 20),
                        child: TextFormField(
                          focusNode: focusNode,
                          textInputAction: TextInputAction.done,
                            controller: textController,
                            decoration: InputDecoration(
                                labelText: 'Search with country name',
                                focusedBorder: OutlineInputBorder(),
                                enabledBorder: OutlineInputBorder()
                            )
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(right: 50),
                        alignment: Alignment.bottomRight,
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              minimumSize: Size(120, 50),
                            ),
                            onPressed: () {
                              _form.currentState.save();
                              context.read(checkProvider.notifier).toggle();
                              focusNode.unfocus();
                           Future.delayed(Duration(seconds: 2), (){
                             textController.clear();
                           });
                            }, child: Text('Search')
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 50,),
                Consumer(
                  builder: (context, watch, child) {
                    final check = watch(checkProvider);
                    final world = watch(worldProvider);
                    final con  = watch(countryProvider(textController.text.trim()));
                    return Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child:check ? world.maybeWhen(
                          data: (data){
                            return   Card(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Html(
                                  data: """ 
                                ${data['data']}
                                 """,
                                ),
                              ),
                            );
                          },
                          orElse: () => Text('Loading....')): con.maybeWhen(
                          data: (data){

                            return   Card(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Html(
                                  data: """ 
                                ${data['data']}
                                 """,
                                ),
                              ),
                            );
                          },
                          orElse: () => Text('Loading....'))
                    );
                  }
                ),
              ],
      )
    );
  }
}
