import 'package:fidelity/pages/main_page.dart';
import 'package:fidelity/view_model/company_details_vm.dart';
import 'package:fidelity/widgets/scanner.dart';
import 'package:flutter/material.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:logger/logger.dart';
import 'package:fidelity/const/color.dart';
import 'package:provider/provider.dart';

var session = SessionManager();

var logger = Logger(
  printer: PrettyPrinter(),
);

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  TextEditingController controller = TextEditingController();
  String searchText = "";
  
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // initializeData();
    });
  }

  bool afficherParametres = false;

  void refreshPage() {
    logger.d("Page refreshed");
    setState(() {
    });
  }

  void updateSearchText(String text) {
    setState(() {
      searchText = text;
      logger.d(text);
    });
  }

  @override
  Widget build(BuildContext context) {

    final companyDetails = Provider.of<CompanyDetailsVM>(context).companyVM;
    final companyImage = companyDetails?.image;

    return Column(
      children: [
        Container(
          width: MediaQuery.of(context).size.width,
          color: Colors.grey[200],
          child: Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Image.network(
              companyImage.toString(),
              width: 50,
              height: 50,
            ),
          ),
        ),
        Expanded(
          child: Scaffold(
            appBar: AppBar(
              toolbarHeight: 100,
              backgroundColor: Colors.grey[200],
              elevation: 0,
              iconTheme: const IconThemeData(color: bodyBk),
              title: Row(
                children: [
                  Expanded(
                    child: TextField(
                      cursorColor: Colors.black,
                      onChanged: updateSearchText,
                      controller: controller,
                      decoration: const InputDecoration(
                        labelText: 'Recherche',
                        hintText: 'Entrez votre recherche...',
                        prefixIcon: Icon(Icons.search),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(10.0),
                          ),
                          borderSide: BorderSide(color: Colors.black)
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 25,
                  ),
                  IconButton(
                    iconSize: 80,
                    icon: const Icon(Icons.qr_code_2_outlined),
                    onPressed: () async {
                      // await Navigator.pushNamed(context, "/userPage");
                      const QrCodeScanner();
                      Navigator.pushNamed(context, "qrcodeScanner");
                    },
                  ),
                ],
              ),
            ),
            drawer: Drawer(
              backgroundColor: bkColor,
              shadowColor: bkColor, 
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      const UserAccountsDrawerHeader(
                        decoration: BoxDecoration(
                          image: DecorationImage(image: AssetImage("assets/images/2s_pos_long.jpg"), fit: BoxFit.cover),
                        ),
                        accountEmail: Text(""),
                        accountName: Text("",
                            style: TextStyle(
                            )
                        ),
                      ),
          
                      ListTile(
                          title: const Text(
                            "Actualiser",
                            style: TextStyle(color: Colors.black, fontSize: 22, fontWeight: FontWeight.bold),
                          ),
                          leading: const Icon(
                            Icons.refresh,
                            size: 30,
                            color: Colors.black,
                          ),
                          onTap: () {
                            refreshPage();
                          }),
                      ListTile(
                          title: const Text(
                            "Se déconnecter",
                            style: TextStyle(color: Colors.black, fontSize: 22, fontWeight: FontWeight.bold),
                          ),
                          leading: const Icon(Icons.exit_to_app, size: 30, color: Colors.black),
                          onTap: () {
                            Navigator.pushReplacementNamed(context, "/login");
                          }),
                    ],
                  ),
                  Container(
                    margin:  const EdgeInsets.only(bottom: 12),
                    child:  Text("Version : $version", style: const TextStyle(fontSize: 16, color: Colors.white)),
                  )
                ],
              ),
            ),
          
            body: Padding(
              padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 0),
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                Expanded(child: MainPage(searchText: searchText)),
              ]),
            ),
          ),
        ),
      ],
    );
  }
}