local UICityEventKillZombieRewardCtrl = BaseClass("UICityEventKillZombieRewardCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UICityEventKillZombieReward, {anim = false})
end

UICityEventKillZombieRewardCtrl.CloseSelf = CloseSelf
return UICityEventKillZombieRewardCtrl
