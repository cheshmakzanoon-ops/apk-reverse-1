local PushSeasonMonsterEventRewardUpdateMessage = BaseClass("PushSeasonMonsterEventRewardUpdateMessage", SFSBaseMessage)
local base = SFSBaseMessage

function PushSeasonMonsterEventRewardUpdateMessage:OnCreate(param)
  base.OnCreate(self)
end

function PushSeasonMonsterEventRewardUpdateMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  elseif t.userSeasonMonsterEventRewardRecordInfo then
    DataCenter.JungleTrialDataManager:HandlePushBox(t.userSeasonMonsterEventRewardRecordInfo)
  end
end

return PushSeasonMonsterEventRewardUpdateMessage
