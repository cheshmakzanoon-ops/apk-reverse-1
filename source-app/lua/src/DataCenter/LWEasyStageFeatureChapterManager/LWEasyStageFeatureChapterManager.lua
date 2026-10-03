local LWEasyStageFeatureChapterManager = BaseClass("LWEasyStageFeatureChapterManager", CEventable)

function LWEasyStageFeatureChapterManager:__init()
  self.currStageId = nil
  self.nextStageId = nil
  self.doneStageIds = {}
  self.chapterCfgs = {}
  self.chapterCfg = nil
  self.chapterReward = {}
  self.lastPlayChapterCfgId = nil
  self.skipIds = {}
  self.failCount = {}
  self:RegisterEvent(EventId.ParkourBattleWin, self.OnParkourBattleWin)
  self:RegisterEvent(EventId.GF_enter_city, self.OnEnterCity)
end

function LWEasyStageFeatureChapterManager:__delete()
  self.currStageId = nil
  self.nextStageId = nil
  self.forceEasyModeDone = nil
  self.doneStageIds = nil
  self.chapterCfgs = nil
  self.chapterCfg = nil
  self.chapterIdToIndex = nil
  self.chapterRewardAlreadyGet = nil
  self.lastPlayChapterCfgId = nil
  self.abTest = nil
  self.autoOpenMapUIWhenBackToCity = nil
  self.skipIds = nil
  self.failCount = nil
end

function LWEasyStageFeatureChapterManager:Startup()
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
        if not self:IsSkipStage(stageId) then
          self.nextStageId = stageId
          self.chapterCfg = chapterCfg
          break
        end
      else
        if fillDoneStageIds and not self:IsSkipStage(stageId) then
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

function LWEasyStageFeatureChapterManager:InitData(msg)
  self.forceEasyModeDone = false
  if msg.planeFeatureStageInfo then
    local normalModeCurStage = msg.planeFeatureStageInfo.stageId
    local normalModelSkipIds = msg.planeFeatureStageInfo.skipIds
    self.forceEasyModeDone = normalModeCurStage ~= nil and 0 < normalModeCurStage or normalModelSkipIds ~= nil and 0 < #normalModelSkipIds
  end
  self.chapterReward = {}
  if msg.planeFeatureNewbieStageInfo then
    self.currStageId = msg.planeFeatureNewbieStageInfo.stageId
    local skips = msg.planeFeatureNewbieStageInfo.skipIds
    self.skipIds = {}
    if skips then
      for _, v in ipairs(skips) do
        self.skipIds[v] = true
      end
    end
  end
  local boxRewardedGet = msg.planeFeatureNewbieStageInfo and msg.planeFeatureNewbieStageInfo.frontlineBox or nil
  self.chapterCfgs = {}
  local tableName = LuaEntry.Player:GetABTestTableName(TableName.LW_EASY_STAGE_FEATURE_CHAPTER)
  local chapterTbl = LocalController:instance():getTable(tableName)
  for chapterId, _ in pairs(chapterTbl.data) do
    local stageIds = LocalController:instance():getValue(tableName, chapterId, "stages")
    local nodePosArr = {}
    local nodePosStrArr = LocalController:instance():getValue(tableName, chapterId, "nodePos")
    for _, nodePosStr in ipairs(nodePosStrArr) do
      local nodePos = string.split(nodePosStr, ",")
      table.insert(nodePosArr, Vector3(tonumber(nodePos[1]), tonumber(nodePos[2]), 0))
    end
    local nodeTipStyleArr = LocalController:instance():getValue(tableName, chapterId, "nodeTipStyle")
    local sign_up_day = LocalController:instance():getValue(tableName, chapterId, "sign_up_day")
    local main_building_level = LocalController:instance():getValue(tableName, chapterId, "main_building_level")
    local chapterIdStr = string.format("%d", chapterId)
    local chapterRewardedIndex = boxRewardedGet and boxRewardedGet[chapterIdStr]
    local chapterBox = LocalController:instance():getValue(tableName, chapterId, "chapter_box")
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
    table.insert(self.chapterCfgs, {
      id = chapterId,
      stageIds = stageIds,
      nodePosArr = nodePosArr,
      nodeTipStyleArr = nodeTipStyleArr,
      sign_up_day = sign_up_day,
      main_building_level = main_building_level,
      boxDatas = chapterBoxDatas
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
  if not self.chapterCfg and 0 < #self.chapterCfgs then
    self.chapterCfg = self.chapterCfgs[1]
  end
  local chaptersNum = #self.chapterCfgs
  if 0 < chaptersNum then
    local theLastChapter = self.chapterCfgs[chaptersNum]
    if theLastChapter and theLastChapter.stageIds and 0 < #theLastChapter.stageIds then
      self.theLastChapterLastStageId = theLastChapter.stageIds[#theLastChapter.stageIds]
    end
  end
  if self.theLastChapterLastStageId and self.forceEasyModeDone then
    self.currStageId = self.theLastChapterLastStageId
  end
  __FindNextStageId(self, true)
  self:FixCurStageIdForSkip()
end

function LWEasyStageFeatureChapterManager:OnEnterGame()
end

function LWEasyStageFeatureChapterManager:SetCurPlayChapterId(chapterId)
  self.lastPlayChapterCfgId = chapterId
end

function LWEasyStageFeatureChapterManager:GetCurPlayChapterId()
  return self.lastPlayChapterCfgId
end

function LWEasyStageFeatureChapterManager:IsAllDone()
  return self.nextStageId == nil
end

function LWEasyStageFeatureChapterManager:IsOpen()
  return self:GetABTest() and not DataCenter.LWIntegratedStageFeatureChapterManager:IsOpen()
end

function LWEasyStageFeatureChapterManager:UpdateBoxRewardData(newRewardGetMsg)
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
    EventManager:GetInstance():Broadcast(EventId.StageFeatureRewardBoxUpdate, newRewardGetMsg.chapter)
  end
end

function LWEasyStageFeatureChapterManager:OnParkourBattleWin(stageId)
  local isNextStageId = self.nextStageId and self.nextStageId == stageId
  local isSkipStage = self:IsSkipStage(stageId)
  if not isNextStageId and not isSkipStage then
    return
  end
  self.doneStageIds[stageId] = true
  if isSkipStage then
    self:RemoveSkipStage(stageId)
  end
  if isNextStageId then
    self.currStageId = stageId
    __FindNextStageId(self, false)
  end
end

function LWEasyStageFeatureChapterManager:GetStageBelongsChapterCfgData(targetStageId)
  for _, chapterCfg in ipairs(self.chapterCfgs) do
    for _, stageId in ipairs(chapterCfg.stageIds) do
      if stageId == targetStageId then
        return chapterCfg
      end
    end
  end
  return nil
end

function LWEasyStageFeatureChapterManager:GetChapterCfgData(chapterId)
  local chapterCfgIndex = self.chapterIdToIndex[chapterId]
  if not chapterCfgIndex then
    return nil
  end
  return self.chapterCfgs[chapterCfgIndex]
end

function LWEasyStageFeatureChapterManager:OnEnterCity()
  if self.autoOpenMapUIWhenBackToCity then
    self.autoOpenMapUIWhenBackToCity = nil
    local dependEasyStageFeatureComplete = not self:IsOpen() or self:IsAllDone()
    local stageFeatureChapterOpen = dependEasyStageFeatureComplete and DataCenter.LWStageFeatureChapterManager:IsOpen()
    if stageFeatureChapterOpen then
      DataCenter.LWBattleManager:SetBattleExitStartTime(BattleExitTimeLogType.Tower_StageFeature)
      DataCenter.LWTrailTowerManager:OpenTrailTowerMainPanel(TrailTowerTabType.StageFeatureChapter)
    else
      DataCenter.LWBattleManager:SetBattleExitStartTime(BattleExitTimeLogType.Tower_EasyStageFeature)
      DataCenter.LWTrailTowerManager:OpenTrailTowerMainPanel(TrailTowerTabType.EasyStageFeatureChapter)
    end
  end
end

function LWEasyStageFeatureChapterManager:IsChapterFinsh(chapterCfg)
  local stageIds = chapterCfg.stageIds
  for i, stageId in ipairs(stageIds) do
    if not self.doneStageIds[stageId] then
      return false
    end
  end
  return true
end

function LWEasyStageFeatureChapterManager:IsSkipStage(stageId)
  return self.skipIds[stageId]
end

function LWEasyStageFeatureChapterManager:RemoveSkipStage(stageId)
  self.skipIds[stageId] = nil
  self.failCount[stageId] = nil
end

function LWEasyStageFeatureChapterManager:AddFailStage(stageId)
  if stageId == nil then
    return
  end
  if self.doneStageIds[stageId] then
    self:RemoveSkipStage(stageId)
    return
  end
  local count = self.failCount[stageId] or 0
  count = count + 1
  self.failCount[stageId] = count
end

function LWEasyStageFeatureChapterManager:GetFailCount(stageId)
  if self.failCount then
    return self.failCount[stageId] or 0
  end
  return 0
end

function LWEasyStageFeatureChapterManager:OnReceiveSkip(message)
  local skips = message.skipIds
  self.skipIds = {}
  if skips then
    for _, v in ipairs(skips) do
      self.skipIds[v] = true
    end
  end
  self:FixCurStageIdForSkip()
  __FindNextStageId(self, false)
  EventManager:GetInstance():Broadcast(EventId.StageFeatureChapterSkip)
end

function LWEasyStageFeatureChapterManager:FixCurStageIdForSkip()
  if self.currStageId == nil and self.nextStageId and self:IsSkipStage(self.nextStageId) then
    self.currStageId = self.nextStageId
    __FindNextStageId(self, false)
  end
end

function LWEasyStageFeatureChapterManager:TryEnterNextStage()
  if self.nextStageId and self.nextStageId > 0 and self.chapterCfg then
    UIManager:GetInstance():DestroyWindow(UIWindowNames.UIParkourBattleLose, {anim = false})
    local param = {}
    param.type = PVEType.Parkour
    param.levelId = tonumber(self.nextStageId)
    param.fromChapter = true
    DataCenter.LWBattleManager:Enter(param)
    DataCenter.LWEasyStageFeatureChapterManager.autoOpenMapUIWhenBackToCity = true
    DataCenter.LWEasyStageFeatureChapterManager:SetCurPlayChapterId(self.chapterCfg.id)
    return true
  end
  return false
end

function LWEasyStageFeatureChapterManager:GetABTest()
  if self.abTest ~= nil then
    return self.abTest
  end
  local server = LuaEntry.Player:GetSourceServerId()
  if CS.CommonUtils.IsDebug() then
    local serverArray = LuaEntry.DataConfig:TryGetStr("new_frontline_breakthrough", "k3")
    if not string.IsNullOrEmpty(serverArray) then
      local array = string.split(serverArray, "|")
      for _, arr in ipairs(array) do
        local list = string.split(arr, "-")
        if #list == 2 then
          local startServer = tonumber(list[1])
          local endServer = tonumber(list[2])
          if startServer <= endServer and server >= startServer and server <= endServer then
            self.abTest = true
            return self.abTest
          end
        elseif #list == 1 then
          local se = tonumber(list[1]) or 0
          if 0 < se and se == server then
            self.abTest = true
            return self.abTest
          end
        end
      end
    end
  else
    local serverArray = LuaEntry.DataConfig:TryGetStr("new_frontline_breakthrough", "k4")
    if not string.IsNullOrEmpty(serverArray) then
      local array = string.split(serverArray, "|")
      for _, arr in ipairs(array) do
        local list = string.split(arr, "-")
        if #list == 2 then
          local startServer = tonumber(list[1])
          local endServer = tonumber(list[2])
          if startServer <= endServer and server >= startServer and server <= endServer then
            self.abTest = true
            return self.abTest
          end
        elseif #list == 1 then
          local se = tonumber(list[1]) or 0
          if 0 < se and se == server then
            self.abTest = true
            return self.abTest
          end
        end
      end
    end
  end
  self.abTest = false
  return false
end

return LWEasyStageFeatureChapterManager
