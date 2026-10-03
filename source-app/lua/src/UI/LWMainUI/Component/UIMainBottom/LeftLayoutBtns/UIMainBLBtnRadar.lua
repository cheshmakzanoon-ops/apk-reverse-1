local UIMainBLBtnBase = require("UI.LWMainUI.Component.UIMainBottom.LeftLayoutBtns.UIMainBLBtnBase")
local UIMainBLBtnRadar = BaseClass("UIMainBLBtnRadar", UIMainBLBtnBase)
local base = UIMainBLBtnBase
local UIRadarZombieBusEnterTip = require("UI.LWMainUI.Component.UIMainBottom.UIRadarZombieBusTrainEnterTip")

local function OnAddMainBtnListener(self)
  base.OnAddMainBtnListener(self)
  self:AddUIListener(EventId.GetAllDetectInfo, self.Refresh)
  self:AddUIListener(EventId.DetectInfoChange, self.Refresh)
  self:AddUIListener(EventId.OnEnterCity, self.Refresh)
  self:AddUIListener(EventId.OnEnterWorld, self.Refresh)
  self:AddUIListener(EventId.SurvivalVipGiftInfoUpdate, self.Refresh)
  self:AddUIListener(EventId.SurvivalVipGiftFreeReward, self.Refresh)
end

local function OnRemoveMainBtnListener(self)
  base.OnRemoveMainBtnListener(self)
  self:RemoveUIListener(EventId.GetAllDetectInfo, self.Refresh)
  self:RemoveUIListener(EventId.DetectInfoChange, self.Refresh)
  self:RemoveUIListener(EventId.OnEnterCity, self.Refresh)
  self:RemoveUIListener(EventId.OnEnterWorld, self.Refresh)
  self:RemoveUIListener(EventId.SurvivalVipGiftInfoUpdate, self.Refresh)
  self:RemoveUIListener(EventId.SurvivalVipGiftFreeReward, self.Refresh)
end

local function OnClick(self)
  self.commonRedPoint:SetViewed()
  if not UIUtil.CheckDetectCanCrossServer() and CrossServerUtil:NeedIntercept(500019) then
    return
  end
  if self.fingerHandle ~= nil then
    self.fingerHandle:Destroy()
    self.fingerHandle = nil
  end
  DataCenter.RadarCenterDataManager:RecordDetectTriggerTime()
  local showPointer = false
  local uuid
  local radarEventZombieBus = DataCenter.RadarCenterDataManager:GetZombieBusTrainEvent()
  if radarEventZombieBus ~= nil then
    showPointer = true
    uuid = radarEventZombieBus.uuid
    if radarEventZombieBus.state == DetectEventState.DETECT_EVENT_STATE_NOT_IN_WORLD then
      self:HideZombieBusEnterTipItem()
      DataCenter.RadarCenterDataManager.lastShowRadarZombieBusTime = UITimeManager:GetInstance():GetServerTime()
    elseif radarEventZombieBus.state == DetectEventState.DETECT_EVENT_STATE_NOT_FINISH then
      self:HideZombieBusAlarmEffect()
      DataCenter.RadarCenterDataManager.lastShowRadarZombieBusAttackEffTime = UITimeManager:GetInstance():GetServerTime()
    end
  end
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIDetectEvent, {
    anim = true,
    UIMainAnim = UIMainAnimType.AllHide
  }, uuid, showPointer)
end

function UIMainBLBtnRadar:CheckToShowRadarZombieBus()
  local needShowZombieBusEnterTip = false
  local radarEventZombieBus = DataCenter.RadarCenterDataManager:GetZombieBusTrainEvent()
  local lastShowZombieBusTime = DataCenter.RadarCenterDataManager.lastShowRadarZombieBusTime
  if radarEventZombieBus and radarEventZombieBus.state == DetectEventState.DETECT_EVENT_STATE_NOT_IN_WORLD then
    if lastShowZombieBusTime == 0 then
      needShowZombieBusEnterTip = true
    else
      local lastShowDayEndTime = UITimeManager:GetInstance():GetNextZero(lastShowZombieBusTime)
      local serverTime = UITimeManager:GetInstance():GetServerTime()
      needShowZombieBusEnterTip = lastShowDayEndTime < serverTime
    end
  end
  self.needShowZombieBusEnterTip = needShowZombieBusEnterTip
  if needShowZombieBusEnterTip then
    if not self.zombieBusEnterTipItemReq then
      self.zombieBusEnterTipItemReq = self:GameObjectInstantiateAsync("Assets/Main/Prefabs/UI/UILWRadarCenter/UIDetectZombieBusEnterTip.prefab", function(request)
        if request.isError then
          return
        end
        local go = request.gameObject
        go.gameObject:SetActive(self.needShowZombieBusEnterTip)
        go.transform:SetParent(self.transform)
        go.transform:Set_localScale(1, 1, 1)
        self.zombieBusEnterTipItem = self:AddComponent(UIRadarZombieBusEnterTip, go.name)
        self.zombieBusEnterTipItem:SetAnchoredPositionXY(0, 0)
      end)
    elseif self.zombieBusEnterTipItem then
      self.zombieBusEnterTipItem:SetActive(true)
    end
  elseif self.zombieBusEnterTipItem then
    self.zombieBusEnterTipItem:SetActive(false)
  end
end

function UIMainBLBtnRadar:CheckToShowRadarZombieBusAlarmEffect()
  local radarEventZombieBus = DataCenter.RadarCenterDataManager:GetZombieBusTrainEvent()
  local needShowZombieBusAlarmEffect = false
  if radarEventZombieBus then
    local lastShowRadarZombieBusAttackEffTime = DataCenter.RadarCenterDataManager.lastShowRadarZombieBusAttackEffTime
    if radarEventZombieBus.state == DetectEventState.DETECT_EVENT_STATE_NOT_FINISH then
      if lastShowRadarZombieBusAttackEffTime == 0 then
        needShowZombieBusAlarmEffect = true
      else
        local lastShowDayEndTime = UITimeManager:GetInstance():GetNextZero(lastShowRadarZombieBusAttackEffTime)
        local serverTime = UITimeManager:GetInstance():GetServerTime()
        needShowZombieBusAlarmEffect = lastShowDayEndTime < serverTime
      end
    end
  end
  self.radarZombieBusAlarmShow = needShowZombieBusAlarmEffect
  if self.radarZombieBusAlarmShow then
    if not self.detectAlarmReq then
      self.detectAlarmReq = self:GameObjectInstantiateAsync("Assets/Main/Prefabs/UI/LWMainUI/Eff_radar_fxglow.prefab", function(request)
        if request.isError then
          return
        end
        local go = request.gameObject
        go.gameObject:SetActive(self.radarZombieBusAlarmShow)
        go.transform:SetParent(self.transform)
        go.transform:Set_localScale(1, 1, 1)
        go.transform:Set_localPosition(0, 0, 0)
        self.detectAlarmObj = go
      end)
    elseif self.detectAlarmObj then
      self.detectAlarmObj:SetActive(true)
    end
  elseif self.detectAlarmObj then
    self.detectAlarmObj:SetActive(false)
  end
end

function UIMainBLBtnRadar:HideZombieBusEnterTipItem()
  if self.zombieBusEnterTipItem then
    self.zombieBusEnterTipItem:SetActive(false)
  end
end

function UIMainBLBtnRadar:HideZombieBusAlarmEffect()
  if self.detectAlarmObj then
    self.detectAlarmObj:SetActive(false)
  end
end

local function CheckEnable(self)
  local inCity = SceneUtils.GetIsInCity()
  local unlock = self:CheckUnlock()
  self:CheckToShowRadarZombieBus()
  self:CheckToShowRadarZombieBusAlarmEffect()
  self.nextTimeToForceRefreshZombieBus = DataCenter.RadarCenterDataManager:GetNextTimeToForceRefreshZombieBusTrain()
  local num = self:RefreshRedDotNum()
  if unlock and 0 < num and CommonUtil.PlayerPrefsGetInt("MAIN_UI_HERO_RADAR_BTN_GUIDE", 0) == 0 then
    CommonUtil.PlayerPrefsSetInt("MAIN_UI_HERO_RADAR_BTN_GUIDE", 1)
    self.fingerHandle = CS.GameEntry.Resource:InstantiateAsync("Assets/Main/Prefabs/Guide/UIArrowFinger.prefab")
    self.fingerHandle:completed("+", function(handle)
      if handle.isError then
        return
      end
      if IsNull(self.transform) then
        self.fingerHandle:Destroy()
        return
      end
      CommonUtil.CallAutoArabicMirrorManually(handle)
      local gameObject = handle.gameObject
      local transform = gameObject.transform
      transform:SetParent(UIManager:GetInstance():GetLayer(UILayer.Guide.Name).transform, false)
      transform.position = self.transform.position
      TimerManager:GetInstance():DelayInvoke(function()
        if self.fingerHandle then
          self.fingerHandle:Destroy()
        end
      end, 3)
    end)
  end
  return unlock
end

local updateTime = -1

local function Update(self)
  local curTime = UITimeManager:GetInstance():GetServerTime()
  if curTime > updateTime + 2000 then
    updateTime = curTime
    local nextRefreshTime = DataCenter.RadarCenterDataManager:GetDetectInfoNextRefreshTime()
    local detectTriggerTime = DataCenter.RadarCenterDataManager:GetDetectTriggerTime()
    if curTime > nextRefreshTime and nextRefreshTime > detectTriggerTime then
      self:Refresh()
    end
  end
  if self.nextTimeToForceRefreshZombieBus and self.nextTimeToForceRefreshZombieBus > 0 and curTime > self.nextTimeToForceRefreshZombieBus then
    self.nextTimeToForceRefreshZombieBus = nil
    DataCenter.RadarCenterDataManager:GetDetectEventData()
  end
end

UIMainBLBtnRadar.OnClick = OnClick
UIMainBLBtnRadar.OnAddMainBtnListener = OnAddMainBtnListener
UIMainBLBtnRadar.OnRemoveMainBtnListener = OnRemoveMainBtnListener
UIMainBLBtnRadar.CheckEnable = CheckEnable
UIMainBLBtnRadar.Update = Update
return UIMainBLBtnRadar
