local UIFormationSoldierChoose = {
  Name = UIWindowNames.UIFormationSoldierChoose,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIFormation.UIFormationSoldierChoose.Controller.UIFormationSoldierChooseCtrl"),
  View = require("UI.UIFormation.UIFormationSoldierChoose.View.UIFormationSoldierChooseView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UIFormation/UIFormationSoldierChoose.prefab"
}
return {UIFormationSoldierChoose = UIFormationSoldierChoose}
