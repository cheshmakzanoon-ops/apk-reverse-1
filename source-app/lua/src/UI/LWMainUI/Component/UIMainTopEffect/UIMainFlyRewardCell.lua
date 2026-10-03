local UIMainFlyRewardCell = BaseClass("UIMainFlyRewardCell", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local quality_bg_path = "QualityBg"
local icon_path = "Icon"
local numText_path = "NumText"

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
end

local function OnDestroy(self)
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
  self.qualityBg = self:AddComponent(UIImage, quality_bg_path)
  self.qualityBg:SetActive(false)
  self.numText = self:AddComponent(UIText, numText_path)
  self.numText:SetActive(false)
  self.icon = self:AddComponent(UIImage, icon_path)
end

local function ComponentDestroy(self)
  self.qualityBg = nil
  self.icon = nil
  self.numText = nil
end

local function SetItemIconImage(self, imageName)
  self.icon:LoadSpriteAuto(imageName)
end

local function SetDefault(self, param)
  local t = type(param.value)
  if t == "number" then
    self:SetItemIconImage(DataCenter.RewardManager:GetPicByType(param.type))
  else
    self:SetItemIconImage(DataCenter.RewardManager:GetPicByType(param.type, param.value.id))
  end
end

local function SetGoods(self, param)
  local itemId = tonumber(param.value.itemId)
  self:SetItemIconImage(DataCenter.RewardManager:GetPicByType(param.type, itemId))
end

local function SetHero(self, param)
  local heroId = tonumber(param.value.heroId)
  local icon = HeroUtils.GetHeroIconPath(heroId)
  self:SetItemIconImage(icon)
  self.qualityBg:SetActive(true)
  self.qualityBg:LoadSprite("Assets/Main/Sprites/UI/LWCommon/Sprite/tongyong_cfm_daojukuang_5.png")
end

local function SetWorker(self, param)
  self:SetItemIconImage(DataCenter.RewardManager:GetPicByType(param.type))
  self.qualityBg:SetActive(true)
  self.qualityBg:LoadSprite("Assets/Main/Sprites/UI/LWCommon/Sprite/tongyong_cfm_daojukuang_5.png")
end

local TypeRewardMap = {
  [RewardType.HERO] = SetHero,
  [RewardType.WORKER] = SetWorker,
  [RewardType.GOODS] = SetGoods,
  Default = SetDefault
}

local function ReInit(self, param)
  self.param = param
  if TypeRewardMap[param.type] then
    TypeRewardMap[param.type](self, param)
  else
    TypeRewardMap.Default(self, param)
  end
end

UIMainFlyRewardCell.OnCreate = OnCreate
UIMainFlyRewardCell.OnDestroy = OnDestroy
UIMainFlyRewardCell.OnEnable = OnEnable
UIMainFlyRewardCell.OnDisable = OnDisable
UIMainFlyRewardCell.ComponentDefine = ComponentDefine
UIMainFlyRewardCell.ComponentDestroy = ComponentDestroy
UIMainFlyRewardCell.ReInit = ReInit
UIMainFlyRewardCell.SetItemIconImage = SetItemIconImage
return UIMainFlyRewardCell
