local UIAttackUnitsTipsView = BaseClass("UIAttackUnitsTipsView", UIBaseView)
local UIAttackUnitsTipsItem = require("UI.UIAttackUnitsTips.Component.UIAttackUnitsTipsItem")
local base = UIBaseView
local attack_units_tips_item_path = "Root/AttackUnitsTipsItem"

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

local function OnDestroy(self)
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function ComponentDefine(self)
  self.root = self:AddComponent(UIBaseContainer, "Root")
  self.itemGo = self.transform:Find(attack_units_tips_item_path).gameObject
  self.itemGo:SetActive(false)
  self.itemGo:GameObjectCreatePool()
end

local function ComponentDestroy(self)
  self.root:RemoveComponents(UIAttackUnitsTipsItem)
  self.root = nil
  self.itemGo:GameObjectRecycleAll()
  self.itemGo = nil
end

local function DataDefine(self)
  local param = self:GetUserData()
  self:Init(param)
  self.timer = nil
end

local function DataDestroy(self)
  if self.timer then
    self.timer:Stop()
  end
  self.timer = nil
end

local function OnAddListener(self)
  base.OnAddListener(self)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
end

local function Init(self, param)
  if param then
    self:RefreshView(param)
  end
  local duration = LuaEntry.DataConfig:TryGetNum("lock_banner", "k1", 0)
  self.timer = TimerManager:GetInstance():DelayInvoke(function()
    if self and self.timer then
      self.timer:Stop()
      self.timer = nil
    end
    if self and self.ctrl then
      self.ctrl:CloseSelf()
    end
  end, duration)
end

local function OnCloseClick(self)
end

local function RefreshView(self, param)
  if param then
    local comp = self.itemComp
    if comp == nil then
      local go = self.itemGo:GameObjectSpawn(self.root.transform)
      go.name = "item"
      comp = self.root:AddComponent(UIAttackUnitsTipsItem, go.name)
      self.itemComp = comp
    end
    comp:SetActive(true)
    comp:RefreshView(param)
  end
end

UIAttackUnitsTipsView.OnCreate = OnCreate
UIAttackUnitsTipsView.OnDestroy = OnDestroy
UIAttackUnitsTipsView.OnEnable = OnEnable
UIAttackUnitsTipsView.OnDisable = OnDisable
UIAttackUnitsTipsView.ComponentDefine = ComponentDefine
UIAttackUnitsTipsView.ComponentDestroy = ComponentDestroy
UIAttackUnitsTipsView.DataDefine = DataDefine
UIAttackUnitsTipsView.DataDestroy = DataDestroy
UIAttackUnitsTipsView.OnAddListener = OnAddListener
UIAttackUnitsTipsView.OnRemoveListener = OnRemoveListener
UIAttackUnitsTipsView.OnCloseClick = OnCloseClick
UIAttackUnitsTipsView.RefreshView = RefreshView
UIAttackUnitsTipsView.Init = Init
return UIAttackUnitsTipsView
