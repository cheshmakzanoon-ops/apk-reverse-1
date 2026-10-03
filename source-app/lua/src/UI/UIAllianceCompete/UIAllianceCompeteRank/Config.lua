local UIAllianceCompeteRank = {
  Name = UIWindowNames.UIAllianceCompeteRank,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIAllianceCompete.UIAllianceCompeteRank.Controller.UIAllianceCompeteRankCtrl"),
  View = require("UI.UIAllianceCompete.UIAllianceCompeteRank.View.UIAllianceCompeteRankView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UIAllianceCompeteNew/UIAllianceCompeteRank.prefab"
}
return {UIAllianceCompeteRank = UIAllianceCompeteRank}
