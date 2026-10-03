local UILWGetGiftView = {
  Name = UIWindowNames.UILWGetGiftView,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UILWGetGiftView.Controller.UILWGetGiftCtrl"),
  View = require("UI.UILWGetGiftView.View.UILWGetGiftView"),
  PrefabPath = "Assets/Main/Prefabs/UI/ActivityCenter/BargainShop/UILWGetGiftView.prefab"
}
return {UILWGetGiftView = UILWGetGiftView}
