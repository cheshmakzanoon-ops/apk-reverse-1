local WorldFavoClearAllMessage = BaseClass("WorldFavoClearAllMessage", SFSBaseMessage)
local base = SFSBaseMessage

function WorldFavoClearAllMessage:OnCreate(param)
  base.OnCreate(self)
  self.sfsObj:PutInt("type", param.type)
end

function WorldFavoClearAllMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.WorldFavoDataManager:DelBookmarkByType(t.type)
    EventManager:GetInstance():Broadcast(EventId.RefreshBookmark)
  end
end

return WorldFavoClearAllMessage
