local QueryThumbsMessage = BaseClass("QueryThumbsMessage", SFSBaseMessage)
local base = SFSBaseMessage

function QueryThumbsMessage:OnCreate(activityId)
  base.OnCreate(self)
  self.sfsObj:PutUtfString("activityId", activityId)
end

function QueryThumbsMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
    return
  end
  DataCenter.SeasonCallbackManager:OnQueryThumbsInfoUpdate(t.activityId)
  if t.recordArr then
    for i = 1, #t.recordArr do
      DataCenter.SeasonCallbackManager:SetThumbsInfo(t.recordArr[i], t.activityId)
    end
  end
  EventManager:GetInstance():Broadcast(EventId.LWQueryThumbsInfoUpdate)
end

return QueryThumbsMessage
