local UIExplorerTreasureRewardCtrl = BaseClass("UIExplorerTreasureRewardCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIExplorerTreasureReward)
end

local function OnCustomKeyCodeEscape(self)
end

UIExplorerTreasureRewardCtrl.CloseSelf = CloseSelf
UIExplorerTreasureRewardCtrl.OnCustomKeyCodeEscape = OnCustomKeyCodeEscape
return UIExplorerTreasureRewardCtrl
