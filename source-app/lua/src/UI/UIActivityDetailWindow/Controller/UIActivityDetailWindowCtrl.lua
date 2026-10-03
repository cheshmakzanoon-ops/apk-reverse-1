local UIActivityDetailWindowCtrl = BaseClass("UIActivityDetailWindowCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIActivityDetail)
end

UIActivityDetailWindowCtrl.CloseSelf = CloseSelf
return UIActivityDetailWindowCtrl
