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

  LoaderPanel({Key? key,this.sname}) : super(key: key);
  String? sname = '';

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
              stream: FirebaseFirestore.instance.collection('testradio').where('userName',isEqualTo: sname).snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                final docs = snapshot.data!.docs;
                return ListView.builder(
                  itemCount: docs.length,
                  itemBuilder: (context, index) {
                    return PostElement(
                      userName: docs[index]['userName'],
                      description: docs[index]['description'],
                      rate: docs[index]['rate'],
                      image: docs[index]['image'],
                      timestamp: docs[index]['timestamp'],
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
  const PostElement({Key? key, this.userName, this.description,this.rate,this.image,this.timestamp})
      : super(key: key);

  final String? userName;
  final String? description;
  final String? rate;
  final String? image;
  final Timestamp? timestamp;

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
    return Column(
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


        //////////////////////////////////////////////////////////////////////////////
        Container(
          child:
          //'Rate.Good'== widget.rate ?
          Column(
            children: [

              ListTile(

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
              ListTile(
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
    );
  }
}


