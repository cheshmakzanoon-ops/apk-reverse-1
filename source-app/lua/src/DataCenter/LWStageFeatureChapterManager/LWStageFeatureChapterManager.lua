local LWStageFeatureChapterManager = BaseClass("LWStageFeatureChapterManager", CEventable)
local Localization = CS.GameEntry.Localization

function LWStageFeatureChapterManager:__init()
  self.currStageId = nil
  self.nextStageId = nil
  self.doneStageIds = {}
  self.chapterCfgs = {}
  self.chapterCfg = nil
  self.lastPlayChapterCfgId = nil
  self.resetedStageIds = {}
  self.todayResetTimes = 0
  self.skipIds = {}
  self.failCount = {}
  self.chapterStageInfoDict = {}
  self.acceptInviteCache = {}
  self.helpUserInfo = {
    helpTimes = 0,
    beHelpedTimes = 0,
    shareTimes = 0,
    lastShareTime = 0
  }
  self:RegisterEvent(EventId.ParkourBattleWin, self.OnParkourBattleWin)
  self:RegisterEvent(EventId.GF_enter_city, self.OnEnterCity)
  self:RegisterEvent(EventId.StageFeatureChapterWinCheckUploadGameCenterData, self.JudgeIsEnoughUploadDataToGameCenter)
  self:RegisterEvent(EventId.OnPassDay, self.OnPassDay)
  self:RegisterEvent(EventId.PlaneFeatureAcceptResultSuccess, self.OnAcceptResultSuccess)
end

function LWStageFeatureChapterManager:__delete()
  self.currStageId = nil
  self.nextStageId = nil
  self.doneStageIds = nil
  self.chapterCfgs = nil
  self.chapterCfg = nil
  self.chapterIdToIndex = nil
  self.resetedStageIds = nil
  self.lastPlayChapterCfgId = nil
  self.abTest = nil
  self.todayResetTimes = 0
  self.autoOpenMapUIWhenBackToCity = nil
  self.skipIds = nil
  self.failCount = nil
  self.chapterStageInfoDict = nil
end

function LWStageFeatureChapterManager:Startup()
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
  if fillDoneStageIds then
    for index, resetedStageId in ipairs(self.resetedStageIds) do
      self.doneStageIds[resetedStageId] = false
    end
  end
end

function LWStageFeatureChapterManager:InitData(msg)
  if msg.planeFeatureStageInfo then
    self.currStageId = msg.planeFeatureStageInfo.stageId
    local resetTimesToday = msg.planeFeatureStageInfo.resetTimes
    self.todayResetTimes = resetTimesToday or 0
    local resetedStageIds = msg.planeFeatureStageInfo.ids
    self.resetedStageIds = resetedStageIds or {}
    local skips = msg.planeFeatureStageInfo.skipIds
    self.skipIds = {}
    if skips then
      for _, v in ipairs(skips) do
        self.skipIds[v] = true
      end
    end
  end
  self.chapterCfgs = {}
  local chapterTbl = LocalController:instance():getTable(TableName.LW_STAGE_FEATURE_CHAPTER)
  for chapterId, _ in pairs(chapterTbl.data) do
    local stageIds = LocalController:instance():getValue(TableName.LW_STAGE_FEATURE_CHAPTER, chapterId, "stages")
    local nodePosArr = {}
    local nodePosStrArr = LocalController:instance():getValue(TableName.LW_STAGE_FEATURE_CHAPTER, chapterId, "nodePos")
    for _, nodePosStr in ipairs(nodePosStrArr) do
      local nodePos = string.split(nodePosStr, ",")
      table.insert(nodePosArr, Vector3(tonumber(nodePos[1]), tonumber(nodePos[2]), 0))
    end
    local nodeTipStyleArr = LocalController:instance():getValue(TableName.LW_STAGE_FEATURE_CHAPTER, chapterId, "nodeTipStyle")
    local sign_up_day = LocalController:instance():getValue(TableName.LW_STAGE_FEATURE_CHAPTER, chapterId, "sign_up_day")
    local main_building_level = LocalController:instance():getValue(TableName.LW_STAGE_FEATURE_CHAPTER, chapterId, "main_building_level")
    table.insert(self.chapterCfgs, {
      id = chapterId,
      stageIds = stageIds,
      nodePosArr = nodePosArr,
      nodeTipStyleArr = nodeTipStyleArr,
      sign_up_day = sign_up_day,
      main_building_level = main_building_level
    })
  end
  table.sort(self.chapterCfgs, function(a, b)
    return a.id < b.id
  end)
  self.chapterIdToIndex = {}
  for index, chaperCfgData in ipairs(self.chapterCfgs) do
    if chaperCfgData then
      self.chapterIdToIndex[chaperCfgData.id] = index
    end
  end
  if not self.chapterCfg and 0 < #self.chapterCfgs then
    self.chapterCfg = self.chapterCfgs[1]
  end
  __FindNextStageId(self, true)
  self.countBattleMapMainLv = LuaEntry.DataConfig:TryGetNum("stageFeatureChapter", "k3")
  self:FixCurStageIdForSkip()
  self:CalculateFinishStageCount()
  self.shareCd = LuaEntry.DataConfig:TryGetNum("frontline_daily_share_config", "k1")
  self.todayShareMaxCount = LuaEntry.DataConfig:TryGetNum("frontline_daily_share_config", "k2")
  self.todayHelpedMaxCount = LuaEntry.DataConfig:TryGetNum("frontline_daily_share_config", "k3")
  self.todayAcceptResultMaxCount = LuaEntry.DataConfig:TryGetNum("frontline_daily_share_config", "k8")
end

function LWStageFeatureChapterManager:OnEnterGame()
  self.countBattleMapMainLv = LuaEntry.DataConfig:TryGetNum("stageFeatureChapter", "k3")
  self:RequestHelpUserInfo()
end

function LWStageFeatureChapterManager:SetCurPlayChapterId(chapterId)
  self.lastPlayChapterCfgId = chapterId
end

function LWStageFeatureChapterManager:GetCurPlayChapterId()
  return self.lastPlayChapterCfgId
end

function LWStageFeatureChapterManager:IsAllDone()
  return self.nextStageId == nil
end

function LWStageFeatureChapterManager:IsOpen()
  return not DataCenter.LWIntegratedStageFeatureChapterManager:IsOpen()
end

function LWStageFeatureChapterManager:OnPassDay()
  if not self.helpUserInfo then
    return
  end
  self.helpUserInfo.helpTimes = 0
  self.helpUserInfo.beHelpedTimes = 0
  self.helpUserInfo.shareTimes = 0
end

function LWStageFeatureChapterManager:OnParkourBattleWin(stageId)
  local isResetedStage = self:IsStageReseted(stageId)
  local isNextStageId = self.nextStageId and self.nextStageId == stageId
  local isSkipStage = self:IsSkipStage(stageId)
  if not isNextStageId and not isResetedStage and not isSkipStage then
    return
  end
  self.doneStageIds[stageId] = true
  if isSkipStage then
    self:RemoveSkipStage(stageId)
  end
  if isResetedStage then
    local newResetedStageIds = {}
    for i, resetedStageId in ipairs(self.resetedStageIds) do
      if resetedStageId ~= stageId then
        table.insert(newResetedStageIds, resetedStageId)
      end
    end
    self.resetedStageIds = newResetedStageIds
    return
  end
  if isNextStageId then
    self.currStageId = stageId
    __FindNextStageId(self, false)
  end
end

function LWStageFeatureChapterManager:GetTodayResetTimes()
  return self.todayResetTimes
end

function LWStageFeatureChapterManager:GetStageBelongsChapterCfgData(targetStageId)
  for _, chapterCfg in ipairs(self.chapterCfgs) do
    for _, stageId in ipairs(chapterCfg.stageIds) do
      if stageId == targetStageId then
        return chapterCfg
      end
    end
  end
  return nil
end

function LWStageFeatureChapterManager:GetResetedChapterNextStageId(resetedChapterCfg)
  if not resetedChapterCfg then
    return -1
  end
  local resetedChapterStageIds = resetedChapterCfg.stageIds
  for index, stageId in ipairs(resetedChapterStageIds) do
    local stageIsReseted = self:IsStageReseted(stageId)
    if stageIsReseted then
      return stageId
    end
  end
  return -1
end

function LWStageFeatureChapterManager:IsStageReseted(stageId)
  return table.indexof(self.resetedStageIds, stageId)
end

function LWStageFeatureChapterManager:GetChapterCfgData(chapterId)
  local chapterCfgIndex = self.chapterIdToIndex[chapterId]
  if not chapterCfgIndex then
    return nil
  end
  return self.chapterCfgs[chapterCfgIndex]
end

function LWStageFeatureChapterManager:ResetTargetChapterStages(chapterId)
  local chapterCfgIndex = self.chapterIdToIndex[chapterId]
  if not chapterCfgIndex then
    return
  end
  self.targetResetChapterId = chapterId
  self:SendResetStageIdsToSeverMsg(self.targetResetChapterId)
end

function LWStageFeatureChapterManager:UpdateDataFromReset(msg)
  if not msg then
    return
  end
  if self.targetResetChapterId then
    self.resetedStageIds = msg.ids or {}
    self.todayResetTimes = msg.resetTimes or 0
    for i, stageId in ipairs(self.resetedStageIds) do
      self.doneStageIds[stageId] = false
    end
    EventManager:GetInstance():Broadcast(EventId.STAGE_FEATURE_CHAPTER_RESET, self.targetResetChapterId)
  end
end

function LWStageFeatureChapterManager:UpdateDataFromPushTimes(msg)
  if not msg then
    return
  end
  local updatedResetTimes = msg.resetTimes
  if updatedResetTimes then
    self.todayResetTimes = updatedResetTimes
  end
end

function LWStageFeatureChapterManager:SendResetStageIdsToSeverMsg(resetChapterId)
  SFSNetwork.SendMessage(MsgDefines.StageFeatureChapterResetMessage, resetChapterId)
end

function LWStageFeatureChapterManager:OnEnterCity()
  if self.autoOpenMapUIWhenBackToCity then
    self.autoOpenMapUIWhenBackToCity = nil
    DataCenter.LWBattleManager:SetBattleExitStartTime(BattleExitTimeLogType.Tower_StageFeature)
    DataCenter.LWTrailTowerManager:OpenTrailTowerMainPanel(TrailTowerTabType.StageFeatureChapter)
  end
end

function LWStageFeatureChapterManager:IsChapterFinsh(chapterCfg)
  local stageIds = chapterCfg.stageIds
  for i, stageId in ipairs(stageIds) do
    if not self.doneStageIds[stageId] then
      return false
    end
  end
  return true
end

function LWStageFeatureChapterManager:IsSkipStage(stageId)
  return self.skipIds[stageId]
end

function LWStageFeatureChapterManager:RemoveSkipStage(stageId)
  self.skipIds[stageId] = nil
  self.failCount[stageId] = nil
end

function LWStageFeatureChapterManager:AddFailStage(stageId)
  if stageId == nil then
    return
  end
  if self.doneStageIds[stageId] then
    self:RemoveSkipStage(stageId)
    return
  end
  if self:IsStageReseted(stageId) then
    self:RemoveSkipStage(stageId)
    return
  end
  local count = self.failCount[stageId] or 0
  count = count + 1
  self.failCount[stageId] = count
end

function LWStageFeatureChapterManager:GetFailCount(stageId)
  if self.failCount then
    return self.failCount[stageId] or 0
  end
  return 0
end

function LWStageFeatureChapterManager:SendSkipMessage(stageId)
  SFSNetwork.SendMessage(MsgDefines.StageFeatureChapterSkip, stageId)
end

function LWStageFeatureChapterManager:OnReceiveSkip(message)
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

function LWStageFeatureChapterManager:FixCurStageIdForSkip()
  if self.currStageId == nil and self.nextStageId and self:IsSkipStage(self.nextStageId) then
    self.currStageId = self.nextStageId
    __FindNextStageId(self, false)
  end
end

function LWStageFeatureChapterManager:TryEnterNextStage()
  if self.nextStageId and self.nextStageId > 0 and self.chapterCfg then
    UIManager:GetInstance():DestroyWindow(UIWindowNames.UIParkourBattleLose, {anim = false})
    local param = {}
    param.type = PVEType.Parkour
    param.levelId = tonumber(self.nextStageId)
    param.fromChapter = true
    DataCenter.LWBattleManager:Enter(param)
    DataCenter.LWStageFeatureChapterManager.autoOpenMapUIWhenBackToCity = true
    DataCenter.LWStageFeatureChapterManager:SetCurPlayChapterId(self.chapterCfg.id)
    return true
  end
  return false
end

function LWStageFeatureChapterManager:RequestChapterStageInfo(chapterId)
  for k, v in pairs(self.chapterCfgs) do
    if v.id == chapterId then
      SFSNetwork.SendMessage(MsgDefines.LwPlaneFeatureInfo, v.stageIds)
    end
  end
end

function LWStageFeatureChapterManager:RefreshChapterStageInfo(message)
  if message.info then
    for k, v in pairs(message.info) do
      if v.id and v.soldier then
        self.chapterStageInfoDict[v.id] = v.soldier
      end
    end
  end
end

function LWStageFeatureChapterManager:UpdateOneStageInfo(stageId, historySoldier)
  if self.chapterStageInfoDict[stageId] then
    if historySoldier > self.chapterStageInfoDict[stageId] then
      self.chapterStageInfoDict[stageId] = historySoldier
    end
  else
    self.chapterStageInfoDict[stageId] = historySoldier
  end
end

function LWStageFeatureChapterManager:JudgeIsEnoughUploadDataToGameCenter(paramData)
  local targetChapterCfg = self:GetStageBelongsChapterCfgData(paramData.stageId)
  if targetChapterCfg then
    local totalSoldier = paramData.remainMemberCount
    if totalSoldier and 0 < totalSoldier and totalSoldier <= 99999 then
      local rankName = string.format(GameCenterUploadDataName.StageFeatureChapter, targetChapterCfg.id)
      CS.LastWarSocialBridge.SubmitScore(rankName, totalSoldier)
      Logger.LogWarning(string.format("\229\137\141\231\186\191\231\170\129\229\155\180\231\172\172%s\231\171\160\232\138\130\232\144\165\230\149\145\231\154\132\229\176\143\229\133\181\230\128\187\230\149\176\228\184\186%s,\228\184\138\228\188\160\229\136\176GameCenter", targetChapterCfg.id, totalSoldier))
    end
  end
  self:CalculateFinishStageCount()
end

function LWStageFeatureChapterManager:CalculateFinishStageCount()
  local finishCount = 0
  for stageId, value in pairs(self.doneStageIds) do
    if value then
      finishCount = finishCount + 1
    end
  end
  local resetCount = table.count(self.resetedStageIds)
  local allCount = finishCount + resetCount
  DataCenter.LWGameCenterUploadAchievementManager:UploadStageFeatureChapterAchievement(allCount)
end

function LWStageFeatureChapterManager:RequestHelpToPlayer(stageId, targetUid)
  if self.helpUserInfo and self.helpUserInfo.shareTimes and self.helpUserInfo.shareTimes >= self.todayShareMaxCount then
    UIUtil.ShowTipsId("frontline_help_fail_03")
    return
  end
  if not self:IsMeetShareCd() then
    UIUtil.ShowTipsId("sticker_send_limit_tips")
    return
  end
  SFSNetwork.SendMessage(MsgDefines.PlaneFeatureInviteChat, stageId, targetUid)
end

function LWStageFeatureChapterManager:RequestHelpToAlliance(stageId)
  if self.helpUserInfo and self.helpUserInfo.shareTimes and self.helpUserInfo.shareTimes >= self.todayShareMaxCount then
    UIUtil.ShowTipsId("frontline_help_fail_03")
    return
  end
  if not self:IsMeetShareCd() then
    UIUtil.ShowTipsId("sticker_send_limit_tips")
    return
  end
  SFSNetwork.SendMessage(MsgDefines.PlaneFeatureInviteAllianceChat, stageId)
end

function LWStageFeatureChapterManager:GoToHelp(uuid, stageId)
  local param = {}
  param.type = PVEType.Parkour
  param.levelId = tonumber(stageId)
  param.fromChapter = true
  param.memRecord = true
  param.helpUuid = uuid
  param.isChapterHelp = true
  if DataCenter.StageFeatureSceneManager:IsInScene() then
    param.enterType = PVEEnterType.StageFeatureScene
    param.stageFeatureTabType = DataCenter.LWIntegratedStageFeatureChapterManager:IsOpen() and TrailTowerTabType.IntegratedStageFeatureChapter or TrailTowerTabType.StageFeatureChapter
    DataCenter.StageFeatureSceneManager:ExitBeforeBattle()
  end
  DataCenter.LWBattleManager:Enter(param)
end

function LWStageFeatureChapterManager:CompleteHelp(uuid, stageId, remainSoldierCount, overPlayer)
  SFSNetwork.SendMessage(MsgDefines.HelpPlaneFeatureFinish, uuid, stageId, remainSoldierCount, overPlayer)
end

function LWStageFeatureChapterManager:AcceptHelpInvite(uuid, stageId)
  if not self:IsHelpShareFunctionOn() then
    UIUtil.ShowTipsId("390994")
    return
  end
  if self.helpUserInfo and self.helpUserInfo.helpTimes and self.helpUserInfo.helpTimes >= self.todayHelpedMaxCount then
    UIUtil.ShowTipsId("frontline_help_tips_08")
    return
  end
  SFSNetwork.SendMessage(MsgDefines.PlaneFeatureAcceptInvite, uuid, stageId)
end

function LWStageFeatureChapterManager:AcceptHelpInviteAlliance(uuid, stageId, targetUid)
  if not self:IsHelpShareFunctionOn() then
    UIUtil.ShowTipsId("390994")
    return
  end
  if self.helpUserInfo and self.helpUserInfo.helpTimes and self.helpUserInfo.helpTimes >= self.todayHelpedMaxCount then
    UIUtil.ShowTipsId("frontline_help_tips_08")
    return
  end
  SFSNetwork.SendMessage(MsgDefines.PlaneFeatureAcceptAllianceInvite, uuid, stageId, targetUid)
end

function LWStageFeatureChapterManager:AcceptHelpResult(uuid, stageId)
  if not self:IsHelpShareFunctionOn() then
    UIUtil.ShowTipsId("390994")
    return
  end
  if self.helpUserInfo and self.helpUserInfo.beHelpedTimes and self.helpUserInfo.beHelpedTimes >= self.todayAcceptResultMaxCount then
    UIUtil.ShowTipsId("action_type_not_enough")
    return
  end
  SFSNetwork.SendMessage(MsgDefines.PlaneFeatureAcceptResult, uuid, stageId)
end

function LWStageFeatureChapterManager:RequestHelpUserInfo()
  local buildData = DataCenter.BuildManager:GetFunbuildByItemID(BuildingTypes.LW_BUILD_COUNT_BATTLE)
  if not buildData or buildData.level < 1 then
    return
  end
  SFSNetwork.SendMessage(MsgDefines.PlaneFeatureUserInfo)
end

function LWStageFeatureChapterManager:OnGetHelpUserInfo(data)
  if not data then
    return
  end
  self.helpUserInfo = data
end

function LWStageFeatureChapterManager:GetHelpUserInfo()
  return self.helpUserInfo
end

function LWStageFeatureChapterManager:GetStageFeatureName(stageId)
  if not stageId then
    return ""
  end
  local tableName = LuaEntry.Player:GetABTestTableName(TableName.LW_Stage_Feature)
  local stageOrder = GetTableData(tableName, stageId, "order") or 0
  local nameLocalized = GetTableData(tableName, stageId, "name")
  local localizedName = Localization:GetString(nameLocalized, stageOrder)
  return localizedName
end

function LWStageFeatureChapterManager:StageFeatureResultThumbsUp(uuid)
  SFSNetwork.SendMessage(MsgDefines.PlaneFeatureResultThumbsUp, uuid)
end

function LWStageFeatureChapterManager:UpdateLastShareTime(time)
  if not self.helpUserInfo then
    return
  end
  self.helpUserInfo.lastShareTime = time
end

function LWStageFeatureChapterManager:UpdateShareTimes(times)
  if not self.helpUserInfo or not times then
    return
  end
  self.helpUserInfo.shareTimes = times
end

function LWStageFeatureChapterManager:UpdateHelpTimes(times)
  if not self.helpUserInfo or not times then
    return
  end
  self.helpUserInfo.helpTimes = times
end

function LWStageFeatureChapterManager:UpdateBeHelpedTimes(times)
  if not self.helpUserInfo or not times then
    return
  end
  self.helpUserInfo.beHelpedTimes = times
end

function LWStageFeatureChapterManager:IsMeetShareCd()
  if not self.helpUserInfo then
    return true
  end
  local lastShareTime = self.helpUserInfo.lastShareTime or 0
  local curTime = UITimeManager:GetInstance():GetServerTime()
  local leftTime = lastShareTime + self.shareCd * 1000 - curTime
  if leftTime <= 0 then
    return true
  end
  return false, leftTime
end

function LWStageFeatureChapterManager:OnAcceptResultSuccess(message)
  local param = {}
  param.fromChapter = true
  param.stageId = message.stageId
  local percent = message.overPlayer / 10000
  param.rank = string.format("%.2f%%", percent * 100)
  param.score = message.soldier
  param.isChapterHelp = true
  param.fromHelpResult = true
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIParkourBattleWin, {anim = false, playEffect = 10024}, param)
end

function LWStageFeatureChapterManager:IsHelpShareFunctionOn()
  return LuaEntry.DataConfig:CheckSwitch("frontline_daily_share")
end

function LWStageFeatureChapterManager:SaveAcceptInviteUuid(uuid)
  if not uuid or not self.acceptInviteCache then
    return
  end
  self.acceptInviteCache[uuid] = true
  EventManager:GetInstance():Broadcast(EventId.PlaneFeatureAcceptAllianceInvite, uuid)
end

function LWStageFeatureChapterManager:CheckAcceptInviteUuidExist(uuid)
  if not uuid or not self.acceptInviteCache then
    return false
  end
  return self.acceptInviteCache[uuid] == true
end

function LWStageFeatureChapterManager:ShowGoToTipsMessage(uuid, stageId)
  if not uuid or not stageId then
    return
  end
  local chatView = UIManager:GetInstance():GetWindow(UIWindowNames.UIChatNew_v2)
  local stageView = UIManager:GetInstance():GetWindow(UIWindowNames.UILWTrailTowerMain)
  local isInCityOrWorld = SceneUtils.GetIsInCity() or SceneUtils.GetIsInWorld()
  local isInStageFeatureScene = DataCenter.StageFeatureSceneManager:IsInScene()
  if not (isInCityOrWorld or isInStageFeatureScene) or not chatView and not stageView then
    UIUtil.ShowTipsId("frontline_help_tips_13")
    return
  end
  local param = {}
  param.uuid = uuid
  param.stageId = stageId
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIStageFeatureGoToHelp, {anim = true}, param)
end

return LWStageFeatureChapterManager
