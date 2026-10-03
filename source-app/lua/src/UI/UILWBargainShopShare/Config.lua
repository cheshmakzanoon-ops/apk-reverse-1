local UILWBargainShopShare = {
  Name = UIWindowNames.UILWBargainShopShare,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UILWBargainShopShare.Controller.UILWBargainShopShareCtrl"),
  View = require("UI.UILWBargainShopShare.View.UILWBargainShopShareView"),
  PrefabPath = "Assets/Main/Prefabs/UI/ActivityCenter/BargainShop/UILWBargainShopShareView.prefab"
}
return {UILWBargainShopShare = UILWBargainShopShare}
