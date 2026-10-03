local LWSpreadResearchDataManager = BaseClass("LWSpreadResearchDataManager")

function LWSpreadResearchDataManager:__init()
  self.data = nil
  self.maxLevel = nil
  self.currentConfig = nil
  self.nextConfig = nil
end

function LWSpreadResearchDataManager:__delete()
  self.activityId = nil
  self.data = nil
  self.maxLevel = nil
  self.currentConfig = nil
  self.nextConfig = nil
end

function LWSpreadResearchDataManager:IsVail()
  local actData = self:GetActivityData()
  if actData == nil then
    return false
  end
  if self.data == nil or self.data.level == nil then
    return false
  end
  return true
end

function LWSpreadResearchDataManager:IsEnd()
  if not self:IsVail() then
    return true
  end
  local actData = self:GetActivityData()
  local curTime = UITimeManager:GetInstance():GetServerTime()
  return actData.endTime and curTime > actData.endTime
end

function LWSpreadResearchDataManager:UpdateData(data)
  self.activityId = toInt(data.id)
end

function LWSpreadResearchDataManager:GetActivityData()
  return DataCenter.ActivityListDataManager:GetActivityDataById(self.activityId)
end

function LWSpreadResearchDataManager:ParseData(t)
  self.data = t.virusboss
end

function LWSpreadResearchDataManager:OnMessage(msg)
  self.data = msg
  EventManager:GetInstance():Broadcast(EventId.SeasonPreSpreadResearchInfo)
end

function LWSpreadResearchDataManager:OnExpMessage(msg)
  if msg.reward then
    DataCenter.RewardManager:AddRewardsAndRes({
      reward = msg.reward
    })
    EventManager:GetInstance():Broadcast(EventId.UpdateGold)
  end
  if msg.levelupRewards then
    DataCenter.RewardManager:AddRewardsAndRes({
      reward = msg.levelupRewards[1]
    })
    EventManager:GetInstance():Broadcast(EventId.UpdateGold)
  end
  local levelUp = false
  local curLevel = self:GetCurrentLevel()
  local changeExp = msg.exp - self.data.exp
  if curLevel ~= msg.level then
    self.data.level = msg.level
    levelUp = true
    changeExp = msg.exp + self:GetCurrentLevelConfig().level_up_exp - self.data.exp
  end
  self.data.exp = msg.exp
  self.data.id = msg.id
  self.resistance = msg.resistance
  EventManager:GetInstance():Broadcast(EventId.SeasonPreSpreadResearchExpChange, {
    changeExp = changeExp,
    critMul = msg.critMul,
    reward = msg.reward,
    levelUp = levelUp
  })
end

function LWSpreadResearchDataManager:GetCurrentLevel()
  if not self:IsVail() then
    return false
  end
  return self.data.level
end

function LWSpreadResearchDataManager:GetExp()
  if not self:IsVail() then
    return 0
  end
  return self.data.exp
end

function LWSpreadResearchDataManager:ParseConfig(lineData)
  local research_cost = lineData:getValue("research_cost") or ""
  local research_cost_param = string.split(research_cost, ";")
  return {
    resistance = tonumber(lineData:getValue("resistance") or 0),
    level_up_exp = tonumber(lineData:getValue("level_up_exp") or 0),
    research_cost = {
      itemId = tonumber(research_cost_param[1] or 0),
      count = tonumber(research_cost_param[2] or 0)
    },
    research_add_exp = tonumber(lineData:getValue("research_add_exp") or 0),
    research_reward = tonumber(lineData:getValue("research_reward") or 0),
    level_up_reward = tonumber(lineData:getValue("level_up_reward") or 0)
  }
end

function LWSpreadResearchDataManager:GetCurrentLevelConfig()
  if not self:IsVail() then
    return nil
  end
  local currentLevel = self:GetCurrentLevel()
  if self.currentConfig ~= nil and self.currentConfig.level == currentLevel then
    return self.currentConfig
  end
  LocalController:instance():visitTable(TableName.LW_SEASON_PRE_VIRUS_STUDY, function(id, lineData)
    if self.data.id == id then
      self.currentConfig = self:ParseConfig(lineData)
      return true
    end
  end)
  return self.currentConfig
end

function LWSpreadResearchDataManager:GetNextLevelConfig()
  if not self:IsVail() then
    return nil
  end
  if self:IsMax() then
    return nil
  end
  local nextLevel = self:GetCurrentLevel() + 1
  if self.nextConfig ~= nil and self.nextConfig.level == nextLevel then
    return self.nextConfig
  end
  LocalController:instance():visitTable(TableName.LW_SEASON_PRE_VIRUS_STUDY, function(id, lineData)
    local level = tonumber(lineData:getValue("level") or 0)
    if level == nextLevel then
      self.nextConfig = self:ParseConfig(lineData)
      return true
    end
  end)
  return self.nextConfig
end

function LWSpreadResearchDataManager:GetLastLevelConfig()
  local lastConfig
  if not self:IsVail() then
    return lastConfig
  end
  local lastLevel = self:GetCurrentLevel() - 1
  if lastLevel < 0 then
    return lastConfig
  end
  LocalController:instance():visitTable(TableName.LW_SEASON_PRE_VIRUS_STUDY, function(id, lineData)
    local level = tonumber(lineData:getValue("level") or 0)
    if level == lastLevel then
      lastConfig = self:ParseConfig(lineData)
      return true
    end
  end)
  return lastConfig
end

function LWSpreadResearchDataManager:GetMaxLevel()
  if self.maxLevel ~= nil then
    return self.maxLevel
  end
  if self.maxLevel == nil then
    self.maxLevel = 1
    LocalController:instance():visitTable(TableName.LW_SEASON_PRE_VIRUS_STUDY, function(id, lineData)
      local eachLevel = tonumber(lineData:getValue("level") or 0)
      if eachLevel > self.maxLevel then
        self.maxLevel = eachLevel
      end
    end)
  end
  return self.maxLevel or 1
end

function LWSpreadResearchDataManager:IsMax()
  if not self:IsVail() then
    return false
  end
  return self:GetCurrentLevel() >= self:GetMaxLevel()
end

return LWSpreadResearchDataManager
