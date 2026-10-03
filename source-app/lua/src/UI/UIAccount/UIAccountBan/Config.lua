local UIAccountBan = {
  Name = UIWindowNames.UIAccountBan,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIAccount.UIAccountBan.Controller.UIAccountBanCtrl"),
  View = require("UI.UIAccount.UIAccountBan.View.UIAccountBanView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UIAccount/UIAccountBan.prefab",
  CustomKeyCodeEscape = true
}
return {UIAccountBan = UIAccountBan}
