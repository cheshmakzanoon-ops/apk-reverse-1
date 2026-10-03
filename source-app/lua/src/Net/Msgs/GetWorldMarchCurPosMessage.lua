local GetWorldMarchCurPosMessage = BaseClass("GetWorldMarchCurPosMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

local function OnCreate(self, uuid)
  base.OnCreate(self)
  self.sfsObj:PutLong("uuid", uuid)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  end
  EventManager:GetInstance():Broadcast(EventId.WorldMarchGetCurPos, t)
end

GetWorldMarchCurPosMessage.OnCreate = OnCreate
GetWorldMarchCurPosMessage.HandleMessage = HandleMessage
return GetWorldMarchCurPosMessage
