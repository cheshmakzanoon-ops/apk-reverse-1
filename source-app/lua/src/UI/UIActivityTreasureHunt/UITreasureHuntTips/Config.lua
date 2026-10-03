local UITreasureHuntTips = {
  Name = UIWindowNames.UITreasureHuntTips,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIActivityTreasureHunt.UITreasureHuntTips.Controller.UITreasureHuntTipsCtrl"),
  View = require("UI.UIActivityTreasureHunt.UITreasureHuntTips.View.UITreasureHuntTipsView"),
  PrefabPath = "Assets/Main/Prefabs/UI/ActivityCenter/TreasureHunt/UITreasureHuntTip.prefab"
}
return {UITreasureHuntTips = UITreasureHuntTips}
