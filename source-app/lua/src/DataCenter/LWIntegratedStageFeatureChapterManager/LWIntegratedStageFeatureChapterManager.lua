local LWIntegratedStageFeatureChapterManager = BaseClass("LWIntegratedStageFeatureChapterManager", CEventable)
local Localization = CS.GameEntry.Localization
local DIFFICULTY = {
  NORMAL = 1,
  HARD = 2,
  NIGHTMARE = 3
}

function LWIntegratedStageFeatureChapterManager:__init()
  self.isOpenFlag = 0
  self.difficultyData = {}
  for _, diff in ipairs({
    DIFFICULTY.NORMAL,
    DIFFICULTY.HARD,
    DIFFICULTY.NIGHTMARE
  }) do
    self.difficultyData[diff] = {
      currStageId = nil,
      nextStageId = nil,
      doneStageIds = {},
      resetedStageIds = {},
      skipIds = {},
      failCount = {},
      chapterCfg = nil
    }
  end
  self.todayResetTimes = 0
  self.chapterCfgs = {
    [DIFFICULTY.NORMAL] = {},
    [DIFFICULTY.HARD] = {},
    [DIFFICULTY.NIGHTMARE] = {}
  }
  self.chapterSeqIdToIndex = {
    [DIFFICULTY.NORMAL] = {},
    [DIFFICULTY.HARD] = {},
    [DIFFICULTY.NIGHTMARE] = {}
  }
  self.stageIdToDiff = {}
  self.stageIdToChapterCfg = {}
  self.configIdToChapterCfg = {}
  self.lastPlayChapterCfgId = nil
  self.autoOpenMapUIWhenBackToCity = false
  self.targetResetDiff = nil
  self.targetResetChapterId = nil
  self:RegisterEvent(EventId.ParkourBattleWin, self.OnParkourBattleWin)
  self:RegisterEvent(EventId.GF_enter_city, self.OnEnterCity)
  self:RegisterEvent(EventId.StageFeatureIntegratedWinCheckUploadGameCenterData, self.JudgeIsEnoughUploadDataToGameCenter)
end

function LWIntegratedStageFeatureChapterManager:__delete()
  self.difficultyData = nil
  self.chapterCfgs = nil
  self.chapterSeqIdToIndex = nil
  self.stageIdToDiff = nil
  self.stageIdToChapterCfg = nil
  self.lastPlayChapterCfgId = nil
end

function LWIntegratedStageFeatureChapterManager:IsOpen()
  return self.isOpenFlag == 1
end

function LWIntegratedStageFeatureChapterManager:InitData(msg)
  self.isOpenFlag = msg.planeFeatureTag
  self.chapterCfgs = {
    [DIFFICULTY.NORMAL] = {},
    [DIFFICULTY.HARD] = {},
    [DIFFICULTY.NIGHTMARE] = {}
  }
  self.chapterSeqIdToIndex = {
    [DIFFICULTY.NORMAL] = {},
    [DIFFICULTY.HARD] = {},
    [DIFFICULTY.NIGHTMARE] = {}
  }
  self.configIdToChapterCfg = {}
  self.stageIdToChapterCfg = {}
  self.stageIdToDiff = {}
  if msg.planeFeatureCommon then
    self:_ParseDifficultyData(DIFFICULTY.NORMAL, msg.planeFeatureCommon)
  end
  if msg.planeFeatureHard then
    self:_ParseDifficultyData(DIFFICULTY.HARD, msg.planeFeatureHard)
  end
  if msg.planeFeatureMaster then
    self:_ParseDifficultyData(DIFFICULTY.NIGHTMARE, msg.planeFeatureMaster)
  end
  self.todayResetTimes = msg.planeFeatureReset or 0
  self:_LoadChapterConfigs()
  for diff, _ in pairs(self.difficultyData) do
    self:__FindNextStageId(diff, true)
  end
end

function LWIntegratedStageFeatureChapterManager:_ParseDifficultyData(diff, data)
  local diffData = self.difficultyData[diff]
  if not diffData then
    return
  end
  diffData.currStageId = data.stageId
  diffData.resetedStageIds = data.resetIds or {}
  diffData.skipIds = {}
  if data.skipIds then
    for _, v in ipairs(data.skipIds) do
      diffData.skipIds[v] = true
    end
  end
  diffData.doneStageIds = {}
end

function LWIntegratedStageFeatureChapterManager:_LoadChapterConfigs()
  local tableName = TableName.LW_Integrated_Stage_Feature
  local chapterTbl = LocalController:instance():getTable(tableName)
  if not chapterTbl then
    Logger.LogError("\233\133\141\232\161\168\228\184\141\229\173\152\229\156\168: " .. tableName)
    return
  end
  for rowId, _ in pairs(chapterTbl.data or {}) do
    local rank = LocalController:instance():getValue(tableName, rowId, "rank")
    if rank then
      local diff = tonumber(rank)
      if self.difficultyData[diff] then
        local chapterSeq = LocalController:instance():getValue(tableName, rowId, "chapter")
        if not chapterSeq then
          Logger.LogError(string.format("\230\149\180\229\144\136\231\137\136\233\133\141\232\161\168\231\188\186\229\176\145chapter\229\173\151\230\174\181, rowId=%s", tostring(rowId)))
          return
        end
        chapterSeq = tonumber(chapterSeq)
        local stageIds = LocalController:instance():getValue(tableName, rowId, "stages") or {}
        local nodePosArr = {}
        local nodePosStrArr = LocalController:instance():getValue(tableName, rowId, "nodePos") or {}
        for _, nodePosStr in ipairs(nodePosStrArr) do
          local nodePos = string.split(nodePosStr, ",")
          table.insert(nodePosArr, Vector3(tonumber(nodePos[1]), tonumber(nodePos[2]), 0))
        end
        local nodeTipStyleArr = LocalController:instance():getValue(tableName, rowId, "nodeTipStyle") or {}
        local sign_up_day = LocalController:instance():getValue(tableName, rowId, "sign_up_day") or 0
        local main_building_level = LocalController:instance():getValue(tableName, rowId, "main_building_level") or 0
        local unlock_pre_chapter = LocalController:instance():getValue(tableName, rowId, "unlock_pre_chapter") or 0
        local chapterCfg = {
          id = rowId,
          chapterSeqId = chapterSeq,
          diff = diff,
          stageIds = stageIds,
          nodePosArr = nodePosArr,
          nodeTipStyleArr = nodeTipStyleArr,
          sign_up_day = sign_up_day,
          main_building_level = main_building_level,
          unlock_pre_chapter = unlock_pre_chapter
        }
        table.insert(self.chapterCfgs[diff], chapterCfg)
        for _, stageId in ipairs(stageIds) do
          self.stageIdToDiff[stageId] = diff
          self.stageIdToChapterCfg[stageId] = chapterCfg
        end
        self.configIdToChapterCfg[rowId] = chapterCfg
      end
    end
  end
  for diff, list in pairs(self.chapterCfgs) do
    table.sort(list, function(a, b)
      return a.chapterSeqId < b.chapterSeqId
    end)
    for idx, cfg in ipairs(list) do
      self.chapterSeqIdToIndex[diff][cfg.chapterSeqId] = idx
    end
  end
end

function LWIntegratedStageFeatureChapterManager:__FindNextStageId(diff, fillDoneStageIds)
  local diffData = self.difficultyData[diff]
  local chapterList = self.chapterCfgs[diff]
  if not chapterList or #chapterList == 0 then
    return
  end
  diffData.nextStageId = nil
  local hitStageId = false
  for _, chapterCfg in ipairs(chapterList) do
    if diffData.nextStageId ~= nil then
      break
    end
    for _, stageId in ipairs(chapterCfg.stageIds) do
      if hitStageId then
        if not self:IsSkipStage(diff, stageId) then
          diffData.nextStageId = stageId
          diffData.chapterCfg = chapterCfg
          break
        end
      else
        if fillDoneStageIds and not self:IsSkipStage(diff, stageId) and diffData.currStageId and stageId <= diffData.currStageId then
          diffData.doneStageIds[stageId] = true
        end
        if stageId == diffData.currStageId then
          diffData.chapterCfg = chapterCfg
          hitStageId = true
        end
      end
    end
  end
  if not hitStageId and diffData.nextStageId == nil then
    diffData.chapterCfg = chapterList[1]
    diffData.nextStageId = diffData.chapterCfg.stageIds[1]
    if fillDoneStageIds then
      diffData.doneStageIds = {}
    end
  end
  if fillDoneStageIds then
    for _, resetedStageId in ipairs(diffData.resetedStageIds) do
      diffData.doneStageIds[resetedStageId] = false
    end
  end
end

function LWIntegratedStageFeatureChapterManager:IsChapterUnlocked(diff, seqId)
  local chapterCfg = self:GetChapterCfgBySeq(diff, seqId)
  if not chapterCfg then
    return false
  end
  if self:IsForceUnlock(diff, chapterCfg) then
    return true
  end
  local regTime = LuaEntry.Player.regTime
  local regZero = regTime - (regTime + UITimeManager:GetInstance().changeDeltaTime) % 86400000
  local now = UITimeManager:GetInstance():GetServerTime()
  local regDiff = now - regZero
  local regDay = regDiff / 86400000 + 1
  if regDay < chapterCfg.sign_up_day then
    return false
  end
  if chapterCfg.unlock_pre_chapter and chapterCfg.unlock_pre_chapter > 0 then
    local preChapterCfg = self.configIdToChapterCfg[chapterCfg.unlock_pre_chapter]
    if not preChapterCfg then
      Logger.LogError("\229\137\141\231\189\174\231\171\160\232\138\130\233\133\141\231\189\174\228\184\141\229\173\152\229\156\168\239\188\140\228\184\187\233\148\174\239\188\154" .. chapterCfg.unlock_pre_chapter)
      return false
    end
    if not self:IsChapterEverFinished(preChapterCfg.diff, preChapterCfg) then
      return false
    end
  end
  local curMainLv = DataCenter.BuildManager.MainLv
  if curMainLv < chapterCfg.main_building_level then
    return false
  end
  return true
end

function LWIntegratedStageFeatureChapterManager:IsForceUnlock(diff, chapterCfg)
  local lastStageId = chapterCfg.stageIds[#chapterCfg.stageIds]
  if self.difficultyData[diff].currStageId and lastStageId <= self.difficultyData[diff].currStageId then
    return true
  end
  return false
end

function LWIntegratedStageFeatureChapterManager:IsDifficultyUnlocked(diff)
  return self:IsChapterUnlocked(diff, 1)
end

function LWIntegratedStageFeatureChapterManager:GetChapterCfgData(configId)
  return self.configIdToChapterCfg[configId]
end

function LWIntegratedStageFeatureChapterManager:GetChapterCfgBySeq(diff, seqId)
  local idx = self.chapterSeqIdToIndex[diff] and self.chapterSeqIdToIndex[diff][seqId]
  if not idx then
    return nil
  end
  return self.chapterCfgs[diff][idx]
end

function LWIntegratedStageFeatureChapterManager:GetStageBelongsChapterCfgData(stageId)
  return self.stageIdToChapterCfg[stageId]
end

function LWIntegratedStageFeatureChapterManager:GetStageDiff(stageId)
  return self.stageIdToDiff[stageId]
end

function LWIntegratedStageFeatureChapterManager:IsStageReseted(diff, stageId)
  local diffData = self.difficultyData[diff]
  if not diffData then
    return false
  end
  return table.indexof(diffData.resetedStageIds, stageId)
end

function LWIntegratedStageFeatureChapterManager:IsSkipStage(diff, stageId)
  local diffData = self.difficultyData[diff]
  if not diffData then
    return false
  end
  return diffData.skipIds[stageId] == true
end

function LWIntegratedStageFeatureChapterManager:GetTodayResetTimes()
  return self.todayResetTimes
end

function LWIntegratedStageFeatureChapterManager:IsChapterFinsh(diff, chapterCfg)
  local diffData = self.difficultyData[diff]
  if not diffData or not chapterCfg then
    return false
  end
  for _, stageId in ipairs(chapterCfg.stageIds) do
    if not diffData.doneStageIds[stageId] then
      return false
    end
  end
  return true
end

function LWIntegratedStageFeatureChapterManager:IsChapterEverFinished(diff, chapterCfg)
  local diffData = self.difficultyData[diff]
  if not diffData or not chapterCfg then
    return false
  end
  local lastStageId = chapterCfg.stageIds[#chapterCfg.stageIds]
  return diffData.doneStageIds[lastStageId] == true or self:IsStageReseted(diff, lastStageId)
end

function LWIntegratedStageFeatureChapterManager:GetNextStageId(diff)
  local diffData = self.difficultyData[diff]
  return diffData and diffData.nextStageId
end

function LWIntegratedStageFeatureChapterManager:IsStageDone(diff, stageId)
  local diffData = self.difficultyData[diff]
  if not diffData then
    return false
  end
  return diffData.doneStageIds[stageId] == true
end

function LWIntegratedStageFeatureChapterManager:IsAllDoneByDiff(diff)
  local diffData = self.difficultyData[diff]
  if not diffData then
    return false
  end
  if diffData.nextStageId ~= nil then
    return false
  end
  if next(diffData.skipIds) then
    return false
  end
  return true
end

function LWIntegratedStageFeatureChapterManager:IsAllDone()
  for diff = 1, 3 do
    if not self:IsAllDoneByDiff(diff) then
      return false
    end
  end
  return true
end

function LWIntegratedStageFeatureChapterManager:GetFailCount(diff, stageId)
  local diffData = self.difficultyData[diff]
  if not diffData then
    return 0
  end
  return diffData.failCount[stageId] or 0
end

function LWIntegratedStageFeatureChapterManager:GetResetedChapterNextStageId(diff, resetedChapterCfg)
  if not resetedChapterCfg then
    return -1
  end
  local diffData = self.difficultyData[diff]
  if not diffData then
    return -1
  end
  for _, stageId in ipairs(resetedChapterCfg.stageIds) do
    if self:IsStageReseted(diff, stageId) then
      return stageId
    end
  end
  return -1
end

function LWIntegratedStageFeatureChapterManager:GetCurPlayChapterId()
  return self.lastPlayChapterCfgId
end

function LWIntegratedStageFeatureChapterManager:SetCurPlayChapterId(chapterId)
  self.lastPlayChapterCfgId = chapterId
end

function LWIntegratedStageFeatureChapterManager:IsFirstStageOfFirstChapter(stageId)
  local chapterCfg = self:GetStageBelongsChapterCfgData(stageId)
  if not chapterCfg then
    return false
  end
  local diff = chapterCfg.diff
  local chapterList = self.chapterCfgs[diff]
  if not chapterList then
    return false
  end
  local currMaxStageId = self.difficultyData[diff] and self.difficultyData[diff].currStageId or 0
  for _, cfg in ipairs(chapterList) do
    if not self:IsChapterUnlocked(diff, cfg.chapterSeqId) and cfg.stageIds then
      for _, id in ipairs(cfg.stageIds) do
        if id > currMaxStageId then
          return stageId == id
        end
      end
    end
  end
  return false
end

function LWIntegratedStageFeatureChapterManager:AddFailStage(diff, stageId)
  local diffData = self.difficultyData[diff]
  if not diffData or not stageId then
    return
  end
  if diffData.doneStageIds[stageId] then
    self:RemoveSkipStage(diff, stageId)
    return
  end
  if self:IsStageReseted(diff, stageId) then
    self:RemoveSkipStage(diff, stageId)
    return
  end
  local count = diffData.failCount[stageId] or 0
  diffData.failCount[stageId] = count + 1
end

function LWIntegratedStageFeatureChapterManager:RemoveSkipStage(diff, stageId)
  local diffData = self.difficultyData[diff]
  if not diffData then
    return
  end
  diffData.skipIds[stageId] = nil
  diffData.failCount[stageId] = nil
end

function LWIntegratedStageFeatureChapterManager:ResetTargetChapterStages(diff, chapterId)
  self.targetResetDiff = diff
  self.targetResetChapterId = chapterId
  self:SendResetStageIdsToSeverMsg(diff, chapterId)
end

function LWIntegratedStageFeatureChapterManager:SendResetStageIdsToSeverMsg(diff, chapterId)
  local chapterCfg = self:GetChapterCfgData(chapterId)
  if not chapterCfg then
    return
  end
  SFSNetwork.SendMessage(MsgDefines.StageFeatureIntegratedResetMessage, diff, chapterId)
end

function LWIntegratedStageFeatureChapterManager:UpdateDataFromReset(message)
  local diff = message.stageType
  local diffData = self.difficultyData[diff]
  if not diffData then
    return
  end
  diffData.resetedStageIds = message.resetIds or {}
  self.todayResetTimes = message.resetTimes or 0
  for _, stageId in ipairs(diffData.resetedStageIds) do
    diffData.doneStageIds[stageId] = false
  end
  self:__FindNextStageId(diff, false)
  if self.targetResetDiff == diff and self.targetResetChapterId then
    local param = {}
    param.diff = diff
    param.targetResetChapterId = self.targetResetChapterId
    EventManager:GetInstance():Broadcast(EventId.STAGE_FEATURE_Integrated_RESET, param)
    self.targetResetDiff = nil
    self.targetResetChapterId = nil
  end
end

function LWIntegratedStageFeatureChapterManager:UpdateDataFromPushTimes(message)
  local resetTimes = message.resetTimes
  if resetTimes then
    self.todayResetTimes = resetTimes
  end
end

function LWIntegratedStageFeatureChapterManager:SendSkipMessage(diff, stageId)
  SFSNetwork.SendMessage(MsgDefines.StageFeatureIntegratedSkip, diff, stageId)
end

function LWIntegratedStageFeatureChapterManager:OnReceiveSkip(message)
  local diff = message.stageType
  local diffData = self.difficultyData[diff]
  if not diffData then
    return
  end
  local skips = message.skipIds
  diffData.skipIds = {}
  if skips then
    for _, v in ipairs(skips) do
      diffData.skipIds[v] = true
    end
  end
  self:FixCurStageIdForSkip(diff)
  self:__FindNextStageId(diff, false)
  EventManager:GetInstance():Broadcast(EventId.StageFeatureChapterSkip)
end

function LWIntegratedStageFeatureChapterManager:FixCurStageIdForSkip(diff)
  local diffData = self.difficultyData[diff]
  if not diffData then
    return
  end
  if diffData.currStageId == nil and diffData.nextStageId and self:IsSkipStage(diff, diffData.nextStageId) then
    diffData.currStageId = diffData.nextStageId
    self:__FindNextStageId(diff, false)
  end
end

function LWIntegratedStageFeatureChapterManager:OnParkourBattleWin(stageId)
  if not self:IsOpen() then
    return
  end
  local diff = self:GetStageDiff(stageId)
  if not diff then
    return
  end
  local diffData = self.difficultyData[diff]
  if not diffData then
    return
  end
  local isResetedStage = self:IsStageReseted(diff, stageId)
  local isNextStageId = diffData.nextStageId == stageId
  local isSkipStage = self:IsSkipStage(diff, stageId)
  if not isNextStageId and not isResetedStage and not isSkipStage then
    return
  end
  diffData.doneStageIds[stageId] = true
  if isSkipStage then
    self:RemoveSkipStage(diff, stageId)
  end
  if isResetedStage then
    local newReseted = {}
    for _, rid in ipairs(diffData.resetedStageIds) do
      if rid ~= stageId then
        table.insert(newReseted, rid)
      end
    end
    diffData.resetedStageIds = newReseted
  end
  if isNextStageId then
    diffData.currStageId = stageId
    self:__FindNextStageId(diff, false)
  end
end

function LWIntegratedStageFeatureChapterManager:JudgeIsEnoughUploadDataToGameCenter(paramData)
  local diff = self:GetStageDiff(paramData.stageId)
  if not diff or diff <= StageFeatureIntegratedDifficulty.Normal then
    return
  end
  local targetChapterCfg = self:GetStageBelongsChapterCfgData(paramData.stageId)
  if targetChapterCfg then
    local totalSoldier = paramData.remainMemberCount
    if totalSoldier and 0 < totalSoldier and totalSoldier <= 99999 then
      local rankName = string.format(GameCenterUploadDataName.StageFeatureChapter, targetChapterCfg.id)
      CS.LastWarSocialBridge.SubmitScore(rankName, totalSoldier)
      Logger.LogWarning(string.format("\229\137\141\231\186\191\231\170\129\229\155\180\230\149\180\229\144\136\231\137\136%s\231\171\160\232\138\130\232\144\165\230\149\145\231\154\132\229\176\143\229\133\181\230\128\187\230\149\176\228\184\186%s,\228\184\138\228\188\160\229\136\176GameCenter", targetChapterCfg.id, totalSoldier))
    end
  end
  self:CalculateFinishStageCount()
end

function LWIntegratedStageFeatureChapterManager:CalculateFinishStageCount()
  local finishCount = 0
  local resetCount = 0
  for diff, diffData in pairs(self.difficultyData) do
    for stageId, done in pairs(diffData.doneStageIds) do
      if done then
        finishCount = finishCount + 1
      end
    end
    resetCount = resetCount + table.count(diffData.resetedStageIds)
  end
  local allCount = finishCount + resetCount
  DataCenter.LWGameCenterUploadAchievementManager:UploadStageFeatureChapterAchievement(allCount)
end

function LWIntegratedStageFeatureChapterManager:OnEnterCity()
  if self.autoOpenMapUIWhenBackToCity then
    self.autoOpenMapUIWhenBackToCity = false
    DataCenter.LWBattleManager:SetBattleExitStartTime(BattleExitTimeLogType.StageFeatureIntegrated)
    DataCenter.LWTrailTowerManager:OpenTrailTowerMainPanel(TrailTowerTabType.IntegratedStageFeatureChapter)
  end
end

return LWIntegratedStageFeatureChapterManager
