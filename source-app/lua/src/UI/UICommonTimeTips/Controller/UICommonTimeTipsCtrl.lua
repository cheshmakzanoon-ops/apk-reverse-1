local UICommonTimeTipsCtrl = BaseClass("UICommonTimeTipsCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UICommonTimeTips)
end

UICommonTimeTipsCtrl.CloseSelf = CloseSelf
return UICommonTimeTipsCtrl
