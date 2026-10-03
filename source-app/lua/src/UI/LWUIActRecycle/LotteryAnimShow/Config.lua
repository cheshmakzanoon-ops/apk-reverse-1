local LWUIActRecycleLotteryAnimShow = {
  Name = UIWindowNames.LWUIActRecycleLotteryAnimShow,
  Layer = UILayer.Normal,
  Ctrl = require("UI.LWUIActRecycle.LotteryAnimShow.Ctrl.LWUIActRecycleLotteryAnimShowCtrl"),
  View = require("UI.LWUIActRecycle.LotteryAnimShow.View.LWUIActRecycleLotteryAnimShowView"),
  PrefabPath = "Assets/Main/Prefabs/UI/Activity/LWUIActRecycle/Base/LWUIActRecycleLotteryAnimShow.prefab"
}
return {LWUIActRecycleLotteryAnimShow = LWUIActRecycleLotteryAnimShow}
