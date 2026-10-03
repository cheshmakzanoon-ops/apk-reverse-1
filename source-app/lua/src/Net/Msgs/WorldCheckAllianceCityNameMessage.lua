local WorldCheckAllianceCityNameMessage = BaseClass("WorldCheckAllianceCityNameMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

local function OnCreate(self, cityName, cityId)
  base.OnCreate(self)
  self.sfsObj:PutInt("cityId", cityId)
  self.sfsObj:PutUtfString("name", cityName)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  elseif t.reason ~= nil then
    local type = t.reason
    EventManager:GetInstance():Broadcast(EventId.AllianceCityNameCheck, type)
  end
end

WorldCheckAllianceCityNameMessage.OnCreate = OnCreate
WorldCheckAllianceCityNameMessage.HandleMessage = HandleMessage
return WorldCheckAllianceCityNameMessage
