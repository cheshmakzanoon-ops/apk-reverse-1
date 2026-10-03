local PushAllianceSeasonMonsterEventCreateMessage = BaseClass("PushAllianceSeasonMonsterEventCreateMessage", SFSBaseMessage)
local base = SFSBaseMessage

function PushAllianceSeasonMonsterEventCreateMessage:OnCreate(param)
  base.OnCreate(self)
end

function PushAllianceSeasonMonsterEventCreateMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  elseif t.allianceMonsterPointInfo then
    DataCenter.JungleTrialDataManager:HandleMonsterAdd(t.allianceMonsterPointInfo)
  end
end

return PushAllianceSeasonMonsterEventCreateMessage
