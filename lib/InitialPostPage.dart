// 플로팅 버튼 클릭시 게시물 생성하는 빈 페이지
//colletion name => testradio로 사용중
//지금은 로그인중인 userName도 저장해서 LoaderPage에서 이를 비교하여 찾고있음
//Tab2에서 id값 넘겨받으면 userName대신 id값으로 세팅해야함
//LoaderPanel(sname: userName) 형식으로 호출.

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// import 'package:flutter_firebase/FilterMessagePage.dart';
import 'package:image_picker/image_picker.dart';

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
        title: const Text('Test'),
        actions: [
          // IconButton(
          //     onPressed: () {
          //       Navigator.push(
          //           context,
          //           MaterialPageRoute(
          //               builder: (context) => const FilterMessageForm()));
          //     },
          //     icon: const Icon(Icons.list)),

          IconButton(
              onPressed: () {
                FirebaseAuth.instance.signOut();
              },
              icon: const Icon(Icons.logout)),
        ],
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
      body: NewMessage(),


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
    return Column(
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



        ListTile(
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

        Row(
          children: [
            Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(labelText: 'New Message'),
                    onChanged: (value) {
                      setState(() {
                        newMessage = value;
                      });
                    },
                  ),
                )),
            IconButton(
                color: Colors.blue,
                onPressed: newMessage.trim().isEmpty
                    ? null
                    : () async {
                  final currentUser = FirebaseAuth.instance.currentUser;
                  final currentUserName = await FirebaseFirestore.instance
                      .collection('user')
                      .doc(currentUser!.uid)
                      .get();
                  FirebaseFirestore.instance.collection('testradio').add({
                    'description': newMessage,
                    'userName': currentUserName.data()!['userName'],
                    'timestamp': Timestamp.now(),
                    'uid': currentUser.uid,
                    'rate':_rate.toString(),
                    'image':_image.toString() ,

                  });
                  _controller.clear();
                },
                icon: const Icon(Icons.send)),
          ],
        ),





      ],
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

