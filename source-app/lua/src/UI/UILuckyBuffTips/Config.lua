local UILuckyBuffTips = {
  Name = UIWindowNames.UILuckyBuffTips,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UILuckyBuffTips.Controller.UILuckyBuffTipsCtrl"),
  View = require("UI.UILuckyBuffTips.View.UILuckyBuffTipsView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UILuckyBuff/UILuckyBuffTips.prefab"
}
return {UILuckyBuffTips = UILuckyBuffTips}
