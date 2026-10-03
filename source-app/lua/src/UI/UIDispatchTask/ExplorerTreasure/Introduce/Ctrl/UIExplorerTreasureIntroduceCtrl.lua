local UIExplorerTreasureIntroduceCtrl = BaseClass("UIExplorerTreasureIntroduceCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIExplorerTreasureIntroduce)
end

UIExplorerTreasureIntroduceCtrl.CloseSelf = CloseSelf
return UIExplorerTreasureIntroduceCtrl
