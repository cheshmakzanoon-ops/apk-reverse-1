local UIPVELoading = {
  Name = UIWindowNames.UIPVELoading,
  Layer = UILayer.Dialog,
  Ctrl = require("UI.UIPVE.UIPVELoading.Controller.UIPVELoadingCtrl"),
  View = require("UI.UIPVE.UIPVELoading.View.UIPVELoadingView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UIPVE/UIPVELoading.prefab"
}
return {UIPVELoading = UIPVELoading}
