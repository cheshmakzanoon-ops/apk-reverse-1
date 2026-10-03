local LWMakingCoffeeTipsView = {
  Name = UIWindowNames.LWMakingCoffeeTipsView,
  Layer = UILayer.Normal,
  Ctrl = require("UI.LWSeason5.LWMakingCoffeeTips.Ctrl.LWMakingCoffeeTipsCtrl"),
  View = require("UI.LWSeason5.LWMakingCoffeeTips.View.LWMakingCoffeeTipsView"),
  PrefabPath = "Assets/Main/SeasonRes/S5/Prefabs/UI/MakingCoffee/LWMakingCoffeeTipsView.prefab"
}
return {LWMakingCoffeeTipsView = LWMakingCoffeeTipsView}
