local PushAllianceSeasonMonsterEventDeleteMessage = BaseClass("PushAllianceSeasonMonsterEventDeleteMessage", SFSBaseMessage)
local base = SFSBaseMessage

function PushAllianceSeasonMonsterEventDeleteMessage:OnCreate(param)
  base.OnCreate(self)
end

function PushAllianceSeasonMonsterEventDeleteMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  elseif t.monsterUuid then
    DataCenter.JungleTrialDataManager:HandleMonsterRemove(t.monsterUuid)
  end
end

return PushAllianceSeasonMonsterEventDeleteMessage
