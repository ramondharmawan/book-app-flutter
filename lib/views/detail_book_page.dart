import 'dart:convert';

import 'package:book_app/controllers/book_controller.dart';
import 'package:book_app/models/book_detail_response.dart';
import 'package:book_app/views/image_view_screen.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../models/book_list_response.dart';

class DetailBookPage extends StatefulWidget {
  const DetailBookPage({super.key, required this.isbn});
  final String isbn;

  @override
  State<DetailBookPage> createState() => _DetailBookPageState();
}

class _DetailBookPageState extends State<DetailBookPage> {
  BookController? controller;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller = Provider.of<BookController>(context,
        listen:
            false); // listen ini berguna untuk update otomatis jika true, jika false update akan dilakukan saat notifyListener saja
    controller!.fetchDetailBookApi(widget.isbn);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Detail"),
        ),
        body: Consumer<BookController>(builder: (context, controller, child) {
          return controller.detailBook == null
              ? Center(child: CircularProgressIndicator())
              : Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ImageViewScreen(
                                      imageUrl: controller!.detailBook!.image!),
                                ),
                              );
                            },
                            child: Image.network(
                              controller!.detailBook!.image!,
                              height: 150,
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 12.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    controller!.detailBook!.title!,
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    controller!.detailBook!.authors!,
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  Row(
                                    children: List.generate(
                                      5,
                                      (index) => Icon(Icons.star,
                                          color: index <
                                                  int.parse(controller!
                                                      .detailBook!.rating!)
                                              ? Colors.yellow
                                              : Colors.grey),
                                    ), //List.generate ini adalah fungsi perulangan
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    controller!.detailBook!.subtitle!,
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  Text(
                                    controller!.detailBook!.price!,
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.green,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        width: double
                            .infinity, // double.infinity itu lebarnya sepanjang layar
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              //fixedSize: Size(double.infinity, 50),
                              ),
                          onPressed: () async {
                            print("url");
                            Uri uri = Uri.parse(controller!.detailBook!.url!);
                            try {
                              (await canLaunchUrl(uri))
                                  ? launchUrl(uri)
                                  : print("Tidak Berhasil Naviagasi");
                            } catch (e) {
                              print("error");
                              //print(e);
                            }
                          },
                          child: Text("BUY"),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Text(controller!.detailBook!.desc!),
                      SizedBox(
                        height: 20,
                      ),
                      //OutlinedButton(onPressed: onPressed, child: child),
                      //TextButton(onPressed: onPressed, child: child),
                      Column(
                        //crossAxisAlignment: CrossAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text("Year: " + controller!.detailBook!.year!),
                          Text("ISBN " +
                              controller!.detailBook!
                                  .isbn13!), // tanda + untuk interpolasi
                          Text(controller!.detailBook!.pages! + " Pages"),
                          Text("Publisher: " +
                              controller!.detailBook!.publisher!),
                          Text(
                              "Language: " + controller!.detailBook!.language!),
                          //Text(detailBook!.rating!),
                        ],
                      ),
                      Divider(),
                      controller!.similiarBooks == null
                          ? CircularProgressIndicator()
                          : Container(
                              height: 180,
                              child: ListView.builder(
                                // karena disini adalah sebuah listview dalam widget column tanpa mendefinisikan panjangnya maka digunakan shrinkWrap
                                shrinkWrap: true,
                                scrollDirection: Axis
                                    .horizontal, // ini untuk mengganti arah scroll Axis. horizontal or vertical
                                itemCount:
                                    controller!.similiarBooks!.books!.length,
                                //physics:NeverScrollableScrollPhysics(), ini fungsinya agar tidak muncul layar kosong, dan ini tidak memperbolehkan Axis untuk scroll jadi harus di comment
                                itemBuilder: ((context, index) {
                                  final current =
                                      controller!.similiarBooks!.books![index];
                                  return Container(
                                    width: 100,
                                    child: Column(
                                      children: [
                                        Image.network(
                                          current.image!,
                                          height: 100,
                                        ),
                                        Text(
                                          current.title!,
                                          maxLines: 2,
                                          textAlign: TextAlign.center,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            fontSize: 12,
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                }),
                              ),
                            ),
                    ],
                  ),
                );
        }));
  }
}
