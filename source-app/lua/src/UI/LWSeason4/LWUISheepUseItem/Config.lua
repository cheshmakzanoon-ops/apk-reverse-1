local LWUISheepUseItem = {
  Name = UIWindowNames.LWUISheepUseItem,
  Layer = UILayer.Normal,
  Ctrl = require("UI.LWSeason4.LWUISheepUseItem.Controller.LWUISheepUseItemCtrl"),
  View = require("UI.LWSeason4.LWUISheepUseItem.View.LWUISheepUseItemView"),
  PrefabPath = "Assets/Main/SeasonRes/S4/Prefabs/UI/LWSheep/LWUISheepUseItem.prefab",
  CustomKeyCodeEscape = true
}
return {LWUISheepUseItem = LWUISheepUseItem}
