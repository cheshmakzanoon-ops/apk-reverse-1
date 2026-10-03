local UIJungleTrialRankCtrl = BaseClass("UIJungleTrialRankCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIJungleTrialRank)
end

UIJungleTrialRankCtrl.CloseSelf = CloseSelf
return UIJungleTrialRankCtrl
