local UIFormationTableNew = {
  Name = UIWindowNames.UIFormationTableNew,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIFormation.UIFormationTableNew.Controller.UIFormationTableNewCtrl"),
  View = require("UI.UIFormation.UIFormationTableNew.View.UIFormationTableNewView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UIFormation/UIFormationTableNew.prefab"
}
return {UIFormationTableNew = UIFormationTableNew}
