local UIExpiredMonthlyCardRecover = {
  Name = UIWindowNames.UIExpiredMonthlyCardRecover,
  Layer = UILayer.Normal,
  Ctrl = require("UI.LWGift.UIExpiredMonthlyCardRecover.Ctrl.UIExpiredMonthlyCardRecoverCtrl"),
  View = require("UI.LWGift.UIExpiredMonthlyCardRecover.View.UIExpiredMonthlyCardRecoverView"),
  PrefabPath = "Assets/Main/Prefabs/UI/LWGift/UIExpiredMonthlyCard/UIExpiredMonthlyCardRecover.prefab"
}
return {UIExpiredMonthlyCardRecover = UIExpiredMonthlyCardRecover}
