import 'package:fidelity/pages/home.dart';
import 'package:fidelity/pages/user_page.dart';
import 'package:fidelity/providers/auth.dart';
import 'package:fidelity/providers/user_info.dart';
import 'package:fidelity/services/update_apk.dart';
import 'package:fidelity/view_model/company_details_vm.dart';
import 'package:fidelity/view_model/device_config_vm.dart';
import 'package:fidelity/widgets/scanner.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:provider/provider.dart';
import 'package:fidelity/pages/login.dart';
import 'package:fidelity/const/date.dart';
import 'package:fidelity/providers/users.dart';

var session = SessionManager();
void main() async {
  try {
    await dotenv.load();
  } catch (e) {
    log.e('Error loading .env file: $e');
  }
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => Users()),
        ChangeNotifierProvider(create: (context) => UserInfo()),
        ChangeNotifierProvider(create: (context) => Auth()),
        ChangeNotifierProvider(create: (context) => CurrentTimeModel()),
        ChangeNotifierProvider(create: (context) => DeviceConfigVM()),
        ChangeNotifierProvider(create: (context) => CompanyDetailsVM())
      ],
      child: ScreenUtilInit(
        designSize: const Size(1080, 1920),
        minTextAdapt: true,
        splitScreenMode: true,
        child: MaterialApp(
          routes: {
            '/userPage': (context) => const UserPage(),
            '/login': (context) => const Login(),
            '/home': (context) => const Home(),
            'qrcodeScanner': (context) => const QrCodeScanner(),
            "/update": (context) => UpdateView(
              url: ModalRoute.of(context)!.settings.arguments,
            ),
          },
          home: const Login(),
          debugShowCheckedModeBanner: false,
        ),
      )
    );
  }
}