local UIJigsawRank = {
  Name = UIWindowNames.UIJigsawRank,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIJigsawRank.Controller.UIJigsawRankCtrl"),
  View = require("UI.UIJigsawRank.View.UIJigsawRankView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UIJigsawRank/UIJigsawRank.prefab"
}
return {UIJigsawRank = UIJigsawRank}
