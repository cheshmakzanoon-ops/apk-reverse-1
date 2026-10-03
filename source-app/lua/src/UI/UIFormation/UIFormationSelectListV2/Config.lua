local UIFormationSelectListV2 = {
  Name = UIWindowNames.UIFormationSelectListV2,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIFormation.UIFormationSelectListV2.Controller.UIFormationSelectListV2Ctrl"),
  View = require("UI.UIFormation.UIFormationSelectListV2.View.UIFormationSelectListV2View"),
  PrefabPath = "Assets/Main/Prefabs/UI/UIFormation/V2/UIFormationSelectListV2.prefab"
}
return {UIFormationSelectListV2 = UIFormationSelectListV2}
