local LWCityEventCityFightRewardCtrl = BaseClass("LWCityEventCityFightRewardCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UICityEventCityFightReward)
end

LWCityEventCityFightRewardCtrl.CloseSelf = CloseSelf
return LWCityEventCityFightRewardCtrl
