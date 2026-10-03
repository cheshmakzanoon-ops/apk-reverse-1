local base = require("UI.UIActivityCenterTable.Component.ActivityContentBase")
local LWUIZombieRushMain = BaseClass("LWUIZombieRushMain", base)
local Localization = CS.GameEntry.Localization
local LWUIZombieRushDifficultyItemRender = require("UI.UIActivityCenterTable.Component.LWUIZombieRush.LWUIZombieRushDifficultyItemRender")
local LWUIZombieRushBuilding = require("UI.UIActivityCenterTable.Component.LWUIZombieRush.LWUIZombieRushBuilding")
local ZombieRushItem = require("UI.UIActivityCenterTable.Component.LWUIZombieRush.LWUIZombieRushItem")
local UIZombieEliteBossDescPanel = require("UI.UIActivityCenterTable.Component.LWUIZombieRush.UIZombieEliteBossDescPanel")
local OptionData = CS.TMPro.TMP_Dropdown.OptionData
local LWZombieRushTemplateManager = DataCenter.LWZombieRushTemplateManager
local CalendarAddBtnContent = require("UI.LWUIActivityAlarmClock.Component.CalendarAddBtnContent")
local normalContent_path = "NormalContent"
local infoBtn_path = "InfoBtn"
local noOpenContent_path = "NormalContent/NoOpenContent"
local noOpenTipsText_path = "NormalContent/NoOpenContent/VerticalLayout/NoOpenTipsText"
local waitOpenCutDownText_path = "NormalContent/NoOpenContent/WaitOpenCutDownText"
local openContent_path = "NormalContent/OpenContent"
local lockContent_path = "NormalContent/OpenContent/LockContent"
local lockText_path = "NormalContent/OpenContent/LockContent/lrb_leida_sousuoweijiesuobg/LockText"
local unlockContent_path = "NormalContent/OpenContent/UnlockContent"
local powerConditionText_path = "NormalContent/OpenContent/UnlockContent/PowerConditionText"
local selectTipsText_path = "NormalContent/OpenContent/UnlockContent/SelectContent/SelectTipsText"
local difficultySelectLoopView_path = "NormalContent/OpenContent/UnlockContent/SelectContent/DifficultySelectScrollView"
local leftBtn_path = "NormalContent/OpenContent/UnlockContent/SelectContent/LeftBtn"
local rightBtn_path = "NormalContent/OpenContent/UnlockContent/SelectContent/RightBtn"
local rewardBtn_path = "NormalContent/OpenContent/RewardBtn"
local searchContent_path = "SearchContent"
local searchTipsText_path = "SearchContent/lrb_leida_leidaboss03/SearchTipsText"
local slider_path = "BottomContent/Slider"
local searchBtn_path = "BottomContent/SearchBtn"
local searchBtnText_path = "BottomContent/SearchBtn/SearchBtnText"
local cdState_path = "BottomContent/CDState"
local cdTimeText_path = "BottomContent/CDState/CDTimeText"
local progressText_path = "BottomContent/Slider/ProgressText"
local difficultySelectScrollContent_path = "NormalContent/OpenContent/UnlockContent/SelectContent/DifficultySelectScrollView/Viewport/DifficultySelectScrollContent"
local buildingRawImage_path = "NormalContent/OpenContent/UnlockContent/BuildingRawImage"
local searchBtnNormalIcon_path = "BottomContent/SearchBtn/SearchBtnNormalIcon"
local searchBtnPressIcon_path = "BottomContent/SearchBtn/SearchBtnPressIcon"
local heartbeatEffectObj_path = "lrb_leida_beijing03/Eff_ui_zombierush1"
local searchEffectObj_path = "SearchContent/Eff_ui_leida_saomiao"
local searchAni_path = ""
local lockAni_path = "NormalContent/OpenContent/LockContent"
local selectContent_path = "NormalContent/OpenContent/UnlockContent/SelectContent"
local challengingContent_path = "NormalContent/OpenContent/UnlockContent/ChallengeingContent"
local stateText_path = "NormalContent/OpenContent/UnlockContent/ChallengeingContent/StateText"
local stateTimeText_path = "NormalContent/OpenContent/UnlockContent/ChallengeingContent/StateTimeText"
local gotoBtn_path = "NormalContent/OpenContent/UnlockContent/ChallengeingContent/GoToBtn"
local gotoBtnText_path = "NormalContent/OpenContent/UnlockContent/ChallengeingContent/GoToBtn/GoToBtnText"
local nextOpenTimeText_path = "BottomContent/CDState/NextOpenTimeText"
local timeSelectBtn_path = "BottomContent/TimeSelectBtn"
local timeSelectBtnText_path = "BottomContent/TimeSelectBtn/TimeSelectBtnText"
local canAttendNumBtn_path = "SelectLevelCotent/CanAttendNumBtn"
local blueIcon_path = "SelectLevelCotent/CanAttendNumBtn/BlueImage"
local redIcon_path = "SelectLevelCotent/CanAttendNumBtn/RedImage"
local numBtnText_path = "SelectLevelCotent/CanAttendNumBtn/NumBtnText"
local levelDrop_path = "SelectLevelCotent/LevelDrop"
local selectLevelTipsText_path = "SelectLevelCotent/SelectLevelTipsText"
local startTimeText_path = "StartTimeTextContent/StartTimeText"
local dropContent_path = "SelectLevelCotent/Template/Viewport/Content"
local arrowBtn_path = "SelectLevelCotent/LevelDrop/Arrow"
local levelLabel_path = "SelectLevelCotent/LevelDrop/Label"
local templateTran_path = "SelectLevelCotent/Template"
local selectLevelCotent_path = "SelectLevelCotent"
local elite_boss_btn_path = "NormalContent/OpenContent/EliteBossBtn"
local l_w_u_i_zombie_elite_boss_desc_path = "LWUIZombieEliteBossDesc"
local calendar_add_btn_content_path = "StartTimeTextContent/StartTimeText/CalendarAddBtnContent"

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:InitSelectState()
end

local function OnDestroy(self)
  self:ClearDifficultySelectLoopView()
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
  if DataCenter.LWZombieRushManager.isRequestServerData then
    DataCenter.LWZombieRushManager:SendMsgZombieRushActInfo()
  end
end

local function OnDisable(self)
  self:StopSearchSuccessDelayTimer()
  if self.zombieRushBuilding ~= nil then
    self.zombieRushBuilding:SetActive(false)
  end
  if self.elite_boss_desc_panel then
    self.elite_boss_desc_panel:SetPanelShow(false)
  end
  base.OnDisable(self)
end

local function ComponentDefine(self)
  self.normalContent = self:AddComponent(UIBaseContainer, normalContent_path)
  self.infoBtn = self:AddComponent(UIButton, infoBtn_path)
  self.noOpenContent = self:AddComponent(UIBaseContainer, noOpenContent_path)
  self.noOpenTipsText = self:AddComponent(UIText, noOpenTipsText_path)
  self.waitOpenCutDownText = self:AddComponent(UIText, waitOpenCutDownText_path)
  self.openContent = self:AddComponent(UIBaseContainer, openContent_path)
  self.lockContent = self:AddComponent(UIBaseContainer, lockContent_path)
  self.lockText = self:AddComponent(UIText, lockText_path)
  self.unlockContent = self:AddComponent(UIBaseContainer, unlockContent_path)
  self.powerConditionText = self:AddComponent(UIText, powerConditionText_path)
  self.selectTipsText = self:AddComponent(UIText, selectTipsText_path)
  self.difficultySelectLoopView = self:AddComponent(UILoopListView2, difficultySelectLoopView_path)
  self.leftBtn = self:AddComponent(UIButton, leftBtn_path)
  self.rightBtn = self:AddComponent(UIButton, rightBtn_path)
  self.rewardBtn = self:AddComponent(UIButton, rewardBtn_path)
  self.searchContent = self:AddComponent(UIBaseContainer, searchContent_path)
  self.searchTipsText = self:AddComponent(UIText, searchTipsText_path)
  self.slider = self:AddComponent(UISlider, slider_path)
  self.searchBtn = self:AddComponent(UIButton, searchBtn_path)
  self.searchBtnText = self:AddComponent(UIText, searchBtnText_path)
  self.cdState = self:AddComponent(UIBaseContainer, cdState_path)
  self.cdStateBtn = self:AddComponent(UIButton, cdState_path)
  self.cdTimeText = self:AddComponent(UIText, cdTimeText_path)
  self.progressText = self:AddComponent(UIText, progressText_path)
  self.difficultySelectScrollContent = self:AddComponent(UIBaseContainer, difficultySelectScrollContent_path)
  self.buildingRawImage = self:AddComponent(UIRawImage, buildingRawImage_path)
  self.searchBtnNormalIcon = self:AddComponent(UIRawImage, searchBtnNormalIcon_path)
  self.searchBtnPressIcon = self:AddComponent(UIRawImage, searchBtnPressIcon_path)
  self.heartbeatEffectObj = self:AddComponent(UIBaseContainer, heartbeatEffectObj_path)
  self.searchEffectObj = self:AddComponent(UIBaseContainer, searchEffectObj_path)
  self.searchAni = self:AddComponent(UIAnimator, searchAni_path)
  self.lockAni = self:AddComponent(UIAnimator, lockAni_path)
  self.selectContent = self:AddComponent(UIBaseContainer, selectContent_path)
  self.challengingContent = self:AddComponent(UIBaseContainer, challengingContent_path)
  self.stateText = self:AddComponent(UIText, stateText_path)
  self.stateTimeText = self:AddComponent(UIText, stateTimeText_path)
  self.gotoBtn = self:AddComponent(UIButton, gotoBtn_path)
  self.gotoBtnText = self:AddComponent(UIText, gotoBtnText_path)
  self.nextOpenTimeText = self:AddComponent(UIText, nextOpenTimeText_path)
  self.timeSelectBtn = self:AddComponent(UIButton, timeSelectBtn_path)
  self.timeSelectBtnText = self:AddComponent(UIText, timeSelectBtnText_path)
  self.canAttendNumBtn = self:AddComponent(UIButton, canAttendNumBtn_path)
  self.redIcon = self:AddComponent(UIImage, redIcon_path)
  self.blueIcon = self:AddComponent(UIImage, blueIcon_path)
  self.numBtnText = self:AddComponent(UIText, numBtnText_path)
  self.levelDrop = self:AddComponent(UIDropdown, levelDrop_path)
  self.selectLevelTipsText = self:AddComponent(UIText, selectLevelTipsText_path)
  self.startTimeText = self:AddComponent(UIText, startTimeText_path)
  self.content = self:AddComponent(UIBaseContainer, dropContent_path)
  self.arrowBtn = self:AddComponent(UIButton, arrowBtn_path)
  self.arrowImage = self:AddComponent(UIImage, arrowBtn_path)
  self.templateTran = self:AddComponent(UIBaseContainer, templateTran_path)
  self.levelLabel = self:AddComponent(UIText, levelLabel_path)
  self.selectLevelCotent = self:AddComponent(UIBaseContainer, selectLevelCotent_path)
  self.levelDrop:SetOnValueChanged(function()
    self:OnLevelChange()
  end)
  self.zombieRushBuilding = self:AddComponent(LWUIZombieRushBuilding, buildingRawImage_path)
  self.difficultySelectLoopView:InitListView(0, function(listView, index)
    return self:OnGetItemByIndex(listView, index)
  end)
  self.difficultySelectLoopView:SetOnSnapItemFinished(function(listView, item)
    self:OnItemSnapFinish(listView, item)
  end)
  self.difficultySelectLoopView:SetOnSnapNearestChanged(function(listView, item)
    self:OnItemSnapNearestChanged(listView, item)
  end)
  self.timeSelectBtn:SetOnClick(function()
    self:TimeSelectBtnClick()
  end)
  self.canAttendNumBtn:SetOnClick(function()
    self:CanAttendNumBtnClick()
  end)
  self.arrowBtn:SetOnClick(function()
    self:ArrowBtnClick()
  end)
  self.infoBtn:SetOnClick(function()
    self:InfoBtnClick()
  end)
  self.rewardBtn:SetOnClick(function()
    self:RewardBtnClick()
  end)
  self.cdStateBtn:SetOnClick(function()
    self:CdStateBtnClick()
  end)
  self.searchBtn:SetOnClick(function()
    self:SearchBtnClick()
  end)
  self.leftBtn:SetSafeClickMode(true)
  self.leftBtn:SetOnClick(function()
    self:LeftBtnClick()
  end)
  self.rightBtn:SetSafeClickMode(true)
  self.rightBtn:SetOnClick(function()
    self:RightBtnClick()
  end)
  self.selectTipsText:SetLocalText("zombieRush_tips_05")
  self.searchTipsText:SetLocalText("zombieRush_tips_20")
  self.searchBtnTrigger = self:AddComponent(UIEventTrigger, searchBtn_path)
  self.searchBtnTrigger:OnPointerDown(function()
    self:BtnPointDown()
  end)
  self.searchBtnTrigger:OnPointerUp(function()
    self:BtnPointUp()
  end)
  self.gotoBtnText:SetLocalText("110088")
  self.gotoBtn:SetOnClick(function()
    self:GoToBtnClick()
  end)
  self.elite_boss_btn = self:AddComponent(UIButton, elite_boss_btn_path)
  self.elite_boss_btn:SetOnClick(BindCallback(self, self.OnZombieExplainClick))
  self.elite_boss_desc_panel = self:AddComponent(UIZombieEliteBossDescPanel, l_w_u_i_zombie_elite_boss_desc_path)
  self.calendar_add_btn_content = self:AddComponent(CalendarAddBtnContent, calendar_add_btn_content_path)
end

local function ComponentDestroy(self)
  self:RemoveDiffItems()
  self.normalContent = nil
  self.infoBtn = nil
  self.noOpenContent = nil
  self.noOpenTipsText = nil
  self.waitOpenCutDownText = nil
  self.openContent = nil
  self.lockContent = nil
  self.lockText = nil
  self.unlockContent = nil
  self.powerConditionText = nil
  self.selectTipsText = nil
  self.difficultySelectLoopView = nil
  self.leftBtn = nil
  self.rightBtn = nil
  self.rewardBtn = nil
  self.searchContent = nil
  self.searchTipsText = nil
  self.slider = nil
  self.searchBtn = nil
  self.searchBtnText = nil
  self.cdState = nil
  self.cdTimeText = nil
  self.progressText = nil
  self.difficultySelectScrollContent = nil
  self.buildingRawImage = nil
  self.searchBtnNormalIcon = nil
  self.searchBtnPressIcon = nil
  self.heartbeatEffectObj = nil
  self.searchEffectObj = nil
  self.searchAni = nil
  self.lockAni = nil
  self.selectContent = nil
  self.challengingContent = nil
  self.stateText = nil
  self.stateTimeText = nil
  self.gotoBtn = nil
  self.gotoBtnText = nil
  self.nextOpenTimeText = nil
  self.timeSelectBtn = nil
  self.timeSelectBtnText = nil
  self.canAttendNumBtn = nil
  self.redIcon = nil
  self.blueIcon = nil
  self.numBtnText = nil
  self.levelDrop = nil
  self.selectLevelTipsText = nil
  self.startTimeText = nil
  self.levelLabel = nil
  self.selectLevelCotent = nil
  self.arrowImage = nil
  self.elite_boss_btn = nil
  self.elite_boss_desc_panel = nil
  self.calendar_add_btn_content = nil
end

local function DataDefine(self)
  self.searchSuccessDelayTimer = nil
  self.status = ZombieRushStatus.None
  self.maxValue = LuaEntry.DataConfig:TryGetNum("zombieRush_config", "k2")
  self.curSelectTemplateId = 0
  self.curSelectIndex = 1
  self.itemIndex = 0
  self.allTemplateIds = LWZombieRushTemplateManager:GetAllTemplateIdsByType(ZombieRushType.ZombieRush)
  self.maxRoundValue = 0
  self.diffItems = {}
  self.diffReqs = {}
  self.selectLevel = 0
  self.ChooseDiffFun = nil
  self.historyPlanList = {}
  self.defaultPlayerList = {}
  self.planTime = DataCenter.LWZombieRushPlanInfoManager:GetPlanTimeStamp()
  self.isR4OrR5 = DataCenter.AllianceBaseDataManager:IsR4orR5()
  table.sort(self.allTemplateIds, function(a, b)
    local templateA = LWZombieRushTemplateManager:GetTemplate(a)
    local templateB = LWZombieRushTemplateManager:GetTemplate(b)
    return templateA.difficulty < templateB.difficulty
  end)
end

local function DataDestroy(self)
  self.status = nil
  self.maxValue = nil
  self.curSelectTemplateId = nil
  self.curSelectIndex = nil
  self.itemIndex = nil
  self.allTemplateIds = nil
  self.maxRoundValue = nil
  self.selectLevel = nil
  self.ChooseDiffFun = nil
  self.historyPlanList = nil
  self.planTime = nil
  self.isR4OrR5 = nil
  self.defaultPlayerList = nil
  self:StopSearchSuccessDelayTimer()
end

local function OnAddListener(self)
  base.OnAddListener(self)
  self:AddUIListener(EventId.UpdateZombieRushPointData, self.UpdateZombieRushPointShow)
  self:AddUIListener(EventId.GetZombieRushActInfoData, self.OnGetZombieRushActInfoData)
  self:AddUIListener(EventId.ZombieRushSearchFailed, self.OnZombieRushSearchFailed)
  self:AddUIListener(EventId.AllianceCreateSuccess, self.OnCreateAllianceSuccess)
  self:AddUIListener(EventId.AllianceQuitOK, self.OnZombieRushSearchFailed)
  self:AddUIListener(EventId.UpdateZombieRushOpenPlayerPop, self.OpenPlayerListPop)
  self:AddUIListener(EventId.UpdateZombieRushLevelInfo, self.UpdateLevelInfo)
  self:AddUIListener(EventId.UpdateZombieRushPlanInfo, self.UpdatePlanInfo)
  self:AddUIListener(EventId.ZombieRushPassDayRefresh, self.OnPassDayRefresh)
end

local function OnRemoveListener(self)
  self:RemoveUIListener(EventId.UpdateZombieRushPointData, self.UpdateZombieRushPointShow)
  self:RemoveUIListener(EventId.GetZombieRushActInfoData, self.OnGetZombieRushActInfoData)
  self:RemoveUIListener(EventId.ZombieRushSearchFailed, self.OnZombieRushSearchFailed)
  self:RemoveUIListener(EventId.AllianceCreateSuccess, self.OnCreateAllianceSuccess)
  self:RemoveUIListener(EventId.AllianceQuitOK, self.OnZombieRushSearchFailed)
  self:RemoveUIListener(EventId.UpdateZombieRushOpenPlayerPop, self.OpenPlayerListPop)
  self:RemoveUIListener(EventId.UpdateZombieRushLevelInfo, self.UpdateLevelInfo)
  self:RemoveUIListener(EventId.UpdateZombieRushPlanInfo, self.UpdatePlanInfo)
  self:RemoveUIListener(EventId.ZombieRushPassDayRefresh, self.OnPassDayRefresh)
  base.OnRemoveListener(self)
end

local function OnGetZombieRushActInfoData(self)
  if DataCenter.LWZombieRushManager.isSearch then
    self:OnZombieRushSearchSuccess()
  else
    self:OnShow()
  end
end

local function OnZombieRushSearchSuccess(self)
  self:ShowSearchView()
  self.searchSuccessDelayTimer = TimerManager:GetInstance():DelayInvoke(function()
    DataCenter.LWZombieRushManager:JumpToZombieRush()
  end, 2.4)
end

local function OnZombieRushSearchFailed(self)
  self:StopSearchSuccessDelayTimer()
  self.status = ZombieRushStatus.None
  self:OnShow()
end

local function OnCreateAllianceSuccess(self, isSuccess)
  if isSuccess then
    DataCenter.LWZombieRushManager:SendMsgZombieRushActInfo()
  end
end

local function OnPassDayRefresh(self)
  self.allTemplateIds = LWZombieRushTemplateManager:GetAllTemplateIdsByType(ZombieRushType.ZombieRush)
  table.sort(self.allTemplateIds, function(a, b)
    local templateA = LWZombieRushTemplateManager:GetTemplate(a)
    local templateB = LWZombieRushTemplateManager:GetTemplate(b)
    return templateA.difficulty < templateB.difficulty
  end)
  if DataCenter.LWZombieRushManager.isRequestServerData then
    DataCenter.LWZombieRushManager:SendMsgZombieRushActInfo()
  end
end

local function StopSearchSuccessDelayTimer(self)
  if self.searchSuccessDelayTimer then
    self.searchSuccessDelayTimer:Stop()
    self.searchSuccessDelayTimer = nil
  end
end

local function Update1000MS(self)
  local curTime = UITimeManager:GetInstance():GetServerTime()
  if self.status == ZombieRushStatus.NoOpen then
    local openTime = DataCenter.LWZombieRushManager.openTime
    if curTime < openTime then
      local surplusTime = openTime - curTime
      self.waitOpenCutDownText:SetText(UITimeManager:GetInstance():MilliSecondToFmtString(surplusTime))
    else
      self:ShowOpenView()
    end
  end
  if self.status == ZombieRushStatus.CD then
    local cdTime = DataCenter.LWZombieRushManager.cdTime
    local cdSurplusTime = cdTime - curTime
    self.planTime = DataCenter.LWZombieRushPlanInfoManager:GetPlanTimeStamp()
    if cdSurplusTime < 0 and self.planTime <= 0 then
      self.status = ZombieRushStatus.Open
      self.searchBtn:SetActive(true)
      self.cdState:SetActive(false)
      self:SetTimeSelectBtnState()
      self:RefreshSearchBtnTextShow()
      self.startTimeText:SetActive(false)
    elseif self.planTime > 0 and 0 >= DataCenter.LWZombieRushManager.buildingId then
      self.searchBtn:SetActive(false)
      self.cdState:SetActive(true)
      self.cdTimeText:SetLocalText("zombierush_plan_btn_cancel")
      self.startTimeText:SetActive(true)
      self:SetStartTime()
    else
      self.startTimeText:SetActive(false)
      self.cdTimeText:SetLocalText("zombieRush_tips_03", UITimeManager:GetInstance():MilliSecondToFmtString(cdSurplusTime))
      self.nextOpenTimeText:SetLocalText("zombieRush_tips_31", string.format("<color=#5FEF87>%s</color>", UITimeManager:GetInstance():GetTimeToMD(cdTime // 1000)))
    end
  end
  if 0 < DataCenter.LWZombieRushManager.buildingId then
    self.startTimeText:SetActive(false)
    self:RefreshShowChallengingView()
  end
end

local function SetStartTime(self)
  local time = "<color=#5fef87>" .. UITimeManager:GetInstance():TimeStampToTimeForServerMinute(DataCenter.LWZombieRushPlanInfoManager:GetPlanTimeStamp()) .. "</color>"
  local template = LWZombieRushTemplateManager:GetTemplate(DataCenter.LWZombieRushPlanInfoManager:GetPlanId())
  local diff = "<color=#5fef87>" .. template.difficulty .. "</color>"
  self.startTimeText:SetLocalText("zombierush_plan_tips_set", time, diff)
end

local function SetData(self, activityId)
  base.SetData(self, activityId)
  DataCenter.ActivityListDataManager:SetActivityVisitedEndTime(activityId)
  self.heartbeatEffectObj:SetActive(false)
  self.searchEffectObj:SetActive(false)
  self:BtnPointUp()
  self:OnShow()
end

local function OnShow(self)
  self.searchAni:SetSpeed(-1)
  self.searchAni:SampleAnimationAtTime("Eff_ui_zombierushlock2", 0)
  self.searchAni:Play("Eff_ui_zombierushlock2", 0, 0)
  self:UpdateStatus()
  self:UpdateZombieRushPointShow()
end

local function UpdateStatus(self)
  if not LuaEntry.Player:IsInAlliance() then
    self.status = ZombieRushStatus.NoAlliance
    self:ShowNoOpenView()
  else
    local curTime = UITimeManager:GetInstance():GetServerTime()
    local openTime = DataCenter.LWZombieRushManager.openTime
    if curTime < openTime then
      self.status = ZombieRushStatus.NoOpen
      self:ShowNoOpenView()
    else
      self:ShowOpenView()
    end
  end
end

local function ShowNoOpenView(self)
  self.heartbeatEffectObj:SetActive(true)
  self.searchEffectObj:SetActive(false)
  self.noOpenContent:SetActive(true)
  self.openContent:SetActive(false)
  self.searchBtn:SetActive(true)
  self.cdState:SetActive(false)
  self.selectLevelCotent:SetActive(false)
  self.timeSelectBtn:SetActive(false)
  self.noOpenTipsText:SetLocalText("zombieRush_title_02")
  if self.status == ZombieRushStatus.NoAlliance then
    self.searchBtnText:SetLocalText("zombieRush_btn_01")
    self.waitOpenCutDownText:SetLocalText("zombieRush_tips_07")
  else
    local curTime = UITimeManager:GetInstance():GetServerTime()
    local openTime = DataCenter.LWZombieRushManager.openTime
    local surplusTime = openTime - curTime
    self.waitOpenCutDownText:SetText(UITimeManager:GetInstance():MilliSecondToFmtString(surplusTime))
    self.searchBtnText:SetLocalText("zombieRush_btn_02")
  end
end

local function ShowOpenView(self)
  self.heartbeatEffectObj:SetActive(false)
  self.searchEffectObj:SetActive(false)
  self.noOpenContent:SetActive(false)
  self.openContent:SetActive(true)
  self.unlockContent:SetActive(true)
  self.startTimeText:SetActive(false)
  local isChallenging = DataCenter.LWZombieRushManager.buildingId > 0
  self.selectContent:SetActive(not isChallenging)
  self.challengingContent:SetActive(isChallenging)
  self.selectLevelCotent:SetActive(not isChallenging)
  if isChallenging then
    self.curSelectTemplateId = DataCenter.LWZombieRushManager.selectDifficultyId
    if table.indexof(self.allTemplateIds, self.curSelectTemplateId) then
      self.curSelectIndex = table.indexof(self.allTemplateIds, self.curSelectTemplateId)
    end
    self:RefreshCurSelectDifficultyView()
    local template = LWZombieRushTemplateManager:GetTemplate(self.curSelectTemplateId)
    if template ~= nil then
      self.maxRoundValue = template:GetMaxRoundValue()
      self:RefreshShowChallengingView()
    end
  else
    self.curSelectTemplateId = DataCenter.LWZombieRushManager.maxDifficultyId
    local count = table.count(self.allTemplateIds)
    if table.indexof(self.allTemplateIds, self.curSelectTemplateId) then
      self.curSelectIndex = table.indexof(self.allTemplateIds, self.curSelectTemplateId)
    elseif self.allTemplateIds[count] < self.curSelectTemplateId then
      self.curSelectIndex = count
      self.curSelectTemplateId = self.allTemplateIds[count]
    end
    if 0 < count then
      self.difficultySelectLoopView:SetListItemCount(count, false, false)
      self.difficultySelectLoopView:RefreshAllShownItem()
      self.difficultySelectLoopView:MovePanelToItemIndex(self.curSelectIndex - 1, 0)
      self:RefreshCurSelectDifficultyView()
      self:RefreshLeftAndRightBtnState()
    end
  end
  local isCd = DataCenter.LWZombieRushManager:IsCd()
  self.searchBtn:SetActive(not isCd and 0 >= self.planTime)
  self.cdState:SetActive(isCd or 0 < self.planTime)
  if 0 < self.planTime and DataCenter.LWZombieRushManager.buildingId <= 0 then
    self.cdTimeText:SetLocalText("zombierush_plan_btn_cancel")
    self.startTimeText:SetActive(true)
    self:SetStartTime()
  end
  if not isCd then
    self:RefreshSearchBtnTextShow()
    self.status = ZombieRushStatus.Open
  else
    local cdTime = DataCenter.LWZombieRushManager.cdTime
    local curTime = UITimeManager:GetInstance():GetServerTime()
    local cdSurplusTime = cdTime - curTime
    if cdSurplusTime < 0 then
      self.status = ZombieRushStatus.Open
      self.searchBtn:SetActive(true)
      self.cdState:SetActive(false)
    else
      self.status = ZombieRushStatus.CD
      self.cdTimeText:SetLocalText("zombieRush_tips_03", UITimeManager:GetInstance():MilliSecondToFmtString(cdSurplusTime))
      self.nextOpenTimeText:SetLocalText("zombieRush_tips_31", string.format("<color=#5FEF87>%s</color>", UITimeManager:GetInstance():GetTimeToMD(cdTime // 1000)))
    end
  end
  self:SetTimeSelectBtnState()
  local curValue = 0
  local allianceData = DataCenter.AllianceBaseDataManager:GetAllianceBaseData()
  if allianceData ~= nil then
    curValue = allianceData.zombieRushPoint
  end
  self.timeSelectBtn:SetActive(not isChallenging and self.isR4OrR5 and curValue >= self.maxValue)
  self:ShowCalendatBtnContent()
end

local function ShowCalendatBtnContent(self)
  local isShowBtn = false
  local isCd = DataCenter.LWZombieRushManager:IsCd()
  if not isCd then
    local time = DataCenter.LWZombieRushPlanInfoManager:GetPlanTimeStamp()
    if 0 < time and 0 >= DataCenter.LWZombieRushManager.buildingId then
      isShowBtn = true
    end
  end
  self.calendar_add_btn_content:SetActive(isShowBtn)
  if isShowBtn then
    local planTime = DataCenter.LWZombieRushPlanInfoManager:GetPlanTimeStamp()
    local startTime = toInt(planTime / 1000)
    local endTime = startTime
    self.calendar_add_btn_content:SetDataWithDefautValue(2, startTime, endTime, CalendarSourcePath.Activity)
  end
end

local function RefreshShowChallengingView(self)
  if DataCenter.LWZombieRushManager.state == ZombieRushAllianceStatus.Prepare then
    self.stateText:SetLocalText("zombieRush_tips_29")
  else
    local stateStr = ""
    if DataCenter.LWZombieRushManager.state == ZombieRushAllianceStatus.Ready then
      stateStr = Localization:GetString("zombieRush_state_01")
    elseif DataCenter.LWZombieRushManager.state == ZombieRushAllianceStatus.InBattle then
      stateStr = Localization:GetString("zombieRush_state_02")
    end
    self.stateText:SetLocalText("zombieRush_tips_25", DataCenter.LWZombieRushManager.round, self.maxRoundValue, stateStr)
  end
  local surplusTime = DataCenter.LWZombieRushManager.stateEndTime - UITimeManager:GetInstance():GetServerTime()
  self.stateTimeText:SetText(UITimeManager:GetInstance():MilliSecondToFmtString(surplusTime))
end

local function ShowSearchView(self)
  self.searchAni:SetSpeed(1)
  self.searchAni:Play("Eff_ui_zombierushlock2", 0, 0)
  self.heartbeatEffectObj:SetActive(false)
  self.searchEffectObj:SetActive(true)
end

local function OnGetItemByIndex(self, loopScroll, index)
  local count = table.count(self.allTemplateIds)
  index = index + 1
  if index < 1 or count < index then
    return nil
  end
  local item = loopScroll:NewListViewItem("LWUIZombieRushDifficultyItemRender")
  local script = self.difficultySelectScrollContent:GetComponent(item.gameObject.name, LWUIZombieRushDifficultyItemRender)
  if script == nil then
    local objectName = tostring(self.itemIndex)
    self.itemIndex = self.itemIndex + 1
    item.gameObject.name = objectName
    script = self.difficultySelectScrollContent:AddComponent(LWUIZombieRushDifficultyItemRender, objectName)
  end
  script:SetActive(true)
  local templateId = self.allTemplateIds[index]
  local template = LWZombieRushTemplateManager:GetTemplate(templateId)
  local isSelect = templateId == self.curSelectTemplateId
  script:SetData(template, isSelect)
  return item
end

local function OnItemSnapFinish(self, loopScroll, item)
end

local function OnItemSnapNearestChanged(self, loopScroll, item)
  self.curSelectIndex = item.ItemIndex + 1
  self:RefreshCurSelectDifficultyView()
  self:RefreshLeftAndRightBtnState()
  self:InitSelectState()
  EventManager:GetInstance():Broadcast(EventId.UpdateZombieRushSelectDifficulty, self.curSelectTemplateId)
end

local function ClearDifficultySelectLoopView(self)
  self.difficultySelectScrollContent:RemoveComponents(LWUIZombieRushDifficultyItemRender)
  self.difficultySelectLoopView:ClearAllItems()
end

local function RefreshCurSelectDifficultyView(self)
  if self.templateTran:GetActive() then
    self.templateTran:SetActive(false)
    self.arrowImage:LoadSprite("Assets/Main/Sprites/UI/UILWZombieRush/lrb_shichaogongji_xiala_btn01.png")
  end
  if self.curSelectIndex < 1 or self.curSelectIndex > table.count(self.allTemplateIds) then
    return
  end
  self.curSelectTemplateId = self.allTemplateIds[self.curSelectIndex]
  local unlock = self.curSelectTemplateId <= DataCenter.LWZombieRushManager.maxDifficultyId
  self.lockContent:SetActive(not unlock)
  local isChallenging = DataCenter.LWZombieRushManager.buildingId > 0
  self.selectLevelCotent:SetActive(unlock and not isChallenging)
  self.planTime = DataCenter.LWZombieRushPlanInfoManager:GetPlanTimeStamp()
  self:SetTimeSelectBtnState()
  local template = LWZombieRushTemplateManager:GetTemplate(self.curSelectTemplateId)
  if template ~= nil then
    self.powerConditionText:SetLocalText("zombieRush_title_04", template.power)
    self.zombieRushBuilding:ReInit(template.alliance_res_build)
    if string.IsNullOrEmpty(template.eliteBoss_show) then
      self.elite_boss_btn:SetActive(false)
    else
      self.elite_boss_btn:SetActive(true)
    end
    if not unlock then
      local unlockConditionList = template:GetUnlockConditionList()
      if table.count(unlockConditionList) > 0 then
        for i = 1, table.count(unlockConditionList) do
          local condition = unlockConditionList[i]
          if condition.conditionType == 1 and table.count(condition.conditionParam) == 2 then
            local preTemplate = LWZombieRushTemplateManager:GetTemplate(condition.conditionParam[1])
            if preTemplate ~= nil then
              self.lockText:SetLocalText("zombieRush_tips_02", preTemplate.difficulty, condition.conditionParam[2])
              break
            end
          end
        end
      end
      self.timeSelectBtn:SetActive(false)
    else
      local curValue = 0
      local allianceData = DataCenter.AllianceBaseDataManager:GetAllianceBaseData()
      if allianceData ~= nil then
        curValue = allianceData.zombieRushPoint
      end
      if curValue < self.maxValue then
        self.timeSelectBtn:SetActive(false)
      else
        self.timeSelectBtn:SetActive(self.isR4OrR5)
      end
    end
  end
end

local function RefreshLeftAndRightBtnState(self)
  if self.curSelectIndex == 1 then
    self.leftBtn:SetActive(false)
    self.rightBtn:SetActive(true)
  elseif self.curSelectIndex == table.count(self.allTemplateIds) then
    self.leftBtn:SetActive(true)
    self.rightBtn:SetActive(false)
  else
    self.leftBtn:SetActive(true)
    self.rightBtn:SetActive(true)
  end
end

local function UpdateZombieRushPointShow(self)
  local curValue = 0
  local allianceData = DataCenter.AllianceBaseDataManager:GetAllianceBaseData()
  if allianceData ~= nil then
    curValue = allianceData.zombieRushPoint
  end
  local progress = self.maxValue == 0 and 0 or curValue / self.maxValue
  self.slider:SetValue(progress)
  self.progressText:SetText(string.format("%d/%d", curValue, self.maxValue))
  if self.status == ZombieRushStatus.Open then
    self:RefreshSearchBtnTextShow()
  end
end

local function RefreshSearchBtnTextShow(self)
  local curValue = 0
  local allianceData = DataCenter.AllianceBaseDataManager:GetAllianceBaseData()
  if allianceData ~= nil then
    curValue = allianceData.zombieRushPoint
  end
  if curValue < self.maxValue then
    self.searchBtnText:SetLocalText("zombieRush_btn_03")
  else
    self.searchBtnText:SetLocalText("zombieRush_btn_02")
  end
end

local function InfoBtnClick(self)
  local param = {}
  param.activityRulesStr = Localization:GetString("zombieRush_tips_06")
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIActivityDetailPopup, {anim = true}, param)
end

local function RewardBtnClick(self)
  UIManager:GetInstance():OpenWindow(UIWindowNames.LWUIZombieRushReward, {anim = true}, self.curSelectTemplateId)
end

local function SearchBtnClick(self)
  if self.status == ZombieRushStatus.NoAlliance then
    UIUtil.OnJoinAllianceBtnClick()
  elseif self.status == ZombieRushStatus.NoOpen then
    UIUtil.ShowTipsId("zombieRush_tips_08")
  elseif self.status == ZombieRushStatus.Open then
    local curValue = 0
    local allianceData = DataCenter.AllianceBaseDataManager:GetAllianceBaseData()
    if allianceData ~= nil then
      curValue = allianceData.zombieRushPoint
    end
    if curValue < self.maxValue then
      GoToUtil.CloseAllWindows()
      UIManager:GetInstance():OpenWindow(UIWindowNames.UIDetectEvent, {
        anim = true,
        UIMainAnim = UIMainAnimType.AllHide
      })
    elseif DataCenter.AllianceBaseDataManager:IsR4orR5() then
      local isUnlock = self.curSelectTemplateId <= DataCenter.LWZombieRushManager.maxDifficultyId
      if isUnlock then
        UIUtil.ShowMessage(CS.GameEntry.Localization:GetString("zombieRush_tips_27"), 2, GameDialogDefine.CONFIRM, GameDialogDefine.CANCEL, function()
          self.status = ZombieRushStatus.Search
          if self.elite_boss_desc_panel then
            self.elite_boss_desc_panel:SetPanelShow(false)
          end
          DataCenter.LWZombieRushManager:SendMsgZombieRushSearch(self.curSelectTemplateId)
        end, function()
        end)
      else
        self.lockAni:Play("Eff_ui_zombierushlock1", 0, 0)
      end
    else
      UIUtil.ShowTipsId("zombieRush_tips_04")
    end
  elseif self.status == ZombieRushStatus.Search and DataCenter.AllianceBaseDataManager:IsR4orR5() then
    UIUtil.ShowTipsId("zombieRush_tips_14")
  end
end

local function LeftBtnClick(self)
  local index = self.curSelectIndex - 1
  if 1 <= index then
    self.difficultySelectLoopView:SetSnapTargetItemIndex(index - 1)
  end
end

local function RightBtnClick(self)
  local index = self.curSelectIndex + 1
  if index <= table.count(self.allTemplateIds) then
    self.difficultySelectLoopView:SetSnapTargetItemIndex(index - 1)
  end
end

local function GoToBtnClick(self)
  DataCenter.LWZombieRushManager:JumpToZombieRush()
end

local function BtnPointDown(self)
  self.searchBtnText:SetLocalPositionXYZ(0, 16, 0)
  self.searchBtnPressIcon:SetActive(true)
  self.searchBtnNormalIcon:SetActive(false)
end

local function BtnPointUp(self)
  self.searchBtnText:SetLocalPositionXYZ(0, 50.5, 0)
  self.searchBtnPressIcon:SetActive(false)
  self.searchBtnNormalIcon:SetActive(true)
end

local function InitSelectState(self)
  if DataCenter.AllianceBaseDataManager:IsR4orR5() then
    self.selectLevelTipsText:SetActive(true)
    self.arrowBtn:SetActive(true)
  else
    self.arrowBtn:SetActive(false)
  end
  if LuaEntry.Player:IsInAlliance() then
    self.selectLevelCotent:SetActive(true)
    self:UpdateSelectData()
  else
    self.selectLevelCotent:SetActive(false)
  end
end

local function UpdateSelectData(self)
  self:RemoveDiffItems()
  if DataCenter.LWZombieRushManager.maxDifficultyId == 0 then
    return
  end
  local template
  if self.curSelectTemplateId == 0 then
    template = LWZombieRushTemplateManager:GetTemplate(DataCenter.LWZombieRushManager.maxDifficultyId)
  else
    template = LWZombieRushTemplateManager:GetTemplate(self.curSelectTemplateId)
  end
  self.selectLevel = math.floor(template.target_lv)
  self.historyPlanList = DataCenter.LWZombieRushPlanInfoManager:GetHistortPlanLevelInfo()
  if self.historyPlanList then
    for k, v in pairs(self.historyPlanList) do
      if tonumber(k) == template.id then
        self.selectLevel = tonumber(v)
        break
      end
    end
  end
  self.defaultPlayerList = DataCenter.LWZombieRushPlanInfoManager:GetDefaultPlayerList()
  if self.defaultPlayerList then
    for k, v in pairs(self.defaultPlayerList) do
      if tonumber(k) == template.id then
        if tonumber(v) ~= 0 then
          self.blueIcon:SetActive(true)
          self.redIcon:SetActive(false)
          self.numBtnText:SetColor(Color.New(0, 0.6352941176470588, 1, 1))
        else
          self.blueIcon:SetActive(false)
          self.redIcon:SetActive(true)
          self.numBtnText:SetColor(Color.New(0.9764705882352941, 0.47843137254901963, 0.5058823529411764, 1))
        end
        self.numBtnText:SetText(v)
        break
      end
    end
  end
  local targetLevelrange = template.target_lv_range
  local levelRange = string.split(targetLevelrange, ";")
  
  function self.ChooseDiffFun(level)
    return LWUIZombieRushMain.ChooseDiff(self, level)
  end
  
  local count = 0
  for i = math.floor(levelRange[1]), math.floor(levelRange[#levelRange]) do
    self.diffReqs[i] = self:GameObjectInstantiateAsync("Assets/Main/Prefabs/UI/ActivityCenter/UILWZombieRush/LWUIZombieRushItem.prefab", function(req)
      if IsNull(req.gameObject) then
        return
      end
      local go = req.gameObject
      local transform = go.transform
      go:SetActive(true)
      transform:SetParent(self.content.transform)
      transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
      local nameStr = tostring(i)
      go.name = nameStr
      local cell = self.content:AddComponent(ZombieRushItem, nameStr)
      cell:Refresh(i)
      cell:ExecuteCallback(self.ChooseDiffFun)
      cell:SetCheckmark(self.selectLevel == i)
      self.diffItems[i] = cell
    end)
    count = count + 1
  end
  local templateTrans = self.templateTran.gameObject:GetComponent(typeof(CS.UnityEngine.RectTransform))
  if count < 5 then
    local height = 352 - (5 - count) * 65
    templateTrans:Set_sizeDelta(templateTrans.sizeDelta.x, height)
  else
    templateTrans:Set_sizeDelta(templateTrans.sizeDelta.x, 352)
  end
  self.levelLabel:SetText("Lv." .. self.selectLevel)
  DataCenter.LWZombieRushPlanInfoManager:SetNowPlanLevel(self.selectLevel)
end

local function ArrowBtnClick(self)
  if self.templateTran:GetActive() then
    self.templateTran:SetActive(false)
    self.arrowImage:LoadSprite("Assets/Main/Sprites/UI/UILWZombieRush/lrb_shichaogongji_xiala_btn01.png")
  else
    self.templateTran:SetActive(true)
    self.arrowImage:LoadSprite("Assets/Main/Sprites/UI/UILWZombieRush/lrb_shichaogongji_xiala_btn02.png")
  end
end

local function ChooseDiff(self, level)
  self.selectLevel = math.floor(level)
  self.levelLabel:SetText("Lv." .. self.selectLevel)
  DataCenter.LWZombieRushPlanInfoManager:SetNowPlanLevel(self.selectLevel)
  if self.diffItems then
    for k, v in pairs(self.diffItems) do
      local diff = v.level and v.level or 1
      v:SetCheckmark(diff == level)
    end
  end
  DataCenter.LWZombieRushPlanInfoManager:SendMsgZombieRushSetLevel(self.curSelectTemplateId, self.selectLevel)
  self.templateTran:SetActive(false)
  self.arrowImage:LoadSprite("Assets/Main/Sprites/UI/UILWZombieRush/lrb_shichaogongji_xiala_btn01.png")
  self:UpdateCanAttendNum()
end

local function UpdateCanAttendNum(self)
  local count = DataCenter.LWZombieRushPlanInfoManager:GetCanAttendPlayerListCount()
  if count ~= 0 then
    self.blueIcon:SetActive(true)
    self.redIcon:SetActive(false)
    self.numBtnText:SetColor(Color.New(0, 0.6352941176470588, 1, 1))
  else
    self.blueIcon:SetActive(false)
    self.redIcon:SetActive(true)
    self.numBtnText:SetColor(Color.New(0.9764705882352941, 0.47843137254901963, 0.5058823529411764, 1))
  end
  self.numBtnText:SetText(count)
end

local function OnLevelChange(self)
  self.selectLevel = self.levelDrop:GetText()
end

local function TimeSelectBtnClick(self)
  UIManager:GetInstance():OpenWindow(UIWindowNames.LWUIZombieRushOrderTimePop, self.curSelectTemplateId)
end

local function CanAttendNumBtnClick(self)
  local allianceId = LuaEntry.Player:GetAllianceUid()
  if allianceId then
    DataCenter.LWZombieRushPlanInfoManager:SendMsgZombieRushGetPlayerList(self.curSelectTemplateId, allianceId)
  end
end

local function OpenPlayerListPop(self, playerList)
  self:UpdateCanAttendNum()
  UIManager:GetInstance():OpenWindow(UIWindowNames.LWUIZombieRushMemberPop, playerList)
end

local function RemoveDiffItems(self)
  self.diffItems = {}
  self.content:RemoveComponents(ZombieRushItem)
  if self.diffReqs then
    for _, v in pairs(self.diffReqs) do
      v:Destroy()
    end
    self.diffReqs = {}
  end
end

local function SetTimeSelectBtnState(self)
  local curValue = 0
  local allianceData = DataCenter.AllianceBaseDataManager:GetAllianceBaseData()
  local unlock = self.curSelectTemplateId <= DataCenter.LWZombieRushManager.maxDifficultyId
  if allianceData ~= nil then
    curValue = allianceData.zombieRushPoint
  end
  self.timeSelectBtn:SetActive(unlock and self.isR4OrR5 and curValue >= self.maxValue)
end

local function CdStateBtnClick(self)
  if not DataCenter.AllianceBaseDataManager:IsR4orR5() then
    UIUtil.ShowTipsId("zombieRush_tips_04")
    return
  end
  local isCd = DataCenter.LWZombieRushManager:IsCd()
  if not isCd then
    local time = DataCenter.LWZombieRushPlanInfoManager:GetPlanTimeStamp()
    if 0 < time then
      DataCenter.LWZombieRushPlanInfoManager:SendMsgZombieRushActDeletePlanInfo(DataCenter.LWZombieRushPlanInfoManager:GetPlanId())
      self.searchBtn:SetActive(true)
      self.cdState:SetActive(false)
      self.startTimeText:SetActive(false)
      self:SetTimeSelectBtnState()
    end
  else
    local time = DataCenter.LWZombieRushPlanInfoManager:GetPlanTimeStamp()
    if 0 < time then
      DataCenter.LWZombieRushPlanInfoManager:SendMsgZombieRushActDeletePlanInfo(DataCenter.LWZombieRushPlanInfoManager:GetPlanId())
      local cdTime = DataCenter.LWZombieRushManager.cdTime
      local curTime = UITimeManager:GetInstance():GetServerTime()
      local cdSurplusTime = cdTime - curTime
      self.cdTimeText:SetLocalText("zombieRush_tips_03", UITimeManager:GetInstance():MilliSecondToFmtString(cdSurplusTime))
      self:SetTimeSelectBtnState()
    end
  end
end

local function UpdatePlanInfo(self)
  local isCd = DataCenter.LWZombieRushManager:IsCd()
  local unlock = self.curSelectTemplateId <= DataCenter.LWZombieRushManager.maxDifficultyId
  if not isCd then
    local time = DataCenter.LWZombieRushPlanInfoManager:GetPlanTimeStamp()
    if time <= 0 then
      self.searchBtn:SetActive(true)
      self.cdState:SetActive(false)
      self.startTimeText:SetActive(false)
      self:SetTimeSelectBtnState()
    else
      self.searchBtn:SetActive(false)
      self.cdState:SetActive(true)
      self.cdTimeText:SetLocalText("zombierush_plan_btn_cancel")
      self.startTimeText:SetActive(true)
      self:SetStartTime()
    end
  end
  self:ShowCalendatBtnContent()
end

local function UpdateLevelInfo(self)
  local level = DataCenter.LWZombieRushPlanInfoManager:GetPlanLevel()
  if level == self.selectLevel then
    self:UpdateCanAttendNum()
  end
end

local function OnZombieExplainClick(self)
  if self.curSelectTemplateId then
    local template = LWZombieRushTemplateManager:GetTemplate(self.curSelectTemplateId)
    if template ~= nil and not string.IsNullOrEmpty(template.eliteBoss_show) then
      self.elite_boss_desc_panel:ReInit(template)
      self.elite_boss_desc_panel:SetPanelShow(true)
    end
  end
end

LWUIZombieRushMain.OnCreate = OnCreate
LWUIZombieRushMain.OnDestroy = OnDestroy
LWUIZombieRushMain.OnEnable = OnEnable
LWUIZombieRushMain.OnDisable = OnDisable
LWUIZombieRushMain.ComponentDefine = ComponentDefine
LWUIZombieRushMain.ComponentDestroy = ComponentDestroy
LWUIZombieRushMain.DataDefine = DataDefine
LWUIZombieRushMain.DataDestroy = DataDestroy
LWUIZombieRushMain.OnAddListener = OnAddListener
LWUIZombieRushMain.OnRemoveListener = OnRemoveListener
LWUIZombieRushMain.SetData = SetData
LWUIZombieRushMain.UpdateStatus = UpdateStatus
LWUIZombieRushMain.Update1000MS = Update1000MS
LWUIZombieRushMain.UpdateZombieRushPointShow = UpdateZombieRushPointShow
LWUIZombieRushMain.ShowOpenView = ShowOpenView
LWUIZombieRushMain.OnGetZombieRushActInfoData = OnGetZombieRushActInfoData
LWUIZombieRushMain.InfoBtnClick = InfoBtnClick
LWUIZombieRushMain.RewardBtnClick = RewardBtnClick
LWUIZombieRushMain.SearchBtnClick = SearchBtnClick
LWUIZombieRushMain.LeftBtnClick = LeftBtnClick
LWUIZombieRushMain.RightBtnClick = RightBtnClick
LWUIZombieRushMain.RefreshCurSelectDifficultyView = RefreshCurSelectDifficultyView
LWUIZombieRushMain.OnGetItemByIndex = OnGetItemByIndex
LWUIZombieRushMain.OnItemSnapFinish = OnItemSnapFinish
LWUIZombieRushMain.OnItemSnapNearestChanged = OnItemSnapNearestChanged
LWUIZombieRushMain.ClearDifficultySelectLoopView = ClearDifficultySelectLoopView
LWUIZombieRushMain.RefreshLeftAndRightBtnState = RefreshLeftAndRightBtnState
LWUIZombieRushMain.ShowSearchView = ShowSearchView
LWUIZombieRushMain.OnZombieRushSearchSuccess = OnZombieRushSearchSuccess
LWUIZombieRushMain.ShowNoOpenView = ShowNoOpenView
LWUIZombieRushMain.OnShow = OnShow
LWUIZombieRushMain.OnCreateAllianceSuccess = OnCreateAllianceSuccess
LWUIZombieRushMain.OnZombieRushSearchFailed = OnZombieRushSearchFailed
LWUIZombieRushMain.BtnPointDown = BtnPointDown
LWUIZombieRushMain.BtnPointUp = BtnPointUp
LWUIZombieRushMain.StopSearchSuccessDelayTimer = StopSearchSuccessDelayTimer
LWUIZombieRushMain.RefreshShowChallengingView = RefreshShowChallengingView
LWUIZombieRushMain.GoToBtnClick = GoToBtnClick
LWUIZombieRushMain.RefreshSearchBtnTextShow = RefreshSearchBtnTextShow
LWUIZombieRushMain.OnLevelChange = OnLevelChange
LWUIZombieRushMain.TimeSelectBtnClick = TimeSelectBtnClick
LWUIZombieRushMain.CanAttendNumBtnClick = CanAttendNumBtnClick
LWUIZombieRushMain.InitSelectState = InitSelectState
LWUIZombieRushMain.UpdateSelectData = UpdateSelectData
LWUIZombieRushMain.ArrowBtnClick = ArrowBtnClick
LWUIZombieRushMain.ChooseDiff = ChooseDiff
LWUIZombieRushMain.UpdateCanAttendNum = UpdateCanAttendNum
LWUIZombieRushMain.RemoveDiffItems = RemoveDiffItems
LWUIZombieRushMain.CdStateBtnClick = CdStateBtnClick
LWUIZombieRushMain.OpenPlayerListPop = OpenPlayerListPop
LWUIZombieRushMain.UpdatePlanInfo = UpdatePlanInfo
LWUIZombieRushMain.ShowCalendatBtnContent = ShowCalendatBtnContent
LWUIZombieRushMain.UpdateLevelInfo = UpdateLevelInfo
LWUIZombieRushMain.SetTimeSelectBtnState = SetTimeSelectBtnState
LWUIZombieRushMain.SetStartTime = SetStartTime
LWUIZombieRushMain.OnZombieExplainClick = OnZombieExplainClick
LWUIZombieRushMain.OnPassDayRefresh = OnPassDayRefresh
return LWUIZombieRushMain
