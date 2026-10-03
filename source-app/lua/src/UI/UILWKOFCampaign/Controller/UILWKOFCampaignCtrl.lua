local UILWKOFCampaignCtrl = BaseClass("UILWKOFCampaignCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UILWKOFCampaign)
end

UILWKOFCampaignCtrl.CloseSelf = CloseSelf
return UILWKOFCampaignCtrl
