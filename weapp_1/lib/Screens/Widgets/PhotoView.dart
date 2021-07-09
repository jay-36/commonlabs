import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';


class ImagePage extends StatefulWidget {
  String imgUrl;
  int index;

  ImagePage({this.imgUrl,this.index});

  @override
  _ImagePageState createState() => _ImagePageState();
}
class _ImagePageState extends State<ImagePage> {

  List<String> arrayImg = [
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

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      arrayImg.forEach((imageUrl) {
        precacheImage(NetworkImage(imageUrl), context);
      });
    });
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("ImagePage"),
        ),
        body: Container(
          child: Stack(
            fit: StackFit.expand,
            children: [
              Container(
                  child: CarouselSlider.builder(
                    itemCount: arrayImg.length,
                    options: CarouselOptions(
                      height: MediaQuery.of(context).size.height / 1.2 - 30,
                      enlargeCenterPage: true,
                      autoPlay: false,
                      reverse: false,
                      enableInfiniteScroll: false,
                      autoPlayInterval: Duration(seconds: 2),
                      autoPlayAnimationDuration: Duration(milliseconds: 2000),
                      scrollDirection: Axis.horizontal,
                    ),
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context) => ImageView(imgUrl: arrayImg[index],),));
                        },
                        child: ClipRRect(
                            borderRadius: BorderRadius.circular(30),
                            child: Image.network(arrayImg[index], fit: BoxFit.cover)
                        ),
                      );
                    },
                  )
              ),
            ],
          ),
        )
    );
  }
}





class ImageView extends StatefulWidget {

  String imgUrl;

  ImageView({this.imgUrl});

  @override
  _ImageViewState createState() => _ImageViewState();
}
class _ImageViewState extends State<ImageView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: PhotoView(
          imageProvider: NetworkImage(widget.imgUrl),
          minScale: PhotoViewComputedScale.contained * 1,
          maxScale: PhotoViewComputedScale.covered * 2.5,
        ),
      ),
    );
  }
}
