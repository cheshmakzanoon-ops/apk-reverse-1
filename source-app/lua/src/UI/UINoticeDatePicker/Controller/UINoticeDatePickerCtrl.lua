local UINoticeDatePickerCtrl = BaseClass("UINoticeDatePickerCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager.Instance:DestroyWindow(UIWindowNames.UINoticeDatePicker)
end

UINoticeDatePickerCtrl.CloseSelf = CloseSelf
return UINoticeDatePickerCtrl
