local base = UIBaseContainer
local UILWUniversalItem = BaseClass("UILWUniversalItem", base)
local TacticalChipItem = require("UI.UILWTacticalWeaponChip.Component.TacticalChipItem")
local BaseUIEquipItem = require("UI.UILWHero.UIHeroEquipListPanel.Component.BaseUIEquipItem")
local commonresitem_path = "UICommonResItem"
local skillchipitem_path = "TacticalChipItem"
local heroequipitem_path = "EquipItem"

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
  base.OnDisable(self)
end

local function ComponentDefine(self)
  self.commonresitem = self:AddComponent(UICommonResItem, commonresitem_path)
  self.skillchipitem = self:AddComponent(TacticalChipItem, skillchipitem_path)
  self.heroequipitem = self:AddComponent(BaseUIEquipItem, heroequipitem_path)
  self.items = {
    self.commonresitem,
    self.skillchipitem,
    self.heroequipitem
  }
end

local function ComponentDestroy(self)
  self.commonresitem = nil
  self.skillchipitem = nil
  self.heroequipitem = nil
end

local function DataDefine(self)
end

local function DataDestroy(self)
end

local function ReInit(self, data)
  local showItem
  if data and data.rewardType then
    if data.rewardType == RewardType.TWSkillChip then
      self.skillchipitem:SetTemplate(data.itemId, data.star)
      self.skillchipitem:SetPivotMiddle()
      self.skillchipitem:SetLocalPositionXYZ(0, 0, 0)
      self.skillchipitem:SetChipTypeVisible(true)
      showItem = self.skillchipitem
    else
      self.commonresitem:ReInit(data)
      showItem = self.commonresitem
    end
  end
  for i = 1, #self.items do
    if self.items[i] ~= showItem then
      self.items[i]:SetActive(false)
    else
      self.items[i]:SetActive(true)
    end
  end
end

UILWUniversalItem.OnCreate = OnCreate
UILWUniversalItem.OnDestroy = OnDestroy
UILWUniversalItem.OnEnable = OnEnable
UILWUniversalItem.OnDisable = OnDisable
UILWUniversalItem.ComponentDefine = ComponentDefine
UILWUniversalItem.ComponentDestroy = ComponentDestroy
UILWUniversalItem.DataDefine = DataDefine
UILWUniversalItem.DataDestroy = DataDestroy
UILWUniversalItem.ReInit = ReInit
return UILWUniversalItem
