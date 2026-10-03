local EasterEggRedPointMessage = BaseClass("EasterEggRedPointMessage", SFSBaseMessage)
local base = SFSBaseMessage

function EasterEggRedPointMessage:OnCreate(activityId)
  base.OnCreate(self)
  self.sfsObj:PutInt("activityId", activityId)
end

function EasterEggRedPointMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  elseif t.comment then
    EventManager:GetInstance():Broadcast(ChatEventEnum.EasterEggUpdateMainRedDot, t.comment)
  end
end

return EasterEggRedPointMessage
