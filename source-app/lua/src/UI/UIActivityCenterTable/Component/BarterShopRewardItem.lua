local BarterShopRewardItem = BaseClass("BarterShopRewardItem", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local item_bg_path = "clickBtn/item_bg"
local hero_quality_path = "clickBtn/HeroQuality"
local item_quality_path = "clickBtn/ImgQuality"
local item_icon_path = "clickBtn/ItemIcon"
local num_text_path = "clickBtn/NumText"
local flag_path = "clickBtn/FlagGo"
local flag_text_path = "clickBtn/FlagGo/FlagText"
local this_path = "clickBtn"
local hero_debris_path = "clickBtn/HeroDebris"
local countBg_path = "clickBtn/countBg"
local extra_path = "clickBtn/ImgExtra"
local rarity_path = "clickBtn/ImgRarity"

local function OnCreate(self)
  base.OnCreate(self)
  self.item_bg = self:AddComponent(UIImage, item_bg_path)
  self.hero_quality = self:AddComponent(UIImage, hero_quality_path)
  self.item_quality = self:AddComponent(UIImage, item_quality_path)
  self.item_icon = self:AddComponent(UIImage, item_icon_path)
  self.num_text = self:AddComponent(UIText, num_text_path)
  self.flag_text = self:AddComponent(UIText, flag_text_path)
  self.btn = self:AddComponent(UIButton, this_path)
  self.flag = self:AddComponent(UIBaseContainer, flag_path)
  self.countBg = self:AddComponent(UIBaseContainer, countBg_path)
  self.nodeHeroDebris = self:AddComponent(UIBaseContainer, hero_debris_path)
  self.nodeHeroDebris:SetActive(false)
  self.imgExtra = self:AddComponent(UIImage, extra_path)
  self.imgRarity = self:AddComponent(UIImage, rarity_path)
  self.btn:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self:OnBtnClick()
  end)
end

local function OnDestroy(self)
  self.item_bg = nil
  self.hero_quality = nil
  self.item_quality = nil
  self.item_icon = nil
  self.num_text = nil
  self.flag_text = nil
  self.btn = nil
  self.flag = nil
  self.nodeHeroDebris = nil
  self.imgExtra = nil
  self.imgRarity = nil
  base.OnDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function RefreshData(self, param)
  self.param = param
  if self.param.cost then
    if self.param.rewardType == RewardType.OIL or self.param.rewardType == RewardType.METAL or self.param.rewardType == RewardType.WATER or self.param.rewardType == RewardType.GOLD or self.param.rewardType == RewardType.FOOD or self.param.rewardType == RewardType.ELECTRICITY or self.param.rewardType == RewardType.FLINT or self.param.rewardType == RewardType.OBSIDIAN then
      self.num_text:SetText(self.param.cost)
      self.item_quality:SetActive(false)
      self.item_bg:SetActive(false)
      self.countBg:SetActive(false)
    elseif self.param.cost <= self.param.count then
      self.num_text:SetText(string.GetFormattedStr(self.param.count) .. "/" .. self.param.cost)
    else
      self.num_text:SetText("<color=#FF0000>" .. string.GetFormattedStr(self.param.count) .. "</color>/" .. self.param.cost)
    end
  else
    self.item_quality:SetActive(true)
    self.item_bg:SetActive(true)
    if self.param.cost then
      self.countBg:SetActive(true)
    end
    self.num_text:SetText(self.param.count)
  end
  self.nodeHeroDebris:SetActive(false)
  self.imgExtra:SetActive(false)
  self.imgRarity:SetActive(false)
  if self.param.rewardType == nil then
  else
    if self.param.rewardType == RewardType.HERO then
      self.item_bg:SetActive(false)
      self.item_quality:SetActive(false)
      self.hero_quality:SetActive(true)
    else
      self.item_bg:SetActive(true)
      self.item_quality:SetActive(true)
      self.hero_quality:SetActive(false)
    end
    if self.param.rewardType == RewardType.GOODS then
      if self.param.itemId == nil then
        if self.param.iconName ~= nil and self.param.itemColor ~= nil then
          self:SetFlagActive(false)
          self:SetItemIconImage(self.param.iconName)
          self:SetItemQualityImage(DataCenter.ItemTemplateManager:GetToolBgByColor(self.param.itemColor))
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
              elf:SetItemQualityImage(tempJoin[2])
            end
            if 2 < #tempJoin then
              self:SetItemIconImage(tempJoin[3])
            end
          else
            self:SetItemQualityImage(DataCenter.ItemTemplateManager:GetToolBgByColor(goods.color))
            local itemType = goods.type
            if itemType == 2 then
              if goods.para1 ~= nil and goods.para1 ~= "" then
                local para1 = goods.para1
                local temp = string.split(para1, ";")
                if temp ~= nil and 1 < #temp then
                  self:SetFlagActive(true)
                  self:SetFlagText(temp[1] .. temp[2])
                else
                  self:SetFlagActive(false)
                end
              end
            elseif itemType == 3 or goods.type == GOODS_TYPE.GOODS_TYPE_91 then
              local type2 = goods.type2
              if type2 ~= 999 and goods.para ~= nil and goods.para ~= "" then
                local res_num = tonumber(goods.para)
                self:SetFlagText(string.GetFormattedStr(res_num))
                self:SetFlagActive(true)
              else
                self:SetFlagActive(false)
              end
            else
              self:SetFlagActive(false)
            end
            self:SetItemIconImage(string.format(LoadPath.ItemPath, goods.icon))
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
    elseif self.param.rewardType == RewardType.GOLD then
      self:SetFlagActive(false)
      self:SetItemIconImage(DataCenter.ResourceManager:GetResourceIconByType(ResourceType.Gold))
      self:SetItemQualityImage(DataCenter.ItemTemplateManager:GetToolBgByColor(ItemColor.PURPLE))
      self:SetNameText(Localization:GetString("100183"))
    elseif self.param.rewardType == RewardType.OIL or self.param.rewardType == RewardType.METAL or self.param.rewardType == RewardType.WATER or self.param.rewardType == RewardType.FOOD or self.param.rewardType == RewardType.ELECTRICITY or self.param.rewardType == RewardType.FLINT or self.param.rewardType == RewardType.OBSIDIAN then
      self:SetFlagActive(false)
      self:SetItemIconImage(DataCenter.RewardManager:GetPicByType(self.param.rewardType))
      self:SetItemQualityImage(DataCenter.ItemTemplateManager:GetToolBgByColor(ItemColor.PURPLE))
      self:SetNameText(Localization:GetString(CS.ResourceUtils.GetRewardTypeName(self.param.rewardType)))
    elseif self.param.rewardType == RewardType.ARM then
      self:SetFlagActive(false)
      local army = DataCenter.ArmyTemplateManager:GetArmyTemplate(self.param.itemId)
      if army ~= nil then
        self:SetItemIconImage(string.format(LoadPath.SoldierIcons, army.icon))
        self:SetItemQualityImage(DataCenter.ItemTemplateManager:GetToolBgByColor(ItemColor.WHITE))
        self:SetNameText(Localization:GetString(army.name))
      end
    elseif self.param.rewardType == RewardType.EQUIP then
      self:SetFlagActive(false)
      local xmlData = LocalController:instance():getLine("equip_info_new_equip", self.param.itemId)
      if xmlData ~= nil then
        self:SetItemIconImage(xmlData:GetString("icon"))
        local nColor = 0
        if xmlData:HasKey("color") then
          nColor = tonumber(xmlData:GetString("color"))
        end
        if nColor < 0 then
          nColor = 0
        end
        self:SetItemQualityImage(DataCenter.ItemTemplateManager:GetToolBgByColor(nColor))
        self:SetNameText(Localization:GetString(xmlData:GetString("name")))
      end
    elseif self.param.rewardType == RewardType.HERO then
      self:SetFlagActive(false)
      local xmlData = LocalController:instance():getLine(HeroUtils.GetHeroXmlName(), self.param.itemId)
      if xmlData ~= nil then
        self:SetItemIconImage(LoadPath.HeroIconsSmallPath .. xmlData.hero_icon)
        self.item_bg:SetActive(false)
        self.item_quality:SetActive(false)
        self.hero_quality:SetActive(true)
        local rarity = tonumber(xmlData.rarity)
        self.hero_quality:LoadSpriteAuto(HeroUtils.GetRarityIconPath(rarity))
        self:SetNameText(Localization:GetString(xmlData.name))
        self.imgRarity:SetActive(true)
        self.imgRarity:LoadSprite(HeroUtils.GetRarityIconName(xmlData.rarity, true))
      end
    elseif self.param.rewardType == RewardType.HONOR or self.param.rewardType == RewardType.ALLIANCE_POINT then
      self:SetFlagActive(false)
      self:SetItemIconImage(DataCenter.RewardManager:GetPicByType(self.param.rewardType, self.param.itemId))
      self:SetNameText(DataCenter.RewardManager:GetNameByType(self.param.rewardType, self.param.itemId))
    elseif self.param.rewardType == RewardType.MATERIAL then
      self:SetFlagActive(false)
      local goods = DataCenter.ItemTemplateManager:GetItemTemplate(self.param.itemId)
      if goods ~= nil then
        self:SetItemIconImage(goods.icon)
        self:SetItemQualityImage(DataCenter.ItemTemplateManager:GetToolBgByColor(tonumber(goods.color)))
        self:SetNameText(DataCenter.ItemTemplateManager:GetName(self.param.itemId))
      end
    elseif self.param.rewardType == RewardType.RESOURCE_ITEM then
      local template = DataCenter.ResourceItemDataManager:GetResourceItemTemplate(self.param.itemId)
      if template ~= nil then
        self:SetFlagActive(false)
        self:SetItemQualityImage(DataCenter.ItemTemplateManager:GetToolBgByColor(ItemColor.PURPLE))
        self:SetItemIconImage(string.format(LoadPath.ItemPath, template.pic))
        self:SetNameText(DataCenter.RewardManager:GetNameByType(self.param.rewardType, self.param.itemId))
      end
    end
  end
end

local function OnBtnClick(self)
  if self.param.rewardType == RewardType.GOODS then
    if self.param.itemId ~= nil then
      local param = {}
      param.itemId = self.param.itemId
      param.alignObject = self.item_icon
      UIManager:GetInstance():OpenWindow(UIWindowNames.UIItemTips, {anim = true}, param)
    elseif self.param.iconName ~= nil then
      local param = {}
      param.itemName = self.param.itemName
      param.itemDesc = self.param.itemDesc
      param.alignObject = self.item_icon
      UIManager:GetInstance():OpenWindow(UIWindowNames.UIItemTips, {anim = true}, param)
    end
  elseif self.param.rewardType == RewardType.HERO then
    local param = {}
    param.itemId = self.param.itemId
    param.rewardType = RewardType.HERO
    param.alignObject = self.item_icon
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIItemTips, {anim = true}, param)
  else
    local desc = DataCenter.RewardManager:GetDescByType(self.param.rewardType, self.param.itemId)
    local name = DataCenter.RewardManager:GetNameByType(self.param.rewardType, self.param.itemId)
    local param = {}
    param.itemName = name
    param.itemDesc = desc
    param.alignObject = self.item_icon
    param.isLocal = true
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIItemTips, {anim = true}, param)
  end
end

local function SetItemIconImage(self, imageName)
  self.item_icon:LoadSpriteAuto(imageName)
end

local function SetItemQualityImage(self, imageName)
  self.item_quality:LoadSprite(imageName)
end

local function SetItemCountActive(self, value)
  if self.itemCountActive ~= value then
    self.itemCountActive = value
    self.num_text.gameObject:SetActive(value)
  end
end

local function SetItemCount(self, value)
  if self.itemCount ~= value then
    self.itemCount = value
    self.num_text:SetText(value)
  end
end

local function SetFlagActive(self, value)
  if self.flagActive ~= value then
    self.flagActive = value
    self.flag:SetActive(value)
  end
end

local function SetFlagText(self, value)
  if self.flagText ~= value then
    self.flagText = value
    self.flag_text:SetText(value)
  end
end

local function SetNameText(self, value)
end

BarterShopRewardItem.OnCreate = OnCreate
BarterShopRewardItem.OnDestroy = OnDestroy
BarterShopRewardItem.OnBtnClick = OnBtnClick
BarterShopRewardItem.OnEnable = OnEnable
BarterShopRewardItem.OnDisable = OnDisable
BarterShopRewardItem.RefreshData = RefreshData
BarterShopRewardItem.SetItemIconImage = SetItemIconImage
BarterShopRewardItem.SetItemQualityImage = SetItemQualityImage
BarterShopRewardItem.SetItemCountActive = SetItemCountActive
BarterShopRewardItem.SetItemCount = SetItemCount
BarterShopRewardItem.SetFlagActive = SetFlagActive
BarterShopRewardItem.SetFlagText = SetFlagText
BarterShopRewardItem.SetNameText = SetNameText
return BarterShopRewardItem
