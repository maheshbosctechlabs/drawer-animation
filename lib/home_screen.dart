import 'package:flutter/material.dart';
import 'package:side_menu_animation/home_page.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  AnimationController _animationController;

  Animation<double> _menuBackgroundAnimation;

  List<Animation<Offset>> _listAnimation;

  Animation<double> _fadeAnimation;

  List<String> _menuList = [
    'ABOUT',
    'SHARE',
    'ACTIVITY',
    'SETTINGS',
    'CONTACT',
  ];

  @override
  void initState() {
    super.initState();
    _animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500));

    _menuBackgroundAnimation =
        Tween<double>(begin: 0, end: 1000).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.ease,
    ));

    _listAnimation = List.generate(_menuList.length, (index) {
      return Tween<Offset>(
        begin: Offset(0, 0),
        end: Offset(0, index * 50 * 1.0),
      ).animate(CurvedAnimation(
          parent: _animationController,
          curve: Interval(index * 0.1, index * 0.1 + 0.3)));
    });

    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(
      parent: _animationController,
      curve: Interval(0.4, 0.7),
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Material(
        child: Stack(
          children: <Widget>[
            MyHomePage(title: 'Flutter Demo Home Page'),
            AnimatedBuilder(
              animation: _animationController,
              builder: (BuildContext context, Widget child) {
                return CustomPaint(
                  painter: MenuPainter(radius: _menuBackgroundAnimation.value),
                  child: Center(
                    child: Container(
                      height: _menuList.length * 50 * 1.0,
                      child: FadeTransition(
                        opacity: _fadeAnimation,
                        child: Stack(
                          children: List.generate(_menuList.length, (index) {
                            return Transform.translate(
                              offset: _listAnimation[index].value,
                              child: Text(
                                _menuList[index],
                                style: TextStyle(
                                  color: Colors.blue,
                                  fontSize: 25,
                                ),
                              ),
                            );
                          }),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
            Container(
              constraints:
                  const BoxConstraints.tightFor(width: 56.0, height: 56.0),
              child: IconButton(
                  icon: AnimatedIcon(
                    icon: AnimatedIcons.menu_close,
                    progress: _animationController,
                  ),
                  onPressed: () {
                    if (_animationController.status ==
                        AnimationStatus.completed) {
                      _animationController.reverse();
                    } else {
                      _animationController.forward();
                    }
                  }),
            ),
          ],
        ),
      ),
    );
  }
}

class MenuPainter extends CustomPainter {
  final double radius;
  final Color backgroundColor;
  final Paint backgroundPaint;

  MenuPainter({
    this.radius,
    this.backgroundColor = Colors.white,
  }) : backgroundPaint = Paint()
          ..color = backgroundColor
          ..style = PaintingStyle.fill;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawCircle(Offset(30, 30), radius, backgroundPaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
