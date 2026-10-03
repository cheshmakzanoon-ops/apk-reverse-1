local LWRefundPunish = {
  Name = UIWindowNames.LWRefundPunish,
  Layer = UILayer.Normal,
  Ctrl = require("UI.LWUIRefundPunish.Ctrl.LWRefundPunishCtrl"),
  View = require("UI.LWUIRefundPunish.View.LWRefundPunishView"),
  PrefabPath = "Assets/Main/Prefabs/UI/LWRefundPunish/LWRefundPunish.prefab"
}
return {LWRefundPunish = LWRefundPunish}
