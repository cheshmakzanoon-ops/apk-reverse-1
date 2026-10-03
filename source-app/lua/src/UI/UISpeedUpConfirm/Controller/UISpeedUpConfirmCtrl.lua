local UISpeedUpConfirmCtrl = BaseClass("UISpeedUpConfirmCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager.Instance:DestroyWindow(UIWindowNames.UISpeedUpConfirm)
end

local function Close(self)
  UIManager.Instance:DestroyWindowByLayer(UILayer.Dialog)
end

UISpeedUpConfirmCtrl.CloseSelf = CloseSelf
UISpeedUpConfirmCtrl.Close = Close
return UISpeedUpConfirmCtrl
