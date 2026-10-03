local UIGarbageRewardShow = {
  Name = UIWindowNames.UIGarbageRewardShow,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIGarbageRewardShow.Controller.UIGarbageRewardShowCtrl"),
  View = require("UI.UIGarbageRewardShow.View.UIGarbageRewardShowView"),
  PrefabPath = "Assets/Main/Prefabs/CityScene/UIGarbageRewardShow.prefab"
}
return {UIGarbageRewardShow = UIGarbageRewardShow}
