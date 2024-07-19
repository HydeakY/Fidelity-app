import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:fidelity/providers/auth.dart';
import 'package:fidelity/services/environement.dart';
import 'package:fidelity/services/update_apk.dart';
import 'package:fidelity/providers/users.dart';
import 'package:fidelity/view_model/company_details_vm.dart';
import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart' as screen_util;
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:provider/provider.dart';
import 'package:package_info/package_info.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:fidelity/widgets/loginWidgets/custom_button.dart';
import 'package:fidelity/widgets/loginWidgets/custom_input_text.dart';
import 'package:fidelity/const/color.dart';


var session = SessionManager();

var logger = Logger(
  printer: PrettyPrinter(),
);
autoComplet() async {
  String? username = await session.get("username");
  String? password = await session.get("password");
  if (username != null && password != null) {
    return {"username": username, "password": password};
  }
  return false;
}

class Login extends StatefulWidget {
  const Login({super.key});
  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();
  String version = "Chargement en cours...";

  bool emailBool = false;
  bool passwordBool = false;
  bool remember = false;

  String error = "";

  @override
  void initState() {
    super.initState();
    getVersion();
    autoComplet().then((i) {
      if (i == false) return;
      setState(() {
        email.text = i["username"];
        password.text = i["password"];
        emailBool = true;
        passwordBool = true;
        remember = true;
      });
    });
  }

  Future<void> getVersion() async {
    try {
      PackageInfo packageInfo = await PackageInfo.fromPlatform();
      setState(() {
        version = packageInfo.version;
      });
    } catch (e) {
      logger.d("Erreur lors de la récupération de la version : $e");
    }
  }
  
  void switchEnvironment() {
    setState(() {
      final currentEnvironment = dotenv.get('ENVIRONMENT');
      final newEnvironment = (currentEnvironment == 'DEV') ? 'PREPROD' : 'DEV';
      dotenv.env['ENVIRONMENT'] = newEnvironment;
    });
  }

  bool _passwordVisible = false;

  @override
  Widget build(BuildContext context) {

    final company = Provider.of<CompanyDetailsVM>(context);
    final users = Provider.of<Users>(context);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(20.0),
              height: MediaQuery.of(context).size.height - 70,
              width: MediaQuery.of(context).size.width,
              color: Colors.white,
              child: SizedBox(
                width: 200.0,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      height: 111,
                      width: 333,
                      decoration: const BoxDecoration(
                        image: DecorationImage(image: AssetImage("assets/images/2s_pos_long.jpg"), fit: BoxFit.cover),
                      ),
                    ),
                    SizedBox(
                      child: Text(
                        error,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.redAccent,
                          fontSize: 18.0,
                          fontWeight: FontWeight.w400,
                          letterSpacing: 2.0,
                        ),
                      ),
                    ),
                    const SizedBox(height: 35.0),
                    SizedBox(
                      width: 500.0,
                      child: Form(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            CustomInputText(
                              controller: email,
                              labelText: 'E-mail',
                              hintText: 'Ex: john.doe@mail.com',
                              suffix: const Icon(Icons.mail_rounded),
                              onChange: (val) {
                                setState(() {
                                  emailBool = EmailValidator.validate(val);
                                });
                              },
                            ),
                            const SizedBox(height: 30.0),
                            CustomInputText(
                              controller: password,
                              labelText: 'Mot de passe',
                              hintText: 'Ex: F7klm13',
                              obscureText: _passwordVisible ? false : true,
            
                              suffix: IconButton(
                                onPressed: () {
                                  setState(() {
                                    _passwordVisible = !_passwordVisible;
                                  });
                                },
                                icon: _passwordVisible ? const Icon(Icons.visibility) : const Icon(Icons.visibility_off),
                              ),
                              onChange: (val) {
                                setState(() {
                                  passwordBool = validatePassword(val);
                                });
                              },
                            ),
                            const SizedBox(height: 15.0),
                            Row(
                              children: [
                                const Text("Se souvenir de moi"),
                                Checkbox(
                                  checkColor: Colors.white,
                                  value: remember,
                                  onChanged: (bool? value) {
                                    setState(() => remember = value!);
                                  },
                                ),
                              ],
                            ),
                            const SizedBox(height: 15.0),
                            Row(
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: CustomButton(
                                    fontSize: 22,
                                    text: "connexion".toUpperCase(),
                                    bgColor: emailBool && passwordBool ? Colors.redAccent : Colors.grey,
                                    textColor: emailBool && passwordBool ? Colors.white : Colors.white54,
                                    onPress: emailBool && passwordBool
                                        ? () {
                                            connect(context, {
                                              "username": email.text,
                                              "password": password.text,
                                              "remember": remember,
                                            }, () async {
                                              String? eth0Address;
                                              String? wlan0Address;
                                              var ipv4Regex = r'^((25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$';
                                              for (var interface in await NetworkInterface.list()) {
                                                if (interface.name == "eth0") {
                                                  for (var addr in interface.addresses) {
                                                    if (RegExp(ipv4Regex).hasMatch(addr.address)) {
                                                      eth0Address = addr.address;
                                                      break;
                                                    }
                                                  }
                                                }
                                                if (interface.name == "wlan0") {
                                                  for (var addr in interface.addresses) {
                                                    if (RegExp(ipv4Regex).hasMatch(addr.address)) {
                                                      wlan0Address = addr.address;
                                                      break;
                                                    }
                                                  }
                                                }
                                              }
                                              if (eth0Address != null) {
                                                ipAddress = eth0Address;
                                              } else if (wlan0Address != null) {
                                                ipAddress = wlan0Address;
                                              }
            
                                              PackageInfo packageInfo = await PackageInfo.fromPlatform();
                                              version = packageInfo.version;
            
                                              final response = await updateApk(deviceType: DeviceType.productionScreen, versionApp: version);
                                              if (response["status"] == true) {
                                                // ignore: use_build_context_synchronously
                                                updatePopup(
                                                  context: context,
                                                  url: response["url"],
                                                );
                                              }else{
                                                await company.fetchCompanyDetailsVM();
                                                await users.getUsers();
                                                Navigator.pushNamed(context, "/home");
                                              }
                                     
                                            }, (msg) {
                                              setState(() => error = msg);
                                            });
                                          }
                                        : null,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Version: $version'
                ),
                const SizedBox(
                  width: 25,
                ),
                if( environement() == 'PREPROD')
                Text(
                  'Env: PREPROD',
                  style: TextStyle(
                    color: Colors.red[800]
                  ),
                ),
                if( environement() == 'DEV')
                Text(
                  'Env: DEV',
                  style: TextStyle(
                    color: Colors.red[800]
                  ),
                ),
                const SizedBox(
                  width: 25,
                ),
                IconButton(
                  onPressed: switchEnvironment,
                  icon: const FaIcon(FontAwesomeIcons.rotate, size: 16, color: bodyBk),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}

bool validatePassword(String value) {
  return true;
}

Future connect(context, obj, resolve, reject) async {
  try {
    final auth = Provider.of<Auth>(context, listen: false);
    String apiUrl = getApiUrl();

    final url = Uri.parse('$apiUrl/login_check');
    final headers = {'Content-Type': 'application/json'};
    final body = jsonEncode({"username": obj["username"], "password": obj["password"]});

    final response = await http.post(url, headers: headers, body: body);

    logger.d(response.statusCode);
    if (response.statusCode == 401) {
      return reject('E-mail ou mot de passe invalide.');
    }

    if (response.statusCode == 200) {
      var res = jsonDecode(response.body);
      logger.i(res);
      if (!res.containsKey('token')) return reject('Une erreur est survenue.');
      auth.setToken(res['token']);
      if (obj["remember"]) {
        await session.set("username", obj["username"]);
        await session.set("password", obj["password"]);
      }

      resolve();
    }
  } catch (error) {
    logger.i(error);
    return reject('Une erreur est survenue.$error');
  }
}

void updatePopup({required BuildContext context, required Uri url}) {
  showModalBottomSheet<void>(
    isDismissible: false,
    context: context,
    backgroundColor: const Color.fromARGB(77, 0, 0, 0),
    builder: (BuildContext context) {
      return GestureDetector(
        onTap: () {},
        child: Container(
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(22.0),
              topRight: Radius.circular(22.0),
            ),
            color: Colors.white,
          ),
          height: 222.h,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  "Une nouvelle mise à jour est disponnible",
                  style: TextStyle(fontSize: 22.sp),
                ),
                SizedBox(height: 50.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                        flex: 0,
                        child: SizedBox(
                          width: 200.w,
                          child: CustomButton(
                            onPress: () {
                              Navigator.pushNamedAndRemoveUntil(context, "/update", (route) => false, arguments: url);
                            },
                            bgColor: Colors.blueAccent,
                            textColor: Colors.white,
                            fontSize: 22.sp,
                            text: "Mettre à jour",
                          ),
                        ))
                  ],
                )
              ],
            ),
          ),
        ),
      );
    },
  );
}