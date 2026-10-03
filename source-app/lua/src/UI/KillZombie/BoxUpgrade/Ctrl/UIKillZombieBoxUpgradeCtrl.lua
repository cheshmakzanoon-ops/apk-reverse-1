local UIKillZombieBoxUpgradeCtrl = BaseClass("UIKillZombieBoxUpgradeCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.KillZombieBoxUpgrade)
end

UIKillZombieBoxUpgradeCtrl.CloseSelf = CloseSelf
return UIKillZombieBoxUpgradeCtrl
