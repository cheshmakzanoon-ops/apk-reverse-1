local LWUIActRecycleTip = {
  Name = UIWindowNames.LWUIActRecycleTip,
  Layer = UILayer.Info,
  Ctrl = require("UI/LWUIActRecycle/Tip/Controller/LWUIActRecycleTipCtrl"),
  View = require("UI/LWUIActRecycle/Tip/View/LWUIActRecycleTipView"),
  PrefabPath = "Assets/Main/Prefabs/UI/Activity/LWUIActRecycle/Base/LWUIActRecycleTips.prefab"
}
return {LWUIActRecycleTip = LWUIActRecycleTip}
