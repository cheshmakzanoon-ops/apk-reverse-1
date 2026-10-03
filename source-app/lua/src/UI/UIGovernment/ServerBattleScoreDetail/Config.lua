local ServerBattleScoreDetail = {
  Name = UIWindowNames.UIGovernmentServerBattleScoreDetail,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIGovernment.ServerBattleScoreDetail.Controller.ServerBattleScoreDetailCtrl"),
  View = require("UI.UIGovernment.ServerBattleScoreDetail.View.ServerBattleScoreDetailView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UIGovernment/ServerBattleScoreDetail.prefab"
}
return {UIGovernmentServerBattleScoreDetail = ServerBattleScoreDetail}
