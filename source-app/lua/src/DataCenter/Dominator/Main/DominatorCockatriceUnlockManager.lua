local DominatorCockatriceUnlockManager = BaseClass("DominatorCockatriceUnlockManager")
local DominatorInfo = require("DataCenter/Dominator/Main/DominatorInfo")
local DominatorGorillaInfo = require("DataCenter/Dominator/Main/DominatorGorillaInfo")
local DominatorTrainInfo = require("DataCenter/Dominator/Train/DominatorTrainInfo")
local Localization = CS.GameEntry.Localization
DominatorCockatriceUnlockManager.TaskGroupState = {
  Finished = 0,
  Going = 1,
  Waiting = 2,
  Locked = 3
}
DominatorCockatriceUnlockManager.FinalTimelinePath = "Assets/Main/CoditionLoadRes/Dominator/Hawk/Prefabs/Timeline/xunzhaohuoban_timeline.prefab"
DominatorCockatriceUnlockManager.FinalPlotGroupIds = {
  2805,
  2806,
  2807
}

function DominatorCockatriceUnlockManager:__init()
  self.dominatorGuid = nil
  self.allDetectEventIdDict = nil
  self.curClaimingQuestGroupIndex = nil
  self.curClaimingTaskIndex = nil
  
  function self.FuncOnPlotGroupDone(plotGroupId)
    self:OnPlotGroupDone(plotGroupId)
  end
  
  EventManager:GetInstance():AddListener(EventId.PlotGroupDone, self.FuncOnPlotGroupDone)
  EventManager:GetInstance():AddListener(EventId.PlotViewClosedAbnormally, self.FuncOnPlotGroupDone)
end

function DominatorCockatriceUnlockManager:__delete()
  EventManager:GetInstance():RemoveListener(EventId.PlotGroupDone, self.FuncOnPlotGroupDone)
  EventManager:GetInstance():RemoveListener(EventId.PlotViewClosedAbnormally, self.FuncOnPlotGroupDone)
  self.dominatorGuid = nil
  self.allDetectEventIdDict = nil
  self.curClaimingQuestGroupIndex = nil
  self.curClaimingTaskIndex = nil
end

function DominatorCockatriceUnlockManager:IsShowMainUIEntrance()
  if self.dominatorGuid == DominatorCockatriceUnlockProgress.End then
    return false
  end
  local dominatorInfo = DataCenter.DominatorManager:GetInfoById(DominatorId.Cockatrice)
  if dominatorInfo then
    if not dominatorInfo:IsUnlocked() then
      return true
    end
    local finalEventInfo = self:GetFinalDetectEventInfo()
    if finalEventInfo ~= nil and finalEventInfo.state == DetectEventState.DETECT_EVENT_STATE_FINISHED then
      return true
    end
  end
  return false
end

function DominatorCockatriceUnlockManager:OnMainUIEntranceClick()
  if not self:IsShowMainUIEntrance() then
    return
  end
  if CrossServerUtil:NeedIntercept("alliance_AssemblyPoint_tips_05") then
    return
  end
  if DataCenter.ActMeteoriteBattleManager:IsInMeteoriteBattle() and DataCenter.ActMeteoriteBattleManager:IsInArea() then
    UIUtil.ShowMessage(Localization:GetString("war_eagle_event_desc_17"))
    return
  elseif LuaEntry.Player:IsInBlackRange() then
    UIUtil.ShowMessage(Localization:GetString("war_eagle_event_desc_17"))
    return
  end
  UIManager:GetInstance():OpenWindow(UIWindowNames.UILWDominatorCockatriceUnlockMain, {anim = true})
end

function DominatorCockatriceUnlockManager:UpdateGuideProgress(message, isFromInit)
  if message and message.commonDominatorGuid then
    if not message.commonDominatorGuid[tostring(DominatorId.Cockatrice)] then
      return
    end
    local needBroadEvent = false
    if self.dominatorGuid ~= message.commonDominatorGuid[tostring(DominatorId.Cockatrice)] and not isFromInit then
      needBroadEvent = true
    end
    self.dominatorGuid = message.commonDominatorGuid[tostring(DominatorId.Cockatrice)]
    if needBroadEvent then
      EventManager:GetInstance():Broadcast(EventId.DominatorCommonGuideProgressChanged)
    end
  end
end

function DominatorCockatriceUnlockManager:SendSetGuideProgressMessage(progress)
  if self.dominatorGuid ~= nil and progress <= self.dominatorGuid then
    DataCenter.DominatorManager:PrintRealErrorLog("cockatrice guide progress must bigger then current")
    return
  end
  SFSNetwork.SendMessage(MsgDefines.CommonDominatorGuid, {
    dominatorId = DominatorId.Cockatrice,
    guid = progress
  })
end

function DominatorCockatriceUnlockManager:GetCurGuideId()
  return self.dominatorGuid
end

function DominatorCockatriceUnlockManager:GetFinalDetectEventId()
  if self.finalDetectEventId == nil then
    self.finalDetectEventId = checknumber(LuaEntry.DataConfig:TryGetStr("dominator_2_unlock_para", "k5", ""))
  end
  return self.finalDetectEventId
end

function DominatorCockatriceUnlockManager:GetAllNormalDetectEventIdDict()
  if self.allDetectEventIdDict == nil then
    self.allDetectEventIdDict = {}
    local configValue = LuaEntry.DataConfig:TryGetStr("dominator_2_unlock_para", "k4", "")
    if not string.IsNullOrEmpty(configValue) then
      local strSplit = string.split(configValue, "|")
      for i, v in ipairs(strSplit) do
        self.allDetectEventIdDict[i] = checknumber(v)
      end
    end
  end
  return self.allDetectEventIdDict
end

function DominatorCockatriceUnlockManager:GetNormalDetectEventIdByIndex(index)
  local idDict = self:GetAllNormalDetectEventIdDict()
  return idDict[index]
end

function DominatorCockatriceUnlockManager:GetAllNormalQuestIdDict()
  if self.allQuestIdDict == nil then
    self.allQuestIdDict = {}
    local configValue = LuaEntry.DataConfig:TryGetStr("dominator_2_unlock_para", "k3", "")
    if not string.IsNullOrEmpty(configValue) then
      local strSplit = string.split(configValue, "|")
      for i, v in ipairs(strSplit) do
        local strSplitSub = string.split(v, ";")
        local questIds = {}
        for _, str in ipairs(strSplitSub) do
          table.insert(questIds, tonumber(str))
        end
        self.allQuestIdDict[i] = questIds
      end
    end
  end
  return self.allQuestIdDict
end

function DominatorCockatriceUnlockManager:GetNormalQuestGroupCount()
  local allQuestDict = self:GetAllNormalQuestIdDict()
  return table.count(allQuestDict)
end

function DominatorCockatriceUnlockManager:GetCurFinishedNormalQuestGroupIndex()
  local info = DataCenter.DominatorManager:GetInfoById(DominatorId.Cockatrice)
  if info then
    return info:GetCurFinishedQuestIndex()
  end
  return 0
end

function DominatorCockatriceUnlockManager:IsFinishedNormalQuestGroupByIndex(index)
  local curIndex = self:GetCurFinishedNormalQuestGroupIndex()
  return index <= curIndex
end

function DominatorCockatriceUnlockManager:IsFinishedNormalQuestTaskByIndex(index)
  local questDict = self:GetAllNormalQuestIdDict()
  if questDict and questDict[index] then
    local isFinished = true
    for i, v in ipairs(questDict[index]) do
      local taskData = DataCenter.TaskManager:FindTaskInfo(v)
      if taskData and taskData.state ~= TaskState.Received then
        isFinished = false
        break
      end
    end
    return isFinished
  end
  return false
end

function DominatorCockatriceUnlockManager:IsFinishedAllNormalQuest()
  return self:GetCurFinishedNormalQuestGroupIndex() >= self:GetNormalQuestGroupCount()
end

function DominatorCockatriceUnlockManager:GetFinalDetectEventInfo()
  local eventId = self:GetFinalDetectEventId()
  if eventId then
    local eventInfoArray = DataCenter.RadarCenterDataManager:GetDetectEventsInfoByEventId(eventId)
    if eventInfoArray[1] then
      return eventInfoArray[1]
    end
  end
  return nil
end

function DominatorCockatriceUnlockManager:GetQuestGroupIconPath(index)
  if index == 1 then
    return "Assets/Main/CoditionLoadRes/Dominator/Hawk/Sprites/LWUIDominatorCockatriceUnlock/zxl_s3_daoju_icon1.png"
  elseif index == 2 then
    return "Assets/Main/CoditionLoadRes/Dominator/Hawk/Sprites/LWUIDominatorCockatriceUnlock/zxl_s3_daoju_icon2.png"
  elseif index == 3 then
    return "Assets/Main/CoditionLoadRes/Dominator/Hawk/Sprites/LWUIDominatorCockatriceUnlock/zxl_s3_daoju_icon3.png"
  elseif index == 4 then
    return "Assets/Main/CoditionLoadRes/Dominator/Hawk/Sprites/LWUIDominatorCockatriceUnlock/zxl_s3_daoju_icon4.png"
  end
end

function DominatorCockatriceUnlockManager:GetQuestGroupBackgroundPath(index)
  if index == 1 then
    return "Assets/Main/CoditionLoadRes/Dominator/Hawk/Texture/zxl_s3_pintu1.png"
  elseif index == 2 then
    return "Assets/Main/CoditionLoadRes/Dominator/Hawk/Texture/zxl_s3_pintu2.png"
  elseif index == 3 then
    return "Assets/Main/CoditionLoadRes/Dominator/Hawk/Texture/zxl_s3_pintu3.png"
  elseif index == 4 then
    return "Assets/Main/CoditionLoadRes/Dominator/Hawk/Texture/zxl_s3_pintu4.png"
  end
end

function DominatorCockatriceUnlockManager:GetQuestGroupUnlockTime(index)
  local questGroupUnlockTimeDict = {}
  local info = DataCenter.DominatorManager:GetInfoById(DominatorId.Cockatrice)
  if info and info.unlockTime then
    local splitStr = string.split(info.unlockTime, ";")
    for i, v in ipairs(splitStr) do
      table.insert(questGroupUnlockTimeDict, tonumber(v))
    end
  end
  return questGroupUnlockTimeDict[index]
end

function DominatorCockatriceUnlockManager:GetVisitorEventId()
  if self.visitorId == nil then
    self.visitorId = 0
    local configValue = LuaEntry.DataConfig:TryGetStr("dominator_2_unlock_para", "k2", "")
    if not string.IsNullOrEmpty(configValue) then
      local splitStr = string.split(configValue, ";")
      if splitStr[1] then
        self.visitorId = checknumber(splitStr[1])
      end
    end
  end
  return self.visitorId
end

function DominatorCockatriceUnlockManager:GetTaskGroupState(index)
  local unlockTime = self:GetQuestGroupUnlockTime(index)
  if not unlockTime then
    return self.TaskGroupState.Finished
  end
  if unlockTime <= 0 then
    return self.TaskGroupState.Waiting
  end
  local nowTime = UITimeManager:GetInstance():GetServerTime()
  local isUnlocked = unlockTime <= nowTime
  if not isUnlocked then
    return self.TaskGroupState.Locked
  else
    local curFinishedIndex = self:GetCurFinishedNormalQuestGroupIndex()
    if index == curFinishedIndex + 1 then
      return self.TaskGroupState.Going
    elseif index <= curFinishedIndex then
      return self.TaskGroupState.Finished
    else
      return self.TaskGroupState.Waiting
    end
  end
end

function DominatorCockatriceUnlockManager:GetGroupShowRedCount(index)
  local res = 0
  local curState = DataCenter.DominatorCockatriceUnlockManager:GetTaskGroupState(index)
  if curState == self.TaskGroupState.Going then
    local questDict = self:GetAllNormalQuestIdDict()
    if questDict and questDict[index] then
      for i, v in ipairs(questDict[index]) do
        local taskData = DataCenter.TaskManager:FindTaskInfo(v)
        if taskData ~= nil and taskData.state == TaskState.CanReceive then
          res = res + 1
        end
      end
    end
    local eventId = self:GetNormalDetectEventIdByIndex(index)
    if eventId then
      local eventInfoArray = DataCenter.RadarCenterDataManager:GetDetectEventsInfoByEventId(eventId)
      if eventInfoArray and eventInfoArray[1] then
        local eventInfo = eventInfoArray[1]
        if eventInfo and eventInfo.state == DetectEventState.DETECT_EVENT_STATE_FINISHED then
          res = res + 1
        end
      end
    end
  end
  return res
end

function DominatorCockatriceUnlockManager:OnPlotGroupDone(plotGroupId)
  local isSelfPlot = false
  for i, v in pairs(self.FinalPlotGroupIds) do
    if checknumber(plotGroupId) == v then
      isSelfPlot = true
      break
    end
  end
  if isSelfPlot then
    local isFinalPlot = self.FinalPlotGroupIds[3] == checknumber(plotGroupId)
    if not isFinalPlot then
      if self.timelineDuration and self.blockerHandleId == nil then
        self.blockerHandleId = UIManager:GetInstance():EnableInteractionBlocker(2, self.timelineDuration)
      end
      if not IsNull(self.listener) then
        self.listener:Play()
      end
    elseif not IsNull(self.listener) then
      self.listener:Stop()
    end
  end
end

function DominatorCockatriceUnlockManager:OnTriggerTimelineEvent01()
  if IsNull(self.listener) then
    return
  end
  self.listener:Pause()
  EventManager:GetInstance():Broadcast(EventId.PlayPlotGroup, {
    plotGroupId = self.FinalPlotGroupIds[1],
    hideMainUI = true,
    UIMainAnim = UIMainAnimType.AllHide
  })
  if self.blockerHandleId then
    UIManager:GetInstance():DisableInteractionBlocker(self.blockerHandleId)
    self.blockerHandleId = nil
  end
end

function DominatorCockatriceUnlockManager:OnTriggerTimelineEvent02()
  if IsNull(self.listener) then
    return
  end
  self.listener:Pause()
  EventManager:GetInstance():Broadcast(EventId.PlayPlotGroup, {
    plotGroupId = self.FinalPlotGroupIds[2],
    hideMainUI = true,
    UIMainAnim = UIMainAnimType.AllHide
  })
  if self.blockerHandleId then
    UIManager:GetInstance():DisableInteractionBlocker(self.blockerHandleId)
    self.blockerHandleId = nil
  end
end

function DominatorCockatriceUnlockManager:OnTriggerTimelineEvent03()
  if IsNull(self.listener) then
    return
  end
  EventManager:GetInstance():Broadcast(EventId.PlayPlotGroup, {
    plotGroupId = self.FinalPlotGroupIds[3],
    hideMainUI = true,
    UIMainAnim = UIMainAnimType.AllHide
  })
  if self.blockerHandleId then
    UIManager:GetInstance():DisableInteractionBlocker(self.blockerHandleId)
    self.blockerHandleId = nil
  end
end

function DominatorCockatriceUnlockManager:DoFinalTimeline(pointId, uuid)
  self.pointObject = CS.SceneManager.World:GetObjectByPoint(pointId)
  local worldPos = SceneUtils.TileIndexToWorld(pointId, ForceChangeScene.World)
  local timeline = CS.GameEntry.Resource:InstantiateAsync(self.FinalTimelinePath)
  timeline:completed("+", function(handle)
    if handle.isError then
      DataCenter.DominatorManager:PrintRealErrorLog("load res failed:" .. self.FinalTimelinePath)
      return
    end
    local director = handle.gameObject:GetComponentInChildren(typeof(CS.UnityEngine.Playables.PlayableDirector))
    self.director = director
    self.listener = handle.gameObject:GetComponentInChildren(typeof(CS.DominatorCockatriceUnlockTimelineAnimationListener))
    if not IsNull(self.listener) then
      function self.listener.animationMarker01()
        self:OnTriggerTimelineEvent01()
      end
      
      function self.listener.animationMarker02()
        self:OnTriggerTimelineEvent02()
      end
      
      function self.listener.animationMarker03()
        self:OnTriggerTimelineEvent03()
      end
    end
    handle.gameObject.transform.position = worldPos
    local camInTimeline = handle.gameObject:GetComponentInChildren(typeof(CS.UnityEngine.Camera))
    self.timelineSyncHandle = CS.SceneManager.World:EnterTimeline(camInTimeline, 1)
    camInTimeline.enabled = false
    self:PlayMainUIAnim(false)
    self.timelineDuration = director.duration
    self.blockerHandleId = UIManager:GetInstance():EnableInteractionBlocker(2, self.timelineDuration)
    self.pointObject = CS.SceneManager.World:GetObjectByPoint(pointId)
    if self.pointObject ~= nil then
      self.pointObject:SetVisible(false)
    end
    SFSNetwork.SendMessage(MsgDefines.StartDetectEventTalk, uuid)
    director:stopped("+", function()
      handle:RealDestroy()
      if self.timelineSyncHandle ~= nil and not IsNull(CS.SceneManager.World) then
        CS.SceneManager.World:ExitTimeline(self.timelineSyncHandle)
        self.timelineSyncHandle = nil
      end
      if self.blockerHandleId then
        UIManager:GetInstance():DisableInteractionBlocker(self.blockerHandleId)
      end
      self:PlayMainUIAnim(true)
      SFSNetwork.SendMessage(MsgDefines.EndDetectEventTalk, uuid)
    end)
    director:Play()
  end)
end

function DominatorCockatriceUnlockManager:PlayMainUIAnim(isShow)
  local uiMain = UIManager:GetInstance():GetWindow(UIWindowNames.UIMain)
  if uiMain and uiMain.View then
    if isShow then
      uiMain.View:PlayAnim(UIMainAnimType.AllShow, true)
    else
      uiMain.View:PlayAnim(UIMainAnimType.AllHide, true)
    end
  end
end

function DominatorCockatriceUnlockManager:SetCurClaimingQuestGroupIndex(index)
  self.curClaimingQuestGroupIndex = index
end

function DominatorCockatriceUnlockManager:GetCurClaimingQuestGroupIndex()
  return self.curClaimingQuestGroupIndex
end

function DominatorCockatriceUnlockManager:SetCurClaimingTaskIndex(index)
  self.curClaimingTaskIndex = index
end

function DominatorCockatriceUnlockManager:GetCurClaimingTaskIndex()
  return self.curClaimingTaskIndex
end

function DominatorCockatriceUnlockManager:IsHasShownQuestGroupUnlockEffect(index)
  local key = "dominator_cockatrice_unlock_quest_group_effect_unlock_" .. index
  return CS.GameEntry.Setting:GetBool(key .. LuaEntry.Player.uid, false)
end

function DominatorCockatriceUnlockManager:SetHasShownQuestGroupUnlockEffect(index)
  local key = "dominator_cockatrice_unlock_quest_group_effect_unlock_" .. index
  CS.GameEntry.Setting:SetBool(key .. LuaEntry.Player.uid, true)
end

function DominatorCockatriceUnlockManager:IsHasShownArchiveGuide()
  local key = "dominator_cockatrice_unlock_archive_guide"
  return CS.GameEntry.Setting:GetBool(key .. LuaEntry.Player.uid, false)
end

function DominatorCockatriceUnlockManager:SetHasShownArchiveGuide()
  local key = "dominator_cockatrice_unlock_archive_guide"
  CS.GameEntry.Setting:SetBool(key .. LuaEntry.Player.uid, true)
end

return DominatorCockatriceUnlockManager
