local SkinPartyReceivePlayersMessage = BaseClass("SkinPartyReceivePlayersMessage", SFSBaseMessage)
local base = SFSBaseMessage

function SkinPartyReceivePlayersMessage:OnCreate(targetUid, statusId, expireTime)
  base.OnCreate(self)
  self.sfsObj:PutInt("statusId", statusId)
  self.sfsObj:PutUtfString("targetUid", targetUid)
  self.sfsObj:PutLong("expireTime", expireTime)
end

function SkinPartyReceivePlayersMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    EventManager:GetInstance():Broadcast(EventId.BuildMainPartyRewardRecordRefresh, t)
  end
end

return SkinPartyReceivePlayersMessage
