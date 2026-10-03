local UIArrowFinger_New = {
  Name = UIWindowNames.UIArrowFinger_New,
  Layer = UILayer.Guide,
  Ctrl = require("UI.LWNewGuide.Ctrl.UIArrowFinger_NewCtrl"),
  View = require("UI.LWNewGuide.View.UIArrowFinger_NewView"),
  PrefabPath = "Assets/Main/Prefabs/UI/LWGuideHeroNew/UIArrowFinger_New.prefab"
}
return {UIArrowFinger_New = UIArrowFinger_New}
