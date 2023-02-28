import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:todo_app/database/task_helper.dart';
import 'package:todo_app/models/task.dart';
import 'package:todo_app/pages/edit_task_page.dart';

class ReadTaskPage extends StatefulWidget {
  final int taskId;

  const ReadTaskPage({
    Key? key,
    required this.taskId,
  }) : super(key: key);

  @override
  _ReadTaskPageState createState() => _ReadTaskPageState();
}

class _ReadTaskPageState extends State<ReadTaskPage> {
  late Task task;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    loadTask();
  }

  Future loadTask() async {
    setState(() => isLoading = true);
    task = await TaskHelper.instance.readTask(widget.taskId);
    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          IconButton(
            icon: const Icon(
              Icons.edit,
              //color: Colors.white,
            ),
            onPressed: () async {
              await Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => EditTaskPage(
                    task: task,
                  ),
                ),
              );
              loadTask();
            },
            tooltip: '編集',
          ),
          IconButton(
            icon: const Icon(
              Icons.delete,
            ),
            onPressed: isLoading
                ? null
                : (task.completed == 0)
                    ? null
                    : () async {
                        await TaskHelper.instance.deleteTask(widget.taskId);
                        Navigator.of(context).pop();
                      },
            tooltip: '削除',
          ),
        ],
      ),
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
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(20.0),
                        child: Row(
                          children: [
                            Container(
                              alignment: Alignment.center,
                              child: Text(
                                '${task.priority}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 24,
                                ),
                              ),
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(color: Colors.black),
                              ),
                            ),
                            const SizedBox(
                              width: 20,
                            ),
                            Expanded(
                              child: Text(
                                task.name,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 24,
                                ),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 2,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        child: const Text('  期限'),
                        color: Colors.grey[300],
                        height: 22,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 5,
                        ),
                      ),
                      Container(
                        child: Text(
                          DateFormat('yyyy/MM/dd E')
                              .format(task.deadline), //yyyy/MM/dd HH:mm
                          style: const TextStyle(
                            fontSize: 18,
                          ),
                        ),
                        padding: const EdgeInsets.all(5.0),
                      ),
                      Container(
                        child: const Text('  進捗'),
                        color: Colors.grey[300],
                        height: 22,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 5,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(5.0),
                        child: Text(
                          (task.completed == 0) ? '未完了' : '完了',
                          style: const TextStyle(
                            fontSize: 18,
                          ),
                          //maxLines: 5,
                        ),
                      ),
                      Container(
                        child: const Text('  メモ'),
                        color: Colors.grey[300],
                        height: 22,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 5,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(5.0),
                        child: Text(
                          task.memo,
                          //maxLines: 5,
                          style: const TextStyle(
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
