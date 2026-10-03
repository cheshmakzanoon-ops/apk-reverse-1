local UITreasureChest = {
  Name = UIWindowNames.UITreasureChest,
  Layer = UILayer.Normal,
  Ctrl = require("UI.LWTreasureChest.UITreasureChestCtrl"),
  View = require("UI.LWTreasureChest.UITreasureChestView"),
  PrefabPath = "Assets/Main/Prefabs/UI/LWTreasureChest/UITreasureChest.prefab"
}
return {UITreasureChest = UITreasureChest}
