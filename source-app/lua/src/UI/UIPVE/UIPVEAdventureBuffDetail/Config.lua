local UIPVEAdventureBuffDetail = {
  Name = UIWindowNames.UIPVEAdventureBuffDetail,
  Layer = UILayer.Background,
  Ctrl = require("UI.UIPVE.UIPVEAdventureBuffDetail.Controller.UIPVEAdventureBuffDetailCtrl"),
  View = require("UI.UIPVE.UIPVEAdventureBuffDetail.View.UIPVEAdventureBuffDetailView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UIPVE/UIPVEAdventureBuffDetail.prefab"
}
return {UIPVEAdventureBuffDetail = UIPVEAdventureBuffDetail}
