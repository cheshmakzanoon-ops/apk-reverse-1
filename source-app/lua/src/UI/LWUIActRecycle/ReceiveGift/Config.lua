local LWUIActRecycleReceiveGift = {
  Name = UIWindowNames.LWUIActRecycleReceiveGift,
  Layer = UILayer.Normal,
  Ctrl = require("UI.LWUIActRecycle.ReceiveGift.Ctrl.LWUIActRecycleReceiveGiftCtrl"),
  View = require("UI.LWUIActRecycle.ReceiveGift.View.LWUIActRecycleReceiveGiftView"),
  PrefabPath = "Assets/Main/Prefabs/UI/Activity/LWUIActRecycle/Base/LWUIActRecycleReceiveGift.prefab"
}
return {LWUIActRecycleReceiveGift = LWUIActRecycleReceiveGift}
