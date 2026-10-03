local UIAllianceChangeRestriction = {
  Name = UIWindowNames.UIAllianceChangeRestriction,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIAlliance.UIAllianceChangeRestriction.Controller.UIAllianceChangeRestrictionCtrl"),
  View = require("UI.UIAlliance.UIAllianceChangeRestriction.View.UIAllianceChangeRestrictionView"),
  PrefabPath = "Assets/Main/Prefabs/UI/Alliance/UIAllianceChangeRestriction.prefab"
}
return {UIAllianceChangeRestriction = UIAllianceChangeRestriction}
