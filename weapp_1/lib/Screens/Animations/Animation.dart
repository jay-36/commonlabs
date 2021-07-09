import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;

class DemoAnimation extends StatefulWidget {
  @override
  _DemoAnimationState createState() => _DemoAnimationState();
}
class _DemoAnimationState extends State<DemoAnimation>with SingleTickerProviderStateMixin {
  Animation _containerRadiusAnimation,
      _containerSizeAnimation,
      _containerColorAnimation;
  AnimationController _containerAnimationController;

  @override
  void initState() {
    super.initState();
    _containerAnimationController = AnimationController(
        vsync: this, duration: Duration(seconds: 10));

    _containerRadiusAnimation = BorderRadiusTween(
        begin: BorderRadius.circular(100.0),
        end: BorderRadius.circular(0.0))
        .animate(CurvedAnimation(
        curve: Curves.ease, parent: _containerAnimationController));

    _containerSizeAnimation = Tween(begin: 0.0, end: 2.0).animate(
        CurvedAnimation(
            curve: Curves.ease, parent: _containerAnimationController));

    _containerColorAnimation =
        ColorTween(begin: Colors.black, end: Colors.white).animate(
            CurvedAnimation(
                curve: Curves.ease, parent: _containerAnimationController));

    _containerAnimationController.forward();
  }

  @override
  void dispose() {
    super.dispose();
    _containerAnimationController?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Center(
        child: AnimatedBuilder(
          animation: _containerAnimationController,
          builder: (context, index) {
            return Container(
              transform: Matrix4.translationValues(
                  _containerSizeAnimation.value * width - 200.0, 0.0, 0.0),
              width: _containerSizeAnimation.value * height,
              height: _containerSizeAnimation.value * height,
              decoration: BoxDecoration(
                  borderRadius: _containerRadiusAnimation.value,
                  color: _containerColorAnimation.value),
            );
          },
        ),
      ),
    );
  }
}

class LogoFade extends StatefulWidget {
  @override
  createState() => LogoFadeState();
}
class LogoFadeState extends State<LogoFade> {
  double opacityLevel = 1.0;

  void _changeOpacity() {
    setState(() => opacityLevel = opacityLevel == 0 ? 1.0 : 0.0);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        AnimatedOpacity(
          opacity: opacityLevel,
          duration: Duration(seconds: 3),
          child: FlutterLogo(size: 100.0,),
        ),
        ElevatedButton(
          child: Text('Fade Logo'),
          onPressed: _changeOpacity,
        ),
      ],
    );
  }
}


class MyStatefulWidget extends StatefulWidget {
  MyStatefulWidget({Key key}) : super(key: key);
  @override
  _MyStatefulWidgetState createState() => _MyStatefulWidgetState();
}
class _MyStatefulWidgetState extends State<MyStatefulWidget>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat();
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.fastOutSlowIn,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            child: Center(
              child: Opacity(
                opacity: 0.3,
                child: FlutterLogo(
                  size: 200,
                ),
              ),
            ),
          ),
          SizeTransition(
            sizeFactor: _animation,
            axis: Axis.horizontal,
            axisAlignment: -1,
            child: Center(
              child: FlutterLogo(size: 200.0),
            ),
          ),
        ],
      ),
    );
  }
}


class BouncingButton extends StatefulWidget {
  @override
  _BouncingButtonState createState() => _BouncingButtonState();
}
class _BouncingButtonState extends State<BouncingButton> with SingleTickerProviderStateMixin {
  double _scale;
  AnimationController _controller;

  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: Duration(
        milliseconds: 500,
      ),
      lowerBound: 0.0,
      upperBound: 0.1,
    )..addListener(() {
      setState(() {});
    });
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _scale = 1 - _controller.value;
    return Scaffold(
      appBar: AppBar(
        title: Text("Flutter Bouncing Button Animation Demo"),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text('Press the Below Button',style: TextStyle(color: Colors.grey[400],fontSize: 20.0),),
          SizedBox(
            height: 20.0,
          ),
          Center(
            child: GestureDetector(
              onTapDown: _tapDown,
              onTapUp: _tapUp,
              child: Transform.scale(
                scale: _scale,
                child: Container(
                  height: 70,
                  width: 200,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100.0),
                      boxShadow: [
                        BoxShadow(
                          color: Color(0x80000000),
                          blurRadius: 12.0,
                          offset: Offset(0.0, 5.0),
                        ),
                      ],
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Color(0xff33ccff),
                          Color(0xffff99cc),
                        ],
                      )),
                  child: Center(
                    child: Text(
                      'Press',
                      style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }


  void _tapDown(TapDownDetails details) {
    _controller.forward();
  }
  void _tapUp(TapUpDetails details) {
    _controller.reverse();
  }
}


class Animationt extends StatefulWidget {
  @override
  _AnimationtState createState() => _AnimationtState();
}
class _AnimationtState extends State<Animationt>with SingleTickerProviderStateMixin {

  AnimationController controller;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      duration: const Duration(seconds: 10),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    controller.dispose();
  }

  bool forward = false;
  bool stop = true;
  bool reverse = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            AnimatedBuilder(
              animation: controller,
              builder: (context,child)=>Transform.rotate(
                angle: controller.value * 2.0 * math.pi,
                child: child,
              ),
              child: Container(
                height: 150,
                width: 150,
                decoration: BoxDecoration(
                    border: Border.all(width: 2,color: Color(0xFF181a85),)
                ),
                child: AnimatedBuilder(
                  animation: controller,
                  builder: (context,child)=>Transform.rotate(
                    angle: controller.value * 1.0 * math.pi,
                    child: child,
                  ),
                  child: Container(
                    height: 150,
                    width: 150,
                    decoration: BoxDecoration(
                        border: Border.all(width: 2,color: Color(0xFF2022a1),)
                    ),
                    child: AnimatedBuilder(
                      animation: controller,
                      builder: (context,child)=>Transform.rotate(
                        angle: controller.value * 1.0 * math.pi,
                        child: child,
                      ),
                      child: Container(
                        height: 150,
                        width: 150,
                        decoration: BoxDecoration(
                            border: Border.all(width: 2,color: Color(0xFF2a2cb5),)
                        ),
                        child: AnimatedBuilder(
                          animation: controller,
                          builder: (context,child)=>Transform.rotate(
                            angle: controller.value * 1.0 * math.pi,
                            child: child,
                          ),
                          child: Container(
                            height: 150,
                            width: 150,
                            decoration: BoxDecoration(
                                border: Border.all(width: 2,color: Colors.blue[900],)
                            ),
                            child: AnimatedBuilder(
                              animation: controller,
                              builder: (context,child)=>Transform.rotate(
                                angle: controller.value * 1.0 * math.pi,
                                child: child,
                              ),
                              child: Container(
                                height: 150,
                                width: 150,
                                decoration: BoxDecoration(
                                    border: Border.all(width: 2,color: Colors.blue[800],)
                                ),
                                child: AnimatedBuilder(
                                  animation: controller,
                                  builder: (context,child)=>Transform.rotate(
                                    angle: controller.value * 1.0 * math.pi,
                                    child: child,
                                  ),
                                  child: Container(
                                    height: 150,
                                    width: 150,
                                    decoration: BoxDecoration(
                                        border: Border.all(width: 2,color: Colors.blue[700],)
                                    ),
                                    child: AnimatedBuilder(
                                      animation: controller,
                                      builder: (context,child)=>Transform.rotate(
                                        angle: controller.value * 1.0 * math.pi,
                                        child: child,
                                      ),
                                      child: Container(
                                        height: 150,
                                        width: 150,
                                        decoration: BoxDecoration(
                                            border: Border.all(width: 2,color: Colors.blue[600],)
                                        ),
                                        child: AnimatedBuilder(
                                          animation: controller,
                                          builder: (context,child)=>Transform.rotate(
                                            angle: controller.value * 1.0 * math.pi,
                                            child: child,
                                          ),
                                          child: Container(
                                            height: 150,
                                            width: 150,
                                            decoration: BoxDecoration(
                                                border: Border.all(width: 2,color: Colors.blue[500],)
                                            ),
                                            child: AnimatedBuilder(
                                              animation: controller,
                                              builder: (context,child)=>Transform.rotate(
                                                angle: controller.value * 1.0 * math.pi,
                                                child: child,
                                              ),
                                              child: Container(
                                                height: 150,
                                                width: 150,
                                                decoration: BoxDecoration(
                                                    border: Border.all(width: 2,color: Colors.blue[400],)
                                                ),
                                                child: AnimatedBuilder(
                                                  animation: controller,
                                                  builder: (context,child)=>Transform.rotate(
                                                    angle: controller.value * 1.0 * math.pi,
                                                    child: child,
                                                  ),
                                                  child: Container(
                                                    height: 150,
                                                    width: 150,
                                                    decoration: BoxDecoration(
                                                      border: Border.all(width: 2,color: Colors.blue[300],)
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                RaisedButton(
                  color: forward == true ? Colors.blue: Colors.grey,
                    onPressed: forward == true ? (){
                      controller..forward();
                      setState(() {
                        stop = true;
                        forward = false;
                        reverse = true;
                      });
                    } : (){},
                    child: Text("Forward")
                ),
                RaisedButton(
                    color: stop == true ? Colors.blue: Colors.grey,
                    onPressed: stop == true ? (){
                    controller..stop();
                    setState(() {
                      stop = false;
                      forward = true;
                      reverse = true;
                    });
                  } : (){},
                  child: Text("Stop")
                ),
                RaisedButton(
                    color: reverse == true  ? Colors.blue: Colors.grey,
                    onPressed: reverse == true ?(){
                      controller..reverse();
                      setState(() {
                        stop = true;
                        forward = true;
                        reverse = false;
                      });
                    } : (){},
                    child: Text("Reverse")
                ),

              ],
            ),
          ],
        ),
      ),
    );
  }
}
