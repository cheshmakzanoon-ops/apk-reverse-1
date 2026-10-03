local LWUIHeroSuggestTips = {
  Name = UIWindowNames.LWUIHeroSuggestTips,
  Layer = UILayer.Guide,
  Ctrl = require("UI.LWUIHeroSuggestTips.Ctrl.LWUIHeroSuggestTipsCtrl"),
  View = require("UI.LWUIHeroSuggestTips.View.LWUIHeroSuggestTipsView"),
  PrefabPath = "Assets/Main/Prefabs/UI/LWUIHeroSuggestTips/LWUIHeroSuggestTips.prefab"
}
return {LWUIHeroSuggestTips = LWUIHeroSuggestTips}
