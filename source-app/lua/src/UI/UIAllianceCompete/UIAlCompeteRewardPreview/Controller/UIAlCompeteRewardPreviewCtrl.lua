local UIAllianceCompeteRewardCtrl = BaseClass("UIAllianceCompeteRewardCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIAlCompeteRewardPreview)
end

local function Close(self)
  UIManager:GetInstance():DestroyWindowByLayer(UILayer.Normal)
end

UIAllianceCompeteRewardCtrl.CloseSelf = CloseSelf
UIAllianceCompeteRewardCtrl.Close = Close
return UIAllianceCompeteRewardCtrl
