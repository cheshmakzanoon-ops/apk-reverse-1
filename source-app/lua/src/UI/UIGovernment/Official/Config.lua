local UIGovernmentOfficial = {
  Name = UIWindowNames.UIGovernmentOfficial,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIGovernment.Official.Controller.OfficialCtrl"),
  View = require("UI.UIGovernment.Official.View.OfficialView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UIGovernment/Official.prefab",
  HideBack = true
}
return {UIGovernmentOfficial = UIGovernmentOfficial}
