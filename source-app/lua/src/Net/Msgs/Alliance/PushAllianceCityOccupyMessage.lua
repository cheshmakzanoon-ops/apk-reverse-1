local PushAllianceCityOccupyMessage = BaseClass("PushAllianceCityOccupyMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self)
  base.OnCreate(self)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.WorldAllianceCityDataManager:PushCityOccupy(t)
  end
end

PushAllianceCityOccupyMessage.OnCreate = OnCreate
PushAllianceCityOccupyMessage.HandleMessage = HandleMessage
return PushAllianceCityOccupyMessage
