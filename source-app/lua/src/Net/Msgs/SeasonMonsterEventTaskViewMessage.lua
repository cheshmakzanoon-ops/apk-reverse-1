local SeasonMonsterEventTaskViewMessage = BaseClass("SeasonMonsterEventTaskViewMessage", SFSBaseMessage)
local base = SFSBaseMessage

function SeasonMonsterEventTaskViewMessage:OnCreate(actId)
  base.OnCreate(self)
  self.sfsObj:PutInt("actId", actId)
end

function SeasonMonsterEventTaskViewMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  elseif t.seasonMonsterEventTaskArr then
    DataCenter.JungleTrialDataManager:HandleJungleTrialTaskInfo(t.seasonMonsterEventTaskArr)
  end
end

return SeasonMonsterEventTaskViewMessage
