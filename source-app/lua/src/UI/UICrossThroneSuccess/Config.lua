local UICrossThroneSuccess = {
  Name = UIWindowNames.UICrossThroneSuccess,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UICrossThroneSuccess.Controller.UICrossThroneSuccessCtrl"),
  View = require("UI.UICrossThroneSuccess.View.UICrossThroneSuccessView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UIThrone/UICrossThroneSuccess.prefab"
}
return {UICrossThroneSuccess = UICrossThroneSuccess}
