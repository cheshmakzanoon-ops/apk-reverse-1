local UIMainArmedUpgradeWarningBubbleCtrl = BaseClass("UIMainArmedUpgradeWarningBubbleCtrl", UIBaseContainer)
local base = UIBaseContainer
local UIMainArmedUpgradeWarningBubbleView = require("UI.UILWArmedUpgrade.WarningBubble.UIMainArmedUpgradeWarningBubbleView")
local AssetPath = "Assets/Main/Prefabs/UI/UILWArmedUpgrade/UIMainWarning/UIMainArmedUpgradeWarningBubble.prefab"

function UIMainArmedUpgradeWarningBubbleCtrl:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:AddUIListener(EventId.ArmedUpgradeMainUIRefresh, self.ReInit)
  self:AddUIListener(EventId.CityEventRefresh, self.ReInit)
  self:AddUIListener(EventId.ArmedUpgradeMainUIBubblePreFly, self.OnPreFly)
  self:AddUIListener(EventId.ArmedUpgradeMainUIBubbleEffect, self.OnEffect)
  self:AddUIListener(EventId.ArmedUpgradeLevelChanged, self.OnRefreshArmedUpgradeLevel)
end

function UIMainArmedUpgradeWarningBubbleCtrl:OnDestroy()
  self:RemoveUIListener(EventId.ArmedUpgradeMainUIRefresh, self.ReInit)
  self:RemoveUIListener(EventId.CityEventRefresh, self.ReInit)
  self:RemoveUIListener(EventId.ArmedUpgradeMainUIBubblePreFly, self.OnPreFly)
  self:RemoveUIListener(EventId.ArmedUpgradeMainUIBubbleEffect, self.OnEffect)
  self:RemoveUIListener(EventId.ArmedUpgradeLevelChanged, self.OnRefreshArmedUpgradeLevel)
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

function UIMainArmedUpgradeWarningBubbleCtrl:OnEnable()
  base.OnEnable(self)
  EventManager:GetInstance():Broadcast(EventId.MainUILeftPosRefresh)
end

function UIMainArmedUpgradeWarningBubbleCtrl:OnDisable()
  EventManager:GetInstance():Broadcast(EventId.MainUILeftPosRefresh)
  base.OnDisable(self)
end

function UIMainArmedUpgradeWarningBubbleCtrl:ComponentDefine()
  self.bubbleView = nil
  self.instanceRequest = nil
end

function UIMainArmedUpgradeWarningBubbleCtrl:ComponentDestroy()
  self.bubbleView = nil
  self.instanceRequest = nil
end

function UIMainArmedUpgradeWarningBubbleCtrl:DataDefine()
  self.activeLogic = false
  self.isOnPreFly = false
  self.isOnEffect = false
  self.ignorePlotBubbleOnce = false
end

function UIMainArmedUpgradeWarningBubbleCtrl:DataDestroy()
  self.activeLogic = nil
  self.isOnPreFly = nil
  self.isOnEffect = nil
  self.ignorePlotBubbleOnce = nil
end

function UIMainArmedUpgradeWarningBubbleCtrl:ReInit()
  local cityEventHappen = DataCenter.LWBeginnerDirectorManager:GetCurCityEvent()
  if cityEventHappen then
    self:SetActiveLogic(false)
    return
  end
  local isOpen = DataCenter.LWArmedUpgradeManager:IsArmedUpgradeOpen()
  if not isOpen then
    self:SetActiveLogic(false)
    return
  end
  if not DataCenter.LWArmedUpgradeManager.appearanceVisible then
    self:SetActiveLogic(false)
    return
  end
  if not DataCenter.LWArmedUpgradeManager.finishClickGuide then
    self:SetActiveLogic(false)
    return
  end
  self:SetActiveLogic(true)
  if self.bubbleView then
    self:InstanceReInit()
  end
end

function UIMainArmedUpgradeWarningBubbleCtrl:InstanceReInit()
  if self.ignorePlotBubbleOnce then
    self.bubbleView:SetIgnorePlotBubbleOnce()
    self.ignorePlotBubbleOnce = nil
  end
  self.bubbleView:ReInit()
end

function UIMainArmedUpgradeWarningBubbleCtrl:SetActiveLogic(active)
  self.activeLogic = active
  self:SetActive(active)
  if self.bubbleView then
    self.bubbleView:SetActive(active)
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
      self.bubbleView = self:AddComponent(UIMainArmedUpgradeWarningBubbleView, go)
      self.bubbleView:SetActive(self.activeLogic)
      self:InstanceReInit()
      if self.isOnPreFly then
        self.bubbleView:OnPreFly()
      end
      if self.isOnEffect then
        self.bubbleView:OnEffect()
      end
    end)
  end
end

function UIMainArmedUpgradeWarningBubbleCtrl:OnPreFly()
  local isOpen = DataCenter.LWArmedUpgradeManager:IsArmedUpgradeOpen()
  if not isOpen then
    return
  end
  self.ignorePlotBubbleOnce = true
  self:SetActiveLogic(true)
  if self.bubbleView then
    self.bubbleView:OnPreFly()
  else
    self.isOnPreFly = true
  end
end

function UIMainArmedUpgradeWarningBubbleCtrl:OnEffect()
  if self.bubbleView then
    self.bubbleView:OnEffect()
  else
    self.isOnEffect = true
  end
end

function UIMainArmedUpgradeWarningBubbleCtrl:OnRefreshArmedUpgradeLevel(isMaxLevel)
  if isMaxLevel then
    self:SetActiveLogic(false)
  elseif self.bubbleView then
    self.bubbleView:RefreshArmedUpgradeProgress()
  end
end

return UIMainArmedUpgradeWarningBubbleCtrl
