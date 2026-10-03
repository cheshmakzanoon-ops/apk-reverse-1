local UILLRank = {
  Name = UIWindowNames.UILLRank,
  Layer = UILayer.Normal,
  Ctrl = require("UI.Landlord.Rank.Ctrl.UILLRankCtrl"),
  View = require("UI.Landlord.Rank.View.UILLRankView"),
  PrefabPath = "Assets/Main/Prefabs/UI/Landlord/LLRankPanel.prefab"
}
return {UILLRank = UILLRank}
