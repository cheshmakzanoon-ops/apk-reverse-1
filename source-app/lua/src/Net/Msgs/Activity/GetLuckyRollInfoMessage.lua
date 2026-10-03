local GetLuckyRollInfoMessage = BaseClass("GetLuckyRollInfoMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

local function OnCreate(self, activityId)
  base.OnCreate(self)
  self.sfsObj:PutInt("activityId", activityId)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.ActLuckyRollInfo:ParseEventData(t)
    EventManager:GetInstance():Broadcast(EventId.ActLuckyRollUpdate)
  end
end

GetLuckyRollInfoMessage.OnCreate = OnCreate
GetLuckyRollInfoMessage.HandleMessage = HandleMessage
return GetLuckyRollInfoMessage
