local UIGuideVideo = {
  Name = UIWindowNames.UIGuideVideo,
  Layer = UILayer.Info,
  Ctrl = require("UI.UIGuideVideo.Controller.UIGuideVideoCtrl"),
  View = require("UI.UIGuideVideo.View.UIGuideVideoView"),
  PrefabPath = "Assets/Main/Prefabs/Guide/GuideVideo.prefab"
}
return {UIGuideVideo = UIGuideVideo}
