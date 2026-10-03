local UIGetPickaxe = {
  Name = UIWindowNames.UIGetPickaxe,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIGetPickaxe.Controller.UIGetPickaxeCtrl"),
  View = require("UI.UIGetPickaxe.View.UIGetPickaxeView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UIGetPickaxe/UIGetPickaxe.prefab"
}
return {UIGetPickaxe = UIGetPickaxe}
