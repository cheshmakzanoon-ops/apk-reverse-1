local LWTowerUpStageManager = BaseClass("LWTowerUpStageManager")

function LWTowerUpStageManager:__init()
  self.curStageId = 0
end

function LWTowerUpStageManager:__delete()
end

function LWTowerUpStageManager:Startup()
end

function LWTowerUpStageManager:InitData(msg)
  self.curStageId = msg.towerUpStageInfo and msg.towerUpStageInfo.stageId and tonumber(msg.towerUpStageInfo.stageId) or 0
  if msg.towerUpStageInfo then
    self:UpdateFirstRewardedDict(msg.towerUpStageInfo.firstRewardedArr)
  end
end

function LWTowerUpStageManager:UpdateData(msg)
  if msg.isWin then
    self.curStageId = msg.id and tonumber(msg.id) or 0
  end
end

function LWTowerUpStageManager:GetCurStageId()
  return self.curStageId
end

function LWTowerUpStageManager:OnStageWin()
end

function LWTowerUpStageManager:OnStageLose()
end

function LWTowerUpStageManager:GetUnGetRewardNum(checkId)
  local num = 0
  local firstRewardStage = DataCenter.TowerUpTemplateManager:GetFirstRewardStage()
  for i, v in ipairs(firstRewardStage) do
    if checkId < v then
      break
    end
    if self.firstRewardedDict == nil or not self.firstRewardedDict[v] then
      num = num + 1
    end
  end
  return num
end

function LWTowerUpStageManager:UpdateFirstRewardedDict(firstRewardedArr)
  if firstRewardedArr then
    self.firstRewardedDict = {}
    for i, v in ipairs(firstRewardedArr) do
      self.firstRewardedDict[v] = true
    end
  end
end

function LWTowerUpStageManager:CanGetFirstReward(checkId)
  local canGet = false
  local firstRewardStage = DataCenter.TowerUpTemplateManager:GetFirstRewardStage()
  if self.firstRewardedDict == nil or self.firstRewardedDict[checkId] == nil then
    for i, v in ipairs(firstRewardStage) do
      if v == checkId then
        canGet = true
        break
      end
    end
  end
  return canGet
end

function LWTowerUpStageManager:GetNearlyFirstReward()
  local rewardCfg
  local nowStageId = self:GetCurStageId()
  local firstRewardStage = DataCenter.TowerUpTemplateManager:GetFirstRewardStage()
  for i, v in ipairs(firstRewardStage) do
    if nowStageId < tonumber(v) then
      rewardCfg = DataCenter.TowerUpTemplateManager:GetTowerUpUnlockTemplate(v)
      break
    end
  end
  return rewardCfg
end

function LWTowerUpStageManager:GetStageFirstRewardType(checkId)
  local type = JeepStageFirstRewardType.NotReached
  local curStageId = self:GetCurStageId()
  if checkId <= curStageId then
    if self.firstRewardedDict and self.firstRewardedDict[checkId] then
      type = JeepStageFirstRewardType.Claimed
    else
      type = JeepStageFirstRewardType.CanClaim
    end
  else
    type = JeepStageFirstRewardType.NotReached
  end
  return type
end

function LWTowerUpStageManager:GetLastFirstReward()
  local firstRewardStage = DataCenter.TowerUpTemplateManager:GetFirstRewardStage()
  local rewardCfg
  for i = #firstRewardStage, 1, -1 do
    rewardCfg = DataCenter.TowerUpTemplateManager:GetTowerUpUnlockTemplate(firstRewardStage[i])
    if rewardCfg then
      break
    end
  end
  return rewardCfg
end

function LWTowerUpStageManager:TowerUpStageABIsOpen()
  if LuaEntry.Player.abTest == ABTestType.B then
    local server = LuaEntry.Player:GetSourceServerId()
    local serverArray = ""
    if CS.CommonUtils.IsDebug() then
      serverArray = LuaEntry.DataConfig:TryGetStr("towerup_AB", "k1")
    else
      serverArray = LuaEntry.DataConfig:TryGetStr("towerup_AB", "k2")
    end
    if not string.IsNullOrEmpty(serverArray) then
      local array = string.split(serverArray, "|")
      for _, arr in ipairs(array) do
        local list = string.split(arr, "-")
        if #list == 2 then
          local startServer = tonumber(list[1])
          local endServer = tonumber(list[2])
          if startServer <= endServer and server >= startServer and server <= endServer then
            return true
          end
        elseif #list == 1 then
          local se = tonumber(list[1]) or 0
          if 0 < se and se == server then
            return true
          end
        end
      end
    end
  end
  return false
end

return LWTowerUpStageManager
