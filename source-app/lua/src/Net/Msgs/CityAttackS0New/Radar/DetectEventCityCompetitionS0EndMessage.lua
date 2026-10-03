local DetectEventCityCompetitionS0EndMessage = BaseClass("DetectEventCityCompetitionS0EndMessage", SFSBaseMessage)
local endUuid
local base = SFSBaseMessage

function DetectEventCityCompetitionS0EndMessage:OnCreate(uuid, eventType)
  base.OnCreate(self)
  self.sfsObj:PutInt("eventType", eventType)
  self.sfsObj:PutUtfString("uuid", tostring(uuid))
  endUuid = uuid
end

function DetectEventCityCompetitionS0EndMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    if t.reward then
      DataCenter.RewardManager:AddRewardsAndRes(t)
    end
    DataCenter.AttackCityS0DataManager:SetCityDetectRadarDoing(endUuid, nil)
    EventManager:GetInstance():Broadcast(EventId.DetectInfoChange)
  end
end

return DetectEventCityCompetitionS0EndMessage
