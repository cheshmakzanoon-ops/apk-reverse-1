local LWUIActRecycleDrawInfo = {
  Name = UIWindowNames.LWUIActRecycleDrawInfo,
  Layer = UILayer.Normal,
  Ctrl = require("UI.LWUIActRecycle.DrawInfo.Ctrl.LWUIActRecycleDrawInfoCtrl"),
  View = require("UI.LWUIActRecycle.DrawInfo.View.LWUIActRecycleDrawInfoView"),
  PrefabPath = "Assets/Main/Prefabs/UI/Activity/LWUIActRecycle/Base/LWUIActRecycleDrawInfo.prefab"
}
return {LWUIActRecycleDrawInfo = LWUIActRecycleDrawInfo}
