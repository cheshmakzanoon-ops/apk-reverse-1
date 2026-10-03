local UIChatNew = {
  Name = UIWindowNames.UIChatNew,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIChatNew.Controller.UIChatCtrl"),
  View = require("UI.UIChatNew.View.UIChatView"),
  PrefabPath = "Assets/Main/Prefabs/UI/ChatNew/LWUIChat.prefab"
}
return {UIChatNew = UIChatNew}
