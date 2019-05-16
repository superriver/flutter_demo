import 'package:flutter/material.dart';

import 'dart:math';

class TestWave extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _TestWaveState();
  }
}

class _TestWaveState extends State<TestWave> with TickerProviderStateMixin {
  List<Wave> waves;
  Animation<double> animation;

  VoidCallback _voidCallback;
  int waveCount = 10;
  double screenWidth;
  double screenHeight;
  GlobalKey _myKey = new GlobalKey();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // final screenSize =MediaQuery.of(context).size;
    //size = new Size(screenSize.width, screenSize.height);
    //size = new Size(400, 800);

//    print("${context.size.height}");
//    print("${context.size.width}");
    createWave(Size(400, 700));
    setWaveCount(waveCount);
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
//    screenWidth = MediaQuery.of(context).size.width;
//    screenHeight = MediaQuery.of(context).size.height;
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    return SizedBox(
      child: CustomPaint(painter: WavePainter(animation,waves),),
      width: 400,
      height: 700,
    );
  }

  void createWave(Size s) {
    if (waves == null) {
      waves = [];
    }
    waves.clear();
    for (int i = 0; i < 17; i++) {
      Wave wave = new Wave(s);
      initAnimator(wave);
      waves.add(wave);
    }
  }

  void setWaveCount(int count) {
    int size = waves.length;
    if (count > size) {
      count = size;
    }
    for (int i = 0; i < size; i++) {
      if (i < count) {
        waves[i].playing = true;
      } else {
        waves[i].playing = false;
      }
    }
  }

  void setVolume(double volume) {
    if (volume <= 3) {
      amplitude = 0.5;
      waveCount = 10;
      wAmplitude = 1.2;
    } else if (volume > 3 && volume < 10) {
      amplitude = 0.7;
      waveCount = 10;
      wAmplitude = 1;
    } else if (volume > 10 && volume < 20) {
      amplitude = 0.9;
    } else if (volume > 20) {
      waveCount = 10;
      amplitude = 1.2;
    }

    setWaveCount(waveCount);
  }

  void initAnimator(final Wave waveBean) {
    AnimationController animationController = new AnimationController(
        duration: const Duration(milliseconds: 1000), vsync: this);
    animation = new Tween(begin: 0.0, end: waveBean.maxHeight)
        .animate(animationController);
//    animation = new CurvedAnimation(
//        parent: animationController, curve: Curves.fastOutSlowIn);
    animation.addListener(_voidCallback = () {
      setState(() {
        // print("animation=$animation.value");
        waveBean.waveHeight = animation.value;
        if (waveBean.waveHeight > waveBean.maxHeight / 2) {
          waveBean.waveHeight = waveBean.maxHeight - waveBean.waveHeight;
        }
      });
    });

    animation.addStatusListener((animationStatus) {
      if (animationStatus == AnimationStatus.completed) {
        // animation.removeListener(_voidCallback);
        // animationController.reset();
        if (waveBean.playing) {
          print("开始重新绘制");
          print(waveBean.playing);
          waveBean.respawn();
          initAnimator(waveBean);
        }
      } else if (animationStatus == AnimationStatus.forward) {}
    });
    animationController.forward();
  }
}

var lineColors = [0xFF111111, 0xFFFFFFFF, 0xFFFFFFFF, 0xFF111111];

var colors = [Colors.purple, Colors.green, Colors.blue];
double amplitude = 0.3;
double wAmplitude = 1.0;

class WavePainter extends CustomPainter {
  Paint mPaint;
  List<Wave> waves;
  final Animation<double> animation;
  double mHeight;
  double mWidth;

  WavePainter(Animation<double> animation, this.waves)
      : animation = animation,
        super(repaint: animation);

  @override
  void paint(Canvas canvas, Size size) {
    //  print("####" + size.toString());
    // TODO: implement paint
    mHeight = size.height;
    mWidth = size.width;
    mPaint = Paint();
    print("mHeight=$mHeight");
    print("mWidth=$mWidth");
    mPaint.color = Colors.white;
    canvas.drawRect(Rect.fromLTRB(0, 0, mWidth, mHeight), mPaint);
    canvas.saveLayer(Rect.fromLTWH(0, 0, mWidth, mHeight), mPaint);
    mPaint.blendMode = BlendMode.plus;
  //  drawLine(canvas);
    waves.forEach((item) => _checkData(canvas, item));
    canvas.restore();
  }

  void _checkData(Canvas canvas, Wave item) {
    if (item.playing) {
      item.draw(canvas, mPaint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    // TODO: implement shouldRepaint
    return false;
  }

  List<Color> lineColors = [Colors.red, Colors.blue, Colors.blue, Colors.red];
  List<double> linepositions = [0.0, 0.1, 0.9, 1.0];

  void drawLine(Canvas canvas) {
    canvas.save();
    LinearGradient shader = LinearGradient(
        colors: lineColors, stops: linepositions, tileMode: TileMode.mirror);
    mPaint.strokeWidth = 2;
    Rect rect = Rect.fromLTRB(mWidth / 40, 0, mWidth * 39 / 40, 0);
    mPaint.shader = shader.createShader(rect);
    canvas.drawLine(Offset(mWidth / 40, mHeight / 2),
        Offset(mWidth * 39 / 40, mHeight / 2), mPaint);
//        mPaint.setXfermode(null);
    mPaint.shader = null;
    //mPaint.clearShadowLayer();
    canvas.restore();
  }
}

class Wave {
  double mHeight;
  double mWidth;
  bool playing = false;
  double maxHeight;
  double maxWidth;
  var waveColor;
  double speed = 0.3;
  double seed, open_class;

  double waveHeight;
  int duration;
  Paint mPaint;
  Random random;
  double max;

  Wave(Size size) {
    mHeight = size.height;
    mWidth = size.width;
    max = mHeight * 2 / 3;
    random = new Random();
    respawn();
  }

  void respawn() {
    this.seed = random.nextDouble(); // 位置
    maxWidth = (random.nextInt((mWidth / 16).floor()) + mWidth * 3 / 11);
    if (seed <= 0.2) {
      maxHeight = (random.nextInt((max / 6).floor()) + max / 5);
      // print("1=$maxHeight");
      open_class = 2;
    } else if (seed <= 0.3 && seed > 0.2) {
      maxHeight = (random.nextInt((max / 3).floor()) + max * 1 / 5);
      open_class = 3;
      // print("2=$maxHeight");
    } else if (seed > 0.3 && seed <= 0.7) {
      maxHeight = (random.nextInt((max / 2).floor()) + max * 2 / 5);
      open_class = 3;
      //print("3=$maxHeight");
    } else if (seed > 0.7 && seed <= 0.8) {
      maxHeight = (random.nextInt((max / 3).floor()) + max * 1 / 5);
      open_class = 3;
      // print("4=$maxHeight");
    } else if (seed > 0.8) {
      maxHeight = (random.nextInt((max / 6).floor()) + max / 5);
      open_class = 2;
      // print("5=$maxHeight");
    }
    duration = random.nextInt(1000) + 1000;
    waveColor = colors[random.nextInt(3)];
  }

  double equation(double i) {
    i = i.abs();
    double y = -1 * amplitude * pow(1 / (1 + pow(open_class * i, 2)), 2);
    return y;
  }

  void draw(Canvas canvas, Paint mPaint) {
    this.mPaint = mPaint;

    this._draw(1, canvas);
  }

  void _draw(int m, Canvas canvas) {
    Path path = new Path();
    Path pathN = new Path();
    path.moveTo(mWidth / 4, mHeight / 2);
    pathN.moveTo(mWidth / 4, mHeight / 2);
    double x_base = mWidth / 2 // 波浪位置
        +
        (-mWidth / 6 + this.seed * (mWidth / 3));
    double y_base = mHeight / 2;

    double x, y, x_init = 0;
    double i = -1;
    while (i <= 1) {
      x = x_base + i * maxWidth * wAmplitude;
      double function = equation(i) * waveHeight;
      y = y_base + function;
      if (x_init > 0 || x > 0) {
        x_init = mWidth / 4;
      }
      if (y > 0.1) {
        path.lineTo(x, y);
        pathN.lineTo(x, y_base - function);
      }
      i += 0.01;
    }

    mPaint.color = waveColor;
    canvas.drawPath(path, mPaint);
    canvas.drawPath(pathN, mPaint);
//            mPaint.setXfermode(null);
  }
}
