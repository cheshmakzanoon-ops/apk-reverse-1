local AllyDuelScoreGachaManager = BaseClass("AllyDuelScoreGachaManager")
local AllyDuelScoreGachaProbabilityTemplate = require("DataCenter/AllianceCompete/AllyDuelScoreGacha/AllyDuelScoreGachaProbabilityTemplate")
local AllyDuelScoreGachaData = require("DataCenter/AllianceCompete/AllyDuelScoreGacha/AllyDuelScoreGachaData")
local AllyDuelScoreGachaInfoTemplate = require("DataCenter/AllianceCompete/AllyDuelScoreGacha/AllyDuelScoreGachaInfoTemplate")
local Localization = CS.GameEntry.Localization
AllyDuelScoreGachaManager.ItemType = {Decoration = 1, Goods = 2}

function AllyDuelScoreGachaManager:__init()
  self.allInfo = {}
  self.allConfigData = {}
  self.allProbability = {}
  self.serverUnlock = false
  self.gachaOnceCost = LuaEntry.DataConfig:TryGetNum("alliance_duel_league", "k6", 100)
  self.unlockScienceId = 90010200
end

function AllyDuelScoreGachaManager:__delete()
  self.allInfo = nil
  self.allConfigData = nil
  self.allProbability = nil
  self.gachaOnceCost = nil
  self.serverUnlock = nil
end

function AllyDuelScoreGachaManager:GetConfigInfo(configId)
  if self.allInfo[tonumber(configId)] == nil then
    local configData = self:GetConfigData(configId)
    if configData ~= nil and configData.data ~= nil and configData.data.configId ~= nil then
      local lineData = LocalController:instance():getLine(TableName.AD_Infinity_Box_Season, tonumber(configData.data.configId))
      if lineData ~= nil then
        self.allInfo[tonumber(configId)] = AllyDuelScoreGachaInfoTemplate.New()
        self.allInfo[tonumber(configId)]:InitData(lineData)
      end
    end
  end
  return self.allInfo[tonumber(configId)]
end

function AllyDuelScoreGachaManager:GetAllProbabilityTemplate(configId)
  local function InitTemplates()
    self.allProbability[tonumber(configId)] = {}
    
    local configInfo = self:GetConfigInfo(configId)
    if configInfo ~= nil then
      LocalController:instance():visitTable(TableName.AD_Infinity_Box_Reward, function(id, lineData)
        if lineData then
          local groupId = tonumber(lineData:getValue("group_id")) or 0
          if 0 < groupId and configInfo ~= nil and configInfo.groupId == tonumber(groupId) then
            local template = AllyDuelScoreGachaProbabilityTemplate.New()
            template:InitData(lineData)
            table.insert(self.allProbability[tonumber(configId)], template)
          end
        end
      end)
    end
  end
  
  local res = {}
  if self.allProbability[tonumber(configId)] == nil then
    InitTemplates()
  end
  res = self.allProbability[tonumber(configId)]
  return res
end

function AllyDuelScoreGachaManager:GetItemDataByItemId(configId, itemId)
  local configData = self:GetConfigData(configId)
  if configData ~= nil then
    return configData:GetItemDataByItemId(itemId)
  end
  return nil
end

function AllyDuelScoreGachaManager:GetConfigData(configId)
  if self.allConfigData ~= nil and self.allConfigData[tostring(configId)] ~= nil then
    return self.allConfigData[tostring(configId)]
  end
end

function AllyDuelScoreGachaManager:OnReceiveConfigData(message)
  if not message then
    return
  end
  local configId = message.configId or ""
  configId = tostring(configId)
  if not string.IsNullOrEmpty(configId) then
    self.serverUnlock = true
    self:UpdateConfigData(configId, message)
    self.curUseConfigId = configId
  end
  EventManager:GetInstance():Broadcast(EventId.AllyDuelScoreGachaGotData, message.configId)
end

function AllyDuelScoreGachaManager:UpdateConfigData(configId, data)
  local configIdStr = tostring(configId)
  if self.allConfigData == nil then
    self.allConfigData = {}
  end
  if self.allConfigData[configIdStr] == nil then
    local configData = AllyDuelScoreGachaData.New()
    configData:InitData(data, configIdStr)
    self.allConfigData[configIdStr] = configData
  else
    self.allConfigData[configIdStr]:InitData(data, configIdStr)
  end
end

function AllyDuelScoreGachaManager:IsSkipGachaAnim()
  local key = "allyduel_score_gacha_skip_gacha_anim_"
  return CS.GameEntry.Setting:GetBool(key .. LuaEntry.Player.uid, true)
end

function AllyDuelScoreGachaManager:SetIsSkipGachaAnim(isSkip)
  local key = "allyduel_score_gacha_skip_gacha_anim_"
  if isSkip then
    CS.GameEntry.Setting:SetBool(key .. LuaEntry.Player.uid, true)
  else
    CS.GameEntry.Setting:SetBool(key .. LuaEntry.Player.uid, false)
  end
end

function AllyDuelScoreGachaManager:IsGachaCostItemEnough(configId, num)
  local configData = self:GetConfigData(configId)
  if configData == nil then
    return
  end
  local curHaveScore = configData.data.score
  return curHaveScore >= num * self.gachaOnceCost
end

function AllyDuelScoreGachaManager:SendGetGachaInfoMessage()
  local isGachaScienceOpen = DataCenter.AllyDuelScoreGachaManager:IsScienceOpen()
  if isGachaScienceOpen then
    SFSNetwork.SendMessage(MsgDefines.AlDuelLotteryGetInfo)
  end
end

function AllyDuelScoreGachaManager:OnGachaInfoMessageCallback(message)
  self:OnReceiveConfigData(message)
end

function AllyDuelScoreGachaManager:SendGachaMessage(configId, num)
  EventManager:GetInstance():Broadcast(EventId.AllyDuelScoreGachaStartGacha)
  SFSNetwork.SendMessage(MsgDefines.AlDuelLotteryLottery, {configId = configId, num = num})
  self.sendConfigId = configId
end

function AllyDuelScoreGachaManager:ShowGachaResult()
  if self.gachaResultParamCache == nil then
    return
  end
  local msgRewardList = {}
  for i, v in pairs(self.gachaResultParamCache.data.rewardArr) do
    for j, vv in pairs(v.reward) do
      table.insert(msgRewardList, vv)
    end
  end
  DataCenter.RewardManager:AddRewards(msgRewardList)
  DataCenter.RewardManager:ShowCommonReward({reward = msgRewardList})
  EventManager:GetInstance():Broadcast(EventId.AllyDuelScoreGachaEndGacha)
  self.gachaResultParamCache = nil
end

function AllyDuelScoreGachaManager:SetLastGachaResultCache(message)
  if message and message.rewardArr then
    local pos = -1
    for i, v in pairs(message.rewardArr) do
      pos = v.pos
    end
    if 0 < pos then
      local key = "allyduel_gacha_last_result_pos"
      CS.GameEntry.Setting:SetInt(key .. LuaEntry.Player.uid, pos)
    end
  end
end

function AllyDuelScoreGachaManager:GetLastGachaResultCache()
  local key = "allyduel_gacha_last_result_pos"
  return CS.GameEntry.Setting:GetInt(key .. LuaEntry.Player.uid, 1)
end

function AllyDuelScoreGachaManager:OnGachaMessageCallback(message)
  if message == nil or self.sendConfigId == nil then
    return
  end
  local configId = self.sendConfigId
  local preWishScore = 0
  local configData = self:GetConfigData(configId)
  if configData ~= nil then
    preWishScore = configData:GetCurWishScore()
  end
  self.gachaResultParamCache = {data = message}
  self:UpdateProtectNum(message.protectNum, configId)
  self:UpdateScore(message.score, configId)
  self:SetLastGachaResultCache(message)
  if self:IsSkipGachaAnim() then
    self:ShowGachaResult()
  else
    EventManager:GetInstance():Broadcast(EventId.AllyDuelScoreGachaShowGachaAnim, {
      num = table.count(message.rewardArr),
      data = message,
      configId = configId
    })
  end
end

function AllyDuelScoreGachaManager:SendClaimWishMessage(configId)
  if self._waitingClaimMessageBack then
    return
  end
  self.claimConfigId = configId
  SFSNetwork.SendMessage(MsgDefines.AlDuelLotteryGetProtectReward, {configId = configId})
  self:SetWaitingClaimMsgFlag(true)
end

function AllyDuelScoreGachaManager:SetWaitingClaimMsgFlag(flag)
  self._waitingClaimMessageBack = flag
end

function AllyDuelScoreGachaManager:OnClaimWishMessageCallback(message)
  local configId = self.claimConfigId
  if message == nil or configId == nil then
    return
  end
  self:SetWaitingClaimMsgFlag(false)
  DataCenter.RewardManager:AddRewardsAndRes(message)
  DataCenter.RewardManager:ShowCommonReward(message)
  self:UpdateProtectNum(message.protectNum, configId)
  EventManager:GetInstance():Broadcast(EventId.AllyDuelScoreGachaWishClaim)
end

function AllyDuelScoreGachaManager:OnPushScoreMessageCallback(message)
  self:UpdateScore(message.score)
end

function AllyDuelScoreGachaManager:GetShowResultDelayTime(evtData)
  if evtData == nil or evtData.num == nil or evtData.data == nil then
    return -1
  end
  if table.IsNullOrEmpty(evtData.data.rewardArr) then
    return -1
  end
  return evtData.num == 1 and 0.5 or 1
end

function AllyDuelScoreGachaManager:UpdateProtectNum(protectNum, configId)
  if self.allConfigData ~= nil and self.allConfigData[tostring(configId)] ~= nil then
    self.allConfigData[tostring(configId)].data.protect.protectNum = protectNum
  end
end

function AllyDuelScoreGachaManager:UpdateScore(score, configId)
  if self.allConfigData ~= nil then
    local id = configId or self.curUseConfigId
    local configData = self.allConfigData[tostring(id)]
    if configData ~= nil then
      configData.data.score = score
    end
    EventManager:GetInstance():Broadcast(EventId.AllyDuelScoreGachaUpdateScore)
  end
end

function AllyDuelScoreGachaManager:IsBigReward()
  return false
end

function AllyDuelScoreGachaManager:IsUnlock()
  return self.serverUnlock and LuaEntry.Effect:GetGameEffect(EffectDefine.ALCOMPETE_SCORE_GACHA_UNLOCK) > 0
end

function AllyDuelScoreGachaManager:GetTotalProbability(configId)
  local probabilityTemplates = self:GetAllProbabilityTemplate(configId)
  local res = 0
  for i, v in pairs(probabilityTemplates) do
    if v.pos ~= -1 then
      res = res + v.showPara
    end
  end
  return res
end

function AllyDuelScoreGachaManager:GetTotalRedDotNum()
  local ret = 0
  local configData = self:GetConfigData(self.curUseConfigId)
  if configData then
    local curScore = configData:GetCurWishScore()
    local maxScore = configData:GetPity()
    local wishRedDotNum = 0 < maxScore and math.floor(curScore / maxScore) or 0
    ret = ret + wishRedDotNum
    local haveScore = configData.data.score
    local gachaOnceCost = self.gachaOnceCost
    local gachaRedDotNum = 0 < gachaOnceCost and math.floor(haveScore / gachaOnceCost) or 0
    ret = ret + gachaRedDotNum
  end
  return ret
end

function AllyDuelScoreGachaManager:IsScienceOpen()
  local template = DataCenter.ScienceTemplateManager:GetScienceTemplateById(self.unlockScienceId)
  if template then
    local gachaSwitch = LuaEntry.DataConfig:CheckSwitch("alliance_duel_zhuanpan")
    return template:IsTimeConditionValid() and gachaSwitch
  end
  return false
end

return AllyDuelScoreGachaManager
