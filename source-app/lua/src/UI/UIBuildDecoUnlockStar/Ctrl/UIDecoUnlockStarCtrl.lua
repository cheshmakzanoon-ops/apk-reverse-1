local UIDecoUnlockStarCtrl = BaseClass("UIDecoUnlockStarCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIBuildDecoUnlockStar)
end

UIDecoUnlockStarCtrl.CloseSelf = CloseSelf
return UIDecoUnlockStarCtrl
