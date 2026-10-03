local UIExpiredMonthlyCardTips = {
  Name = UIWindowNames.UIExpiredMonthlyCardTips,
  Layer = UILayer.Normal,
  Ctrl = require("UI.LWGift.UIExpiredMonthlyCardTips.Ctrl.UIExpiredMonthlyCardTipsCtrl"),
  View = require("UI.LWGift.UIExpiredMonthlyCardTips.View.UIExpiredMonthlyCardTipsView"),
  PrefabPath = "Assets/Main/Prefabs/UI/LWGift/UIExpiredMonthlyCard/UIExpiredMonthlyCardTips.prefab"
}
return {UIExpiredMonthlyCardTips = UIExpiredMonthlyCardTips}
