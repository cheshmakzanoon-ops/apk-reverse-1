local FetchAllianceAllyLogDetailMessage = BaseClass("FetchAllianceAllyLogDetailMessage", SFSBaseMessage)
local base = SFSBaseMessage

function FetchAllianceAllyLogDetailMessage:OnCreate(uuid)
  base.OnCreate(self)
  self.sfsObj:PutLong("uuid", uuid)
end

function FetchAllianceAllyLogDetailMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
    return
  end
  if t.uuid ~= nil then
    DataCenter.SeasonAllyFriendManager:UpdateOpLogDetail(t.uuid, t)
  end
end

return FetchAllianceAllyLogDetailMessage
