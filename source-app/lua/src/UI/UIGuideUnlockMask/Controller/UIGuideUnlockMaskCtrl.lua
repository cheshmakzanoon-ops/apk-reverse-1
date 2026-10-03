local UIGuideUnlockMaskCtrl = BaseClass("UIGuideUnlockMaskCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIGuideUnlockMask, {anim = true, playEffect = false})
end

UIGuideUnlockMaskCtrl.CloseSelf = CloseSelf
UIGuideUnlockMaskCtrl.Close = Close
return UIGuideUnlockMaskCtrl
