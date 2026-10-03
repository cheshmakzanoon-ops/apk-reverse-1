local UITitleGetShowCtrl = BaseClass("UITitleGetShowCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UITitleGetShow)
end

UITitleGetShowCtrl.CloseSelf = CloseSelf
return UITitleGetShowCtrl
