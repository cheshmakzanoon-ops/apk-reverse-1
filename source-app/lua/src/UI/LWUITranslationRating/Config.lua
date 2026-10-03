local LWUITranslationRating = {
  Name = UIWindowNames.LWUITranslationRating,
  Layer = UILayer.Normal,
  Ctrl = require("UI.LWUITranslationRating.Controller.LWUITranslationRatingCtrl"),
  View = require("UI.LWUITranslationRating.View.LWUITranslationRatingView"),
  PrefabPath = "Assets/Main/Prefabs/UI/LWTranslationRating/UILWTranslationRatingPanel.prefab"
}
return {LWUITranslationRating = LWUITranslationRating}
