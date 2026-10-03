local LWUIActRecycleExchange = {
  Name = UIWindowNames.LWUIActRecycleExchange,
  Layer = UILayer.Normal,
  Ctrl = require("UI.LWUIActRecycle.Exchange.Ctrl.LWUIActRecycleExchangeCtrl"),
  View = require("UI.LWUIActRecycle.Exchange.View.LWUIActRecycleExchangeView"),
  PrefabPath = "Assets/Main/Prefabs/UI/Activity/LWUIActRecycle/Base/LWUIActRecycleExchange.prefab"
}
return {LWUIActRecycleExchange = LWUIActRecycleExchange}
