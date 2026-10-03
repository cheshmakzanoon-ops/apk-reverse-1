local FakeZombieBusTrainDetectEventItem = BaseClass("FakeZombieBusTrainDetectEventItem", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local this_path = ""
local quality_img_path = "Item_All/Detect_Event_Quality_Img"
local detect_event_point_path = "Detect_event_point"
local titleTxt_path = "Item_All/titleTxt"
local event_img_path = "Item_All/Detect_Event_Img_mask/Detect_Event_Img"
local vfx_radar_scan_path = "VFX_leida_shijian"
local item_all_path = "Item_All"
local particle_show_time = 1000.0
local talk_panel = "Item_All/TalkPanel"
local talk_Content = "Item_All/TalkPanel/TalkContent"

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
  self.titleTxt = self:AddComponent(UIText, titleTxt_path)
  self.event_img = self:AddComponent(UIImage, event_img_path)
  self.vfx_radar_scan = self:AddComponent(UIBaseContainer, vfx_radar_scan_path)
  self.vfx_radar_scan:SetActive(false)
  self.item_all = self:AddComponent(UIBaseContainer, item_all_path)
  self.detect_event_point = self:AddComponent(UIImage, detect_event_point_path)
  DOTween.Rewind(self.gameObject)
  local delayTime = 1.0 * math.random(0, 10) / 150.0
  self:DelayInvoke(function()
    self:PlayShowAnimation()
  end, delayTime)
  DOTween.Rewind(self.item_all.gameObject)
  self.talkPanel = self:AddComponent(UIBaseContainer, talk_panel)
  self.talkPanel:SetActive(false)
  self.talkContentTxt = self:AddComponent(UIText, talk_Content)
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
  self.uuid = self:GetFakeZombieBusTrainDetectEventUUID()
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
  self.event_img = nil
  self.vfx_radar_scan = nil
  self.item_all = nil
  self.detect_event_point = nil
  self.titleTxt = nil
end

local function DataDestroy(self)
  self.lastPlayEffectTime = nil
end

local function setSelectUuid(self, selectUuid)
  self.selectUuid = selectUuid
  self:Refresh()
  if self.uuid == self.selectUuid then
    DOTween.Restart(self.item_all.gameObject)
    self.item_all.transform:DOLocalMove(Vector3.New(0, 20, 0), 0.25)
    self.talkPanel:SetActive(true)
    local verbs = DataCenter.RadarCenterDataManager:GetZombieBusTrainVerbs()
    if verbs and 1 <= #verbs then
      local randomIndex = math.random(1, #verbs)
      local verbKey = verbs[randomIndex]
      self.talkContentTxt:SetLocalText(verbKey)
    else
      self.talkContentTxt:SetText("")
    end
    self.transform:SetAsLastSibling()
  end
end

local function OnPointerDown(self, eventData)
  self.view:SetCurrentSelectItemId(self.uuid)
end

local function Refresh(self)
  self:CheckAndHideRadarScanEffect()
  self:Update1000MS()
  if self.uuid ~= self.selectUuid then
    DOTween.Rewind(self.item_all.gameObject)
    self.item_all.transform:DOLocalMove(Vector3.zero, 0.25)
    self.talkPanel:SetActive(false)
  end
end

function FakeZombieBusTrainDetectEventItem:Update1000MS()
  local refreshTime = DataCenter.RadarCenterDataManager:GetNextTimeToForceRefreshZombieBusTrain()
  if refreshTime then
    local deltaMillSeconds = math.max(0, refreshTime - UITimeManager:GetInstance():GetServerTime())
    local str = UITimeManager:GetInstance():MilliSecondToFmtStringWithoutDay(deltaMillSeconds)
    self.titleTxt:SetText(str)
  else
    self.titleTxt:SetText("00:00:00")
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

function FakeZombieBusTrainDetectEventItem:GetFakeZombieBusTrainDetectEventUUID()
  return "fakeZombieBusTrainDetectEventUUID"
end

FakeZombieBusTrainDetectEventItem.OnCreate = OnCreate
FakeZombieBusTrainDetectEventItem.OnDestroy = OnDestroy
FakeZombieBusTrainDetectEventItem.ComponentDefine = ComponentDefine
FakeZombieBusTrainDetectEventItem.ComponentDestroy = ComponentDestroy
FakeZombieBusTrainDetectEventItem.SetUuid = SetUuid
FakeZombieBusTrainDetectEventItem.DataDefine = DataDefine
FakeZombieBusTrainDetectEventItem.DataDestroy = DataDestroy
FakeZombieBusTrainDetectEventItem.Refresh = Refresh
FakeZombieBusTrainDetectEventItem.SetBgImg = SetBgImg
FakeZombieBusTrainDetectEventItem.OnPointerDown = OnPointerDown
FakeZombieBusTrainDetectEventItem.PlayShowAnimation = PlayShowAnimation
FakeZombieBusTrainDetectEventItem.DelayInvoke = DelayInvoke
FakeZombieBusTrainDetectEventItem.ShowRadarScanEffect = ShowRadarScanEffect
FakeZombieBusTrainDetectEventItem.CheckAndHideRadarScanEffect = CheckAndHideRadarScanEffect
FakeZombieBusTrainDetectEventItem.setSelectUuid = setSelectUuid
return FakeZombieBusTrainDetectEventItem
