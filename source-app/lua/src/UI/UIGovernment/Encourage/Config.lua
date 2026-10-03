local UIGovernmentEncourage = {
  Name = UIWindowNames.UIGovernmentEncourage,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIGovernment.Encourage.Controller.EncourageCtrl"),
  View = require("UI.UIGovernment.Encourage.View.EncourageView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UIGovernment/Encourage.prefab",
  HideBack = true
}
return {UIGovernmentEncourage = UIGovernmentEncourage}
