local DetectEventItemInfoView = BaseClass("DetectEventItemInfoView", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local UIGiftRewardCell = require("UI.UIGiftPackageRewardGet.Component.UIGiftRewardCell")
local DetectEventRewardCell = require("UI.UIRadarCenter.UIDetectEvent.Component.DetectEventRewardCell")
local UIHeroTipView = require("UI.UIHero2.UIHeroTip.View.UIHeroTipView")
local title_text_path = "Detect_Event_Info_Title_Text"
local quality_title_path = "Detect_Event_Info_Quality_Title_Text"
local quality_text_path = "Detect_Event_Info_Quality_Text_Text"
local power_level_title_path = "Detect_Event_Info_Power_Title_Text"
local power_level_text_path = "Detect_Event_Info_Power_Text_Text"
local detect_event_time_go_path = "Detect_Event_Time_GO"
local disappear_time_text_path = "Detect_Event_Time_GO/Detect_Event_Info_Time_Text"
local description_text_path = "Detect_Event_Info_Description_Text"
local reward_get_title_path = "Detect_Event_Reward_Get_Title_Text"
local goto_btn_path = "Detect_Event_Info_Goto_Btn"
local goto_btn_text_path = "Detect_Event_Info_Goto_Btn/Detect_Event_Info_Goto_Btn_Text"
local reward_get_btn_path = "Detect_Event_Info_Reward_Get_Btn"
local reward_get_btn_text_path = "Detect_Event_Info_Reward_Get_Btn/Detect_Event_Info_Reward_Get_Btn_Text"
local marching_text_path = "Detect_Event_Marching_Text"
local infoBtn_path = "infoButton"
local resetBtn_path = "resetButton"
local scroll_view_path = "ScrollView"

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

local function ComponentDefine(self)
  self.title_text = self:AddComponent(UIText, title_text_path)
  self.quality_title = self:AddComponent(UIText, quality_title_path)
  self.quality_text = self:AddComponent(UIText, quality_text_path)
  self.power_level_title = self:AddComponent(UIText, power_level_title_path)
  self.power_level_text = self:AddComponent(UIText, power_level_text_path)
  self.disappear_time_text = self:AddComponent(UIText, disappear_time_text_path)
  self.description_text = self:AddComponent(UIText, description_text_path)
  self.reward_get_title = self:AddComponent(UIText, reward_get_title_path)
  self.goto_btn_text = self:AddComponent(UIText, goto_btn_text_path)
  self.reward_get_btn_text = self:AddComponent(UIText, reward_get_btn_text_path)
  self.goto_btn = self:AddComponent(UIButton, goto_btn_path)
  self.reward_get_btn = self:AddComponent(UIButton, reward_get_btn_path)
  self.detect_event_time_go = self:AddComponent(UIBaseContainer, detect_event_time_go_path)
  self.marching_text = self:AddComponent(UIText, marching_text_path)
  self.quality_title:SetLocalText(GameDialogDefine.DETECT_EVENT_QUALITY)
  self.power_level_title:SetLocalText(GameDialogDefine.DETECT_POWER)
  self.reward_get_btn_text:SetLocalText(GameDialogDefine.GET_REWARD)
  self.reward_get_title:SetLocalText(GameDialogDefine.MAY_GET)
  self.marching_text:SetLocalText(GameDialogDefine.GO_TO_DETECT_EVENT_POINT)
  self.goto_btn_text:SetLocalText(GameDialogDefine.GOTO)
  self.infoBtn = self:AddComponent(UIButton, infoBtn_path)
  self.resetBtn = self:AddComponent(UIButton, resetBtn_path)
  self.resetBtn:SetActive(false)
  self.infoBtn:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self:OnInfoClick()
  end)
  self.resetBtn:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self:OnResetClick()
  end)
  self.goto_btn:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self.view.ctrl:Goto(self.uuid)
  end)
  self.reward_get_btn:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self:GetReward()
  end)
  self.scroll_view = self:AddComponent(UIScrollView, scroll_view_path)
  self.scroll_view:SetOnItemMoveIn(function(itemObj, index)
    self:OnCreateCell(itemObj, index)
  end)
  self.scroll_view:SetOnItemMoveOut(function(itemObj, index)
    self:OnDeleteCell(itemObj, index)
  end)
end

local function ShowCells(self)
  self:ClearScroll()
  if self.rewardList == nil then
    return
  end
  local count = table.count(self.rewardList)
  if 0 < count then
    self.scroll_view:SetTotalCount(count)
    self.scroll_view:RefillCells()
  end
end

local function ClearScroll(self)
  self.scroll_view:ClearCells()
  self.scroll_view:RemoveComponents(DetectEventRewardCell)
end

local function OnCreateCell(self, itemObj, index)
  itemObj.name = tostring(index)
  local cellItem = self.scroll_view:AddComponent(DetectEventRewardCell, itemObj)
  local rewardParam = self.rewardList[index]
  local param = DetectEventRewardCell.Param.New()
  param.rewardType = rewardParam.rewardType
  param.itemId = rewardParam.itemId
  param.count = rewardParam.count
  if param.rewardType == RewardType.FOOD then
  elseif param.rewardType == RewardType.RESOURCE_ITEM and param.itemId == ResourceItemId.HeroExp then
    param.count = DataCenter.HeroStationManager:CalcEffectedValue(param.count, HeroStationEffectType.HeroExp)
    param.count = Mathf.Round(param.count)
  end
  cellItem:ReInit(param)
end

local function OnDeleteCell(self, itemObj, index)
  self.scroll_view:RemoveComponent(itemObj.name, DetectEventRewardCell)
end

local function DataDefine(self)
  self.uuid = ""
  self.rewardList = {}
end

local function DataDestroy(self)
  self.uuid = nil
  self.rewardList = nil
end

local function OnDestroy(self)
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

local function ComponentDestroy(self)
end

local function SetCurrentSelectUuid(self, uuid)
  self.uuid = uuid
  local data = DataCenter.RadarCenterDataManager:GetDetectEventInfo(uuid)
  if data ~= nil then
    self.rewardList = data.rewardList
  end
  self:RefreshView()
end

local function RefreshView(self)
  local data = DataCenter.RadarCenterDataManager:GetDetectEventInfo(self.uuid)
  local template = DataCenter.DetectEventTemplateManager:GetDetectEventTemplate(data.eventId)
  if data == nil or template == nil then
    return
  end
  self.infoBtn:SetActive(template.type == DetectEventType.DetectEventTypeSpecial)
  local isGoto = DataCenter.RadarCenterDataManager:IsDetectEventDoing(self.uuid)
  self.goto_btn:SetActive(data.state == DetectEventState.DETECT_EVENT_STATE_NOT_FINISH and not isGoto)
  self.marching_text:SetActive(data.state == DetectEventState.DETECT_EVENT_STATE_NOT_FINISH and isGoto)
  self.reward_get_btn:SetActive(data.state == DetectEventState.DETECT_EVENT_STATE_FINISHED)
  self.title_text:SetText(template:GetRealName())
  self.power_level_text:SetText(string.GetFormattedSeperatorNum(DataCenter.RadarCenterDataManager:GetDetectInfoPower()))
  self.description_text:SetLocalText(template.description)
  self.resetBtn:SetActive(self.view.ctrl:IsCanReset(template.type))
  local qualityText = CommonUtil.GetDetectEventQualityName(template.quality)
  local color = CommonUtil.GetDetectEventQualityColor(template.quality)
  self.quality_text:SetColor(color)
  self.quality_text:SetLocalText(qualityText)
  self:ShowCells()
end

local function Update(self)
  local data = DataCenter.RadarCenterDataManager:GetDetectEventInfo(self.uuid)
  if data == nil or data.state == DetectEventState.DETECT_EVENT_STATE_REWARDED then
    self.view:SetCurrentSelectItemId(nil)
    return
  end
  local refreshTime = data.endTime
  local curTime = UITimeManager:GetInstance():GetServerTime()
  local leftTime = (refreshTime - curTime) / 1000
  local template = DataCenter.DetectEventTemplateManager:GetDetectEventTemplate(data.eventId)
  if template.type == DetectEventType.DetectEventTypeSpecial or template.type == DetectEventType.DetectEventRadarRally or template.type == DetectEventType.DetectEventPVE or template.type == DetectEventType.SPECIAL_OPS or data.state == DetectEventState.DETECT_EVENT_STATE_FINISHED then
    self.detect_event_time_go:SetActive(false)
  else
    self.detect_event_time_go:SetActive(true)
    if 0 <= leftTime then
      self.disappear_time_text:SetText(UITimeManager:GetInstance():SecondToFmtString(leftTime))
    elseif data.state ~= DetectEventState.DETECT_EVENT_STATE_FINISHED then
      EventManager:GetInstance():Broadcast(EventId.DetectInfoChange)
    end
  end
end

local function OnAddListener(self)
  self:AddUIListener(EventId.GetAllDetectInfo, self.DoWhenDataChange)
  self:AddUIListener(EventId.UpgradeDetectPower, self.DoWhenDataChange)
  self:AddUIListener(EventId.DetectInfoChange, self.DoWhenDataChange)
end

local function OnRemoveListener(self)
  self:RemoveUIListener(EventId.GetAllDetectInfo, self.DoWhenDataChange)
  self:RemoveUIListener(EventId.UpgradeDetectPower, self.DoWhenDataChange)
  self:RemoveUIListener(EventId.DetectInfoChange, self.DoWhenDataChange)
end

local function DoWhenDataChange(self)
  self:RefreshView()
end

local function GetReward(self)
  SFSNetwork.SendMessage(MsgDefines.DetectEventRewardReceive, self.uuid)
  self.view:SetCurrentSelectItemId(nil)
end

local function OnInfoClick(self)
  local scaleFactor = UIManager:GetInstance():GetScaleFactor()
  local position = self.infoBtn.transform.position + Vector3.New(-30, 0, 0) * scaleFactor
  local param = UIHeroTipView.Param.New()
  param.content = Localization:GetString("140059")
  param.dir = UIHeroTipView.Direction.LEFT
  param.defWidth = 210
  param.pivot = 0.5
  param.position = position
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeroTip, {anim = false}, param)
end

local function OnResetClick(self)
  self.view.ctrl:ResetDetectEvent(self.uuid)
  self.view:SetCurrentSelectItemId(nil)
end

DetectEventItemInfoView.OnCreate = OnCreate
DetectEventItemInfoView.OnDestroy = OnDestroy
DetectEventItemInfoView.ComponentDefine = ComponentDefine
DetectEventItemInfoView.ComponentDestroy = ComponentDestroy
DetectEventItemInfoView.DataDefine = DataDefine
DetectEventItemInfoView.DataDestroy = DataDestroy
DetectEventItemInfoView.SetCurrentSelectUuid = SetCurrentSelectUuid
DetectEventItemInfoView.RefreshView = RefreshView
DetectEventItemInfoView.OnAddListener = OnAddListener
DetectEventItemInfoView.OnRemoveListener = OnRemoveListener
DetectEventItemInfoView.DoWhenDataChange = DoWhenDataChange
DetectEventItemInfoView.OnCreateCell = OnCreateCell
DetectEventItemInfoView.OnDeleteCell = OnDeleteCell
DetectEventItemInfoView.GetReward = GetReward
DetectEventItemInfoView.Update = Update
DetectEventItemInfoView.ShowCells = ShowCells
DetectEventItemInfoView.ClearScroll = ClearScroll
DetectEventItemInfoView.OnInfoClick = OnInfoClick
DetectEventItemInfoView.OnResetClick = OnResetClick
return DetectEventItemInfoView
