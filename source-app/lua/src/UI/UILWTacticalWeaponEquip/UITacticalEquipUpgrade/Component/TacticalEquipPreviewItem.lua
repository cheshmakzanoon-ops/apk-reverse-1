local TacticalEquipPreviewItem = BaseClass("TacticalEquipPreviewItem", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local TacticalEquipStaticAttriItem = require("UI.UILWTacticalWeaponEquip.UITacticalEquipUpgrade.Component.TacticalEquipStaticAttriItem")

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
  self.compBg = self:AddComponent(UIBaseContainer, "bg")
  self.compCurLevelBg = self:AddComponent(UIBaseContainer, "curLevelBg")
  self.compResItem = self:AddComponent(UICommonResItem, "resItem")
  self.textTitle = self:AddComponent(UITextMeshProUGUIEx, "layout/title")
  self.compAttributeNode = self:AddComponent(UIBaseContainer, "layout/AttributeNode")
  self.compCurLevelFlag = self:AddComponent(UIBaseContainer, "curLevelFlag")
  self.textLevel = self:AddComponent(UITextMeshProUGUIEx, "level")
end

local function ComponentDestroy(self)
  self.compAttributeNode:RemoveComponents(TacticalEquipStaticAttriItem)
  self.compBg = nil
  self.compCurLevelBg = nil
  self.compResItem = nil
  self.textTitle = nil
  self.compAttributeNode = nil
  self.compCurLevelFlag = nil
  self.textLevel = nil
end

local function DataDefine(self)
  self.attributeReqs = {}
end

local function DataDestroy(self)
  for i, v in ipairs(self.attributeReqs) do
    if v then
      v:Destroy()
    end
  end
end

function TacticalEquipPreviewItem:SetData(curConfigId, config)
  self.config = config
  self.compBg:SetActive(curConfigId ~= config.id)
  self.compCurLevelBg:SetActive(curConfigId == config.id)
  self.compCurLevelFlag:SetActive(curConfigId == config.id)
  self.compAttributeNode:RemoveComponents(TacticalEquipStaticAttriItem)
  for i, v in ipairs(self.attributeReqs) do
    if v then
      v:Destroy()
    end
  end
  local effectList = DataCenter.CommonEquipDataManager:GetAttributePairsDataList(config.baseEffect)
  for i, v in ipairs(effectList) do
    table.insert(self.attributeReqs, self:CreateAttributeItem(v, i))
  end
  self:RefreshEquipItem()
  self:RefreshTitle(curConfigId)
end

function TacticalEquipPreviewItem:RefreshTitle(curConfigId)
  if curConfigId == nil then
    self.textTitle:SetActive(false)
    return
  end
  local curConfig = DataCenter.CommonEquipTemplateManager:GetTemplate(curConfigId)
  if curConfig and curConfig.upgrade_switch == 1 then
    self.textTitle:SetLocalText("squad_equip_preview_desc_3", self.config.growth_value)
    self.textTitle:SetActive(true)
  else
    self.textTitle:SetActive(false)
  end
end

function TacticalEquipPreviewItem:RefreshEquipItem()
  local param = UICommonResItem.Param.New()
  param.rewardType = RewardType.CommonEquip
  param.itemId = self.config.id
  param.count = 1
  param.enableClick = false
  self.compResItem:ReInit(param)
  self.compResItem:SetActive(true)
  self.compResItem:SetItemCountActive(false)
  self.compResItem:SetFlagActive(false)
  if self.config then
    self.textLevel:SetText(string.format("Lv.%d", self.config.level))
  end
end

function TacticalEquipPreviewItem:CreateAttributeItem(data, index)
  return self:GameObjectInstantiateAsync(UIAssets.TacticalEquipStaticAttriItem, function(request)
    if request.isError then
      return
    end
    local go = request.gameObject
    go.transform:SetParent(self.compAttributeNode.transform)
    go.transform:Set_localScale(1, 1, 1)
    go:SetActive(true)
    local name = "attribute_" .. tostring(index)
    go.name = name
    local cell = self.compAttributeNode:AddComponent(TacticalEquipStaticAttriItem, name)
    data.index = index
    cell:SetData(data)
  end)
end

TacticalEquipPreviewItem.OnCreate = OnCreate
TacticalEquipPreviewItem.OnDestroy = OnDestroy
TacticalEquipPreviewItem.OnEnable = OnEnable
TacticalEquipPreviewItem.OnDisable = OnDisable
TacticalEquipPreviewItem.ComponentDefine = ComponentDefine
TacticalEquipPreviewItem.ComponentDestroy = ComponentDestroy
TacticalEquipPreviewItem.DataDefine = DataDefine
TacticalEquipPreviewItem.DataDestroy = DataDestroy
return TacticalEquipPreviewItem
