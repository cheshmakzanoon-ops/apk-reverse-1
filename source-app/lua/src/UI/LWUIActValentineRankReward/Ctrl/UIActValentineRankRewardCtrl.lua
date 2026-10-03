local UIActValentineRankRewardCtrl = BaseClass("UIActValentineRankRewardCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIActValentineRankRewardView)
end

UIActValentineRankRewardCtrl.CloseSelf = CloseSelf
return UIActValentineRankRewardCtrl
