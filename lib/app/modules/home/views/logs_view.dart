import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:talker_flutter/talker_flutter.dart';
import 'package:waifspace/app/global.dart';

class LogsView extends GetView {
  const LogsView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: TalkerScreen(talker: talker),
    );
  }
}
