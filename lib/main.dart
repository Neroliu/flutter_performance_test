import 'dart:async';
import 'dart:ui';

import 'package:figma_squircle/figma_squircle.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'dart:math' as math;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a blue toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    Navigator.push(context, MaterialPageRoute(builder: (context){
      return const PerformanceListView();
    },),);
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // TRY THIS: Try changing the color here to a specific color (to
        // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        // change color while the other colors stay the same.
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          //
          // TRY THIS: Invoke "debug painting" (choose the "Toggle Debug Paint"
          // action in the IDE, or press "p" in the console), to see the
          // wireframe for each widget.
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

extension WidgetModifier on Widget {
  Widget smoothRadiusAll({required double radius, double smoothing = 0.6, Clip clipBehavior = Clip.antiAlias}) {
    return ClipSmoothRect(
      radius: SmoothBorderRadius(cornerRadius: radius, cornerSmoothing: smoothing),
      clipBehavior: clipBehavior,
      child: this,
    );
  }

  Widget smoothRadiusOnly(
      {double topLeftRadius = 0.0,
        double topLeftSmoothing = 0.6,
        double topRightRadius = 0.0,
        double topRightSmoothing = 0.6,
        double bottomLeftRadius = 0.0,
        double bottomLeftSmoothing = 0.6,
        double bottomRightRadius = 0.0,
        double bottomRightSmoothing = 0.6,
        Clip clipBehavior = Clip.antiAlias}) {
    return ClipSmoothRect(
      radius: SmoothBorderRadius.only(
        topLeft: SmoothRadius(cornerRadius: topLeftRadius, cornerSmoothing: topLeftSmoothing),
        topRight: SmoothRadius(cornerRadius: topRightRadius, cornerSmoothing: topRightSmoothing),
        bottomLeft: SmoothRadius(cornerRadius: bottomLeftRadius, cornerSmoothing: bottomLeftSmoothing),
        bottomRight: SmoothRadius(cornerRadius: bottomRightRadius, cornerSmoothing: bottomRightSmoothing),
      ),
      clipBehavior: clipBehavior,
      child: this,
    );
  }
}




mixin ScrollExtentContext {
  double get minScrollExtent;
  double get maxScrollExtent;
}

class ScrollToEndActivity extends ScrollActivity {
  /// Creates an activity that animates a scroll view based on animation
  /// parameters.
  ///
  /// All of the parameters must be non-null.
  ScrollToEndActivity(
      ScrollActivityDelegate delegate, {
        required double from,
        required double to,
        required Curve curve,
        required Duration duration,
        required TickerProvider vsync,
      }) : assert(from != null),
        assert(to != null),
        assert(curve != null),
        super(delegate) {
    _completer = Completer<void>();
    _controller = AnimationController.unbounded(
      value: from,
      debugLabel: objectRuntimeType(this, 'DrivenScrollActivity'),
      vsync: vsync,
      duration: duration,
    )
      ..addListener(_tick)
      ..animateTo(to, curve: curve)
          .whenComplete(_end); // won't trigger if we dispose _controller first
  }

  late final Completer<void> _completer;
  late final AnimationController _controller;

  /// A [Future] that completes when the activity stops.
  ///
  /// For example, this [Future] will complete if the animation reaches the end
  /// or if the user interacts with the scroll view in way that causes the
  /// animation to stop before it reaches the end.
  Future<void> get done => _completer.future;

  void _tick() {
    if (delegate.setPixels(_controller.value) != 0.0)
      delegate.goIdle();
  }

  void _end() {
    delegate.goBallistic(0.0);
  }

  @override
  void dispatchOverscrollNotification(ScrollMetrics metrics, BuildContext context, double overscroll) {
    OverscrollNotification(metrics: metrics, context: context, overscroll: overscroll, velocity: velocity).dispatch(context);
  }

  @override
  void dispatchScrollStartNotification(ScrollMetrics metrics, BuildContext? context) {
    UserScrollNotification(metrics: metrics, context: context!, direction: ScrollDirection.forward).dispatch(context);
  }

  @override
  void dispatchScrollEndNotification(ScrollMetrics metrics, BuildContext context) {
    UserScrollNotification(metrics: metrics, context: context, direction: ScrollDirection.idle).dispatch(context);
  }

  @override
  bool get shouldIgnorePointer => true;

  @override
  bool get isScrolling => true;

  @override
  double get velocity => _controller.velocity;

  @override
  void dispose() {
    _completer.complete();
    _controller.dispose();
    super.dispose();
  }

  @override
  void applyNewDimensions() {
    super.applyNewDimensions();
    if (delegate is ScrollExtentContext) {
      _controller.stop();
      _controller.animateTo((delegate as ScrollExtentContext).maxScrollExtent).whenComplete(_end);
    }
  }

  @override
  String toString() {
    return '${describeIdentity(this)}($_controller)';
  }
}


class MMScrollPositionWithSingleContext extends ScrollPositionWithSingleContext with ScrollExtentContext{

  Map<int, double>? _indexToLayoutOffset;

  MMScrollPositionWithSingleContext({
    required ScrollPhysics physics,
    required ScrollContext context,
    double? initialPixels = 0.0,
    bool keepScrollOffset = true,
    ScrollPosition? oldPosition,
    String? debugLabel,
  }) : super(
    physics: physics,
    context: context,
    initialPixels: initialPixels,
    keepScrollOffset: keepScrollOffset,
    oldPosition: oldPosition,
    debugLabel: debugLabel,
  );

  @override
  void goBallistic(double velocity) {
    super.goBallistic(velocity);
    // assert(hasPixels);
    // final Simulation? simulation = physics.createBallisticSimulation(this, velocity);
    // if (simulation != null) {
    //   beginActivity(MMSuspendedBallisticScrollActivity(this, simulation, context.vsync));
    // } else {
    //   goIdle();
    // }
  }

  @override
  bool correctForNewDimensions(ScrollMetrics oldPosition, ScrollMetrics newPosition) {
    if (activity == null) {
      return true;
    }
    return super.correctForNewDimensions(oldPosition, newPosition);
  }

  @override
  void applyNewDimensions() {
    if (activity == null) {
      return;
    }
    super.applyNewDimensions();
  }

  void animateToEnd({Curve curve = Curves.linear, Duration duration = const Duration(milliseconds: 300),}) {
    beginActivity(ScrollToEndActivity(this,
        from: pixels,
        to: maxScrollExtent,
        curve: curve,
        duration: duration,
        vsync: context.vsync));
  }

  @override
  void updateLayout(Map<int, double>? indexToLayoutOffset) {
    _indexToLayoutOffset = indexToLayoutOffset;
  }

  Map<int, double>? get indexToLayoutOffset => _indexToLayoutOffset;

  @override
  void absorb(ScrollPosition other) {
    super.absorb(other);
    if (other is! MMScrollPositionWithSingleContext) {
      return;
    }
    updateLayout(other.indexToLayoutOffset);
  }
}

class MMScrollController extends ScrollController {
  MMScrollController({
    double initialScrollOffset = 0.0,
    bool keepScrollOffset = true,
    String? debugLabel,
  }) : super(
    initialScrollOffset: initialScrollOffset,
    keepScrollOffset: keepScrollOffset,
    debugLabel: debugLabel,
  );

  @override
  ScrollPosition createScrollPosition(ScrollPhysics physics, ScrollContext context, ScrollPosition? oldPosition) {
    return MMScrollPositionWithSingleContext(
      physics: physics,
      context: context,
      initialPixels: initialScrollOffset,
      keepScrollOffset: keepScrollOffset,
      oldPosition: oldPosition,
      debugLabel: debugLabel,
    );
  }

  void animateToEnd({Curve curve = Curves.linear, Duration duration = const Duration(milliseconds: 300),}) {
    (position as MMScrollPositionWithSingleContext).animateToEnd(curve: curve, duration: duration);
  }
}



class PerformanceListView extends StatefulWidget {
  const PerformanceListView({super.key});

  @override
  State<PerformanceListView> createState() => _PerformanceListViewState();
}

class _PerformanceListViewState extends State<PerformanceListView> {
  late final MMScrollController _controller;
  Timer? _timer;
  Timer? _fpsTimer;
  bool animateToEnd = false;
  int fps = 0;
  List<int> timeDiff = List<int>.empty(growable: true);
  List<double> timeTotal= List<double>.empty(growable: true);
  List<int> fpsTotal = List<int>.empty(growable: true);
  int lastMilliseconds = 0;
  bool _isDisposed = false;
  static const timerDuration = Duration(milliseconds: 10000);
  int testTimes = 20;
  int currentTimes = 0;
  bool inTest = false;
  double _avgFrameTime = 0.0;
  double _avgFps = 0.0;

  @override
  void initState() {
    super.initState();
    _isDisposed = false;
    _controller = MMScrollController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("PerformanceListView"),
      ),
      body: Stack(
        children: [
          IgnorePointer(
            child: ListView.builder(
              itemBuilder: buildItem,
              controller: _controller,
              itemCount: 30,
            ),
          ),
          Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(20)),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                  child: Container(
                    color: Colors.white60,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text("平均帧间隔: ${_avgFrameTime.toStringAsFixed(5)}", style: TextStyle(fontSize: 14, color: Colors.black),),
                          SizedBox(width: 8,),
                          Text("平均 fps：${_avgFps.toStringAsFixed(5)}", style: TextStyle(fontSize: 14, color: Colors.black)),
                          SizedBox(width: 8,),
                          ClipRRect(
                            borderRadius: BorderRadius.all(Radius.circular(8)),
                            child:
                            GestureDetector(
                              onTap: (){
                                final preInTest = inTest;
                                preInTest ? stopTest() : startTest();
                              },
                              child: Container(
                                color: Colors.blueAccent,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(inTest ? "停止测试" : "开始测试", style: TextStyle(fontSize: 14, color: Colors.white),),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  void stopTest() {
    inTest = false;
    var tempTotalTime = 0.0;
    var tempTotalFps = 0;
    final timeCount = timeTotal.length;
    final fpsCount = fpsTotal.length;
    for(var frameTime in timeTotal) {
      tempTotalTime += frameTime;
    }
    for(var tempFps in fpsTotal) {
      tempTotalFps += tempFps;
    }
    if (timeCount > 0) {
      _avgFrameTime = tempTotalTime / timeCount;
      print("nero, test finish, frame time avg = $_avgFrameTime");
    }
    if (fpsCount > 0) {
      _avgFps = tempTotalFps / fpsCount;
      print("nero, test finish, fps avg = $_avgFps");
    }
    timeTotal.clear();
    fpsTotal.clear();
    _timer?.cancel();
    _fpsTimer?.cancel();
    lastMilliseconds = 0;
    _timer = null;
    _fpsTimer = null;
    currentTimes = 0;
    setState(() {

    });
  }

  void startTest() {
    inTest = true;
    _timer = Timer.periodic(timerDuration, (timer) {
      if (!_controller.hasClients) {
        return;
      }
      _fpsTimer ??= Timer.periodic(Duration(seconds: 1), (timer) {
        final currentFps = fps;
        fps = 0;
        var totalTime = 0;
        final count = timeDiff.length;
        for (var element in timeDiff) {
          totalTime += element;
        }
        timeDiff.clear();
        final avgTime = totalTime / count;
        if (count > 0) {
          timeTotal.add(avgTime);
          fpsTotal.add(currentFps);
          print("nero, avg build time = $avgTime");
          print("nero, fps = $currentFps");
        }
      });
      animateToEnd ? _controller.animateTo(0, duration: timerDuration, curve: Curves.linear) : _controller.animateToEnd(duration: timerDuration);
      animateToEnd = !animateToEnd;
      currentTimes ++;
      if (currentTimes > testTimes) {
        stopTest();
      }
    });
    animateToEnd ? _controller.animateTo(0, duration: timerDuration, curve: Curves.linear) : _controller.animateToEnd(duration: timerDuration);
    animateToEnd = !animateToEnd;
    currentTimes ++;
    if (currentTimes > testTimes) {
      stopTest();
    }
    WidgetsBinding.instance.addPostFrameCallback(_fpsCheck);
    setState(() {
    });
  }

  Widget buildItem(context, index) {
    final radius = math.Random().nextInt(20);
    final imgIndex = math.Random().nextInt(1000);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        height: 400,
        child: ColoredBox(
          color: Colors.blueAccent,
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
            child: Image.asset(
              "assets/images/test.jpg",
              fit: BoxFit.cover,
            ),
          ),
        ).smoothRadiusAll(radius: radius.toDouble(),),
      ),
    );
    return Container();
  }

  void _fpsCheck(Duration timestamp) {
    fps ++;
    if (inTest) {
      WidgetsBinding.instance.addPostFrameCallback(_fpsCheck);
    }
    if (lastMilliseconds != 0) {
      timeDiff.add(timestamp.inMilliseconds - lastMilliseconds);
    }
    lastMilliseconds = timestamp.inMilliseconds;
  }

  @override
  void dispose() {
    super.dispose();
    stopTest();
    _isDisposed = true;
    _controller.dispose();
  }
}
