local DetectEventItem = BaseClass("DetectEventItem", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local this_path = ""
local quality_img_path = "Item_All/Detect_Event_Quality_Img"
local detect_event_point_path = "Detect_event_point"
local complete_img_path = "Item_All/Detect_Event_Select_Img"
local detect_Event_Img_mask_path = "Item_All/Detect_Event_Img_mask"
local uiPlayerHead_path = "Item_All/UIPlayerHead"
local titleTxt_path = "Item_All/titleTxt"
local event_img_path = "Item_All/Detect_Event_Img_mask/Detect_Event_Img"
local event_img_mask_path = "Item_All/Detect_Event_Img_mask/mask"
local event_monster_img_path = "Item_All/Detect_Event_Monster_Img"
local red_dot_path = "Item_All/Detect_Event_Red_Dot"
local common_red_point_path = "Item_All/CommonRedPoint"
local vfx_radar_scan_path = "VFX_leida_shijian"
local vfx_special_event_effect_path = "Item_All/VFX_special_event_effect"
local vfx_special_event_effect1_path = "Item_All/VFX_special_event_effect_01"
local item_all_path = "Item_All"
local uiPlayerCanvasGroup_path = "Item_All/UIPlayerHead"
local particle_show_time = 1000.0
local shiningVFX = "Assets/Main/Prefabs/UI/UILWRadarCenter/Eff_ui_DetectEventItem_fire.prefab"
local countdown_image_path = "Item_All/CountdownImage"
local v_f_x_complete_path = "Item_All/VFX_complete"
local bg_pos_1 = -20
local bg_pos_2 = 55
local bg_pos_fake_player = -3
local item_pos_fake_player = -20
local item_pos_1 = 10
local item_pos_2 = 0
local bg_pos_help = -9

local function OnCreate(self)
  base.OnCreate(self)
  self:DataDefine()
  self:ComponentDefine()
end

local function ComponentDefine(self)
  self.event_trigger = self:AddComponent(UIEventTrigger, this_path)
  self.event_trigger:OnPointerDown(function(eventData)
    self:OnPointerDown(eventData)
  end)
  self.quality_img = self:AddComponent(UIImage, quality_img_path)
  self.detect_Event_Img_mask = self:AddComponent(UIBaseContainer, detect_Event_Img_mask_path)
  self.uiPlayerHead = self:AddComponent(UICommonHead, uiPlayerHead_path)
  self.uiPlayerCanvasGroup = self:AddComponent(UICanvasGroup, uiPlayerCanvasGroup_path)
  self.titleTxt = self:AddComponent(UIText, titleTxt_path)
  self.event_img = self:AddComponent(UIImage, event_img_path)
  self.event_img_mask = self:AddComponent(UIBaseContainer, event_img_mask_path)
  self.event_monster_img = self:AddComponent(UIImage, event_monster_img_path)
  self.red_dot = self:AddComponent(UICommonRedPoint, common_red_point_path)
  self.red_dot:SetType(CommonRedPointPriority.Level1)
  self.complete_img = self:AddComponent(UIImage, complete_img_path)
  self.vfx_radar_scan = self:AddComponent(UIBaseContainer, vfx_radar_scan_path)
  self.vfx_radar_scan:SetActive(false)
  self.vfx_special_event_effect = self:AddComponent(UIBaseContainer, vfx_special_event_effect_path)
  self.vfx_special_event_effect:SetActive(false)
  self.vfx_special_event_effect1 = self:AddComponent(UIBaseContainer, vfx_special_event_effect1_path)
  self.vfx_special_event_effect1:SetActive(false)
  self.item_all = self:AddComponent(UIBaseContainer, item_all_path)
  self.detect_event_point = self:AddComponent(UIImage, detect_event_point_path)
  DOTween.Rewind(self.gameObject)
  local delayTime = 1.0 * math.random(0, 10) / 150.0
  self:DelayInvoke(function()
    self:PlayShowAnimation()
  end, delayTime)
  DOTween.Rewind(self.item_all.gameObject)
  self.countdown_image = self:AddComponent(UIImage, countdown_image_path)
  self.v_f_x_complete = self:AddComponent(UIBaseContainer, v_f_x_complete_path)
  self.v_f_x_complete:SetActive(false)
end

local function DelayInvoke(self, callback, delayTime)
  local param = {}
  param.timer = TimerManager:GetInstance():GetTimer(delayTime, function()
    if param.timer ~= nil then
      param.timer:Stop()
      param.timer = nil
    end
    param = nil
    callback()
  end, self, true, false, false)
  param.timer:Start()
end

local function PlayShowAnimation(self)
  DOTween.Play(self.gameObject)
end

local function DataDefine(self)
  self.lastPlayEffectTime = 0
  self.detectEventIsDoing = false
end

local function OnDestroy(self)
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

local function ComponentDestroy(self)
  self.event_trigger = nil
  self.quality_img = nil
  self.select_img = nil
  self.detect_Event_Img_mask = nil
  self.uiPlayerHead = nil
  self.uiPlayerCanvasGroup = nil
  self.event_img = nil
  self.event_img_mask = nil
  self.event_monster_img = nil
  self.red_dot = nil
  self.vfx_radar_scan = nil
  self.complete_img = nil
  self.vfx_special_event_effect = nil
  self.item_all = nil
  self.detect_event_point = nil
  self.titleTxt = nil
  self.countdown_image = nil
  self.v_f_x_complete = nil
end

local function DataDestroy(self)
  self.lastPlayEffectTime = nil
  self.shineVFXReq = nil
  self.shineParticle = nil
  self.detectEventIsDoing = nil
end

local function Update1000MS(self)
  self:RefreshCountdownImageShowState()
end

local function SetUuid(self, param, selectUuid)
  self.param = param
  self.selectUuid = selectUuid
  self.v_f_x_complete:SetActive(false)
  self:Refresh()
end

local function setSelectUuid(self, selectUuid)
  self.selectUuid = selectUuid
  self:Refresh()
  if self.param.uuid == self.selectUuid then
    DOTween.Restart(self.item_all.gameObject)
    self.item_all.transform:DOLocalMove(Vector3.New(0, 20, 0), 0.25)
  end
end

local function OnPointerDown(self, eventData)
  if self.param.uuid ~= nil then
    local data = DataCenter.RadarCenterDataManager:GetDetectEventInfo(self.param.uuid)
    local template = DataCenter.DetectEventTemplateManager:GetDetectEventTemplate(self.param.eventId)
    if data ~= nil and template ~= nil then
      if template.type == DetectEventType.PLOT then
        local plotId = tonumber(template.para)
        if 0 < plotId then
          self.view:StartDetectPlot(self.param.uuid, plotId)
        end
      elseif data.state == DetectEventState.DETECT_EVENT_STATE_FINISHED then
        if DataCenter.RadarCenterDataManager:ClaimDetectEventRewardByEventData(data) then
          self.view:PlayRewardSound()
          self.view:SetCurrentSelectItemId(nil)
          self.view:SetLastReceiveDetectEventRewardTime()
        end
      else
        self.view:SetCurrentSelectItemId(self.param.uuid)
      end
    end
    EventManager:GetInstance():Broadcast(EventId.GF_detect_event_item_clicked, tonumber(self.param.eventId))
  end
  DataCenter.GuideManager:HasClick(self:GetGuideObject())
end

local function SetBgImg(self, imgComponent)
  local template = DataCenter.DetectEventTemplateManager:GetDetectEventTemplate(self.param.eventId)
  if template.type == DetectEventType.FAKE_PLAYER then
    imgComponent:LoadSprite(DetectEvenFakePlayerColorImage[template.quality])
    imgComponent.transform:Set_localPosition(0, bg_pos_fake_player, 0)
  elseif template.type == DetectEventType.HELPER then
    imgComponent:LoadSprite("Assets/Main/Sprites/UI/UIRadarCenter/zyf_leida_touxiangkuang")
    imgComponent.transform:Set_localPosition(0, bg_pos_help, 0)
  else
    imgComponent:LoadSprite(DetectEvenColorImage[template.quality])
    imgComponent.transform:Set_localPosition(0, bg_pos_1, 0)
  end
end

local function Refresh(self)
  local template = DataCenter.DetectEventTemplateManager:GetDetectEventTemplate(self.param.eventId)
  if template == nil then
    return
  end
  self:RefreshRedDotPos(template)
  self.red_dot:SetForceTipVisible(self.param.state == DetectEventState.DETECT_EVENT_STATE_FINISHED)
  self.complete_img:SetActive(self.param.state == DetectEventState.DETECT_EVENT_STATE_FINISHED)
  self:SetBgImg(self.quality_img)
  if self.param.state == DetectEventState.DETECT_EVENT_STATE_FINISHED then
    self:SetBgImg(self.complete_img)
  end
  self.quality_img:SetNativeSize()
  self.complete_img:SetNativeSize()
  self:CheckAndHideRadarScanEffect()
  self.vfx_special_event_effect:SetActive(template.type == DetectEventType.DetectEventTypeSpecial)
  self.vfx_special_event_effect1:SetActive(template.type == DetectEventType.SPECIAL_OPS)
  self.detect_Event_Img_mask:SetActive(false)
  self.uiPlayerHead:SetActive(false)
  self.titleTxt:SetActive(false)
  self.event_img:SetActive(true)
  self.event_monster_img:SetActive(false)
  self.event_img_mask:SetActive(false)
  self.quality_img:SetLocalScale(ResetScale)
  self.detect_Event_Img_mask:SetLocalScaleXYZ(1, 1, 1)
  if self.shineVFXReq then
    self.shineVFXReq.gameObject:SetActive(false)
  end
  if template.type == DetectEventType.FAKE_PLAYER then
    self.detect_Event_Img_mask:SetActive(true)
    local imgName = template.icon
    local imgPath = string.format(LoadPath.UIPlayerIcon, imgName)
    self.event_img:LoadSprite(imgPath)
    self.event_img:SetNativeSize()
    self.event_img.rectTransform:Set_anchoredPosition(0, item_pos_fake_player)
    self.event_img.unity_image.maskable = false
    self.event_img:SetLocalScaleXYZ(1.2, 1.2, 1.2)
  elseif template.type == DetectEventType.HELPER then
    self.uiPlayerHead:SetActive(true)
    local framePath = DataCenter.DecorationDataManager:GetHeadFrame(self.param.helpInfo.headSkinId, self.param.helpInfo.headSkinET, false)
    local activityHeadIcon = DataCenter.ActivityListDataManager:GetActivityRadarHeadIcon(false)
    self.uiPlayerHead:SetData(self.param.helpInfo.uid, activityHeadIcon and activityHeadIcon or self.param.helpInfo.pic, self.param.helpInfo.picVer, nil, framePath)
    self.titleTxt:SetActive(true)
    self.titleTxt:SetText(string.format("[%s]%s", self.param.helpInfo.abbr, self.param.helpInfo.name))
  elseif template.type == DetectEventType.CAVE_EXPLORATION and template:IsRollTreasure() then
    self.detect_Event_Img_mask:SetActive(true)
    local appearenceId = template.appearance_id
    if appearenceId == 0 then
      self.event_img:LoadSpriteAsyncWithCallback(string.format(LoadPath.RadarCenterPath, template.icon), function(texture)
        if self and self.event_img then
          self.event_img:SetNativeSize()
        end
      end)
      self.event_img.unity_image.maskable = true
      self.event_img:SetLocalScale(ResetScale)
    else
      local iconPath = HeroUtils.GetHeroIconPath(appearenceId)
      self.event_img:LoadSpriteAsyncWithCallback(iconPath, function()
        if self and self.event_img then
          self.event_img:SetNativeSize()
        end
      end)
      self.event_img.unity_image.maskable = true
      self.event_img:SetLocalScale(ResetScale)
    end
    self.event_img.rectTransform:Set_anchoredPosition(0, -10)
  elseif template.type == DetectEventType.ZOMBIE_BUS_TRAIN then
    local isOrange = template.quality >= 5
    if self.shineVFXReq then
      if isOrange then
        self.shineVFXReq.gameObject:SetActive(true)
        if self.shineParticle then
          self.shineParticle:Play()
        end
      else
        self.shineVFXReq.gameObject:SetActive(false)
      end
    elseif isOrange then
      self.shineVFXReq = self:GameObjectInstantiateAsync(shiningVFX, function(request)
        if request.isError then
          return
        end
        local go = request.gameObject
        go:SetActive(true)
        go.transform:SetParent(self.transform)
        local rect = go.transform:GetComponent(typeof(CS.UnityEngine.RectTransform))
        rect:Set_anchoredPosition(0, 100)
        go.transform:Set_localScale(1.2, 1.2, 1)
        go.transform:SetAsFirstSibling()
      end)
    end
    self.detect_Event_Img_mask:SetActive(true)
    self.event_img:LoadSprite(string.format(LoadPath.RadarCenterPath, template.icon))
    self.event_img:SetNativeSize()
    self.event_img.rectTransform:Set_anchoredPosition(0, item_pos_1)
    self.event_img.unity_image.maskable = true
    self.detect_Event_Img_mask:SetLocalScaleXYZ(1.2, 1.2, 1)
    self.quality_img:SetLocalScaleXYZ(1.2, 1.2, 1)
  else
    self.detect_Event_Img_mask:SetActive(true)
    local appearenceId = template.appearance_id
    if appearenceId == 0 then
      if not string.IsNullOrEmpty(template.icon_custom) then
        self.event_img:LoadSprite(template.icon_custom)
      else
        self.event_img:LoadSprite(string.format(LoadPath.RadarCenterPath, template.icon))
      end
      self.event_img:SetNativeSize()
      self.event_img.rectTransform:Set_anchoredPosition(0, item_pos_1)
      self.event_img.unity_image.maskable = true
      self.event_img:SetLocalScale(ResetScale)
    else
      local iconPath = HeroUtils.GetHeroIconPath(appearenceId)
      self.event_img:LoadSpriteAsyncWithCallback(iconPath, function(texture)
        if self and self.event_img then
          self.event_img:SetNativeSize()
        end
      end)
      self.event_img.rectTransform:Set_anchoredPosition(0, item_pos_2)
      self.event_img.unity_image.maskable = true
      self.event_img:SetLocalScale(ResetScale)
    end
  end
  if template.type == DetectEventType.OFF_SEASON_TREASURE then
    self.event_img.rectTransform:Set_anchoredPosition(0, 0)
  end
  if self.param.uuid ~= self.selectUuid then
    DOTween.Rewind(self.item_all.gameObject)
    self.item_all.transform:DOLocalMove(Vector3.zero, 0.25)
  end
  local isGoto = DataCenter.RadarCenterDataManager:IsDetectEventDoing(self.param.uuid)
  self.detectEventIsDoing = isGoto
  if isGoto then
    self.quality_img:SetColor(Color.New(1, 1, 1, 0.3))
    self.event_img:SetColor(Color.New(1, 1, 1, 0.3))
    self.detect_event_point:SetColor(Color.New(1, 1, 1, 0.3))
    self.uiPlayerCanvasGroup:SetAlpha(0.3)
  else
    self.quality_img:SetColor(WhiteColor)
    self.event_img:SetColor(WhiteColor)
    self.detect_event_point:SetColor(WhiteColor)
    self.uiPlayerCanvasGroup:SetAlpha(1)
  end
  self:RefreshCountdownImageShowState()
end

local function RefreshRedDotPos(self, template)
  if template.type == DetectEventType.HELPER then
    self.red_dot:SetAnchoredPositionXY(36, 143)
  else
    self.red_dot:SetAnchoredPositionXY(36, 168)
  end
end

local function CheckAndHideRadarScanEffect(self)
  if self.lastPlayEffectTime > 0 and UITimeManager:GetInstance():GetServerTime() - self.lastPlayEffectTime > particle_show_time then
    self.vfx_radar_scan:SetActive(false)
  end
end

local function ShowRadarScanEffect(self)
  self.lastPlayEffectTime = UITimeManager:GetInstance():GetServerTime()
  self.vfx_radar_scan:SetActive(false)
  self.vfx_radar_scan:SetActive(true)
end

local function GetGuideObject(self)
  return self.quality_img.gameObject
end

function DetectEventItem:GetPointerPosition()
  return self.event_img.transform.position
end

function DetectEventItem:GetEventPoint()
  return self.detect_event_point
end

local function RefreshCountdownImageShowState(self)
  local detectEventInfo = DataCenter.RadarCenterDataManager:GetDetectEventInfo(self.param.uuid)
  if detectEventInfo then
    local now = UITimeManager:GetInstance():GetServerTime()
    local remainTime = (detectEventInfo.endTime - now) / 1000
    local isOutTime = remainTime <= 3600
    if isOutTime then
      local isShow = detectEventInfo.state ~= DetectEventState.DETECT_EVENT_STATE_FINISHED and not self.detectEventIsDoing
      self.countdown_image:SetActive(isShow)
    else
      self.countdown_image:SetActive(false)
    end
  else
    self.countdown_image:SetActive(false)
  end
end

function DetectEventItem:PlayVfx()
  self.v_f_x_complete:SetActive(false)
  self.v_f_x_complete:SetActive(true)
end

DetectEventItem.OnCreate = OnCreate
DetectEventItem.OnDestroy = OnDestroy
DetectEventItem.ComponentDefine = ComponentDefine
DetectEventItem.ComponentDestroy = ComponentDestroy
DetectEventItem.SetUuid = SetUuid
DetectEventItem.DataDefine = DataDefine
DetectEventItem.DataDestroy = DataDestroy
DetectEventItem.Refresh = Refresh
DetectEventItem.SetBgImg = SetBgImg
DetectEventItem.OnPointerDown = OnPointerDown
DetectEventItem.PlayShowAnimation = PlayShowAnimation
DetectEventItem.DelayInvoke = DelayInvoke
DetectEventItem.ShowRadarScanEffect = ShowRadarScanEffect
DetectEventItem.CheckAndHideRadarScanEffect = CheckAndHideRadarScanEffect
DetectEventItem.setSelectUuid = setSelectUuid
DetectEventItem.GetGuideObject = GetGuideObject
DetectEventItem.RefreshRedDotPos = RefreshRedDotPos
DetectEventItem.RefreshCountdownImageShowState = RefreshCountdownImageShowState
DetectEventItem.Update1000MS = Update1000MS
return DetectEventItem
