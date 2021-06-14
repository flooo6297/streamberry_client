

import 'package:streamberry_client/src/blocs/button_panel/default_button/button_functions/button_action.dart';
import 'package:streamberry_client/src/blocs/button_panel/default_button/button_functions/button_functions.dart';
import 'package:streamberry_client/src/blocs/button_panel/default_button/button_functions/folder/actions/close_folder_action.dart';
import 'package:streamberry_client/src/blocs/button_panel/default_button/button_functions/folder/actions/open_folder_action.dart';

class FolderFunctions extends ButtonFunctions {

  @override
  get title => 'Folders';

  @override
  Map<String, ButtonAction> actions(Map<String, String> params) =>
      <ButtonAction>[
        OpenFolderAction(this),
        CloseFolderAction(this),
      ].asMap().map((key, value) => MapEntry(value.actionName, value));

  @override
  get function => 'folderFunctions';

}
