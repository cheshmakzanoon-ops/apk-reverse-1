local SeasonMilitaryShopNewPopup = {
  Name = UIWindowNames.SeasonMilitaryShopNewPopup,
  Layer = UILayer.Normal,
  Ctrl = require("UI.LWSeason6.UILWSeasonMilitaryShop.NewPopup.Ctrl.SeasonMilitaryShopNewPopupCtrl"),
  View = require("UI.LWSeason6.UILWSeasonMilitaryShop.NewPopup.View.SeasonMilitaryShopNewPopupView"),
  PrefabPath = "Assets/Main/SeasonRes/S6/Prefabs/UI/MilitaryShop/SeasonMilitaryShopNewPopup.prefab"
}
return {SeasonMilitaryShopNewPopup = SeasonMilitaryShopNewPopup}
