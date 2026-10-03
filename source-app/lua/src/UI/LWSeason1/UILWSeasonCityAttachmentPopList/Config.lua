local UILWSeasonCityAttachmentPopList = {
  Name = UIWindowNames.UILWSeasonCityAttachmentPopList,
  Layer = UILayer.Normal,
  Ctrl = require("UI.LWSeason1.UILWSeasonCityAttachmentPopList.Controller.UILWSeasonCityAttachmentPopListCtrl"),
  View = require("UI.LWSeason1.UILWSeasonCityAttachmentPopList.View.UILWSeasonCityAttachmentPopListView"),
  PrefabPath = "Assets/Main/Prefabs/UI/LWSeason1/CityAttachmentMain/CityAttachmentPopList.prefab"
}
return {UILWSeasonCityAttachmentPopList = UILWSeasonCityAttachmentPopList}
