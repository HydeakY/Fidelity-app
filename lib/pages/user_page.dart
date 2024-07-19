import 'package:fidelity/const/color.dart';
import 'package:fidelity/providers/users.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';


class UserPage extends StatefulWidget {
  const UserPage({super.key});

  @override
  State<UserPage> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {

  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {

    String addSpacesEveryTwoChars(String input) {
    StringBuffer output = StringBuffer();
    for (int i = 0; i < input.length; i += 2) {
      output.write(input.substring(i, i + 2));
      if (i + 2 < input.length) {
        output.write(' ');
      }
    }
      return output.toString();
    }

    String replaceCharsAtIndices(String input, String newChar, List<int> indices) {
      StringBuffer output = StringBuffer();
      for (int i = 0; i < input.length; i++) {
        if (indices.contains(i)) {
          output.write(newChar);
        } else {
          output.write(input[i]);
        }
      }
      return output.toString();
    }

    final user = Provider.of<Users>(context).currentUser;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.grey[200],
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          children: [
            Row(
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)
                    )
                  ),
                  onPressed: () async {
                    Navigator.pushNamed(context, "/home");
                  },
                  child: const Row(
                    children: [
                      Icon(Icons.arrow_back, color: bkColor,),
                      SizedBox(
                        width: 5,
                      ),
                      Text('Retour', style: TextStyle(color: bkColor),)
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Center(
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20)
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: Text(
                                "${user['firstName']} ${user['lastName']}".toUpperCase(),
                                style: const TextStyle(
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold
                                ),
                              ),
                            ),
                          ),
                        ),
                        Center(
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20)
                            ),
                            child: QrImageView(
                              data: user['qrCode'],
                              version: QrVersions.auto,
                              size: 150,
                            ),
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20)
                          ),
                          width: MediaQuery.of(context).size.width,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 260),
                            child: Column(
                              children: [
                                const Row(
                                  children: [
                                    Text(
                                      'Informations',
                                      style: TextStyle(
                                        fontSize: 24
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  children: [
                                    const Icon(Icons.person),
                                    const SizedBox(width: 10),
                                    Text("${user['firstName']} ${user['lastName']}")
                                  ],
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  children: [
                                    const Icon(FontAwesomeIcons.envelope, size: 20,),
                                    const SizedBox(width: 10),
                                    Text(user['email']),
                                  ],
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  children: [
                                    const Icon(FontAwesomeIcons.phone, size: 18,),
                                    const SizedBox(width: 10),
                                    Text(addSpacesEveryTwoChars(user['phone'].toString())),
                                  ],
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  children: [
                                    const Icon(FontAwesomeIcons.cakeCandles, size: 20,),
                                    const SizedBox(width: 10),
                                    Text(replaceCharsAtIndices(user['birthday'], '/', [2, 5])),
                                  ],
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                              ],
                            ),
                          ),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20)
                          ),
                          child: Column(
                            children: [
                              const SizedBox(
                                height: 20,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(FontAwesomeIcons.coins, size: 20,),
                                  const SizedBox(width: 15),
                                  Text(user['rewardsPoint'].toString()),
                                ],
                              ),
                              const SizedBox(height: 20),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.blueAccent,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10)
                                      )
                                    ),
                                    onPressed: () {
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {

                                          final userProvider = Provider.of<Users>(context);

                                          return AlertDialog(
                                            title: const Center(
                                              child: Text(
                                                'Ajouter des points de fidélité'
                                              )
                                            ),
                                            content: TextField(
                                              focusNode: _focusNode,
                                              controller: _controller,
                                              decoration: InputDecoration(
                                                labelText: 'Entrez le nombre de points a ajouter',
                                                border: OutlineInputBorder(
                                                  borderRadius: BorderRadius.circular(20),
                                                  borderSide: const BorderSide(color: bodyBk, width: 2)
                                                )
                                              ),
                                              keyboardType: TextInputType.number,
                                              inputFormatters: <TextInputFormatter>[
                                                FilteringTextInputFormatter.digitsOnly,
                                              ],
                                            ),
                                            actions: <Widget>[
                                              Center(
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    ElevatedButton(
                                                      style: ElevatedButton.styleFrom(
                                                        backgroundColor: Colors.blueAccent,
                                                        shape: RoundedRectangleBorder(
                                                          borderRadius: BorderRadius.circular(10)
                                                        )
                                                      ),
                                                      onPressed: () async {
                                                        _focusNode.unfocus();
                                                        String inputValue = _controller.text;
                                                        int pointsToAdd = int.parse(inputValue);
                                                        try {
                                                          await userProvider.patchFidelityPoints(pointsToAdd, "add");
                                                          _controller.clear();
                                                          ScaffoldMessenger.of(context).showSnackBar(
                                                            const SnackBar(
                                                              content: Text('Points ajoutés avec succès'),
                                                              duration: Duration(seconds: 3),
                                                              behavior: SnackBarBehavior.floating, // Faire flotter le SnackBar en haut de l'écran
                                                              margin: EdgeInsets.all(10),
                                                            ),
                                                          );
                                                        } catch(error) {
                                                          throw Exception('Failed to update fidelity points.');
                                                        }
                                                      },
                                                      child: const Text('Confirmer', style: TextStyle(color: Colors.white),),
                                                    ),
                                                    ElevatedButton(
                                                      style: ElevatedButton.styleFrom(
                                                        backgroundColor: Colors.blueAccent,
                                                        shape: RoundedRectangleBorder(
                                                          borderRadius: BorderRadius.circular(10)
                                                        )
                                                      ),
                                                      onPressed: () {
                                                        Navigator.of(context).pop();
                                                      },
                                                      child: const Text('Fermer', style: TextStyle(color: Colors.white),),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                            contentPadding: const EdgeInsets.symmetric(vertical: 24.0, horizontal: 10.0)
                                          );
                                        },
                                      );
                                    },
                                    child: const Icon(Icons.add, color: bkColor,),
                                  ),
                                  const SizedBox(
                                    width: 40,
                                  ),
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.blueAccent,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10)
                                      )
                                    ),
                                    onPressed: () {
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {

                                          final userProvider = Provider.of<Users>(context);

                                          return AlertDialog(
                                            title: const Center(
                                              child: Text(
                                                'Retirer des points de fidélité'
                                              )
                                            ),
                                            content: TextField(
                                              focusNode: _focusNode,
                                              controller: _controller,
                                              decoration: InputDecoration(
                                                labelText: 'Entrez le nombre de points a retirer',
                                                border: OutlineInputBorder(
                                                  borderRadius: BorderRadius.circular(20),
                                                  borderSide: const BorderSide(color: bodyBk, width: 2)
                                                )
                                              ),
                                              keyboardType: TextInputType.number,
                                              inputFormatters: <TextInputFormatter>[
                                                FilteringTextInputFormatter.digitsOnly,
                                              ],
                                            ),
                                            actions: <Widget>[
                                              Center(
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    ElevatedButton(
                                                      style: ElevatedButton.styleFrom(
                                                        backgroundColor: Colors.blueAccent,
                                                        shape: RoundedRectangleBorder(
                                                          borderRadius: BorderRadius.circular(10)
                                                        )
                                                      ),
                                                      onPressed: () async {
                                                        _focusNode.unfocus();
                                                        String inputValue = _controller.text;
                                                        int pointsToRemove = int.parse(inputValue);
                                                        try {
                                                          await userProvider.patchFidelityPoints(pointsToRemove, "remove");
                                                          _controller.clear();
                                                        } catch(error) {
                                                          throw Exception('Failed to update fidelity points.');
                                                        }
                                                      },
                                                      child: const Text('Confirmer', style: TextStyle(color: Colors.white),),
                                                    ),
                                                    ElevatedButton(
                                                      style: ElevatedButton.styleFrom(
                                                        backgroundColor: Colors.blueAccent,
                                                        shape: RoundedRectangleBorder(
                                                          borderRadius: BorderRadius.circular(10)
                                                        )
                                                      ),
                                                      onPressed: () {
                                                        Navigator.of(context).pop();
                                                      },
                                                      child: const Text('Fermer', style: TextStyle(color: Colors.white),),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                            contentPadding: const EdgeInsets.symmetric(vertical: 24.0, horizontal: 10.0)
                                          );
                                        },
                                      );
                                    },
                                    child: const Icon(Icons.remove, color: bkColor,),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(width: 20,),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.white,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Scrollbar(
                              thumbVisibility: true,
                              trackVisibility: true,
                              thickness: 5,
                              child: ListView(
                                children: [
                                  Wrap(
                                    crossAxisAlignment: WrapCrossAlignment.center,
                                    direction: Axis.horizontal,
                                    children: [
                                      for (int i = 0; i < user['rewardsPointHistory'].length; i++)
                                      Padding(
                                        padding: const EdgeInsets.all(10),
                                        child: Container(
                                          width: 300,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(5),
                                            color: Colors.grey[300]
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Column(
                                              children: [
                                                Row(
                                                  children: [
                                                    Container(
                                                      width: 30,
                                                      height: 30,
                                                      decoration: const BoxDecoration(
                                                        shape: BoxShape.circle,
                                                        gradient: RadialGradient(
                                                          colors: [
                                                            Colors.blueAccent,
                                                            Colors.white,
                                                          ],
                                                          stops: [0.0, 1.0],
                                                          center: Alignment.center,
                                                          radius: 0.6,
                                                        ),
                                                      ),
                                                      child: const Icon(FontAwesomeIcons.hashtag, size: 20)
                                                    ),
                                                    const SizedBox(width: 15,),
                                                    Text(
                                                      'Commande numéro ${user['rewardsPointHistory'][i]['orderNumber'].toString()}.'
                                                    ),
                                                  ],
                                                ),
                                                const SizedBox(height: 15),
                                                Row(
                                                  children: [
                                                    Container(
                                                      width: 30,
                                                      height: 30,
                                                      decoration: const BoxDecoration(
                                                        shape: BoxShape.circle,
                                                        gradient: RadialGradient(
                                                          colors: [
                                                            Colors.blueAccent,
                                                            Colors.white,
                                                          ],
                                                          stops: [0.0, 1.0],
                                                          center: Alignment.center,
                                                          radius: 0.6,
                                                        ),
                                                      ),
                                                      child: const Icon(FontAwesomeIcons.coins, size: 20,),
                                                    ),
                                                    const SizedBox(width: 15,),
                                                    if(user['rewardsPointHistory'][i]['type'] == 'earned')
                                                    Text(
                                                      '${user['rewardsPointHistory'][i]['amount'].toString()} points gagné.'
                                                    )
                                                    else
                                                    Text(
                                                      '${user['rewardsPointHistory'][i]['amount'].toString()} points dépensé.'
                                                    )
                                                  ],
                                                ),
                                                const SizedBox(height: 15),
                                                Row(
                                                  children: [
                                                    Container(
                                                      width: 30,
                                                      height: 30,
                                                      decoration: const BoxDecoration(
                                                        shape: BoxShape.circle,
                                                        gradient: RadialGradient(
                                                          colors: [
                                                            Colors.blueAccent,
                                                            Colors.white,
                                                          ],
                                                          stops: [0.0, 1.0],
                                                          center: Alignment.center,
                                                          radius: 0.6,
                                                        ),
                                                      ),
                                                      child: const Icon(FontAwesomeIcons.calendarDay, size: 20,),
                                                    ),
                                                    const SizedBox(width: 15,),
                                                    Text(user['rewardsPointHistory'][i]['executedAt'])
                                                  ],
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              )
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(
              height: 75,
            ),
            
          ],
        ),
      ),
    );
  }
}