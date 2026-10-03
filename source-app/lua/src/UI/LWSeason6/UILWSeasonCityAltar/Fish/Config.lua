local S6CityAltarFish = {
  Name = UIWindowNames.S6CityAltarFish,
  Layer = UILayer.Normal,
  Ctrl = require("UI.LWSeason6.UILWSeasonCityAltar.Fish.Ctrl.S6CityAltarFishCtrl"),
  View = require("UI.LWSeason6.UILWSeasonCityAltar.Fish.View.S6CityAltarFishView"),
  PrefabPath = "Assets/Main/SeasonRes/S6/Prefabs/UI/CityAltar/S6CityAltarFish.prefab"
}
return {S6CityAltarFish = S6CityAltarFish}
