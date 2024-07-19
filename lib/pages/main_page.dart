import 'package:fidelity/const/color.dart';
import 'package:fidelity/providers/users.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class MainPage extends StatefulWidget {

  final String searchText;

  const MainPage({Key? key, required this.searchText}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    final usersProvider = Provider.of<Users>(context);
    dynamic users = usersProvider.users;

    List filteredUsers = users.where((user) {
      String fullName = '${user['firstName']}';
      return fullName.toLowerCase().contains(widget.searchText.toLowerCase());
    }).toList();


    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: Padding(
        padding: const EdgeInsets.only(top: 5),
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    direction: Axis.vertical,
                    children: [
                      for (int i = 0; i < filteredUsers.length; i++)
                      Container(
                        width: 300,
                        height: 70,
                        decoration: BoxDecoration(
                          color: bkColor,
                          borderRadius: BorderRadius.circular(15)
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Icon(Icons.person_outline_sharp),
                              Column(
                                children: [
                                  Expanded(
                                    child: Text(
                                      users[i]['firstName']
                                    ),
                                  ),
                                  Expanded(
                                    child: Text(
                                      users[i]['lastName']
                                    ),
                                  ),
                                ],
                              ),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blueAccent,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)
                                  )
                                ),
                                onPressed: () async {
                                  await usersProvider.getOneUser(users[i]['uuid']);
                                  await Navigator.pushNamed(context, "/userPage");
                                },
                                child: const Row(
                                  children: [
                                    Icon(Icons.person_search_rounded, color: bkColor,),
                                    Text('Voir le profil', style: TextStyle(color: bkColor),),
                                  ],
                                )
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                Center(
                  child: SizedBox(
                    width: 400.sp,
                    child: const Divider(
                      thickness: 3,
                    )
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.resolveWith<Color>(
                          (Set<MaterialState> states) {
                            if (states.contains(MaterialState.pressed)) {
                              // Si le bouton est pressé
                              return Colors.grey; // Changez la couleur à verte
                            }
                            // Si le bouton est dans un autre état, par exemple en appuyant
                            return Colors.blueAccent; // Utilisez la couleur par défaut
                          },
                        ),
                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      onPressed: () {},
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.chevron_left, color: bkColor),
                          Text('Page Précédente', style: TextStyle(color: bkColor))
                        ],
                      )
                    ),
                    const SizedBox( width: 25),
                    ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.resolveWith<Color>(
                          (Set<MaterialState> states) {
                            if (states.contains(MaterialState.pressed)) {
                              // Si le bouton est pressé
                              return Colors.grey; // Changez la couleur à verte
                            }
                            // Si le bouton est dans un autre état, par exemple en appuyant
                            return Colors.blueAccent; // Utilisez la couleur par défaut
                          },
                        ),
                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      onPressed: () {},
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Page suivante', style: TextStyle(color: bkColor)),
                          Icon(Icons.chevron_right, color: bkColor)
                        ],
                      )
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}