

import 'package:streamberry_client/src/blocs/button_panel/button_functions/button_action.dart';
import 'package:streamberry_client/src/blocs/button_panel/button_functions/button_functions.dart';
import 'package:streamberry_client/src/blocs/button_panel/button_functions/folder/actions/close_folder_action.dart';
import 'package:streamberry_client/src/blocs/button_panel/button_functions/folder/actions/open_folder_action.dart';

class FolderFunctions extends ButtonFunctions {

  @override
  get title => 'Folders';

  @override
  Map<String, ButtonAction> actions(Map<String, String> params) => {
    OpenFolderAction().actionName: OpenFolderAction()..setParams(params),
    CloseFolderAction().actionName: CloseFolderAction()..setParams(params),
  };

  @override
  get function => 'folderFunctions';

}
