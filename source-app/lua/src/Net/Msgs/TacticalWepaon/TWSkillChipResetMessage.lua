local TWSkillChipResetMessage = BaseClass("TWSkillChipResetMessage", SFSBaseMessage)
local base = SFSBaseMessage

function TWSkillChipResetMessage:OnCreate(uuidArr)
  base.OnCreate(self)
  self.sfsObj:PutLongArray("uuidArr", uuidArr)
end

function TWSkillChipResetMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    print(errCode)
    UIUtil.ShowTipsId(errCode)
  elseif t.reward then
    DataCenter.RewardManager:AddRewardsAndRes(t)
    local updates = t.changeCfgArr
    if updates ~= nil then
      for i, v in ipairs(updates) do
        local rewardInfo = {}
        rewardInfo.type = RewardType.TWSkillChip
        rewardInfo.value = {}
        rewardInfo.value.updates = {}
        table.insert(rewardInfo.value.updates, v)
        table.insert(t.reward, rewardInfo)
      end
    end
    DataCenter.RewardManager:ShowCommonReward(t)
  end
end

return TWSkillChipResetMessage
