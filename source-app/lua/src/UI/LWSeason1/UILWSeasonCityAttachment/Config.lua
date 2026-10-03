local UILWSeasonCityAttachment = {
  Name = UIWindowNames.UILWSeasonCityAttachment,
  Layer = UILayer.Normal,
  Ctrl = require("UI.LWSeason1.UILWSeasonCityAttachment.Controller.UILWSeasonCityAttachmentCtrl"),
  View = require("UI.LWSeason1.UILWSeasonCityAttachment.View.UILWSeasonCityAttachmentView"),
  PrefabPath = "Assets/Main/Prefabs/UI/LWSeason1/CityAttachmentMain/CityAttachment.prefab",
  HideBack = true
}
return {UILWSeasonCityAttachment = UILWSeasonCityAttachment}
