local GetRankPreviewMessage = BaseClass("GetRankPreviewMessage", SFSBaseMessage)
local base = SFSBaseMessage

function GetRankPreviewMessage:OnCreate(global, serverId)
  base.OnCreate(self)
  self.sfsObj:PutInt("global", global)
  self.sfsObj:PutInt("serverId", serverId)
end

function GetRankPreviewMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    if "E000000" == errCode then
      UIUtil.ShowTipsId("110534")
    else
      UIUtil.ShowTipsId(errCode)
    end
  elseif t.data ~= nil then
    DataCenter.RankDataManager:UpdatePreviewRankData(t.global or 0, t.data, t.serverId)
  end
  EventManager:GetInstance():Broadcast(EventId.UpdateRankPreview)
end

return GetRankPreviewMessage
