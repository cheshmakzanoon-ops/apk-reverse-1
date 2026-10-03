local FetchAllianceAllyLogListMessage = BaseClass("FetchAllianceAllyLogListMessage", SFSBaseMessage)
local base = SFSBaseMessage

function FetchAllianceAllyLogListMessage:OnCreate(playType, eventType, pageNum, pageSize)
  base.OnCreate(self)
  self.sfsObj:PutInt("playType", playType)
  self.sfsObj:PutInt("eventType", eventType)
  self.sfsObj:PutInt("page", pageNum)
  self.sfsObj:PutInt("pageSize", pageSize or 100)
end

function FetchAllianceAllyLogListMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
    return
  end
  if t.playType == 1 then
    DataCenter.SeasonAllyFriendManager:UpdateOpLog(t.eventType, t.page, t.pageSize, t)
  end
end

return FetchAllianceAllyLogListMessage
