local UIChapterSwitch = {
  Name = UIWindowNames.UIChapterSwitch,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIChapterSwitch.Controller.UIChapterSwitchCtrl"),
  View = require("UI.UIChapterSwitch.View.UIChapterSwitchView"),
  PrefabPath = "Assets/Main/Prefabs/UI/ChatNew/UIChapterTransfer.prefab"
}
return {UIChapterSwitch = UIChapterSwitch}
