local UILWKOFDefenseTeamOrder = {
  Name = UIWindowNames.UILWKOFDefenseTeamOrder,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UILWKOFDefenseTeamOrder.Controller.UILWKOFDefenseTeamOrderCtrl"),
  View = require("UI.UILWKOFDefenseTeamOrder.View.UILWKOFDefenseTeamOrderView"),
  PrefabPath = "Assets/Main/Prefabs/UI/LWKOFCampaign/LWKOFDefenseTeamOrder.prefab"
}
return {UILWKOFDefenseTeamOrder = UILWKOFDefenseTeamOrder}
