local TCStarListItemComponent = BaseClass("TCStarListItemComponent", UIBaseContainer)
local TCStarItemComponent = require("UI.LWUITCCardMain.Component.TCStarItemComponent")
local SINGLE_STAR_FRAG_COUNT = 5
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local t_c_star_item_path = "TCStarItem"

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
  self.starItem = self:AddComponent(UIBaseContainer, t_c_star_item_path)
  self.starItem.gameObject:GameObjectCreatePool()
  self.allStarItemList = {}
end

local function ComponentDestroy(self)
  self:RemoveComponents(TCStarItemComponent)
  self.starItem.gameObject:GameObjectRecycleAll()
  self.allStarItemList = nil
end

local function DataDefine(self)
end

local function DataDestroy(self)
end

local function OnAddListener(self)
  base.OnAddListener(self)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
end

function TCStarListItemComponent:ReInit(curStarVal, allStarVal)
  allStarVal = allStarVal or curStarVal
  local starSlotCount = math.ceil(allStarVal / SINGLE_STAR_FRAG_COUNT)
  local remainStarVal = curStarVal
  for i = 1, starSlotCount do
    local lightVal = Mathf.Clamp(remainStarVal, 0, SINGLE_STAR_FRAG_COUNT)
    remainStarVal = remainStarVal - lightVal
    if not self.allStarItemList[i] then
      local starObj = self.starItem.gameObject:GameObjectSpawn(self.transform)
      local name = tostring(i)
      starObj.name = name
      local star = self:AddComponent(TCStarItemComponent, name)
      self.allStarItemList[i] = star
    else
      self.allStarItemList[i]:SetActive(true)
    end
    local star = self.allStarItemList[i]
    star:ReInit(lightVal)
  end
  if starSlotCount < #self.allStarItemList then
    for i = starSlotCount + 1, #self.allStarItemList do
      self.allStarItemList[i]:SetActive(false)
    end
  end
end

function TCStarListItemComponent:ClearLightCount()
  for i = 1, #self.allStarItemList do
    self.allStarItemList[i]:ClearLightCount()
  end
end

TCStarListItemComponent.OnCreate = OnCreate
TCStarListItemComponent.OnDestroy = OnDestroy
TCStarListItemComponent.OnEnable = OnEnable
TCStarListItemComponent.OnDisable = OnDisable
TCStarListItemComponent.ComponentDefine = ComponentDefine
TCStarListItemComponent.ComponentDestroy = ComponentDestroy
TCStarListItemComponent.DataDefine = DataDefine
TCStarListItemComponent.DataDestroy = DataDestroy
TCStarListItemComponent.OnAddListener = OnAddListener
TCStarListItemComponent.OnRemoveListener = OnRemoveListener
return TCStarListItemComponent
