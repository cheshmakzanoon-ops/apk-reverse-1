local UIMoveCityTipCtrl = BaseClass("UIMoveCityTipCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager.Instance:DestroyWindow(UIWindowNames.UIMoveCityTip, {anim = true})
end

local function Close(self)
  UIManager.Instance:DestroyWindowByLayer(UILayer.Normal, false)
end

UIMoveCityTipCtrl.CloseSelf = CloseSelf
UIMoveCityTipCtrl.Close = Close
return UIMoveCityTipCtrl
