local UIChatNew_v2 = {
  Name = UIWindowNames.UIChatNew_v2,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIChatNewV2.Controller.UIChatCtrl_v2"),
  View = require("UI.UIChatNewV2.View.UIChatView_v2"),
  PrefabPath = "Assets/Main/Prefabs/UI/ChatNew/LWUIChat_v2_new.prefab",
  HideBack = true,
  CustomKeyCodeEscape = true
}
return {UIChatNew_v2 = UIChatNew_v2}
