local LWMainDesertUI = {
  Name = UIWindowNames.LWMainDesertUI,
  Layer = UILayer.UIResource,
  Ctrl = require("UI.BattleFieldBase.BattleFieldBaseCtrl"),
  View = require("UI.LWMainDesertUI.View.LWMainDesertUIView"),
  PrefabPath = "Assets/Main/Prefabs/UI/LWMainUI/LWMainDesertUI.prefab"
}
return {LWMainDesertUI = LWMainDesertUI}
