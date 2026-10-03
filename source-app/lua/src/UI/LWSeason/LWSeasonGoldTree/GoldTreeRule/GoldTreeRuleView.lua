local base = UIBaseView
local GoldTreeRule = BaseClass("GoldTreeRule", base)
local GoldTreeRuleItem = require("UI.LWSeason.LWSeasonGoldTree.GoldTreeRule.Component.GoldTreeRuleItem")
local btnBack_path = "panel"
local btnClose_path = "PopUpTitle/CloseBtn"
local desc_path = "PopUpTitle/Common_bg_orange2/ScrollView/Viewport/Content/desc"
local content_path = "PopUpTitle/Common_bg_orange2/ScrollView/Viewport/Content"
local ruleItem_path = "PopUpTitle/Common_bg_orange2/ScrollView/Viewport/Content/GoldTreeRuleItem"
local scroll_path = "PopUpTitle/Common_bg_orange2/ScrollView"

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
  self.btnBack = self:AddComponent(UIButton, btnBack_path)
  self.btnClose = self:AddComponent(UIButton, btnClose_path)
  self.desc = self:AddComponent(UIText, desc_path)
  self.content = self:AddComponent(UIBaseContainer, content_path)
  self.ruleItem = self:AddComponent(UIBaseContainer, ruleItem_path)
  self.scroll = self:AddComponent(UIScrollRect, scroll_path)
  self.btnBack:SetOnClick(BindCallback(self.ctrl, self.ctrl.CloseSelf))
  self.btnClose:SetOnClick(BindCallback(self.ctrl, self.ctrl.CloseSelf))
  self.ruleObject = self.ruleItem.gameObject
  self.ruleObject:GameObjectCreatePool()
  self.ruleObject:SetActive(false)
  self:RefreshView()
end

local function ComponentDestroy(self)
  self.content:RemoveComponents(GoldTreeRuleItem)
  self.ruleObject:GameObjectRecycleAll()
  self.btnBack = nil
  self.btnClose = nil
  self.desc = nil
  self.content = nil
  self.ruleItem = nil
  self.scroll = nil
end

local function DataDefine(self)
end

local function DataDestroy(self)
end

function GoldTreeRule:RefreshView()
  local descKey = DataCenter.SeasonGoldTreeTemplateManager:GetGoldTreeTemp("help") or "season_s4_golden_tree_UI_42"
  self.desc:SetLocalText(descKey)
  local list = DataCenter.SeasonGoldTreeTemplateManager:GetCardCombinationsList()
  self.content:RemoveComponents(GoldTreeRuleItem)
  self.ruleObject:GameObjectRecycleAll()
  if not list then
    return
  end
  local trans = self.content.transform
  self.items = {}
  for i, v in ipairs(list) do
    local theItem = self.ruleObject:GameObjectSpawn(trans)
    theItem.name = string.format("ruleItem_%d", i)
    theItem:SetActive(true)
    theItem = self.content:AddComponent(GoldTreeRuleItem, theItem.name)
    theItem:ReInit(v)
    self.items[i] = theItem
  end
  TimerManager:GetInstance():DelayInvoke(function()
    self:JumpTo(self:GetUserData(), list)
  end, 0.1)
end

function GoldTreeRule:JumpTo(combinationId, list)
  if not combinationId then
    return
  end
  list = list or DataCenter.SeasonGoldTreeTemplateManager:GetCardCombinationsList()
  if not list then
    return
  end
  local max, jumpIndex, jumpItem = #list
  for i, v in ipairs(list) do
    if v.id == combinationId then
      jumpIndex = i
      jumpItem = self.items[i]
      break
    end
  end
  if jumpIndex then
    local contentH = self.content.rectTransform.rect.height
    local scrollH = self.scroll.rectTransform.rect.height
    local minContentPosY = 0
    if contentH > scrollH then
      minContentPosY = contentH - scrollH
    end
    local _, itemH = jumpItem:GetSizeDeltaXY()
    local itemAnchoredPosY = jumpItem:GetAnchoredPositionY()
    local jumpPos = -(itemAnchoredPosY + 0.5 * itemH)
    if minContentPosY < jumpPos then
      jumpPos = minContentPosY
    end
    self.content:SetAnchoredPositionXY(0, jumpPos)
  end
end

GoldTreeRule.OnCreate = OnCreate
GoldTreeRule.OnDestroy = OnDestroy
GoldTreeRule.OnEnable = OnEnable
GoldTreeRule.OnDisable = OnDisable
GoldTreeRule.ComponentDefine = ComponentDefine
GoldTreeRule.ComponentDestroy = ComponentDestroy
GoldTreeRule.DataDefine = DataDefine
GoldTreeRule.DataDestroy = DataDestroy
return GoldTreeRule
