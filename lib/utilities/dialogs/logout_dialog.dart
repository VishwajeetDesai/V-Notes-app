import 'package:flutter/widgets.dart';
import 'package:practice/utilities/dialogs/generic_dialog.dart';

Future<bool> showLogOutDialog(BuildContext context) {
  return showGenericDialog<bool>(
    context: context,
    title: 'Logout',
    content: 'Are You Sure You Want To Logout',
    optionsBuilder: () => {
      'Cancel': false,
      'LogOut': true,
    },
  ).then((value) => value ?? false);
}
