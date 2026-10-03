local UIChatKickUser = {
  Name = UIWindowNames.UIChatKickUser,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIChatNew.UIChatKickUser.Controller.UIChatKickUserCtrl"),
  View = require("UI.UIChatNew.UIChatKickUser.View.UIChatKickUserView"),
  PrefabPath = "Assets/Main/Prefabs/UI/ChatNew/ChatKickUser/UIChatKickUser.prefab"
}
return {UIChatKickUser = UIChatKickUser}
