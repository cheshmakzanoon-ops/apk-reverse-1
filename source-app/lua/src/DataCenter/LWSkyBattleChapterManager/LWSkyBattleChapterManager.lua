local LWSkyBattleChapterManager = BaseClass("LWSkyBattleChapterManager", CEventable)
local Localization = CS.GameEntry.Localization

function LWSkyBattleChapterManager:__init()
  self.currStageId = nil
  self.nextStageId = nil
  self.doneStageIds = {}
  self.chapterCfgs = {}
  self.chapterCfg = nil
  self.chapterReward = {}
  self.lastPlayChapterCfgId = nil
  self.chapterInited = false
  self.skipIds = {}
  self.failCount = {}
  self:RegisterEvent(EventId.SkyBattleWin, self.OnSkyBattleWin)
  self:RegisterEvent(EventId.GF_enter_city, self.OnEnterCity)
end

function LWSkyBattleChapterManager:__delete()
  self.currStageId = nil
  self.nextStageId = nil
  self.doneStageIds = nil
  self.chapterCfgs = nil
  self.chapterCfg = nil
  self.chapterIdToIndex = nil
  self.chapterRewardAlreadyGet = nil
  self.lastPlayChapterCfgId = nil
  self.autoOpenMapUIWhenBackToCity = nil
  self.skipIds = nil
  self.failCount = nil
  self.chapterInited = false
  self.reward = nil
  self.rewardStageId = nil
  self.stageRewardShow = nil
  self.stageStarConditions = nil
  self.startTime = nil
  self.endTime = nil
end

function LWSkyBattleChapterManager:Startup()
end

function LWSkyBattleChapterManager:InitMsg(msg)
  if msg.skyBattle then
    self.startTime = msg.skyBattle.st
    self.endTime = msg.skyBattle.et
  end
end

local function __FindNextStageId(self, fillDoneStageIds)
  self.nextStageId = nil
  local hitStageId = false
  for _, chapterCfg in ipairs(self.chapterCfgs) do
    if self.nextStageId ~= nil then
      break
    end
    for _, stageId in ipairs(chapterCfg.stageIds) do
      if hitStageId then
        self.nextStageId = stageId
        self.chapterCfg = chapterCfg
        break
      else
        if fillDoneStageIds then
          self.doneStageIds[stageId] = true
        end
        if stageId == self.currStageId then
          self.chapterCfg = chapterCfg
          hitStageId = true
        end
      end
    end
  end
  if not hitStageId and self.nextStageId == nil then
    self.chapterCfg = self.chapterCfgs[1]
    self.nextStageId = self.chapterCfg.stageIds[1]
    if fillDoneStageIds then
      self.doneStageIds = {}
    end
  end
end

function LWSkyBattleChapterManager:ChapterInited()
  return self.chapterInited
end

function LWSkyBattleChapterManager:InitChapterData(msg)
  if self.chapterInited then
    return
  end
  if not msg then
    return
  end
  self.chapterInited = true
  self.chapterReward = {}
  self.skipIds = {}
  if msg.stageId then
    self.currStageId = msg.stageId
  end
  local chapterInfos = msg.chapterInfo
  self.chapterCfgs = {}
  local chapterTbl = LocalController:instance():getTable(TableName.LW_SKY_BATTLE_CHAPTER)
  for chapterId, _ in pairs(chapterTbl.data) do
    local stageIds = LocalController:instance():getValue(TableName.LW_SKY_BATTLE_CHAPTER, chapterId, "stages")
    local nodePosArr = {}
    local nodePosStrArr = LocalController:instance():getValue(TableName.LW_SKY_BATTLE_CHAPTER, chapterId, "nodePos")
    for _, nodePosStr in ipairs(nodePosStrArr) do
      local nodePos = string.split(nodePosStr, ",")
      table.insert(nodePosArr, Vector3(tonumber(nodePos[1]), tonumber(nodePos[2]), 0))
    end
    local nodeTipStyleArr = LocalController:instance():getValue(TableName.LW_SKY_BATTLE_CHAPTER, chapterId, "nodeTipStyle")
    local sign_up_day = LocalController:instance():getValue(TableName.LW_SKY_BATTLE_CHAPTER, chapterId, "sign_up_day")
    local main_building_level = LocalController:instance():getValue(TableName.LW_SKY_BATTLE_CHAPTER, chapterId, "main_building_level")
    local chapterExtraFromMsg
    if chapterInfos then
      for index, chapterInfo in ipairs(chapterInfos) do
        if chapterInfo.chapter == chapterId then
          chapterExtraFromMsg = chapterInfo
          break
        end
      end
    end
    local chapterRewardedIndex = chapterExtraFromMsg and chapterExtraFromMsg.rewardedTarget or nil
    local chapterBox = LocalController:instance():getValue(TableName.LW_SKY_BATTLE_CHAPTER, chapterId, "chapter_box")
    local chapterBoxDatas = {}
    if not string.IsNullOrEmpty(chapterBox) then
      local chapterBoxStrs = string.split(chapterBox, ";")
      for i, boxStr in ipairs(chapterBoxStrs) do
        local boxDatas = string.split(boxStr, "|")
        if boxDatas and boxDatas[1] and boxDatas[2] then
          local completeNum = tonumber(boxDatas[1])
          local boxReward = tonumber(boxDatas[2])
          local got = chapterRewardedIndex and table.indexof(chapterRewardedIndex, completeNum) and true or false
          local boxData = {
            TargetCompleteNum = completeNum,
            RewardId = boxReward,
            Got = got
          }
          table.insert(chapterBoxDatas, boxData)
        end
      end
    end
    local chapterBgImg = LocalController:instance():getValue(TableName.LW_SKY_BATTLE_CHAPTER, chapterId, "bgImg")
    table.insert(self.chapterCfgs, {
      id = chapterId,
      stageIds = stageIds,
      nodePosArr = nodePosArr,
      nodeTipStyleArr = nodeTipStyleArr,
      sign_up_day = sign_up_day,
      main_building_level = main_building_level,
      boxDatas = {},
      boxDatas = chapterBoxDatas,
      stageExtraInfos = chapterExtraFromMsg and chapterExtraFromMsg.stageInfo or {},
      chapterBgImg = chapterBgImg
    })
  end
  table.sort(self.chapterCfgs, function(a, b)
    return a.id < b.id
  end)
  self.chapterIdToIndex = {}
  for index, chapterCfgData in ipairs(self.chapterCfgs) do
    if chapterCfgData then
      self.chapterIdToIndex[chapterCfgData.id] = index
    end
  end
  if not self.chapterCfg and #self.chapterCfgs > 0 then
    self.chapterCfg = self.chapterCfgs[1]
  end
  __FindNextStageId(self, true)
  EventManager:GetInstance():Broadcast(EventId.SkyBattleChapterMsgInit)
end

function LWSkyBattleChapterManager:UpdateStageStar(stageStarData)
  if not self.chapterInited then
    return
  end
  if not stageStarData then
    return
  end
  for i, chapterCfg in ipairs(self.chapterCfgs) do
    local alreadyHasStarData = false
    for i, stageExtraInfo in ipairs(chapterCfg.stageExtraInfos) do
      if stageExtraInfo.stageId == stageStarData.id then
        if stageStarData.star > stageExtraInfo.star then
          stageExtraInfo.star = stageStarData.star
        end
        alreadyHasStarData = true
        EventManager:GetInstance():Broadcast(EventId.SkyBattleChapterRefresh, chapterCfg.id)
        break
      end
    end
    if not alreadyHasStarData and table.indexof(chapterCfg.stageIds, stageStarData.id) then
      table.insert(chapterCfg.stageExtraInfos, {
        star = stageStarData.star,
        stageId = stageStarData.id
      })
      EventManager:GetInstance():Broadcast(EventId.SkyBattleChapterRefresh, chapterCfg.id)
    end
  end
end

function LWSkyBattleChapterManager:OnEnterGame()
end

function LWSkyBattleChapterManager:EnterChapterStage(chapterId, stageId)
  if not chapterId then
    return
  end
  if not stageId then
    return
  end
  local param = {}
  param.type = PVEType.SkyBattle
  param.levelId = tonumber(stageId)
  param.fromChapter = true
  param.growthMode = false
  DataCenter.LWBattleManager:Enter(param)
  self.autoOpenMapUIWhenBackToCity = true
  self:SetCurPlayChapterId(chapterId)
end

function LWSkyBattleChapterManager:FindNextChapterStage(stageId)
  if not self.lastPlayChapterCfgId then
    return false
  end
  local lastPlayChapterCfg = self:GetChapterCfgData(self.lastPlayChapterCfgId)
  if not lastPlayChapterCfg then
    return false
  end
  local chapterStageIds = lastPlayChapterCfg.stageIds
  local curStageIndex = table.indexof(chapterStageIds, stageId)
  if not curStageIndex then
    return false
  end
  if curStageIndex >= #chapterStageIds then
    local index = table.indexof(self.chapterCfgs, lastPlayChapterCfg)
    if not index then
      return false
    end
    index = index + 1
    local nextChapterCfg = self.chapterCfgs[index]
    if not nextChapterCfg then
      return false
    end
    return true, nextChapterCfg.id, nextChapterCfg.stageIds[1]
  else
    return true, lastPlayChapterCfg.id, chapterStageIds[curStageIndex + 1]
  end
end

function LWSkyBattleChapterManager:CheckChapterStageMatchEnterCondition(chapterId, stageId, battleWin)
  if not self:IsOpen() then
    UIUtil.ShowTipsId(Localization:GetString("undo_system_toast_failed_desc003"))
    return false
  end
  local chapterCfgData = self:GetChapterCfgData(chapterId)
  if not chapterCfgData then
    return false
  end
  local sign_up_day = chapterCfgData.sign_up_day
  local main_building_level = chapterCfgData.main_building_level
  local regTime = LuaEntry.Player.openServerTime
  local regZero = regTime - (regTime + UITimeManager:GetInstance().changeDeltaTime) % 86400000
  local now = UITimeManager:GetInstance():GetServerTime()
  local regDiff = now - regZero
  local regDay = regDiff / 86400000 + 1
  if sign_up_day > regDay then
    local remain = Mathf.Floor(sign_up_day - regDay)
    local diff = 86400000 - (now + UITimeManager:GetInstance().changeDeltaTime) % 86400000 + remain * 86400000
    local time = UITimeManager:GetInstance():MilliSecondToFmtStringSpecial(diff)
    local tipMsg = Localization:GetString("plane_chapter_unlock_desc_01", time)
    UIUtil.ShowMessage(tipMsg, 1, nil, 801037)
    return false
  end
  local curLevel = DataCenter.BuildManager.MainLv
  if main_building_level > curLevel then
    local buildingNameKey = LocalController:instance():getValue(LuaEntry.Player:GetABTestTableName(TableName.Building), BuildingTypes.FUN_BUILD_MAIN, "name")
    local tipMsg = Localization:GetString(800371, Localization:GetString(buildingNameKey), tostring(main_building_level))
    UIUtil.ShowMessage(tipMsg, 2, 801037, 393010, function()
      GoToUtil.CloseAllWindows()
      if battleWin then
        DataCenter.LWBattleManager:Exit(nil, "win")
      end
      GoToUtil.GotoCityByBuildId(BuildingTypes.FUN_BUILD_MAIN, WorldTileBtnType.City_Upgrade)
    end)
    return false
  end
  return true
end

function LWSkyBattleChapterManager:CacheReward(stageId, reward)
  self.reward = reward
  self.rewardStageId = stageId
end

function LWSkyBattleChapterManager:SetCurPlayChapterId(chapterId)
  self.lastPlayChapterCfgId = chapterId
end

function LWSkyBattleChapterManager:GetCurPlayChapterId()
  return self.lastPlayChapterCfgId
end

function LWSkyBattleChapterManager:IsAllDone()
  return self.nextStageId == nil
end

function LWSkyBattleChapterManager:IsOpen()
  if self.startTime and self.endTime then
    local curTime = UITimeManager:GetInstance():GetServerTime()
    return curTime >= self.startTime and curTime <= self.endTime
  end
  return false
end

function LWSkyBattleChapterManager:GetEndTime()
  if not self:IsOpen() then
    return -1
  end
  return self.endTime or 0
end

function LWSkyBattleChapterManager:UpdateBoxRewardData(newRewardGetMsg)
  if newRewardGetMsg.chapter and newRewardGetMsg.rewardedTarget then
    local chapterIndex = self.chapterIdToIndex[newRewardGetMsg.chapter]
    local chapter = self.chapterCfgs[chapterIndex]
    if chapter then
      local boxDatas = chapter.boxDatas
      for i, boxData in ipairs(boxDatas) do
        local got = table.indexof(newRewardGetMsg.rewardedTarget, boxData.TargetCompleteNum) and true or false
        if not boxData.Got and got then
          boxData.Got = got
        end
      end
    end
    EventManager:GetInstance():Broadcast(EventId.SkyBattleChapterRewardBoxUpdate, newRewardGetMsg.chapter)
  end
end

function LWSkyBattleChapterManager:OnSkyBattleWin(stageId)
  local isNextStageId = self.nextStageId and self.nextStageId == stageId
  if not isNextStageId then
    return
  end
  self.doneStageIds[stageId] = true
  if isNextStageId then
    self.currStageId = stageId
    __FindNextStageId(self, false)
  end
end

function LWSkyBattleChapterManager:GetStageBelongsChapterCfgData(targetStageId)
  for _, chapterCfg in ipairs(self.chapterCfgs) do
    for _, stageId in ipairs(chapterCfg.stageIds) do
      if stageId == targetStageId then
        return chapterCfg
      end
    end
  end
  return nil
end

function LWSkyBattleChapterManager:GetChapterCfgData(chapterId)
  local chapterCfgIndex = self.chapterIdToIndex[chapterId]
  if not chapterCfgIndex then
    return nil
  end
  return self.chapterCfgs[chapterCfgIndex]
end

function LWSkyBattleChapterManager:OnEnterCity()
  if self:IsOpen() and self.autoOpenMapUIWhenBackToCity then
    self.autoOpenMapUIWhenBackToCity = nil
    DataCenter.LWBattleManager:SetBattleExitStartTime(BattleExitTimeLogType.SkyBattle)
    UIManager:GetInstance():OpenWindow(UIWindowNames.LWStageSkyBattleChapter, {anim = true}, {growMode = false})
  end
end

function LWSkyBattleChapterManager:IsChapterFinsh(chapterCfg)
  local stageIds = chapterCfg.stageIds
  for i, stageId in ipairs(stageIds) do
    if not self.doneStageIds[stageId] then
      return false
    end
  end
  return true
end

function LWSkyBattleChapterManager:GetStageStarCondition(stageId)
  if not self.stageStarConditions then
    self.stageStarConditions = {}
  end
  if not self.stageStarConditions[stageId] then
    self.stageStarConditions[stageId] = {}
    local stageStarConditionStr = LocalController:instance():getValue(TableName.LW_Stage_SkyBattle, stageId, "star_condition")
    if not string.IsNullOrEmpty(stageStarConditionStr) then
      local conditionStrs = string.split(stageStarConditionStr, "|")
      for i, conditionStr in ipairs(conditionStrs) do
        local conditionParams = string.split(conditionStr, ",")
        table.insert(self.stageStarConditions[stageId], {
          type = conditionParams[1] and tonumber(conditionParams[1]) or 0,
          value = conditionParams[2] or 0
        })
      end
    end
  end
  return self.stageStarConditions[stageId]
end

function LWSkyBattleChapterManager:GetConditionLocalKey(conditionType, conditionValue)
  if conditionType == BattleStarCondition.Success then
    return Localization:GetString("plane_chapter_detail_05")
  elseif conditionType == BattleStarCondition.HPPercent then
    return Localization:GetString("plane_chapter_detail_07", math.ceil(tonumber(conditionValue) * 0.01))
  elseif conditionType == BattleStarCondition.StageSuccessTime then
    return Localization:GetString("plane_chapter_detail_06", conditionValue)
  elseif conditionType == BattleStarCondition.MemberNum then
    return Localization:GetString("plane_chapter_detail_12", conditionValue)
  else
    return ""
  end
end

return LWSkyBattleChapterManager
