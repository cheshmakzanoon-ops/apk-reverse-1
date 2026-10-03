local UIValentineNpcCollect = {
  Name = UIWindowNames.UIValentineNpcCollect,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIValentineNpcCollect.Ctrl.UIValentineNpcCollectCtrl"),
  View = require("UI.UIValentineNpcCollect.View.UIValentineNpcCollectView"),
  PrefabPath = "Assets/Main/Prefabs/UI/ActivityCenter/Valentine/SendGiftContent/UIValentineNpcCollect.prefab"
}
return {UIValentineNpcCollect = UIValentineNpcCollect}
