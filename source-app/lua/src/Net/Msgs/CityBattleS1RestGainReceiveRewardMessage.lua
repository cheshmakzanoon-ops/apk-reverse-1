local CityBattleS1RestGainReceiveRewardMessage = BaseClass("CityBattleS1RestGainReceiveRewardMessage", SFSBaseMessage)
local base = SFSBaseMessage

function CityBattleS1RestGainReceiveRewardMessage:OnCreate(group, configId)
  base.OnCreate(self)
  self.sfsObj:PutInt("group", group)
  self.sfsObj:PutInt("configId", configId)
end

function CityBattleS1RestGainReceiveRewardMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  elseif t.reward ~= nil then
    DataCenter.RewardManager:AddRewards(t.reward)
    if t.configId and t.configId == -2 then
      DataCenter.RewardManager:ShowCommonReward(t)
    end
    SFSNetwork.SendMessage(MsgDefines.CityBattleActivityGainTaskInfo, t.groupId)
  end
end

return CityBattleS1RestGainReceiveRewardMessage
