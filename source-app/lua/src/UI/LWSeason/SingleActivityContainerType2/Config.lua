local SingleActivityContainerType2 = {
  Name = UIWindowNames.SingleActivityContainerType2,
  Layer = UILayer.Normal,
  Ctrl = require("UI.LWSeason.SingleActivityContainerType2.Controller.SingleActivityContainerType2Ctrl"),
  View = require("UI.LWSeason.SingleActivityContainerType2.View.SingleActivityContainerType2View"),
  PrefabPath = "Assets/Main/Prefabs/UI/ActivityCenter/ActTrends/SingleActivityContainerType2.prefab",
  CustomKeyCodeEscape = true,
  HideBack = true
}
return {SingleActivityContainerType2 = SingleActivityContainerType2}
