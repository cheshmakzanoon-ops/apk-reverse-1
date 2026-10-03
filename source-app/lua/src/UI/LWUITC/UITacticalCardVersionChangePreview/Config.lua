local UITacticalCardVersionChangePreview = {
  Name = UIWindowNames.UITacticalCardVersionChangePreview,
  Layer = UILayer.Normal,
  Ctrl = require("UI.LWUITC.UITacticalCardVersionChangePreview.Ctrl.UITacticalCardVersionChangePreviewCtrl"),
  View = require("UI.LWUITC.UITacticalCardVersionChangePreview.View.UITacticalCardVersionChangePreviewView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UILWTC/ChangePreview/UITacticalCardVersionChangePreview.prefab"
}
return {UITacticalCardVersionChangePreview = UITacticalCardVersionChangePreview}
