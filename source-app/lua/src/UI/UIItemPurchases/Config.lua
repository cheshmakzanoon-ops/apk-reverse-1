local UIItemPurchases = {
  Name = UIWindowNames.UIItemPurchases,
  Layer = UILayer.Background,
  Ctrl = require("UI.UIItemPurchases.Controller.UIItemPurchasesCtrl"),
  View = require("UI.UIItemPurchases.View.UIItemPurchasesView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UIItem/UIItemPurchases.prefab"
}
return {UIItemPurchases = UIItemPurchases}
