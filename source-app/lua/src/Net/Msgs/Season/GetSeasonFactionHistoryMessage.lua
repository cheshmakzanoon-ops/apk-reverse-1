local GetSeasonFactionHistoryMessage = BaseClass("GetSeasonFactionHistoryMessage", SFSBaseMessage)
local base = SFSBaseMessage

function GetSeasonFactionHistoryMessage:OnCreate(pageNum, pageSize)
  base.OnCreate(self)
  self.sfsObj:PutInt("pageNum", pageNum or 0)
  self.sfsObj:PutInt("pageSize", pageSize or 100)
end

function GetSeasonFactionHistoryMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  end
  if t.history then
    if t.pageNum == 0 then
      DataCenter.SeasonDataManager.seasonFactionHistory = t
    end
    EventManager:GetInstance():Broadcast(EventId.LWSeasonFactionHistory, t)
  end
end

return GetSeasonFactionHistoryMessage
