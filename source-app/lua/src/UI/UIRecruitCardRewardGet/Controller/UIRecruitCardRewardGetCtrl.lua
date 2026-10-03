local UIRecruitCardRewardGetCtrl = BaseClass("UIRecruitCardRewardGetCtrl", UIBaseCtrl)
local Localization = CS.GameEntry.Localization

local function CloseSelf(self, useAnimation)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIRecruitCardRewardGet, {anim = useAnimation})
end

local function Close(self)
  UIManager:GetInstance():DestroyWindowByLayer(UILayer.Info)
end

UIRecruitCardRewardGetCtrl.CloseSelf = CloseSelf
UIRecruitCardRewardGetCtrl.Close = Close
return UIRecruitCardRewardGetCtrl
