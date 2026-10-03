local TCCardSalvage = {
  Name = UIWindowNames.TCCardSalvage,
  Layer = UILayer.Normal,
  Ctrl = require("UI.LWUITCSalvage.Ctrl.UITCCardSalvageCtrl"),
  View = require("UI.LWUITCSalvage.View.UITCCardSalvageView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UILWTCSalvage/UITCCardSalvage.prefab"
}
return {TCCardSalvage = TCCardSalvage}
