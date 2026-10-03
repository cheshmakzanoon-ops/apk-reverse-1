local BaseUIEquipItem = BaseClass("BaseUIEquipItem", UIBaseContainer)
local base = UIBaseContainer
local LWEquipRankStar = require("UI.UILWHero.UIHeroEquipListPanel.Component.LWEquipRankStar")
local UIHeroCellTiny = require("UI.UIHero2.Common.UIHeroCellTiny")

local function OnCreate(self)
  base.OnCreate(self)
  self:DataDefine()
  self:ComponentDefine()
end

local function OnDestroy(self)
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

local function DataDefine(self)
  self.showRedPoint = false
  self.isTemplate = false
end

local function DataDestroy(self)
  self.equipData = nil
  self.template = nil
  self.clickCallBack = nil
  self.showRedPoint = nil
  self.isTemplate = nil
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
  self.root = self:AddComponent(UIBaseContainer, "")
  self.equipQualityBg = self:AddComponent(UIImage, "QualityBg")
  self.equipBtn = self:AddComponent(UIButton, "QualityBg")
  self.equipBtn:SetOnClick(function()
    if self.clickCallBack ~= nil then
      if self.isTemplate then
        self.clickCallBack(self.template.id)
      else
        self.clickCallBack(self.equipData)
      end
    end
  end)
  self.equipLevelText = self:AddComponent(UIText, "LevelText")
  self.equipIcon = self:AddComponent(UIImage, "Icon")
  self.slot = self:AddComponent(UIImage, "Slot")
  self.redPoint = self:AddComponent(UIImage, "RedPoint")
  self.heroTypeIcon = self:AddComponent(UIImage, "HeroTypeIcon")
  self.rankStar = self:AddComponent(LWEquipRankStar, "EquipRankStar")
  self.ownerHero = self:AddComponent(UIHeroCellTiny, "UIHeroCellTiny")
end

local function ComponentDestroy(self)
  self.root = nil
  self.equipQualityBg = nil
  self.equipBtn = nil
  self.equipLevelText = nil
  self.equipIcon = nil
  self.redPoint = nil
  self.heroTypeIcon = nil
end

local function ShowSlot(self, slotIndex)
  self.slot:SetActive(true)
  self.equipIcon:SetActive(false)
  self.equipQualityBg:SetActive(false)
  self.equipLevelText:SetActive(false)
  self.slot:LoadSpriteAsync(HeroUtils.GetEquipSlotSprite(slotIndex))
  self.rankStar:SetActive(false)
  self.heroTypeIcon:SetActive(false)
  self.ownerHero:SetActive(false)
end

local function SetData(self, equipData, clickCallBack, showRedPoint, showHeroType, showLevel)
  if equipData == nil then
    self:SetActive(false)
    return
  else
    self:SetActive(true)
    self.slot:SetActive(false)
  end
  self.equipData = equipData
  self.template = equipData.config
  self.clickCallBack = clickCallBack
  self.equipQualityBg:SetActive(true)
  self.equipQualityBg:LoadSpriteAsync(UIUtil.GetItemQualityBg(self.template.quality))
  self.equipIcon:SetActive(true)
  self.equipIcon:LoadSpriteAsync(string.format(LoadPath.ItemPath, self.template.icon))
  if showRedPoint then
    local canShowRedPoint = self.equipData:CanShowRedPoint()
    self.redPoint:SetActive(canShowRedPoint)
    self.showRedPoint = true
  else
    self.redPoint:SetActive(false)
    self.showRedPoint = false
  end
  if showHeroType then
    local heroTypeIconPath = HeroUtils.GetHeroTypeIcon(self.template.heroType)
    if not string.IsNullOrEmpty(heroTypeIconPath) then
      self.heroTypeIcon:SetActive(true)
      self.heroTypeIcon:LoadSpriteAsync(heroTypeIconPath)
    else
      self.heroTypeIcon:SetActive(false)
    end
  else
    self.heroTypeIcon:SetActive(false)
  end
  if showLevel then
    if self.template.quality > 2 then
      self.equipLevelText:SetActive(true)
      self.equipLevelText:SetText("Lv." .. tostring(equipData.level))
    else
      self.equipLevelText:SetActive(false)
    end
  else
    self.equipLevelText:SetActive(false)
  end
  self.isTemplate = false
  local canShowEquipStar = DataCenter.EquipDataManager:CanShowEquipStar(self.equipData)
  if canShowEquipStar or self.equipData.promoteLevel > 0 then
    self:SetEquipRank(self.equipData.promoteLevel, self.equipData.maxPromoteLevel)
  else
    self.rankStar:SetActive(false)
  end
  self:HideOwnerHero()
end

local function RefreshEquipStarMail(self)
  if not self.equipData then
    return
  end
  if self.equipData.promoteLevel > 0 then
    self:SetEquipRank(self.equipData.promoteLevel, self.equipData.maxPromoteLevel)
  else
    self.rankStar:SetActive(false)
  end
end

local function SetTemplateData(self, id, clickCallBack, showHeroType, showLevel, lv, promote)
  local template = DataCenter.EquipTemplateManager:GetTemplate(id)
  if template == nil then
    self:SetActive(false)
    return
  else
    self:SetActive(true)
  end
  self.equipData = nil
  self.template = template
  self.clickCallBack = clickCallBack
  self.equipQualityBg:SetActive(true)
  self.equipQualityBg:LoadSpriteAsync(UIUtil.GetItemQualityBg(self.template.quality))
  self.equipIcon:SetActive(true)
  self.equipIcon:LoadSpriteAsync(string.format(LoadPath.ItemPath, self.template.icon))
  self.redPoint:SetActive(false)
  if showHeroType then
    local heroTypeIconPath = HeroUtils.GetHeroTypeIcon(self.template.heroType)
    if not string.IsNullOrEmpty(heroTypeIconPath) then
      self.heroTypeIcon:SetActive(true)
      self.heroTypeIcon:LoadSpriteAsync(heroTypeIconPath)
    else
      self.heroTypeIcon:SetActive(false)
    end
  else
    self.heroTypeIcon:SetActive(false)
  end
  if showLevel then
    self.equipLevelText:SetActive(true)
    local lv = lv or 1
    self.equipLevelText:SetText(string.format("Lv.%d", lv))
  else
    self.equipLevelText:SetActive(false)
  end
  self.isTemplate = true
  if not promote or promote <= 0 then
    self.rankStar:SetActive(false)
  else
    self:SetEquipRank(promote, template.maxPromoteLevel)
  end
  self:HideOwnerHero()
end

local function RefreshCanReplaceWithBetterEquipRedPoint(self)
  if self.showRedPoint then
    local canEquip = HeroRedPointManager:GetInstance():CheckCanShowRedPoint(HeroRedPointType.HeroDetail_ExistEquipSlot, self.equipData, self.equipData.heroUuid)
    self.redPoint:SetActive(canEquip)
  end
end

local function SetEquipRank(self, rank, maxRank)
  if not rank or not maxRank then
    return
  end
  if not DataCenter.EquipDataManager:CheckRedEquipOpen() then
    self.rankStar:SetActive(false)
    return
  end
  if 0 <= rank then
    self.rankStar:SetActive(true)
    self.rankStar:ShowRank(rank, maxRank)
  else
    self.rankStar:SetActive(false)
  end
end

local function ShowOwnerHero(self, ownerUuid)
  if not ownerUuid then
    self.ownerHero:SetActive(false)
    return
  end
  if ownerUuid <= 0 then
    self.ownerHero:SetActive(false)
    return
  end
  local heroData = DataCenter.HeroDataManager:GetHeroByUuid(ownerUuid)
  if not heroData then
    self.ownerHero:SetActive(false)
    return
  end
  self.ownerHero:SetActive(true)
  self.ownerHero:SetData(heroData.heroId, heroData.quality, nil, heroData.weaponLevel, nil, heroData:GetSkinId())
end

local function HideOwnerHero(self)
  self.ownerHero:SetActive(false)
end

BaseUIEquipItem.OnCreate = OnCreate
BaseUIEquipItem.OnDestroy = OnDestroy
BaseUIEquipItem.OnEnable = OnEnable
BaseUIEquipItem.OnDisable = OnDisable
BaseUIEquipItem.DataDefine = DataDefine
BaseUIEquipItem.DataDestroy = DataDestroy
BaseUIEquipItem.ComponentDefine = ComponentDefine
BaseUIEquipItem.ComponentDestroy = ComponentDestroy
BaseUIEquipItem.SetData = SetData
BaseUIEquipItem.RefreshEquipStarMail = RefreshEquipStarMail
BaseUIEquipItem.ShowSlot = ShowSlot
BaseUIEquipItem.SetTemplateData = SetTemplateData
BaseUIEquipItem.RefreshCanReplaceWithBetterEquipRedPoint = RefreshCanReplaceWithBetterEquipRedPoint
BaseUIEquipItem.SetEquipRank = SetEquipRank
BaseUIEquipItem.ShowOwnerHero = ShowOwnerHero
BaseUIEquipItem.HideOwnerHero = HideOwnerHero
return BaseUIEquipItem
