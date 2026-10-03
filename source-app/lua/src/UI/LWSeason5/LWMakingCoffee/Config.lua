local LWMakingCoffeeView = {
  Name = UIWindowNames.LWMakingCoffeeView,
  Layer = UILayer.Normal,
  Ctrl = require("UI.LWSeason5.LWMakingCoffee.Controller.LWMakingCoffeeCtrl"),
  View = require("UI.LWSeason5.LWMakingCoffee.View.LWMakingCoffeeView"),
  PrefabPath = "Assets/Main/SeasonRes/S5/Prefabs/UI/MakingCoffee/LWMakingCoffeeView.prefab"
}
return {LWMakingCoffeeView = LWMakingCoffeeView}
