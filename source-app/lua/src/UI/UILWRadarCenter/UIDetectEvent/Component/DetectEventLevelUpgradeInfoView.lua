local DetectEventLevelUpgradeInfoView = BaseClass("DetectEventLevelUpgradeInfoView", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local normal_path = "normal"
local max_path = "max"
local detectEventLevel_title_path = "normal/DetectEventLevel_Title"
local upgrade_condition_title_path = "normal/Upgrade_Condition_Title"
local upgrade_condition_text_path = "normal/Upgrade_Condition_Text"
local current_lv_text_path = "normal/Current_lv/Current_Lv_Text"
local current_lv_quality_title_path = "normal/Current_lv/Current_Lv_Quality_Title"
local current_lv_max_num_title_path = "normal/Current_lv/Current_Lv_Max_Num_Title"
local current_lv_max_num_text_path = "normal/Current_lv/Current_Lv_Max_Num_Text"
local current_event_max_num_text_path = "normal/Current_lv/Current_event_Max_Num_Text"
local current_event_max_num_title_path = "normal/Current_lv/Current_event_Max_Num_Title"
local Current_Lv_Time_Title_path = "normal/Current_lv/Current_Lv_Time_Title"
local Current_Lv_Time_path = "normal/Current_lv/Current_Lv_Time"
local next_lv_text_path = "normal/Next_lv/Next_Lv_Text"
local next_lv_quality_title_path = "normal/Next_lv/Next_Lv_Quality_Title"
local next_lv_max_num_title_path = "normal/Next_lv/Next_Lv_Max_Num_Title"
local next_lv_max_num_text_path = "normal/Next_lv/Next_Lv_Max_Num_Text"
local next_event_max_num_text_path = "normal/Next_lv/Next_event_Max_Num_Text"
local next_event_max_num_title_path = "normal/Next_lv/Next_event_Max_Num_Title"
local Next_Lv_Time_Title_path = "normal/Next_lv/Next_Lv_Time_Title"
local Next_Lv_Time_path = "normal/Next_lv/Next_Lv_Time"
local max_lv_text_path = "max/Max_lv/Max_Lv_Text"
local max_lv_quality_title_path = "max/Max_lv/Max_Lv_Quality_Title"
local max_lv_max_num_title_path = "max/Max_lv/Max_Lv_Max_Num_Title"
local max_lv_max_num_text_path = "max/Max_lv/Max_Lv_Max_Num_Text"
local max_event_max_num_text_path = "max/Max_lv/Max_event_Max_Num_Text"
local max_event_max_num_title_path = "max/Max_lv/Max_event_Max_Num_Title"
local Max_Lv_Time_Title_path = "max/Max_lv/Max_Lv_Time_Title"
local Max_Lv_Time_path = "max/Max_lv/Max_Lv_Time"
local rate_text_path = "normal/Rate_Text"
local rate_text2_path = "max/Rate_Text2"

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:ReInit()
end

local function ComponentDefine(self)
  self.detectEventLevel_title = self:AddComponent(UIText, detectEventLevel_title_path)
  self.upgrade_condition_title = self:AddComponent(UIText, upgrade_condition_title_path)
  self.upgrade_condition_text = self:AddComponent(UIText, upgrade_condition_text_path)
  self.detectEventLevel_title:SetText("")
  self.current_lv_text = self:AddComponent(UIText, current_lv_text_path)
  self.current_lv_quality_title = self:AddComponent(UIText, current_lv_quality_title_path)
  self.current_lv_max_num_title = self:AddComponent(UIText, current_lv_max_num_title_path)
  self.current_lv_max_num_text = self:AddComponent(UIText, current_lv_max_num_text_path)
  self.Current_Lv_Time_Title = self:AddComponent(UIText, Current_Lv_Time_Title_path)
  self.Current_Lv_Time = self:AddComponent(UIText, Current_Lv_Time_path)
  self.Current_Lv_Time_Title:SetLocalText(800804)
  self.next_lv_text = self:AddComponent(UIText, next_lv_text_path)
  self.next_lv_quality_title = self:AddComponent(UIText, next_lv_quality_title_path)
  self.next_lv_max_num_title = self:AddComponent(UIText, next_lv_max_num_title_path)
  self.next_lv_max_num_text = self:AddComponent(UIText, next_lv_max_num_text_path)
  self.Next_Lv_Time_Title = self:AddComponent(UIText, Next_Lv_Time_Title_path)
  self.Next_Lv_Time = self:AddComponent(UIText, Next_Lv_Time_path)
  self.Next_Lv_Time_Title:SetLocalText(800804)
  self.normal = self:AddComponent(UIBaseContainer, normal_path)
  self.max = self:AddComponent(UIBaseContainer, max_path)
  self.max_lv_text = self:AddComponent(UIText, max_lv_text_path)
  self.max_lv_quality_title = self:AddComponent(UIText, max_lv_quality_title_path)
  self.max_lv_max_num_title = self:AddComponent(UIText, max_lv_max_num_title_path)
  self.max_lv_max_num_text = self:AddComponent(UIText, max_lv_max_num_text_path)
  self.Max_Lv_Time_Title = self:AddComponent(UIText, Max_Lv_Time_Title_path)
  self.Max_Lv_Time = self:AddComponent(UIText, Max_Lv_Time_path)
  self.Max_Lv_Time_Title:SetLocalText(800804)
  self.current_lv_quality_title:SetText("")
  self.next_lv_quality_title:SetText("")
  self.max_lv_quality_title:SetText("")
  self.current_lv_max_num_title:SetLocalText(GameDialogDefine.DETECT_EVENT_MAX_NUM)
  self.next_lv_max_num_title:SetLocalText(GameDialogDefine.DETECT_EVENT_MAX_NUM)
  self.max_lv_max_num_title:SetLocalText(GameDialogDefine.DETECT_EVENT_MAX_NUM)
  self.current_event_max_num_text = self:AddComponent(UIText, current_event_max_num_text_path)
  self.next_event_max_num_text = self:AddComponent(UIText, next_event_max_num_text_path)
  self.max_event_max_num_text = self:AddComponent(UIText, max_event_max_num_text_path)
  self.current_event_max_num_title = self:AddComponent(UIText, current_event_max_num_title_path)
  self.next_event_max_num_title = self:AddComponent(UIText, next_event_max_num_title_path)
  self.max_event_max_num_title = self:AddComponent(UIText, max_event_max_num_title_path)
  self.current_event_max_num_title:SetLocalText(140069)
  self.next_event_max_num_title:SetLocalText(140069)
  self.max_event_max_num_title:SetLocalText(140069)
  self.rate_text = self:AddComponent(UITextMeshProUGUIEx, rate_text_path)
  self.rate_text:OnPointerClick(function(eventData)
    self:OnRateTextPointerClick(eventData.position)
  end)
  self.rate_text2 = self:AddComponent(UITextMeshProUGUIEx, rate_text2_path)
  self.rate_text2:OnPointerClick(function(eventData)
    self:OnRateTextPointerClick(eventData.position)
  end)
  self.rate_text:SetText(Localization:GetString("drop_info_title1"))
  self.rate_text2:SetText(Localization:GetString("drop_info_title1"))
end

local function OnDestroy(self)
  self:ComponentDestroy()
  base.OnDestroy(self)
end

local function ComponentDestroy(self)
  self.detectEventLevel_title = nil
  self.upgrade_condition_title = nil
  self.upgrade_condition_text = nil
  self.current_lv_text = nil
  self.current_lv_quality_title = nil
  self.current_lv_max_num_title = nil
  self.current_lv_max_num_text = nil
  self.next_lv_text = nil
  self.next_lv_quality_title = nil
  self.next_lv_max_num_title = nil
  self.next_lv_max_num_text = nil
  self.normal = nil
  self.max = nil
  self.max_lv_text = nil
  self.max_lv_quality_title = nil
  self.max_lv_max_num_title = nil
  self.max_lv_max_num_text = nil
  self.max_lv_quality_text_1 = nil
  self.max_lv_quality_text_2 = nil
  self.max_lv_quality_text_3 = nil
  self.max_lv_quality_text_4 = nil
  self.max_lv_quality_text_5 = nil
  self.max_lv_quality_text_6 = nil
  self.current_event_max_num_text = nil
  self.next_event_max_num_text = nil
  self.max_event_max_num_text = nil
  self.rate_text = nil
  self.rate_text2 = nil
end

local function ReInit(self)
  local currentLv = DataCenter.RadarCenterDataManager:GetDetectInfoLevel()
  local maxLv = self.view.ctrl:GetDetectEventMaxLevel()
  if currentLv < maxLv then
    self.normal:SetActive(true)
    self.max:SetActive(false)
    self:RefreshNormal()
  else
    self.normal:SetActive(false)
    self.max:SetActive(true)
    self:RefreshMax()
  end
end

local function RefreshNormal(self)
  local currentLv = DataCenter.RadarCenterDataManager:GetDetectInfoLevel()
  local nextLv = currentLv + 1
  local currentComplete = DataCenter.RadarCenterDataManager:GetDetectInfoCompleteNum()
  local nextLvNeed = self.view.ctrl:GetDetectEventLevelUpNum(currentLv)
  local currentLvEventNum = self.view.ctrl:GetDetectEventNum(currentLv)
  local nextLvEventNum = self.view.ctrl:GetDetectEventNum(nextLv)
  self.upgrade_condition_title:SetLocalText(GameDialogDefine.UPGRADE_CONDITION)
  self.upgrade_condition_text:SetLocalText(GameDialogDefine.DETECT_UPGRADE_CONDITION, nextLvNeed, currentComplete, nextLvNeed)
  self.current_lv_max_num_text:SetText(string.GetFormattedSeperatorNum(currentLvEventNum))
  self.next_lv_max_num_text:SetText(string.GetFormattedSeperatorNum(nextLvEventNum))
  local time = self.view.ctrl:GetEventRecoverNum(currentLv)
  local nextTime = self.view.ctrl:GetEventRecoverNum(nextLv)
  self.Current_Lv_Time:SetText(time)
  self.Next_Lv_Time:SetText(nextTime)
  self.current_lv_text:SetLocalText(GameDialogDefine.DETECT_POWER, currentLv)
  self.next_lv_text:SetLocalText(GameDialogDefine.DETECT_POWER, nextLv)
  local currentMax = self.view.ctrl:GetEventStoreMax(currentLv)
  local nextMax = self.view.ctrl:GetEventStoreMax(nextLv)
  self.current_event_max_num_text:SetText(currentMax)
  self.next_event_max_num_text:SetText(nextMax)
end

local function RefreshMax(self)
  local currentLv = DataCenter.RadarCenterDataManager:GetDetectInfoLevel()
  local currentLvEventNum = self.view.ctrl:GetDetectEventNum(currentLv)
  self.max_lv_max_num_text:SetText(string.GetFormattedSeperatorNum(currentLvEventNum))
  local time = self.view.ctrl:GetEventRecoverNum(currentLv)
  self.Max_Lv_Time:SetText(time)
  self.max_lv_text:SetLocalText(GameDialogDefine.DETECT_POWER, currentLv)
  local currentMax = self.view.ctrl:GetEventStoreMax(currentLv)
  self.max_event_max_num_text:SetText(currentMax)
end

local function OnRateTextPointerClick(self, clickPos)
  UIUtil.ShowIntro(Localization:GetString("drop_info_title1"), nil, Localization:GetString("drop_info_desc2"))
end

DetectEventLevelUpgradeInfoView.OnCreate = OnCreate
DetectEventLevelUpgradeInfoView.OnDestroy = OnDestroy
DetectEventLevelUpgradeInfoView.ComponentDefine = ComponentDefine
DetectEventLevelUpgradeInfoView.ComponentDestroy = ComponentDestroy
DetectEventLevelUpgradeInfoView.ReInit = ReInit
DetectEventLevelUpgradeInfoView.RefreshNormal = RefreshNormal
DetectEventLevelUpgradeInfoView.RefreshMax = RefreshMax
DetectEventLevelUpgradeInfoView.OnRateTextPointerClick = OnRateTextPointerClick
return DetectEventLevelUpgradeInfoView
