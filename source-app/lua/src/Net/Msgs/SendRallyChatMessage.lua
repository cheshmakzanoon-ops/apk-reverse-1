local SendRallyChatMessage = BaseClass("SendRallyChatMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

local function OnCreate(self, teamUuid, room, targetUid)
  base.OnCreate(self)
  if teamUuid then
    self.sfsObj:PutLong("teamUuid", teamUuid)
  end
  if room then
    self.sfsObj:PutInt("room", room)
  end
  if targetUid then
    self.sfsObj:PutUtfString("targetUid", targetUid)
  end
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
  end
end

SendRallyChatMessage.OnCreate = OnCreate
SendRallyChatMessage.HandleMessage = HandleMessage
return SendRallyChatMessage
