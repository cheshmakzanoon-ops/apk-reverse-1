local UILookForCareer = {
  Name = UIWindowNames.UILookForCareer,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UILookForCareer.Controller.UILookForCareerCtrl"),
  View = require("UI.UILookForCareer.View.UILookForCareerView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UILookForCareer/UILookForCareer.prefab"
}
return {UILookForCareer = UILookForCareer}
