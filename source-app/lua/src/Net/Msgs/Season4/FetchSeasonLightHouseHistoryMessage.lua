local FetchSeasonLightHouseHistoryMessage = BaseClass("FetchSeasonLightHouseHistoryMessage", SFSBaseMessage)
local base = SFSBaseMessage

function FetchSeasonLightHouseHistoryMessage:OnCreate(pageNum, pageSize)
  base.OnCreate(self)
  self.sfsObj:PutInt("pageNum", pageNum)
  self.sfsObj:PutInt("pageSize", pageSize or 100)
end

function FetchSeasonLightHouseHistoryMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
    return
  end
  if t and t.pageNum and t.pageSize then
    EventManager:GetInstance():Broadcast(EventId.LWSeasonLightHouseHistory, t)
  end
end

return FetchSeasonLightHouseHistoryMessage
