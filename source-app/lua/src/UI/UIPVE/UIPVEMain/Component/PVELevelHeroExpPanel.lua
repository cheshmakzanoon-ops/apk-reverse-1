local PVELevelHeroExpPanel = BaseClass("PVELevelHeroExpPanel", UIBaseContainer)
local base = UIBaseContainer
local PVELevelHeroExpItem = require("UI.UIPVE.UIPVEMain.Component.PVELevelHeroExpItem")
local root_path = "Root"
local item_path = "Root/List/UIPVELevelHeroExpItem_%s"
local ITEM_COUNT = 5

local function OnCreate(self)
  base.OnCreate(self)
  self:DataDefine()
  self:ComponentDefine()
end

local function OnDestroy(self)
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

local function ComponentDefine(self)
  self.root_go = self:AddComponent(UIBaseContainer, root_path)
  self.itemList = {}
  for i = 1, ITEM_COUNT do
    self.itemList[i] = self:AddComponent(PVELevelHeroExpItem, string.format(item_path, i))
  end
  self:LockExtraSlots()
end

local function ComponentDestroy(self)
  self.root_go = nil
  self.itemList = nil
end

local function DataDefine(self)
  self.heroes = {}
  self.autoHide = false
  self.hideTimer = nil
end

local function DataDestroy(self)
  self.heroes = nil
  self.autoHide = nil
  self.hideTimer = nil
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function OnAddListener(self)
  base.OnAddListener(self)
  self:AddUIListener(EventId.AddExpFromScene, self.AddExpFromScene)
  self:AddUIListener(EventId.HeroLvUpSuccess, self.OnHeroLvUpSuccess)
end

local function OnRemoveListener(self)
  self:RemoveUIListener(EventId.AddExpFromScene, self.AddExpFromScene)
  self:RemoveUIListener(EventId.HeroLvUpSuccess, self.OnHeroLvUpSuccess)
  base.OnRemoveListener(self)
end

local function ReInit(self)
  self.heroes = {}
  for i = 1, ITEM_COUNT do
    self.itemList[i]:SetToAdd()
  end
end

local function Show(self, show)
  self.root_go:SetActive(show)
end

local function SetAutoHide(self, autoHide)
  self.autoHide = autoHide
  self:Show(not autoHide)
end

local function SetHeroes(self, heroes)
  self.heroes = heroes
  local maxHeroCount = DataCenter.BattleLevel:GetMaxHeroCount()
  for i = 1, ITEM_COUNT do
    if i <= #self.heroes then
      self.itemList[i]:SetHeroUuid(self.heroes[i])
    elseif i <= maxHeroCount then
      self.itemList[i]:SetToAdd()
    else
      self.itemList[i]:SetToLock()
    end
  end
end

local function LockEmptySlots(self)
  for i = 1, ITEM_COUNT do
    if i > #self.heroes then
      self.itemList[i]:SetToLock()
    end
  end
end

local function LockExtraSlots(self)
  local maxCount = DataCenter.BattleLevel:GetMaxHeroCount()
  for i = 1, ITEM_COUNT do
    if i > maxCount then
      self.itemList[i]:SetToLock()
    end
  end
end

local function AddExpFromScene(self, addExp)
  local eachExp = addExp // #self.heroes
  for i = 1, #self.heroes do
    self.itemList[i]:AddExpB(eachExp)
  end
end

local function OnHeroLvUpSuccess(self)
  self:SetHeroes(self.heroes)
end

local function OnPVEHeroExpFly(self, param)
  if param.info == nil then
    return
  end
  local item
  for _, v in ipairs(self.itemList) do
    if v.heroUuid == param.info.heroUuid then
      item = v
      break
    end
  end
  if item == nil then
    return
  end
  if self.autoHide then
    self:Show(true)
    if self.hideTimer ~= nil then
      self.hideTimer:Stop()
    end
  end
  
  local function FlyCallback()
    item:ShowExpGlow()
    TimerManager:GetInstance():DelayInvoke(function()
      item:RefreshExpA(param.info)
    end, 0.2)
    if self.autoHide then
      if self.hideTimer ~= nil then
        self.hideTimer:Stop()
      end
      self.hideTimer = TimerManager:GetInstance():DelayInvoke(function()
        if self.root_go ~= nil then
          self:Show(false)
          self.hideTimer = nil
        end
      end, 2)
    end
  end
  
  TimerManager:GetInstance():DelayInvoke(function()
    if item and item.bar_bg_image then
      local destPos = item.bar_bg_image.transform.position
      local model = "Assets/_Art/Effect/prefab/ui/Common/FlyPveHeroExp.prefab"
      UIUtil.DoFlyCustom(nil, nil, 1, param.pos, destPos, nil, nil, FlyCallback, model)
    end
  end, 0.2)
end

PVELevelHeroExpPanel.OnCreate = OnCreate
PVELevelHeroExpPanel.OnDestroy = OnDestroy
PVELevelHeroExpPanel.ComponentDefine = ComponentDefine
PVELevelHeroExpPanel.ComponentDestroy = ComponentDestroy
PVELevelHeroExpPanel.DataDefine = DataDefine
PVELevelHeroExpPanel.DataDestroy = DataDestroy
PVELevelHeroExpPanel.OnEnable = OnEnable
PVELevelHeroExpPanel.OnDisable = OnDisable
PVELevelHeroExpPanel.OnAddListener = OnAddListener
PVELevelHeroExpPanel.OnRemoveListener = OnRemoveListener
PVELevelHeroExpPanel.ReInit = ReInit
PVELevelHeroExpPanel.Show = Show
PVELevelHeroExpPanel.SetAutoHide = SetAutoHide
PVELevelHeroExpPanel.SetHeroes = SetHeroes
PVELevelHeroExpPanel.LockEmptySlots = LockEmptySlots
PVELevelHeroExpPanel.LockExtraSlots = LockExtraSlots
PVELevelHeroExpPanel.AddExpFromScene = AddExpFromScene
PVELevelHeroExpPanel.OnHeroLvUpSuccess = OnHeroLvUpSuccess
PVELevelHeroExpPanel.OnPVEHeroExpFly = OnPVEHeroExpFly
return PVELevelHeroExpPanel
