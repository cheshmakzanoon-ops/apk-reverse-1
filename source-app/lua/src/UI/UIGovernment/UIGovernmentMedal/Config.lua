local UIGovernmentMedal = {
  Name = UIWindowNames.UIGovernmentMedal,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIGovernment.UIGovernmentMedal.Controller.UIGovernmentMedalCtrl"),
  View = require("UI.UIGovernment.UIGovernmentMedal.View.UIGovernmentMedalView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UIGovernment/GovernmentMedal.prefab"
}
return {UIGovernmentMedal = UIGovernmentMedal}
