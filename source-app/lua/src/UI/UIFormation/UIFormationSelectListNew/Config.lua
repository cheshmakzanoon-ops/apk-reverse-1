local UIFormationSelectListNew = {
  Name = UIWindowNames.UIFormationSelectListNew,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIFormation.UIFormationSelectListNew.Controller.UIFormationSelectListNewCtrl"),
  View = require("UI.UIFormation.UIFormationSelectListNew.View.UIFormationSelectListNewView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UIFormation/UIFormationSelectListnew.prefab"
}
return {UIFormationSelectListNew = UIFormationSelectListNew}
