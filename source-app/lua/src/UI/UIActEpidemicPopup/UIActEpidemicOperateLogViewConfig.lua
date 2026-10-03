local UIActEpidemicOperateLogViewConfig = {
  Name = UIWindowNames.UIActEpidemicOperateLogView,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIActEpidemicPopup.Ctrl.UIActEpidemicOperateLogCtrl"),
  View = require("UI.UIActEpidemicPopup.View.UIActEpidemicOperateLogView"),
  PrefabPath = "Assets/Main/Prefabs/UI/BF_Epidemic/UIActivity/UIActEpidemicOperateLogView.prefab"
}
return {UIActEpidemicOperateLogViewConfig = UIActEpidemicOperateLogViewConfig}
