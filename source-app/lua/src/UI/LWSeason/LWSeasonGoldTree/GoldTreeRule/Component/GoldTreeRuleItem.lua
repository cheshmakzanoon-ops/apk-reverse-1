local base = UIBaseContainer
local GoldTreeRuleItem = BaseClass("GoldTreeRuleItem", base)
local Localization = CS.GameEntry.Localization
local GoldTreeRuleCardItem = require("UI.LWSeason.LWSeasonGoldTree.GoldTreeRule.Component.GoldTreeRuleCardItem")
local title_path = "title"
local desc_path = "desc"
local content_path = "content"
local item_path = "content/GoldTreeRuleCardItem"
local contentReward_path = "RewardScroll/Viewport/Content"
local element_path = ""
local DefaultDescHeight = 48
local DefaultMinHeight = 480

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
  self.title = self:AddComponent(UIText, title_path)
  self.desc = self:AddComponent(UIText, desc_path)
  self.content = self:AddComponent(UIBaseContainer, content_path)
  self.item = self:AddComponent(UIBaseContainer, item_path)
  self.contentReward = self:AddComponent(UIBaseContainer, contentReward_path)
  self.layoutElement = self:AddComponent(UILayoutElement, "")
  self.cardObject = self.item.gameObject
  self.cardObject:GameObjectCreatePool()
  self.cardObject:SetActive(false)
end

local function ComponentDestroy(self)
  self:ClearRewardItems()
  self.content:RemoveComponents(GoldTreeRuleCardItem)
  self.cardObject:GameObjectRecycleAll()
  self.title = nil
  self.desc = nil
  self.content = nil
  self.item = nil
  self.contentReward = nil
  self.element = nil
end

local function DataDefine(self)
end

local function DataDestroy(self)
end

function GoldTreeRuleItem:ClearRewardItems()
  self.contentReward:RemoveComponents(UICommonResItem)
  if self.rewardItems then
    for k, v in pairs(self.rewardItems) do
      if v then
        self:GameObjectDestroy(v)
      end
    end
  end
end

function GoldTreeRuleItem:ReInit(combineConfig)
  if not combineConfig then
    self:SetActive(false)
    return
  end
  self.title:SetLocalText(combineConfig.help_name)
  self.desc:SetText(string.format([[
%s
%s]], Localization:GetString(combineConfig.desc), Localization:GetString(combineConfig.desc_help)))
  local preferredValues = self.desc.unity_tmpro:GetPreferredValues()
  if preferredValues.y > DefaultDescHeight then
    self.layoutElement:SetMinHeight(DefaultMinHeight + preferredValues.y - DefaultDescHeight)
  else
    self.layoutElement:SetMinHeight(DefaultMinHeight)
  end
  local list = combineConfig:GetCardDisplayList()
  self.content:RemoveComponents(GoldTreeRuleCardItem)
  self.cardObject:GameObjectRecycleAll()
  if list then
    local max = #list
    local trans = self.content.transform
    for i, v in ipairs(list) do
      local theItem = self.cardObject:GameObjectSpawn(trans)
      theItem.name = string.format("cardItem_%d", i)
      theItem:SetActive(true)
      theItem = self.content:AddComponent(GoldTreeRuleCardItem, theItem.name)
      theItem:ReInit(v, i, max)
    end
  end
  self:ClearRewardItems()
  self.rewardItems = {}
  local rewardList = combineConfig:GetRewardList()
  if rewardList then
    local contentTrans = self.contentReward.transform
    for i, v in ipairs(rewardList) do
      self.rewardItems[i] = self:GameObjectInstantiateAsync(UIAssets.UICommonResItem, function(request)
        if request.isError then
          return
        end
        local go = request.gameObject
        local trans = go.transform
        trans:SetParent(contentTrans)
        trans:Set_localScale(1, 1, 1)
        trans:Set_sizeDelta(100, 100)
        trans.pivot = Vector2.New(0.5, 0.5)
        go.name = "item" .. i
        local cell = self.contentReward:AddComponent(UICommonResItem, go.name)
        cell:ReInit(rewardList[i])
      end)
    end
  end
end

GoldTreeRuleItem.OnCreate = OnCreate
GoldTreeRuleItem.OnDestroy = OnDestroy
GoldTreeRuleItem.OnEnable = OnEnable
GoldTreeRuleItem.OnDisable = OnDisable
GoldTreeRuleItem.ComponentDefine = ComponentDefine
GoldTreeRuleItem.ComponentDestroy = ComponentDestroy
GoldTreeRuleItem.DataDefine = DataDefine
GoldTreeRuleItem.DataDestroy = DataDestroy
return GoldTreeRuleItem
