local BountyHunterExchange = {
  Name = UIWindowNames.BountyHunterExchange,
  Layer = UILayer.Normal,
  Ctrl = require("UI.LWUIActBountyHunter.LWUIActBountyHunterExchange.Ctrl.UIActBountyHunterExchangeCtrl"),
  View = require("UI.LWUIActBountyHunter.LWUIActBountyHunterExchange.View.UIActBountyHunterExchangeView"),
  PrefabPath = "Assets/Main/Prefabs/UI/ActivityCenter/BountyHunter/UIActBountyHunterExchange.prefab"
}
return {BountyHunterExchange = BountyHunterExchange}
