local PushDetectTreasureClaimMessage = BaseClass("PushDetectTreasureClaimMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, uuid)
  base.OnCreate(self)
  self.sfsObj:PutLong("uuid", uuid)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    local data = {
      bUuid = t.uuid,
      msg = t
    }
    EventManager:GetInstance():Broadcast(EventId.WorldBuildTopBubbleTreasureGet, data)
  end
end

PushDetectTreasureClaimMessage.OnCreate = OnCreate
PushDetectTreasureClaimMessage.HandleMessage = HandleMessage
return PushDetectTreasureClaimMessage
