local UIHSRRank = {
  Name = UIWindowNames.UIHSRRank,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIHSRRank.UIHSRRankCtrl"),
  View = require("UI.UIHSRRank.UIHSRRankView"),
  PrefabPath = "Assets/Main/SeasonRes/S5/Prefabs/UI/HSR/UIHSRRank.prefab",
  HideBack = true
}
return {UIHSRRank = UIHSRRank}
