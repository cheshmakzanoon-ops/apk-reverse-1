local Localization = CS.GameEntry.Localization
local UIModifySuccessCtrl = BaseClass("UIModifySuccessCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIModifySuccess)
end

UIModifySuccessCtrl.CloseSelf = CloseSelf
return UIModifySuccessCtrl
