import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../crud/crud.dart';
import '../provider/API-provider.dart';

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  int adminCurrentPage = 1;
  Uint8List? myImage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
          onPressed: () => addDataWidget(context).whenComplete(() {
                setState(() {});
              }),
          child: const Icon(Icons.add)),
      appBar: AppBar(title: const Text("TODO List"), centerTitle: true),
      body: Consumer<TodoProvider>(
        builder: (context, model, _) => FutureBuilder(
          future: model.fetchData(adminCurrentPage),
          builder: (context, snapshot) {
            return snapshot.hasData
                ? SingleChildScrollView(
                    child: Column(
                    children: [
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: model.todoData?.length,
                          itemBuilder: (context, int index) {
                            var img = model.todoData![index]['selectedFile'];
                              final UriData? _data =  Uri.parse(img).data;
                              myImage = _data!.contentAsBytes();     
                              print(myImage);                       
                            return Container(
                                height: 70,
                                color: Colors.blue,
                                child: ListTile(
                                  onLongPress: () {
                                    deleteDataWidget(context,
                                            model.todoData![index]["_id"])
                                        .whenComplete(() {
                                      setState(() {});
                                    });
                                  },

                                  onTap: () {
                                    
                                    updateDataWidget(
                                      context,
                                      model.todoData![index]["_id"],
                                      model.todoData![index]["title"],
                                      model.todoData![index]["price"],
                                      model.todoData![index]["message"],
                                      model.todoData![index]["tags"][0],
                                      model.todoData![index]["selectedFile"],
                                    ).whenComplete(() {
                                      setState(() {});
                                    });
                                  },
                                  title: Text(model.todoData![index]['title']),
                                  subtitle:
                                      Text(model.todoData![index]['message']),
                                  leading: CircleAvatar(
                                    radius: 50,
                                    child: Image.memory(myImage!),
                                  ),
                                ));
                          },
                        ),
                      
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if (model.mapResponse!['adminCurrentPage'] <
                              model.mapResponse!['adminNumberOfPages'])
                            OutlinedButton(
                              onPressed: () {
                                setState(() {
                                  adminCurrentPage++;
                                  showDialog(
                                      context: context,
                                      builder: (context) => const AlertDialog(
                                          title: Text('Navigating...'),
                                          content:
                                              Text('Moving to the Next page')));
                                });
                              },
                              child: const Text(
                                "Next",
                              ),
                            ),
                          if (model.mapResponse!['adminCurrentPage'] > 1)
                            OutlinedButton(
                              onPressed: () {
                                setState(() {
                                  adminCurrentPage--;
                                  showDialog(
                                      context: context,
                                      builder: (context) => AlertDialog(
                                          title: const Text('Navigating...'),
                                          content: Text(
                                              "Moving to the $adminCurrentPage page")));
                                });
                              },
                              child: const Text(
                                "Previous",
                              ),
                            ),
                        ],
                      ),
                    ],
                  ))
                : snapshot.hasError
                    ? Text(snapshot.error.toString())
                    : const Center(
                        child: CircularProgressIndicator(),
                      );
          },
        ),
      ),
    );
  }
}

// class ListTileItem extends StatefulWidget {
//   const ListTileItem(
//       {Key? key,
//       required this.id,
//       required this.title,
//       required this.price,
//       required this.image})
//       : super(key: key);
//   final String id, title, price;
//   final image;
//   @override
//   _ListTileItemState createState() => _ListTileItemState();
// }

// class _ListTileItemState extends State<ListTileItem> {
//   Uint8List? myImage;
//   @override
//   void initState() {
//     super.initState();
//     final UriData? _data = Uri.parse(widget.image).data;
//     myImage = _data!.contentAsBytes();
//     setState(() {});
//   }

//   @override
//   Widget build(BuildContext context) {
//     return ListTile(
//       onLongPress: () {
//         deleteDataWidget(context, widget.id).whenComplete(() {
//           setState(() {});
//         });
//       },
//       onTap: () {
//         updateDataWidget(context, widget.id).whenComplete(() {
//           setState(() {});
//         });
//       },
//       title: Text(widget.title),
//       subtitle: Text(widget.price),
//       leading: CircleAvatar(
//         radius: 30,
//         child: Image.memory(myImage!),
//       ),
//     );
//   }
// }
