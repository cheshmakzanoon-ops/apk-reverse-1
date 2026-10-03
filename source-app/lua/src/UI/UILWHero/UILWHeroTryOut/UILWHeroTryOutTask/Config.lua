local UILWHeroTryOutTask = {
  Name = UIWindowNames.UILWHeroTryOutTask,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UILWHero.UILWHeroTryOut.UILWHeroTryOutTask.Ctrl.UILWHeroTryOutTaskCtrl"),
  View = require("UI.UILWHero.UILWHeroTryOut.UILWHeroTryOutTask.View.UILWHeroTryOutTaskView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UIHero/UILWHeroTryOut/UILWHeroTryOutTask.prefab",
  HideInBattle = true
}
return {UILWHeroTryOutTask = UILWHeroTryOutTask}
