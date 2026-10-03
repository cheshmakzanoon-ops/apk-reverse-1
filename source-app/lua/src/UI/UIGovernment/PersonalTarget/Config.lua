local UIGovernmentPersonalTarget = {
  Name = UIWindowNames.UIGovernmentPersonalTarget,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIGovernment.PersonalTarget.Controller.PersonalTargetCtrl"),
  View = require("UI.UIGovernment.PersonalTarget.View.PersonalTargetView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UIGovernment/PersonalTarget.prefab"
}
return {UIGovernmentPersonalTarget = UIGovernmentPersonalTarget}
