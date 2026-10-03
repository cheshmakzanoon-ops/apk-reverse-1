local UILWSeasonAttachmentBuildDetail = {
  Name = UIWindowNames.UILWSeasonAttachmentBuildDetail,
  Layer = UILayer.Info,
  Ctrl = require("UI.LWSeason.LWSeasonAttachmentBuildDetail.Controller.LWSeasonAttachmentBuildDetailCtrl"),
  View = require("UI.LWSeason.LWSeasonAttachmentBuildDetail.View.LWSeasonAttachmentBuildDetailView"),
  PrefabPath = "Assets/Main/Prefabs/UI/LWWorld/Component/AttachmentBuildPopUp.prefab"
}
return {UILWSeasonAttachmentBuildDetail = UILWSeasonAttachmentBuildDetail}
