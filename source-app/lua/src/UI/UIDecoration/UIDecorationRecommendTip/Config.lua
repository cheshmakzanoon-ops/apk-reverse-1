local UIDecorationRecommendTip = {
  Name = UIWindowNames.UIDecorationRecommendTip,
  Layer = UILayer.Info,
  Ctrl = require("UI/UIDecoration/UIDecorationRecommendTip/Controller/UIDecorationRecommendTipCtrl"),
  View = require("UI.UIDecoration.UIDecorationRecommendTip.View.UIDecorationRecommendTipView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UIDecorationBook/UIDecorationBookRecommendTip.prefab"
}
return {UIDecorationRecommendTip = UIDecorationRecommendTip}
