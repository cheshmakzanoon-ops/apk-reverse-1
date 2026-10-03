local TacticalChipStarDetailSystemPanel = BaseClass("TacticalChipStarDetailSystemPanel", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local TacticalChipStarDetailSystemItem = require("UI.UILWTacticalWeaponChip.StarDetail.Component.TacticalChipStarDetailSystemItem")
local ADD_NUM_PATH_FORMAT = "Assets/Main/Sprites/UI/LWUITacticalWeaponChip/FX_wurenjixingpian_shuzi+%s.png"

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
  self.compContent = self:AddComponent(UIBaseContainer, "ScrollView/ViewPort/content")
  self.textTitle = self:AddComponent(UIText, "title")
  self.textTitle:SetLocalText("battlesystem_chip_preview_desc1")
  self.imgAddNumIcon = self:AddComponent(UIImage, "addNumIcon")
  self.textDesc = self:AddComponent(UIText, "desc")
  self.compScrollView = self:AddComponent(UIBaseContainer, "ScrollView")
  self.textEmptyDesc = self:AddComponent(UIText, "emptyDesc")
  self.textEmptyDesc:SetLocalText("")
  self.compContentLayout = self:AddComponent(UIHorizontalOrVerticalLayoutGroup, "ScrollView/ViewPort/content")
end

local function ComponentDestroy(self)
  self.compContent = nil
  self.textTitle = nil
  self.imgAddNumIcon = nil
  self.textDesc = nil
  self.compScrollView = nil
  self.textEmptyDesc = nil
  self.compContentLayout = nil
end

local function DataDefine(self)
  self.itemCount = 0
end

local function DataDestroy(self)
  self.itemCount = nil
  self.init = nil
  self.compContent:RemoveComponents(TacticalChipStarDetailSystemItem)
end

local function OnAddListener(self)
  base.OnAddListener(self)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
end

function TacticalChipStarDetailSystemPanel:ReInit(chipId, chipStar, customTierSystemLv)
  self.chipId = chipId
  self.chipStar = chipStar
  self.customTierSystemLevel = customTierSystemLv
  local chipTemplate = DataCenter.TWSkillChipTemplateManager:GetTemplate(chipId)
  local curSystemLevel = DataCenter.TacticalChipManager:GetLevel()
  if self.customTierSystemLevel and self.customTierSystemLevel > 0 then
    curSystemLevel = self.customTierSystemLevel
  end
  local systemLevelTemplate = DataCenter.TacticalChipManager:GetLevelTemplate(curSystemLevel)
  local curSystemTierTemplate = DataCenter.TacticalChipManager:GetTierTemplate(systemLevelTemplate.system_tier)
  local isMaxTier = DataCenter.TacticalChipManager:IsMaxTier(systemLevelTemplate.system_tier)
  self.imgAddNumIcon:LoadSprite(string.format(ADD_NUM_PATH_FORMAT, DataCenter.TacticalChipManager:GetSystemTierEffectValue()))
  if isMaxTier then
    self.textDesc:SetLocalText("battlesystem_chip_preview_desc3")
  else
    local nextTierTemplate = DataCenter.TacticalChipManager:GetTierTemplate(systemLevelTemplate.system_tier + 1)
    self.textDesc:SetLocalText("battlesystem_chip_preview_desc2", nextTierTemplate.tier_level)
  end
  self.compScrollView:SetActive(chipTemplate.quality >= 4)
  self.textEmptyDesc:SetActive(chipTemplate.quality < 4)
  if chipTemplate.quality < 4 then
    return
  end
  if self.init == true then
    return
  end
  self.init = true
  self:CreateList()
end

function TacticalChipStarDetailSystemPanel:CreateList()
  local tierEffectValueList = DataCenter.TacticalChipManager:GetTierEffectValueList()
  if tierEffectValueList == nil then
    return
  end
  self.systemList = tierEffectValueList
  for i = 1, #tierEffectValueList do
    local effectValue = tierEffectValueList[i]
    self:CreateItem(i, effectValue)
  end
end

function TacticalChipStarDetailSystemPanel:CreateItem(i, effectValue)
  self:GameObjectInstantiateAsync("Assets/Main/Prefabs/UI/LWUITacticalWeapon/ChipV2/TacticalChipStarDetailSystemItem.prefab", function(request)
    if IsNull(request.gameObject) then
      return
    end
    local go = request.gameObject
    local transform = go.transform
    go.gameObject:SetActive(true)
    transform:SetParent(self.compContent.transform)
    transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
    go.name = i
    local cell = self.compContent:AddComponent(TacticalChipStarDetailSystemItem, go)
    cell:SetData(i, effectValue, self.chipId, #self.systemList)
    local curSystemLevel = DataCenter.TacticalChipManager:GetLevel()
    if self.customTierSystemLevel and self.customTierSystemLevel > 0 then
      curSystemLevel = self.customTierSystemLevel
    end
    if DataCenter.TacticalChipManager:GetSystemTierEffectValue() == effectValue then
      self.curShowIndex = i
    end
    self.itemCount = self.itemCount + 1
    if self.systemList and self.itemCount == #self.systemList then
      self.compContent:SetSizeDeltaXY(0, 1 + cell:GetSizeDelta().y * #self.systemList)
      local height = cell:GetSizeDelta().y * self.curShowIndex + self.compContentLayout:GetSpacing() * (self.curShowIndex - 1)
      if height > self.compScrollView:GetSizeDelta().y then
        local delta = height - self.compScrollView:GetSizeDelta().y
        self.compContent:SetAnchoredPositionXY(0, delta)
      else
        self.compContent:SetAnchoredPositionXY(0, 0)
      end
    end
  end)
end

TacticalChipStarDetailSystemPanel.OnCreate = OnCreate
TacticalChipStarDetailSystemPanel.OnDestroy = OnDestroy
TacticalChipStarDetailSystemPanel.OnEnable = OnEnable
TacticalChipStarDetailSystemPanel.OnDisable = OnDisable
TacticalChipStarDetailSystemPanel.ComponentDefine = ComponentDefine
TacticalChipStarDetailSystemPanel.ComponentDestroy = ComponentDestroy
TacticalChipStarDetailSystemPanel.DataDefine = DataDefine
TacticalChipStarDetailSystemPanel.DataDestroy = DataDestroy
TacticalChipStarDetailSystemPanel.OnAddListener = OnAddListener
TacticalChipStarDetailSystemPanel.OnRemoveListener = OnRemoveListener
return TacticalChipStarDetailSystemPanel
