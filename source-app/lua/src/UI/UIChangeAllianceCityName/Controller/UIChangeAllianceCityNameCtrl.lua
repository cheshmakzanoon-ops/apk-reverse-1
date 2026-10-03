local UIChangeAllianceCityNameCtrl = BaseClass("UIChangeAllianceCityNameCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIChangeAllianceCityName)
end

local function Close(self)
  UIManager:GetInstance():DestroyWindowByLayer(UILayer.Normal)
end

local function SetCityId(self, cityId)
  self.cityId = cityId
end

local function CheckName(self, value)
  local type = CheckNameType.None
  local len = #value
  if len < MIN_AL_NAME_CHAR then
    type = CheckNameType.MinNameChar
  end
  return type
end

local function SendCheckNameMessage(self, value)
  SFSNetwork.SendMessage(MsgDefines.WorldCheckAllianceCityName, value, self.cityId)
end

local function SendChangeNameMessage(self, value)
  SFSNetwork.SendMessage(MsgDefines.WorldChangeAllianceCityName, value, self.cityId)
end

UIChangeAllianceCityNameCtrl.CloseSelf = CloseSelf
UIChangeAllianceCityNameCtrl.Close = Close
UIChangeAllianceCityNameCtrl.CheckName = CheckName
UIChangeAllianceCityNameCtrl.SendCheckNameMessage = SendCheckNameMessage
UIChangeAllianceCityNameCtrl.SendChangeNameMessage = SendChangeNameMessage
UIChangeAllianceCityNameCtrl.SetCityId = SetCityId
return UIChangeAllianceCityNameCtrl
