local UIFishBuff = {
  Name = UIWindowNames.UIFishBuff,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIFishing.UIFishBuff.UIFishBuffCtrl"),
  View = require("UI.UIFishing.UIFishBuff.UIFishBuffView"),
  PrefabPath = "Assets/Main/SeasonRes/S6/Prefabs/UI/Fishing/UIFishBuff.prefab"
}
return {UIFishBuff = UIFishBuff}
