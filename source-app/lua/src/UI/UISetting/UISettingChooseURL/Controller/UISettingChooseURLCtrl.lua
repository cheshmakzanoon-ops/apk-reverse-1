local rapidjson = require("rapidjson")
local UISettingChooseURLCtrl = BaseClass("UISettingChooseURLCtrl", UIBaseCtrl)
local Setting = CS.GameEntry.Setting

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UISettingChooseURL)
end

local function Close(self)
  UIManager:GetInstance():DestroyWindowByLayer(UILayer.Normal)
end

UISettingChooseURLCtrl.CloseSelf = CloseSelf
UISettingChooseURLCtrl.Close = Close
UISettingChooseURLCtrl.OnClick = OnClick
return UISettingChooseURLCtrl
