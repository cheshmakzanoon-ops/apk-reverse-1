local ChampionDuelRewardBatchGetMessage = BaseClass("ChampionDuelRewardBatchGetMessage", SFSBaseMessage)
local base = SFSBaseMessage

function ChampionDuelRewardBatchGetMessage:OnCreate(stage)
  base.OnCreate(self)
  self.sfsObj:PutInt("stage", stage)
end

function ChampionDuelRewardBatchGetMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.ChampionDuelManager:HandleAllRewardGet(t)
  end
end

return ChampionDuelRewardBatchGetMessage
