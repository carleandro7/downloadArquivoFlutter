import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';

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
  final imgUrl =
      "https://appinfor.com.br/tecnico/webservice/pluginfile.php/88/mod_resource/content/1/Desenvolvimento%20%C3%A1gil%20de%20software.pdf?forcedownload=1&token=75dc82048f64fd9bf7956b99c08b6075";
  bool downloading = false;
  var progressString = "";

  @override
  void initState() {
    super.initState();

    downloadFile();
  }

  Future<void> downloadFile() async {
    Dio dio = Dio();
    try {
      var dir = await getApplicationDocumentsDirectory();

      await dio.download(
        imgUrl, "${dir.path}/teste.pdf",
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
      progressString = "Download Completo";
    });
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
      body: Center(
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
            : Text("$progressString"),
      ),
    );
  }
}
