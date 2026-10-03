local UIPveTriggerItemBuy = {
  Name = UIWindowNames.UIPveTriggerItemBuy,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIPVE.UIPveTriggerItemBuy.Controller.UIPveTriggerItemBuyCtrl"),
  View = require("UI.UIPVE.UIPveTriggerItemBuy.View.UIPveTriggerItemBuyView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UIPVE/UIPveTriggerItemBuy.prefab"
}
return {UIPveTriggerItemBuy = UIPveTriggerItemBuy}
