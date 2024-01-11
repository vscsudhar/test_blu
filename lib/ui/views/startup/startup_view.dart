import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:stacked/stacked.dart';
import 'package:test_blu/ui/common/ui_helpers.dart';

import 'startup_viewmodel.dart';

class StartupView extends StackedView<StartupViewModel> {
  const StartupView({Key? key}) : super(key: key);

  @override
  Widget builder(
    BuildContext context,
    StartupViewModel viewModel,
    Widget? child,
  ) {
    return Scaffold(
      backgroundColor: const Color(0xffffffff),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: 150,
              width: 150,
              child: Image.asset('assets/images/cowma.jpeg'),
            ),
            // const Text(
            //   'COWMA',
            //   style: TextStyle(fontSize: 40, fontWeight: FontWeight.w900),
            // ),
            const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Loading ...', style: TextStyle(fontSize: 16, color: Color(0xFFF2008D))),
                horizontalSpaceSmall,
                SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(
                    color: Color(0xFFF2008D),
                    strokeWidth: 6,
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  StartupViewModel viewModelBuilder(
    BuildContext context,
  ) =>
      StartupViewModel();

  @override
  void onViewModelReady(StartupViewModel viewModel) => SchedulerBinding.instance.addPostFrameCallback((timeStamp) => viewModel.runStartupLogic());
}
