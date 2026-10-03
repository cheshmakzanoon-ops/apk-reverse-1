local UIFormationState = {
  Name = UIWindowNames.UIFormationState,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIFormation.UIFormationState.Controller.UIFormationStateCtrl"),
  View = require("UI.UIFormation.UIFormationState.View.UIFormationStateView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UIFormation/UIFormationStateNew.prefab"
}
return {UIFormationState = UIFormationState}
