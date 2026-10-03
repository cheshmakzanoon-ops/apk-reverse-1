local UITreasureHuntNewTips = {
  Name = UIWindowNames.UITreasureHuntNewTips,
  Layer = UILayer.Normal,
  Ctrl = require("UI/UIActivityTreasureHuntNew/UITreasureHuntNewTips/Controller/UITreasureHuntNewTipsCtrl"),
  View = require("UI/UIActivityTreasureHuntNew/UITreasureHuntNewTips/View/UITreasureHuntNewTipsView"),
  PrefabPath = "Assets/Main/Prefabs/UI/ActivityCenter/TreasureHuntNew/UITreasureHuntNewTip.prefab"
}
return {UITreasureHuntNewTips = UITreasureHuntNewTips}
