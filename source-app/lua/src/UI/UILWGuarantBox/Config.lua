local UILWGuarantBox = {
  Name = UIWindowNames.UILWGuarantBox,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UILWGuarantBox.Controller.UILWGuarantBoxCtrl"),
  View = require("UI.UILWGuarantBox.View.UILWGuarantBoxView"),
  PrefabPath = "Assets/Main/Prefabs/UI/LWUITacticalWeapon/ChipV2/UITacticalChipBoxProps.prefab"
}
return {UILWGuarantBox = UILWGuarantBox}
