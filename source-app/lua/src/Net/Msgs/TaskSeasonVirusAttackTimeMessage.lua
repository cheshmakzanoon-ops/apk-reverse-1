local TaskSeasonVirusAttackTimeMessage = BaseClass("TaskSeasonVirusAttackTimeMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, attackTimes)
  base.OnCreate(self)
  self.sfsObj:PutInt("attackTimes", attackTimes)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  if t.errorCode then
    UIUtil.ShowTipsId(t.errorCode)
  else
    DataCenter.LWSeasonBossLoginDataManager:ParseVirusAttackTimes(t)
    EventManager:GetInstance():Broadcast(EventId.OnActBossRankRefresh)
    EventManager:GetInstance():Broadcast(EventId.SeasonVirusBossReddot)
  end
end

TaskSeasonVirusAttackTimeMessage.OnCreate = OnCreate
TaskSeasonVirusAttackTimeMessage.HandleMessage = HandleMessage
return TaskSeasonVirusAttackTimeMessage
