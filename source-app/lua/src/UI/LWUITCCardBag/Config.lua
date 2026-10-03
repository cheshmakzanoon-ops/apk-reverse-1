local TCCardBag = {
  Name = UIWindowNames.TCCardBag,
  Layer = UILayer.Normal,
  Ctrl = require("UI.LWUITCCardBag.Ctrl.TCCardBagCtrl"),
  View = require("UI.LWUITCCardBag.View.TCCardBagView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UILWTCBag/TCCardBag.prefab",
  HideBack = true
}
return {TCCardBag = TCCardBag}
