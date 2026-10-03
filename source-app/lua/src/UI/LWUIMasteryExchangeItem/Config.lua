local LWUIMasteryExchangeItem = {
  Name = UIWindowNames.LWUIMasteryExchangeItem,
  Layer = UILayer.Normal,
  Ctrl = require("UI.LWUIMasteryExchangeItem.Controller.LWUIMasteryExchangeItemCtrl"),
  View = require("UI.LWUIMasteryExchangeItem.View.LWUIMasteryExchangeItemView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UIMastery/LWUIMasteryExchangeItem.prefab"
}
return {LWUIMasteryExchangeItem = LWUIMasteryExchangeItem}
