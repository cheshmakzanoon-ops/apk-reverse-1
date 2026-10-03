local UIHeroBountyTask = {
  Name = UIWindowNames.UIHeroBountyTask,
  Layer = UILayer.Background,
  Ctrl = require("UI.UIHeroBountyTask.Controller.UIHeroBountyTaskCtrl"),
  View = require("UI.UIHeroBountyTask.View.UIHeroBountyTaskView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UIHero/New/UIHeroOfferReward.prefab"
}
return {UIHeroBountyTask = UIHeroBountyTask}
