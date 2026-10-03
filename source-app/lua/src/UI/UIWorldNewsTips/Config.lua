local UIWorldNewsTips = {
  Name = UIWindowNames.UIWorldNewsTips,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIWorldNewsTips.Controller.UIWorldNewsTipsCtrl"),
  View = require("UI.UIWorldNewsTips.View.UIWorldNewsTipsView"),
  PrefabPath = "Assets/Main/Prefabs/UI/World/UIWorldBattleNewsTip.prefab"
}
return {UIWorldNewsTips = UIWorldNewsTips}
