local UILWDevConsole = {
  Name = UIWindowNames.UILWDevConsole,
  Layer = UILayer.TopMost,
  Ctrl = require("UI.UILWDevConsole.Controller.UILWDevConsoleCtrl"),
  View = require("UI.UILWDevConsole.View.UILWDevConsoleView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UILWDevConsole/UILWDevConsole.prefab"
}
return {UILWDevConsole = UILWDevConsole}
