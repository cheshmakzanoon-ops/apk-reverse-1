local RewardGhostParkourBattlepassMessage = BaseClass("RewardGhostParkourBattlepassMessage", SFSBaseMessage)
local base = SFSBaseMessage

function RewardGhostParkourBattlepassMessage:OnCreate(param)
  base.OnCreate(self)
  self.sfsObj:PutInt("round", param.round)
  self.sfsObj:PutInt("id", param.id)
  self.sfsObj:PutInt("type", param.type)
end

function RewardGhostParkourBattlepassMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.LWGhostParkourDataManager:SaveGhostParkourRewardInfo(t)
  end
end

return RewardGhostParkourBattlepassMessage
