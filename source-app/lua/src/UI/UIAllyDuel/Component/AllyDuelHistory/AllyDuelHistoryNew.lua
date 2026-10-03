local AllyDuelHistory = BaseClass("AllyDuelHistory", UIBaseContainer)
local base = UIBaseContainer
local REFRESH_CD = 5
local VIEW_IDX = {
  TODAY = 1,
  WEEK = 2,
  READY1 = 3,
  READY2 = 4
}
local CLS = {
  "UI.UIAllyDuel.Component.AllyDuelHistory.AllyDuelHistoryToday",
  "UI.UIAllyDuel.Component.AllyDuelHistory.AllyDuelHistoryCurWeek",
  "UI.UIAllyDuel.Component.AllyDuelHistory.AllyDuelHistoryReady1",
  "UI.UIAllyDuel.Component.AllyDuelHistory.AllyDuelHistoryReady2"
}
local PREFAB = {
  "Assets/Main/Prefabs/UI/UIAllyDuel/AllyDuelHistoryToday.prefab",
  "Assets/Main/Prefabs/UI/UIAllyDuel/AllyDuelHistoryCurWeek.prefab",
  "Assets/Main/Prefabs/UI/UIAllyDuel/AllyDuelHistoryReady1.prefab",
  "Assets/Main/Prefabs/UI/UIAllyDuel/AllyDuelHistoryReady2.prefab"
}

function AllyDuelHistory:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function AllyDuelHistory:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function AllyDuelHistory:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.toggleToggle1 = self.viewSkin:AddComponent(self, UIToggle, 1)
  self.toggleToggle2 = self.viewSkin:AddComponent(self, UIToggle, 2)
  self.compVSContent = self.viewSkin:AddComponent(self, UIBaseContainer, 3)
  self.compContent = self.viewSkin:AddComponent(self, UIBaseContainer, 4)
end

function AllyDuelHistory:ComponentDestroy()
  self.viewSkin = nil
  self.toggleToggle1 = nil
  self.toggleToggle2 = nil
  self.compVSContent = nil
  self.compContent = nil
end

function AllyDuelHistory:DataDefine()
  self.refreshCD = REFRESH_CD
  self.curIdx = 0
  self.comps = {}
  self.toggleToggle1:SetOnValueChanged(function(tf)
    if tf then
      DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
      self:OnToggleIdx(VIEW_IDX.TODAY)
    end
  end)
  self.toggleToggle2:SetOnValueChanged(function(tf)
    if tf then
      DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
      self:OnToggleIdx(VIEW_IDX.WEEK)
    end
  end)
end

function AllyDuelHistory:DataDestroy()
  self.curIdx = 0
  self.comps = nil
end

function AllyDuelHistory:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.RefreshAllianceArmsUI, self.Init)
  self:AddUIListener(EventId.OnUpdateActivityEventData, self.Init)
  self:AddUIListener(EventId.AllianceCompeteWeeklySummaryUpdated, self.UpdateInfo)
  self:AddUIListener(EventId.OnPassDay, self.AutoRefresh)
end

function AllyDuelHistory:OnRemoveListener()
  self:RemoveUIListener(EventId.RefreshAllianceArmsUI, self.Init)
  self:RemoveUIListener(EventId.OnUpdateActivityEventData, self.Init)
  self:RemoveUIListener(EventId.AllianceCompeteWeeklySummaryUpdated, self.UpdateInfo)
  self:RemoveUIListener(EventId.OnPassDay, self.AutoRefresh)
  base.OnRemoveListener(self)
end

function AllyDuelHistory:OnToggleIdx(idx)
  if self.curIdx ~= idx then
    local comp = self.comps[self.curIdx]
    if comp ~= nil and comp:AsyncLoadDone() then
      comp:SetActive(false)
    end
  end
  self.curIdx = idx
  local comp = self.comps[self.curIdx]
  if comp ~= nil then
    if comp:AsyncLoadDone() then
      comp:SetActive(true)
      comp:UpdateData()
      if comp.RefreshReadyState then
        comp:RefreshReadyState(self.state)
      end
    end
    return
  end
  local cls = CLS[idx]
  local prefab = PREFAB[idx]
  local content = self.curIdx <= VIEW_IDX.WEEK and self.compVSContent or self.compContent
  self.comps[idx] = self:LoadComponentAsync(cls, prefab, content, function(_, go)
    comp = self.comps[idx]
    if comp ~= nil then
      comp:SetOffsetMinXY(0, 0)
      comp:SetOffsetMaxXY(0, 0)
      if comp.RefreshReadyState then
        comp:RefreshReadyState(self.state)
      end
    end
    go:SetActive(self.curIdx == idx)
  end)
end

function AllyDuelHistory:ShowPanel()
  self:Init()
  self:AutoRefresh()
end

function AllyDuelHistory:UpdateInfo()
  self.actInfo = DataCenter.ActivityListDataManager:GetActivityDataById(EnumActivity.AllianceCompete.ActId)
end

function AllyDuelHistory:GetEventInfo()
  return self.actInfo ~= nil and self.actInfo:GetEventInfo() or nil
end

function AllyDuelHistory:Init()
  self:UpdateInfo()
  local inMatch = DataCenter.LeagueMatchManager:CheckIsMatchOpen() and not DataCenter.LeagueMatchManager:CheckAllianceInMatch()
  if inMatch then
    self:RefreshOpenState()
    return
  end
  if self.actInfo == nil then
    return
  end
  if self.actInfo.finish ~= nil then
    SFSNetwork.SendMessage(MsgDefines.AllianceCompeteWeekResult)
    return
  end
  if self.actInfo.preOpenTime ~= nil then
    self.state = AllianceBatState.PreOpenState
    self:ShowVS(false)
    return
  end
  local eventInfo = self:GetEventInfo()
  if eventInfo == nil then
    return
  end
  self.state = AllianceBatState.None
  local curTime = UITimeManager:GetInstance():GetServerTime()
  local endTime = eventInfo.weekEndTime or 0
  local startTime = self.actInfo.startTime or 0
  local readyTime = self.actInfo.readyTime or 0
  if curTime >= readyTime and 0 < endTime then
    if curTime < startTime then
      self.state = AllianceBatState.Ready
      self:RefreshOpenState()
    else
      if curTime <= endTime then
        self.state = AllianceBatState.Start
        self:RefreshOpenState()
      else
      end
    end
  end
end

function AllyDuelHistory:RefreshOpenState()
  local hasAlliance = LuaEntry.Player:IsInAlliance()
  local myAllianceId = LuaEntry.Player:GetAllianceUid()
  if not hasAlliance or myAllianceId == nil then
    self.state = AllianceBatState.StartOut
    self:ShowVS(false)
    return
  end
  local eventInfo = self:GetEventInfo()
  if eventInfo == nil or eventInfo.vsAllianceList == nil then
    self.state = AllianceBatState.StartOut
    self:ShowVS(false)
    return
  end
  self:ShowVS(true)
end

function AllyDuelHistory:ShowVS(bVS)
  self.compVSContent:SetActive(bVS)
  self.compContent:SetActive(not bVS)
  if bVS then
    local idx = self.curIdx == VIEW_IDX.WEEK and VIEW_IDX.WEEK or VIEW_IDX.TODAY
    local toggle = idx == VIEW_IDX.WEEK and self.toggleToggle2 or self.toggleToggle1
    toggle:SetIsOn(true)
    self:OnToggleIdx(idx)
  else
    local hasAlliance = LuaEntry.Player:IsInAlliance()
    self:OnToggleIdx(hasAlliance and VIEW_IDX.READY1 or VIEW_IDX.READY2)
  end
end

function AllyDuelHistory:Update()
  local timeStr, leftTime = self:GetTimeStr()
  local comp = self.comps[self.curIdx]
  if comp ~= nil and comp:AsyncLoadDone() and comp.UpdateTime then
    comp:UpdateTime(timeStr, leftTime)
  end
  self.refreshCD = self.refreshCD - Time.deltaTime
  if self.refreshCD <= 0 then
    self.refreshCD = REFRESH_CD
  end
end

function AllyDuelHistory:AutoRefresh()
  local actInfo = DataCenter.ActivityListDataManager:GetActivityDataById(EnumActivity.AllianceCompete.ActId)
  if actInfo ~= nil then
    SFSNetwork.SendMessage(MsgDefines.ActivityEventInfoGet, tostring(actInfo.activityid))
  end
end

function AllyDuelHistory:GetTimeStr()
  local str = ""
  local leftTime = 0
  if self.actInfo == nil then
    return str, leftTime
  end
  if self.state == AllianceBatState.Finish then
    local finishTime = DataCenter.AllianceCompeteDataManager:GetFinishTime()
    if finishTime ~= nil then
      return str, leftTime
    end
  end
  local UITMgr = UITimeManager:GetInstance()
  local curTime = UITMgr:GetServerTime()
  if self.actInfo.preOpenTime ~= nil then
    local preOpenTime = self.actInfo.preOpenTime or 0
    leftTime = preOpenTime - curTime
    str = UITMgr:MilliSecondToFmtString(leftTime)
    return str, leftTime
  end
  local endTime = self.actInfo.endTime or 0
  local eventInfo = self:GetEventInfo()
  if eventInfo ~= nil then
    endTime = eventInfo.weekEndTime or 0
  end
  local startTime = self.actInfo.startTime or 0
  local readyTime = self.actInfo.readyTime or 0
  leftTime = endTime - curTime
  if curTime > startTime and 0 < leftTime then
    str = UITMgr:MilliSecondToFmtString(leftTime)
  elseif curTime < startTime and curTime > readyTime then
    str = UITMgr:MilliSecondToFmtString(leftTime)
  else
    str = 370100
    leftTime = 0
  end
  return str, leftTime
end

return AllyDuelHistory
