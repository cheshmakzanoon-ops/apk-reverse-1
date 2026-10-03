local LWUIActRecycleExchangeConfirm = {
  Name = UIWindowNames.LWUIActRecycleExchangeConfirm,
  Layer = UILayer.Normal,
  Ctrl = require("UI.LWUIActRecycle.ExchangeConfirm.Ctrl.LWUIActRecycleExchangeConfirmCtrl"),
  View = require("UI.LWUIActRecycle.ExchangeConfirm.View.LWUIActRecycleExchangeConfirmView"),
  PrefabPath = "Assets/Main/Prefabs/UI/Activity/LWUIActRecycle/Base/LWUIActRecycleExchangeConfirm.prefab"
}
return {LWUIActRecycleExchangeConfirm = LWUIActRecycleExchangeConfirm}
