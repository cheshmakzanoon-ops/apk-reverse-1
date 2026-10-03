local UIHeroDebrisCell = BaseClass("UIHeroDebrisCell", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local UIGray = CS.UIGray
local hero_debris_path = ""
local hero_debris_bg_path = "ImgHeroDebrisBg"
local hero_debris_fg_path = "ImgHeroDebrisFg"
local hero_debris_icon_path = "ImgHeroDebrisBg/ImgHeroDebrisIcon"

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
  self.nodeHeroDebris = self:AddComponent(UIBaseContainer, hero_debris_path)
  self.imgHeroDebrisBg = self:AddComponent(UIButton, hero_debris_bg_path)
  self.imgHeroDebrisBg:SetOnClick(function()
    self:OnClick()
  end)
  self.imgHeroDebrisFg = self:AddComponent(UIImage, hero_debris_fg_path)
  self.imgHeroDebrisIcon = self:AddComponent(UIImage, hero_debris_icon_path)
end

local function ComponentDestroy(self)
  self.nodeHeroDebris = nil
  self.imgHeroDebrisBg = nil
  self.imgHeroDebrisFg = nil
  self.imgHeroDebrisIcon = nil
  self.imgExtra = nil
  self.imgRarity = nil
  self.imgCamp = nil
end

local function DataDefine(self)
  self.param = {}
end

local function DataDestroy(self)
  self.param = nil
end

local function ReInit(self, param)
  self.param = param
  self.nodeHeroDebris:SetActive(false)
  local goods = DataCenter.ItemTemplateManager:GetItemTemplate(self.param.itemId)
  if goods ~= nil then
    local isHeroDebris = goods ~= nil and goods.type == GOODS_TYPE.GOODS_TYPE_99
    self.nodeHeroDebris:SetActive(isHeroDebris)
    if isHeroDebris then
      self.imgHeroDebrisIcon:LoadSpriteAuto(HeroUtils.GetHeroIconPath(goods.para2))
    end
  end
end

local function OnClick(self)
  if self.param.itemId ~= nil then
    local param = {}
    param.itemId = self.param.itemId
    param.alignObject = self.imgHeroDebrisBg
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIItemTips, {anim = true}, param)
  elseif self.param.iconName ~= nil then
    local param = {}
    param.itemName = self.param.itemName
    param.itemDesc = self.param.itemDesc
    param.alignObject = self.imgHeroDebrisBg
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIItemTips, {anim = true}, param)
  end
end

UIHeroDebrisCell.OnCreate = OnCreate
UIHeroDebrisCell.OnDestroy = OnDestroy
UIHeroDebrisCell.OnEnable = OnEnable
UIHeroDebrisCell.OnDisable = OnDisable
UIHeroDebrisCell.ComponentDefine = ComponentDefine
UIHeroDebrisCell.ComponentDestroy = ComponentDestroy
UIHeroDebrisCell.DataDefine = DataDefine
UIHeroDebrisCell.DataDestroy = DataDestroy
UIHeroDebrisCell.ReInit = ReInit
UIHeroDebrisCell.OnClick = OnClick
return UIHeroDebrisCell
