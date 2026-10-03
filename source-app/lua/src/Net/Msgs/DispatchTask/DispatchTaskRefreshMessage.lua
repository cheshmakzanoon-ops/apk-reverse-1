local DispatchTaskRefreshMessage = BaseClass("DispatchTaskRefreshMessage", SFSBaseMessage)
local base = SFSBaseMessage

function DispatchTaskRefreshMessage:OnCreate(costType, super)
  base.OnCreate(self)
  self.sfsObj:PutInt("costType", costType)
  self.sfsObj:PutInt("isSuper", tonumber(super) or 0)
end

function DispatchTaskRefreshMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
    EventManager:GetInstance():Broadcast(EventId.DispatchTaskRefreshError)
    return
  end
  if t then
    DataCenter.ActDispatchTaskDataManager:UpdateAllSingleTasks(t)
  end
end

return DispatchTaskRefreshMessage
