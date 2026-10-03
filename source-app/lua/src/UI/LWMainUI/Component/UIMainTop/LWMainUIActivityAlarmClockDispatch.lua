local LWMainUIActivityAlarmClockDispatch = BaseClass("LWMainUIActivityAlarmClockDispatch", UIBaseContainer)
local base = UIBaseContainer
local UIMainActivityAlarmClockObj = require("UI.LWMainUI.Component.UIMainTop.LWMainUIActivityAlarmClockObj")
local Resource = CS.GameEntry.Resource

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

local function OnDestroy(self)
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  self:DestroyActivityAlarmClockView_View()
  self:ClearTopViewData()
  base.OnDisable(self)
end

local function ComponentDefine(self)
end

local function ComponentDestroy(self)
end

local function DataDefine(self)
  self:ClearTopViewData()
end

local function DataDestroy(self)
  self:ClearTopViewData()
end

local function OnAddListener(self)
  self:AddUIListener(EventId.GF_guide_start, self.ForceDestroyActivityAlarmClockView)
  self:AddUIListener(EventId.ChangeOtherScene, self.ForceDestroyActivityAlarmClockView)
end

local function OnRemoveListener(self)
  self:RemoveUIListener(EventId.GF_guide_start, self.ForceDestroyActivityAlarmClockView)
  self:RemoveUIListener(EventId.ChangeOtherScene, self.ForceDestroyActivityAlarmClockView)
end

function LWMainUIActivityAlarmClockDispatch:RefreshShowActivityAlarmClockView()
  local needShowTop = DataCenter.LWActivityAlarmClockManager:AlarmClockTipNeedShowTop()
  if needShowTop then
    self:DestroyActivityAlarmClockView_Comp()
    self:RefreshShowActivityAlarmClockView_View()
  else
    self:DestroyActivityAlarmClockView_View()
    self:ClearTopViewData()
    self:RefreshShowActivityAlarmClockView_Comp()
  end
end

function LWMainUIActivityAlarmClockDispatch:DestroyActivityAlarmClockView()
  self:DestroyActivityAlarmClockView_Comp()
  self:DestroyActivityAlarmClockView_View()
  self:ClearTopViewData()
end

function LWMainUIActivityAlarmClockDispatch:RefreshShowActivityAlarmClockView_Comp()
  local alarmClockData = DataCenter.LWActivityAlarmClockManager:GetNeedShowMainUITopAlarmClockData()
  if alarmClockData ~= nil then
    if self.activityAlarmClockReq == nil then
      self.activityAlarmClockReq = Resource:InstantiateAsync("Assets/Main/Prefabs/UI/LWMainUI/LWMainUIActivityAlarmClockObj.prefab")
      self.activityAlarmClockReq:completed("+", function(req)
        local gameObject = req.gameObject
        if IsNull(gameObject) then
          self:DestroyActivityAlarmClockView()
          return
        end
        gameObject.transform:SetParent(self.transform)
        gameObject.transform:Set_localScale(1, 1, 1)
        gameObject.transform:Set_anchoredPosition(-21, -63, 0)
        local name = "LWMainUIActivityAlarmClockObj"
        gameObject.name = name
        self.activityAlarmClockObj = self:AddComponent(UIMainActivityAlarmClockObj, name)
        self.activityAlarmClockObj:ReInit(alarmClockData)
      end)
    elseif self.activityAlarmClockObj ~= nil then
      self.activityAlarmClockObj:ReInit(alarmClockData)
    end
  else
    if self.activityAlarmClockObj ~= nil then
      self.activityAlarmClockObj:ReInit(nil)
    end
    self:HideActivityAlarmClockView()
  end
end

function LWMainUIActivityAlarmClockDispatch:HideActivityAlarmClockView()
  if self.activityAlarmClockObj ~= nil then
    self.activityAlarmClockObj:SetActiveState(false)
  end
end

function LWMainUIActivityAlarmClockDispatch:DestroyActivityAlarmClockView_Comp()
  self:RemoveComponents(UIMainActivityAlarmClockObj)
  if self.activityAlarmClockReq ~= nil then
    self.activityAlarmClockReq:Destroy()
    self.activityAlarmClockReq = nil
  end
  self.activityAlarmClockObj = nil
end

function LWMainUIActivityAlarmClockDispatch:RefreshShowActivityAlarmClockView_View()
  local alarmClockData = DataCenter.LWActivityAlarmClockManager:GetNeedShowMainUITopAlarmClockData()
  self.alarmClockTopData = alarmClockData
  self.showTopView = self:GetNeedShowView(self.alarmClockTopData)
  if self.showTopView then
    self:OpenLWUIActivityAlarmClockTopView(self.alarmClockTopData)
  else
    self:DestroyActivityAlarmClockView_View()
  end
end

function LWMainUIActivityAlarmClockDispatch:OpenLWUIActivityAlarmClockTopView(alarmClockData)
  if UIManager:GetInstance():IsWindowOpen(UIWindowNames.LWUIActivityAlarmClockTop) then
    EventManager:GetInstance():Broadcast(EventId.UpdateActivityAlarmClockTopView, alarmClockData)
  else
    UIManager:GetInstance():OpenWindow(UIWindowNames.LWUIActivityAlarmClockTop, {anim = false, playEffect = false}, alarmClockData)
  end
end

function LWMainUIActivityAlarmClockDispatch:GetNeedShowView(alarmClockTopData)
  if alarmClockTopData then
    local curTime = UITimeManager:GetInstance():GetServerTime()
    if self:GetActive() and not DataCenter.LWGuideFlowManager:IsRunning() and (SceneUtils.GetIsInCity() or SceneUtils.GetIsInWorld()) and curTime >= alarmClockTopData.showMainUITopStartTime and curTime <= alarmClockTopData.showMainUITopEndTime then
      return true
    end
  end
  return false
end

function LWMainUIActivityAlarmClockDispatch:DestroyActivityAlarmClockView_View()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.LWUIActivityAlarmClockTop, {anim = false, playEffect = false})
end

function LWMainUIActivityAlarmClockDispatch:ClearTopViewData()
  self.alarmClockTopData = nil
  self.showTopView = false
end

function LWMainUIActivityAlarmClockDispatch:Update1000MS()
  if self.alarmClockTopData == nil then
    return
  end
  if self.showTopView then
    if UIManager:GetInstance():IsWindowOpen(UIWindowNames.LWUIActivityAlarmClockTop) then
      local window = UIManager:GetInstance():GetWindow(UIWindowNames.LWUIActivityAlarmClockTop)
      local isShow = false
      if window and window.View and window.View.IsShow then
        isShow = window.View:IsShow()
      end
      if not isShow then
        self:DestroyActivityAlarmClockView_View()
        self:ClearTopViewData()
      end
    end
  else
    local showTopView = self:GetNeedShowView(self.alarmClockTopData)
    if showTopView then
      self.showTopView = showTopView
      self:OpenLWUIActivityAlarmClockTopView(self.alarmClockTopData)
    end
  end
end

function LWMainUIActivityAlarmClockDispatch:ForceDestroyActivityAlarmClockView()
  self:DestroyActivityAlarmClockView()
  self:ClearTopViewData()
end

LWMainUIActivityAlarmClockDispatch.OnCreate = OnCreate
LWMainUIActivityAlarmClockDispatch.OnDestroy = OnDestroy
LWMainUIActivityAlarmClockDispatch.OnEnable = OnEnable
LWMainUIActivityAlarmClockDispatch.OnDisable = OnDisable
LWMainUIActivityAlarmClockDispatch.ComponentDefine = ComponentDefine
LWMainUIActivityAlarmClockDispatch.ComponentDestroy = ComponentDestroy
LWMainUIActivityAlarmClockDispatch.DataDefine = DataDefine
LWMainUIActivityAlarmClockDispatch.DataDestroy = DataDestroy
LWMainUIActivityAlarmClockDispatch.OnAddListener = OnAddListener
LWMainUIActivityAlarmClockDispatch.OnRemoveListener = OnRemoveListener
return LWMainUIActivityAlarmClockDispatch
