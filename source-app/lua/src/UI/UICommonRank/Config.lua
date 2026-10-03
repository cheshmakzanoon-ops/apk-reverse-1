local UICommonRank = {
  Name = UIWindowNames.UICommonRank,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UICommonRank.UICommonRankCtrl"),
  View = require("UI.UICommonRank.UICommonRankView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UICommonRank/UICommonRank.prefab",
  HideBack = true
}
return {UICommonRank = UICommonRank}
