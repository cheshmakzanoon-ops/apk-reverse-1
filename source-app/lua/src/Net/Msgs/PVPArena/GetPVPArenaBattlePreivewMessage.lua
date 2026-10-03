local GetPVPArenaBattlePreivewMessage = BaseClass("GetPVPArenaBattlePreivewMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, otherUid)
  base.OnCreate(self)
  if otherUid then
    self.sfsObj:PutUtfString("otherUid", tostring(otherUid))
  end
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
    EventManager:GetInstance():Broadcast(EventId.PeakArenaGetMessageError)
  else
    EventManager:GetInstance():Broadcast(EventId.PeakArenaGetBattlePreview, t)
  end
end

GetPVPArenaBattlePreivewMessage.OnCreate = OnCreate
GetPVPArenaBattlePreivewMessage.HandleMessage = HandleMessage
return GetPVPArenaBattlePreivewMessage
