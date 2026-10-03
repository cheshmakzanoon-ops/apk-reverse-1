local UIBuildingDigTreasure = {
  Name = UIWindowNames.UIBuildingDigTreasure,
  Layer = UILayer.Normal,
  Ctrl = require("UI.DigMap.Building.Ctrl.UIBuildingDigTreasureCtrl"),
  View = require("UI.DigMap.Building.View.UIBuildingDigTreasureView"),
  PrefabPath = "Assets/Main/Prefabs/UI/DigTreasureCommon/Building/UIBuildingDigTreasure.prefab"
}
return {UIBuildingDigTreasure = UIBuildingDigTreasure}
