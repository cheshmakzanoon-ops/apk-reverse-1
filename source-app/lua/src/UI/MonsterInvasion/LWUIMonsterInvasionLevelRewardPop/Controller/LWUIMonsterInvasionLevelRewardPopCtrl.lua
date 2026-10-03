local LWUIMonsterInvasionLevelRewardPopCtrl = BaseClass("LWUIMonsterInvasionLevelRewardPopCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.LWUIMonsterInvasionLevelRewardPop)
end

LWUIMonsterInvasionLevelRewardPopCtrl.CloseSelf = CloseSelf
return LWUIMonsterInvasionLevelRewardPopCtrl
