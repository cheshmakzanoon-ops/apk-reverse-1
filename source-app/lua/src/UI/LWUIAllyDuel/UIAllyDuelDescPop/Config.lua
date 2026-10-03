local UIAllyDuelDescPop = {
  Name = UIWindowNames.UIAllyDuelDescPop,
  Layer = UILayer.Normal,
  Ctrl = require("UI.LWUIAllyDuel.UIAllyDuelDescPop.Controller.UIAllyDuelDescPopCtrl"),
  View = require("UI.LWUIAllyDuel.UIAllyDuelDescPop.View.UIAllyDuelDescPopView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UIAllyDuel/UIAllyDuelDescPop.prefab"
}
return {UIAllyDuelDescPop = UIAllyDuelDescPop}
