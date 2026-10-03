local UIWorldBattleNews = {
  Name = UIWindowNames.UIWorldBattleNews,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIWorldBattleNews.Controller.UIWorldBattleNewsCtrl"),
  View = require("UI.UIWorldBattleNews.View.UIWorldBattleNewsView"),
  PrefabPath = "Assets/Main/Prefabs/UI/World/WorldBattleNewsView.prefab"
}
return {UIWorldBattleNews = UIWorldBattleNews}
