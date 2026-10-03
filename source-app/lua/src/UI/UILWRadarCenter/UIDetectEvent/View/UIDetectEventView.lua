local UIDetectEventView = BaseClass("UIDetectEventView", UIBaseView)
local Setting = CS.GameEntry.Setting
local ZOMBIE_BUS_TRAIN_SETTING_KEY = "ZOMBIE_BUS_TRAIN_KEY"
local Localization = CS.GameEntry.Localization
local DetectEventItem = require("UI.UILWRadarCenter.UIDetectEvent.Component.DetectEventItem")
local FakeZombieBusTrainDetectEventItem = require("UI.UILWRadarCenter.UIDetectEvent.Component.FakeZombieBusTrainDetectEventItem")
local DetectEventRewardEffect = require("UI.UILWRadarCenter.UIDetectEvent.Component.DetectEventRewardEffect")
local DetectEventItemInfoView = require("UI.UILWRadarCenter.UIDetectEvent.Component.DetectEventItemInfoView")
local DetectEventHelpTipContent = require("UI.UILWRadarCenter.UIDetectEvent.Component.DetectEventHelpTipContent")
local UIRadarNormalEvent = require("UI.UILWRadarCenter.UIDetectEvent.Component.UIRadarNormalEvent")
local UIGiftPackagePoint = require("UI.UIGiftPackage.Component.UIGiftPackagePoint")
local DetectEventLevelUpRewardBtn = require("UI.UILWRadarCenter.UIDetectEvent.Component.DetectEventLevelUpRewardBtn")
local NormalEventInfo = require("UI.UILWRadarCenter.UIDetectEvent.Component.NormalEventInfo")
local SpecialOpsEventInfo = require("UI.UILWRadarCenter.UIDetectEvent.Component.SpecialOpsEventInfo")
local DetectEventLevelUpgradeInfoNewView = require("UI.UILWRadarCenter.UIDetectEvent.Component.DetectEventLevelUpgradeInfoNewView")
local DetectEventCompleteOneClickBtnView = require("UI.UILWRadarCenter.UIDetectEvent.Component.DetectEventCompleteOneClickBtnView")
local UIHeroTipView = require("UI.UIHero2.UIHeroTip.View.UIHeroTipView")
local FormationStaminaSlider = require("UI.UIFormation.UIFormationSelectListNew.Component.FormationStaminaSlider")
local LWUIZombieRushContent = require("UI.UILWRadarCenter.UIDetectEvent.Component.LWUIZombieRushContent")
local BuffActInfoComp = require("UI.UILWRadarCenter.UIDetectEvent.Component.BuffActInfoComp")
local RewardUtil = require("Util.RewardUtil")
local LWBtnBuyRefundRemind = require("UI.LWBtnBuyRefundRemind.LWBtnBuyRefundRemind")
local AttackCityS0RadarEvent = require("UI.LWCityAttackS0.Radar.Tag.AttackCityS0NewRadarEventItem")
local base = UIBaseView
local safe_area_path = "safeArea/panel1"
local close_btn_path = "safeArea/CloseBtn"
local back_home_btn_path = "safeArea/BackHomeBtn"
local btn_complete_one_click_path = "safeArea/QuickOpt"
local radar_image_path = "safeArea/selfPos/selfPosAni/Panel_BG3"
local radar_contain_path = "safeArea/selfPos/selfPosAni/radarImg"
local radar_event_path = "safeArea/eventContent"
local radar_level_path = "safeArea/LevelGo"
local radar_level_text_path = "safeArea/LevelGo/Level_Text"
local level_up_reward_btn_path = "safeArea/LevelGo/level_up_reward_btn"
local level_progress_path = "safeArea/LevelGo/Level_Fill_Background"
local radar_level_slider_text_path = "safeArea/LevelGo/Level_Fill_Background/Num"
local radar_level_info_btn_path = "safeArea/LevelGo/Level_Info_btn"
local radar_level_fill_amount_path = "safeArea/LevelGo/Level_Fill_Background/Level_Fill_Amount"
local ani_path = ""
local event_items_path = "safeArea/EventsGo"
local cd_EventTips_path = "safeArea/CDEventTips"
local eventPosCal_path = "safeArea/EventsGo/eventPosCal"
local event_reward_effect_path = "safeArea/RewardEffectGo"
local detect_event_info_path = "safeArea/DetectEventInfoGo"
local detect_level_info_path = "safeArea/DetectEventLevelGo"
local scan_effect_path = "safeArea/selfPos/selfPosAni/Panel_BG3/VFX_leida_saomiao"
local formationStaminaSlider_path = "safeArea/sliderBg"
local normal_event_path = "safeArea/NormalEvent"
local normal_event_info_path = "safeArea/Normal_Event_Info_Panel"
local self_pos_path = "safeArea/selfPos/selfPosAni"
local self_pos_do_scale_path = "safeArea/selfPos/selfPosAni/selfPosScaleAni"
local wold_map_path = "BGContent/worldMap"
local self_pos_effect_mask_path = "safeArea/selfPos/selfPosAni/selfPosEffectMask"
local self_pos_effect_path = "safeArea/selfPos/selfPosAni/selfPosEffectMask/selfPosEffect"
local move_ani_path = "safeArea/selfPos"
local one_round_time = 5500.0
local one_round_show_time = 3060.0
local auto_request_time_gap = 5000.0
local giftPack_path = "safeArea/GiftPack"
local giftPack_name_text_path = "safeArea/GiftPack/GiftPackNameText"
local giftPack_desc_text_path = "safeArea/GiftPack/GiftPackDescText"
local giftPack_buy_btn_path = "safeArea/GiftPack/GiftPackBuyBtn"
local giftPack_price_text_path = "safeArea/GiftPack/GiftPackBuyBtn/GiftPackBuyBtnPriceText"
local giftPack_point_path = "safeArea/GiftPack/GiftPackBuyBtn/UIGiftPackagePoint"
local helpTipContent_path = "safeArea/helpTipContent"
local zombie_rush_content_path = "safeArea/ZombieRushContent"
local desc_btn_path = "safeArea/DescBtn"
local pop_btn_path = "safeArea/popBtn"
local desc_text_path = "safeArea/DescBtn/DescIcon/DescText"
local desc_icon_path = "safeArea/DescBtn/DescIcon"
local reward_enter_path = "safeArea/RewardEnter"
local frozen_bg_path = "safeArea/frozenBg"
local attackArrow = "safeArea/EventsGo/EffAttackArrow"
local self_main_city_image_path = "safeArea/selfPos/selfPosAni/radarImg/SelfMainCityImage"
local eff_ui_radar_saomiao_path = "safeArea/selfPos/selfPosAni/selfPosScaleAni/Eff_ui_radar_saomiao"
local b_g_content_path = "BGContent"
local p_ui_march_line_root_path = "safeArea/EventsGo/ui_march_line/p_ui_march_line_root"
local RadarFakeUIMarchLineComp = require("UI.UILWRadarCenter.UIDetectEvent.Component.RadarFakeUIMarchLineComp")
local ui_march_line_prefab_path = "Assets/Main/Prefabs/UI/UILWRadarCenter/Eff_ui_radar_line.prefab"
local white_bg_path = "WhiteBg"
local _LWUIVIPRadarEntranceClass

local function GetLWUIVIPRadarEntranceClass()
  if not _LWUIVIPRadarEntranceClass then
    _LWUIVIPRadarEntranceClass = require("UI.UILWRadarCenter.UIDetectEvent.Component.LWUIVIPRadarEntrance")
  end
  return _LWUIVIPRadarEntranceClass
end

function UIDetectEventView:RefreshVipRadarEntrance()
  local show, activityInfo = DataCenter.VipGiftActDataManager:CanShowRadarEntrance()
  if self.vipRadarEntrance then
    self.vipRadarEntrance:SetActive(show)
    if show then
      self.vipRadarEntrance:RefreshView()
    end
    return
  end
  if not show then
    return
  end
  local entranceClass = GetLWUIVIPRadarEntranceClass()
  if not entranceClass then
    return
  end
  self.vipRadarEntrance = self.radarEventContent:LoadComponentAsync(entranceClass, UIAssets.VIPRadarEntrance, self.radarEventContent)
end

local function OnCreate(self)
  base.OnCreate(self)
  local uuid, usePointer = self:GetUserData()
  self.uuid = uuid or nil
  self.usePointer = usePointer
  self:DataDefine()
  self:ComponentDefine()
  self:GetDataFromServer()
  self:SetSelfMapPosAtOpenAndPlayTween()
  self:CheckShowNormalInfo()
  DataCenter.RadarCenterDataManager:RecordDetectTriggerTime()
  DataCenter.RadarCenterDataManager.lastShowRadarZombieBusTime = UITimeManager:GetInstance():GetServerTime()
end

local function ComponentDefine(self)
  self.detectEventItemInfo = nil
  self.detectEventItems = {}
  self.level_progress = self:AddComponent(UIBaseContainer, level_progress_path)
  self.animator = self.transform:Find(ani_path):GetComponent(typeof(CS.UnityEngine.Animator))
  self.animator.enabled = true
  self.radar_image = self:AddComponent(UIImage, radar_image_path)
  self.radarEventContent = self:AddComponent(UIBaseContainer, radar_event_path)
  self.radar_level = self:AddComponent(UIBaseContainer, radar_level_path)
  self.radar_level_text = self:AddComponent(UIText, radar_level_text_path)
  self.level_up_reward_btn = self:AddComponent(DetectEventLevelUpRewardBtn, level_up_reward_btn_path)
  self.radar_level_slider_text = self:AddComponent(UIText, radar_level_slider_text_path)
  self.radar_level_info_btn = self:AddComponent(UIButton, radar_level_info_btn_path)
  self.radar_level_fill_amount = self:AddComponent(UIImage, radar_level_fill_amount_path)
  self.radar_level_fill_amount:SetSizeDelta(Vector2(0, self.level_progress:GetSizeDelta().y))
  self.event_reward_effect = self:AddComponent(UIBaseContainer, event_reward_effect_path)
  self.event_items = self:AddComponent(UIBaseContainer, event_items_path)
  self.cd_EventTips = self:AddComponent(UIBaseContainer, cd_EventTips_path)
  self.eventPosCal = self:AddComponent(UIBaseContainer, eventPosCal_path)
  self.close_btn = self:AddComponent(UIButton, close_btn_path)
  self.back_home_btn = self:AddComponent(UIButton, back_home_btn_path)
  self.btn_complete_one_click = self:AddComponent(DetectEventCompleteOneClickBtnView, btn_complete_one_click_path)
  self.btn_complete_one_click:SetActive(true)
  self.btn_complete_one_click:ReInit()
  self.formationStaminaSlider = self:AddComponent(FormationStaminaSlider, formationStaminaSlider_path)
  self.formationStaminaSlider:SetTipTop()
  self.self_pos = self:AddComponent(UIBaseContainer, self_pos_path)
  self.self_pos_do_scale = self:AddComponent(UIBaseContainer, self_pos_do_scale_path)
  self.self_pos_effect_mask = self:AddComponent(UIBaseContainer, self_pos_effect_mask_path)
  self.self_pos_effect = self:AddComponent(UIBaseContainer, self_pos_effect_path)
  self.wold_map = self:AddComponent(UIBaseContainer, wold_map_path)
  self.radar_contain = self:AddComponent(UIBaseContainer, radar_contain_path)
  self.move_ani = self:AddComponent(UIBaseContainer, move_ani_path)
  self.frozen_bg = self:AddComponent(UIImage, frozen_bg_path)
  self.frozen_bg:SetActive(false)
  self.attackArrow = self:AddComponent(UIBaseContainer, attackArrow)
  self.buffActInfoComp = self:AddComponent(BuffActInfoComp, "safeArea/eventContent/buffContent")
  self.buffActInfoComp:ReInit(EnumActivity.DetectS1Buff.Type, function()
    self:SetDetectEventLvInfoShowState(false)
  end)
  self.close_btn:SetOnClick(function()
    self:TryShowDetectEventRewardList()
    self.ctrl:CloseSelf()
  end)
  self.back_home_btn:SetOnClick(function()
    self:TryShowDetectEventRewardList()
    self.ctrl:BackHome()
  end)
  self.radar_level_info_btn:SetOnClick(function()
    if self.showDetectEventLvInfo == nil or self.showDetectEventLvInfo == false then
      self:SetDetectEventLvInfoShowState(true)
    else
      self:SetDetectEventLvInfoShowState(false)
    end
  end)
  self.safe_area_btn = self:AddComponent(UIButton, safe_area_path)
  self.safe_area_btn:SetOnClick(function()
    self:SetDetectEventLvInfoShowState(false)
    self.view:SetCurrentSelectItemId(nil)
    self:HideBuffDetail()
  end)
  local scale = Screen.height / 750
  local screenWidth = Screen.width / scale
  local halfScreenHeight = 375.0
  local halfScreenWidth = screenWidth / 2
  self.scan_effect = self.transform:Find(scan_effect_path).gameObject
  self.soundEffectRadar = DataCenter.LWSoundManager:PlaySound(SoundAssetId.Music_Effect_Radar, false)
  DOTween.Restart(self.radar_image.gameObject)
  self.normalEvent = self:AddComponent(UIRadarNormalEvent, normal_event_path)
  self.giftPack = self:AddComponent(UIBaseContainer, giftPack_path)
  self.giftPack:SetActive(false)
  self.giftPackNameText = self:AddComponent(UIText, giftPack_name_text_path)
  self.giftPackDescText = self:AddComponent(UIText, giftPack_desc_text_path)
  self.giftPackBuyBtn = self:AddComponent(LWBtnBuyRefundRemind, giftPack_buy_btn_path)
  self.giftPackBuyBtn:SetSafeClickMode(true)
  self.giftPackPoint = self:AddComponent(UIGiftPackagePoint, giftPack_point_path)
  self.helpTipContent = self:AddComponent(DetectEventHelpTipContent, helpTipContent_path)
  self.helpTipContent:SetClose()
  self.white_bg = self:TryAddComponent(UIImage, white_bg_path)
  if self.white_bg then
    self.white_bg:SetActive(true)
  end
  local meta = CS.SceneSkinManager.Instance:GetCurSkinMeta()
  if meta and meta.radar_bg then
    local wold_map_img = self:AddComponent(UIRawImage, wold_map_path)
    wold_map_img:LoadSpriteAsyncWithCallback(meta.radar_bg, function()
      if self.white_bg then
        self.white_bg:SetActive(false)
      end
    end)
    self.world_map_img = wold_map_img
  end
  self.zombie_rush_content = self:AddComponent(LWUIZombieRushContent, zombie_rush_content_path)
  self.zombie_rush_content:SetActive(false)
  self.popBtn = self:AddComponent(UIButton, pop_btn_path)
  self.popBtn:SetOnClick(function()
    self:OnPopBtnClick()
  end)
  self.reward_enter = self:AddComponent(UIImage, reward_enter_path)
  self.reward_enter:SetActive(false)
  if self.attackArrow then
    self.attackArrow:SetActive(false)
  end
  self.self_main_city_image = self:AddComponent(UIImage, self_main_city_image_path)
  self.eff_ui_radar_saomiao = self:AddComponent(UIBaseContainer, eff_ui_radar_saomiao_path)
  self.eff_ui_radar_saomiao:SetActive(false)
  self.b_g_content = self:AddComponent(UIBaseContainer, b_g_content_path)
  self.p_ui_march_line_root = self:AddComponent(UIBaseContainer, p_ui_march_line_root_path)
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
  self.isPlayingOpenTween = false
  self.openAniWaitWorldPoint = false
  self.plotDetectUuid = -1
  self.plotDetectPlotId = -1
  self.curDetectLv = -1
  self.needOpenDetectLvUpView = false
  self.receiveDetectEventRewardIntervalTime = LuaEntry.DataConfig:TryGetNum("detect_reward_value", "k1")
  self.lastReceiveDetectEventRewardTime = 0
  self.frozen_bg = nil
  self.isFirst = false
  self.showBuildingHelper = nil
  self.vipRadarEntrance = nil
  self.UIMarchLines = {}
  self.white_bg = nil
end

local function OnDestroy(self)
  self:ComponentDestroy()
  self:DataDestroy()
  self:StopSound()
  base.OnDestroy(self)
end

local function ComponentDestroy(self)
  self:ResetAniControlData()
  self:HideDetectEventItemInfoImmediately()
  self:HideDetectLevelInfoView()
  self:HideNormalInfo()
  self.vipRadarEntrance = nil
  self.detectEventItemInfo = nil
  self.detectEventItems = nil
  self.desc_icon = nil
  self.radar_level = nil
  self.radar_level_text = nil
  self.level_up_reward_btn = nil
  self.radar_level_slider_text = nil
  self.radar_level_info_btn = nil
  self.animator = nil
  self.close_btn = nil
  self.back_home_btn = nil
  self.btn_complete_one_click = nil
  self.event_items = nil
  self.eventPosCal = nil
  self.radar_image = nil
  self.bg_image = nil
  self.event_reward_effect = nil
  self.plotDetectUuid = nil
  self.plotDetectPlotId = nil
  self.giftPack = nil
  self.giftPackNameText = nil
  self.giftPackDescText = nil
  self.giftPackBuyBtn = nil
  self.giftPackPoint = nil
  self.helpTipContent = nil
  self.curDetectLv = nil
  self.needOpenDetectLvUpView = nil
  self.zombie_rush_content = nil
  self.desc_btn = nil
  self.desc_text = nil
  self.reward_enter = nil
  self.radarEventContent = nil
  self.self_main_city_image = nil
  self.eff_ui_radar_saomiao = nil
  self.b_g_content = nil
  self.world_map_img = nil
  self.p_ui_march_line_root = nil
  self:ClearUIMarchLine()
  self:StopWaitTimer()
end

local function OnEnable(self)
  base.OnEnable(self)
  self:RefreshVipRadarEntrance()
  if DataCenter.ActMeteoriteBattleManager:IsInMeteoriteBattle() and DataCenter.ActMeteoriteBattleManager:IsInArea() then
    UIUtil.ShowMessage(Localization:GetString("yuntieBattle_tips_1007"))
  elseif LuaEntry.Player:IsInBlackRange() then
    UIUtil.ShowMessage(Localization:GetString(457081))
  end
  self:UpdateGiftPackage()
  self:CheckCachedRewards()
  self:ShowSelfMainCitySkin()
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function DataDestroy(self)
  self.uuid = nil
  self.waitItemInfoToPointerUuid = nil
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
  self:StopOpenTween()
  self.isPlayingOpenTween = nil
  self.openAniWaitWorldPoint = nil
  self.receiveDetectEventRewardIntervalTime = nil
  self.lastReceiveDetectEventRewardTime = nil
  self.fakeZombieBusTrainEvent = nil
  self.nextTimeToForceRefreshZombieBus = nil
  self.zombieBusTrainEvent = nil
  self.fakeZombieBusTrainItem = nil
  if self.fakeZombieBusTrainItemRequest then
    self.fakeZombieBusTrainItemRequest:Destroy()
  end
  self.fakeZombieBusTrainItemRequest = nil
  self.usePointer = false
  self.radarTag = nil
  if self.attackCityRadar then
    self.attackCityRadar:Destroy()
  end
  self.attackCityRadar = nil
  self.vipRadarEntrance = nil
  DataCenter.RadarFakeUIMarchManager:RemoveClaimingTask(-1)
  DataCenter.RadarFakeUIMarchManager:RemoveMarchedTask(-1)
end

local function RefreshView(self)
  if self.isGettingData then
    return
  end
  self.needRefresh = false
  self.dataList = self.ctrl:GetRadarCenterPositionList()
  self:RefreshDetectEventItems()
  self:CheckToRefreshZombieBusTrain()
  self:CheckAttackCityS0RadarAct()
  self:RefreshLevelInfo()
  self:RefreshPowerInfo()
  self:UpdateGiftPackage()
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
  local maxNum = self.ctrl:GetEventStoreMax()
  local currentNum = DataCenter.RadarCenterDataManager:GetMaxDetectNum()
  self.normalEvent:SetData(currentNum, maxNum)
  self:Update()
  self.btn_complete_one_click:ReInit()
  self.unlockDetectEventRewardCacheModel = DataCenter.RadarCenterDataManager:UnlockDetectEventRewardCacheModel()
  local oldLv = self.curDetectLv
  self.curDetectLv = DataCenter.RadarCenterDataManager:GetDetectInfoLevel()
  if 0 < oldLv and oldLv < self.curDetectLv then
    self.needOpenDetectLvUpView = true
    if self.unlockDetectEventRewardCacheModel then
      self:TryShowDetectEventRewardList()
    end
  end
end

local function SetDetectEventLvInfoShowState(self, showFlag)
  self.showDetectEventLvInfo = showFlag
  if self.showDetectEventLvInfo then
    self:ShowDetectLevelInfoView()
  else
    self:HideDetectLevelInfoView()
  end
end

local function SetSelfMapPosAtOpenAndPlayTweenEvent(self)
end

local function RefreshDetectEventItems(self)
  if self.isPlayingOpenTween then
    return
  end
  local newItem = {}
  table.walk(self.dataList, function(k, v)
    if self.itemInfoCells[v.uuid] == nil then
      newItem[v.uuid] = 1
    end
  end)
  table.walk(self.itemInfoCells, function(k, v)
    table.insert(self.freeItemInfoCells, v)
  end)
  self.itemInfoCells = {}
  self.ctrl:ResetAllPosition()
  table.walk(self.dataList, function(k, v)
    self:AddOneDetectEventItem(v, newItem[v.uuid])
  end)
  newItem = nil
  table.walk(self.freeItemInfoCells, function(k, v)
    v:SetActive(false)
  end)
  EventManager:GetInstance():Broadcast(EventId.GF_detect_event_items_refresh_complete)
end

function UIDetectEventView:CheckToRefreshZombieBusTrain()
  self.fakeZombieBusTrainEvent = DataCenter.RadarCenterDataManager:GetFakeZombieBusTrainEvent()
  self.nextTimeToForceRefreshZombieBus = DataCenter.RadarCenterDataManager:GetNextTimeToForceRefreshZombieBusTrain()
  local order = 0
  self.zombieBusTrainEvent, order = DataCenter.RadarCenterDataManager:GetZombieBusTrainEvent()
  if self.zombieBusTrainEvent and self.zombieBusTrainEvent.state == DetectEventState.DETECT_EVENT_STATE_NOT_IN_WORLD and order == 1 then
    local hasShow = Setting:GetPrivateBool(ZOMBIE_BUS_TRAIN_SETTING_KEY, false)
    if not hasShow then
    end
  end
  if self.fakeZombieBusTrainEvent then
    if self.fakeZombieBusTrainItem == nil then
      if not self.fakeZombieBusTrainItemRequest then
        self.fakeZombieBusTrainItemRequest = self:GameObjectInstantiateAsync(UIAssets.FakeZombieBusTrainDetectEventItem, function(request)
          if request.isError then
            return
          end
          local go = request.gameObject
          go:SetActive(true)
          go.transform:SetParent(self.cd_EventTips.transform)
          go.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
          local nameStr = "FakeZombieBusTrain"
          go.name = nameStr
          self.fakeZombieBusTrainItem = self.cd_EventTips:AddComponent(FakeZombieBusTrainDetectEventItem, nameStr)
          self.fakeZombieBusTrainItem:SetAnchoredPosition(Vector2(0, 0))
          self.fakeZombieBusTrainItem:Refresh()
        end)
      end
    else
      self.fakeZombieBusTrainItem:SetActive(true)
      self.fakeZombieBusTrainItem:Refresh()
    end
  elseif self.fakeZombieBusTrainItem then
    self.fakeZombieBusTrainItem:SetActive(false)
  end
end

local function RefreshLevelInfo(self)
  local level = DataCenter.RadarCenterDataManager:GetDetectInfoLevel()
  local maxLv = self.view.ctrl:GetDetectEventMaxLevel()
  self.radar_level_text:SetLocalText(GameDialogDefine.DETECT_POWER, level)
  self.level_progress:SetActive(true)
  local max = self.ctrl:GetDetectEventLevelUpNum(level)
  local current = DataCenter.RadarCenterDataManager:GetDetectInfoCompleteNum()
  local text = string.GetFormattedSeperatorNum(current)
  self.radar_level_slider_text:SetText(text)
  local fillSize = self.level_progress:GetSizeDelta()
  local progressNum = current / max
  if 1 < progressNum then
    progressNum = 1
  end
  self.radar_level_fill_amount:SetSizeDelta(Vector2(progressNum * fillSize.x, fillSize.y))
  self.currentFillPercent = current / max
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
      self.itemInfoCells[param.uuid]:SetAnchoredPosition(self.ctrl:GetDetectEventPosition(param.uuid))
      self:CheckToFocusDetectEvent(param.uuid)
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
      self.itemInfoCells[param.uuid]:SetAnchoredPosition(self.ctrl:GetDetectEventPosition(param.uuid))
      self:CheckToFocusDetectEvent(param.uuid)
      EventManager:GetInstance():Broadcast(EventId.GF_detect_event_refreshed, tonumber(param.eventId))
    end)
  end
  local data = DataCenter.RadarCenterDataManager:GetDetectEventInfo(param.uuid)
  if data and data.template and data.template.type == DetectEventType.ZOMBIE_BUS_TRAIN and (data.state == DetectEventState.DETECT_EVENT_STATE_NOT_FINISH or data.state == DetectEventState.DETECT_EVENT_STATE_NOT_IN_WORLD) then
    local startPosition = self.ctrl:GetDetectEventPosition(param.uuid)
    local scale = CommonUtil.ArabicAutoMirrorFactor()
    local selfPositionV2 = self.move_ani:GetAnchoredPosition()
    selfPositionV2.x = selfPositionV2.x * scale
    local startPositionV2 = Vector2.New(startPosition.x * scale, startPosition.y)
    self:ShowAttackArrowEffect(startPositionV2, selfPositionV2)
  end
end

function UIDetectEventView:GetSelfPos()
  if self.move_ani then
    return self.move_ani:GetAnchoredPosition()
  end
  return Vector2.zero
end

function UIDetectEventView:CheckToFocusDetectEvent(uuid)
  if not self.itemInfoCells[uuid] then
    return
  end
  if self.uuid ~= nil and self.uuid == uuid then
    if self.usePointer then
      self:PointerPos(self.itemInfoCells[uuid]:GetPointerPosition())
    else
      self:SetCurrentSelectItemId(uuid)
    end
    self.itemInfoCells[uuid].transform:SetAsLastSibling()
  else
    self.itemInfoCells[uuid].transform:SetAsFirstSibling()
  end
end

function UIDetectEventView:GetRadarIdPos(radarId)
  if not self.dataList then
    return nil
  end
  local id = tonumber(radarId) or 0
  local uuid = 0
  for _, v in pairs(self.dataList) do
    if v and tonumber(v.eventId) == id then
      uuid = v.uuid
      break
    end
  end
  if uuid and tonumber(uuid) > 0 then
    local cell = self.itemInfoCells[uuid]
    if cell and cell.GetPosition then
      return cell:GetPosition()
    end
  end
  return nil
end

local function FindDetectEventItemRTByEventId(self, eventId)
  for _, item in pairs(self.itemInfoCells) do
    if item.param.eventId == tostring(eventId) then
      return item.transform:Find("Item_All/Detect_Event_Quality_Img").gameObject:GetComponent(typeof(CS.UnityEngine.RectTransform))
    end
  end
  return nil
end

function UIDetectEventView:CheckDetectEvenType(type)
  for _, item in pairs(self.itemInfoCells) do
    if item.param.type == tonumber(type) then
      return item.transform:Find("Item_All/Detect_Event_Quality_Img").gameObject:GetComponent(typeof(CS.UnityEngine.RectTransform))
    end
  end
  return nil
end

function UIDetectEventView:FindDetectEventItemRTByEventIdForCityAttack(type)
  local obj = self:CheckDetectEvenType(type)
  if obj then
    self:ShowFingerArrowFun(obj)
  else
    obj = self:CheckDetectEvenType(DetectEventType.AttackCityS0_City_Monster)
    if obj then
      self:ShowFingerArrowFun(obj)
    end
  end
  if obj == nil then
  end
end

function UIDetectEventView:ShowFingerArrowFun(obj)
  local param = {}
  param.positionType = PositionType.Screen
  local targetRoot = obj
  param.position = targetRoot.transform.position + Vector3.New(50, 0, 0)
  param.isAutoClose = 2
  DataCenter.ArrowManager:ShowFingerArrow(param)
end

local function OnSetMainWorldPointId(self)
  if self.openAniWaitWorldPoint then
    self.openAniWaitWorldPoint = false
    self:PlayOpenTween()
  end
end

local function SetSelfMapPosAtOpenAndPlayTween(self)
  local isFirstOpen = DataCenter.RadarCenterDataManager:IsDetectEventUIFirstOpen()
  local currentLv = DataCenter.RadarCenterDataManager:GetDetectInfoLevel()
  local key1 = "detect_config"
  if LuaEntry.Player:IsMonopolyDetectB() then
    key1 = "detect_config_new"
  end
  local limitLv = LuaEntry.DataConfig:TryGetNum(key1, "k17")
  if isFirstOpen then
    self.isFirst = isFirstOpen
    DataCenter.RadarCenterDataManager:RecordDetectEventUIFirstOpen()
  end
  if isFirstOpen and currentLv < limitLv then
    local mainWorldPos = LuaEntry.Player:GetMainWorldPos()
    if 0 < mainWorldPos then
      self:PlayOpenTween()
    else
      self.openAniWaitWorldPoint = true
      self.self_pos_do_scale:SetLocalScaleXYZ(1, 1, 1)
      self.self_pos:SetAnchoredPositionXY(0, 0)
      self.wold_map:SetAnchoredPositionXY(0, 0)
      self.self_pos_effect:SetAnchoredPositionXY(0, 0)
      self.self_pos_effect_mask:SetAnchoredPositionXY(0, 0)
      self.self_pos_effect_mask:SetActive(false)
      self.radar_contain:SetActive(false)
      self:RefreshZombieRushContent()
    end
  else
    self:StopOpenTween()
    local selfPos = self.ctrl:GetSelfWorldMapImgPosition()
    self.self_pos_effect:SetAnchoredPositionXY(0, 0)
    self.self_pos_effect_mask:SetActive(false)
    self.self_pos:SetAnchoredPositionXY(0, 0)
    self.radar_image.gameObject:SetActive(true)
    self.radar_contain:SetActive(true)
    self:RePlayRadarSaomiaoAni()
    self:RefreshDetectEventItems()
    self:PlayHideAniFin()
    self.helpTipContent:SetOpen()
    self:RefreshZombieRushContent()
  end
end

local function StopOpenTween(self)
  if self.openTween then
    self.openTween:Kill()
    self.openTween = nil
    self.isPlayingOpenTween = false
  end
end

local function PlayOpenTween(self)
  StopOpenTween(self)
  DataCenter.LWSoundManager:PlaySound(SoundAssetId.RadarUI, false)
  self.isPlayingOpenTween = true
  local openTweenTime = 1.1
  local tweenWaitTime = 0.4
  local effectMoveTime = 0.8
  local tweenTime = 1
  local endScale = self.ctrl:GetSelfWorldMapImgScale()
  local selfPos = self.ctrl:GetSelfWorldMapImgPosition()
  self.self_pos_do_scale:SetLocalScaleXYZ(1, 1, 1)
  self.self_pos_effect:SetAnchoredPositionXY(0, 0)
  self.self_pos_effect_mask:SetAnchoredPositionXY(-selfPos.x, -selfPos.y)
  self.radar_image.gameObject:SetActive(false)
  self.openTween = DOTween.Sequence()
  self.openTween:AppendCallback(function()
    self.animator:Play("Eff_anim_daditu_show", 0, 0)
    self.eff_ui_radar_saomiao:SetActive(true)
  end)
  self.openTween:AppendInterval(openTweenTime)
  self.openTween:AppendCallback(function()
    local selfPos = self.ctrl:GetSelfWorldMapImgPosition()
    self.self_pos_do_scale:SetLocalScaleXYZ(1, 1, 1)
    self.self_pos_effect:SetAnchoredPositionXY(0, 0)
    self.self_pos_effect_mask:SetAnchoredPositionXY(-selfPos.x, -selfPos.y)
    self.radar_contain:SetActive(true)
    self.self_pos_effect_mask:SetActive(true)
  end)
  self.openTween:AppendInterval(tweenWaitTime)
  self.openTween:Append(self.self_pos_effect.transform:DOMove(self.self_pos.transform.position, effectMoveTime):SetEase(CS.DG.Tweening.Ease.OutCubic))
  self.openTween:AppendCallback(function()
    self.self_pos_effect_mask:SetActive(false)
  end)
  self.openTween:OnComplete(function()
    self:StopOpenTween()
    self.radar_image.gameObject:SetActive(true)
    self:RePlayRadarSaomiaoAni()
    self:RefreshDetectEventItems()
    self.helpTipContent:SetOpen()
    self.eff_ui_radar_saomiao:SetActive(false)
    self:RefreshZombieRushContent()
  end)
  self.self_pos_do_scale:SetLocalScaleXYZ(1, 1, 1)
  self.self_pos:SetAnchoredPositionXY(0, 0)
  self.wold_map:SetAnchoredPositionXY(0, 0)
  self.self_pos_effect:SetAnchoredPositionXY(0, 0)
  self.self_pos_effect_mask:SetAnchoredPositionXY(0, 0)
  self.self_pos_effect_mask:SetActive(false)
  self.radar_contain:SetActive(false)
end

local function RePlayRadarSaomiaoAni(self)
  self.panelOpenTime = UITimeManager:GetInstance():GetServerTime()
  self:CheckAndPlayScanEffect()
end

local function OnAddListener(self)
  base.OnAddListener(self)
  self:AddUIListener(EventId.GetAllDetectInfo, self.DoWhenListDataBack)
  self:AddUIListener(EventId.UpgradeDetectPower, self.DoWhenDataChange)
  self:AddUIListener(EventId.DetectInfoChange, self.DoWhenDataChange)
  self:AddUIListener(EventId.DetectEventRewardGet, self.ShowRewardGetAnimation)
  self:AddUIListener(EventId.SetMainWorldPointId, self.OnSetMainWorldPointId)
  self:AddUIListener(EventId.GF_plot_group_done, self.OnPlotDone)
  self:AddUIListener(EventId.UpdateGiftPackData, self.UpdateGiftPackage)
  self:AddUIListener(EventId.DetectInfoChangeClaimLevelReward, self.OnClaimLevelReward)
  self:AddUIListener(EventId.OnRewardGetPanelClose, self.OnGetRewardGetPanelCloseMsg)
  self:AddUIListener(EventId.LWDetectEventRewardReceive, self.FlyReward)
  self:AddUIListener(EventId.UIDetectCaveRewardsGetViewClose, self.CheckCachedRewards)
  self:AddUIListener(EventId.PlayRadarGuide, self.SetSelfMapPosAtOpenAndPlayTweenEvent)
  self:AddUIListener(EventId.GMPanelPlayDetectEventAni, self.GMPanelPlayAni)
  self:AddUIListener(EventId.AttackCityS0RadarEvent, self.FindDetectEventItemRTByEventIdForCityAttack)
  self:AddUIListener(EventId.SurvivalVipGiftInfoUpdate, self.RefreshVipRadarEntrance)
end

local function OnRemoveListener(self)
  self:RemoveUIListener(EventId.DetectEventRewardGet, self.ShowRewardGetAnimation)
  self:RemoveUIListener(EventId.GetAllDetectInfo, self.DoWhenListDataBack)
  self:RemoveUIListener(EventId.UpgradeDetectPower, self.DoWhenDataChange)
  self:RemoveUIListener(EventId.DetectInfoChange, self.DoWhenDataChange)
  self:RemoveUIListener(EventId.SetMainWorldPointId, self.OnSetMainWorldPointId)
  self:RemoveUIListener(EventId.GF_plot_group_done, self.OnPlotDone)
  self:RemoveUIListener(EventId.UpdateGiftPackData, self.UpdateGiftPackage)
  self:RemoveUIListener(EventId.DetectInfoChangeClaimLevelReward, self.OnClaimLevelReward)
  self:RemoveUIListener(EventId.OnRewardGetPanelClose, self.OnGetRewardGetPanelCloseMsg)
  self:RemoveUIListener(EventId.LWDetectEventRewardReceive, self.FlyReward)
  self:RemoveUIListener(EventId.UIDetectCaveRewardsGetViewClose, self.CheckCachedRewards)
  self:RemoveUIListener(EventId.PlayRadarGuide, self.SetSelfMapPosAtOpenAndPlayTweenEvent)
  self:RemoveUIListener(EventId.GMPanelPlayDetectEventAni, self.GMPanelPlayAni)
  self:RemoveUIListener(EventId.AttackCityS0RadarEvent, self.FindDetectEventItemRTByEventIdForCityAttack)
  self:RemoveUIListener(EventId.SurvivalVipGiftInfoUpdate, self.RefreshVipRadarEntrance)
  base.OnRemoveListener(self)
end

local function RefreshFormationStamina(self)
  self.formationStaminaSlider:UpdateStamina()
end

local function Update(self)
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

local function Update100MS(self)
  if self.lastReceiveDetectEventRewardTime and self.lastReceiveDetectEventRewardTime > 0 then
    local curTime = UITimeManager:GetInstance():GetServerTime()
    if curTime - self.lastReceiveDetectEventRewardTime > self.receiveDetectEventRewardIntervalTime then
      self.lastReceiveDetectEventRewardTime = 0
      self:TryShowDetectEventRewardList()
    end
  end
  if self.nextTimeToForceRefreshZombieBus and 0 < self.nextTimeToForceRefreshZombieBus then
    local curTime = UITimeManager:GetInstance():GetServerTime()
    if curTime > self.nextTimeToForceRefreshZombieBus then
      self.nextTimeToForceRefreshZombieBus = nil
      self:GetDataFromServer()
    end
  end
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
  local oldEventId = self.currentSelectEventId
  self.currentSelectEventId = detectEventId
  table.walk(self.itemInfoCells, function(k, v)
    v:setSelectUuid(detectEventId)
  end)
  if self.fakeZombieBusTrainItem then
    self.fakeZombieBusTrainItem:setSelectUuid(detectEventId)
  end
  if oldEventId then
    for k, v in pairs(self.itemInfoCells) do
      if v.param and v.param.uuid == oldEventId then
        v.transform:SetAsFirstSibling()
        break
      end
    end
    if self.fakeZombieBusTrainItem and self.fakeZombieBusTrainItem:GetFakeZombieBusTrainDetectEventUUID() == oldEventId then
      self.fakeZombieBusTrainItem.transform:SetAsFirstSibling()
    end
  end
  if self.currentSelectEventId == nil or self.fakeZombieBusTrainItem and self.fakeZombieBusTrainItem:GetFakeZombieBusTrainDetectEventUUID() == self.currentSelectEventId then
    self:HideDetectEventItemInfo()
  else
    self:ShowDetectEventItemInfo()
  end
end

local function ShowDetectEventItemInfo(self)
  if self.detectEventItemInfo == nil then
    self.detectEventItemInfo = self:AddComponent(DetectEventItemInfoView, detect_event_info_path)
  end
  self:StopWaitTimer()
  local data = DataCenter.RadarCenterDataManager:GetDetectEventInfo(self.currentSelectEventId)
  if data then
    self.frozen_bg:SetActive(data.isFrozen)
    self.detectEventItemInfo:SetCurrentSelectUuid(self.currentSelectEventId)
    self.detectEventItemInfo:SetActive(true)
    if not LuaEntry.DataConfig:CheckSwitch("radar_click_area") and self.itemInfoCells[self.currentSelectEventId] ~= nil then
      if self.itemInfoCells[self.currentSelectEventId].transform.localPosition.y < 0 then
        if 0 >= self.event_items.transform.localPosition.y then
          self.animator:Play("ShowDetectEventInfo")
        end
      elseif 0 < self.event_items.transform.localPosition.y then
        self.animator:Play("HideDetectEventInfo")
      end
    end
    self:SetDetectEventLvInfoShowState(false)
  end
end

local function HideDetectEventItemInfo(self)
  self.frozen_bg:SetActive(false)
  local isPlayHideAni = false
  self:StopWaitTimer()
  if self.event_items.transform.localPosition.y > 0 then
    self.animator:Play("HideDetectEventInfo")
    isPlayHideAni = true
    self.waitTimer = TimerManager:GetInstance():DelayInvoke(function()
      self:HideDetectEventItemInfoImmediately()
    end, 0.2)
  end
  if not isPlayHideAni then
    self:HideDetectEventItemInfoImmediately()
  end
end

local function HideDetectEventItemInfoImmediately(self)
  if self.detectEventItemInfo ~= nil then
    self.detectEventItemInfo:SetActive(false)
    self.detectEventItemInfo:RemoveCountdownSizeTween()
  end
end

local function ResetAniControlData(self)
  self.animator.enabled = false
  self.event_items:SetLocalPositionXYZ(0, 0, 0)
  self.b_g_content:SetAnchoredPositionXY(0, 0)
  self.b_g_content:SetLocalScaleXYZ(1, 1, 1)
  self.move_ani:SetAnchoredPositionXY(0, 0)
  if self.world_map_img then
    self.world_map_img:SetColorRGBA(1, 1, 1, 1)
  end
end

local function StopWaitTimer(self)
  if self.waitTimer ~= nil then
    self.waitTimer:Stop()
    self.waitTimer = nil
  end
end

local function ShowDetectLevelInfoView(self)
  if self.DetectEventLevelUpgradeInfoNewView == nil then
    self.DetectEventLevelUpgradeInfoNewView = self:AddComponent(DetectEventLevelUpgradeInfoNewView, detect_level_info_path)
  end
  self.DetectEventLevelUpgradeInfoNewView:SetActive(true)
  self.DetectEventLevelUpgradeInfoNewView:ReInit()
  self:SetCurrentSelectItemId(nil)
  self:HideBuffDetail()
end

local function HideDetectLevelInfoView(self)
  if self.DetectEventLevelUpgradeInfoNewView ~= nil then
    self.DetectEventLevelUpgradeInfoNewView:SetActive(false)
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

local oldRound = -1

local function CheckAndPlayScanEffect(self)
  local totalTime = math.fmod(UITimeManager:GetInstance():GetServerTime() - self.panelOpenTime, one_round_time)
  local roundNum = math.floor((UITimeManager:GetInstance():GetServerTime() - self.panelOpenTime) / one_round_time)
  if roundNum ~= oldRound then
    oldRound = roundNum
    self.soundRadarScan = DataCenter.LWSoundManager:PlaySound(SoundAssetId.RadarScan, false)
  end
  if totalTime > one_round_show_time then
    self.scan_effect:SetActive(false)
  else
    if not self.scan_effect.activeSelf then
      CS.DynamicFPSConfig.AcquireHighFPSLockerForSeconds(one_round_show_time / 1000)
    end
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
    param.lvPosX = lvProgressTransform.position.x + rect.width * self.currentFillPercent
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
      local rectTransform = go:GetComponent(typeof(CS.UnityEngine.RectTransform))
      rectTransform:Set_offsetMin(0, 0)
      rectTransform:Set_offsetMax(0, 0)
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

local function GetGuideBubbleByEventId(self, eventId)
  local infoList = DataCenter.RadarCenterDataManager:GetDetectEventsInfoByEventId(eventId)
  if infoList ~= nil and infoList[1] ~= nil then
    local info = infoList[1]
    if info ~= nil and self.itemInfoCells[info.uuid] ~= nil then
      return self.itemInfoCells[info.uuid]:GetGuideObject()
    end
  end
end

function UIDetectEventView:GetEventPointByUuid(uuid)
  if self.itemInfoCells[uuid] ~= nil then
    return self.itemInfoCells[uuid]
  end
  return nil
end

local function ShowSpecialOpsInfo(self)
end

local function HideSpecialOpsInfo(self)
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
  else
    self:HideNormalInfo()
  end
end

local function HideNormalInfo(self)
  if self.normalInfo ~= nil then
    self.normalInfo:SetActive(false)
  end
end

local function CheckShowNormalInfo(self)
  self:ShowNormalInfo()
end

local function GetEventIcon(self, evtType, evtParam)
  local result
  local event = DataCenter.RadarCenterDataManager:GetOneInfoByEventTypeAndPara(evtType, evtParam)
  if event ~= nil then
    local itemCell = self.itemInfoCells[event.uuid]
    if itemCell ~= nil then
      result = itemCell.event_trigger.rectTransform
    end
  end
  return result
end

local function PlayHideAniFin(self)
  if self.event_items.transform.localPosition.y > 0 then
    self.animator:Play("HideDetectEventInfo", 0, 1)
  end
end

function UIDetectEventView:ShowAttackArrowEffect(startPositionV2, targetPositionV2)
  local deltaDirection = targetPositionV2 - startPositionV2
  local zeroDirection = Vector2.New(1, 0)
  local angle = Vector2.Angle(zeroDirection, deltaDirection)
  angle = angle * (0 <= deltaDirection.y and 1 or -1)
  if self.attackArrow then
    self.attackArrow:SetActive(true)
    self.attackArrow.rectTransform:Set_anchoredPosition(startPositionV2.x, startPositionV2.y)
    self.attackArrow.transform:Set_localEulerAngles(0, 0, angle)
    local sizeX = Vector2.Magnitude(deltaDirection)
    self.attackArrow:SetSizeDeltaXY(sizeX, 30)
  end
end

local function StartDetectPlot(self, uuid, plotId)
  if 0 < plotId then
    self.plotDetectUuid = uuid
    self.plotDetectPlotId = plotId
    SFSNetwork.SendMessage(MsgDefines.StartDetectEventTalk, self.plotDetectUuid)
    EventManager:GetInstance():Broadcast(EventId.PlayPlotGroup, {plotGroupId = plotId, hideMainUI = false})
  end
end

local function OnPlotDone(self, plotId)
  if plotId == self.plotDetectPlotId then
    local data = DataCenter.RadarCenterDataManager:GetDetectEventInfo(self.plotDetectUuid)
    if data ~= nil then
      SFSNetwork.SendMessage(MsgDefines.EndDetectEventTalk, self.plotDetectUuid)
      self.plotDetectUuid = -1
      self.plotDetectPlotId = -1
    end
  end
end

local function UpdateGiftPackage(self)
  local currentNum = DataCenter.RadarCenterDataManager:GetCurEventNum()
  if 3 < currentNum then
    self.giftPack:SetActive(false)
    self.pack = nil
  else
    local radarPackId = LuaEntry.DataConfig:TryGetStr("redar_refresh_pack", "k1", "")
    local pack = GiftPackageData.get(radarPackId)
    if pack ~= nil and pack:canGet() then
      self.giftPack:SetActive(true)
      self.giftPackNameText:SetLocalText(pack:getName())
      self.giftPackDescText:SetLocalText(pack:getDescription())
      self.giftPackBuyBtn:Init(pack)
      self.giftPackBuyBtn:RefreshPoint()
    else
      self.giftPack:SetActive(false)
    end
    self.pack = pack
  end
  self:RefreshVipRadarEntrance()
end

local function OnGiftPackBuyBtn(self)
  if self.pack then
    DataCenter.PayManager:CallPayment(self.pack, "GoldExchangeView")
  end
end

local function OnClaimLevelReward(self, msg)
  local events = msg.events
  if events == nil or #events == 0 then
    return
  end
  self.ctrl:ResetAllPosition()
  local randomTime = 100
  local moveTime = 1
  for i = 1, #events do
    local uuid = events[i].uuid
    local param = self.ctrl:GetOneEventData(uuid)
    local delayTime = 1.0 * math.random(0, randomTime) / 150.0
    TimerManager:GetInstance():DelayInvoke(function()
      if self.ctrl == nil then
        return
      end
      local effectPath = "Assets/_Art/Effect/prefab/ui/VFX_leida_trail.prefab"
      local startPos = self.level_up_reward_btn.transform.position
      self.eventPosCal.transform.localPosition = self.ctrl:GetDetectEventPosition(uuid)
      local endPos = self.eventPosCal.transform.position
      UIUtil.DoFlySimpleFunc(effectPath, startPos, endPos, moveTime, nil, function()
        if self.ctrl == nil then
          return
        end
        table.insert(self.dataList, param)
        self:AddOneDetectEventItem(param, 1)
      end)
    end, delayTime)
  end
  local maxTime = 1.0 * randomTime / 150.0 + moveTime + 0.2
  TimerManager:GetInstance():DelayInvoke(function()
    self.needRefresh = true
  end, maxTime)
end

local function OnGetRewardGetPanelCloseMsg(self)
  if self.needOpenDetectLvUpView == true then
    self.needOpenDetectLvUpView = false
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIDetectEventLevelUp, {anim = true}, self.curDetectLv - 1, self.curDetectLv)
  end
end

local function RefreshZombieRushContent(self)
  self.zombie_rush_content:RefreshView(self.radar_contain.transform.position)
end

function UIDetectEventView:OnDescBtnClick()
  UIManager:GetInstance():OpenWindow(UIWindowNames.UILWWorldTip, {anim = false}, 1)
end

function UIDetectEventView:OnPopBtnClick()
  UIManager:GetInstance():OpenWindow(UIWindowNames.LWUIBuildingHelperView, 10114000)
end

local function SetLastReceiveDetectEventRewardTime(self)
  if self.unlockDetectEventRewardCacheModel then
    self.lastReceiveDetectEventRewardTime = UITimeManager:GetInstance():GetServerTime()
  end
end

local function TryShowDetectEventRewardList(self)
  self.lastReceiveDetectEventRewardTime = 0
  if self.reward_enter.activeSelf then
    self.reward_enter:SetActive(false)
  end
  local rewardList = DataCenter.RadarCenterDataManager:GetCacheDetectEventRewardList()
  if 0 < table.count(rewardList) then
    DataCenter.RewardManager:ShowDetectEventCombineReward(rewardList)
    DataCenter.RadarCenterDataManager:ClearCacheDetectEventRewardList()
  end
end

local function FlyReward(self, paramData)
  if not self.reward_enter.activeSelf then
    self.reward_enter:SetActive(true)
  end
  local startPos = Vector3.zero
  if self.itemInfoCells and self.itemInfoCells[paramData.eventUuid] then
    startPos = self.itemInfoCells[paramData.eventUuid].transform.position
  elseif self.radar_contain then
    startPos = self.radar_contain.transform.position
  end
  local list = DataCenter.RewardManager:ReturnRewardParamForMessage(paramData.reward) or {}
  for i, reward in pairs(list) do
    if reward.rewardType == RewardType.GOODS then
      local template = DataCenter.ItemTemplateManager:GetItemTemplate(tonumber(reward.itemId))
      if template ~= nil and template.type == GOODS_TYPE.GOODS_TYPE_144 then
        goto lbl_78
      end
    end
    local pic = RewardUtil.GetPic(reward.rewardType, reward.itemId)
    UIUtil.DoFly(reward.rewardType, 3, pic, startPos, self.reward_enter.transform.position, nil, nil, function()
      if not self.unlockDetectEventRewardCacheModel and self.reward_enter and self.reward_enter.activeSelf then
        self.reward_enter:SetActive(false)
      end
    end)
    ::lbl_78::
  end
end

function UIDetectEventView:CheckCachedRewards()
  local reward = DataCenter.CaveExplorationManager:DequeueTempCacheRewards()
  if reward then
    DataCenter.RewardManager:ShowTwoLinesRewards(reward.reward, reward.pathReward, "128027", reward.showTip)
  end
end

function UIDetectEventView:ShowPointerWithUuid(uuid)
  if not uuid then
    return
  end
  local eventInfo = DataCenter.RadarCenterDataManager:GetDetectEventInfo(uuid)
  if not eventInfo then
    return
  end
  local itemInfoCell = self.itemInfoCells[uuid]
  if itemInfoCell then
    self:PointerPos(itemInfoCell:GetPointerPosition())
  else
    self.waitItemInfoToPointerUuid = uuid
  end
end

function UIDetectEventView:PointerPos(pos)
  if not pos then
    return
  end
  local param = {}
  param.positionType = PositionType.Screen
  param.position = pos + Vector3.New(50, -50, 0)
  param.isAutoClose = 2
  DataCenter.ArrowManager:ShowFingerArrow(param)
end

function UIDetectEventView:HideBuffDetail()
  if self.buffActInfoComp then
    self.buffActInfoComp:HideBuffDetail()
  end
end

function UIDetectEventView:ShowSelfMainCitySkin()
  local skinId = DataCenter.DecorationDataManager:GetCurrentSkinByType(DecorationType.DecorationType_Main_City)
  if skinId ~= nil then
    local template = DataCenter.DecorationTemplateManager:GetTemplate(skinId)
    if template then
      self.self_main_city_image:LoadSpriteAsyncWithCallback(template.icon, function(texture)
        if self.self_main_city_image then
          self.self_main_city_image:SetNativeSize()
        end
      end)
    end
  end
end

function UIDetectEventView:GMPanelPlayAni()
  if table.count(self.itemInfoCells) > 0 then
    table.walk(self.itemInfoCells, function(k, v)
      v:SetActive(false)
    end)
  end
  self:PlayOpenTween()
end

function UIDetectEventView:CheckAttackCityS0RadarAct()
  local attackCityState = DataCenter.AttackCityS0DataManager:GetActivityState()
  if attackCityState == CityAttackS0ActivityState.Waiting and DataCenter.AttackCityS0DataManager:JudgeActOpen() then
    if self.radarTag then
      self.radarTag.gameObject:SetActive(true)
    elseif self.attackCityRadar == nil then
      local assetPath = "Assets/Main/Prefabs/UI/LWCityAttackS0/Rader/AttackCityS0NewRadarEvent.prefab"
      self.attackCityRadar = self:GameObjectInstantiateAsync(assetPath, function(request)
        if request.isError then
          return
        end
        local go = request.gameObject
        go.gameObject:SetActive(false)
        go.transform:SetParent(self.radarEventContent.transform)
        go.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
        go.name = "attackCityRadarTag"
        local cell = self.radarEventContent:AddComponent(AttackCityS0RadarEvent, go.name)
        cell:SetAsFirstSibling()
        self.radarTag = cell
        self.radarTag.gameObject:SetActive(true)
      end)
    end
  elseif self.radarTag then
    self.radarTag.gameObject:SetActive(false)
  end
end

function UIDetectEventView:AddFakeUIMarch(eventData)
  if eventData == nil then
    return
  end
  if DataCenter.RadarFakeUIMarchManager:IsMarched(eventData.uuid) then
    return
  end
  local startTime, endTime = DataCenter.RadarFakeUIMarchManager:StartUIMarch(eventData)
  local item = self:GetEventPointByUuid(eventData.uuid)
  if item ~= nil then
    item:Refresh()
    local now = UITimeManager:GetInstance():GetServerTime()
    if startTime <= now and endTime > now then
      local req = self:GameObjectInstantiateAsync(ui_march_line_prefab_path, function(req)
        local go = req.gameObject
        go.name = string.format("UIMarchLine_%s_%s", eventData.uuid, NameCount)
        NameCount = NameCount + 1
        local transform = go.transform
        local transRoot = self.p_ui_march_line_root.transform
        transform:SetParent(transRoot)
        transform:Set_localScale(1, 1, 1)
        transform:Set_localPosition(0, 0, 0)
        local comp = self.p_ui_march_line_root:AddComponent(RadarFakeUIMarchLineComp, go.name)
        local lineData = {}
        lineData.EventData = eventData
        lineData.StartTime = startTime
        lineData.EndTime = endTime
        comp:ReInit(lineData)
      end)
      table.insert(self.UIMarchLines, req)
    end
  end
end

function UIDetectEventView:ClearUIMarchLine()
  if not table.IsNullOrEmpty(self.UIMarchLines) then
    for _, req in pairs(self.UIMarchLines) do
      if req ~= nil then
        self:GameObjectDestroy(req)
      end
    end
  end
  self.UIMarchLines = {}
end

function UIDetectEventView:StopSound()
  if self.soundRadarScan then
    DataCenter.LWSoundManager:StopSound(self.soundRadarScan)
    self.soundRadarScan = nil
  end
  if self.soundEffectRadar then
    DataCenter.LWSoundManager:StopSound(self.soundEffectRadar)
    self.soundEffectRadar = nil
  end
  self:StopRewardSound()
end

function UIDetectEventView:PlayRewardSound()
  self:StopRewardSound()
  self.soundRewardGet = DataCenter.LWSoundManager:PlaySound(62299, false)
end

function UIDetectEventView:StopRewardSound()
  if self.soundRewardGet then
    DataCenter.LWSoundManager:StopSound(self.soundRewardGet)
    self.soundRewardGet = nil
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
UIDetectEventView.OnClaimLevelReward = OnClaimLevelReward
UIDetectEventView.SetCurrentSelectItemId = SetCurrentSelectItemId
UIDetectEventView.ShowDetectEventItemInfo = ShowDetectEventItemInfo
UIDetectEventView.HideDetectEventItemInfo = HideDetectEventItemInfo
UIDetectEventView.ShowDetectLevelInfoView = ShowDetectLevelInfoView
UIDetectEventView.HideDetectLevelInfoView = HideDetectLevelInfoView
UIDetectEventView.RefreshDetectEventItems = RefreshDetectEventItems
UIDetectEventView.AddOneDetectEventItem = AddOneDetectEventItem
UIDetectEventView.FindDetectEventItemRTByEventId = FindDetectEventItemRTByEventId
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
UIDetectEventView.SetSelfMapPosAtOpenAndPlayTween = SetSelfMapPosAtOpenAndPlayTween
UIDetectEventView.PlayOpenTween = PlayOpenTween
UIDetectEventView.OnSetMainWorldPointId = OnSetMainWorldPointId
UIDetectEventView.StopOpenTween = StopOpenTween
UIDetectEventView.RePlayRadarSaomiaoAni = RePlayRadarSaomiaoAni
UIDetectEventView.CheckShowNormalInfo = CheckShowNormalInfo
UIDetectEventView.GetEventIcon = GetEventIcon
UIDetectEventView.PlayHideAniFin = PlayHideAniFin
UIDetectEventView.StartDetectPlot = StartDetectPlot
UIDetectEventView.OnPlotDone = OnPlotDone
UIDetectEventView.UpdateGiftPackage = UpdateGiftPackage
UIDetectEventView.OnGiftPackBuyBtn = OnGiftPackBuyBtn
UIDetectEventView.OnGetRewardGetPanelCloseMsg = OnGetRewardGetPanelCloseMsg
UIDetectEventView.RefreshZombieRushContent = RefreshZombieRushContent
UIDetectEventView.Update100MS = Update100MS
UIDetectEventView.SetLastReceiveDetectEventRewardTime = SetLastReceiveDetectEventRewardTime
UIDetectEventView.TryShowDetectEventRewardList = TryShowDetectEventRewardList
UIDetectEventView.FlyReward = FlyReward
UIDetectEventView.GetGuideBubbleByEventId = GetGuideBubbleByEventId
UIDetectEventView.SetSelfMapPosAtOpenAndPlayTweenEvent = SetSelfMapPosAtOpenAndPlayTweenEvent
UIDetectEventView.StopWaitTimer = StopWaitTimer
UIDetectEventView.HideDetectEventItemInfoImmediately = HideDetectEventItemInfoImmediately
UIDetectEventView.ResetAniControlData = ResetAniControlData
return UIDetectEventView
