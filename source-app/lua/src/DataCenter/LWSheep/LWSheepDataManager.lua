local LWSheepDataManager = BaseClass("LWSheepDataManager")
local LWSheepUtil = require("DataCenter.LWSheep.LWSheepUtil")

function LWSheepDataManager:__init()
  self.sheepData = nil
  self.rankData = {
    [1] = {},
    [2] = {}
  }
  self.challengeMaxLevel = 1
  self.reward = {}
end

function LWSheepDataManager:__delete()
  self.sheepData = nil
  self.rankData = nil
  self.challengeMaxLevel = nil
  self.reward = nil
end

function LWSheepDataManager:UpdateData(data)
  self.activityId = toInt(data.id)
end

function LWSheepDataManager:GetActivityData()
  return DataCenter.ActivityListDataManager:GetActivityDataById(self.activityId)
end

function LWSheepDataManager:UpdateSheepInfo(t)
  self.sheepData = t
  EventManager:GetInstance():Broadcast(EventId.SeasonGetSheepInfo)
end

function LWSheepDataManager:UpdateGameInfo(t)
  self.sheepData = t
  EventManager:GetInstance():Broadcast(EventId.SeasonGetSheepGameInfo)
end

function LWSheepDataManager:UpdateMoveSheep(t)
  if t.rewardsInfo ~= nil and next(t.rewardsInfo) then
    t.rewardsInfo.level = self:GetCurrentLevel()
  end
  self.sheepData = t
  if t.rewardsInfo ~= nil and next(t.rewardsInfo) then
    local isPass = false
    if t.rewardsInfo.reward then
      isPass = true
      DataCenter.RewardManager:AddRewardsAndRes({
        reward = t.rewardsInfo.reward
      })
    end
    if t.rewardsInfo.perfectReward then
      isPass = true
      DataCenter.RewardManager:AddRewardsAndRes({
        reward = t.rewardsInfo.perfectReward
      })
    end
    EventManager:GetInstance():Broadcast(EventId.UpdateGold)
  end
  local reward = {
    reward = t.eliminateRewards
  }
  if t.eliminateRewards ~= nil and next(t.eliminateRewards) then
    DataCenter.RewardManager:AddRewardsAndRes(reward)
    EventManager:GetInstance():Broadcast(EventId.UpdateGold)
  end
  EventManager:GetInstance():Broadcast(EventId.SeasonSheepOp, {
    lastOptAction = t.lastOptAction,
    eliminate = t.eliminate,
    type = SheepGameOpType.Click,
    rewardsInfo = t.rewardsInfo,
    eliminateRewards = t.eliminateRewards,
    opPointId = t.opPointId
  })
end

function LWSheepDataManager:HandleSandWormFishingRewardList(msg, rewardType)
  self.reward[rewardType] = msg
  EventManager:GetInstance():Broadcast(EventId.SeasonSheepGetRankReward)
end

function LWSheepDataManager:Error()
  EventManager:GetInstance():Broadcast(EventId.SeasonSheepOp, {
    type = SheepGameOpType.Error
  })
end

function LWSheepDataManager:UpdateUseItem(t)
  local lastInfo = self.sheepData.lastOptAction
  self.sheepData = t
  local opTable = {
    type = t.opType
  }
  if t.opType == SheepGameOpType.Move then
    opTable.eliminate = t.eliminate
    opTable.cache = t.cache
    opTable.lastOptAction = t.lastOptAction
  elseif t.opType == SheepGameOpType.Back then
    opTable.lastOptAction = lastInfo
  elseif t.opType == SheepGameOpType.Refresh then
    opTable.sheepData = t
    opTable.lastOptAction = t.lastOptAction
  end
  EventManager:GetInstance():Broadcast(EventId.SeasonSheepOp, opTable)
end

function LWSheepDataManager:UpdateRank(t)
  local rankList = {}
  for k, v in pairs(t.rankArr) do
    local oneData = PlayerRankData.New()
    oneData:ParseData(v)
    oneData:SetRank(v.rank, t.opType)
    table.insert(rankList, oneData)
  end
  local parseData = {
    rankArr = rankList,
    owner = t.owner,
    opType = t.opType
  }
  self.rankData[t.opType] = parseData
  EventManager:GetInstance():Broadcast(EventId.SeasonSheepGetRankInfo, parseData)
end

function LWSheepDataManager:IsEnd()
  if not self:IsVail() then
    return true
  end
  local actData = self:GetActivityData()
  local curTime = UITimeManager:GetInstance():GetServerTime()
  return actData.endTime and curTime > actData.endTime
end

function LWSheepDataManager:IsVail()
  local actData = self:GetActivityData()
  if actData == nil then
    return false
  end
  if self.sheepData == nil then
    return false
  end
  return true
end

function LWSheepDataManager:GetRankData(type)
  if self.rankData == nil then
    return nil
  end
  return self.rankData[type] or nil
end

function LWSheepDataManager:GetCurrentLevel()
  if not self:IsVail() then
    return 0
  end
  return self.sheepData.passMaxBlock + 1
end

function LWSheepDataManager:GetChallengeMaxLevel()
  if not self:IsVail() then
    return 0
  end
  local actData = self:GetActivityData()
  local serverTime = UITimeManager:GetInstance():GetServerSeconds()
  local opLevel = math.ceil((serverTime - self.sheepData.actBeginTime) / 86400)
  if opLevel ~= self.challengeMaxLevel then
    self.challengeMaxLevel = opLevel * toInt(actData.para_2)
  end
  return self.challengeMaxLevel
end

function LWSheepDataManager:IsDayPass()
  return self:GetCurrentLevel() > self:GetChallengeMaxLevel()
end

function LWSheepDataManager:IsPass()
  if not self:IsVail() then
    return false
  end
  local actData = self:GetActivityData()
  return self.sheepData.passMaxBlock >= toInt(actData.para_8)
end

function LWSheepDataManager:CanChallenge()
  if not self:IsVail() then
    return false
  end
  if self:IsPass() then
    return false
  end
  return self:GetCurrentLevel() <= self:GetChallengeMaxLevel()
end

function LWSheepDataManager:CheckNeedSendStartGameMsgOrOnlyCheck(isSend)
  if self.sheepData == nil then
    if isSend then
      SFSNetwork.SendMessage(MsgDefines.LWSheepStartGame)
    end
    return true
  end
  if not self:CheckHasGame() then
    if isSend then
      SFSNetwork.SendMessage(MsgDefines.LWSheepStartGame)
    end
    return true
  end
  if #self.sheepData.eliminate == 7 then
    if isSend then
      SFSNetwork.SendMessage(MsgDefines.LWSheepStartGame)
    end
    return true
  end
  return false
end

function LWSheepDataManager:CheckHasGame()
  if self.sheepData == nil then
    return false
  end
  local hasCache = next(self.sheepData.cache) or false
  local hasEliminate = next(self.sheepData.eliminate) or false
  local hasStack = next(self.sheepData.stack) or false
  return hasCache or hasEliminate or hasStack
end

function LWSheepDataManager:NotPlayGame()
  if self.sheepData == nil then
    return false
  end
  return not self:CheckHasGame() and self.sheepData.passMaxBlock == 0
end

function LWSheepDataManager:GetCurBlockId()
  if self:IsVail() then
    return string.IsNullOrEmpty(self.sheepData.blockId) and "10001" or self.sheepData.blockId
  end
end

function LWSheepDataManager:GetRankConfigId()
  if self:IsVail() then
    local actData = self:GetActivityData()
    return actData.rankRewardParam[1]
  end
end

function LWSheepDataManager:GetRewardList(rewardType)
  return self.reward[rewardType] or {}
end

function LWSheepDataManager:Description()
  local sb = StringBuilder.New()
  local sheepUIView = UIManager:GetInstance():GetWindow(UIWindowNames.LWUISheepGame)
  if self.sheepData == nil then
    sb:AppendLine("\230\151\160\230\149\176\230\141\174")
  elseif sheepUIView == nil then
    sb:AppendLine("\230\151\160\230\149\176\230\141\174")
  else
    sb:AppendLine("blockId" .. self.sheepData.blockId)
    local layoutPlan = GetTableData(TableName.SEASON_BLOCK_REMOVAL, self.sheepData.blockId, "layout_plan")
    sb:AppendLine("plan" .. layoutPlan)
    local game = sheepUIView.View.engine.game
    sb:AppendLine("====\230\156\141\229\138\161\229\153\168 eliminate")
    for _, serverInfo in ipairs(self.sheepData.eliminate) do
      local serverPosStr = serverInfo.sheepId:split("_")
      local serverX, serverY, serverZ = toInt(serverPosStr[1]), toInt(serverPosStr[2]), toInt(serverPosStr[3])
      sb:AppendLine(string.format("g:{%d} s:{%s}", LWSheepUtil.PosXYZToGridID(serverX, serverY, serverZ), serverInfo.sheepId))
    end
    sb:AppendLine("=====\229\174\162\230\136\183\231\171\175 removeList")
    for _, remove in ipairs(game.removeList) do
      sb:AppendLine(string.format("g:{%d} s:{%s}", remove.gridId, remove:GetPosToServer()))
    end
    sb:AppendLine("====\230\156\141\229\138\161\229\153\168 cache")
    for _, cacheInfo in pairs(self.sheepData.cache) do
      local serverPosStr = cacheInfo.sheepId:split("_")
      local serverX, serverY, serverZ = toInt(serverPosStr[1]), toInt(serverPosStr[2]), toInt(serverPosStr[3])
      local line = toInt(cacheInfo.line + 1)
      local pos = toInt(cacheInfo.pos)
      local tempId = LWSheepUtil.PosXYToTempID(line, pos)
      sb:AppendLine(string.format("g:{%d} s:{%s} t:{%d}", LWSheepUtil.PosXYZToGridID(serverX, serverY, serverZ), cacheInfo.sheepId, tempId))
    end
    sb:AppendLine("=====\229\174\162\230\136\183\231\171\175 temporaryList")
    for tempId, remove in ipairs(game.temporaryList) do
      sb:AppendLine(string.format("g:{%d} s:{%s} t:{%d}", remove.gridId, remove:GetPosToServer(), tempId))
    end
    sb:AppendLine("=====\229\174\162\230\136\183\231\171\175 show")
    for height, heightCards in pairs(game.showCards) do
      for _, card in pairs(heightCards) do
        local occDes = ""
        occDes = occDes .. card.gridId .. tostring(card.occGridList[card.gridId]) .. "-"
        occDes = occDes .. LWSheepUtil.PosXYZToGridID(card.pos.x + 1, card.pos.y, card.pos.z) .. tostring(card.occGridList[LWSheepUtil.PosXYZToGridID(card.pos.x + 1, card.pos.y, card.pos.z)]) .. "-"
        occDes = occDes .. LWSheepUtil.PosXYZToGridID(card.pos.x, card.pos.y + 1, card.pos.z) .. tostring(card.occGridList[LWSheepUtil.PosXYZToGridID(card.pos.x, card.pos.y + 1, card.pos.z)]) .. "-"
        occDes = occDes .. LWSheepUtil.PosXYZToGridID(card.pos.x + 1, card.pos.y + 1, card.pos.z) .. tostring(card.occGridList[LWSheepUtil.PosXYZToGridID(card.pos.x + 1, card.pos.y + 1, card.pos.z)]) .. "-"
        sb:AppendLine(string.format("g:{%d} s:{%s}|o:{%s}", card.gridId, card:GetPosToServer(), occDes))
      end
    end
  end
  return sb:ToString()
end

return LWSheepDataManager
