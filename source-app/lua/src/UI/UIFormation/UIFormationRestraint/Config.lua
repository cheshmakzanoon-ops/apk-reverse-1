local UIFormationRestraint = {
  Name = UIWindowNames.UIFormationRestraint,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIFormation.UIFormationRestraint.Controller.UIFormationRestraintCtrl"),
  View = require("UI.UIFormation.UIFormationRestraint.View.UIFormationRestraintView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UIFormation/UIFormationRestraint.prefab"
}
return {UIFormationRestraint = UIFormationRestraint}
