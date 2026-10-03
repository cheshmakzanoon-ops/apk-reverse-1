local UIAllianceChangeName = {
  Name = UIWindowNames.UIAllianceChangeName,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIAlliance.UIAllianceChangeName.Controller.UIAllianceChangeNameCtrl"),
  View = require("UI.UIAlliance.UIAllianceChangeName.View.UIAllianceChangeNameView"),
  PrefabPath = "Assets/Main/Prefabs/UI/Alliance/UILWChangeAllianceName.prefab"
}
return {UIAllianceChangeName = UIAllianceChangeName}
