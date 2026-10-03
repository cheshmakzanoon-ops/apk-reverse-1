local FetchRainforestKingBattleGatherDestroyChestMessage = BaseClass("FetchRainforestKingBattleGatherDestroyChestMessage", SFSBaseMessage)
local base = SFSBaseMessage

function FetchRainforestKingBattleGatherDestroyChestMessage:OnCreate(targetServer)
  base.OnCreate(self)
  self.sfsObj:PutInt("targetServer", targetServer)
end

function FetchRainforestKingBattleGatherDestroyChestMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
    return
  end
  if t.reward ~= nil then
    DataCenter.RewardManager:ShowCommonReward(t)
    DataCenter.RewardManager:AddRewardsAndRes(t)
  end
  SFSNetwork.SendMessage(MsgDefines.FetchRainforestKingBattleActivityInfo)
end

return FetchRainforestKingBattleGatherDestroyChestMessage
