local UIChangeGender = {
  Name = UIWindowNames.UIChangeGender,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIChangeGender.Controller.UIChangeGenderCtrl"),
  View = require("UI.UIChangeGender.View.UIChangeGenderView"),
  PrefabPath = "Assets/Main/Prefabs/UI/Set/New/UIChangeGender.prefab"
}
return {UIChangeGender = UIChangeGender}
