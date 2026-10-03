local OfficialCDSettingCtrl = BaseClass("OfficialCDSettingCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.OfficialCDSetting)
end

OfficialCDSettingCtrl.CloseSelf = CloseSelf
return OfficialCDSettingCtrl
