local UIDeclareCondition = {
  Name = UIWindowNames.UIDeclareCondition,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIDeclareCondition.Controller.UIDeclareConditionCtrl"),
  View = require("UI.UIDeclareCondition.View.UIDeclareConditionView"),
  PrefabPath = "Assets/Main/Prefabs/UI/World/UIDeclareCondition.prefab"
}
return {UIDeclareCondition = UIDeclareCondition}
