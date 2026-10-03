local TCStarItemComponent = BaseClass("TCStarItemComponent", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local star_frag_group_path = "NotFullroot/StarFragGroup"
local star_frag_path = "NotFullroot/StarFragGroup/StarFrag%s"
local full_star_path = "FullStar"

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
  self.starGroup = self:AddComponent(UIBaseContainer, star_frag_group_path)
  local fragCount = self.starGroup.transform.childCount
  self.allStarList = {}
  for i = 1, fragCount do
    local star = self:AddComponent(UIBaseContainer, string.format(star_frag_path, i))
    self.allStarList[i] = star
    if CommonUtil.IsArabicAutoMirrorOpen() then
      star:SetLocalScaleXYZ(-1, 1, 1)
    else
      star:SetLocalScaleXYZ(1, 1, 1)
    end
  end
  self.fullLight = self:AddComponent(UIBaseContainer, full_star_path)
  local effectParam = {}
  effectParam.lifeType = UIVfxLifeType.DestroyAfterOnce
  effectParam.duration = 1.2
  self.vfx_starUpgrade = self:AddComponent(UIVfx, "NotFullroot/vfx_starUpgrade", VfxAssets.TCCardStarUpgradeVfx, effectParam)
end

local function ComponentDestroy(self)
  self.allStarList = nil
end

local function DataDefine(self)
end

local function DataDestroy(self)
  self.lightCount = nil
end

local function OnAddListener(self)
  base.OnAddListener(self)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
end

function TCStarItemComponent:ReInit(lightCount)
  if self.lightCount and lightCount > self.lightCount then
    self:PlayStarUpgradeVfx()
  end
  self.lightCount = lightCount
  local isAllLight = lightCount == #self.allStarList
  self.starGroup:SetActive(not isAllLight)
  self.fullLight:SetActive(isAllLight)
  if isAllLight then
    return
  end
  for i = 1, #self.allStarList do
    if self.allStarList[i] then
      self.allStarList[i]:SetActive(i <= lightCount)
    end
  end
end

function TCStarItemComponent:PlayStarUpgradeVfx()
  self.vfx_starUpgrade:Replay()
end

function TCStarItemComponent:ClearLightCount()
  self.lightCount = nil
end

TCStarItemComponent.OnCreate = OnCreate
TCStarItemComponent.OnDestroy = OnDestroy
TCStarItemComponent.OnEnable = OnEnable
TCStarItemComponent.OnDisable = OnDisable
TCStarItemComponent.ComponentDefine = ComponentDefine
TCStarItemComponent.ComponentDestroy = ComponentDestroy
TCStarItemComponent.DataDefine = DataDefine
TCStarItemComponent.DataDestroy = DataDestroy
TCStarItemComponent.OnAddListener = OnAddListener
TCStarItemComponent.OnRemoveListener = OnRemoveListener
return TCStarItemComponent
