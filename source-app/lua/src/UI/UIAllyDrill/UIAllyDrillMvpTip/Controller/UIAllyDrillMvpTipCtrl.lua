local UIAllyDrillMvpTipCtrl = BaseClass("UIAllyDrillMvpTipCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager.Instance:DestroyWindow(UIWindowNames.UIAllyDrillMvpTip, {anim = true})
end

UIAllyDrillMvpTipCtrl.CloseSelf = CloseSelf
return UIAllyDrillMvpTipCtrl
