local PushEpidemicZoneBattleSkillStatisticsInfoMessage = BaseClass("PushEpidemicZoneBattleSkillStatisticsInfoMessage", SFSBaseMessage)
local base = SFSBaseMessage

function PushEpidemicZoneBattleSkillStatisticsInfoMessage:OnCreate()
  base.OnCreate(self)
end

function PushEpidemicZoneBattleSkillStatisticsInfoMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
    return
  end
  DataCenter.ActEpidemicZoneManager:HandleBattleSkillStatisticsInfo(t)
end

return PushEpidemicZoneBattleSkillStatisticsInfoMessage
