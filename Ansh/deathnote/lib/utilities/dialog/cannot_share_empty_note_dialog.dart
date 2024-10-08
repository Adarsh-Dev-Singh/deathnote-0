import 'package:deathnote/utilities/dialog/generic_dialog.dart';
import 'package:flutter/material.dart';

Future<void> showCannotShareEmptyNoteDialog(BuildContext context) {
  return showGenericDialog(
    context: context,
    title: 'Shating',
    content: 'You cannot share an empty note!',
    optionsBuilder: () => {
      'OK': null,
    },
  );
}
