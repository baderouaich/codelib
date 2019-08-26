
import '../frontend/code.dart';

import 'bookview.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import '../backend/models/book.dart';

import '../backend/api.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

enum LoadingState
{
  loading,
  done
}

class _HomeState extends State<Home> 
{
  List<Book> books = new List<Book>();
  LoadingState state = LoadingState.loading;
  bool isSearching = false;
  bool isLoadingMore = false;
  //bool isFreeOnly = false;
  int page = 1;
  TextEditingController searchController = new TextEditingController();


 
  void loadMore() async
  {

    page++;
    if(mounted)setState(()=> isLoadingMore = true);
    var response  = await Api.searchBooks(searchController.text, page);
    if(!response['isError'])
    {
       var data = response["data"]["books"];
       List<Book> queryBooks = new List<Book>();
       await data.forEach((book)=> queryBooks.add( Book.fromJson(book) ));
      if(mounted)
      {
        setState(() {
          books.addAll(queryBooks);
          isLoadingMore = false;
        });

      }
    }
  }
  void searchBooks(String query) async
  {
    if(mounted)setState(()=> isSearching = true);
    if(query.trim().isEmpty)
    {
      init();
    }
    setState((){
        books.clear();
      });

    var response  = await Api.searchBooks(query, 0);
    if(!response['isError'])
    {
       var data = response["data"]["books"];
         List<Book> queryBooks = new List<Book>();
       await data.forEach((book)=> queryBooks.add( Book.fromJson(book) ));
     
      if(mounted)
      {
        setState(() {
         // books = isFreeOnly ? queryBooks.where((book)=> book.price == "\$0.00").toList() :  queryBooks;
          books = queryBooks;
          isSearching = false;
        });

      }
    }
     page = 1;



   
  }
  

  Future<List<Book>> getNewBooks() async
  {
      var response  = await Api.getAllNewBooks();
      List<Book> r = new List<Book>();
      if(!response['isError'])
      {
        var data = response["data"]["books"];
        await data.forEach((book)=> r.add( Book.fromJson(book) ));
       
      }
      return r;
  }
  

  init()
  {
    if(mounted)
    setState(()=>state = LoadingState.loading);
    getNewBooks().then((data)
        {
          if(mounted)
          {
            setState((){
                books = data;
                state = LoadingState.done;
            });
          }
        });
  }
  

  @override
  void initState()
   {
     init();
     super.initState();

  }
  @override
  Widget build(BuildContext context)
   {
     double width = MediaQuery.of(context).size.width;
    // double height = MediaQuery.of(context).size.height;
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
          appBar: PreferredSize(
             preferredSize: Size(width,  AppBar().preferredSize.height + 5),
             child: Container(
                  color: Colors.transparent,
                  child:  Padding(
                    padding: const EdgeInsets.only(top: 25.0),
                    child:  Card(
                      color:  Color(0xFF2d3447),
                      elevation: 7.0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25.0),
                        ),
                      child:  ListTile(
                        dense: true,
                        leading: Icon(Icons.search),
                        title:  TextField(
                          controller: searchController,
                          onChanged: searchBooks,
                          autofocus: false,
                          decoration:  InputDecoration(hintText: 'Search books by title, author, keywords or ISBN', border: InputBorder.none),
                        ),
                        trailing: IconButton(icon: Icon(Icons.cancel), onPressed: ()
                        {
                          setState((){
                            searchController.clear();
                            page = 1;
                          });
                          init();
                        },),
                      ),
                    ),
                    ),

               ),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>
            [
              //Search
              
              Padding(
                padding: EdgeInsets.all(20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(isSearching ? "Searching" : "New",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 40.0,
                          letterSpacing: 2.0,
                        )),
                    IconButton(
                      tooltip: "App Code View",
                      icon: Icon(
                        Icons.code,
                        size: 30.0,
                        color: Colors.white,
                      ),
                      onPressed: () {
                       Navigator.of(context).push(PageTransition(type: PageTransitionType.fade, child: Code(), duration: Duration(milliseconds: 1200)));

                      },
                    )
                  ],
                ),
              ),
              
              Padding(
                padding: const EdgeInsets.only(left: 20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(
                      decoration: BoxDecoration(
                         color: Colors.blueAccent,
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      child: Center(
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 22.0, vertical: 6.0),
                          child: Text(isSearching ? "Search" : "New Books",
                              style: TextStyle(color: Colors.white)),
                        ),
                      ),
                    ),

                    
                     /*Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ChoiceChip(
                        backgroundColor: Colors.blueGrey[500],
                        selectedColor: Colors.green[400],
                        label: Text("Free Only", style: TextStyle(color: Colors.white)),
                        selected: isFreeOnly,
                        elevation: 7.0,
                        onSelected: (v){
                          setState(()=> isFreeOnly = v);
                          //searchBooks(searchController.text);
                        }),
                      
                     ),*/


                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text("${books.length} Books",
                          style: TextStyle(color: Colors.blueAccent)),
                    )
                  ],
                ),
              ),




              Divider(),
              Builder(
                builder: (c)
                {
                  if(isSearching)
                  {
                    return Center(child: Text("Searching..."));
                  }
                  
                  switch(state)
                  {
                    case LoadingState.loading:
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Center(child: CircularProgressIndicator()),
                      );

                    case LoadingState.done:
                    default:
                    return  books.isNotEmpty ? 
                          StaggeredGridView.countBuilder(
                                        shrinkWrap: true,
                                        physics: BouncingScrollPhysics(),
                                        crossAxisCount: 4, // num * 2
                                        scrollDirection: Axis.vertical,
                                        itemCount: books.length,
                                        itemBuilder: (BuildContext context, int index) => _renderBookItem(books[index], index),
                                        staggeredTileBuilder: (int i) => StaggeredTile.fit(2),
                        ) : Center(child: Text("No Books Found."));
                  }
                },
              ),
                
             
              if(searchController.text.trim().isNotEmpty && books.isNotEmpty)
              (
                 isLoadingMore ? Padding(padding: const EdgeInsets.all(7.0) ,child:CircularProgressIndicator()) : 
                  RaisedButton(
                   child: Text("Load More"),
                   onPressed: ()
                   {
                       loadMore();
                   },
                 )
              ),
             
              
             // futureBuilder
              
              /*Stack(
                children: <Widget>
                [
                  CardScrollWidget(currentPage: currentPage, books:[]),
                  Positioned.fill(
                    child: PageView.builder(
                      itemCount: images.length,
                      controller: pageController,
                      reverse: true,
                      itemBuilder: (context, index) {
                        return Container();
                      },
                    ),
                  )
                ],
              ),*/
            
            
            /*  Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text("Favourite",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 46.0,
                          letterSpacing: 1.0,
                        )),
                    IconButton(
                      icon: Icon(
                        Icons.menu,
                        size: 12.0,
                        color: Colors.white,
                      ),
                      onPressed: () {},
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20.0),
                child: Row(
                  children: <Widget>[
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.blueAccent,
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      child: Center(
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 22.0, vertical: 6.0),
                          child: Text("Latest",
                              style: TextStyle(color: Colors.white)),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 15.0,
                    ),
                    Text("9+ Stories",
                        style: TextStyle(color: Colors.blueAccent))
                  ],
                ),
              ),
              SizedBox(
                height: 20.0,
              ),*/
              
            ],
          ),
        ),
      ),
    );
    
  }




 Widget _renderBookItem(Book book, int index)
  {
    const cardRadius = BorderRadius.vertical(bottom: Radius.circular(15.0), top: Radius.circular(15.0));
    const topImageRadius = BorderRadius.vertical(top: Radius.circular(15.0));

    return InkWell(
      splashColor: Colors.pink[200],
      onTap: ()
      {
        Navigator.of(context).push(PageTransition(type: PageTransitionType.size, alignment: Alignment.bottomCenter, child: BookView(book.isbn13), duration: Duration(milliseconds: 1200)));
      },
      child: Card(
        color: Colors.blueGrey[800],
        elevation: 5.0,
      shape: RoundedRectangleBorder(borderRadius: cardRadius),
        child: Column(
          children: <Widget>
          [
           // if(book.image != null)
            Stack(
              children: <Widget>
              [
                ClipRRect(
                          borderRadius: topImageRadius,
                          child: GestureDetector(
                              child: Container(
                                child: Image.network(book.image, fit: BoxFit.cover, loadingBuilder:(BuildContext ctx, Widget image, ImageChunkEvent progress)
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
                  )),

                  if(book.price != null && book.price !="")
                  (
                      Positioned(
                        top: 0,
                        right: 0,
                        child: Card(
                          margin: EdgeInsets.all(5.0),
                          elevation: 7.0,
                          color: book.price == "\$0.00" ?  Colors.green : Color(0xFFff6e6e),
                          child: Center(child: Padding(padding: EdgeInsets.all(3.0),child: Text(book.price)),
                        ),
                      )
                      )
                  )
              ],
            ),
            
            Padding(
              padding: const EdgeInsets.only(top:8.0, left:8.0, right:8.0),
              child: Text(book.title, style: TextStyle(fontSize: 17,fontWeight: FontWeight.w700)),
            ),
            Divider(),
            Padding(
              padding: const EdgeInsets.only(bottom:8.0, left:8.0, right:8.0),
              child: Text(book.subtitle, style: TextStyle(fontSize: 14,fontWeight: FontWeight.w200)),
            ),
           

          ],
        ),
      ),
    );
  }
}
