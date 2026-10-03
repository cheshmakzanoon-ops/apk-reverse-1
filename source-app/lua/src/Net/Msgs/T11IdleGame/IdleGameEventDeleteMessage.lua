local IdleGameEventDeleteMessage = BaseClass("IdleGameEventDeleteMessage", SFSBaseMessage)
local base = SFSBaseMessage

function IdleGameEventDeleteMessage:OnCreate(param)
  base.OnCreate(self)
  self.sfsObj:PutLong("uuid", param.eventUuid)
end

function IdleGameEventDeleteMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    UIManager:GetInstance():DestroyWindow(UIWindowNames.UIIdleGameTaskEventDetail)
    local eventUuid = t.uuid
    if eventUuid then
      DataCenter.T11IdleGameDataManager:RemoveEventData({uuid = eventUuid})
      EventManager:GetInstance():Broadcast(EventId.T11IdleGameTaskEventListRefresh)
      UIUtil.ShowTipsId("t11_idle_game_desc_94")
    end
  end
end

return IdleGameEventDeleteMessage
