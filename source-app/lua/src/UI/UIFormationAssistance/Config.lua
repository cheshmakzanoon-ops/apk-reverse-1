local UIFormationAssistance = {
  Name = UIWindowNames.UIFormationAssistance,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIFormationAssistance.Controller.UIFormationAssistanceCtrl"),
  View = require("UI.UIFormationAssistance.View.UIFormationAssistanceView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UIFormationDefence/UIFormationAssistance.prefab"
}
return {UIFormationAssistance = UIFormationAssistance}
