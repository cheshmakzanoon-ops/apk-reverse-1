local UIAlMemberRecommend = {
  Name = UIWindowNames.UIAlMemberRecommend,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIAlliance.UIAlMemberRecommend.Controller.UIAlMemberRecommendCtrl"),
  View = require("UI.UIAlliance.UIAlMemberRecommend.View.UIAlMemberRecommendView"),
  PrefabPath = "Assets/Main/Prefabs/UI/Alliance/UIAlMemberRecommend.prefab"
}
return {UIAlMemberRecommend = UIAlMemberRecommend}
