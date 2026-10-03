local EasterChangeAnonymousMessage = BaseClass("EasterChangeAnonymousMessage", SFSBaseMessage)
local base = SFSBaseMessage

function EasterChangeAnonymousMessage:OnCreate(activityId, name, head, type)
  base.OnCreate(self)
  self.sfsObj:PutInt("activityId", activityId)
  self.sfsObj:PutInt("anonymous", name)
  self.sfsObj:PutInt("index", head)
  self.sfsObj:PutInt("type", type)
end

function EasterChangeAnonymousMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    local mainData = DataCenter.ActEasterEggManager:GetActivityData()
    if mainData then
      mainData:UpdateAnonymousInfo(t.anonymousAndHead, t.anonymous, t.type)
      EventManager:GetInstance():Broadcast(ChatEventEnum.CHAT_REFRESH_VIEW)
    end
  end
end

return EasterChangeAnonymousMessage
