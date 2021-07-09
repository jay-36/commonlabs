import 'package:flutter/material.dart';
import 'package:flutter/services.dart';


class ImageIntegrationPage extends StatefulWidget {
  @override
  _ImageIntegrationPageState createState() => _ImageIntegrationPageState();
}

class _ImageIntegrationPageState extends State<ImageIntegrationPage> {


  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
  }

  @override
  dispose() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Layouts"),
        actions: [
          IconButton(
            onPressed: (){
              SystemChrome.setPreferredOrientations([
                DeviceOrientation.landscapeRight,
              ]);
            },icon:Icon(Icons.arrow_back)
          ),
        IconButton(
            onPressed: (){
              SystemChrome.setPreferredOrientations([
                DeviceOrientation.portraitUp,
              ]);
            },icon:Icon(Icons.arrow_upward)
        ),
        IconButton(
            onPressed: (){
              SystemChrome.setPreferredOrientations([
                DeviceOrientation.landscapeLeft,
              ]);
            },icon:Icon(Icons.arrow_forward)
        )
      ],

      ),
      body: OrientationBuilder(
        builder: (context, orientation){
          if(orientation == Orientation.portrait){
            return portraitView(context);
          }else{
            return landscapeView(context);
          }
        },
      ),
    );
  }

  Column portraitView(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Expanded(
          flex: 145,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                decoration : BoxDecoration(
                  borderRadius: BorderRadius.circular(100.0),
                  border: Border.all(color: Colors.grey,width: 2)
                ),
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: CircleAvatar(
                    radius: 35,
                    backgroundImage: AssetImage("assets/instagram.png"),
                  ),
                ),
              ),
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: Column(
                          children: [
                            Text("3,782",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
                            Text("Posts",style: TextStyle(color: Colors.grey)),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: Column(
                          children: [
                            Text("3.6 M",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
                            Text("Followers",style: TextStyle(color: Colors.grey)),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: Column(
                          children: [
                            Text("36",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
                            Text("Following",style: TextStyle(color: Colors.grey)),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        child: MaterialButton(
                          minWidth: 20,
                          onPressed: (){},child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Text("Message"),
                          ),shape: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey)),),
                      ) ,
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        child: MaterialButton(
                            minWidth: 0,
                            onPressed: (){},child: Icon(Icons.person_add_outlined),shape: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey))),
                      ) ,
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        child: MaterialButton(
                            minWidth: 0,
                            onPressed: (){},child: Icon(Icons.arrow_drop_down_sharp),shape: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey))),
                      ),
                    ],
                  )
                ],
              )
            ],
          ),
        ),
        Expanded(
          flex: 110,
          child: Container(
            padding: EdgeInsets.only(left: 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Photographer"),
                Text("Attitude is Everything"),
                Text("Work Hard, Have Fun, Stay Positive, No Drama"),
                Text("Together Every Achieves More"),
              ],
            ),
          ),
        ),
        Expanded(
          flex: 125,
          child: Container(
            height: 89,
            child: ListView.builder(
                itemCount: 10,
                scrollDirection: Axis.horizontal,
                itemBuilder: (BuildContext context,int index){
                  return Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(100.0),
                                border: Border.all(color: Colors.grey,width: 2)
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(3.0),
                              child: CircleAvatar(
                                radius: 28,
                                backgroundImage: AssetImage("assets/images/travelimage4.jpg"),
                              ),
                            ),
                          ),
                        ),
                        Text("Story  $index",style: TextStyle(fontSize: 10,color: Colors.grey),)
                      ],
                    ),
                  );
                }),
          ),
        ),
        Expanded(
          flex: 520,
          child: Container(
            padding: EdgeInsets.all(5),
            child: GridView.builder(
              itemCount: 36,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: MediaQuery.of(context).orientation ==
                    Orientation.landscape ? 4 : 3,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
                childAspectRatio: (2 / 2),
              ),
              itemBuilder: (context,index,) {
                return Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.blue)
                  ),
                  child: Center(child: Text("${index+1}",style: TextStyle(fontSize: 40),))
                );
              },
            )
          ),
        ),
      ],
    );
  }

  Row landscapeView(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Expanded(
          child: Column(
            children: [
              Expanded(
                child: Column(
                  children: [
                    Expanded(
                      flex: 70,
                      child: ListView.builder(
                          itemCount: 10,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (BuildContext context,int index){
                            return Container(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 8),
                                    child: Container(
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(100.0),
                                          border: Border.all(color: Colors.grey,width: 2)
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(3.0),
                                        child: CircleAvatar(
                                          radius: 28,
                                          backgroundImage: AssetImage("assets/images/travelimage4.jpg"),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Text("Story  $index",style: TextStyle(fontSize: 10,color: Colors.grey),)
                                ],
                              ),
                            );
                          }),
                    ),
                    Expanded(
                      flex: 150,
                      child: Container(
                        padding: EdgeInsets.all(5),
                        child: GridView.builder(
                          itemCount: 36,
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: MediaQuery.of(context).orientation ==
                                Orientation.landscape ? 4 : 3,
                            crossAxisSpacing: 8,
                            mainAxisSpacing: 8,
                            childAspectRatio: (2 / 2),
                          ),
                          itemBuilder: (context,index,) {
                            return Container(
                                decoration: BoxDecoration(
                                    border: Border.all(color: Colors.blue)
                                ),
                                child: Center(child: Text("${index+1}",style: TextStyle(fontSize: 40),))
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                )
              )
            ],
          ),
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 70,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      decoration : BoxDecoration(
                          borderRadius: BorderRadius.circular(100.0),
                          border: Border.all(color: Colors.grey,width: 2)
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(3.0),
                        child: CircleAvatar(
                          radius: 35,
                          backgroundImage: AssetImage("assets/instagram.png"),
                        ),
                      ),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 7),
                              child: Column(
                                children: [
                                  Text("3,782",style: TextStyle(fontSize: 23,fontWeight: FontWeight.bold),),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 5),
                                    child: Text("Posts",style: TextStyle(color: Colors.grey)),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 7),
                              child: Column(
                                children: [
                                  Text("3.6 M",style: TextStyle(fontSize: 23,fontWeight: FontWeight.bold),),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 5),
                                    child: Text("Followers",style: TextStyle(color: Colors.grey)),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 7),
                              child: Column(
                                children: [
                                  Text("36",style: TextStyle(fontSize: 23,fontWeight: FontWeight.bold),),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 5),
                                    child: Text("Following",style: TextStyle(color: Colors.grey)),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    )
                  ],
                ),
              ),
              Expanded(
                flex: 50,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 7),
                      child: MaterialButton(
                        minWidth: 20,
                        onPressed: (){},child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 50),
                        child: Text("Message"),
                      ),shape: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey)),),
                    ) ,
                    MaterialButton(
                        minWidth: 0,
                        onPressed: (){},child: Icon(Icons.person_add_outlined),shape: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey))) ,
                    MaterialButton(
                        minWidth: 0,
                        onPressed: (){},child: Icon(Icons.arrow_drop_down_sharp),shape: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey))),
                  ],
                ),
              ),
              Expanded(
                flex:100,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5),
                        child: Text("Photographer"),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5),
                        child: Text("Attitude is Everything"),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5),
                        child: Text("Work Hard, Have Fun, Stay Positive, No Drama"),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5),
                        child: Text("Together Every Achieves More"),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ],
    );
  }

}

