local FetchAllianceAllyInfoMessage = BaseClass("FetchAllianceAllyInfoMessage", SFSBaseMessage)
local base = SFSBaseMessage

function FetchAllianceAllyInfoMessage:OnCreate(targetAllianceId)
  base.OnCreate(self)
  self.sfsObj:PutUtfString("targetAllianceId", targetAllianceId)
end

function FetchAllianceAllyInfoMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    return
  end
  local myAllianceId = LuaEntry.Player.allianceId
  if myAllianceId == nil or myAllianceId == "" then
  elseif myAllianceId == t.targetAllianceId then
    DataCenter.SeasonAllyFriendManager:SetFriendAllianceId(t.allyAllianceId, t.allyTime)
  elseif myAllianceId == t.allyAllianceId then
    DataCenter.SeasonAllyFriendManager:SetFriendAllianceId(t.targetAllianceId, t.allyTime)
  end
end

return FetchAllianceAllyInfoMessage
