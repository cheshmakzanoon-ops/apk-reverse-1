local UICommonCountdown = {
  Name = UIWindowNames.UICommonCountdown,
  Layer = UILayer.UIResource,
  Ctrl = require("UI.UICommonCountdown.Controller.UICommonCountdownCtrl"),
  View = require("UI.UICommonCountdown.View.UICommonCountdownView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UICommonCountdown/UICommonCountdown.prefab"
}
return {UICommonCountdown = UICommonCountdown}
