local UIGovernmentServerBattleRewardDetail = {
  Name = UIWindowNames.UIGovernmentServerBattleRewardDetail,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIGovernment.ServerBattleRewardDetail.Controller.ServerBattleRewardDetailCtrl"),
  View = require("UI.UIGovernment.ServerBattleRewardDetail.View.ServerBattleRewardDetailView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UIGovernment/ServerBattleRewardDetail.prefab"
}
return {UIGovernmentServerBattleRewardDetail = UIGovernmentServerBattleRewardDetail}
