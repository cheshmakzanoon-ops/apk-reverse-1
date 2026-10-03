local UITWSkillChipGroupItem = BaseClass("UITWSkillChipGroupItem", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local Resource = CS.GameEntry.Resource
local UIGray = CS.UIGray
local SkillChipItem = require("UI.UILWTacticalWeapon.Component.SkillChipPage.SkillChipItem")
local TacticalWeaponUtils = require("DataCenter.TacticalWeapon.TacticalWeaponManager.TacticalWeaponUtils")
local type_icon_path = "BaseInfo/TypeIcon"
local type_text_path = "BaseInfo/TypeText"
local chips_path = "Chips"

local function OnCreate(self)
  base.OnCreate(self)
  self:DataDefine()
  self:ComponentDefine()
end

local function ClearChips(self)
  if self.chipReqs then
    self.chipsContainer:RemoveComponents(SkillChipItem)
    for i, v in pairs(self.chipReqs) do
      self:GameObjectDestroy(v)
    end
    self.chipReqs = {}
  end
end

local function OnDestroy(self)
  ClearChips(self)
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

local function DataDefine(self)
end

local function DataDestroy(self)
  self.onChildExpandFinish = nil
end

local function OnEnable(self)
  base.OnEnable(self)
  self.active = true
end

local function OnDisable(self)
  base.OnDisable(self)
  self.active = false
end

local function ComponentDefine(self)
  self.type_icon = self:AddComponent(UIImage, type_icon_path)
  self.type_text = self:AddComponent(UIText, type_text_path)
  self.chipsContainer = self:AddComponent(UIBaseContainer, chips_path)
end

local function ComponentDestroy(self)
end

local function SetOnChildExpandFinish(self, callback)
  self.onChildExpandFinish = callback
end

local function SetData(self, data, index)
  local type = data.type
  self.type_icon:LoadSprite(TacticalWeaponUtils.GetSkillChipTypeIcon(type))
  self.type_text:SetText(TacticalWeaponUtils.GetSkillChipTypeText(type))
  ClearChips(self)
  self.createCount = 0
  self.index = index
  local templateCount = #data.templates
  for i, v in pairs(data.templates) do
    local chipReq = self:GameObjectInstantiateAsync(UIAssets.UILWTWSkillChipItem, function(request)
      if request.isError then
        return
      end
      local go = request.gameObject
      go.transform:SetParent(self.chipsContainer.transform)
      go.transform:Set_localScale(0.72, 0.72, 0.72)
      go.name = "item" .. i
      local cell = self.chipsContainer:AddComponent(SkillChipItem, go.name)
      cell:SetTemplate(v.id, v.maxLevel, v.maxStar)
      self.createCount = self.createCount + 1
      CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.transform)
      if self.createCount == templateCount and self.onChildExpandFinish then
        self.onChildExpandFinish(self.index)
      end
    end)
    if not self.chipReqs then
      self.chipReqs = {}
    end
    table.insert(self.chipReqs, chipReq)
  end
end

UITWSkillChipGroupItem.OnCreate = OnCreate
UITWSkillChipGroupItem.OnDestroy = OnDestroy
UITWSkillChipGroupItem.OnEnable = OnEnable
UITWSkillChipGroupItem.OnDisable = OnDisable
UITWSkillChipGroupItem.DataDefine = DataDefine
UITWSkillChipGroupItem.DataDestroy = DataDestroy
UITWSkillChipGroupItem.ComponentDefine = ComponentDefine
UITWSkillChipGroupItem.ComponentDestroy = ComponentDestroy
UITWSkillChipGroupItem.SetData = SetData
UITWSkillChipGroupItem.SetOnChildExpandFinish = SetOnChildExpandFinish
return UITWSkillChipGroupItem
