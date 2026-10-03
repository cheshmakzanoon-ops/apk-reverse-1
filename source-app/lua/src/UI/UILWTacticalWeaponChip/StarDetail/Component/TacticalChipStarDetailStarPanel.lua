local TacticalChipStarDetailStarPanel = BaseClass("TacticalChipStarDetailStarPanel", UIBaseContainer)
local TacticalChipStarDetailItem = require("UI.UILWTacticalWeaponChip.StarDetail.Component.TacticalChipStarDetailItem")
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local YELLOW_INDICES = {
  [2] = true,
  [5] = true,
  [8] = true
}

function TacticalChipStarDetailStarPanel:GetLineBgType(index, activeState)
  if activeState then
    if YELLOW_INDICES[index] then
      return 2
    else
      return 1
    end
  elseif YELLOW_INDICES[index] then
    return 4
  else
    return 3
  end
end

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
end

local function ComponentDestroy(self)
  self.compContent = nil
end

local function DataDefine(self)
end

local function DataDestroy(self)
  self.init = nil
  self.compContent:RemoveComponents(TacticalChipStarDetailItem)
end

local function OnAddListener(self)
  base.OnAddListener(self)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
end

function TacticalChipStarDetailStarPanel:ReInit(chipId, chipStar)
  self.chipId = chipId
  self.chipStar = chipStar
  if self.init == true then
    return
  end
  self.init = true
  self:CreateLines()
end

function TacticalChipStarDetailStarPanel:CreateLines()
  local skillChipTemplate = DataCenter.TWSkillChipTemplateManager:GetTemplate(self.chipId)
  if not skillChipTemplate then
    return
  end
  local skillInfo = skillChipTemplate:GetSkillInfoByStarLevel(self.chipStar)
  local effects = skillInfo:GetEffectsDescTWSkillChip()
  for i = 1, #effects do
    local effect = effects[i]
    self:CreateItem(i, effect)
  end
end

function TacticalChipStarDetailStarPanel:CreateItem(i, data)
  self:GameObjectInstantiateAsync("Assets/Main/Prefabs/UI/LWUITacticalWeapon/ChipV2/TacticalChipStarDetailItem.prefab", function(request)
    if IsNull(request.gameObject) then
      return
    end
    local go = request.gameObject
    local transform = go.transform
    go.gameObject:SetActive(true)
    transform:SetParent(self.compContent.transform)
    transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
    go.name = i
    local cell = self.compContent:AddComponent(TacticalChipStarDetailItem, go)
    cell:SetData(data.outDesc, i, self:GetLineBgType(i, data.isUnlock))
  end)
end

TacticalChipStarDetailStarPanel.OnCreate = OnCreate
TacticalChipStarDetailStarPanel.OnDestroy = OnDestroy
TacticalChipStarDetailStarPanel.OnEnable = OnEnable
TacticalChipStarDetailStarPanel.OnDisable = OnDisable
TacticalChipStarDetailStarPanel.ComponentDefine = ComponentDefine
TacticalChipStarDetailStarPanel.ComponentDestroy = ComponentDestroy
TacticalChipStarDetailStarPanel.DataDefine = DataDefine
TacticalChipStarDetailStarPanel.DataDestroy = DataDestroy
TacticalChipStarDetailStarPanel.OnAddListener = OnAddListener
TacticalChipStarDetailStarPanel.OnRemoveListener = OnRemoveListener
return TacticalChipStarDetailStarPanel
