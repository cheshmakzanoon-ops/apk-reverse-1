local UIAlR4RecommendPopup = {
  Name = UIWindowNames.UIAlR4RecommendPopup,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIAlliance.UIAlR4RecommendPopup.Controller.UIAlR4RecommendPopupCtrl"),
  View = require("UI.UIAlliance.UIAlR4RecommendPopup.View.UIAlR4RecommendPopupView"),
  PrefabPath = "Assets/Main/Prefabs/UI/Alliance/UIAlR4RecommendPopup.prefab"
}
return {UIAlR4RecommendPopup = UIAlR4RecommendPopup}
