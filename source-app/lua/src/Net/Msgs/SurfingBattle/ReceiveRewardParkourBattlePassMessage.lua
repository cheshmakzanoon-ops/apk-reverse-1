local ReceiveRewardParkourBattlePassMessage = BaseClass("ReceiveRewardParkourBattlePassMessage", SFSBaseMessage)
local base = SFSBaseMessage

function ReceiveRewardParkourBattlePassMessage:OnCreate(round, type, id)
  base.OnCreate(self)
  self.sfsObj:PutInt("round", round)
  self.sfsObj:PutInt("type", type)
  self.sfsObj:PutInt("id", id)
end

function ReceiveRewardParkourBattlePassMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.LWSurfingDataManager:UpdateAllianceBattleList(t)
  end
end

return ReceiveRewardParkourBattlePassMessage
