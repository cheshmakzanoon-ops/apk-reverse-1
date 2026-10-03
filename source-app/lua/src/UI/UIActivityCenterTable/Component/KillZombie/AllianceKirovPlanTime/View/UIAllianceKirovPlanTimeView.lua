local UIAllianceKirovPlanTimeView = BaseClass("UIAllianceKirovPlanTimeView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local OptionData = CS.TMPro.TMP_Dropdown.OptionData
local AllyDrillDiffItem = require("UI.UIActivityCenterTable.Component.KillZombie.AllianceKirovPlanTime.Component.AllianceKirovDiffItem")
local ItemHeight = 56.18

function UIAllianceKirovPlanTimeView:OnCreate()
  base.OnCreate(self)
  local userData = self:GetUserData()
  if type(userData) == "number" then
    self.nConfigId = userData
  elseif type(userData) == "table" then
    self.tParam = userData
  end
  self:ComponentDefine()
  self:DataDefine()
  self:RefreshTime()
  self:RefreshLevel()
  self:SetRecordToggle()
  self:OnTimeChange()
end

function UIAllianceKirovPlanTimeView:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIAllianceKirovPlanTimeView:ComponentDefine()
  self.btnConfirm = self:AddComponent(UIButton, "Root/confirmBtn")
  self.btnConfirm:SetOnClick(function()
    self:OnBtnConfirmClick()
  end)
  self.btnClose = self:AddComponent(UIButton, "Root/CloseBtn")
  self.btnClose:SetOnClick(function()
    self:OnBtnCloseClick()
  end)
  self.btnPanel = self:AddComponent(UIButton, "UICommonPopUpTitle/panel")
  self.btnPanel:SetOnClick(function()
    self:OnBtnPanelClick()
  end)
  self.textTimeZone = self:AddComponent(UITextMeshProUGUIEx, "Root/timeSelect/timeZone")
  self.rawImgBanner = self:AddComponent(UIRawImage, "Root/bannerImg")
  self.textToggle = self:AddComponent(UITextMeshProUGUIEx, "Root/Toggle/ToggleText")
  self.toggleSelect = self:AddComponent(UIToggle, "Root/Toggle/SelectToggle")
  self.textDate = self:AddComponent(UITextMeshProUGUIEx, "Root/timeSelect/Date/dateTxt")
  self.imgLevelDrop = self:AddComponent(UIImage, "Root/levelDrop/Arrow")
  self.dateDrop = self:AddComponent(UIDropdown, "Root/timeSelect/dateDrop")
  self.dateDrop:SetOnValueChanged(function(nIndex)
    self:OnDateChange(nIndex)
  end)
  self.hourDrop = self:AddComponent(UIDropdown, "Root/timeSelect/hourDrop")
  self.hourDrop:SetOnValueChanged(function()
    self:OnHourChange()
  end)
  self.hourDrop:RegisterCreateDropdownListCallBack(function()
    self:SetDefaultDropDownPos(true, self.hourDrop)
  end)
  self.minDrop = self:AddComponent(UIDropdown, "Root/timeSelect/minDrop")
  self.minDrop:SetOnValueChanged(function()
    self:OnMinuteChange()
  end)
  self.minDrop:RegisterCreateDropdownListCallBack(function()
    self:SetDefaultDropDownPos(false, self.minDrop)
  end)
  self.levelDrop = self:AddComponent(UIDropdown, "Root/levelDrop")
  if self.nConfigId and self.nConfigId > 0 then
    CS.UIGray.SetGray(self.imgLevelDrop.transform, true, false)
    self.levelDrop:SetInteractable(false)
  else
    CS.UIGray.SetGray(self.imgLevelDrop.transform, false, true)
    self.levelDrop:SetInteractable(true)
  end
  self.diffBtn = self:AddComponent(UIButton, "Root/levelDrop/Arrow")
  self.diffBtn:SetOnClick(function()
    self:OnClickDiffBtn()
  end)
  self.diffLabel = self:AddComponent(UIText, "Root/levelDrop/Label")
  self.textHour = self:AddComponent(UITextMeshProUGUIEx, "Root/timeSelect/hourDrop/LabelHour")
  self.textMin = self:AddComponent(UITextMeshProUGUIEx, "Root/timeSelect/minDrop/LabelMin")
  self.textHour.transform.localScale = Vector3.one
  self.textMin.transform.localScale = Vector3.one
  self.Blocker = self:AddComponent(UIButton, "Root/Blocker")
  self.Blocker:SetActive(false)
  self.Blocker:SetOnClick(function()
    self.Blocker:SetActive(false)
  end)
  self.content = self:AddComponent(UIBaseContainer, "Root/Blocker/layout/ScrollView/Viewport/Content")
  self.diffReqs = {}
  self.textToggle:SetText(Localization:GetString("appointment_time_last_select"))
  self.toggleSelect:SetOnValueChanged(function(isOn)
    self.bIsRecordTime = isOn
    CommonUtil.PlayerPrefsSetBool(SettingKeys.KIROV_BOSS_LAST_PLAN_TIME, isOn)
    self:SetLastRecordTime(isOn)
    if not isOn then
      self:SetRecommendTime()
    end
  end)
end

function UIAllianceKirovPlanTimeView:RemoveDiffItems()
  self.diffItems = {}
  self.content:RemoveComponents(AllyDrillDiffItem)
  if self.diffReqs then
    for _, v in pairs(self.diffReqs) do
      v:Destroy()
    end
    self.diffReqs = {}
  end
end

function UIAllianceKirovPlanTimeView:ComponentDestroy()
  self.btnConfirm = nil
  self.btnClose = nil
  self.btnPanel = nil
  self.textTimeZone = nil
  self.rawImgBanner = nil
  self.textToggle = nil
  self.toggleSelect = nil
  self.textDate = nil
  self.imgLevelDrop = nil
  self:RemoveDiffItems()
  if self.seq then
    self.seq:Kill()
    self.seq = nil
  end
end

function UIAllianceKirovPlanTimeView:DataDefine()
  self.nSelectDate = 0
  self.nSelectHour = 0
  self.nSelectMinute = 0
  self.bFirstShow = true
  local nActivityId = DataCenter.ActivityKillZombieManager.activityId
  self.tActData = DataCenter.ActivityListDataManager:GetActivityDataById(nActivityId)
  self.nLastPlanTime = DataCenter.ActivityKillZombieManager:GetLastPlanTime()
  self.nMaxDifficulty = self.tParam and self.tParam.maxCanChallengeLevel
  self.bIsRecordTime = CommonUtil.PlayerPrefsGetBool(SettingKeys.KIROV_BOSS_LAST_PLAN_TIME, false)
end

function UIAllianceKirovPlanTimeView:SetRecordToggle()
  self.toggleSelect:SetIsOn(self.bIsRecordTime)
end

function UIAllianceKirovPlanTimeView:SetRecommendTime()
  local nCurTime = UITimeManager:GetInstance():GetServerTime()
  local tCurTimeDate = UITimeManager:GetInstance():TimeStampToServerDate(nCurTime)
  self.nRecommendTimeStamp = nCurTime + self.nRecommendCd * 1000
  self.tRecommendDate = UITimeManager:GetInstance():TimeStampToServerDate(self.nRecommendTimeStamp)
  self.nSelectHour = self.tRecommendDate.hour
  self.nSelectMinute = self.tRecommendDate.min
  if tCurTimeDate.day == self.tRecommendDate.day and tCurTimeDate.month == self.tRecommendDate.month then
    self.nSelectDate = 0
  elseif self.nShowDays > 1 then
    self.nSelectDate = 1
  else
    self.nSelectDate = 0
  end
  self.hourDrop:SetValue(self.nSelectHour)
  self.minDrop:SetValue(self.nSelectMinute)
  self.dateDrop:SetValue(self.nSelectDate)
  self:PlayTimeChangeAnim()
end

function UIAllianceKirovPlanTimeView:RefreshTime()
  self.nRecommendCd = LuaEntry.DataConfig:TryGetNum("advanced_challenge", "k14", 600)
  local nCurTime = UITimeManager:GetInstance():GetServerTime()
  self.nRecommendTimeStamp = nCurTime + self.nRecommendCd * 1000
  local tRecommendDate = UITimeManager:GetInstance():TimeStampToServerDate(self.nRecommendTimeStamp)
  self.tRecommendDate = tRecommendDate
  self.tCurTimeData = UITimeManager:GetInstance():TimeStampToServerDate(nCurTime)
  if self.nLastPlanTime and self.nLastPlanTime > 0 then
    self.tLastPlanTimeData = UITimeManager:GetInstance():TimeStampToServerDate(self.nLastPlanTime)
  end
  self.nStartZeroTime = UITimeManager:GetInstance():GetTodayZeroServerTime(nCurTime // 1000) * 1000
  local nDiff = UITimeManager:GetInstance():GetBetweenDaysForServerTime(self.nStartZeroTime / 1000, self.tActData.endTime / 1000)
  self.nShowDays = nDiff + 1
  self.dateDrop:Clear()
  for i = 0, self.nShowDays - 1 do
    local temp = OptionData()
    local tCurDate = UITimeManager:GetInstance():TimeStampToServerDate(self.nStartZeroTime + i * OneDayTime * 1000)
    temp.text = string.format("%d/%d", tCurDate.month, tCurDate.day)
    self.dateDrop:Add(temp)
  end
  self.hourDrop:Clear()
  for i = 0, 23 do
    local temp = OptionData()
    temp.text = string.format("%d", i)
    self.hourDrop:Add(temp)
  end
  self.minDrop:Clear()
  for i = 0, 59 do
    local temp = OptionData()
    temp.text = string.format("%d", i)
    self.minDrop:Add(temp)
  end
  if self.bIsRecordTime and self.nLastPlanTime and self.nLastPlanTime > 0 then
    self:SetLastRecordTime()
  else
    self.nSelectDate = 0
    self.nSelectHour = tRecommendDate.hour
    self.nSelectMinute = tRecommendDate.min
    self.hourDrop:SetValue(self.nSelectHour)
    self.minDrop:SetValue(self.nSelectMinute)
    self.dateDrop:SetValue(self.nSelectDate)
  end
end

function UIAllianceKirovPlanTimeView:SetLastRecordTime(isOn)
  if not (self.bIsRecordTime and self.nLastPlanTime) or self.nLastPlanTime <= 0 then
    return
  end
  local nLastRecordHour = self.tLastPlanTimeData.hour
  local nLastRecordMin = self.tLastPlanTimeData.min
  if nLastRecordHour < self.tCurTimeData.hour or nLastRecordHour == self.tCurTimeData.hour and nLastRecordMin < self.tCurTimeData.min then
    if self.nShowDays > 1 then
      if self.nSelectDate == 0 then
        self.nSelectDate = 1
      end
      self.nSelectHour = nLastRecordHour
      self.nSelectMinute = nLastRecordMin
    else
      self.nSelectDate = 0
      self.nSelectHour = self.tRecommendDate.hour
      self.nSelectMinute = self.tRecommendDate.min
    end
  else
    self.nSelectHour = nLastRecordHour
    self.nSelectMinute = nLastRecordMin
  end
  self.hourDrop:SetValue(self.nSelectHour)
  self.minDrop:SetValue(self.nSelectMinute)
  self.dateDrop:SetValue(self.nSelectDate)
  if isOn then
    self:PlayTimeChangeAnim()
  end
end

function UIAllianceKirovPlanTimeView:PlayTimeChangeAnim()
  if self.bFirstShow then
    self.bFirstShow = false
    return
  end
  if self.seq then
    self.seq:Kill()
    self.seq = nil
    self.textHour.transform.localScale = Vector3.one
    self.textMin.transform.localScale = Vector3.one
  end
  self.seq = DOTween.Sequence()
  self.seq:Append(self.textHour.transform:DOScale(Vector3.New(1.5, 1.5, 1.5), 0.2):SetLoops(2, CS.DG.Tweening.LoopType.Yoyo))
  self.seq:Join(self.textMin.transform:DOScale(Vector3.New(1.5, 1.5, 1.5), 0.2):SetLoops(2, CS.DG.Tweening.LoopType.Yoyo))
end

function UIAllianceKirovPlanTimeView:RefreshLevel()
  self:RemoveDiffItems()
  self.levelDrop:Clear()
  if self.nConfigId then
    local temp = OptionData()
    local nLevel = self.nConfigId % 1000
    temp.text = string.format("Lv.%d", nLevel)
    self.levelDrop:Add(temp)
    self.levelDrop:SetValue(1)
    self.nCurLevel = nLevel
  else
    for i = 1, self.nMaxDifficulty do
    end
    if self.nLastConfigId and self.nLastConfigId > 0 then
    else
      local nCurSelectId = self.tParam.curSelectedConfigId
      local nLevel = nCurSelectId % 1000
      self.levelDrop:SetValue(nLevel - 1)
      self.nCurLevel = nLevel
    end
    local nMaxOpenLevel = DataCenter.ActivityKillZombieManager.maxAlOpenDifficulty or 0
    for i = 1, nMaxOpenLevel do
      self.diffReqs[i] = self:GameObjectInstantiateAsync("Assets/Main/Prefabs/UI/ActivityCenter/KillZombie/AllianceKirovDiffItem.prefab", function(req)
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
        local cell = self.content:AddComponent(AllyDrillDiffItem, nameStr)
        cell:Refresh(i > self.nMaxDifficulty, i)
        cell:SetCheckmark(i == self.nCurLevel)
        self.diffItems[i] = cell
      end)
    end
  end
  self.diffLabel:SetText("Lv." .. self.nCurLevel)
end

function UIAllianceKirovPlanTimeView:ChooseDiff(difficulty)
  self.nCurLevel = difficulty
  self.diffLabel:SetText("Lv." .. self.nCurLevel)
  if self.diffItems then
    for k, v in pairs(self.diffItems) do
      v:SetCheckmark(v.nLevel == difficulty)
    end
  end
  self.Blocker:SetActive(false)
end

function UIAllianceKirovPlanTimeView:DataDestroy()
  self.tActData = nil
end

function UIAllianceKirovPlanTimeView:OnAddListener()
  base.OnAddListener(self)
end

function UIAllianceKirovPlanTimeView:OnRemoveListener()
  base.OnRemoveListener(self)
end

function UIAllianceKirovPlanTimeView:OnBtnConfirmClick()
  local nTargetTimeStamp = self.nStartZeroTime + (self.nSelectDate * OneDayTime + self.nSelectHour * OneHourTime + self.nSelectMinute * 60) * 1000
  local nLimitHour = LuaEntry.DataConfig:TryGetNum("advanced_challenge", "k13", 0)
  local nLimitTime = nLimitHour * OneHourTime * 1000
  local nCurTime = UITimeManager:GetInstance():GetServerTime()
  if nTargetTimeStamp < nCurTime then
    UIUtil.ShowTipsId("appointment_time_exceed_tips_2")
    return
  end
  if nTargetTimeStamp > self.tActData.endTime then
    UIUtil.ShowTipsId("370100")
    return
  end
  if nTargetTimeStamp >= self.tActData.endTime - nLimitTime then
    local sTip = Localization:GetString("appointment_time_count_down_hour", nLimitHour)
    UIUtil.ShowTips(sTip)
    return
  end
  local nCurPlanTime = DataCenter.ActivityKillZombieManager:GetBossPlanTimeFromServer() or 0
  if math.abs(nTargetTimeStamp - nCurPlanTime) < 5000 then
    UIUtil.ShowTipsId("appointment_time_exceed_tips_2")
    return
  end
  local tCfgData = DataCenter.ActivityKillZombieManager:GetDataWithTypeAndLevel(2, self.nCurLevel)
  DataCenter.ActivityKillZombieManager:SetBossPlanTime(nTargetTimeStamp)
  if self.nConfigId then
    SFSNetwork.SendMessage(MsgDefines.AllianceChallengeNewBuildToWorldUpdate, self.nConfigId, nTargetTimeStamp)
    self.ctrl.CloseSelf()
  else
    DataCenter.ActivityKillZombieManager:RequestPutNewBuildPoint(tCfgData.id)
  end
end

function UIAllianceKirovPlanTimeView:OnBtnCloseClick()
  self.ctrl.CloseSelf()
end

function UIAllianceKirovPlanTimeView:OnBtnPanelClick()
  self.ctrl.CloseSelf()
end

function UIAllianceKirovPlanTimeView:OnDateChange(nIndex)
  self.nSelectDate = nIndex
  self:OnTimeChange()
end

function UIAllianceKirovPlanTimeView:OnHourChange()
  self.nSelectHour = tonumber(self.hourDrop:GetText())
  self:OnTimeChange()
end

function UIAllianceKirovPlanTimeView:OnMinuteChange()
  self.nSelectMinute = tonumber(self.minDrop:GetText())
  self:OnTimeChange()
end

function UIAllianceKirovPlanTimeView:OnTimeChange()
  local nTime
  if self.nSelectHour and self.nSelectMinute then
    if self.nSelectHour == 0 then
      local hour = tonumber(self.hourDrop:GetText())
      local min = tonumber(self.minDrop:GetText())
      self.nSelectHour = hour and hour or 0
      self.nSelectMinute = min and min or 0
    end
    nTime = (self.nSelectDate * OneDayTime + self.nSelectHour * OneHourTime + self.nSelectMinute * 60) * 1000 + self.nStartZeroTime
  else
    nTime = self.nRecommendTimeStamp * 1000
  end
  local localTime = UITimeManager:GetInstance():TimeStampToTimeForLocalMinute(nTime)
  self.textTimeZone:SetLocalText(2010345, localTime)
end

function UIAllianceKirovPlanTimeView:OnLevelChange(index)
  self.nCurLevel = index + 1
end

function UIAllianceKirovPlanTimeView:OnClickDiffBtn()
  self.Blocker:SetActive(true)
end

function UIAllianceKirovPlanTimeView:SetDefaultDropDownPos(bIsHour, dropTrans)
  if IsNull(dropTrans) then
    return
  end
  local content = dropTrans.transform:Find("Dropdown List/Viewport/Content")
  if IsNull(content) then
    return
  end
  local nSelectMin = tonumber(dropTrans:GetText()) or 0
  local nTotalHeight = bIsHour and 24 * ItemHeight or 60 * ItemHeight
  local nViewportHeight = 330
  local targetPos = nSelectMin * ItemHeight
  local nCenterOffset = nViewportHeight / 2
  local nMaxScroll = nTotalHeight - nViewportHeight
  local nTargetY = math.min(targetPos - nCenterOffset, nMaxScroll)
  nTargetY = math.max(nTargetY, 0)
  content.transform.anchoredPosition = Vector2.New(0, nTargetY)
end

return UIAllianceKirovPlanTimeView
