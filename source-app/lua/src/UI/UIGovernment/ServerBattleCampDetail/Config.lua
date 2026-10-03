local ServerBattleCampDetail = {
  Name = UIWindowNames.ServerBattleCampDetail,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIGovernment.ServerBattleCampDetail.Controller.ServerBattleCampDetailCtrl"),
  View = require("UI.UIGovernment.ServerBattleCampDetail.View.ServerBattleCampDetailView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UIGovernment/ServerBattleCampDetail.prefab"
}
return {ServerBattleCampDetail = ServerBattleCampDetail}
