import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:pdf_text/pdf_text.dart';
import 'dart:convert';
import 'package:file_picker/file_picker.dart';
import 'dart:math';
import 'dart:async';
import 'package:aplicativovoz/leitor_pdf.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      // theme: ThemeData(
      //   primarySwatch: Colors.purple,
      // ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  FlutterTts flutterTts = FlutterTts();
  TextEditingController controller = TextEditingController();

  double volume = 1.0;
  double pitch = 1.0;
  double speechRate = 0.5;
  List<String>? languages;
  String langCode = "pt-BR";
  String nomeVoz = "Maria";
  List<String>? vozes = [];
  double tamanhoFonte = 17.0;
  int corFonte = 0; //Preto
  int corFundo = 0; //Branco

  //LEITOR DE PDF
  String _text = "";

  late List<Object?> tts;
  String teste = "";
  String jsonUser = "";
  String name = "Microsoft Daniel - Portuguese (Brazil)";
  String local = "pt-BR";

  List<String> nomes = [
    "Microsoft Maria - Portuguese (Brazil)",
    "Microsoft Daniel - Portuguese (Brazil)"
  ];

  String aux = "";
  Map<String, String> vozz = {};
  Map<String, String> voz = {
    "name": "Microsoft Maria - Portuguese (Brazil)",
    "locale": "pt-BR"
  };
  List<String> opcoesVoz = [
    "name: Microsoft Daniel - Portuguese (Brazil), locale: pt-BR",
    "name: Microsoft Maria - Portuguese (Brazil), locale: pt-BR"
  ];

  @override
  void initState() {
    super.initState();
    init();
    setState(() {});
  }

  void init() async {
    languages = List<String>.from(await flutterTts.getLanguages);
    tts = (await flutterTts.getVoices);
    // print(tts);
    jsonUser = jsonEncode(tts);
    // print(jsonUser);
    setState(() {});
  }

  trocaVoz(String nome) async {
    setState(() {
      final Map<String, String> data = new Map<String, String>();
      data['name'] = nome;
      data['locale'] = local;
      flutterTts.setVoice(data);
    });
  }

  @override
  Widget build(BuildContext context) {
    return RawKeyboardListener(
      autofocus: true,
      focusNode: FocusNode(),
      onKey: (event) {
        if (event.isKeyPressed(LogicalKeyboardKey.f5)) {
          //Tecla F5 para falar
          _speak();
        }

        if (event.isKeyPressed(LogicalKeyboardKey.f6)) {
          //Tecla F5 para parar de falar
          _speak();
        }

        if (event.isKeyPressed(LogicalKeyboardKey.altRight)) {
          //Aumentar fonte
          _aumentarFonte();
        }

        if (event.isKeyPressed(LogicalKeyboardKey.altLeft)) {
          //Diminuir fonte
          _fonteOriginal();
        }
      },
      child: Scaffold(
          // appBar: AppBar(
          //   centerTitle: true,
          //   title: const Text("Text To Speech"),
          // ),
          backgroundColor: corFundo == 0
              ? Colors.white
              : corFundo == 1
                  ? Colors.black
                  : Colors.white,
          body: SingleChildScrollView(
            child: Container(
              margin: const EdgeInsets.only(top: 20),
              child: Center(
                child: Column(children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * .05,
                  ),

                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width * .8,
                        height: MediaQuery.of(context).size.height * .2,
                        //width: 500,
                        //height: 60,
                        child: TextField(
                          style: TextStyle(
                              fontSize: tamanhoFonte,
                              color: corFundo == 0
                                  ? Colors.black
                                  : corFundo == 1
                                      ? Colors.white
                                      : Colors.black),
                          maxLines: 10,
                          controller: controller,
                          decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: corFundo == 0
                                      ? Colors.black
                                      : corFundo == 1
                                          ? Colors.white
                                          : Colors.black),
                            ),
                            hintText: 'Digite o texto',
                            hintStyle: TextStyle(
                                color: corFundo == 0
                                    ? Colors.black
                                    : corFundo == 1
                                        ? Colors.white
                                        : Colors.black),
                          ),
                        ),
                      ),
                      Text(_text),
                    ],
                  ),

                  SizedBox(
                    height: MediaQuery.of(context).size.height * .05,
                  ),

                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            primary: Colors.green,
                            textStyle: TextStyle(fontSize: tamanhoFonte)),
                        onPressed: _speak,
                        child: const Text("Falar"),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * .01,
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            primary: Colors.green,
                            textStyle: TextStyle(fontSize: tamanhoFonte)),
                        onPressed: _stop,
                        child: const Text("Parar"),
                      ),
                    ],
                  ),

                  SizedBox(
                    height: MediaQuery.of(context).size.height * .04,
                  ),

                  Container(
                    margin: EdgeInsets.only(
                        left: MediaQuery.of(context).size.height * .02),
                    child: Row(
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width * .08,
                          child: Text(
                            "Volume",
                            style: TextStyle(
                                fontSize: tamanhoFonte,
                                color: corFundo == 0
                                    ? Colors.black
                                    : corFundo == 1
                                        ? Colors.white
                                        : Colors.black),
                          ),
                        ),
                        Slider(
                          activeColor: Colors.green,
                          min: 0.0,
                          max: 1.0,
                          value: volume,
                          onChanged: (value) {
                            setState(() {
                              volume = value;
                            });
                          },
                        ),
                        Container(
                          margin: EdgeInsets.only(
                              left: MediaQuery.of(context).size.height * .01),
                          child: Text(
                              double.parse((volume).toStringAsFixed(2))
                                  .toString(),
                              style: TextStyle(fontSize: tamanhoFonte)),
                        )
                      ],
                    ),
                  ),

                  SizedBox(
                    height: MediaQuery.of(context).size.height * .05,
                  ),

                  Container(
                    margin: EdgeInsets.only(
                        left: MediaQuery.of(context).size.height * .02),
                    child: Row(
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width * .08,
                          child: Text(
                            "Tonalidade",
                            style: TextStyle(
                                fontSize: tamanhoFonte,
                                color: corFundo == 0
                                    ? Colors.black
                                    : corFundo == 1
                                        ? Colors.white
                                        : Colors.black),
                          ),
                        ),
                        Slider(
                          activeColor: Colors.green,
                          min: 0.5,
                          max: 2.0,
                          value: pitch,
                          onChanged: (value) {
                            setState(() {
                              pitch = value;
                            });
                          },
                        ),
                        Container(
                          margin: EdgeInsets.only(
                              left: MediaQuery.of(context).size.height * .01),
                          child: Text(
                              double.parse((pitch).toStringAsFixed(2))
                                  .toString(),
                              style: TextStyle(fontSize: tamanhoFonte)),
                        )
                      ],
                    ),
                  ),

                  SizedBox(
                    height: MediaQuery.of(context).size.height * .05,
                  ),

                  Container(
                    margin: EdgeInsets.only(
                        left: MediaQuery.of(context).size.height * .02),
                    child: Row(
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width * .08,
                          child: Text(
                            "Velocidade",
                            style: TextStyle(
                                fontSize: tamanhoFonte,
                                color: corFundo == 0
                                    ? Colors.black
                                    : corFundo == 1
                                        ? Colors.white
                                        : Colors.black),
                          ),
                        ),
                        Slider(
                          activeColor: Colors.green,
                          min: 0.0,
                          max: 1.0,
                          value: speechRate,
                          onChanged: (value) {
                            setState(() {
                              speechRate = value;
                            });
                          },
                        ),
                        Container(
                          margin: EdgeInsets.only(
                              left: MediaQuery.of(context).size.height * .02),
                          child: Text(
                              double.parse((speechRate).toStringAsFixed(2))
                                  .toString(),
                              style: TextStyle(fontSize: tamanhoFonte)),
                        )
                      ],
                    ),
                  ),

                  SizedBox(
                    height: MediaQuery.of(context).size.height * .04,
                  ),

                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            primary: Colors.green,
                            textStyle: TextStyle(fontSize: tamanhoFonte)),
                        onPressed: _aumentarFonte,
                        child: const Text("Aumentar Fonte "),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * .01,
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            primary: Colors.green,
                            textStyle: TextStyle(fontSize: tamanhoFonte)),
                        onPressed: _fonteOriginal,
                        child: const Text("Tamanho Original"),
                      ),
                    ],
                  ),

                  SizedBox(
                    height: MediaQuery.of(context).size.height * .04,
                  ),

                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            primary: Colors.green,
                            textStyle: TextStyle(fontSize: tamanhoFonte)),
                        onPressed: _altoContraste,
                        child: const Text("Alto Contraste"),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * .01,
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            primary: Colors.green,
                            textStyle: TextStyle(fontSize: tamanhoFonte)),
                        onPressed: _contrasteOriginal,
                        child: const Text("Constraste Original"),
                      ),
                    ],
                  ),

                  // Row(
                  //   children: [
                  //     Container(
                  //       margin: EdgeInsets.only(left: MediaQuery.of(context).size.height *.02),
                  //       child: Row(
                  //         children: [
                  //           Text(
                  //             "Vozzzzz :",
                  //             style: TextStyle(fontSize: tamanhoFonte, color: corFundo == 0 ? Colors.black : corFundo == 1 ? Colors.white : Colors.black),
                  //           ),
                  //           SizedBox(
                  //             width: MediaQuery.of(context).size.height *.05,
                  //           ),
                  //           DropdownButton<Object>(
                  //             dropdownColor: corFundo == 1 ? Colors.black : corFundo == 0 ? Colors.white : Colors.black,
                  //             focusColor: corFundo == 1 ? Colors.black : corFundo == 0 ? Colors.white : Colors.black,
                  //             value: nomeVoz2,
                  //             style: TextStyle(
                  //                 color: corFundo == 0 ? Colors.black : corFundo == 1 ? Colors.white : Colors.black
                  //             ),
                  //             iconEnabledColor: corFundo == 0 ? Colors.black : corFundo == 1 ? Colors.white : Colors.black,
                  //             items: tts
                  //                 .map<DropdownMenuItem<Object>>((Object? value) {
                  //               return DropdownMenuItem<Object>(
                  //                 value: value!,
                  //                 child: Text(
                  //                   value.toString(),
                  //                   style: TextStyle(color: corFundo == 0 ? Colors.black : corFundo == 1 ? Colors.white : Colors.black),
                  //                 ),
                  //               );
                  //             }).toList(),
                  //             onChanged: (Object? value) {
                  //               setState(() {
                  //                 nomeVoz2 = value!;
                  //               });
                  //             },
                  //           ),
                  //         ],
                  //       ),
                  //     ),
                  //   ],
                  // ),

                  if (languages != null)
                    Row(
                      children: [
                        Container(
                          margin: EdgeInsets.only(
                              left: MediaQuery.of(context).size.height * .02),
                          child: Row(
                            children: [
                              Text(
                                "Idioma :",
                                style: TextStyle(
                                    fontSize: tamanhoFonte,
                                    color: corFundo == 0
                                        ? Colors.black
                                        : corFundo == 1
                                            ? Colors.white
                                            : Colors.black),
                              ),
                              SizedBox(
                                width: MediaQuery.of(context).size.height * .05,
                              ),
                              DropdownButton<String>(
                                dropdownColor: corFundo == 1
                                    ? Colors.black
                                    : corFundo == 0
                                        ? Colors.white
                                        : Colors.black,
                                focusColor: corFundo == 1
                                    ? Colors.black
                                    : corFundo == 0
                                        ? Colors.white
                                        : Colors.black,
                                value: langCode,
                                style: TextStyle(
                                    color: corFundo == 0
                                        ? Colors.black
                                        : corFundo == 1
                                            ? Colors.white
                                            : Colors.black),
                                iconEnabledColor: corFundo == 0
                                    ? Colors.black
                                    : corFundo == 1
                                        ? Colors.white
                                        : Colors.black,
                                items: languages!.map<DropdownMenuItem<String>>(
                                    (String? value) {
                                  return DropdownMenuItem<String>(
                                    value: value!,
                                    child: Text(
                                      value,
                                      style: TextStyle(
                                          color: corFundo == 0
                                              ? Colors.black
                                              : corFundo == 1
                                                  ? Colors.white
                                                  : Colors.black),
                                    ),
                                  );
                                }).toList(),
                                onChanged: (String? value) {
                                  setState(() {
                                    langCode = value!;
                                  });
                                },
                              ),
                              SizedBox(
                                width: MediaQuery.of(context).size.width * .04,
                              ),
                              Row(
                                children: [
                                  Container(
                                    margin: EdgeInsets.only(
                                        left:
                                            MediaQuery.of(context).size.height *
                                                .02),
                                    child: Row(
                                      children: [
                                        Text(
                                          "Voz :",
                                          style: TextStyle(
                                              fontSize: tamanhoFonte,
                                              color: corFundo == 0
                                                  ? Colors.black
                                                  : corFundo == 1
                                                      ? Colors.white
                                                      : Colors.black),
                                        ),
                                        SizedBox(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              .05,
                                        ),
                                        DropdownButton<String>(
                                          dropdownColor: corFundo == 1
                                              ? Colors.black
                                              : corFundo == 0
                                                  ? Colors.white
                                                  : Colors.black,
                                          focusColor: corFundo == 1
                                              ? Colors.black
                                              : corFundo == 0
                                                  ? Colors.white
                                                  : Colors.black,
                                          value: name,
                                          style: TextStyle(
                                              color: corFundo == 0
                                                  ? Colors.black
                                                  : corFundo == 1
                                                      ? Colors.white
                                                      : Colors.black),
                                          iconEnabledColor: corFundo == 0
                                              ? Colors.black
                                              : corFundo == 1
                                                  ? Colors.white
                                                  : Colors.black,
                                          items: nomes
                                              .map<DropdownMenuItem<String>>(
                                                  (String? value) {
                                            return DropdownMenuItem<String>(
                                              value: value!,
                                              child: Text(
                                                value,
                                                style: TextStyle(
                                                    color: corFundo == 0
                                                        ? Colors.black
                                                        : corFundo == 1
                                                            ? Colors.white
                                                            : Colors.black),
                                              ),
                                            );
                                          }).toList(),
                                          onChanged: (String? value) {
                                            setState(() {
                                              name = value!;
                                              trocaVoz(name);
                                            });
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                width: MediaQuery.of(context).size.width * .3,
                              ),
                            ],
                          ),
                        ),
                      ],
                    )
                ]),
              ),
            ),
          )),
    );
  }

  void initSetting() async {
    // await flutterTts.getDefaultVoice;
    // await flutterTts.setVoice({"name": "Microsoft Daniel - Portuguese (Brazil)", "locale": "pt-BR"});
    await flutterTts.setVolume(volume);
    await flutterTts.setPitch(pitch);
    await flutterTts.setSpeechRate(speechRate);
    await flutterTts.setLanguage(langCode);
    //List tts = await flutterTts.getVoices;
    // print (tts);
  }

  void _speak() async {
    initSetting();
    await flutterTts.speak(controller.text);
    controller.clear();
  }

  void _aumentarFonte() async {
    setState(() {
      tamanhoFonte = tamanhoFonte + 1.0;
    });
    //print(tamanhoFonte);
  }

  void _fonteOriginal() async {
    setState(() {
      tamanhoFonte = 17.0;
    });
    //print(tamanhoFonte);
  }

  void _altoContraste() async {
    setState(() {
      corFonte = 0;
      corFundo = 1;
    });
  }

  void _contrasteOriginal() async {
    setState(() {
      corFonte = 1; //Preto
      corFundo = 0; //Branco
    });
  }

  void _stop() async {
    await flutterTts.stop();
  }
}
