local UIVipRenew = {
  Name = UIWindowNames.UIVIPRewnew,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIVip.UIVipRenew.Controller.UIVipRenewCtrl"),
  View = require("UI.UIVip.UIVipRenew.View.UIVipRenewView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UILWVIPPanel/UIVipRenew.prefab"
}
return {WorldDesUI = UIVipRenew}
