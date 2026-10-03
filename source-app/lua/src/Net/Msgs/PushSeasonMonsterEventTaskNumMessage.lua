local PushSeasonMonsterEventTaskNumMessage = BaseClass("PushSeasonMonsterEventTaskNumMessage", SFSBaseMessage)
local base = SFSBaseMessage

function PushSeasonMonsterEventTaskNumMessage:OnCreate(param)
  base.OnCreate(self)
end

function PushSeasonMonsterEventTaskNumMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  elseif t.seasonMonsterEventTaskInfo then
    DataCenter.JungleTrialDataManager:HandlePushTask(t.seasonMonsterEventTaskInfo)
  end
end

return PushSeasonMonsterEventTaskNumMessage
