local UITacticalChipStarExchange = {
  Name = UIWindowNames.UITacticalChipStarExchange,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UITacticalChipStarExchange.Controller.UITacticalChipStarExchangeCtrl"),
  View = require("UI.UITacticalChipStarExchange.View.UITacticalChipStarExchangeView"),
  PrefabPath = "Assets/Main/Prefabs/UI/LWUITacticalWeapon/ChipFactory/UITacticalChipStarExchange.prefab"
}
return {UITacticalChipStarExchange = UITacticalChipStarExchange}
