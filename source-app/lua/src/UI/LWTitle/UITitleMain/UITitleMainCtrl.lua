local UITitleMainCtrl = BaseClass("UITitleMainCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UITitleMain)
end

UITitleMainCtrl.CloseSelf = CloseSelf
return UITitleMainCtrl
