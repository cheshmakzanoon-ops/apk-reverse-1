local UILWExpiredItemConvertCtrl = BaseClass("UILWExpiredItemConvertCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager.Instance:DestroyWindow(UIWindowNames.UILWExpiredItemConvert)
end

UILWExpiredItemConvertCtrl.CloseSelf = CloseSelf
return UILWExpiredItemConvertCtrl
