local UIChatCommanderTips = {
  Name = UIWindowNames.UIChatCommanderTips,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIChatCommanderTips.Controller.UIChatCommanderCtrl"),
  View = require("UI.UIChatCommanderTips.View.UIChatCommanderTips"),
  PrefabPath = "Assets/Main/Prefabs/UI/ChatNew/UIChatCommanderTips.prefab"
}
return {UIChatCommanderTips = UIChatCommanderTips}
