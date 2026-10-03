local UILWChangeEnterAllianceCondition = {
  Name = UIWindowNames.UILWChangeEnterAllianceCondition,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIAlliance.LWUIChangeEnterAllianceCondition.Controller.LWUIChangeEnterAllianceConditionCtrl"),
  View = require("UI.UIAlliance.LWUIChangeEnterAllianceCondition.View.LWUIChangeEnterAllianceConditionView"),
  PrefabPath = "Assets/Main/Prefabs/UI/Alliance/UILWChangeEnterAllianceCondition.prefab"
}
return {UILWChangeEnterAllianceCondition = UILWChangeEnterAllianceCondition}
