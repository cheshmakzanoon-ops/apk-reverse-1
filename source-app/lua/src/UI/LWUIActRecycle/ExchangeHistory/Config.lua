local LWUIActRecycleExchangeHistory = {
  Name = UIWindowNames.LWUIActRecycleExchangeHistory,
  Layer = UILayer.Normal,
  Ctrl = require("UI.LWUIActRecycle.ExchangeHistory.Ctrl.LWUIActRecycleExchangeHistoryCtrl"),
  View = require("UI.LWUIActRecycle.ExchangeHistory.View.LWUIActRecycleExchangeHistoryView"),
  PrefabPath = "Assets/Main/Prefabs/UI/Activity/LWUIActRecycle/Base/LWUIActRecycleExchangeHistory.prefab"
}
return {LWUIActRecycleExchangeHistory = LWUIActRecycleExchangeHistory}
