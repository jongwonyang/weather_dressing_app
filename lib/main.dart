import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'styles.dart';
import 'HomePage.dart';
import 'forecast.dart';
import 'package:provider/provider.dart';
import 'package:flutter_keyboard_size/flutter_keyboard_size.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (BuildContext context) => DailyForecast(),
      builder: (context, child) => MaterialApp(
        title: 'My App',
        theme: ThemeData(
          primaryColor: Color(0xff4055f2),
          fontFamily: 'LexendDeca',
        ),
        home: MyHomePage(),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return KeyboardSizeProvider(
      child: DefaultTabController(
        length: 2,
        child: Scaffold(
          backgroundColor: Color(0xff4055f2),
          body: Padding(
            padding: const EdgeInsets.only(top: 140),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.sunny, size: 35, color: Colors.white),
                        Text('  기온별 옷차림',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30, color: Colors.white, fontFamily: 'LG'),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(
                  height: 30,
                ),
                TabBar(
                  indicatorColor: Colors.white,
                  tabs: [
                    Container(
                      height: 50,
                      alignment: Alignment.center,
                      child: Text('Sign In',
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                    Container(
                      height: 50,
                      alignment: Alignment.center,
                      child: Text('Sign Up',
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                  ],
                ),
                Expanded(
                  child: TabBarView(
                    children: [
                      Tab(
                        child: LoginForm(),
                      ),
                      Tab(
                        child: RegisterForm(),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class LoginForm extends StatefulWidget {
  const LoginForm({Key? key}) : super(key: key);

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _authentication = FirebaseAuth.instance;
  final _formKey = GlobalKey<FormState>();
  String email = '';
  String password = '';

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 30.0, right: 30.0, bottom: 30.0, top: 10.0),
      child: Form(
        key: _formKey,
        child: ListView(
          children: [
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Email Address',
                hintText: 'Enter your email...',
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.transparent,
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                filled: true,
                fillColor: Colors.white,
              ),
              onChanged: (value) {
                email = value;
              },
            ),
            const SizedBox(
              height: 20,
            ),
            TextFormField(
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Password',
                hintText: 'Enter your password...',
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.transparent,
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                filled: true,
                fillColor: Colors.white,
              ),
              onChanged: (value) {
                password = value;
              },
            ),
            const SizedBox(
              height: 40,
            ),
            SizedBox(
              width: 150,
              height: 50,
              child: ElevatedButton(
                child: Text('Sign In',
                    style: TextStyle(fontSize: 20, color: AppColor.bluePruple, fontFamily: 'Laxend Deca')
                ),
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    elevation: 0.0
                ),
                onPressed: () async {
                  try{
                    final currentUser = await _authentication.signInWithEmailAndPassword(email: email, password: password);
                    if (currentUser.user != null) {
                      _formKey.currentState!.reset();
                      if (!mounted) return;
                      Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage()));
                    }
                  } catch (e) {
                    print(e);
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class RegisterForm extends StatefulWidget {
  const RegisterForm({Key? key}) : super(key: key);

  @override
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final _authentication = FirebaseAuth.instance;
  final _formKey = GlobalKey<FormState>();
  String email = '';
  String password = '';

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 30.0, right: 30.0, bottom: 30.0, top: 10.0),
      child: Form(
        key: _formKey,
        child: ListView(
          children: [
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Email Address',
                hintText: 'Enter your email...',
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.transparent,
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                filled: true,
                fillColor: Colors.white,
              ),
              onChanged: (value) {
                email = value;
              },
            ),
            const SizedBox(
              height: 20,
            ),
            TextFormField(
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Password',
                hintText: 'Enter your password...',
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.transparent,
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                filled: true,
                fillColor: Colors.white,
              ),
              onChanged: (value) {
                password = value;
              },
            ),
            const SizedBox(
              height: 40,
            ),
            SizedBox(
              width: 20,
              height: 50,
              child: ElevatedButton(
                child: Text('Create Account',
                    style: TextStyle(fontSize: 20, color: AppColor.bluePruple, fontFamily: 'LexendDeca')),
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    elevation: 0.0),
                onPressed: () async {
                  try {
                    final newUser =
                    await _authentication.createUserWithEmailAndPassword(
                        email: email, password: password);
                    if (newUser.user != null) {
                      _formKey.currentState!.reset();
                      if (!mounted) return;
                      _showdialog(context);
                    }
                  } catch (e) {
                    print(e);
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Future<dynamic> _showdialog(BuildContext context) {
  return showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: Text('Successful Register'),
        content: Text('Return to LogIn Page'),
        actions: [
          ElevatedButton(
            child: Text('OK',
                style: TextStyle(fontSize: 15, color: AppColor.bluePruple)),
            style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                elevation: 0.0),
            onPressed: () {
              // Navigator.of(context).popUntil((route) => route.isFirst);
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => MyHomePage()));
            },
          )
        ],
      )
  );
}