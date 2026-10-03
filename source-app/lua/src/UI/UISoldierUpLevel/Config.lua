local UISoldierDetails = {
  Name = UIWindowNames.UISoldierUpLevel,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UISoldierUpLevel.Controller.UISoldierUpLevelCtrl"),
  View = require("UI.UISoldierUpLevel.View.UISoldierUpLevelView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UILWMilitaryCamp/UISoldierUpLevelView.prefab"
}
return {UISoldierDetails = UISoldierDetails}
