local base = UIBaseContainer
local GroupDetailLine1 = BaseClass("GroupDetailLine1", base)
local UIHeroSkillItem = require("UI.UILWHero.UIHeroDetailPanel.Component.UIHeroSkillItem")
local BaseUIEquipItem = require("UI.UILWHero.UIHeroEquipListPanel.Component.BaseUIEquipItem")
local UIHeroCellSmall = require("UI.UIHero2.Common.UIHeroCellSmall")
local MailScoutReportConst = require("DataCenter.MailData.DataExtModule.MailScoutReportConst")

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

local function OnDestroy(self)
  self:DestroyAllCells()
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function ComponentDefine(self)
  self.heroContainer = self:AddComponent(UIBaseContainer, "hero")
  self.cellContainers = {}
  for i = 1, 4 do
    local path = string.format("cells/cell%s", i)
    local cell = self:AddComponent(UIBaseContainer, path)
    self.cellContainers[i] = cell
  end
  self.bottomLine = self:AddComponent(UIBaseContainer, "bottomLine")
end

local function ComponentDestroy(self)
  self.item = nil
  self.probab_txt = nil
  self.price_txt = nil
  self.itemIcon_img = nil
end

local function DataDefine(self)
  self.cellReqs = {}
end

local function DataDestroy(self)
end

local EQUIPITEM_SIZE = {
  [1] = 170,
  [2] = 170
}
local SKILLITEM_SIZE = {
  [1] = 132,
  [2] = 160
}
local EQUIPITEM_SCALE = 1
local SKILLITEM_SCALE = 1.2
local EQUIPITEM_POS = {
  [1] = 0,
  [2] = 0
}
local SKILLITEM_POS = {
  [1] = 0,
  [2] = -8
}

local function GetPrefabConfig(type)
  if type == 1 then
    return UIAssets.EquipItem, BaseUIEquipItem, EQUIPITEM_SIZE, EQUIPITEM_SCALE, EQUIPITEM_POS
  elseif type == 2 then
    return UIAssets.UIHeroSkillItem, UIHeroSkillItem, SKILLITEM_SIZE, SKILLITEM_SCALE, SKILLITEM_POS
  end
end

local function DestroyAllCells(self)
  self:RemoveComponents(UIHeroSkillItem)
  self:RemoveComponents(BaseUIEquipItem)
  self:RemoveComponents(UIHeroCellSmall)
  self:RemoveComponents(UICommonResItem)
  if self.heroCellReq then
    self:GameObjectDestroy(self.heroCellReq)
    self.heroCellReq = nil
  end
  if self.cellReqs then
    for _, req in pairs(self.cellReqs) do
      self:GameObjectDestroy(req)
    end
    self.cellReqs = {}
  end
end

local function SetData(self, groupData)
  DestroyAllCells(self)
  if groupData == nil then
    return
  end
  local heroData = groupData.heroData
  local heroReq = self:GameObjectInstantiateAsync(UIAssets.UIHeroCellSmall, function(req)
    local obj = req.gameObject
    if IsNull(obj) then
      return
    end
    obj:SetActive(true)
    local transform = obj.transform
    transform:SetParent(self.heroContainer.transform)
    transform:Set_pivot(0.5, 0.5)
    transform:Set_localScale(1, 1, 1)
    transform:Set_sizeDelta(100, 100)
    transform:Set_localPosition(0, 0, 0)
    local name = "hero"
    obj.name = name
    local fullPath = string.format("hero/%s", name)
    local cell = self:AddComponent(UIHeroCellSmall, fullPath)
    local awakenLv = heroData.awakenLv and heroData.awakenLv.value or 0
    local heroSkinId = heroData.heroSkinId and heroData.heroSkinId.value or 0
    cell:InitWithConfigId(heroData.heroId.value, nil, heroData.heroLevel.value, heroData.heroRankLevel.value, heroData.weaponLevel.value, awakenLv, heroSkinId)
  end)
  self.heroCellReq = heroReq
  local type = groupData.type
  local prefabPath, cls, size, scale, posOffset = GetPrefabConfig(type)
  local lineDatas = groupData.lineDatas
  local isHide = groupData.isHide
  if isHide then
    prefabPath = UIAssets.UICommonResItem
    cls = UICommonResItem
    size = {
      [1] = 150,
      [2] = 150
    }
    scale = 1.42
    posOffset = {
      [1] = 0,
      [2] = 0
    }
  end
  for i = 1, 4 do
    if type ~= 2 or lineDatas[i] then
      local lineData = lineDatas[i]
      local cellReq = self:GameObjectInstantiateAsync(prefabPath, function(req)
        local obj = req.gameObject
        if IsNull(obj) then
          return
        end
        obj:SetActive(true)
        local transform = obj.transform
        transform:SetParent(self.cellContainers[i].transform)
        transform:Set_pivot(0.5, 0.5)
        transform:Set_localScale(scale, scale, scale)
        transform:Set_sizeDelta(size[1], size[2])
        transform:Set_localPosition(posOffset[1], posOffset[2], 0)
        local name = string.format("item%s", i)
        obj.name = name
        local fullPath = string.format("cells/cell%s/%s", i, name)
        local cell = self:AddComponent(cls, fullPath)
        if isHide then
          cell:ReInit(MailScoutReportConst.questionmark_config)
        elseif type == 1 then
          if not lineData then
            cell:ShowSlot(i)
          else
            cell:SetTemplateData(lineData.equipId, nil, false, true, lineData.equipLv, lineData.promote)
          end
        elseif type == 2 then
          local showParam = {
            showSkillName = false,
            showLock = false,
            showRedPoint = false,
            showStar = true
          }
          cell:SetData(lineData, showParam, nil)
        end
      end)
      self.cellReqs[i] = cellReq
    end
  end
end

local function SetBottomLineActive(self, active)
  self.bottomLine:SetActive(active)
end

GroupDetailLine1.OnCreate = OnCreate
GroupDetailLine1.OnDestroy = OnDestroy
GroupDetailLine1.OnEnable = OnEnable
GroupDetailLine1.OnDisable = OnDisable
GroupDetailLine1.ComponentDefine = ComponentDefine
GroupDetailLine1.ComponentDestroy = ComponentDestroy
GroupDetailLine1.DataDefine = DataDefine
GroupDetailLine1.DataDestroy = DataDestroy
GroupDetailLine1.SetData = SetData
GroupDetailLine1.DestroyAllCells = DestroyAllCells
GroupDetailLine1.SetBottomLineActive = SetBottomLineActive
return GroupDetailLine1
