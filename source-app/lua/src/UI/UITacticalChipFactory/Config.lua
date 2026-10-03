local UITacticalChipFactory = {
  Name = UIWindowNames.UITacticalChipFactory,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UITacticalChipFactory.Controller.UITacticalChipFactoryCtrl"),
  View = require("UI.UITacticalChipFactory.View.UITacticalChipFactoryView"),
  PrefabPath = "Assets/Main/Prefabs/UI/LWUITacticalWeapon/ChipFactory/UITacticalChipFactory.prefab",
  HideBack = true
}
return {UITacticalChipFactory = UITacticalChipFactory}
