local SeasonMonsterEventActRankViewMessage = BaseClass("SeasonMonsterEventActRankViewMessage", SFSBaseMessage)
local base = SFSBaseMessage

function SeasonMonsterEventActRankViewMessage:OnCreate()
  base.OnCreate(self)
end

function SeasonMonsterEventActRankViewMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  elseif t.rankInfo then
    DataCenter.JungleTrialDataManager:HandleRankInfo(t.rankInfo)
  end
end

return SeasonMonsterEventActRankViewMessage
