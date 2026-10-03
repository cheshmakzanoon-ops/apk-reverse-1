local EpidemicZoneBattleUseSkillMessage = BaseClass("EpidemicZoneBattleUseSkillMessage", SFSBaseMessage)
local base = SFSBaseMessage

function EpidemicZoneBattleUseSkillMessage:OnCreate(pointId, group)
  base.OnCreate(self)
  self.sfsObj:PutInt("pointId", pointId)
  self.sfsObj:PutInt("group", group)
end

function EpidemicZoneBattleUseSkillMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.ActEpidemicZoneManager:HandleBattleUseSkill(t)
  end
  EventManager:GetInstance():Broadcast(EventId.SetMovingUI, UIMovingType.Close)
  TimerManager:GetInstance():DelayInvoke(function()
    EventManager:GetInstance():Broadcast(EventId.MoveCityPostProcess)
  end, 3)
end

return EpidemicZoneBattleUseSkillMessage
