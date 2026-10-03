local base = require("UI.UIDispatchTask.Main.Component.UIDispatchContentBase")
local Ghostrecon = BaseClass("Ghostrecon", base)
local Localization = CS.GameEntry.Localization
local GhostreconBubblePanel = require("UI.UIDispatchTask.Main.Component.Ghorstrecon.GhostreconBubblePanel")
local UILWScienceDetailDesc = require("UI/UILWScience/UILWScienceDetail/Component/UILWScienceDetailDesc")
local SendMaxTimes = 4
local bubblePanelParent_path = "BgClip/BgRawImg/BubblePanelParent"
local titleText_path = "Content/TextPanel/TitleText"
local timeText_path = "Content/TextPanel/Time/TimeText"
local tip1Text_path = "Content/TextPanel/Tip1Text"
local tip2Text_path = "Content/TextPanel/Tip2Text"
local infoBtn_path = "Content/InfoBtn"
local allyBtn_path = "Content/AllyBtn"
local allyBtnText_path = "Content/AllyBtn/AllyBtnText"
local allyRedPoint_path = "Content/AllyBtn/AllyRedPoint"
local logBtn_path = "Content/LogBtn"
local logRedPoint_path = "Content/LogBtn/LogRedPoint"
local timePanel_path = "Content/TextPanel/Time"
local previewContent_path = "BgClip/BgRawImg/PreviewContent"
local previewTipText_path = "BgClip/BgRawImg/PreviewContent/Bg/PreviewTipText"
local previewDayText_path = "BgClip/BgRawImg/PreviewContent/Bg/PreviewDayText"
local previewTimeText_path = "BgClip/BgRawImg/PreviewContent/Bg/PreviewTimeText"
local joinAllianceBtn_path = "Content/JoinAllianceBtn"
local joinAllianceBtnText_path = "Content/JoinAllianceBtn/JoinAllianceBtnText"
local greenEffect_path = "Content/TextPanel/Time/Eff_UIActivityGhostrecon_Green"
local redEffect_path = "Content/TextPanel/Time/Eff_UIActivityGhostrecon_Red"
local autoBtn_path = "Content/AutoStartPanel/AutoBtn"
local autoSelectImg_path = "Content/AutoStartPanel/AutoBtn/AutoSelectImg"
local autoStartPanel_path = "Content/AutoStartPanel"
local autoSTipText_path = "Content/AutoStartPanel/AutoTipText"

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

local function OnDestroy(self)
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
  self:SendGhostreconTaskRefresh()
end

local function OnDisable(self)
  base.OnDisable(self)
  DataCenter.ActGhostreconManager:SetTriggerGuide(false)
end

local function ContentShow(self)
  base.ContentShow(self)
  self.view.ctrl:SetGhostMainShow(true)
  if self.isInit then
    if self.isOpenDay ~= nil and self.isOpenDay ~= DataCenter.ActGhostreconManager:IsOpenDay() then
      self:SendGhostreconTaskRefresh()
    else
      self:Refresh()
    end
  end
end

local function ContentHide(self)
  base.ContentHide(self)
  DataCenter.ActGhostreconManager:SetTriggerGuide(false)
  self.view.ctrl:SetGhostMainShow(false)
end

local function ComponentDefine(self)
  self.bubblePanelParent = self:AddComponent(UIBaseContainer, bubblePanelParent_path)
  self.titleText = self:AddComponent(UIText, titleText_path)
  self.timeText = self:AddComponent(UIText, timeText_path)
  self.tip1Text = self:AddComponent(UIText, tip1Text_path)
  self.tip2Text = self:AddComponent(UIText, tip2Text_path)
  self.infoBtn = self:AddComponent(UIButton, infoBtn_path)
  self.allyBtn = self:AddComponent(UIButton, allyBtn_path)
  self.allyBtnText = self:AddComponent(UIText, allyBtnText_path)
  self.allyRedPoint = self:AddComponent(UIBaseContainer, allyRedPoint_path)
  self.logBtn = self:AddComponent(UIButton, logBtn_path)
  self.logRedPoint = self:AddComponent(UIBaseContainer, logRedPoint_path)
  self.timePanel = self:AddComponent(UIButton, timePanel_path)
  self.previewContent = self:AddComponent(UIBaseContainer, previewContent_path)
  self.previewTipText = self:AddComponent(UIText, previewTipText_path)
  self.previewDayText = self:AddComponent(UIText, previewDayText_path)
  self.previewTimeText = self:AddComponent(UIText, previewTimeText_path)
  self.joinAllianceBtn = self:AddComponent(UIButton, joinAllianceBtn_path)
  self.joinAllianceBtnText = self:AddComponent(UIText, joinAllianceBtnText_path)
  self.greenEffect = self:AddComponent(UIBaseContainer, greenEffect_path)
  self.redEffect = self:AddComponent(UIBaseContainer, redEffect_path)
  self.autoBtn = self:AddComponent(UIButton, autoBtn_path)
  self.autoSelectImg = self:AddComponent(UIImage, autoSelectImg_path)
  self.autoStartPanel = self:AddComponent(UIBaseContainer, autoStartPanel_path)
  self.allyBtnText:SetLocalText("ghostrecon_btn01")
  self.tip2Text:SetActive(false)
  self.previewTipText:SetLocalText("ghostrecon_006")
  self.joinAllianceBtnText:SetLocalText("ghostrecon_btn12")
  self.logBtn:SetOnClick(Bind(self, self.OnClickLogBtn))
  self.infoBtn:SetOnClick(Bind(self, self.OnClickInfoBtn))
  self.allyBtn:SetOnClick(Bind(self, self.OnClickAllyBtn))
  self.timePanel:SetOnClick(Bind(self, self.OnClickTeamPanel))
  self.joinAllianceBtn:SetOnClick(Bind(self, self.OnClickJoinAllianceBtn))
  self.greenEffect:SetActive(false)
  self.redEffect:SetActive(false)
  self.timePanel:SetActive(false)
  self.previewContent:SetActive(false)
  self.autoTipText = self:AddComponent(UILWScienceDetailDesc, autoSTipText_path)
  local param = {}
  param.contentParam = SafePack(LuaEntry.DataConfig:TryGetNum("ghostrecon_config", "k5", 0))
  param.yPosFix = 30
  self.autoTipText:SetTextAndParam(Localization:GetString("ghostrecon_087"), param)
  self.autoBtn:SetOnClick(Bind(self, self.OnClickAutoBtn))
  self.autoStartPanel:SetActive(false)
end

local function ComponentDestroy(self)
  self:ClearBubblePanel()
  self.bubblePanelParent = nil
  self.titleText = nil
  self.timeText = nil
  self.tip1Text = nil
  self.tip2Text = nil
  self.infoBtn = nil
  self.allyBtn = nil
  self.allyBtnText = nil
  self.allyRedPoint = nil
  self.logBtn = nil
  self.logRedPoint = nil
  self.timePanel = nil
  self.previewContent = nil
  self.previewTipText = nil
  self.previewDayText = nil
  self.previewTimeText = nil
  self.joinAllianceBtn = nil
  self.joinAllianceBtnText = nil
  self.greenEffect = nil
  self.redEffect = nil
  self.autoBtn = nil
  self.autoSelectImg = nil
  self.autoStartPanel = nil
  self.autoTipText = nil
end

local function DataDefine(self)
  self.sendMaxTimes = 0
  self.lastSendRefreshTime = 0
  self.state = GhostreconState.NoOpen
  self.isInit = true
end

local function DataDestroy(self)
  self.activityId = nil
  self.actData = nil
  self.bubbles = nil
  self.sendMaxTimes = nil
  self.lastSendRefreshTime = nil
  self.debugShowTimeLog = nil
  self.state = nil
  self.needShowGuide = nil
  self.isInit = false
  self.nextDayMs = nil
  self.isOpenDay = nil
end

local function OnAddListener(self)
  base.OnAddListener(self)
  self:AddUIListener(EventId.GhostreconTaskRefreshAll, self.Refresh)
  self:AddUIListener(EventId.GhostreconRefreshTeamworkRewardTimes, self.RefreshTeamworkRewardTimes)
  self:AddUIListener(EventId.SendGhostreconTaskRefresh, self.SendGhostreconTaskRefresh)
  self:AddUIListener(EventId.GhostreconGetRecord, self.OnGetRecord)
  self:AddUIListener(EventId.GhostreconAllianceTaskRefreshRed, self.RefreshAllyRed)
  self:AddUIListener(EventId.PlotGroupDone, self.OnPlotGroupDone)
  self:AddUIListener(EventId.GhostReconSetAutoStart, self.RefreshAutoStart)
end

local function OnRemoveListener(self)
  self:RemoveUIListener(EventId.GhostreconTaskRefreshAll, self.Refresh)
  self:RemoveUIListener(EventId.GhostreconRefreshTeamworkRewardTimes, self.RefreshTeamworkRewardTimes)
  self:RemoveUIListener(EventId.SendGhostreconTaskRefresh, self.SendGhostreconTaskRefresh)
  self:RemoveUIListener(EventId.GhostreconGetRecord, self.OnGetRecord)
  self:RemoveUIListener(EventId.GhostreconAllianceTaskRefreshRed, self.RefreshAllyRed)
  self:RemoveUIListener(EventId.PlotGroupDone, self.OnPlotGroupDone)
  self:RemoveUIListener(EventId.GhostReconSetAutoStart, self.RefreshAutoStart)
  base.OnRemoveListener(self)
end

local function SetData(self, activityId)
  base.SetData(self, activityId)
  self.activityId = activityId
  if not self.activityId then
    return
  end
  self.actData = DataCenter.ActivityListDataManager:GetActivityDataById(activityId)
  self.titleText:SetLocalText(self.actData.name)
end

local function Refresh(self)
  local now = UITimeManager:GetInstance():GetServerTime()
  if self.debugShowTimeLog then
    self.debugShowTimeLog = false
    Logger.Log("now:" .. now)
    Logger.Log("dispatchBeginTime:" .. DataCenter.ActGhostreconManager.dispatchBeginTime)
    Logger.Log("dispatchEndTime:" .. DataCenter.ActGhostreconManager.dispatchEndTime)
    Logger.Log("openTime:" .. DataCenter.ActGhostreconManager.openTime)
  end
  self.isOpenDay = DataCenter.ActGhostreconManager:IsOpenDay()
  if self.isOpenDay then
    self:CheckGuide()
    self.state = GhostreconState.NoOpen
    self.previewContent:SetActive(false)
    self.bubblePanelParent:SetActive(true)
    self.timePanel:SetActive(true)
    self.tip1Text:SetActive(true)
    self.tip1Text:SetText(DataCenter.ActGhostreconManager:GetTeamworkRewardTimesText())
    self.tip2Text:SetActive(true)
    self:RefreshBubblePanel()
    self:RefreshStealTimes()
    self:RefreshTeamworkRewardTimes()
    if DataCenter.ActGhostreconManager.dispatchBeginTime == 0 and DataCenter.ActGhostreconManager.dispatchEndTime == 0 then
      self.nextDayMs = UITimeManager:GetInstance():GetNextDayMs()
      self.state = GhostreconState.AfterOpen
      self.timeText:SetText(UITimeManager:GetInstance():SecondToFmtString(self.nextDayMs - now))
      self.timePanel:LoadSprite("Assets/Main/Sprites/UI/UIGhostrecon/ljq_youling_xinhao_01.png")
    elseif now < DataCenter.ActGhostreconManager.dispatchBeginTime then
      self.state = GhostreconState.BeforOpen
      self.timeText:SetText(UITimeManager:GetInstance():SecondToFmtString(DataCenter.ActGhostreconManager.dispatchBeginTime - now))
      self.timePanel:LoadSprite("Assets/Main/Sprites/UI/UIGhostrecon/ljq_youling_xinhao_01.png")
    elseif now >= DataCenter.ActGhostreconManager.dispatchBeginTime and now < DataCenter.ActGhostreconManager.dispatchEndTime then
      self.state = GhostreconState.Open
      self.timeText:SetText(UITimeManager:GetInstance():SecondToFmtString(DataCenter.ActGhostreconManager.dispatchEndTime - now))
      self.timePanel:LoadSprite("Assets/Main/Sprites/UI/UIGhostrecon/ljq_youling_xinhao_02.png")
    end
  else
    self.state = GhostreconState.NoOpen
    self.timePanel:SetActive(false)
    self.tip1Text:SetActive(false)
    self.tip2Text:SetActive(false)
    self:CheckPreviewShow()
  end
  if not string.IsNullOrEmpty(LuaEntry.Player.allianceId) then
    self.allyBtn:SetActive(true)
    self.joinAllianceBtn:SetActive(false)
  else
    self.allyBtn:SetActive(false)
    self.joinAllianceBtn:SetActive(true)
  end
  self:RefreshAllyRed()
  self:RefreshAutoStart()
  self:Update1000MS()
end

local function RefreshBubblePanel(self)
  local prefabPath = DataCenter.ActGhostreconBubblePosManager:GetBubblePanelPrefabPath()
  if prefabPath ~= self.prefabPath then
    self:ClearBubblePanel()
    self.prefabPath = prefabPath
  end
  if self.bubblePanel then
    self.bubblePanel:Refresh()
    if not self.bubblePanel:IsShowSpawmAnim() then
      self.bubblePanel:SetActive(not DataCenter.ActGhostreconManager.isTriggerGuide)
    end
  elseif self.bubblePanelReq == nil then
    self.bubblePanelReq = self:GameObjectInstantiateAsync(prefabPath, function(request)
      if self.bubblePanelParent == nil then
        return
      end
      local go = request.gameObject
      go.transform:SetParent(self.bubblePanelParent.transform)
      go.transform:Set_localScale(1, 1, 1)
      go.transform:Set_localPosition(0, 0, 0)
      self.bubblePanel = self.bubblePanelParent:AddComponent(GhostreconBubblePanel, go.name)
      self.bubblePanel:Refresh()
      self.bubblePanel:SetActive(not DataCenter.ActGhostreconManager.isTriggerGuide)
    end)
  end
end

local function RefreshStealTimes(self)
  if DataCenter.ActGhostreconManager.stealTimes then
    self.tip2Text:SetText(Localization:GetString("ghostrecon_075") .. " " .. DataCenter.ActGhostreconManager.stealTimes .. "/" .. DataCenter.ActGhostreconManager:GetNowSettingCfg().stealCount)
  end
end

local function RefreshTeamworkRewardTimes(self)
  if DataCenter.ActGhostreconManager.teamworkRewardTimes then
  end
end

local function OnClickLogBtn(self)
  SFSNetwork.SendMessage(MsgDefines.GhostReconGetRecord)
end

local function OnGetRecord(self)
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIGhostreconRecord, {anim = true})
end

local function OnClickInfoBtn(self)
  if self.actData ~= nil and self.actData.story ~= nil then
    local param = {}
    param.activityId = self.activityId
    param.activityRulesStr = Localization:GetString(self.actData.story)
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIActivityDetailPopup, {anim = true}, param)
  end
end

local function OnClickAllyBtn(self)
  if string.IsNullOrEmpty(LuaEntry.Player.allianceId) then
    UIUtil.OnJoinAllianceBtnClick()
  else
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIGhostreconAllianceTask, {anim = true})
  end
end

local function OnClickTeamPanel(self)
  local now = UITimeManager:GetInstance():GetServerTime()
  if self.isOpenDay then
    if now < DataCenter.ActGhostreconManager.dispatchBeginTime then
      UIUtil.ShowBubbleTips(Localization:GetString("ghostrecon_005"), self.timePanel.transform.position, 100, -40, 0)
    elseif now >= DataCenter.ActGhostreconManager.dispatchBeginTime and now < DataCenter.ActGhostreconManager.dispatchEndTime then
      UIUtil.ShowBubbleTips(Localization:GetString("ghostrecon_004"), self.timePanel.transform.position, 100, -40, 0)
    end
  end
end

local function OnClickJoinAllianceBtn(self)
  UIUtil.OnJoinAllianceBtnClick()
end

local function CheckPreviewShow(self)
  local taskList = DataCenter.ActGhostreconManager.taskList
  if taskList == nil or #taskList == 0 then
    self.bubblePanelParent:SetActive(false)
    self.previewContent:SetActive(true)
  else
    self.bubblePanelParent:SetActive(true)
    self.previewContent:SetActive(false)
    self:RefreshBubblePanel()
  end
end

local function Update1000MS(self)
  if not self.view.ctrl:GetGhostMainShow() then
    return
  end
  local now = UITimeManager:GetInstance():GetServerTime()
  if self.isOpenDay then
    if DataCenter.ActGhostreconManager.dispatchBeginTime == 0 and DataCenter.ActGhostreconManager.dispatchEndTime == 0 then
      if self.state ~= GhostreconState.AfterOpen then
        self.debugShowTimeLog = true
        self:SendGhostreconTaskRefresh()
      else
        if self.nextDayMs == nil then
          self.nextDayMs = UITimeManager:GetInstance():GetNextDayMs()
        end
        local diffTime = self.nextDayMs - now
        if diffTime <= 0 then
          self.debugShowTimeLog = true
          self:SendGhostreconTaskRefresh()
          diffTime = 0
        end
        self.timeText:SetText(UITimeManager:GetInstance():MilliSecondToFmtString(diffTime))
      end
    elseif now < DataCenter.ActGhostreconManager.dispatchBeginTime then
      if self.state ~= GhostreconState.BeforOpen then
        self.debugShowTimeLog = true
        self:SendGhostreconTaskRefresh()
      else
        local diffTime = DataCenter.ActGhostreconManager.dispatchBeginTime - now
        self.timeText:SetText(UITimeManager:GetInstance():MilliSecondToFmtString(diffTime))
        if diffTime + 1000 >= 4000 and diffTime < 4000 then
          self.redEffect:SetActive(false)
          self.redEffect:SetActive(true)
        end
      end
    elseif now >= DataCenter.ActGhostreconManager.dispatchBeginTime and now < DataCenter.ActGhostreconManager.dispatchEndTime then
      if self.state ~= GhostreconState.Open then
        self.debugShowTimeLog = true
        self:SendGhostreconTaskRefresh()
      else
        local diffTime = DataCenter.ActGhostreconManager.dispatchEndTime - now
        self.timeText:SetText(UITimeManager:GetInstance():MilliSecondToFmtString(diffTime))
        if diffTime + 1000 >= 4000 and diffTime < 4000 then
          self.greenEffect:SetActive(false)
          self.greenEffect:SetActive(true)
        end
      end
    elseif now >= DataCenter.ActGhostreconManager.dispatchEndTime and self.state ~= GhostreconState.AfterOpen then
      self.debugShowTimeLog = true
      self:SendGhostreconTaskRefresh()
    end
  elseif DataCenter.ActGhostreconManager.openTime then
    local diffTime = DataCenter.ActGhostreconManager.openTime - now
    if diffTime < 0 then
      self.debugShowTimeLog = true
      self:SendGhostreconTaskRefresh()
    else
      local day, hour, minute, second = UITimeManager:GetInstance():MilliSecondToDHMS(diffTime)
      if 0 < day then
        self.previewDayText:SetText(day .. " " .. Localization:GetString("ghostrecon_085"))
        self.previewTimeText:SetText(string.format("%02d:%02d:%02d", hour, minute, second))
        self.previewTimeText:SetActive(true)
      else
        self.previewDayText:SetText(string.format("%02d:%02d:%02d", hour, minute, second))
        self.previewTimeText:SetActive(false)
      end
    end
  end
end

local function SendGhostreconTaskRefresh(self)
  local now = UITimeManager:GetInstance():GetServerTime()
  if self.lastSendRefreshTime and now - self.lastSendRefreshTime < 2000 then
    self.sendMaxTimes = self.sendMaxTimes + 1
  else
    self.sendMaxTimes = 0
  end
  self.lastSendRefreshTime = now
  if self.sendMaxTimes >= SendMaxTimes then
    Logger.LogInfo("SendGhostreconTaskRefresh MoreTimes")
  else
    SFSNetwork.SendMessage(MsgDefines.GhostreconGetTaskList)
  end
end

local function RefreshAllyRed(self)
  local allianceTaskList = DataCenter.ActGhostreconAllianceManager.allianceTaskList
  if allianceTaskList and 0 < #allianceTaskList then
    self.allyRedPoint:SetActive(true)
  else
    self.allyRedPoint:SetActive(false)
  end
end

local function ClearBubblePanel(self)
  self.bubblePanelParent:RemoveComponents(GhostreconBubblePanel)
  if self.bubblePanelReq then
    self:GameObjectDestroy(self.bubblePanelReq)
  end
  self.bubblePanelReq = nil
  self.bubblePanel = nil
  self.prefabPath = nil
end

local function OnPlotGroupDone(self, plotGroupId)
  if plotGroupId == DataCenter.ActGhostreconManager:GetPlotId(1) and DataCenter.ActGhostreconManager.isTriggerGuide and self.bubblePanel then
    self.bubblePanel:SetActive(true)
    self.bubblePanel:ShowSpawnAnim()
  end
end

local function CheckGuide(self)
  if DataCenter.ActGhostreconManager:GetNeedShowGuide() then
    DataCenter.ActGhostreconManager:SaveFinshedGuide()
    DataCenter.ActGhostreconManager:SetTriggerGuide(true)
    local plotId = DataCenter.ActGhostreconManager:GetPlotId(1)
    if plotId then
      EventManager:GetInstance():Broadcast(EventId.PlayPlotGroup, {plotGroupId = plotId, hideMainUI = false})
    else
      Logger.Log("SetTriggerGuide false")
      DataCenter.ActGhostreconManager:SetTriggerGuide(false)
      self:OnPlotGroupDone()
    end
  end
end

local function RefreshAutoStart(self)
  if DataCenter.ActGhostreconManager.autoStart ~= nil then
    self.autoStartPanel:SetActive(true)
    self.autoSelectImg:SetActive(DataCenter.ActGhostreconManager.autoStart)
  else
    self.autoStartPanel:SetActive(false)
  end
end

local function OnClickAutoBtn(self)
  if DataCenter.ActGhostreconManager.autoStart ~= nil then
    SFSNetwork.SendMessage(MsgDefines.GhostReconSetAutoStart, DataCenter.ActGhostreconManager.autoStart and 0 or 1)
  end
end

Ghostrecon.OnCreate = OnCreate
Ghostrecon.OnDestroy = OnDestroy
Ghostrecon.OnEnable = OnEnable
Ghostrecon.OnDisable = OnDisable
Ghostrecon.ComponentDefine = ComponentDefine
Ghostrecon.ComponentDestroy = ComponentDestroy
Ghostrecon.DataDefine = DataDefine
Ghostrecon.DataDestroy = DataDestroy
Ghostrecon.OnAddListener = OnAddListener
Ghostrecon.OnRemoveListener = OnRemoveListener
Ghostrecon.ContentShow = ContentShow
Ghostrecon.ContentHide = ContentHide
Ghostrecon.SetData = SetData
Ghostrecon.Refresh = Refresh
Ghostrecon.RefreshBubblePanel = RefreshBubblePanel
Ghostrecon.RefreshStealTimes = RefreshStealTimes
Ghostrecon.RefreshTeamworkRewardTimes = RefreshTeamworkRewardTimes
Ghostrecon.OnClickLogBtn = OnClickLogBtn
Ghostrecon.OnGetRecord = OnGetRecord
Ghostrecon.OnClickInfoBtn = OnClickInfoBtn
Ghostrecon.OnClickAllyBtn = OnClickAllyBtn
Ghostrecon.OnClickTeamPanel = OnClickTeamPanel
Ghostrecon.OnClickJoinAllianceBtn = OnClickJoinAllianceBtn
Ghostrecon.CheckPreviewShow = CheckPreviewShow
Ghostrecon.Update1000MS = Update1000MS
Ghostrecon.SendGhostreconTaskRefresh = SendGhostreconTaskRefresh
Ghostrecon.RefreshAllyRed = RefreshAllyRed
Ghostrecon.ClearBubblePanel = ClearBubblePanel
Ghostrecon.OnPlotGroupDone = OnPlotGroupDone
Ghostrecon.CheckGuide = CheckGuide
Ghostrecon.RefreshAutoStart = RefreshAutoStart
Ghostrecon.OnClickAutoBtn = OnClickAutoBtn
return Ghostrecon
