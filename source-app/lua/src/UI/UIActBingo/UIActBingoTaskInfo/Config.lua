local UIActBingoTaskInfo = {
  Name = UIWindowNames.UIActBingoTaskInfo,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIActBingo.UIActBingoTaskInfo.Controller.UIActBingoTaskInfoCtrl"),
  View = require("UI.UIActBingo.UIActBingoTaskInfo.View.UIActBingoTaskInfoView"),
  PrefabPath = "Assets/Main/Prefabs/UI/ActivityCenter/ActBingo/UIActBingoTaskInfo.prefab"
}
return {UIActBingoTaskInfo = UIActBingoTaskInfo}
