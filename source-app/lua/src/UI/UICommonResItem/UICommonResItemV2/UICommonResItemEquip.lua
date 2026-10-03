local UICommonResItemBase = require("UI.UICommonResItem.UICommonResItemV2.UICommonResItemBase")
local UICommonResItemEquip = BaseClass("UICommonResItemEquip", UICommonResItemBase)
local base = UICommonResItemBase

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

local function ComponentDefine(self)
end

local function ComponentDestroy(self)
end

local function DataDefine(self)
  base.DataDefine(self)
end

local function DataDestroy(self)
  base.DataDestroy(self)
end

local function OnReInit(self)
  self:SetFlagActive(false)
  self:SetItemIconImage(DataCenter.RewardManager:GetPicByType(tonumber(self.param.rewardType), tonumber(self.param.itemId)))
  self:SetItemQualityImage(DataCenter.RewardManager:GetRewardQualityBg(tonumber(self.param.rewardType), tonumber(self.param.itemId)))
  self:SetNameText(DataCenter.RewardManager:GetNameByType(tonumber(self.param.rewardType), tonumber(self.param.itemId)))
  local data = EquipInfo.New()
  data:CreateFromTemplate(self.param.itemId)
  if data.config == nil then
    Logger.LogError("\232\163\133\229\164\135\232\161\168\228\184\173\230\178\161\230\156\137id\228\184\186" .. self.param.itemId .. "\231\154\132\232\163\133\229\164\135")
    return
  end
  local path = HeroUtils.GetHeroTypeIcon(data.config.heroType)
  if not string.IsNullOrEmpty(path) then
    self.imgCamp:SetActive(true)
    self.imgCamp:LoadSprite(path)
  else
    self.imgCamp:SetActive(false)
  end
end

UICommonResItemEquip.OnCreate = OnCreate
UICommonResItemEquip.OnDestroy = OnDestroy
UICommonResItemEquip.ComponentDefine = ComponentDefine
UICommonResItemEquip.ComponentDestroy = ComponentDestroy
UICommonResItemEquip.DataDefine = DataDefine
UICommonResItemEquip.DataDestroy = DataDestroy
UICommonResItemEquip.OnReInit = OnReInit
return UICommonResItemEquip
