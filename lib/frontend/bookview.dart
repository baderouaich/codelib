import 'package:flutter/services.dart';

import '../backend/api.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import '../backend/models/book.dart';

class BookView extends StatefulWidget
{
  final String isbn13;
  BookView(this.isbn13);
  @override
  _BookViewState createState() => _BookViewState();
}

class _BookViewState extends State<BookView>
{


  
  Book book;

  @override
  void initState() {
    Api.getBookByISBN13(widget.isbn13).then((response)
    {
      if(mounted)
      {
         setState(()=> book = Book.fromJson(response["data"]));
      }
    });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
     return Container(
     decoration: BoxDecoration(
          gradient: LinearGradient(
              colors: [
                        Color(0xFF2d3447),
                        Colors.blueGrey[900],
                      ],
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
              tileMode: TileMode.clamp)),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(centerTitle: true, title: Text(book?.title?? "Loading...", style: TextStyle(fontSize: 14)), backgroundColor: Color(0xFF2d3447)),
        body: book == null ?  Padding(padding: EdgeInsets.all(10.0),child: Center(child: LinearProgressIndicator())) :
            SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Column(
                children: <Widget>
                [
                    Stack(
                      children: <Widget>
                      [
                          if(book.image != null && book.image != "")
                          (
                            Image.network(book.image, fit: BoxFit.cover, loadingBuilder:(BuildContext ctx, Widget image, ImageChunkEvent progress)
                                    {
                                      if(progress?.cumulativeBytesLoaded == progress?.expectedTotalBytes)
                                      {
                                        return image;
                                      }
                                      return Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Center(child: CircularProgressIndicator()),
                                      );
                              })
                          
                          ),

                          if(book.price != null && book.price !="")
                          (
                              Positioned(
                                top: 0,
                                right: 0,
                                child: Card(
                                  
                                  margin: EdgeInsets.all(7.0),
                                  elevation: 8.0,
                                  color: book.price == "\$0.00" ?  Colors.green : Color(0xFFff6e6e),
                                  child: Center(child: Padding(padding: EdgeInsets.all(7.0),child: Text(book.price)),
                                ),
                              )
                              )
                          ),
                      

                      ],
                    ),
               


                  if(book.subtitle != null && book.subtitle != "")
                  (
                    Padding(
                      padding: const EdgeInsets.only(bottom:8.0, left:8.0, right:8.0),
                      child: Text(book.subtitle, style: TextStyle(fontSize: 15,fontWeight: FontWeight.w400),
                    ))
                  ),
                  Divider(),
                  if(book.desc != null && book.desc != "")
                  (
                    Padding(
                      padding: const EdgeInsets.only(bottom:8.0, left:8.0, right:8.0),
                      child: Text(book.desc, style: TextStyle(fontSize: 15,fontWeight: FontWeight.w200),
                    ))
                  ),
                  if(book.authors != null && book.authors !="")
                    (
                        ListTile(
                          title: Text("Authors"),
                          subtitle: Text(book.authors),
                        )
                    ),
                  if(book.publisher != null && book.publisher !="")
                    (
                        ListTile(
                          title: Text("Publisher"),
                          subtitle: Text(book.publisher),
                        )
                    ),
                  if(book.language != null && book.language !="")
                    (
                        ListTile(
                          title: Text("Language"),
                          subtitle: Text(book.language),
                        )
                    ),
                  if(book.pages != null && book.pages !="")
                    (
                        ListTile(
                          title: Text("Pages"),
                          subtitle: Text(book.pages),
                        )
                    ),
                  if(book.year != null && book.year !="")
                    (
                        ListTile(
                          title: Text("Year"),
                          subtitle: Text(book.year),
                        )
                    ),
                  if(book.rating != null && book.rating !="")
                    (
                      ListTile(
                        title: Text("Rating ${book.rating}/5"),
                        subtitle:  Center(
                          child: RatingBar(
                            onRatingUpdate: (double rating){},
                            initialRating: double.parse(book.rating),
                            direction: Axis.horizontal,
                           // allowHalfRating: true,
                            itemCount: 5,
                            itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                            itemBuilder: (context, _) => Icon(
                              Icons.star,
                              color: Colors.amber,
                            ),
                            ignoreGestures: true,
                            
                          ),
                        ))
                    ),
                    if(book.url != null && book.url !="")
                    (
                      ListTile(
                        onTap: ()
                        {
                          Clipboard.setData(new ClipboardData(text: book.url));
                          showModalBottomSheet(
                            isScrollControlled: true,
                            context: context,
                            builder: (c)
                            {

                              return Container(
                                 height: 50,
                                child: Center(child: Text("Copied to Clipboard")),
                              );
                            }
                          );
                        },
                        title: Text("URL"),
                        subtitle:  Text(book.url,style: TextStyle(color: Colors.blueAccent, decoration: TextDecoration.underline))
                        )
                    ),
                ],
              ),
            )
        ),
    );
  }
}