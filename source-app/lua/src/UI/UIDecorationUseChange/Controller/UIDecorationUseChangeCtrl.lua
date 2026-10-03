local UIDecorationUseChangeCtrl = BaseClass("UIDecorationUseChangeCtrl", UIBaseCtrl)
local Localization = CS.GameEntry.Localization

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIDecorationUseChange)
end

UIDecorationUseChangeCtrl.CloseSelf = CloseSelf
return UIDecorationUseChangeCtrl
