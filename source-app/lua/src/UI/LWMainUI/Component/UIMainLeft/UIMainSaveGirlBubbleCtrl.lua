local UIMainSaveGirlBubbleCtrl = BaseClass("UIMainSaveGirlBubbleCtrl", UIBaseContainer)
local base = UIBaseContainer
local UIMainSaveGirlBubbleView = require("UI.LWMainUI.Component.UIMainLeft.UIMainSaveGirlBubbleView")
local AssetPath = "Assets/Main/Prefabs/UI/LWMainUI/SaveGirlWarning.prefab"

function UIMainSaveGirlBubbleCtrl:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:AddUIListener(EventId.SaveGirlMainUIRefresh, self.ReInit)
  self:AddUIListener(EventId.CityEventRefresh, self.ReInit)
  self:AddUIListener(EventId.SaveGirlPreFly, self.OnPreFly)
  self:AddUIListener(EventId.SaveGirlMainUIEffect, self.OnEffect)
end

function UIMainSaveGirlBubbleCtrl:OnDestroy()
  self:RemoveUIListener(EventId.SaveGirlMainUIRefresh, self.ReInit)
  self:RemoveUIListener(EventId.CityEventRefresh, self.ReInit)
  self:RemoveUIListener(EventId.SaveGirlPreFly, self.OnPreFly)
  self:RemoveUIListener(EventId.SaveGirlMainUIEffect, self.OnEffect)
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

function UIMainSaveGirlBubbleCtrl:OnEnable()
  base.OnEnable(self)
  EventManager:GetInstance():Broadcast(EventId.MainUILeftPosRefresh)
end

function UIMainSaveGirlBubbleCtrl:OnDisable()
  EventManager:GetInstance():Broadcast(EventId.MainUILeftPosRefresh)
  base.OnDisable(self)
end

function UIMainSaveGirlBubbleCtrl:ComponentDefine()
  self.saveGirlView = nil
  self.instanceRequest = nil
end

function UIMainSaveGirlBubbleCtrl:ComponentDestroy()
  self.saveGirlView = nil
  self.instanceRequest = nil
end

function UIMainSaveGirlBubbleCtrl:DataDefine()
  self.activeLogic = false
  self.isOnPreFly = false
  self.isOnEffect = false
  self.ignorePlotBubbleOnce = false
end

function UIMainSaveGirlBubbleCtrl:DataDestroy()
  self.activeLogic = nil
  self.isOnPreFly = nil
  self.isOnEffect = nil
  self.ignorePlotBubbleOnce = nil
end

function UIMainSaveGirlBubbleCtrl:ReInit()
  local cityEventHappen = DataCenter.LWBeginnerDirectorManager:GetCurCityEvent()
  if cityEventHappen then
    self:SetActiveLogic(false)
    return
  end
  local show = DataCenter.LWSaveGirlManager:IsShowBubble()
  if not show then
    self:SetActiveLogic(false)
    return
  end
  local endTime = DataCenter.LWSaveGirlManager:GetWarningEndTime()
  local curTime = UITimeManager:GetInstance():GetServerTime()
  if endTime < curTime then
    self:SetActiveLogic(false)
    return
  end
  self:SetActiveLogic(true)
  if self.saveGirlView then
    self:InstanceReInit()
  end
end

function UIMainSaveGirlBubbleCtrl:InstanceReInit()
  if self.ignorePlotBubbleOnce then
    self.saveGirlView:SetIgnorePlotBubbleOnce()
    self.ignorePlotBubbleOnce = nil
  end
  self.saveGirlView:ReInit()
end

function UIMainSaveGirlBubbleCtrl:SetActiveLogic(active)
  self.activeLogic = active
  self:SetActive(active)
  if self.saveGirlView then
    self.saveGirlView:SetActive(active)
  elseif active and not self.instanceRequest then
    self.instanceRequest = self:GameObjectInstantiateAsync(AssetPath, function(request)
      if request.isError then
        return
      end
      local go = request.gameObject
      local trans = go.transform
      trans:SetParent(self.transform)
      trans:Set_anchoredPosition(ResetPosition.x, ResetPosition.y)
      trans:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
      self.saveGirlView = self:AddComponent(UIMainSaveGirlBubbleView, go)
      self.saveGirlView:SetActive(self.activeLogic)
      self:InstanceReInit()
      if self.isOnPreFly then
        self.saveGirlView:OnPreFly()
      end
      if self.isOnEffect then
        self.saveGirlView:OnEffect()
      end
    end)
  end
end

function UIMainSaveGirlBubbleCtrl:Update1000MS()
  if self.activeLogic then
    self:UpdateTime()
  end
end

function UIMainSaveGirlBubbleCtrl:UpdateTime()
  local endTime = DataCenter.LWSaveGirlManager:GetWarningEndTime()
  local curTime = UITimeManager:GetInstance():GetServerTime()
  local diff = endTime - curTime
  if diff <= 0 then
    self:SetActiveLogic(false)
  elseif self.saveGirlView then
    self.saveGirlView:UpdateTime()
  end
end

function UIMainSaveGirlBubbleCtrl:OnPreFly()
  local show = DataCenter.LWSaveGirlManager:IsShowBubble()
  if not show then
    return
  end
  local endTime = DataCenter.LWSaveGirlManager:GetWarningEndTime()
  local curTime = UITimeManager:GetInstance():GetServerTime()
  if endTime < curTime then
    return
  end
  self.ignorePlotBubbleOnce = true
  self:SetActiveLogic(true)
  if self.saveGirlView then
    self.saveGirlView:OnPreFly()
  else
    self.isOnPreFly = true
  end
end

function UIMainSaveGirlBubbleCtrl:OnEffect()
  if self.saveGirlView then
    self.saveGirlView:OnEffect()
  else
    self.isOnEffect = true
  end
end

return UIMainSaveGirlBubbleCtrl
