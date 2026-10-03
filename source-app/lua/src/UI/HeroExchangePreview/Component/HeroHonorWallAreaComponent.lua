local HeroHonorWallAreaComponent = BaseClass("HeroHonorWallAreaComponent", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local honor_wall_lv_text_path = "HonorWallLvArea/HonorWallLvText"
local honor_wall_tip_text_path = "HonorWallTipText"

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
  self.honorLvText = self:AddComponent(UIText, honor_wall_lv_text_path)
  self.honorWallChangeTip = self:AddComponent(UIText, honor_wall_tip_text_path)
end

local function ComponentDestroy(self)
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

function HeroHonorWallAreaComponent:SetData(fromHeroData, toHeroData)
  if not fromHeroData or not toHeroData then
    return
  end
  local isExistHonorLevel = 0 < (fromHeroData.honorLevel or 0)
  local isMaxRankAfterChange = toHeroData:IsReachMaxRank()
  if fromHeroData.honorLevel > 0 then
    self.honorLvText:SetLocalText("activity_hero_change_cofirm_honor_wall_tips_1", fromHeroData.honorLevel)
  else
    self.honorLvText:SetLocalText("activity_hero_change_cofirm_honor_wall_tips_2")
  end
  self.honorWallChangeTip:SetActive(isExistHonorLevel and not isMaxRankAfterChange)
end

HeroHonorWallAreaComponent.OnCreate = OnCreate
HeroHonorWallAreaComponent.OnDestroy = OnDestroy
HeroHonorWallAreaComponent.OnEnable = OnEnable
HeroHonorWallAreaComponent.OnDisable = OnDisable
HeroHonorWallAreaComponent.ComponentDefine = ComponentDefine
HeroHonorWallAreaComponent.ComponentDestroy = ComponentDestroy
HeroHonorWallAreaComponent.DataDefine = DataDefine
HeroHonorWallAreaComponent.DataDestroy = DataDestroy
HeroHonorWallAreaComponent.OnAddListener = OnAddListener
HeroHonorWallAreaComponent.OnRemoveListener = OnRemoveListener
return HeroHonorWallAreaComponent
