//import 'dart:html';
//import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:todo_app/database/task_helper.dart';
import 'package:todo_app/models/task.dart';
import 'package:todo_app/pages/edit_task_page.dart';
import 'package:todo_app/pages/read_task_page.dart';
import 'package:animations/animations.dart';
//import 'package:marquee/marquee.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'dart:math'; //show pow;
import 'package:confetti/confetti.dart';

class TasksPage extends StatefulWidget {
  const TasksPage({Key? key}) : super(key: key);
  @override
  _TasksPageState createState() => _TasksPageState();
}

class _TasksPageState extends State<TasksPage> {
  List<Task> tasks = [];
  bool isLoading = false;
  final Color primary = Colors.white;
  final Color active = Colors.grey.shade800;
  final Color divider = Colors.grey.shade400;
  final today = DateTime.parse(DateFormat('yyyyMMdd').format(DateTime.now()));

  @override
  void initState() {
    super.initState();
    loadTasks();
  }

  @override
  void dispose() {
    //TaskHelper.instance.closeDatabase();
    super.dispose();
  }

  Future loadTasks() async {
    setState(() => isLoading = true);
    tasks = await TaskHelper.instance.readAllTasks();
    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ToDo LIST'),
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
                icon: const Icon(Icons.menu),
                onPressed: () => Scaffold.of(context).openDrawer(),
                tooltip: 'Developer');
          },
        ),
      ),
      drawer: _buildDrawer(),
      drawerEdgeDragWidth: 0, //←エッジスワイプを不可に
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Scrollbar(
              thumbVisibility: true,
              thickness: 8,
              //hoverThickness: 16,
              radius: const Radius.circular(16),
              child: SizedBox(
                child: ListView.builder(
                  itemCount: tasks.length,
                  itemBuilder: (BuildContext context, int index) {
                    final task = tasks[index];
                    return Card(
                      color: Colors.white,
                      margin: const EdgeInsets.all(5),
                      elevation: 8,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: OpenContainer(
                        transitionDuration: const Duration(milliseconds: 600),
                        openBuilder: (context, _) =>
                            ReadTaskPage(taskId: task.id!),
                        onClosed: (_) => loadTasks(),
                        closedShape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(15),
                          ),
                        ),
                        closedColor: Colors.white,
                        closedBuilder: (context, openContainer) => InkWell(
                          borderRadius: BorderRadius.circular(15),
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Transform.scale(
                                  scale: 1.5,
                                  child: Checkbox(
                                    value: (task.completed == 1) ? true : false,
                                    onChanged: (bool? value) {
                                      setState(() => task.completed =
                                          (value == true) ? 1 : 0);
                                      TaskHelper.instance.updateTask(task);
                                    },
                                  ),
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Container(
                                          alignment: Alignment.center,
                                          child: _text(
                                            text: '${task.priority}',
                                            fontColor: Colors.white,
                                            bold: true,
                                            fontSize: 14,
                                          ),
                                          width: 28,
                                          height: 28,
                                          decoration: BoxDecoration(
                                            color: _selectPriorityColor(
                                                task.priority),
                                            shape: BoxShape.circle,
                                            //border: Border.all(color: Colors.black54, width: 1.5),
                                            /* boxShadow: const [
                                    BoxShadow(
                                      color: Colors.grey, //色
                                      //spreadRadius: 5,
                                      blurRadius: 8,
                                      offset: Offset(2, 2),
                                    ),
                                  ],*/
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        SizedBox(
                                          //width: 250.0,
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width -
                                              120,
                                          child: _text(
                                            text: task.name,
                                            bold: true,
                                            fontSize: 24,
                                            completed: (task.completed == 1)
                                                ? true
                                                : false,
                                            //shadow: true,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        _text(text: '期限：'),
                                        _text(
                                          text: DateFormat(
                                                  'yyyy/MM/dd E   ') //yyyy/MM/dd HH:mm
                                              .format(task.deadline),
                                        ),
                                        task.deadline.isAfter(
                                          today.add(const Duration(days: -1)),
                                        )
                                            ? _text(
                                                text:
                                                    'あと${task.deadline.difference(today).inDays}日',
                                                fontColor: Colors.indigo,
                                                bold: true,
                                              )
                                            : _text(
                                                text: '期限切れ',
                                                bold: true,
                                                fontColor: Colors.red,
                                                shadow: true,
                                                shadowColor: Colors.lime,
                                              ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          /* onTap: () async {
                            await Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) =>
                                    ReadTaskPage(taskId: task.id!),
                              ),
                            );
                            loadTasks();
                          }, */
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
      floatingActionButton: OpenContainer(
        transitionDuration: const Duration(milliseconds: 600),
        openBuilder: (context, _) => const EditTaskPage(),
        onClosed: (_) => loadTasks(),
        closedElevation: 8,
        openElevation: 8,
        closedShape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(28),
          ),
        ),
        closedColor: Colors.indigo,
        closedBuilder: (context, openContainer) => Container(
          color: Colors.indigo,
          height: 56,
          width: 56,
          child: const Center(
            child: Icon(Icons.add, color: Colors.white),
          ),
        ),
      ),

      /*
      floatingActionButton: FloatingActionButton(
        child: Container(
          child: const Icon(
            Icons.add,
          ),
          height: 56,
          width: 56,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              colors: [
                Colors.orangeAccent,
                Colors.redAccent,
              ],
            ),
          ),
        ),
        onPressed: () async {
          await Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => const EditTaskPage()),
          );
          loadTasks();
        },
        tooltip: '追加',
      ), */
    );
  }

  Color _selectPriorityColor(int priority) {
    Color color = Colors.white;
    switch (priority) {
      case 1:
        color = Colors.blue;
        break;
      case 2:
        color = Colors.green;
        break;
      case 3:
        color = Colors.orange;
        break;
      case 4:
        color = Colors.red;
        break;
      case 5:
        color = Colors.purple;
        break;
    }
    return color;
  }

  Text _text({
    required String text,
    bool bold = false,
    double fontSize = 15,
    Color fontColor = Colors.black,
    bool completed = false,
    bool shadow = false,
    Color shadowColor = Colors.grey,
  }) {
    return Text(text,
        style: TextStyle(
          fontSize: fontSize,
          color: completed ? Colors.black54 : fontColor,
          fontWeight: bold ? FontWeight.bold : null,
          decoration: completed ? TextDecoration.lineThrough : null,
          decorationColor: Colors.red.withOpacity(0.5),
          decorationThickness: 3.0,
          shadows: shadow
              ? [
                  Shadow(
                    offset: const Offset(1.0, 1.0),
                    blurRadius: 8.0,
                    color: shadowColor,
                  )
                ]
              : null,
        ),
        overflow: TextOverflow.ellipsis);
  }

  _buildDrawer() {
    //const String image = 'assets/logo.png';
    final controller =
        ConfettiController(duration: const Duration(milliseconds: 200));
    return ClipPath(
      clipper: OvalRightBorderClipper(),
      child: Drawer(
        child: Container(
          padding: const EdgeInsets.only(
            left: 16.0,
            right: 40,
          ),
          decoration: BoxDecoration(
            color: primary,
            boxShadow: const [
              BoxShadow(color: Colors.black45),
            ],
          ),
          width: 300,
          child: SafeArea(
            child: SingleChildScrollView(
              child: Stack(
                children: [
                  Column(
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          const Icon(Icons.favorite,
                              color: Colors.pink, size: 12),
                          Icon(Icons.hiking, color: active),
                          const Icon(Icons.terrain, color: Colors.green),
                        ],
                      ),
                      /* Draggable(
                  //data: 'Green',
                  child: logo(),
                  feedback: logo(),
                  childWhenDragging: const SizedBox(
                    width: 95,
                    height: 95)), */
                      //  const DraggableLogo(),//
                      /* Container(
                  height: 95,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      border: Border.all(
                          color: Colors.greenAccent.shade400, width: 5.0),
                      shape: BoxShape.circle,
                      color: primary),
                  child: const CircleAvatar(
                    radius: 40,
                    backgroundColor: Colors.white,
                    backgroundImage: AssetImage(image))), */
                      /* Container(
                  height: 95,
                  width: 95,
                  alignment: Alignment.center,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Colors.red,
                        Colors.yellow,
                      ])),
                  child: Container(
                    decoration: const BoxDecoration(
                        shape: BoxShape.circle, color: Colors.white),
                    padding: const EdgeInsets.all(2.0),
                    child: const CircleAvatar(
                      radius: 40,
                      backgroundColor: Colors.white,
                      backgroundImage: AssetImage(image),
                    ))), */
                      const SizedBox(height: 120.0),
                      const Text(
                        "FUKUJU IoT",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 18.0,
                            fontWeight: FontWeight.w600),
                      ),
                      Text(
                        "dev@AtsushiTanase",
                        style: TextStyle(color: active, fontSize: 16.0),
                      ),
                      const SizedBox(height: 40.0),
                      _buildRow(
                        icon: Icons.factory,
                        title: "Company profile",
                        comment:
                            "福寿工業株式会社\n岐阜県羽島市小熊町西小熊4005\nTel (058)392-2111\nFax (058)392-8723\nhttp://www.fukujukk.co.jp",
                        qr: true,
                        qrData: "http://www.fukujukk.co.jp",
                      ),
                      _buildRow(
                        icon: Icons.person,
                        title: "My profile",
                        comment: "棚瀬敦史\nトランスミッショングループ 製造",
                      ),
                      _buildRow(
                        icon: Icons.email,
                        title: "Contact us",
                        comment: "a_tanase@fukujukk.co.jp",
                        qr: true,
                        qrData: "a_tanase@fukujukk.co.jp",
                      ),
                      _buildRow(
                        icon: Icons.groups,
                        title: "About us",
                        comment: "FUKUJU IoT\nなにか役に立つモノが\n作れればと思ってます…",
                      ),
                    ],
                  ),
                  Positioned(
                    top: 40 + 95 / 2 - 10,
                    left: 248 / 2 - 10,
                    child: ConfettiWidget(
                      confettiController: controller,
                      //displayTarget: true,
                      numberOfParticles: 5,
                      blastDirectionality: BlastDirectionality.explosive,
                      colors: const [
                        Colors.yellowAccent,
                        Colors.blueAccent,
                        Colors.greenAccent
                      ],
                      createParticlePath: _drawStar,
                      maximumSize: const Size(40, 40),
                      minimumSize: const Size(10, 10),
                      maxBlastForce: 3,
                      minBlastForce: 2,
                      emissionFrequency: 0.5,
                    ),
                  ),
                  Positioned(
                    top: 40,
                    left: 248 / 2 - 95 / 2,
                    child: DraggableLogo(controller: controller),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Path _drawStar(Size size) {
    // Method to convert degree to radians
    double degToRad(double deg) => deg * (pi / 180.0);

    const numberOfPoints = 5;
    final halfWidth = size.width / 2;
    final externalRadius = halfWidth;
    final internalRadius = halfWidth / 2.5;
    final degreesPerStep = degToRad(360 / numberOfPoints);
    final halfDegreesPerStep = degreesPerStep / 2;
    final path = Path();
    final fullAngle = degToRad(360);
    path.moveTo(size.width, halfWidth);

    for (double step = 0; step < fullAngle; step += degreesPerStep) {
      path.lineTo(halfWidth + externalRadius * cos(step),
          halfWidth + externalRadius * sin(step));
      path.lineTo(halfWidth + internalRadius * cos(step + halfDegreesPerStep),
          halfWidth + internalRadius * sin(step + halfDegreesPerStep));
    }
    path.close();
    return path;
  }

  Widget _buildRow({
    required IconData icon,
    required String title,
    required String comment,
    bool qr = false,
    String? qrData,
  }) {
    final TextStyle textStyle = TextStyle(color: active, fontSize: 16.0);
    double qrSize = 100.0;
    double embeddedImageSize = qrSize * 0.2;
    return Column(
      children: <Widget>[
        ExpansionTile(
          //onExpansionChanged: (bool changed) {}, //←タップしたときの動作はココ
          leading: Icon(icon),
          title: Text(
            title,
            style: textStyle,
          ),
          children: [
            Text(comment),
            (qr)
                ? QrImage(
                    padding: const EdgeInsets.all(5),
                    data: qrData!,
                    version: QrVersions.auto,
                    size: qrSize,
                    embeddedImage: const AssetImage('assets/logo3.png'),
                    embeddedImageStyle: QrEmbeddedImageStyle(
                        size: Size(embeddedImageSize, embeddedImageSize)),
                    constrainErrorBounds: true,
                    embeddedImageEmitsError: true,
                  )
                : const SizedBox(),
            const SizedBox(height: 5),
          ],
          //subtitle: Text('subtitle'),
        ),
        Divider(thickness: 1, height: 0, color: divider),
      ],
    );
  }
}

Widget logo() {
  const String image = 'assets/logo.png';
  const double logoSize = 95.0;
  return Container(
    width: logoSize,
    height: logoSize,
    decoration:
        const BoxDecoration(shape: BoxShape.circle, color: Colors.transparent),
    padding: const EdgeInsets.all(6.0),
    child: const CircleAvatar(
      //radius: 42.5,
      backgroundColor: Colors.transparent,
      backgroundImage: AssetImage(image),
    ),
  );
}

class OvalRightBorderClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0, 0);
    path.lineTo(size.width - 40, 0);
    path.quadraticBezierTo(
        size.width, size.height / 4, size.width, size.height / 2);
    path.quadraticBezierTo(size.width, size.height - (size.height / 4),
        size.width - 40, size.height);
    path.lineTo(0, size.height);
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }
}

class DraggableLogo extends StatefulWidget {
  const DraggableLogo({Key? key, required this.controller}) : super(key: key);
  final ConfettiController controller;

  @override
  _DraggableLogoState createState() => _DraggableLogoState();
}

class _DraggableLogoState extends State<DraggableLogo> {
  static const _baseSize = 95.0;
  static const _targetSize = 95.0;
  static const _defaultDelta = (_baseSize - _targetSize) / 2;

  var _offset = Offset.zero;

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          alignment: Alignment.center,
          width: _baseSize,
          height: _baseSize,
          decoration: const BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Colors.red, Colors.yellow])),
          child: Container(
              width: 85,
              height: 85,
              decoration: const BoxDecoration(
                  shape: BoxShape.circle, color: Colors.white)),
        ),
        AnimatedPositioned(
          left: _defaultDelta + _offset.dx,
          top: _defaultDelta + _offset.dy,
          duration: Duration(milliseconds: _offset == Offset.zero ? 800 : 0),
          curve: Curves.elasticOut,
          child: GestureDetector(
              onPanUpdate: (update) => setState(() => _offset += update.delta),
              onPanEnd: (info) {
                if (pow(_offset.dx, 2) + pow(_offset.dy, 2) <=
                    pow(_baseSize / 2, 2)) {
                  return;
                }
                setState(() {
                  _offset = Offset.zero;
                  widget.controller.play();
                });
              },
              child: logo()),
        ),
      ],
    );
  }
}
