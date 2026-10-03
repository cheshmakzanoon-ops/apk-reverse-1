local UISuppliesShow = {
  Name = UIWindowNames.SuppliesShow,
  Layer = UILayer.Normal,
  Ctrl = require("UI.LWSeason4.Activity.SeasonSupplies.SuppliesShow.SuppliesShowCtrl"),
  View = require("UI.LWSeason4.Activity.SeasonSupplies.SuppliesShow.SuppliesShowView"),
  PrefabPath = "Assets/Main/SeasonRes/S4/Prefabs/UI/SeasonActivity/SuppliesShow.prefab"
}
return {UISuppliesShow = UISuppliesShow}
