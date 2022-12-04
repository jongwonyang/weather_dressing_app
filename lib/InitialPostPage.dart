// 플로팅 버튼 클릭시 게시물 생성하는 빈 페이지
//colletion name => records로 사용중
//지금은 로그인중인 userName도 저장해서 LoaderPage에서 이를 비교하여 찾고있음
//Tab2에서 id값 넘겨받으면 userName대신 id값으로 세팅해야함
//LoaderPanel(sname: userName) 형식으로 호출.

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter_firebase/FilterMessagePage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:team_project1/LoaderPage.dart';
import 'package:team_project1/forecast.dart';

class TestPage extends StatefulWidget {
  const TestPage({Key? key}) : super(key: key);

  @override
  State<TestPage> createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {
  final _authentication = FirebaseAuth.instance;

  User? loggedUser;



  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  void getCurrentUser() {
    try {
      final user = _authentication.currentUser;
      if (user != null) {
        loggedUser = user;
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('새 일기'),
      ),
      // body: Column(
      //   children: [
      //     Expanded(
      //       child: StreamBuilder(
      //         stream: FirebaseFirestore.instance.collection('chat').orderBy('timestamp').snapshots(),
      //         builder: (context, snapshot) {
      //           if (snapshot.connectionState == ConnectionState.waiting) {
      //             return const Center(child: CircularProgressIndicator());
      //           }
      //           final docs = snapshot.data!.docs;
      //           return ListView.builder(
      //             itemCount: docs.length,
      //             itemBuilder: (context, index) {
      //               return ChatElement(
      //                 isMe: docs[index]['uid'] == _authentication.currentUser!.uid,
      //                 userName: docs[index]['userName'],
      //                 text: docs[index]['text'],
      //               );
      //             },
      //           );
      //         },
      //       ),
      //     ),
      //     NewMessage(),
      //   ],
      // ),
      body: SingleChildScrollView(
        child: Container(child: const NewMessage()),
      ),


    );
  }
}


enum Rate { Good, Bad }
class NewMessage extends StatefulWidget {
  const NewMessage({Key? key}) : super(key: key);

  @override
  State<NewMessage> createState() => _NewMessageState();
}

class _NewMessageState extends State<NewMessage> {


  // var hour = DateTime.now().hour*100+100;
  // var temperature = context.watch<DailyForecast>().dataList[hour];

  //////////
  final _controller = TextEditingController();
  String newMessage = '';
  Rate? _rate = Rate.Good; //default




  File? _image;
  final _picker = ImagePicker();

  //List<XFile> _pickedImgs = [];

  Future _getImage(ImageSource imageSource) async{
    //final List<XFile>? images = await _picker.pickMultiImage();

    final image = await _picker.pickImage(source: imageSource);

    setState(() {
      _image = File(image!.path);
    });


  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          SizedBox(height: 5.0,),
          Container(
            color: const Color(0xffd0cece),
            width: MediaQuery.of(context).size.width,
            height: 250,
            //height: MediaQuery.of(context).size.width,
            child: Center(
                child: _image ==null
                //? Text('No image')
                    ? IconButton(
                    onPressed: (){
                      _getImage(ImageSource.gallery);
                    },
                    icon: Container(
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Colors.green.withOpacity(0.5),shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.add_a_photo,
                      ),

                    )
                )
                    : Image.file(File(_image!.path))
              //: Text(File(_image!.path).toString())

            ),



          ),

          SizedBox(height: 5.0,),
          Container(

            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.black12,width: 2),

            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 25.0,),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [

                    Text('최고기온 : ',style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold),),
                    Text(context.watch<DailyForecast>().dataList[(DateTime.now().hour * 100+100)]!.tmx.toString()),
                    //Text((DateTime.now().hour * 100).toString()),
                    SizedBox(width: 25.0,),
                    Text('최저기온 : ',style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold),),
                    Text(context.watch<DailyForecast>().dataList[(DateTime.now().hour * 100+100)]!.tmn.toString()),

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

          SizedBox(height: 15.0,),





          Row(
            children: [
              Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(0.0),
                    child: TextField(
                      controller: _controller,
                      decoration: InputDecoration(
                          labelText: 'New Message',
                        contentPadding: const EdgeInsets.symmetric(vertical: 40,horizontal: 15),
                        hintText: 'Enter your comment..',
                        border: OutlineInputBorder(
                          borderSide: const BorderSide(
                            color: Colors.black12,
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(8.0),

                        ),


                      ),
                      onChanged: (value) {
                        setState(() {
                          newMessage = value;
                        });
                      },
                    ),



                    // child:TextFormField(
                    //   //obscureText: true,
                    //   decoration: InputDecoration(
                    //
                    //
                    //     contentPadding: const EdgeInsets.symmetric(vertical: 40),
                    //     hintText: 'Enter your comment..',
                    //     enabledBorder: OutlineInputBorder(
                    //       borderSide: BorderSide(
                    //         color: Colors.black12,
                    //         width: 2,
                    //       ),
                    //       borderRadius: BorderRadius.circular(8.0),
                    //     ),
                    //     filled: true,
                    //     fillColor: Colors.white,
                    //   ),
                    //   onChanged: (value) {
                    //     newMessage = value;
                    //   },
                    // ),
                  )),



              // IconButton(
              //     color: Colors.blue,
              //     onPressed: newMessage.trim().isEmpty
              //         ? null
              //         : () async {
              //       final currentUser = FirebaseAuth.instance.currentUser;
              //       final currentUserEmail = FirebaseAuth.instance.currentUser?.email;
              //       print(currentUserEmail);
              //
              //       FirebaseFirestore.instance.collection('testradio').add({
              //         'description': newMessage,
              //         'user':currentUserEmail,
              //
              //         'timestamp': Timestamp.now(),
              //         'uid': currentUser!.uid,  //uid ==user
              //         'rate':_rate.toString(),
              //         'image':_image.toString() ,
              //
              //       });
              //       _controller.clear();
              //     },
              //     icon: const Icon(Icons.send)),
            ],
          ),
          SizedBox(height: 35.0,),
          ButtonTheme(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10)),
            child: ElevatedButton(
              onPressed: newMessage.trim().isEmpty
                ? null
                    : () async {
                final currentUser = FirebaseAuth.instance.currentUser;
                final currentUserEmail = FirebaseAuth.instance.currentUser?.email;
                final maxtemp = context.read<DailyForecast>().dataList[(DateTime.now().hour * 100+100)]!.tmx;
                final mintemp = context.read<DailyForecast>().dataList[(DateTime.now().hour * 100+100)]!.tmn;
                print(currentUserEmail);

                var tempcode =0;
                final avgtemp = (maxtemp + mintemp)/2;

                if (avgtemp<=0){
                  tempcode=1;
                } else if(avgtemp>0 && avgtemp<=9){
                  tempcode=2;
                } else if(avgtemp>=10 && avgtemp<=11){
                  tempcode=3;
                }  else if(avgtemp>=12 && avgtemp<=16){
                  tempcode=4;
                } else if(avgtemp>=17 && avgtemp<=19){
                  tempcode=5;
                } else if(avgtemp>=20 && avgtemp<=22){
                  tempcode=6;
                } else if(avgtemp>=23 && avgtemp<=26){
                  tempcode=7;
                } else if(avgtemp>=27){
                  tempcode=8;
                } else{
                  tempcode=999;
                }


                FirebaseFirestore.instance.collection('records').add({
                'description': newMessage,
                'user':currentUserEmail,

                'timestamp': Timestamp.now(),
                'uid': currentUser!.uid,  //uid ==user
                'rate':_rate.toString(),
                'image':_image.toString() ,
                  'maxtemp':maxtemp.toString(),

                  'mintemp':mintemp.toString(),
                  'tempcode':tempcode,

                });
                _controller.clear();
                Navigator.pop(context);
                },
              child: Text(
                '게시',
                style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white),
              ),

            ),
          ),





        ],
      ),
    );
  }
}



class RadioButtonWidget extends StatefulWidget {
  const RadioButtonWidget({Key? key}) : super(key: key);

  @override
  State<RadioButtonWidget> createState() => _RadioButtonWidgetState();
}

/// This is the private State class that goes with MyStatefulWidget.
class _RadioButtonWidgetState extends State<RadioButtonWidget> {

  Rate? _rate = Rate.Good; //default

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
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
        // ListTile(
        //   title: const Text('Pear'),
        //   leading: Radio<Rate>(
        //     value: Rate.Pear,
        //     groupValue: _rate,
        //     onChanged: (Rate? value) {
        //       setState(() {
        //         _rate = value;
        //       });
        //     },
        //   ),
        // ),

      ],
    );
  }
}

/////////////////////////////////////////////////////////////////////////////////////////
