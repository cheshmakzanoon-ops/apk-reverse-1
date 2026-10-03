local SeasonMonsterEventActViewMessage = BaseClass("SeasonMonsterEventActViewMessage", SFSBaseMessage)
local base = SFSBaseMessage

function SeasonMonsterEventActViewMessage:OnCreate(param)
  base.OnCreate(self)
end

function SeasonMonsterEventActViewMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.JungleTrialDataManager:HandleJungleTrialActivityInfo(t)
  end
end

return SeasonMonsterEventActViewMessage
