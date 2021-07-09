import 'dart:ui';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class DelegatesDemo extends StatefulWidget {
  @override
  _DelegatesDemoState createState() => _DelegatesDemoState();
}
class _DelegatesDemoState extends State<DelegatesDemo> {
  List<String> imageArray = [
    "https://images.unsplash.com/photo-1503023345310-bd7c1de61c7d?ixid=MXwxMjA3fDB8MHxzZWFyY2h8MXx8aHVtYW58ZW58MHx8MHw%3D&ixlib=rb-1.2.1&w=1000&q=80",
    "https://i.pinimg.com/564x/fb/ef/1d/fbef1d60a957c5748d05d8881b460fe2.jpg",
    "https://i.pinimg.com/originals/df/07/cb/df07cb4ccb697303462ad7a8b57b852f.jpg",
    "https://i.pinimg.com/736x/37/6e/2d/376e2dab5652d6e1751e25cbcb52f2d5.jpg",
    "https://i.pinimg.com/originals/c8/2a/f9/c82af9c8a818d8dba545fb896b8a6b2c.jpg",
    "https://images.pexels.com/photos/1496372/pexels-photo-1496372.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500",
    "https://images.unsplash.com/photo-1503023345310-bd7c1de61c7d?ixid=MXwxMjA3fDB8MHxzZWFyY2h8MXx8aHVtYW58ZW58MHx8MHw%3D&ixlib=rb-1.2.1&w=1000&q=80",
    "https://i.pinimg.com/564x/fb/ef/1d/fbef1d60a957c5748d05d8881b460fe2.jpg",
    "https://i.pinimg.com/originals/df/07/cb/df07cb4ccb697303462ad7a8b57b852f.jpg",
    "https://i.pinimg.com/736x/37/6e/2d/376e2dab5652d6e1751e25cbcb52f2d5.jpg",
    "https://i.pinimg.com/originals/c8/2a/f9/c82af9c8a818d8dba545fb896b8a6b2c.jpg",
    "https://images.pexels.com/photos/1496372/pexels-photo-1496372.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500",
  ];

  List<String> ListviewList = [
    "https://i.pinimg.com/564x/79/a5/b4/79a5b4d3aca0e605eca4389c78e71f28.jpg",
    "https://i.pinimg.com/564x/05/02/30/050230ef1e2b486613f20bb71a1f1f3e.jpg",
    "https://i.pinimg.com/564x/fc/91/12/fc911293a31a21c55f4d0fef56d69418.jpg",
    "https://i.pinimg.com/564x/f9/34/33/f934334c6557dcd57acde6e087c33c6a.jpg",
    "https://i.pinimg.com/originals/2c/9d/55/2c9d5557856d906ef57f484119f1cbf1.jpg",
    "https://i.pinimg.com/originals/8a/e4/34/8ae434d33f914a85d2a2c1571568b716.jpg",
    "https://i.pinimg.com/564x/79/a5/b4/79a5b4d3aca0e605eca4389c78e71f28.jpg",
    "https://i.pinimg.com/564x/05/02/30/050230ef1e2b486613f20bb71a1f1f3e.jpg",
    "https://i.pinimg.com/564x/fc/91/12/fc911293a31a21c55f4d0fef56d69418.jpg",
    "https://i.pinimg.com/564x/f9/34/33/f934334c6557dcd57acde6e087c33c6a.jpg",
    "https://i.pinimg.com/originals/2c/9d/55/2c9d5557856d906ef57f484119f1cbf1.jpg",
    "https://i.pinimg.com/originals/8a/e4/34/8ae434d33f914a85d2a2c1571568b716.jpg",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Delegates"),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Container(
            child: Column(
              children: [
                Container(
                  height: MediaQuery.of(context).size.height * 0.5,
                  child: GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          crossAxisSpacing: 1.0,
                          mainAxisSpacing: 1.0,
                          childAspectRatio: 0.6),
                      itemCount: imageArray.length,
                      itemBuilder: (context, index) {
                        return Container(
                          child: InkWell(
                            onTap: (){
                              Navigator.push(context, MaterialPageRoute(builder: (context) => GridDemoCarousel(
                                index: index,
                                arrayList: imageArray,
                              ),));
                            },
                            child: Image.network(
                              imageArray[index],
                              fit: BoxFit.cover,
                            ),
                          )
                        );
                      }),
                ),
                Container(
                  height: MediaQuery.of(context).size.height * 0.5,
                  child: ListView.builder(
                      itemExtent: 150.0,
                      itemCount: ListviewList.length,
                      itemBuilder: (context, index) {
                        return Container(
                          child: InkWell(
                            onTap: (){
                              Navigator.push(context, MaterialPageRoute(builder: (context) => ListDemoPageView(
                                index: index,
                                arrayList: ListviewList,
                              ),));
                            },
                            child: Image.network(
                              ListviewList[index],
                              fit: BoxFit.cover,
                            ),
                          )
                        );
                      }),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}



class GridDemoCarousel extends StatefulWidget {
  int index;
  List<String> arrayList;
  GridDemoCarousel({this.arrayList,this.index});

  @override
  _GridDemoCarouselState createState() => _GridDemoCarouselState();
}
class _GridDemoCarouselState extends State<GridDemoCarousel> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
          child: Stack(
            children: [

              Container(
                //color: Colors.red,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(widget.arrayList[widget.index]),
                    fit: BoxFit.cover,
                  ),
                ),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
                  child: Container(
                    color: Colors.black.withOpacity(0.5),
                  ),
                ),
              ),

              Center(
                child: Container(
                    child: CarouselSlider.builder(
                      itemCount: widget.arrayList.length,
                      options: CarouselOptions(
                          height: MediaQuery.of(context).size.height / 1.2 - 30,
                          enlargeCenterPage: true,
                          initialPage: widget.index,
                          autoPlayInterval: Duration(seconds: 2),
                          autoPlayAnimationDuration: Duration(milliseconds: 2000),
                          scrollDirection: Axis.horizontal,
                          onPageChanged: (index, reason) {
                            setState(() {
                              widget.index = index;
                            });
                          }
                      ),
                      itemBuilder: (context, index) {
                        return ClipRRect(
                            borderRadius: BorderRadius.circular(30),
                            child: Image.network(widget.arrayList[index], fit: BoxFit.cover)
                        );
                      },
                    )
                ),
              ),
            ],
          ),
        )
    );
  }
}



class ListDemoPageView extends StatefulWidget {
  int index;
  List<String> arrayList;
  ListDemoPageView({this.arrayList,this.index});

  @override
  _ListDemoPageViewState createState() => _ListDemoPageViewState();
}
class _ListDemoPageViewState extends State<ListDemoPageView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
          child: Stack(
            fit: StackFit.expand,
            children: [
              Builder(
                builder: (context){
                  final double height = MediaQuery.of(context).size.height;
                  return CarouselSlider.builder(
                    itemCount: widget.arrayList.length,
                    options: CarouselOptions(
                        height: height,
                        viewportFraction: 1.0,
                        initialPage: widget.index,
                        enlargeCenterPage: false,
                        onPageChanged: (index, reason) {
                          setState(() {
                            widget.index = index;
                          });
                        }
                    ),
                    itemBuilder: (context, index) {
                      return PhotoView(imageProvider: NetworkImage(widget.arrayList[index]));
                    },
                  );
                },
              )
            ],
          ),
        )
    );
  }
}
