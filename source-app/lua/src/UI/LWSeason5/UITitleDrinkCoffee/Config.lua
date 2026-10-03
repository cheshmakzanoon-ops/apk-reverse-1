local UITitleDrinkCoffeeView = {
  Name = UIWindowNames.UITitleDrinkCoffeeView,
  Layer = UILayer.Normal,
  Ctrl = require("UI.LWSeason5.UITitleDrinkCoffee.Controller.UITitleDrinkCoffeeCtrl"),
  View = require("UI.LWSeason5.UITitleDrinkCoffee.View.UITitleDrinkCoffeeView"),
  PrefabPath = "Assets/Main/SeasonRes/S5/Prefabs/UI/MakingCoffee/UITitleDrinkCoffee.prefab"
}
return {UITitleDrinkCoffeeView = UITitleDrinkCoffeeView}
