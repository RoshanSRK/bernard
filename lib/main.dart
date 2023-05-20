import 'package:bernard/storage_service.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueGrey),
        useMaterial3: true,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    Storage storage = Storage();
    return Scaffold(
        appBar: AppBar(
          title: Text('Cloud Storage'),
        ),
        body: Column(
          children: [
            Center(
                child: ElevatedButton(
                  onPressed: () async {
                    final results = await FilePicker.platform.pickFiles(
                      allowMultiple: false,
                      type: FileType.custom,
                      allowedExtensions: ['png', 'jpg'],
                    );
                    if (results == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('No file selected.')),
                      );
                      return null;
                    }

                    final path = results.files.single.path!;
                    final fileName = results.files.single.name;

                    // print(path);
                    // print(fileName);

                    storage
                        .uploadFile(path, fileName)
                        .then((value) => print('Done.'));
                  },
                  child: Text('Upload file'),
                )),
            FutureBuilder(
                future: storage.listFiles(),
                builder: (BuildContext context,
                    AsyncSnapshot<firebase_storage.ListResult> snapshot) {
                  if (snapshot.connectionState == ConnectionState.done &&
                      snapshot.hasData) {
                    return Container(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        height: 50,
                        child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            shrinkWrap: true,
                            itemCount: snapshot.data!.items.length,
                            itemBuilder: (BuildContext context, int index) {
                              return ElevatedButton(
                                  onPressed: () {},
                                  child:
                                  Text(snapshot.data!.items[index].name));
                            }));
                  }

                  if (snapshot.connectionState == ConnectionState.waiting &&
                      !snapshot.hasData) {
                    return CircularProgressIndicator();
                  }
                  return Container();
                }),
            FutureBuilder(
                future: storage.downloadURL('Snapchat-601650972.jpg'),
                builder: (BuildContext context,
                    AsyncSnapshot<String> snapshot) {
                  if (snapshot.connectionState == ConnectionState.done &&
                      snapshot.hasData) {
                    return Container(
                        width: 300,
                        height: 250,
                        child: Image.network(
                          snapshot.data!,
                          fit: BoxFit.cover,
                        )
                    );
                  }

                  if (snapshot.connectionState == ConnectionState.waiting &&
                      !snapshot.hasData) {
                    return CircularProgressIndicator();
                  }
                  return Container();
                }),
            FutureBuilder(
                future: storage.getDownloadURLs(),
                builder: (BuildContext context,
                    AsyncSnapshot<List<String>> urlList) {
                  if (urlList.connectionState == ConnectionState.done &&
                      urlList.hasData) {
                    return Container(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        height: 250,
                        child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            shrinkWrap: true,
                            itemCount: urlList.data!.length,
                            itemBuilder: (BuildContext context, int index) {
                              return ElevatedButton(
                                  onPressed: () {},
                                  child:
                                  Image.network(
                                    urlList.data![index],
                                    fit: BoxFit.cover,
                                  )
                              );
                            }
                            )
                    );

                  }

                  if (urlList.connectionState == ConnectionState.waiting &&
                  !urlList.hasData) {
                  return CircularProgressIndicator();
                  }
                  return
                  Container
                  (
                  );
                }),
          ],
        ));
  }
}
