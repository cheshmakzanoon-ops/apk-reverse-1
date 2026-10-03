local PushEpidemicBattleSkillCityPlaceMessage = BaseClass("PushEpidemicBattleSkillCityPlaceMessage", SFSBaseMessage)
local base = SFSBaseMessage

function PushEpidemicBattleSkillCityPlaceMessage:OnCreate()
  base.OnCreate(self)
end

function PushEpidemicBattleSkillCityPlaceMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
    return
  end
  DataCenter.ActEpidemicZoneManager:HandleBattleSkillMVBorn(t)
end

return PushEpidemicBattleSkillCityPlaceMessage
