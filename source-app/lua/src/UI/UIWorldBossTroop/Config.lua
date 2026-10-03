local UIWorldBossTroop = {
  Name = UIWindowNames.UIWorldBossTroop,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIWorldBossTroop.Controller.UIWorldBossTroopCtrl"),
  View = require("UI.UIWorldBossTroop.View.UIWorldBossTroopView"),
  PrefabPath = "Assets/Main/Prefabs/UI/World/UIWorldBossTroopView.prefab"
}
return {UIWorldBossTroop = UIWorldBossTroop}
