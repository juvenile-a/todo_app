import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:todo_app/database/task_helper.dart';
import 'package:todo_app/models/task.dart';
import 'package:todo_app/pages/task_form_page.dart';

class EditTaskPage extends StatefulWidget {
  final Task? task;

  const EditTaskPage({
    Key? key,
    this.task,
  }) : super(key: key);

  @override
  _EditTaskPageState createState() => _EditTaskPageState();
}

class _EditTaskPageState extends State<EditTaskPage> {
  final _formkey = GlobalKey<FormState>();
  late String name;
  late int priority;
  late DateTime deadline;
  late String? memo;
  late int completed;
  late DateTime today;

  final focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    today = DateTime.parse(DateFormat('yyyyMMdd').format(DateTime.now()));
    name = widget.task?.name ?? '';
    priority = widget.task?.priority ?? 3;
    deadline = widget.task?.deadline ?? today;
    memo = widget.task?.memo;
    completed = widget.task?.completed ?? 0;
  }

  @override
  Widget build(BuildContext context) {
    return Focus(
      focusNode: focusNode,
      child: GestureDetector(
        onTap: focusNode.requestFocus,
        child: Scaffold(
          appBar: AppBar(
            title: const Text('タスクの編集'),
            actions: [
              buildSaveButton(),
            ],
          ),
          body: SingleChildScrollView(
            child: Form(
              key: _formkey,
              child: TaskFormPage(
                name: name,
                priority: priority,
                deadline: deadline,
                memo: memo,
                completed: completed,
                onChangedName: (name) => setState(() => this.name = name),
                onChangedPriority: (priority) =>
                    setState(() => this.priority = priority),
                onChangedDeadline: (deadline) =>
                    setState(() => this.deadline = deadline),
                onChangedMemo: (memo) => setState(() => this.memo = memo),
                onChangedCompleted: (completed) =>
                    setState(() => this.completed = completed),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildSaveButton() {
    final isFormValid = name.isNotEmpty;
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: ElevatedButton(
        child: const Text('保存'),
        style: ElevatedButton.styleFrom(
          onPrimary: Colors.white,
          primary: isFormValid ? Colors.redAccent : Colors.grey.shade700,
        ),
        onPressed: _createOrUpdateTask,
      ),
    );
  }

  void _createOrUpdateTask() async {
    final isValid = _formkey.currentState!.validate();
    if (isValid) {
      final isUpdate = (widget.task != null);
      if (isUpdate) {
        await updateTask();
      } else {
        await createTask();
      }
      Navigator.of(context).pop();
    }
  }

  Future updateTask() async {
    final task = widget.task!.copy(
      name: name,
      priority: priority,
      deadline: deadline,
      memo: memo,
      completed: completed,
    );

    await TaskHelper.instance.updateTask(task);
  }

  Future createTask() async {
    final task = Task(
      name: name,
      priority: priority,
      deadline: deadline,
      memo: memo ?? '',
      completed: completed,
    );

    await TaskHelper.instance.createTask(task);
  }
}
