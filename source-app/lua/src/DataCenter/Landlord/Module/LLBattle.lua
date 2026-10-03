local _CLASS = {}
local LLCityDetailData = require("DataCenter.Landlord.Data.LLCityDetailData")
local Localization = CS.GameEntry.Localization
local Resource = CS.GameEntry.Resource

function _CLASS:InitBattle()
  self.lastServerId = nil
  self.centerServerId = 0
  self.configIdFromWorld = nil
  self.isInNewCenterMapPeriod = {}
  self.isShowingLLMainUI = false
  self.cityDetailList = {}
  self.actBuffRecordList = {}
  self.battleCityNoticeDestroyList = {}
  self.battleCityNoticePercentList = {}
  self.preBattleTimeMinute = LuaEntry.DataConfig:TryGetNum("zonewar_landlord", "k11", 1)
  self.clearPrepareStagePlayerTypeFlag = nil
end

function _CLASS:DeleteBattle()
  self:OnExitWorld()
  self.centerServerId = nil
  self.configIdFromWorld = nil
  self.isInNewCenterMapPeriod = nil
  self.lastServerId = nil
  self.isShowingLLMainUI = nil
  self.curCenterServerId = nil
  if self.ironCurtainReq then
    self.ironCurtainReq:Release()
    self.ironCurtainReq = nil
  end
  self.ironCurtainCallbacks = nil
  self.ironCurtainMat = nil
  self.cityDetailList = nil
  self.battleCityNoticeDestroyList = nil
  self.battleCityNoticePercentList = nil
  self.battleCountDownSec = nil
  self.curBattleStartSec = nil
  self.clearPrepareStagePlayerTypeFlag = nil
  self:PurgeCSharpLandlordManager()
end

function _CLASS:SendDetailMessage(cityId, serverId)
  SFSNetwork.SendMessage(MsgDefines.GetLandlordCityDetail, serverId, cityId)
end

function _CLASS:OnHandleDetailMessage(msg)
  EventManager:GetInstance():Broadcast(EventId.LandlordGetCityDetail, msg)
end

function _CLASS:TryReqDetailList(type)
  local dic = self.cityDetailList[type] or {}
  self.cityDetailList[type] = dic
  local curSec = UITimeManager:GetInstance():GetServerSeconds()
  local lastReqTime = dic.lastReqTime or 0
  if curSec - lastReqTime < 10 then
    return
  end
  dic.lastReqTime = curSec
  SFSNetwork.SendMessage(MsgDefines.LandlordGetCityDetailList, type)
end

function _CLASS:OnHandleDetailList(msg)
  local type = msg.type
  local dic = self.cityDetailList[type] or {}
  self.cityDetailList[type] = dic
  dic.selfRank = msg.selfRank
  dic.alRank = msg.alRank
  local list = {}
  local cityDetailList = msg.cityDetailList
  if cityDetailList ~= nil then
    for _, v in ipairs(cityDetailList) do
      local cityDetail = LLCityDetailData.New()
      cityDetail:ParseData(v)
      table.insert(list, cityDetail)
    end
  end
  dic.list = list
  EventManager:GetInstance():Broadcast(EventId.LandlordGetCityDetailList, type)
end

function _CLASS:GetDetailList(type)
  return self.cityDetailList[type]
end

function _CLASS:ReqMaxDestroyCity()
  SFSNetwork.SendMessage(MsgDefines.LandlordMaxDestroyCity)
end

function _CLASS:OnHandleMaxDestroyCity(msg)
  self:JumpToCity(msg.cityId)
end

function _CLASS:HandleBattleCityNotice(msg)
  if msg == nil then
    return
  end
  local progress = toInt(msg.progress)
  local cacheList = (progress == 100 or progress == 0) and self.battleCityNoticeDestroyList or self.battleCityNoticePercentList
  if cacheList ~= nil then
    table.insert(cacheList, msg)
  end
  EventManager:GetInstance():Broadcast(EventId.LandlordBattleCityNotice, msg)
end

function _CLASS:PopBattleCityNoticeMsg(isDestroyNotice)
  local cacheList = isDestroyNotice and self.battleCityNoticeDestroyList or self.battleCityNoticePercentList
  if table.IsNullOrEmpty(cacheList) then
    return nil
  end
  return table.remove(cacheList, 1)
end

function _CLASS:ClearBattleCityNoticeMsgCache(isDestroyNotice)
  if isDestroyNotice == nil then
    if self.battleCityNoticeDestroyList then
      table.clear(self.battleCityNoticeDestroyList)
    end
    if self.battleCityNoticePercentList then
      table.clear(self.battleCityNoticePercentList)
    end
    return
  end
  local cacheList = isDestroyNotice and self.battleCityNoticeDestroyList or self.battleCityNoticePercentList
  if cacheList then
    table.clear(cacheList)
  end
end

function _CLASS:IsCityWithBoom(cityId)
  local llPreviewStage = DataCenter.LandlordMgr:GetActCurStage()
  local isNewCenterMap = DataCenter.LandlordMgr:IsInNewCenterMapPeriod()
  local cityTemplate = DataCenter.AllianceCityTemplateManager:GetTemplate(cityId, LuaEntry.Player:GetCurServerId())
  local isOldCityBoom = llPreviewStage == LLConst.LandlordStage.PREVIEW and not isNewCenterMap
  local isNewCityBoom = isNewCenterMap
  local isCenterCity = cityTemplate and cityTemplate:getValue("zoneId") == 5
  return isCenterCity and (isOldCityBoom or isNewCityBoom)
end

function _CLASS:IsOldCityWithBoom(cityId)
  local llPreviewStage = DataCenter.LandlordMgr:GetActCurStage()
  local isNewCenterMap = DataCenter.LandlordMgr:IsInNewCenterMapPeriod()
  local cityTemplate = DataCenter.AllianceCityTemplateManager:GetTemplate(cityId, LuaEntry.Player:GetCurServerId())
  local isOldCityBoom = llPreviewStage == LLConst.LandlordStage.PREVIEW and not isNewCenterMap
  local isCenterCity = cityTemplate and cityTemplate:getValue("zoneId") == 5
  return isCenterCity and isOldCityBoom
end

function _CLASS:IsOldCityBooming(cityId)
  local llPreviewStage = DataCenter.LandlordMgr:GetActCurStage()
  local isNewCenterMap = DataCenter.LandlordMgr:IsInNewCenterMapPeriod()
  local cityTemplate = DataCenter.AllianceCityTemplateManager:GetTemplate(cityId, LuaEntry.Player:GetCurServerId())
  local curTime = UITimeManager:GetInstance():GetServerTime()
  local boomTime = DataCenter.LandlordMgr:GetPreviewBoomTime()
  local isOldCityBoom = llPreviewStage == LLConst.LandlordStage.PREVIEW and not isNewCenterMap and curTime >= boomTime
  local isCenterCity = cityTemplate and cityTemplate:getValue("zoneId") == 5 and cityTemplate.type ~= WorldAllianceCityType.Canon
  return isCenterCity and isOldCityBoom
end

function _CLASS:PreviewBoomCheck()
  local curTime = UITimeManager:GetInstance():GetServerTime()
  local boomTime = self:GetPreviewBoomTime()
  self.previewBoomCheck = curTime < boomTime
end

function _CLASS:PreviewBoomTimerAction()
  if not self.previewBoomCheck then
    return
  end
  local curTime = UITimeManager:GetInstance():GetServerTime()
  local boomTime = self:GetPreviewBoomTime()
  if curTime >= boomTime then
    if SceneUtils.GetIsInWorld() then
      CS.SceneManager.World:UpdateViewRequest(true)
    end
    EventManager:GetInstance():Broadcast(EventId.LandlordOldCityPointStartBooming)
    self.previewBoomCheck = false
  end
end

function _CLASS:ClearPreviewBoomCheck()
  self.previewBoomCheck = false
end

function _CLASS:RefreshCenterMapRandomFxSystem()
  local csInst = CS.LandlordManager.Instance
  if csInst then
    csInst.previewBoomTime = self:GetPreviewBoomTime()
    csInst.myCampId = self:GetMyGroup()
    csInst:DisposeCenterMapRandomFxSystem()
    csInst:EnsureCenterMapRandomFxSystem()
  end
end

function _CLASS:GetIronCurtainMaterial(callback)
  if self.ironCurtainMat and not IsNull(self.ironCurtainMat) then
    if callback then
      callback(self.ironCurtainMat)
    end
    return
  end
  if callback then
    self.ironCurtainCallbacks = self.ironCurtainCallbacks or {}
    table.insert(self.ironCurtainCallbacks, callback)
  end
  if self.ironCurtainReq then
    return
  end
  self.ironCurtainReq = Resource:LoadAssetAsync(LLConst.IronCurtainBuffMatPath, typeof(CS.UnityEngine.Material))
  
  function self.ironCurtainReq.completed(asset)
    self.ironCurtainReq = nil
    if IsNull(asset) or IsNull(asset.asset) then
      return
    end
    local mat = CS.UnityEngine.Material(asset.asset)
    if IsNull(mat) then
      return
    end
    self.ironCurtainMat = mat
    local cbs = self.ironCurtainCallbacks
    self.ironCurtainCallbacks = nil
    if cbs then
      for _, cb in ipairs(cbs) do
        if cb then
          cb(self.ironCurtainMat)
        end
      end
    end
  end
end

function _CLASS:IsCurHaveIronCurtainStatus()
  return LuaEntry.Effect:HasStatus(LLConst.IronCurtainStatusId)
end

function _CLASS:GetCurIronCurtainStatusEndTime()
  return LuaEntry.Effect:GetStatusEndTime(LLConst.IronCurtainStatusId) or 0
end

function _CLASS:OnFinishHandleInitMsg()
  self:RefreshServerChange(true)
  self:SetCurCenterServerId(DataCenter.SeasonDataManager:GetNinePalacesServer(5, ServerEnum.View))
end

function _CLASS:OnEnterWorld()
  self:RefreshServerChange()
  local csInst = CS.LandlordManager.Instance
  if csInst then
    csInst:EnsureCenterMapRandomFxSystem()
  end
end

function _CLASS:OnExitWorld()
  self.lastServerId = nil
  self:StopMainUIAnimTimer()
  self:TryCloseBattleMainWindow()
  self:RemoveBattleCountDownTimer()
  local csInst = CS.LandlordManager.Instance
  if csInst then
    csInst:DisposeCenterMapRandomFxSystem()
  end
end

function _CLASS:PurgeCSharpLandlordManager()
  if CS.LandlordManager then
    CS.LandlordManager.Purge()
  end
end

function _CLASS:ClearCSharpLandlordManagerZoneData()
  if CS.LandlordManager then
    CS.LandlordManager.ClearLandlordCache()
  end
end

function _CLASS:StopMainUIAnimTimer()
  if self.mainUIAnimTimer then
    self.mainUIAnimTimer:Stop()
    self.mainUIAnimTimer = nil
  end
end

function _CLASS:RefreshServerChange(force)
  if BattleFieldUtil.InBattleField() or not SceneUtils.GetIsInWorld() then
    return
  end
  local curStage = self:GetActCurStage()
  if not DataCenter.LandlordMgr:IsInMyServerGroup() then
    self.lastServerId = nil
    self:RemoveBattleCountDownTimer()
    self:TryHideBattleMainWindow()
    UIManager:GetInstance():DestroyWindow(UIWindowNames.LWCityFightCountTimeToGo)
    return
  end
  if curStage == LLConst.LandlordStage.NONE or curStage == LLConst.LandlordStage.PREVIEW then
    return
  end
  local worldId = LuaEntry.Player:GetCurWorldId()
  local centerServerId = self:GetCenterServerId()
  if worldId ~= 0 or centerServerId == 0 then
    return
  end
  local curServerId = LuaEntry.Player:GetCurServerId()
  if not force and curServerId == self.lastServerId then
    return
  end
  if not self:IsInNewCenterMapPeriod(centerServerId) then
    return
  end
  self.lastServerId = curServerId
  EventManager:GetInstance():Broadcast(EventId.LandlordCurServerChanged)
  self:StopMainUIAnimTimer()
  if curServerId == centerServerId then
    self:BattleCountDownCheck()
    self:TryHideMainWindow()
  else
    self:RemoveBattleCountDownTimer()
    self:TryHideBattleMainWindow()
    UIManager:GetInstance():DestroyWindow(UIWindowNames.LWCityFightCountTimeToGo)
  end
end

function _CLASS:TryOpenAndShowBattleMainWindow()
  if BattleFieldUtil.InBattleField() or not SceneUtils.GetIsInWorld() then
    return
  end
  if not UIManager:GetInstance():IsWindowOpen(UIWindowNames.LWLLBattleMainUIView) then
    UIManager:GetInstance():OpenWindow(UIWindowNames.LWLLBattleMainUIView, {
      anim = true,
      UIMainAnim = UIMainAnimType.AllHide
    })
    self.isShowingLLMainUI = true
  else
    local llBattleMainUIView = UIManager:GetInstance():GetWindow(UIWindowNames.LWLLBattleMainUIView).View
    if llBattleMainUIView and llBattleMainUIView.alreadyLoaded then
      self.isShowingLLMainUI = true
      llBattleMainUIView:SetActive(true)
      llBattleMainUIView:UpdateLod(CS.SceneManager.World:GetLodLevel())
    end
  end
end

function _CLASS:TryHideBattleMainWindow()
  self.isShowingLLMainUI = false
  if UIManager:GetInstance():IsWindowOpen(UIWindowNames.LWLLBattleMainUIView) then
    local llBattleMainUIView = UIManager:GetInstance():GetWindow(UIWindowNames.LWLLBattleMainUIView).View
    if llBattleMainUIView then
      self:PlayLLMainUIAnim(UIMainAnimType.AllHide)
      self.mainUIAnimTimer = TimerManager:GetInstance():DelayInvoke(function()
        if llBattleMainUIView and llBattleMainUIView.alreadyLoaded then
          llBattleMainUIView:SetActive(false)
          llBattleMainUIView:TryHideMiniMap()
        end
        self:TryShowMainWindow()
      end, 0.5)
    else
      self:TryShowMainWindow()
    end
  else
    local uiMainAnim = UIManager:GetInstance():GetUIMainAnim()
    if uiMainAnim == nil then
      self:TryShowMainWindow()
    end
  end
end

function _CLASS:TryCloseBattleMainWindow()
  self.isShowingLLMainUI = false
  if UIManager:GetInstance():IsWindowOpen(UIWindowNames.LWLLBattleMainUIView) then
    UIManager:GetInstance():DestroyWindow(UIWindowNames.LWLLBattleMainUIView, {
      anim = false,
      UIMainAnim = UIMainAnimType.AllShow
    })
    self:TryShowMainWindow()
  end
end

function _CLASS:TryShowMainWindow()
  if BattleFieldUtil.InBattleField() then
    return
  end
  local isLuaShutDown = DataCenter.BuildManager == nil or DataCenter.BuildManager.MainLv == nil
  if isLuaShutDown then
    return
  end
  local mainUI = UIManager:GetInstance():GetWindow(UIWindowNames.UIMain)
  if mainUI then
    local mainUIView = mainUI.View
    if mainUIView and mainUIView.alreadyLoaded then
      mainUIView:SetActive(true)
      mainUIView:RecoverFromInactive()
    end
  end
end

function _CLASS:TryHideMainWindow()
  local mainUIView = UIManager:GetInstance():GetWindow(UIWindowNames.UIMain).View
  if mainUIView then
    mainUIView:OnPlayMainUIAnim({
      UIMainAnimType.AllHide,
      true
    })
    self.mainUIAnimTimer = TimerManager:GetInstance():DelayInvoke(function()
      if mainUIView and mainUIView.alreadyLoaded then
        mainUIView:SetActive(false)
        mainUIView:TryHideMiniMap()
        self:TryOpenAndShowBattleMainWindow()
      end
    end, 0.5)
  else
    self:TryOpenAndShowBattleMainWindow()
  end
end

function _CLASS:GetIsShowingLLMainUI()
  return self.isShowingLLMainUI
end

function _CLASS:PlayLLMainUIAnim(animName)
  local llBattleMainUI = UIManager:GetInstance():GetWindow(UIWindowNames.LWLLBattleMainUIView)
  if llBattleMainUI then
    local llBattleMainUIView = llBattleMainUI.View
    if llBattleMainUIView then
      llBattleMainUIView:PlayAnim(animName)
    end
  end
end

function _CLASS:BattleCountDownCheck()
  local curStage = self:GetActCurStageInfo()
  local centerServerId = self:GetCenterServerId()
  local targetSec, sSec
  if curStage ~= nil and centerServerId ~= 0 and centerServerId == LuaEntry.Player:GetCurServerId() then
    local cdSec
    if curStage.stage == LLConst.LandlordStage.PREPARE then
      cdSec = LLConst.PREPARE_BATTLE_COUNTDOWN
    elseif curStage.stage == LLConst.LandlordStage.BATTLE then
      cdSec = LLConst.BATTLE_END_COUNTDOWN
      local curWeek = self:GetCurWeek()
      sSec = self:GetWeekBattleStartTime(curWeek)
    end
    local curSec = UITimeManager:GetInstance():GetServerSeconds()
    if cdSec ~= nil then
      local pSec = curStage.eTime - cdSec
      if curSec < pSec then
        targetSec = pSec
      else
        self:BattleCountDownAction()
      end
    end
  end
  self.battleCountDownSec = targetSec
  self.curBattleStartSec = sSec
end

function _CLASS:CheckBattleTimeCtrl(curSec)
  if self.curBattleStartSec == nil or not SceneUtils.GetIsInWorld() then
    return
  end
  local preTime = 2
  local list = self:GetBattleTimeCtrlDic()
  local curWeek = tostring(self:GetCurWeek())
  local sTime = self.curBattleStartSec
  local config
  local isFly = false
  local ignoreBrod = false
  for _, v in pairs(list) do
    if v.para == curWeek then
      local rTime = sTime + v.trigger_time
      local stTime = rTime - v.alert_time
      if curSec == stTime then
        config = v
        isFly = true
        break
      elseif curSec > stTime and curSec < stTime + preTime then
        config = v
        ignoreBrod = true
        break
      elseif curSec >= stTime + preTime and curSec < rTime then
        config = v
        break
      end
    end
  end
  local data = self.TimeCtrlParamData
  if config ~= nil or ignoreBrod == false and data.config ~= config then
    data.config = config
    data.isFly = isFly
    EventManager:GetInstance():Broadcast(EventId.LandlordBattleTimeCtrlNotice, data)
  end
end

function _CLASS:BattleCountDownTimerAction()
  if self.battleCountDownSec == nil then
    return
  end
  local curSec = UITimeManager:GetInstance():GetServerSeconds()
  if curSec >= self.battleCountDownSec then
    self:BattleCountDownAction()
  end
end

function _CLASS:BattleCountDownAction()
  self:RemoveBattleCountDownTimer()
  if LuaEntry.Player:GetCurServerId() ~= self:GetCenterServerId() then
    return
  end
  local curStageInfo = self:GetActCurStageInfo()
  if curStageInfo == nil then
    return
  end
  local lastTips
  local stage = curStageInfo.stage
  if stage == LLConst.LandlordStage.PREPARE then
    lastTips = "new_city_activity_tips1009"
  elseif stage == LLConst.LandlordStage.BATTLE then
    lastTips = "458121"
  end
  if lastTips ~= nil then
    UIManager:GetInstance():OpenWindow(UIWindowNames.LWCityFightCountTimeToGo, {anim = true}, {
      protectTime = curStageInfo.eTime * 1000,
      finalTxt = stage == LLConst.LandlordStage.BATTLE and Localization:GetString("134012") or Localization:GetString("110058"),
      lastTips = lastTips
    })
  end
end

function _CLASS:RemoveBattleCountDownTimer()
  self.battleCountDownSec = nil
  self.curBattleStartSec = nil
end

function _CLASS:SetIsNewCenterMapPeriod(isNew, centerServerId, isSrcServerPush)
  local targetCenterServerId = tonumber(centerServerId) or 0
  if targetCenterServerId <= 0 then
    return
  end
  local firstEnter = centerServerId ~= self.centerServerId
  Logger.LogInfo("[LandlordRoom] centerServerId: " .. centerServerId)
  self.centerServerId = centerServerId
  self.isInNewCenterMapPeriod = self.isInNewCenterMapPeriod or {}
  local oldIsNew = self.isInNewCenterMapPeriod[targetCenterServerId] == true
  local newIsNew = isNew == true
  self.isInNewCenterMapPeriod[targetCenterServerId] = newIsNew
  local isChange = oldIsNew ~= newIsNew or firstEnter
  if not isChange then
    return
  end
  self:ClearCSharpLandlordManagerZoneData()
  local csInst = CS.LandlordManager.Instance
  if csInst then
    csInst.centerServerId = self.centerServerId
    csInst:SetIsNewCenterMapFlag(newIsNew, isSrcServerPush)
  end
  EventManager:GetInstance():Broadcast(EventId.LandlordCenterStateChange)
  local theWorld = CS.SceneManager.World
  if SceneUtils.GetIsInWorld() and theWorld then
    theWorld:OnChangeServerRemove()
    theWorld:SetFirstViewRequestFlag(true)
    theWorld:UpdateViewRequest(true)
  end
  if newIsNew then
    self:RefreshServerChange()
    if DataCenter.WorldAllianceCityDataManager then
      DataCenter.WorldAllianceCityDataManager:CleanLandlordCityOccupyData()
    end
  end
end

function _CLASS:IsInNewCenterMapPeriod(centerServerId)
  local targetCenterServerId = tonumber(centerServerId) or tonumber(self.centerServerId) or 0
  if targetCenterServerId <= 0 then
    return false
  end
  self.isInNewCenterMapPeriod = self.isInNewCenterMapPeriod or {}
  return self.isInNewCenterMapPeriod[targetCenterServerId] == true
end

function _CLASS:GetCenterServerId()
  return self.centerServerId
end

function _CLASS:IsUnlockCityByWeek(cityId)
  local tableName = self:GetCityTemplateTableName()
  if not string.IsNullOrEmpty(tableName) and cityId then
    local unlock_week = tonumber(GetTableData(tableName, cityId, "unlock_week")) or 0
    local curBattleWeek = self:GetCurWeek()
    return unlock_week <= curBattleWeek
  end
  return true
end

function _CLASS:GetCityUnlockWeek(cityId)
  local tableName = self:GetCityTemplateTableName()
  local unlock_week = tonumber(GetTableData(tableName, cityId, "unlock_week")) or 0
  return unlock_week
end

function _CLASS:IsLandlordCity(cityId, serverId)
  if serverId ~= self:GetCenterServerId() then
    return false
  end
  return self:GetCityTemplate(cityId) ~= nil
end

function _CLASS:GetLLCityNextOpenTimeByCityId(cityId)
  local isUnlockWeek = self:IsUnlockCityByWeek(cityId)
  if not isUnlockWeek then
    local unlockWeek = self:GetCityUnlockWeek(cityId)
    return self:GetWeekBattleStartTime(unlockWeek) * 1000
  else
    return self:GetNextBattleStartTime() * 1000
  end
end

function _CLASS:GetLLCurActEndTime()
  local curStageInfo = self:GetActCurStageInfo()
  if curStageInfo then
    return curStageInfo.eTime or 0
  end
  return 0
end

function _CLASS:_InitCalculateSpeedByKey(key, dic)
  local speedCalculateStr = LuaEntry.DataConfig:TryGetStr("zonewar_landlord", key, "")
  local speedCalculateArray = string.split(speedCalculateStr, "|")
  for k, v in ipairs(speedCalculateArray) do
    local array = string.string2array_num_oneSep(v, ";")
    if 3 <= #array then
      local threshold = array[2] == -1 and math.huge or array[2]
      table.insert(dic, {
        threshold,
        array[3]
      })
    end
  end
end

function _CLASS:InitCalculateSpeed()
  self.speedCalculateList = {}
  self.speedCalculateList[1] = {}
  self:_InitCalculateSpeedByKey("k2", self.speedCalculateList[1])
  self.speedCalculateList[2] = {}
  self:_InitCalculateSpeedByKey("k15", self.speedCalculateList[2])
end

function _CLASS:GetSpeedCalculateList(isThroneCity)
  if table.IsNullOrEmpty(self.speedCalculateList) then
    self:InitCalculateSpeed()
  end
  local idx = isThroneCity and 2 or 1
  return self.speedCalculateList[idx] or {}
end

function _CLASS:CalculateOccupySpeed(startOccupyTime, extraEffectValue, isThroneCity)
  local dic = self:GetSpeedCalculateList(isThroneCity)
  local curTime = UITimeManager:GetInstance():GetServerTime()
  local curOccupyTime = (curTime - startOccupyTime) / 1000
  local speed = 0
  for k, v in ipairs(dic) do
    if curOccupyTime < v[1] then
      speed = v[2]
      break
    end
  end
  speed = speed == 0 and dic[#dic][2] or speed
  local effectValue = 1 + (extraEffectValue or 0)
  return toInt(speed * effectValue)
end

function _CLASS:CalculateOccupyCurProgress(startOccupyTime, startOccupyProgress, maxProgress, campId, extraEffectValue, isThroneCity)
  local dic = self:GetSpeedCalculateList(isThroneCity)
  local isLord = campId == LLConst.LandLordGroup.LORD
  local curTime = UITimeManager:GetInstance():GetServerTime()
  local elapsedTime = (curTime - startOccupyTime) / 1000
  if elapsedTime <= 0 then
    local remainingProgress = 0
    local remainingTime = 0
    if isLord then
      remainingProgress = startOccupyProgress
      if 0 < remainingProgress then
        remainingTime = self:CalculateRemainingTime(0, remainingProgress, extraEffectValue, isThroneCity)
      end
    else
      remainingProgress = maxProgress - startOccupyProgress
      if 0 < remainingProgress then
        remainingTime = self:CalculateRemainingTime(0, remainingProgress, extraEffectValue, isThroneCity)
      end
    end
    return toInt(startOccupyProgress), toInt(remainingTime)
  end
  local effectValue = 1 + (extraEffectValue or 0)
  local totalProgress = 0
  local remainingTime = elapsedTime
  local currentOccupyDuration = 0
  local cnt = #dic
  for i = 1, cnt do
    if remainingTime <= 0 then
      break
    end
    local timeThreshold = dic[i][1]
    local speed = dic[i][2]
    if currentOccupyDuration < timeThreshold then
      local nextThreshold = i < cnt and dic[i + 1][1] or math.huge
      local segmentStartDuration = currentOccupyDuration
      local segmentEndDuration = math.min(currentOccupyDuration + remainingTime, timeThreshold, nextThreshold)
      if segmentStartDuration < segmentEndDuration then
        local segmentTime = segmentEndDuration - segmentStartDuration
        totalProgress = totalProgress + speed * segmentTime * effectValue
        remainingTime = remainingTime - segmentTime
        currentOccupyDuration = segmentEndDuration
      end
    end
  end
  if 0 < remainingTime then
    local lastSpeed = dic[cnt][2]
    totalProgress = totalProgress + lastSpeed * remainingTime * effectValue
  end
  local curProgress = 0
  local remainingProgress = 0
  local timeToComplete = 0
  if isLord then
    curProgress = startOccupyProgress - totalProgress
    curProgress = math.max(0, curProgress)
    remainingProgress = curProgress
    if 0 < remainingProgress then
      timeToComplete = self:CalculateRemainingTime(elapsedTime, remainingProgress, extraEffectValue, isThroneCity)
    end
  else
    curProgress = math.min(startOccupyProgress + totalProgress, maxProgress)
    remainingProgress = maxProgress - curProgress
    if 0 < remainingProgress then
      timeToComplete = self:CalculateRemainingTime(elapsedTime, remainingProgress, extraEffectValue, isThroneCity)
    end
  end
  return toInt(curProgress), toInt(timeToComplete)
end

function _CLASS:CalculateRemainingTime(startDuration, targetProgress, extraEffectValue, isThroneCity)
  local dic = self:GetSpeedCalculateList(isThroneCity)
  local effectValue = 1 + (extraEffectValue or 0)
  local remainingProgress = targetProgress
  local totalTime = 0
  local currentDuration = startDuration
  local cnt = #dic
  for i = 1, cnt do
    if remainingProgress <= 0 then
      break
    end
    local timeThreshold = dic[i][1]
    local speed = dic[i][2]
    if currentDuration < timeThreshold then
      local nextThreshold = i < cnt and dic[i + 1][1] or math.huge
      local segmentMaxDuration = math.min(timeThreshold, nextThreshold)
      local segmentMaxTime = segmentMaxDuration - currentDuration
      local segmentProgressPerSecond = speed * effectValue
      local segmentNeededTime = remainingProgress / segmentProgressPerSecond
      if segmentMaxTime >= segmentNeededTime then
        totalTime = totalTime + segmentNeededTime
        remainingProgress = 0
        break
      else
        local segmentProgress = segmentProgressPerSecond * segmentMaxTime
        totalTime = totalTime + segmentMaxTime
        remainingProgress = remainingProgress - segmentProgress
        currentDuration = segmentMaxDuration
      end
    end
  end
  if 0 < remainingProgress then
    local lastSpeed = dic[cnt][2]
    local lastProgressPerSecond = lastSpeed * effectValue
    totalTime = totalTime + remainingProgress / lastProgressPerSecond
  end
  return toInt(totalTime)
end

function _CLASS:SecondToFmtString(secs)
  if secs == nil or secs == 0 or secs < 0 then
    return "00:00"
  end
  local temp = ""
  local day = math.modf(secs / OneDayTime)
  local hour = math.modf(secs / 3600) % 24
  local minute = math.modf(secs / 60) % 60
  local second = math.floor(secs % 60)
  if secs >= OneDayTime then
    temp = string.format("%dd\194\160%02d:%02d:%02d", day, hour, minute, second)
  elseif secs >= OneHourTime then
    temp = string.format("%02d:%02d:%02d", hour, minute, second)
  else
    temp = string.format("%02d:%02d", minute, second)
  end
  return temp
end

function _CLASS:RecordLandlordStatusId(statusId)
  self.actBuffRecordList[statusId] = true
end

function _CLASS:IsLandlordStatus(statusId)
  return self.actBuffRecordList[statusId] == true
end

function _CLASS:TryGetCampRoom()
  local actInfo = self:GetActData()
  if not actInfo then
    return nil
  end
  local myGroupIdx = self:GetMyGroup()
  local stage = self:GetActCurStage()
  if stage <= LLConst.LandlordStage.GROUP or myGroupIdx == LLConst.LandLordGroup.NONE then
    return nil
  end
  local centerServerId = DataCenter.SeasonDataManager:GetNinePalacesServer(5, ServerEnum.Source)
  local actStartTime = self:GetActStartTime()
  return string.format("%s%s_%s_%s", ChatInterface.GetRoomIdPrefix(), myGroupIdx == LLConst.LandLordGroup.LORD and ChatGroupType.GROUP_LANDLORD_LORD or ChatGroupType.GROUP_LANDLORD_FARMER, centerServerId, actStartTime)
end

function _CLASS:GotoChatRoom()
  local roomId = self:TryGetCampRoom()
  if roomId then
    GoToUtil.OpenChatView(true, {anim = false, immediately = true}, {roomId = roomId, scrollToActive = true})
  end
end

function _CLASS:IsExploding(pointInfo)
  local now = UITimeManager:GetInstance():GetServerTime()
  local tableName = self:GetCityTemplateTableName()
  local boom_time = GetTableData(tableName, pointInfo.cityId, "boom_time")
  local isExploding = pointInfo.ownerCampId == LLConst.LandLordGroup.FARMER and pointInfo.state == LLConst.ZWLBuildingState.OVER and now >= pointInfo.overTime + boom_time * 1000 and now < pointInfo.overTime + (boom_time + LLConst.BoomingTime) * 1000
  return isExploding
end

function _CLASS:IsWillExplode(pointInfo)
  local now = UITimeManager:GetInstance():GetServerTime()
  local tableName = self:GetCityTemplateTableName()
  local boom_time = GetTableData(tableName, pointInfo.cityId, "boom_time")
  local isWillExplode = pointInfo.ownerCampId == LLConst.LandLordGroup.FARMER and pointInfo.state == LLConst.ZWLBuildingState.OVER and now >= pointInfo.overTime and now < pointInfo.overTime + boom_time * 1000
  return isWillExplode
end

function _CLASS:IsRuins(pointInfo)
  local now = UITimeManager:GetInstance():GetServerTime()
  local tableName = self:GetCityTemplateTableName()
  local boom_time = GetTableData(tableName, pointInfo.cityId, "boom_time")
  local isCity = pointInfo.type == WorldAllianceCityType.LLNormalCity or pointInfo.type == WorldAllianceCityType.LLThroneCity
  return isCity and pointInfo.state == LLConst.ZWLBuildingState.RUIN or pointInfo.state == LLConst.ZWLBuildingState.OVER and pointInfo.ownerCampId == LLConst.LandLordGroup.FARMER and now >= pointInfo.overTime + (boom_time + LLConst.BoomingTime) * 1000
end

function _CLASS:IsRebuilding(pointInfo)
  return pointInfo.state == LLConst.ZWLBuildingState.FIX
end

function _CLASS:IsFighting(pointInfo)
  local isInBattleStageAndUnlock = DataCenter.LandlordMgr:GetActCurStage() == LLConst.LandlordStage.BATTLE and DataCenter.LandlordMgr:IsUnlockCityByWeek(pointInfo.cityId)
  local curTime = UITimeManager:GetInstance():GetServerTime()
  return pointInfo.state == LLConst.ZWLBuildingState.NORMAL and isInBattleStageAndUnlock and curTime > pointInfo.unlockTime
end

function _CLASS:IsOpenButShield(pointInfo)
  local curTime = UITimeManager:GetInstance():GetServerTime()
  local leftTime = (pointInfo.unlockTime - curTime) / 1000
  return 0 < leftTime
end

function _CLASS:DeriveState(pointInfo)
  local curState = LLConst.LLBuildingState.NotOpen
  if self:IsExploding(pointInfo) then
    curState = LLConst.LLBuildingState.Exploding
  elseif self:IsWillExplode(pointInfo) then
    curState = LLConst.LLBuildingState.WillExplode
  elseif self:IsRuins(pointInfo) then
    curState = LLConst.LLBuildingState.Ruins
  elseif self:IsRebuilding(pointInfo) then
    curState = LLConst.LLBuildingState.Rebuilding
  elseif self:IsFighting(pointInfo) then
    curState = LLConst.LLBuildingState.Fighting
  elseif self:IsOpenButShield(pointInfo) then
    curState = LLConst.LLBuildingState.OpenButShield
  end
  return curState
end

function _CLASS:OnActStageChange(oldActIdx)
  if oldActIdx ~= LLConst.LandlordStage.UN_INIT and self:GetActCurStage() == LLConst.LandlordStage.REST then
    UIUtil.ShowTipsId("zonewar_landlord_tips_1010")
  end
end

function _CLASS:RefreshPlayerTypeCache()
  local curIdx = self:GetActCurStage()
  if (curIdx == LLConst.LandlordStage.PREPARE or curIdx == LLConst.LandlordStage.BATTLE or curIdx == LLConst.LandlordStage.REST) and CS.SceneManager and CS.SceneManager.World then
    CS.SceneManager.World:CleanAllianceCacheData()
    CS.SceneManager.World:SetFirstViewRequestFlag(true)
    CS.SceneManager.World:UpdateViewRequest(true)
  end
end

function _CLASS:CheckPlayerTypeClearCacheTime()
  local curIdx = self:GetActCurStage()
  if curIdx == LLConst.LandlordStage.PREPARE then
    local oldState = self.clearPrepareStagePlayerTypeFlag
    local curTimeSeconds = UITimeManager:GetInstance():GetServerSeconds()
    local battleStartTime = self:GetNextBattleStartTime()
    self.clearPrepareStagePlayerTypeFlag = curTimeSeconds > battleStartTime - self.preBattleTimeMinute * 60
    if oldState ~= nil and oldState ~= self.clearPrepareStagePlayerTypeFlag then
      self:RefreshPlayerTypeCache()
    end
  end
end

function _CLASS:IsInCenterServerPeriod()
  local curStage = self:GetActCurStage()
  if curStage ~= LLConst.LandlordStage.PREPARE and curStage ~= LLConst.LandlordStage.BATTLE then
    return false
  end
  local curTimeSeconds = UITimeManager:GetInstance():GetServerSeconds()
  if curStage == LLConst.LandlordStage.PREPARE then
    local battleStartTime = self:GetNextBattleStartTime()
    return curTimeSeconds > battleStartTime - self.preBattleTimeMinute * 60
  end
  return true
end

function _CLASS:DescriptionBattle(sb)
  sb:AppendLine("-----\230\136\152\230\150\151\228\191\161\230\129\175\229\188\128\229\167\139-----")
  sb:AppendFormatLine("  \228\184\173\229\191\131\230\156\141ID : %s", self.centerServerId or 0)
  sb:AppendFormatLine("  \230\152\175\229\144\166\229\186\148\231\148\168\230\150\176\231\154\132\228\184\173\229\191\131\229\156\176\229\155\190\233\128\187\232\190\145 : %s", self:IsInNewCenterMapPeriod(self.centerServerId) and "\230\152\175" or "\229\144\166")
  sb:AppendFormatLine("  \230\152\175\229\144\166\230\152\190\231\164\186LL\228\184\187UI : %s", self.isShowingLLMainUI and "\230\152\175" or "\229\144\166")
  sb:AppendLine("  \233\162\132\229\145\138\231\136\134\231\130\184\229\174\154\230\151\182\229\153\168\231\138\182\230\128\129\239\188\154")
  if self.previewBoomTimer then
    sb:AppendLine("    \229\183\178\232\174\190\231\189\174")
  else
    sb:AppendLine("    \230\156\170\232\174\190\231\189\174")
  end
  sb:AppendLine("  \233\147\129\229\185\149\231\155\184\229\133\179\239\188\154")
  if self.ironCurtainMat and not IsNull(self.ironCurtainMat) then
    sb:AppendLine("    \230\157\144\232\180\168\229\183\178\229\138\160\232\189\189")
  else
    sb:AppendLine("    \230\157\144\232\180\168\230\156\170\229\138\160\232\189\189")
  end
  if self.ironCurtainReq then
    sb:AppendLine("    \230\157\144\232\180\168\229\138\160\232\189\189\232\175\183\230\177\130\228\184\173")
  end
  local hasIronCurtainStatus = self:IsCurHaveIronCurtainStatus()
  sb:AppendFormatLine("    \229\189\147\229\137\141\230\152\175\229\144\166\230\156\137\233\147\129\229\185\149\231\138\182\230\128\129 : %s", hasIronCurtainStatus and "\230\152\175" or "\229\144\166")
  if hasIronCurtainStatus then
    local endTime = self:GetCurIronCurtainStatusEndTime()
    sb:AppendFormatLine("    \233\147\129\229\185\149\231\138\182\230\128\129\231\187\147\230\157\159\230\151\182\233\151\180 : %s", 0 < endTime and UITimeManager:GetInstance():MilliSecondToFmtString(endTime) or "\230\151\160")
  end
  sb:AppendLine("  \229\141\160\233\162\134\233\128\159\229\186\166\232\174\161\231\174\151\233\133\141\231\189\174\239\188\154")
  if table.IsNullOrEmpty(self.speedCalculateList) then
    sb:AppendLine("    \230\156\170\229\136\157\229\167\139\229\140\150")
  else
    for j, dic in ipairs(self.speedCalculateList) do
      sb:AppendFormatLine("    %s:", j == 1 and "\230\153\174\233\128\154\229\187\186\231\173\145" or "\231\142\139\229\186\167")
      for i, v in ipairs(dic) do
        sb:AppendFormatLine("    \230\174\181[%s]: \230\151\182\233\151\180\233\152\136\229\128\188=%s\231\167\146, \233\128\159\229\186\166=%s", i, v[1] or "\230\151\160", v[2] or "\230\151\160")
      end
    end
  end
  sb:AppendLine("-----\230\136\152\230\150\151\228\191\161\230\129\175\231\187\147\230\157\159-----")
end

return _CLASS
