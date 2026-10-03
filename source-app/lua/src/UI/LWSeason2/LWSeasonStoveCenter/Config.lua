local UILWSeasonStoveCenter = {
  Name = UIWindowNames.UILWSeasonStoveCenter,
  Layer = UILayer.Normal,
  Ctrl = require("UI.LWSeason2.LWSeasonStoveCenter.Controller.UILWSeasonStoveCenterCtrl"),
  View = require("UI.LWSeason2.LWSeasonStoveCenter.View.UILWSeasonStoveCenterView"),
  PrefabPath = "Assets/Main/Prefabs/UI/LWSeason2/SeasonStoveCenter.prefab",
  HideBack = true
}
return {UILWSeasonStoveCenter = UILWSeasonStoveCenter}
