local UIBloodyNightRewardCtrl = BaseClass("UIBloodyNightRewardCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIBloodyNightReward)
end

UIBloodyNightRewardCtrl.CloseSelf = CloseSelf
return UIBloodyNightRewardCtrl
