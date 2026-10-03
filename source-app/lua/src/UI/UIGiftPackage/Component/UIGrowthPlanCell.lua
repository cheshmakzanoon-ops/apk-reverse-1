local UIGrowthPlanCell = BaseClass("UIGrowthPlanCell", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local UIHeroTipsView = require("UI.UIHeroTips.View.UIHeroTipsView")
local Param = DataClass("Param", ParamData)
local ParamData = {
  rewardType,
  itemId,
  count,
  iconName,
  itemColor,
  itemName,
  itemDes
}
local glow_path = "Glow"
local mask_path = "Mask"
local lock_path = "Lock"
local check_path = "Check"
local item_bg_path = "UICommonResItem/clickBtn/item_bg"
local hero_quality_path = "UICommonResItem/clickBtn/HeroQuality"
local item_quality_path = "UICommonResItem/clickBtn/ImgQuality"
local item_icon_path = "UICommonResItem/clickBtn/ItemIcon"
local num_text_path = "UICommonResItem/clickBtn/NumText"
local flag_path = "UICommonResItem/clickBtn/FlagGo"
local flag_text_path = "UICommonResItem/clickBtn/FlagGo/FlagText"
local this_path = "UICommonResItem/clickBtn"
local hero_debris_path = "UICommonResItem/clickBtn/HeroDebris"
local extra_path = "UICommonResItem/clickBtn/ImgExtra"

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
  self.glow_go = self:AddComponent(UIBaseContainer, glow_path)
  self.mask_go = self:AddComponent(UIBaseContainer, mask_path)
  self.lock_go = self:AddComponent(UIBaseContainer, lock_path)
  self.check_go = self:AddComponent(UIBaseContainer, check_path)
  self.item_bg = self:AddComponent(UIImage, item_bg_path)
  self.hero_quality = self:AddComponent(UIImage, hero_quality_path)
  self.item_quality = self:AddComponent(UIImage, item_quality_path)
  self.item_icon = self:AddComponent(UIImage, item_icon_path)
  self.num_text = self:AddComponent(UIText, num_text_path)
  self.flag_text = self:AddComponent(UIText, flag_text_path)
  self.btn = self:AddComponent(UIButton, this_path)
  self.flag = self:AddComponent(UIBaseContainer, flag_path)
  self.nodeHeroDebris = self:AddComponent(UIBaseContainer, hero_debris_path)
  self.nodeHeroDebris:SetActive(false)
  self.imgExtra = self:AddComponent(UIImage, extra_path)
  self.btn:SetOnClick(function()
    if self.onClick then
      self.onClick()
    end
  end)
end

local function ComponentDestroy(self)
  self.glow_go = nil
  self.mask_go = nil
  self.lock_go = nil
  self.check_go = nil
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
end

local function DataDefine(self)
  self.param = {}
  self.flagText = nil
  self.flagActive = nil
  self.itemCount = nil
  self.itemCountActive = nil
  self.nameText = nil
  self.onClick = nil
end

local function DataDestroy(self)
  self.param = nil
  self.flagText = nil
  self.flagActive = nil
  self.itemCount = nil
  self.itemCountActive = nil
  self.nameText = nil
  self.onClick = nil
end

local function SetData(self, data)
  self.lock_go:SetActive(data.locked)
  self.mask_go:SetActive(data.checked)
  self.check_go:SetActive(data.checked)
  self.glow_go:SetActive(data.canGet)
  if type(data.reward.value) == "table" then
    local param = {
      rewardType = data.reward.type,
      itemId = data.reward.value.id,
      count = data.reward.value.num
    }
    self:ReInit(param)
  elseif type(data.reward.value) == "number" then
    local param = {
      rewardType = data.reward.type,
      count = data.reward.value
    }
    self:ReInit(param)
  end
end

local function ReInit(self, param)
  self.param = param
  if self.param.count == nil then
    self:SetItemCountActive(false)
  else
    self:SetItemCountActive(true)
    self:SetItemCount(self.param.count)
  end
  self.nodeHeroDebris:SetActive(false)
  self.imgExtra:SetActive(false)
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
    elseif self.param.rewardType == RewardType.OIL or self.param.rewardType == RewardType.METAL or self.param.rewardType == RewardType.WATER or self.param.rewardType == RewardType.FOOD or self.param.rewardType == RewardType.ELECTRICITY then
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
    local heroId = self.param.itemId
    local heroConfig = LocalController:instance():getLine(HeroUtils.GetHeroXmlName(), tonumber(heroId))
    local param = UIHeroTipsView.Param.New()
    param.heroId = heroId
    param.title = Localization:GetString(heroConfig.name)
    param.content = Localization:GetString(heroConfig.brief_desc)
    param.dir = UIHeroTipsView.Direction.ABOVE
    param.defWidth = 300
    param.pivot = 0.5
    param.position = self.transform.position + Vector3.New(0, 75, 0)
    param.bindObject = self.gameObject
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeroTips, {anim = false}, param)
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

local function SetOnClick(self, onClick)
  self.onClick = onClick
end

UIGrowthPlanCell.OnCreate = OnCreate
UIGrowthPlanCell.OnDestroy = OnDestroy
UIGrowthPlanCell.Param = Param
UIGrowthPlanCell.OnBtnClick = OnBtnClick
UIGrowthPlanCell.OnEnable = OnEnable
UIGrowthPlanCell.OnDisable = OnDisable
UIGrowthPlanCell.ComponentDefine = ComponentDefine
UIGrowthPlanCell.ComponentDestroy = ComponentDestroy
UIGrowthPlanCell.DataDefine = DataDefine
UIGrowthPlanCell.DataDestroy = DataDestroy
UIGrowthPlanCell.SetData = SetData
UIGrowthPlanCell.ReInit = ReInit
UIGrowthPlanCell.SetItemIconImage = SetItemIconImage
UIGrowthPlanCell.SetItemQualityImage = SetItemQualityImage
UIGrowthPlanCell.SetItemCountActive = SetItemCountActive
UIGrowthPlanCell.SetItemCount = SetItemCount
UIGrowthPlanCell.SetFlagActive = SetFlagActive
UIGrowthPlanCell.SetFlagText = SetFlagText
UIGrowthPlanCell.SetNameText = SetNameText
UIGrowthPlanCell.SetOnClick = SetOnClick
return UIGrowthPlanCell
