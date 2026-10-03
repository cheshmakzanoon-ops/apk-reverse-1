local UIBuyOneGetOneFree = {
  Name = UIWindowNames.UIBuyOneGetOneFree,
  Layer = UILayer.Info,
  Ctrl = require("UI.UIBuyOneGetOneFree.Controller.UIBuyOneGetOneFreeCtrl"),
  View = require("UI.UIBuyOneGetOneFree.View.UIBuyOneGetOneFreeView"),
  PrefabPath = "Assets/Main/SeasonRes/S3/Prefabs/UI/UIBuyOneGetOneFree/UIBuyOneGetOneFree.prefab"
}
return {UIBuyOneGetOneFree = UIBuyOneGetOneFree}
