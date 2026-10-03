local GetCampMasterServerHistoryMessage = BaseClass("GetCampMasterServerHistoryMessage", SFSBaseMessage)
local base = SFSBaseMessage

function GetCampMasterServerHistoryMessage:OnCreate(pageNum, pageSize)
  base.OnCreate(self)
  self.sfsObj:PutInt("page", pageNum or 0)
  self.sfsObj:PutInt("pageSize", pageSize or 100)
end

function GetCampMasterServerHistoryMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
    return
  end
  if t.list then
    DataCenter.SeasonFactionWarDataManager.seasonFactionMasterServerHistory = t.list
    EventManager:GetInstance():Broadcast(EventId.LWSeasonFactionHistoryKing)
  end
end

return GetCampMasterServerHistoryMessage
