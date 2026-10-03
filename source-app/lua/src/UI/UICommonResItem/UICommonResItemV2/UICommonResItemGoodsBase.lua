local UICommonResItemBase = require("UI.UICommonResItem.UICommonResItemV2.UICommonResItemBase")
local UICommonResItemGoodsBase = BaseClass("UICommonResItemGoodsBase", UICommonResItemBase)
local base = UICommonResItemBase
local dictSeason = {}

local function OnCreate(self)
  base.OnCreate(self)
  if dictSeason == nil or dictSeason[SeasonMapType.Snow] == nil then
    dictSeason = {}
    dictSeason[SeasonMapType.Nothing] = 0
    dictSeason[SeasonMapType.CityStronghold] = 1
    dictSeason[SeasonMapType.Snow] = 2
    dictSeason[SeasonMapType.Mummy] = 3
    dictSeason[SeasonMapType.Darkness] = 4
    dictSeason[SeasonMapType.NineNation] = 5
    dictSeason[SeasonMapType.NineNationRainforest] = 6
  end
  self:ComponentDefineGoods()
  self:DataDefine()
end

local function OnDestroy(self)
  self:ComponentDestroyGoods()
  self:DataDestroy()
  base.OnDestroy(self)
end

local function ComponentDefineGoods(self)
end

local function ComponentDestroyGoods(self)
end

local function DataDefine(self)
  base.DataDefine(self)
end

local function DataDestroy(self)
  base.DataDestroy(self)
end

local function OnReInit(self)
  self.goodSkin = nil
  self:SetItemCount(self.param.count)
  if self.param.itemId == nil then
    if self.param.iconName ~= nil and self.param.itemColor ~= nil then
      self:SetFlagActive(false)
      self:SetItemIconImage(self.param.iconName)
      self:SetItemQualityImage(DataCenter.ItemTemplateManager:GetToolBgByColor(tonumber(self.param.itemColor)))
      self.num_text:SetText("")
    elseif self.param.heroConfigId ~= nil then
      self:SetFlagActive(false)
      local _heroConfigId = self.param.heroConfigId
      self:SetItemIconImage(HeroUtils.GetHeroIconPath(_heroConfigId, false))
      local heroTemplate = DataCenter.HeroTemplateManager:GetTemplate(_heroConfigId)
      local quality = 1
      if heroTemplate ~= nil then
        quality = heroTemplate.quality
      end
      self:SetItemQualityImage(HeroUtils.GetQualityIconPath(quality, false))
    end
  else
    local goods = DataCenter.ItemTemplateManager:GetItemTemplate(self.param.itemId)
    if goods ~= nil then
      self:SetNameText(DataCenter.ItemTemplateManager:GetName(self.param.itemId))
      local join_method = -1
      local icon_join
      if goods.join_method ~= nil and goods.join_method > 0 and goods.icon_join ~= nil and goods.icon_join ~= "" then
        join_method = goods.join_method
        icon_join = goods.icon_join
      end
      if 0 < join_method and icon_join ~= nil and icon_join ~= "" then
        self:SetFlagActive(false)
        local tempJoin = string.split(icon_join, ";")
        if 1 < #tempJoin then
          self:SetItemQualityImage(tempJoin[2])
        end
        if 2 < #tempJoin then
          self:SetItemIconImage(tempJoin[3])
        end
      else
        self:SetItemQualityImage(DataCenter.ItemTemplateManager:GetToolBgByColor(goods.color))
        local flagText = DataCenter.RewardManager:GetFlagText(RewardType.GOODS, self.param.itemId)
        if string.IsNullOrEmpty(flagText) then
          self:SetFlagActive(false)
        else
          self:SetFlagActive(true)
          self:SetFlagText(flagText)
        end
        local goodSkin
        local iconPath = string.format(LoadPath.ItemPath, goods.icon)
        if self.seasonType ~= nil then
          local seasonIndex = toInt(dictSeason[toInt(self.seasonType)])
          if 0 < seasonIndex then
            goodSkin = DataCenter.ItemTemplateManager:GetItemSkin(self.param.itemId, seasonIndex)
            if goodSkin ~= nil then
              self.goodSkin = goodSkin
              iconPath = string.format(LoadPath.ItemPath, goodSkin.icon)
            end
          end
        end
        self:SetItemIconImage(iconPath)
      end
    else
      local resourceType = tonumber(self.param.itemId)
      if resourceType < 100 then
        self:SetFlagActive(false)
        self:SetItemIconImage(DataCenter.ResourceManager:GetResourceIconByType(resourceType))
        self:SetItemQualityImage(DataCenter.ItemTemplateManager:GetToolBgByColor(ItemColor.PURPLE))
      end
    end
  end
end

local function OnClick(self)
  if self.param.itemId ~= nil then
    if self:HandleClickSticker() then
      return
    end
    local param = {}
    param.itemId = self.param.itemId
    param.alignObject = self.item_icon
    param.hideHaveCountShow = self.param.hideHaveCountShow
    param.showUse = self.param.showUse
    param.seasonType = self.seasonType
    param.goodSkin = self.goodSkin
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIItemTips, {anim = true}, param)
  elseif self.param.iconName ~= nil then
    local param = {}
    param.itemName = self.param.itemName
    param.itemDesc = self.param.itemDesc
    param.alignObject = self.item_icon
    param.hideHaveCountShow = self.param.hideHaveCountShow
    param.showUse = self.param.showUse
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIItemTips, {anim = true}, param)
  end
end

function UICommonResItemGoodsBase:HandleClickSticker()
  local goods = DataCenter.ItemTemplateManager:GetItemTemplate(self.param.itemId)
  if goods ~= nil then
    local stickerCell = DataCenter.StickerWithDecorationLinkManager:GetStickerCellByGoodsId(goods.id)
    if stickerCell ~= nil then
      local param = {}
      param.alignObject = self.item_icon
      param.yPosFix = 20
      param.showArrow = true
      param.preferTop = false
      param.itemId = self.param.itemId
      param.hideHaveCountShow = self.param.hideHaveCountShow
      param.showUse = self.param.showUse
      param.seasonType = self.seasonType
      param.goodSkin = self.goodSkin
      UIManager:GetInstance():OpenWindow(UIWindowNames.UIStickerTipsViewView, {anim = true}, param)
      return true
    end
  end
  return false
end

UICommonResItemGoodsBase.OnCreate = OnCreate
UICommonResItemGoodsBase.OnDestroy = OnDestroy
UICommonResItemGoodsBase.ComponentDefineGoods = ComponentDefineGoods
UICommonResItemGoodsBase.ComponentDestroyGoods = ComponentDestroyGoods
UICommonResItemGoodsBase.DataDefine = DataDefine
UICommonResItemGoodsBase.DataDestroy = DataDestroy
UICommonResItemGoodsBase.OnReInit = OnReInit
UICommonResItemGoodsBase.OnClick = OnClick
return UICommonResItemGoodsBase
