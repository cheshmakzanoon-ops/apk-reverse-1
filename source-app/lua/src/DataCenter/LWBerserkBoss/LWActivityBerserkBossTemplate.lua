local LWActivityBerserkBossTemplate = BaseClass("LWActivityBerserkBossTemplate")

function LWActivityBerserkBossTemplate:__init()
  self.id = 0
  self.level = 0
  self.monster = 0
  self.img = ""
  self.icon = ""
  self.reward = ""
  self.id2RewardTotalPercent = {}
  self.id2RewardQuality = {}
  self.effect = ""
  self.effectDataList = nil
  self.type = 0
end

function LWActivityBerserkBossTemplate:__delete()
  self.id = nil
  self.level = nil
  self.monster = nil
  self.img = nil
  self.icon = nil
  self.reward = nil
  self.id2RewardTotalPercent = nil
  self.id2RewardQuality = nil
  self.effect = nil
  self.effectDataList = nil
  self.type = nil
end

function LWActivityBerserkBossTemplate:Init(row)
  self.id = row:getValue("id") or 0
  self.level = row:getValue("level") or 0
  self.monster = row:getValue("monster") or 0
  self.img = row:getValue("img") or ""
  self.icon = row:getValue("icon") or ""
  self.reward = row:getValue("reward") or ""
  self.effect = row:getValue("effect") or ""
  self.type = row:getValue("type") or ""
end

function LWActivityBerserkBossTemplate:GetRewardInfoById(id)
  if self.id2RewardTotalPercent[id] == nil then
    self:SplitReward()
  end
  return self.id2RewardTotalPercent[id], self.id2RewardQuality[id]
end

function LWActivityBerserkBossTemplate:GetRewardAllTotalPercentInfo()
  if table.count(self.id2RewardTotalPercent) then
    self:SplitReward()
  end
  return self.id2RewardTotalPercent
end

function LWActivityBerserkBossTemplate:SplitReward()
  local rewardStrArr = string.split(self.reward, "|")
  local count = table.count(rewardStrArr)
  for i = 1, count do
    local rewardArr = string.split(rewardStrArr[i], ";")
    local rewardInfoCount = table.count(rewardArr)
    if rewardInfoCount == 3 then
      local totalPercent = tonumber(rewardArr[1]) / 100
      local quality = tonumber(rewardArr[3])
      self.id2RewardTotalPercent[i] = totalPercent
      self.id2RewardQuality[i] = quality
    end
  end
end

function LWActivityBerserkBossTemplate:GetEffectDataList()
  if string.IsNullOrEmpty(self.effect) then
    return nil
  end
  if self.effectList == nil then
    self.effectDataList = {}
    local effectStrArr = string.split(self.effect, "|")
    local count = table.count(effectStrArr)
    for i = 1, count do
      local effectArr = string.split(effectStrArr[i], ";")
      local effectCount = table.count(effectArr)
      if effectCount == 2 then
        local oneData = {}
        oneData.effectId = tonumber(effectArr[1])
        oneData.effectValue = tonumber(effectArr[2])
        table.insert(self.effectDataList, oneData)
      end
    end
  end
  return self.effectDataList
end

return LWActivityBerserkBossTemplate
