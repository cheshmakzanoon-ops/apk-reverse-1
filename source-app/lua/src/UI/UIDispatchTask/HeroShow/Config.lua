local UIDispatchTaskHeroShow = {
  Name = UIWindowNames.UIDispatchTaskHeroShow,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIDispatchTask.HeroShow.Controller.UIDispatchTaskHeroShowCtrl"),
  View = require("UI.UIDispatchTask.HeroShow.View.UIDispatchTaskHeroShowView"),
  PrefabPath = "Assets/Main/Prefabs/UI/DispatchTask/UIDispatchTaskHeroShow.prefab"
}
return {UIDispatchTaskHeroShow = UIDispatchTaskHeroShow}
