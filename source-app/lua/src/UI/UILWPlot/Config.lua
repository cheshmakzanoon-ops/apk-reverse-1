local UILWPlot = {
  Name = UIWindowNames.UILWPlot,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UILWPlot.Controller.UILWPlotCtrl"),
  View = require("UI.UILWPlot.View.UILWPlotView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UILWPlot/UILWPlot.prefab",
  CustomKeyCodeEscape = true
}
return {UILWPlot = UILWPlot}
