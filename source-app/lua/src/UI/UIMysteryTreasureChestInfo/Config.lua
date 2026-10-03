local UIMysteryTreasureChest = {
  Name = UIWindowNames.UIMysteryTreasureChest,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIMysteryTreasureChestInfo.Controller.UIMysteryTreasureChestInfoCtrl"),
  View = require("UI.UIMysteryTreasureChestInfo.View.UIMysteryTreasureChestInfoView"),
  PrefabPath = "Assets/Main/Prefabs/UI/Monopoly/UIMysteryTreasureChestInfo.prefab"
}
return {UIMysteryTreasureChest = UIMysteryTreasureChest}
