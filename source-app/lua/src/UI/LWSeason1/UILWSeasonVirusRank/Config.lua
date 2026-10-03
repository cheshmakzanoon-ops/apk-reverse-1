local UILWSeasonVirusRank = {
  Name = UIWindowNames.UILWSeasonVirusRank,
  Layer = UILayer.Normal,
  Ctrl = require("UI.LWSeason1.UILWSeasonVirusRank.Controller.UILWSeasonVirusRankCtrl"),
  View = require("UI.LWSeason1.UILWSeasonVirusRank.View.UILWSeasonVirusRankView"),
  PrefabPath = "Assets/Main/Prefabs/UI/LWSeason1/VirusRank.prefab"
}
return {UILWSeasonVirusRank = UILWSeasonVirusRank}
