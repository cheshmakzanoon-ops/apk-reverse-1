local ValentineViewDayInfoMessage = BaseClass("ValentineViewDayInfoMessage", SFSBaseMessage)
local base = SFSBaseMessage

function ValentineViewDayInfoMessage:OnCreate(activityId, lastOpenDay)
  base.OnCreate(self)
  self.sfsObj:PutInt("activityId", activityId)
  self.sfsObj:PutInt("day", lastOpenDay)
end

function ValentineViewDayInfoMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  elseif t.activityId then
    local param = {}
    param.activityId = toInt(t.activityId)
    if t.reward then
      param.reward = t.reward
    end
    if t.firstPlayerInfo then
      param.championInfo = t.firstPlayerInfo
    end
    if t.day then
      param.day = t.day
    end
    if t.exp then
      param.exp = toInt(t.exp)
    end
    EventManager:GetInstance():Broadcast(EventId.ValentineReceiveChampionRewardData, param)
  end
end

return ValentineViewDayInfoMessage
