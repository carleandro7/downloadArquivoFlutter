import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:ext_storage/ext_storage.dart';
import 'package:open_file/open_file.dart';
import 'Dart:io';

void main() => runApp(MaterialApp(
      home: MyApp(),
      debugShowCheckedModeBanner: false,
    ));

class MyApp extends StatefulWidget {
  @override
  MyAppState createState() {
    return new MyAppState();
  }
}

class MyAppState extends State<MyApp> {
  final imgUrl = "url";
  bool downloading = false;
  var progressString = "teste.pdf";
  String textButton = "Download do Arquivo";

  @override
  void initState() {
    super.initState();
  }

  Future<String> _getPath() {
    return ExtStorage.getExternalStorageDirectory();
  }

  bool _veriricarArquivoExiste(String path) {
    if (FileSystemEntity.typeSync(path) != FileSystemEntityType.notFound)
      return true;
    return false;
  }

  bool _abrirArquivo(String path) {
    if (_veriricarArquivoExiste(path)) {
      OpenFile.open(path);
      return true;
    }
    return false;
  }

  Future<void> downloadFile() async {
    Dio dio = Dio();
    String dir = await _getPath();
    dir = "${dir}/arquivos/teste2.pdf";
    if (!_veriricarArquivoExiste(dir)) {
      try {
        print(dir);
        await dio.download(
          imgUrl, dir,
          onReceiveProgress: showDownloadProgress,
          //Received data with List<int>
          options: Options(
              responseType: ResponseType.bytes,
              followRedirects: false,
              validateStatus: (status) {
                return status < 500;
              }),
        );
      } catch (e) {
        print(e);
      }

      setState(() {
        downloading = false;
        //verificar se foi feito o download do arquivo
        if (_veriricarArquivoExiste(dir)) {
          progressString = "Download Completo";
          textButton = "Abrir Arquivo";
        }
      });
    } else {
      _abrirArquivo(dir);
    }
  }

  void showDownloadProgress(received, total) {
    setState(() {
      downloading = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Download de Arquivo"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text("Fazendo o Download do arquivo: $progressString",
                style: TextStyle(
                  color: Colors.black,
                )),
            Center(
              child: downloading
                  ? Container(
                      height: 120.0,
                      width: 200.0,
                      child: Card(
                        color: Colors.black,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            CircularProgressIndicator(),
                            SizedBox(
                              height: 20.0,
                            ),
                            Text(
                              "Fazendo o Download do arquivo: $progressString",
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            )
                          ],
                        ),
                      ),
                    )
                  : Padding(
                      padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
                      child: Container(
                        height: 50.0,
                        child: RaisedButton(
                          onPressed: () {
                            downloadFile();
                          },
                          child: Text(textButton),
                          color: Colors.green,
                        ),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
