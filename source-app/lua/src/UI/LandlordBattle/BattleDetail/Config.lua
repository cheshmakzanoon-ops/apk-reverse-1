local UILLBattleDetail = {
  Name = UIWindowNames.UILLBattleDetail,
  Layer = UILayer.Normal,
  Ctrl = require("UI.LandlordBattle.BattleDetail.Ctrl.UILLBattleDetailCtrl"),
  View = require("UI.LandlordBattle.BattleDetail.View.UILLBattleDetailView"),
  PrefabPath = "Assets/Main/Prefabs/UI/Landlord/World/LLWorldBattleDetailView.prefab"
}
return {UILLBattleDetail = UILLBattleDetail}
