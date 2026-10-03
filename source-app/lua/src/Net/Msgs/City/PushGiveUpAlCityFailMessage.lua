local PushGiveUpAlCityFailMessage = BaseClass("PushGiveUpAlCityFailMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

local function OnCreate(self)
  base.OnCreate(self)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.WorldAllianceCityDataManager:OnAlCityGiveUpFail(t, false)
  end
end

PushGiveUpAlCityFailMessage.OnCreate = OnCreate
PushGiveUpAlCityFailMessage.HandleMessage = HandleMessage
return PushGiveUpAlCityFailMessage
