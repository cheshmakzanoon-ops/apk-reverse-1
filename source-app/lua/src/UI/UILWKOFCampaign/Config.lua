local UILWKOFCampaign = {
  Name = UIWindowNames.UILWKOFCampaign,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UILWKOFCampaign.Controller.UILWKOFCampaignCtrl"),
  View = require("UI.UILWKOFCampaign.View.UILWKOFCampaignView"),
  PrefabPath = "Assets/Main/Prefabs/UI/LWKOFCampaign/LWKOFCampaign_02.prefab"
}
return {UILWKOFCampaign = UILWKOFCampaign}
