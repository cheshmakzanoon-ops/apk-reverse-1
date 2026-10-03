local UILWCommonRecordLogCtrl = BaseClass("UILWCommonRecordLogCtrl", UIBaseCtrl)
local Localization = CS.GameEntry.Localization

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UILWCommonRecordLog, {anim = true})
end

UILWCommonRecordLogCtrl.CloseSelf = CloseSelf
return UILWCommonRecordLogCtrl
