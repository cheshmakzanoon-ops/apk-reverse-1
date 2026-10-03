local LWUIMasteryTemplate = {
  Name = UIWindowNames.LWUIMasteryTemplate,
  Layer = UILayer.Normal,
  Ctrl = require("UI.LWUIMasteryTemplate.Controller.LWUIMasteryTemplateCtrl"),
  View = require("UI.LWUIMasteryTemplate.View.LWUIMasteryTemplateView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UIMastery/LWUIMasteryTemplate.prefab"
}
return {LWUIMasteryTemplate = LWUIMasteryTemplate}
