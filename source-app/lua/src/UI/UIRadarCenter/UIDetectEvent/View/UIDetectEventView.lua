local UIDetectEventView = BaseClass("UIDetectEventView", UIBaseView)
local Localization = CS.GameEntry.Localization
local DetectEventItem = require("UI.UIRadarCenter.UIDetectEvent.Component.DetectEventItem")
local DetectEventRewardEffect = require("UI.UIRadarCenter.UIDetectEvent.Component.DetectEventRewardEffect")
local DetectEventItemInfoView = require("UI.UIRadarCenter.UIDetectEvent.Component.DetectEventItemInfoView")
local UIRadarSpecialEvent = require("UI.UIRadarCenter.UIDetectEvent.Component.UIRadarSpecialEvent")
local UIRadarNormalEvent = require("UI.UIRadarCenter.UIDetectEvent.Component.UIRadarNormalEvent")
local NormalEventInfo = require("UI.UIRadarCenter.UIDetectEvent.Component.NormalEventInfo")
local SpecialOpsEventInfo = require("UI.UIRadarCenter.UIDetectEvent.Component.SpecialOpsEventInfo")
local DetectEventLevelUpgradeInfoView = require("UI.UIRadarCenter.UIDetectEvent.Component.DetectEventLevelUpgradeInfoView")
local UIHeroTipView = require("UI.UIHero2.UIHeroTip.View.UIHeroTipView")
local FormationStaminaSlider = require("UI.UIFormation.UIFormationSelectListNew.Component.FormationStaminaSlider")
local base = UIBaseView
local safe_area_path = "safeArea/panel1"
local title_text_path = "safeArea/TitleText"
local close_btn_path = "safeArea/CloseBtn"
local bg_image_path = "Panel_BG1"
local radar_image_path = "safeArea/Panel_BG3"
local radar_level_path = "safeArea/LevelGo"
local radar_level_text_path = "safeArea/LevelGo/Level_Text"
local radar_level_slider_path = "safeArea/LevelGo/Slider"
local level_progress_path = "safeArea/LevelGo/Level_Fill_Background"
local radar_level_slider_text_path = "safeArea/LevelGo/Level_Fill_Background/Num"
local radar_level_info_btn_path = "safeArea/LevelGo/Level_Info_btn"
local radar_level_fill_amount_path = "safeArea/LevelGo/Level_Fill_Background/Level_Fill_Amount"
local max_progress_bg = "safeArea/LevelGo/Detect_bg_max"
local ani_path = ""
local event_items_path = "safeArea/EventsGo"
local event_reward_effect_path = "safeArea/RewardEffectGo"
local detect_event_info_path = "safeArea/DetectEventInfoGo"
local detect_level_info_path = "safeArea/DetectEventLevelGo"
local black1_path = "Panel_BG_Black1"
local black2_path = "Panel_BG_Black2"
local black3_path = "Panel_BG_Black3"
local black4_path = "Panel_BG_Black4"
local scan_effect_path = "safeArea/Panel_BG3/VFX_leida_saomiao"
local extra_effect_path = "safeArea/DetectEventInfoGo/UIExtraEffect"
local formationStaminaSlider_path = "safeArea/sliderBg"
local special_event_path = "safeArea/SpecialEvent"
local normal_event_path = "safeArea/NormalEvent"
local special_event_info_path = "safeArea/Special_Event_Info_Panel"
local normal_event_info_path = "safeArea/Normal_Event_Info_Panel"
local one_round_time = 5500.0
local one_round_show_time = 3060.0
local auto_request_time_gap = 5000.0

local function OnCreate(self)
  base.OnCreate(self)
  local uuid = self:GetUserData()
  self.uuid = uuid or nil
  self:DataDefine()
  self:ComponentDefine()
  self:GetDataFromServer()
end

local function ComponentDefine(self)
  self.detectEventItemInfo = nil
  self.detectEventItems = {}
  self.level_progress = self:AddComponent(UIBaseContainer, level_progress_path)
  self.max_progress_bg = self:AddComponent(UIBaseContainer, max_progress_bg)
  self.animator = self.transform:Find(ani_path):GetComponent(typeof(CS.UnityEngine.Animator))
  self.radar_image = self:AddComponent(UIImage, radar_image_path)
  self.bg_image = self:AddComponent(UIImage, bg_image_path)
  self.radar_level = self:AddComponent(UIBaseContainer, radar_level_path)
  self.radar_level_text = self:AddComponent(UIText, radar_level_text_path)
  self.radar_level_slider = self:AddComponent(UISlider, radar_level_slider_path)
  self.radar_level_slider_text = self:AddComponent(UIText, radar_level_slider_text_path)
  self.radar_level_info_btn = self:AddComponent(UIButton, radar_level_info_btn_path)
  self.radar_level_fill_amount = self:AddComponent(UIImage, radar_level_fill_amount_path)
  self.radar_level_fill_amount:SetFillAmount(0)
  self.event_reward_effect = self:AddComponent(UIBaseContainer, event_reward_effect_path)
  self.event_items = self:AddComponent(UIBaseContainer, event_items_path)
  self.close_btn = self:AddComponent(UIButton, close_btn_path)
  self.title_text = self:AddComponent(UIText, title_text_path)
  self.formationStaminaSlider = self:AddComponent(FormationStaminaSlider, formationStaminaSlider_path)
  self.formationStaminaSlider:SetTipTop()
  self.title_text:SetLocalText(GameDialogDefine.RADAR_DETECT)
  self.close_btn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.radar_level_info_btn:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self:SetDetectEventLvInfoShowState(true)
  end)
  self.safe_area_btn = self:AddComponent(UIButton, safe_area_path)
  self.safe_area_btn:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self:SetDetectEventLvInfoShowState(false)
    self.view:SetCurrentSelectItemId(nil)
    self:HideSpecialOpsInfo()
    self:HideNormalInfo()
  end)
  self.black1 = self:AddComponent(UIImage, black1_path)
  self.black2 = self:AddComponent(UIImage, black2_path)
  self.black3 = self:AddComponent(UIImage, black3_path)
  self.black4 = self:AddComponent(UIImage, black4_path)
  local scale = Screen.height / 750
  local screenWidth = Screen.width / scale
  local halfScreenHeight = 375.0
  local halfScreenWidth = screenWidth / 2
  self.black1.rectTransform:Set_sizeDelta(halfScreenWidth, halfScreenHeight)
  self.black2.rectTransform:Set_sizeDelta(halfScreenWidth, halfScreenHeight)
  self.black3.rectTransform:Set_sizeDelta(halfScreenWidth, halfScreenHeight)
  self.black4.rectTransform:Set_sizeDelta(halfScreenWidth, halfScreenHeight)
  self.scan_effect = self.transform:Find(scan_effect_path).gameObject
  DataCenter.LWSoundManager:PlaySound(SoundAssetId.Music_Effect_Radar, false)
  DOTween.Restart(self.radar_image.gameObject)
  DOTween.Restart(self.bg_image.gameObject)
  self.extra_effect = self:AddComponent(UIExtraEffect, extra_effect_path)
  self.specialEvent = self:AddComponent(UIRadarSpecialEvent, special_event_path)
  self.normalEvent = self:AddComponent(UIRadarNormalEvent, normal_event_path)
end

local function DataDefine(self)
  self.currentSelectEventId = nil
  self.showDetectEventLvInfo = false
  self.showDetectEventPowerLvInfo = false
  self.isGettingData = false
  self.isLoading = {}
  self.freeItemInfoCells = {}
  self.itemInfoCells = {}
  self.dataList = {}
  self.allRewardAnimation = {}
  self.panelOpenTime = UITimeManager:GetInstance():GetServerTime()
  self.preAngle = 0
  self.currentFillPercent = 0
  self.lastAutoTime = 0
  self.needRefresh = false
end

local function OnDestroy(self)
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

local function ComponentDestroy(self)
  self:HideDetectEventItemInfo()
  self:HideDetectLevelInfoView()
  self:HideNormalInfo()
  self:HideSpecialOpsInfo()
  self.animator:Play("HideDetectEventInfo")
  self.detectEventItemInfo = nil
  self.detectEventItems = nil
  self.radar_level = nil
  self.radar_level_text = nil
  self.radar_level_slider = nil
  self.radar_level_slider_text = nil
  self.radar_level_info_btn = nil
  self.animator = nil
  self.close_btn = nil
  self.title_text = nil
  self.event_items = nil
  self.radar_image = nil
  self.bg_image = nil
  self.event_reward_effect = nil
  self.extra_effect = nil
  self.formationStaminaSlider = nil
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function DataDestroy(self)
  self.uuid = nil
  self.currentSelectEventId = nil
  self.isGettingData = nil
  self.showDetectEventLvInfo = nil
  self.showDetectEventPowerLvInfo = nil
  self.isLoading = nil
  self.freeItemInfoCells = nil
  self.itemInfoCells = nil
  self.dataList = nil
  self.panelOpenTime = nil
  self.preAngle = nil
  self.allRewardAnimation = nil
  self.currentFillPercent = nil
  self.lastAutoTime = nil
  self.needRefresh = nil
end

local function RefreshView(self)
  if self.isGettingData then
    return
  end
  self.needRefresh = false
  self.dataList = self.ctrl:GetRadarCenterPositionList()
  local specialEventData = self.ctrl:GetSpecialEventData()
  if specialEventData ~= nil then
    self.specialEvent:SetData(specialEventData)
  end
  self:RefreshDetectEventItems()
  self:RefreshLevelInfo()
  self:RefreshPowerInfo()
  if self.currentSelectEventId ~= nil then
    self:ShowDetectEventItemInfo()
  else
    self:HideDetectEventItemInfo()
  end
  if self.showDetectEventLvInfo then
    self:ShowDetectLevelInfoView()
  else
    self:HideDetectLevelInfoView()
  end
  if self.normalInfo ~= nil and self.normalInfo:GetActive() then
    self:ShowNormalInfo()
  end
  if self.specialOpsInfo ~= nil and self.specialOpsInfo:GetActive() then
    self:ShowSpecialOpsInfo()
  end
  local maxNum = self.ctrl:GetEventStoreMax()
  local currentNum = DataCenter.RadarCenterDataManager:GetMaxDetectNum()
  self.normalEvent:SetData(currentNum, maxNum)
  self:Update()
end

local function SetDetectEventLvInfoShowState(self, showFlag)
  self.showDetectEventLvInfo = showFlag
  if self.showDetectEventLvInfo then
    self:ShowDetectLevelInfoView()
  else
    self:HideDetectLevelInfoView()
  end
end

local function RefreshDetectEventItems(self)
  local newItem = {}
  table.walk(self.dataList, function(k, v)
    if self.itemInfoCells[v.uuid] == nil then
      newItem[v.uuid] = 1
    end
  end)
  table.walk(self.itemInfoCells, function(k, v)
    v:SetActive(false)
    table.insert(self.freeItemInfoCells, v)
  end)
  self.itemInfoCells = {}
  self.ctrl:ResetAllPosition()
  table.walk(self.dataList, function(k, v)
    self:AddOneDetectEventItem(v, newItem[v.uuid])
  end)
  newItem = nil
end

local function RefreshLevelInfo(self)
  local level = DataCenter.RadarCenterDataManager:GetDetectInfoLevel()
  local maxLv = self.view.ctrl:GetDetectEventMaxLevel()
  self.radar_level_text:SetLocalText(GameDialogDefine.DETECT_POWER, level)
  if level < maxLv then
    self.level_progress:SetActive(true)
    self.max_progress_bg:SetActive(false)
    local max = self.ctrl:GetDetectEventLevelUpNum(level)
    local current = DataCenter.RadarCenterDataManager:GetDetectInfoCompleteNum()
    local text = string.GetFormattedSeperatorNum(current) .. "/" .. string.GetFormattedSeperatorNum(max)
    self.radar_level_slider_text:SetText(text)
    self.radar_level_fill_amount:SetFillAmount(current / max)
    self.currentFillPercent = current / max
  else
    self.level_progress:SetActive(false)
    self.max_progress_bg:SetActive(true)
  end
end

local function RefreshPowerInfo(self)
end

local function AddOneDetectEventItem(self, param, isNew)
  if #self.freeItemInfoCells > 0 then
    local temp = table.remove(self.freeItemInfoCells)
    if temp ~= nil then
      temp:SetActive(true)
      temp.transform:SetParent(self.event_items.transform)
      temp:SetUuid(param, self.currentSelectEventId)
      self.itemInfoCells[param.uuid] = temp
      if self.currentSelectEventId == param.uuid or isNew ~= nil then
        DOTween.Restart(temp.gameObject)
      end
      temp.transform.localPosition = self.ctrl:GetDetectEventPosition(param.uuid)
      temp.transform:SetAsLastSibling()
    end
  else
    self:GameObjectInstantiateAsync(UIAssets.DetectEventItem, function(request)
      if request.isError then
        return
      end
      local go = request.gameObject
      go:SetActive(true)
      go.transform:SetParent(self.event_items.transform)
      go.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
      local nameStr = tostring(NameCount)
      go.name = nameStr
      NameCount = NameCount + 1
      self.itemInfoCells[param.uuid] = self.event_items:AddComponent(DetectEventItem, nameStr)
      self.itemInfoCells[param.uuid]:SetUuid(param, self.currentSelectEventId)
      if self.uuid ~= nil and self.uuid == param.uuid then
        self:SetCurrentSelectItemId(param.uuid)
      end
      go.transform.localPosition = self.ctrl:GetDetectEventPosition(param.uuid)
      go.transform:SetAsLastSibling()
    end)
  end
end

local function OnAddListener(self)
  base.OnAddListener(self)
  self:AddUIListener(EventId.GetAllDetectInfo, self.DoWhenListDataBack)
  self:AddUIListener(EventId.UpgradeDetectPower, self.DoWhenDataChange)
  self:AddUIListener(EventId.DetectInfoChange, self.DoWhenDataChange)
  self:AddUIListener(EventId.DetectEventRewardGet, self.ShowRewardGetAnimation)
end

local function OnRemoveListener(self)
  self:RemoveUIListener(EventId.DetectEventRewardGet, self.ShowRewardGetAnimation)
  self:RemoveUIListener(EventId.GetAllDetectInfo, self.DoWhenListDataBack)
  self:RemoveUIListener(EventId.UpgradeDetectPower, self.DoWhenDataChange)
  self:RemoveUIListener(EventId.DetectInfoChange, self.DoWhenDataChange)
  base.OnRemoveListener(self)
end

local function RefreshFormationStamina(self)
  self.formationStaminaSlider:UpdateStamina()
end

local function Update(self)
  if self.specialEvent ~= nil then
    self.specialEvent:RefreshTime()
  end
  if self.normalInfo ~= nil and self.normalInfo:GetActive() then
    self.normalInfo:RefreshTime()
  end
  if self.specialOpsInfo and self.specialOpsInfo:GetActive() then
    self.specialOpsInfo:RefreshTime()
  end
  if self.needRefresh == true then
    self:RefreshView()
    return
  end
  if self.formationStaminaSlider == nil then
    return
  end
  self:RefreshFormationStamina()
  local time = self.ctrl:GetRefreshLeftTime()
  local curTime = UITimeManager:GetInstance():GetServerTime()
  local maxNum = self.ctrl:GetEventStoreMax()
  local currentNum = DataCenter.RadarCenterDataManager:GetMaxDetectNum()
  if time < 0 and curTime - self.lastAutoTime > auto_request_time_gap and maxNum > currentNum then
    self:GetDataFromServer()
    self.lastAutoTime = curTime
    return
  end
  self:CheckAndPlayScanEffect()
end

local function GetDataFromServer(self)
  if self.isGettingData then
    return
  end
  self.isGettingData = true
  DataCenter.RadarCenterDataManager:GetDetectEventData()
end

local function DoWhenListDataBack(self)
  self.isGettingData = false
  self.needRefresh = true
end

local function DoWhenDataChange(self)
  self.needRefresh = true
end

local function SetCurrentSelectItemId(self, detectEventId)
  table.walk(self.itemInfoCells, function(k, v)
    v:setSelectUuid(detectEventId)
  end)
  self.currentSelectEventId = detectEventId
  if self.currentSelectEventId == nil then
    self:HideDetectEventItemInfo()
  else
    self:ShowDetectEventItemInfo()
  end
end

local function ShowDetectEventItemInfo(self)
  if self.detectEventItemInfo == nil then
    self.detectEventItemInfo = self:AddComponent(DetectEventItemInfoView, detect_event_info_path)
  end
  self.detectEventItemInfo:SetCurrentSelectUuid(self.currentSelectEventId)
  self.detectEventItemInfo:SetActive(true)
  if self.itemInfoCells[self.currentSelectEventId] ~= nil then
    if self.itemInfoCells[self.currentSelectEventId].transform.localPosition.x > 0 then
      if 0 <= self.radar_image.transform.localPosition.x then
        self.animator:Play("ShowDetectEventInfo")
      end
    elseif 0 > self.radar_image.transform.localPosition.x then
      self.animator:Play("HideDetectEventInfo")
    end
  end
  self:SetDetectEventLvInfoShowState(false)
  self:HideNormalInfo()
  self:HideSpecialOpsInfo()
end

local function HideDetectEventItemInfo(self)
  if self.detectEventItemInfo ~= nil then
    self.detectEventItemInfo:SetActive(false)
  end
  if self.radar_image.transform.localPosition.x < 0 then
    self.animator:Play("HideDetectEventInfo")
  end
end

local function ShowDetectLevelInfoView(self)
  if self.detectEventLevelUpgradeInfoView == nil then
    self.detectEventLevelUpgradeInfoView = self:AddComponent(DetectEventLevelUpgradeInfoView, detect_level_info_path)
  end
  self.detectEventLevelUpgradeInfoView:SetActive(true)
  self:SetCurrentSelectItemId(nil)
  self:HideNormalInfo()
  self:HideSpecialOpsInfo()
end

local function HideDetectLevelInfoView(self)
  if self.detectEventLevelUpgradeInfoView ~= nil then
    self.detectEventLevelUpgradeInfoView:SetActive(false)
  end
end

local function OnPowerUpgradeClick(self)
  if not self:IsReachPowerMax() then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIDetectEventPowerUpgrade)
    self:SetDetectEventLvInfoShowState(false)
    self.view:SetCurrentSelectItemId(nil)
  end
end

local function IsReachPowerMax(self)
  local currentLv = DataCenter.RadarCenterDataManager:GetDetectInfoPower()
  local max = self.ctrl:GetDetectEventPowerMaxLevel()
  return currentLv >= max
end

local function CheckAndPlayScanEffect(self)
  local totalTime = math.fmod(UITimeManager:GetInstance():GetServerTime() - self.panelOpenTime, one_round_time)
  if totalTime > one_round_show_time then
    self.scan_effect:SetActive(false)
  else
    self.scan_effect:SetActive(true)
  end
  local currentAngle = totalTime * 360 / one_round_show_time
  currentAngle = math.min(currentAngle, 360)
  if currentAngle == 360 then
    currentAngle = 0
  end
  table.walk(self.itemInfoCells, function(k, v)
    local pos_x, pos_y = v.transform:Get_localPosition()
    local angle = self:GetAngleByPos(0, 0, pos_x, pos_y)
    if angle >= self.preAngle and angle <= currentAngle then
      v:ShowRadarScanEffect()
    end
  end)
  self.preAngle = currentAngle
end

local function GetAngleByPos(self, p1_x, p1_y, p2_x, p2_y)
  local px = p2_x - p1_x
  local py = p2_y - p1_y
  local r = math.atan(py, px) * 180 / math.pi + 720
  r = math.fmod(r, 360)
  return r
end

local function ShowRewardGetAnimation(self, eventUuid)
  local param = self.ctrl:GetOneEventData(eventUuid)
  if param ~= nil and self.itemInfoCells[eventUuid] ~= nil and self.itemInfoCells[eventUuid].transform ~= nil then
    local lvProgressTransform = self.radar_level_fill_amount.transform
    local rect = self.radar_level_fill_amount.rectTransform.rect
    param.lvPosX = lvProgressTransform.position.x + rect.width * (self.currentFillPercent - 0.5)
    param.eventPos = self.itemInfoCells[eventUuid].transform.position
    self:GameObjectInstantiateAsync(UIAssets.DetectEventRewardEffect, function(request)
      if request.isError then
        return
      end
      local go = request.gameObject
      go:SetActive(true)
      go.transform:SetParent(self.event_reward_effect.transform)
      go.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
      go.transform:Set_localPosition(0, 0, 0)
      local nameStr = tostring(NameCount)
      go.name = nameStr
      NameCount = NameCount + 1
      param.name = nameStr
      self.allRewardAnimation[nameStr] = self.event_reward_effect:AddComponent(DetectEventRewardEffect, nameStr)
      self.allRewardAnimation[nameStr]:SetParam(param)
    end)
  end
end

local function RemoveRewardGetAnimation(self, nameStr)
  if self.allRewardAnimation[nameStr] ~= nil then
    self.event_reward_effect:RemoveComponents(nameStr)
    self.allRewardAnimation[nameStr] = nil
  end
end

local function GetGuideSpecialBubble(self, eventType, state)
  local info = DataCenter.RadarCenterDataManager:GetOneInfoByEventTypeAndState(eventType, state)
  if info ~= nil and self.itemInfoCells[info.uuid] ~= nil then
    return self.itemInfoCells[info.uuid]:GetGuideObject()
  end
end

local function ShowSpecialOpsInfo(self)
  if self.specialOpsInfo == nil then
    self.specialOpsInfo = self:AddComponent(SpecialOpsEventInfo, special_event_info_path)
  end
  local data = self.ctrl:GetSpecialOpsEventInfo()
  if data ~= nil then
    self.specialOpsInfo:SetActive(true)
    self.specialOpsInfo:SetData(data)
    self:SetDetectEventLvInfoShowState(false)
    self.view:SetCurrentSelectItemId(nil)
    self:HideNormalInfo()
  else
    self:HideSpecialOpsInfo()
  end
end

local function HideSpecialOpsInfo(self)
  if self.specialOpsInfo ~= nil then
    self.specialOpsInfo:SetActive(false)
  end
end

local function ShowNormalInfo(self)
  if self.normalInfo == nil then
    self.normalInfo = self:AddComponent(NormalEventInfo, normal_event_info_path)
  end
  local data = self.ctrl:GetNormalEventInfo()
  if data ~= nil then
    self.normalInfo:SetActive(true)
    self.normalInfo:SetData(data)
    self:SetDetectEventLvInfoShowState(false)
    self.view:SetCurrentSelectItemId(nil)
    self:HideSpecialOpsInfo()
  else
    self:HideNormalInfo()
  end
end

local function HideNormalInfo(self)
  if self.normalInfo ~= nil then
    self.normalInfo:SetActive(false)
  end
end

UIDetectEventView.ShowSpecialOpsInfo = ShowSpecialOpsInfo
UIDetectEventView.HideSpecialOpsInfo = HideSpecialOpsInfo
UIDetectEventView.ShowNormalInfo = ShowNormalInfo
UIDetectEventView.HideNormalInfo = HideNormalInfo
UIDetectEventView.OnCreate = OnCreate
UIDetectEventView.OnDestroy = OnDestroy
UIDetectEventView.ComponentDefine = ComponentDefine
UIDetectEventView.ComponentDestroy = ComponentDestroy
UIDetectEventView.DataDefine = DataDefine
UIDetectEventView.DataDestroy = DataDestroy
UIDetectEventView.Update = Update
UIDetectEventView.RefreshView = RefreshView
UIDetectEventView.OnAddListener = OnAddListener
UIDetectEventView.OnRemoveListener = OnRemoveListener
UIDetectEventView.GetDataFromServer = GetDataFromServer
UIDetectEventView.DoWhenDataChange = DoWhenDataChange
UIDetectEventView.SetCurrentSelectItemId = SetCurrentSelectItemId
UIDetectEventView.ShowDetectEventItemInfo = ShowDetectEventItemInfo
UIDetectEventView.HideDetectEventItemInfo = HideDetectEventItemInfo
UIDetectEventView.ShowDetectLevelInfoView = ShowDetectLevelInfoView
UIDetectEventView.HideDetectLevelInfoView = HideDetectLevelInfoView
UIDetectEventView.RefreshDetectEventItems = RefreshDetectEventItems
UIDetectEventView.AddOneDetectEventItem = AddOneDetectEventItem
UIDetectEventView.DoWhenListDataBack = DoWhenListDataBack
UIDetectEventView.RefreshLevelInfo = RefreshLevelInfo
UIDetectEventView.RefreshPowerInfo = RefreshPowerInfo
UIDetectEventView.OnPowerUpgradeClick = OnPowerUpgradeClick
UIDetectEventView.IsReachPowerMax = IsReachPowerMax
UIDetectEventView.SetDetectEventLvInfoShowState = SetDetectEventLvInfoShowState
UIDetectEventView.CheckAndPlayScanEffect = CheckAndPlayScanEffect
UIDetectEventView.OnDisable = OnDisable
UIDetectEventView.OnEnable = OnEnable
UIDetectEventView.GetAngleByPos = GetAngleByPos
UIDetectEventView.ShowRewardGetAnimation = ShowRewardGetAnimation
UIDetectEventView.RemoveRewardGetAnimation = RemoveRewardGetAnimation
UIDetectEventView.GetGuideSpecialBubble = GetGuideSpecialBubble
UIDetectEventView.RefreshFormationStamina = RefreshFormationStamina
return UIDetectEventView
