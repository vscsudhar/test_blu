import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:stacked/stacked.dart';
import 'package:test_blu/ui/common/shared/styles.dart';
import 'package:test_blu/ui/common/ui_helpers.dart';
import 'package:test_blu/ui/common/widgets/button.dart';
import 'package:test_blu/ui/common/widgets/text_field1.dart';
import 'package:test_blu/ui/views/login/widgets/register_page.dart';

import 'login_viewmodel.dart';

class LoginView extends StackedView<LoginViewModel> {
  const LoginView({Key? key}) : super(key: key);
  static final formKey = GlobalKey<FormState>();

  @override
  Widget builder(
    BuildContext context,
    LoginViewModel viewModel,
    Widget? child,
  ) {
    return Scaffold(
        appBar: AppBar(),
        backgroundColor: Colors.white,
        body: Padding(
          padding: defaultPadding12,
          child: Form(
            key: formKey,
            child: Column(children: [
              verticalSpaceMedium,
              verticalSpaceMedium,
              verticalSpaceMedium,
              InkWell(
                onLongPress: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const Register()));
                },
                child: Text(
                  'Login',
                  style: fontFamilyMedium.appChambray1.size28,
                ),
              ),
              verticalSpacing12,
              RawKeyboardListener(
                focusNode: FocusNode(canRequestFocus: false),
                onKey: (RawKeyEvent event) {
                  if (event is RawKeyDownEvent) {
                    if (event.logicalKey == LogicalKeyboardKey.escape) {
                      viewModel.goBack(context);
                    }
                  }
                },
                child: TextField1(
                  color: Colors.black,
                  hintText: 'User Name',
                  validator: (val) {
                    if (val == null || val.isEmpty) {
                      return 'User Name is required';
                    }
                    return null;
                  },
                  onSaved: (userName) => viewModel.setUserName(userName.toString()),
                ),
              ),
              verticalSpacing12,
              RawKeyboardListener(
                focusNode: FocusNode(canRequestFocus: true),
                onKey: (RawKeyEvent event) {
                  if (event is RawKeyDownEvent) {
                    if (event.logicalKey == LogicalKeyboardKey.escape) {
                      viewModel.goBack(context);
                    } else if (event.logicalKey == LogicalKeyboardKey.enter) {
                      viewModel.loginData();
                    }
                  }
                },
                child: TextField1(
                  obscureText: true,
                  color: Colors.black,
                  hintText: 'PassWord',
                  validator: (val) {
                    if (val == null || val.isEmpty) {
                      return 'Password is required';
                    }
                    return null;
                  },
                  onSaved: (pass) => viewModel.setUserPass(pass.toString()),
                ),
              ),
              verticalSpacing16,
              Button(
                  name: 'Login',
                  onTap: () {
                    if (formKey.currentState?.validate() ?? false) {
                      formKey.currentState?.save();
                      viewModel.loginData();
                      formKey.currentState?.reset();
                    }
                  })
            ]),
          ),
        ));
  }

  @override
  LoginViewModel viewModelBuilder(
    BuildContext context,
  ) =>
      LoginViewModel();
}
