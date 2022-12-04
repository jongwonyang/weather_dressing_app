//저장된 데이터 보여주는 페이지
//colletion name => testradio
//지금은 userName으로 compare해서 찾고있음 추후 id로 변경
//PostElement에서 id 추가해야함

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';

class LoaderPanel extends StatelessWidget {

  LoaderPanel({Key? key,this.postid}) : super(key: key);
  String? postid = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('LoaderPanel'),
      ),
      body: Column(
        children: [

          Expanded(
            child: StreamBuilder(
              //stream: FirebaseFirestore.instance.collection('testradio').where('docs[index].id',isEqualTo: postid).snapshots(),
              stream: FirebaseFirestore.instance.collection('records').where(FieldPath.documentId,isEqualTo: postid).snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                final docs = snapshot.data!.docs;
                return ListView.builder(
                  itemCount: docs.length,
                  itemBuilder: (context, index) {
                    return PostElement(
                      //userName: docs[index]['userName'],
                      description: docs[index]['description'],
                      rate: docs[index]['rate'],
                      image: docs[index]['image'],
                      timestamp: docs[index]['timestamp'],
                      maxtemp: docs[index]['maxtemp'],
                      mintemp: docs[index]['mintemp'],
                      
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

enum Rate { Good, Bad }

class PostElement extends StatefulWidget {
  const PostElement({Key? key, this.description,this.rate,this.image,this.timestamp,this.maxtemp,this.mintemp})
      : super(key: key);

  //final String? userName;
  final String? description;
  final String? rate;
  final String? image;
  final Timestamp? timestamp;
  final String? maxtemp;
  final String? mintemp;

  @override
  State<PostElement> createState() => _PostElementState();
}

class _PostElementState extends State<PostElement> {


  Rate? _rate;

  @override
  void initState() {
    // TODO: implement initState
    widget.rate =='Rate.Good' ?
    _rate = Rate.Good :
        _rate = Rate.Bad;
  }
  //Rate _rate = Rate(widget.rate.replaceAll("'", "")); //default
  //File _image = (widget.image!)

  //File? _image = File(widget.image!);
  


    @override
    Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          SizedBox(height: 5.0,),
      //////////////////////////////////////////////imageload ///////////////////////////////
          Container(
            color: const Color(0xffd0cece),
            width: MediaQuery.of(context).size.width,
            height: 250,
            //height: MediaQuery.of(context).size.width,
            child: Center(
                    child: Image.file(File(widget.image!.replaceAll("File:", "").replaceAll("'", "").trim())),
            ),

          ),

          SizedBox(height: 5.0,),
          //////////////////////////////////////////////////////////////////////////////
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.black12,width: 2),),
            child:
            //'Rate.Good'== widget.rate ?
            Column(

              mainAxisAlignment: MainAxisAlignment.center,
              children: [

                SizedBox(height: 25.0,),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [

                    Text('최고기온 : ',style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold),),
                    Text(widget.maxtemp!),
                    //Text((DateTime.now().hour * 100).toString()),
                    SizedBox(width: 25.0,),
                    Text('최저기온 : ',style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold),),
                    Text(widget.mintemp!)
                    //Text(context.watch<DailyForecast>().dataList[(DateTime.now().hour * 100)]!.tmn.toString()),
                  ],
                ),

                SizedBox(height: 8.0,),

                Row(
                  children: [
                    Expanded(
                      child: ListTile(
                        //ListTile - title에는 내용,
                        //leading or trailing에 체크박스나 더보기와 같은 아이콘을 넣는다.
                        title: const Text('Good'),
                        leading: Radio<Rate>(
                          value: Rate.Good,
                          groupValue: _rate,
                          onChanged: (Rate? value) {
                            setState(() {
                              _rate = value;
                            });
                          },
                        ),
                      ),
                    ),

                    Expanded(
                      child: ListTile(
                        title: const Text('Bad'),
                        leading: Radio<Rate>(
                          value: Rate.Bad,
                          groupValue: _rate,
                          onChanged: (Rate? value) {
                            setState(() {
                              _rate = value;
                            });
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),


          ),

          Row(
            children: [
              Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      widget.description!,
                      style:
                      TextStyle(color: Colors.black, fontSize: 20),
                    ),
                  )),

            ],
          ),

          Row(
            children: [
              Text(widget.timestamp!.toDate().toString().substring(0,10))
            ],
          )
        ],
      ),
    );
  }
}


