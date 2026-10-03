local UIBuildingPersonalFurnace = {
  Name = UIWindowNames.UIBuildingPersonalFurnace,
  Layer = UILayer.Background,
  Ctrl = require("UI.UIBuilding.UIBuildingPersonalFurnace.Controller.UIBuildingPersonalFurnaceCtrl"),
  View = require("UI.UIBuilding.UIBuildingPersonalFurnace.View.UIBuildingPersonalFurnaceView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UIBuilding/UIBuildingPersonalFurnace.prefab"
}
return {UIBuildingPersonalFurnace = UIBuildingPersonalFurnace}
