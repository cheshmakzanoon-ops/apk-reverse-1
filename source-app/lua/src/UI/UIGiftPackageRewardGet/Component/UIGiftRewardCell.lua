local UIGiftRewardCell = BaseClass("UIGiftRewardCell", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
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
local commonItemContainer_path = "GameObject"
local item_quality_path = "GameObject/ImgQuality"
local item_icon_path = "GameObject/ItemIcon"
local num_text_path = "GameObject/NumText"
local flag_text_path = "GameObject/FlagGo/FlagText"
local flag_go_path = "GameObject/FlagGo"
local this_path = ""
local name_text_path = "GameObject/NameText"
local heroItemContainer_path = "hero"
local heroIcon_path = "hero/Icon"
local heroBg_path = "hero/imgQuality"
local heroName_path = "hero/heroName"
local imgExtra_path = "GameObject/imgExtra"
local bg_path = "GameObject/item_bg"
local hero_debris_path = "GameObject/HeroDebris"
local ICON_SIZE = 118

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
  self.commonItemContainer = self:AddComponent(UIBaseContainer, commonItemContainer_path)
  self.commonItemAnim = self:AddComponent(UIAnimator, commonItemContainer_path)
  self.item_quality = self:AddComponent(UIImage, item_quality_path)
  self.item_icon = self:AddComponent(UIImage, item_icon_path)
  self.num_text = self:AddComponent(UIText, num_text_path)
  self.flag_text = self:AddComponent(UIText, flag_text_path)
  self.flag_go = self:AddComponent(UIBaseContainer, flag_go_path)
  self.btn = self:AddComponent(UIButton, this_path)
  self.name_text = self:AddComponent(UIText, name_text_path)
  self.heroItemContainer = self:AddComponent(UIBaseContainer, heroItemContainer_path)
  self.heroItemAnim = self:AddComponent(UIAnimator, heroItemContainer_path)
  self.heroIcon = self:AddComponent(UIImage, heroIcon_path)
  self.heroBg = self:AddComponent(UIImage, heroBg_path)
  self.heroName = self:AddComponent(UIText, heroName_path)
  self.imgExtra = self:AddComponent(UIImage, imgExtra_path)
  self.bg = self:AddComponent(UIBaseContainer, bg_path)
  self.nodeHeroDebris = self:AddComponent(UIBaseContainer, hero_debris_path)
  self.nodeHeroDebris:SetActive(false)
  self.btn:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self:OnBtnClick()
  end)
end

local function ComponentDestroy(self)
  self.item_quality = nil
  self.item_icon = nil
  self.num_text = nil
  self.flag_text = nil
  self.flag_go = nil
  self.btn = nil
  self.name_text = nil
  self.imgExtra = nil
  self.bg = nil
end

local function DataDefine(self)
  self.param = {}
  self.flagText = nil
  self.flagActive = nil
  self.itemCount = nil
  self.itemCountActive = nil
  self.nameText = nil
end

local function DataDestroy(self)
  self.param = nil
  self.flagText = nil
  self.flagActive = nil
  self.itemCount = nil
  self.itemCountActive = nil
  self.nameText = nil
end

local function ReInit(self, param)
  self.param = param
  self.bg:SetActive(true)
  self.item_quality:SetActive(true)
  self.imgExtra:SetActive(false)
  self.nodeHeroDebris:SetActive(false)
  self.item_icon.rectTransform.sizeDelta = Vector2.New(ICON_SIZE, ICON_SIZE)
  if self.param.count == nil then
    self:SetItemCountActive(false)
  else
    self:SetItemCountActive(true)
    self:SetItemCount(self.param.count)
  end
  self.commonItemContainer:SetActive(true)
  self.heroItemContainer:SetActive(false)
  if self.param.rewardType == nil then
  elseif self.param.rewardType == RewardType.GOODS then
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
          elseif itemType == 3 then
            local type2 = goods.type2
            if type2 ~= 999 and goods.para ~= nil and goods.para ~= "" then
              local res_num = tonumber(goods.para)
              self:SetFlagText(string.GetFormattedStr(res_num))
              self:SetFlagActive(true)
            else
              self:SetFlagActive(false)
            end
          elseif itemType == 5 then
            if goods.para3 ~= nil and goods.para3 ~= "" then
              local res_num = tonumber(goods.para3)
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
  elseif self.param.rewardType == RewardType.OIL or self.param.rewardType == RewardType.METAL or self.param.rewardType == RewardType.WATER or self.param.rewardType == RewardType.FOOD or self.param.rewardType == RewardType.ELECTRICITY or self.param.rewardType == RewardType.PVE_POINT or self.param.rewardType == RewardType.DETECT_EVENT or self.param.rewardType == RewardType.WOOD or self.param.rewardType == RewardType.FORMATION_STAMINA or self.param.rewardType == RewardType.PVE_ACT_SCORE then
    self:SetFlagActive(false)
    self:SetItemIconImage(DataCenter.RewardManager:GetPicByType(self.param.rewardType))
    self:SetItemQualityImage(DataCenter.ItemTemplateManager:GetToolBgByColor(ItemColor.PURPLE))
    self:SetNameText(DataCenter.RewardManager:GetNameByType(self.param.rewardType))
  elseif self.param.rewardType == RewardType.ARM then
    self:SetFlagActive(false)
    local army = DataCenter.ArmyTemplateManager:GetArmyTemplate(self.param.itemId)
    if army ~= nil then
      self:SetItemIconImage(string.format(LoadPath.SoldierIcons, army.icon))
      self:SetItemQualityImage(DataCenter.ItemTemplateManager:GetToolBgByColor(ItemColor.WHITE))
      self:SetNameText(Localization:GetString(army.name))
      self.item_icon:SetNativeSize()
      self.bg:SetActive(false)
      self.item_quality:SetActive(false)
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
    self.commonItemContainer:SetActive(false)
    self.heroItemContainer:SetActive(true)
    self.heroUuid = self.param.heroUuid
    local heroConfig = LocalController:instance():getLine(HeroUtils.GetHeroXmlName(), self.param.itemId)
    self.heroIcon:LoadSpriteAuto(HeroUtils.GetHeroIconPath(self.param.itemId))
    self.heroBg:LoadSpriteAuto(HeroUtils.GetRarityIconPath(heroConfig.rarity))
    self.heroName:SetText(Localization:GetString(heroConfig.name) .. " x" .. self.param.count)
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
      self:SetItemQualityImage(DataCenter.ItemTemplateManager:GetToolBgByColor(ItemColor.GREEN))
      self:SetItemIconImage(string.format(LoadPath.ItemPath, template.pic))
      self:SetNameText(DataCenter.RewardManager:GetNameByType(self.param.rewardType, self.param.itemId))
    end
  elseif self.param.rewardType == RewardType.Golloes then
    self:SetFlagActive(false)
    self:SetItemQualityImage(DataCenter.ItemTemplateManager:GetToolBgByColor(ItemColor.PURPLE))
    self:SetItemIconImage(string.format("Assets/Main/Sprites/UI/UIGolloesCamp/%s", GolloesShow[self.param.itemId].rewardIcon))
    self:SetNameText(Localization:GetString(GolloesShow[self.param.itemId].name))
  elseif self.param.rewardType == RewardType.EXP then
    self:SetFlagActive(false)
    self:SetItemQualityImage(DataCenter.ItemTemplateManager:GetToolBgByColor(ItemColor.BLUE))
    self:SetItemIconImage(string.format(LoadPath.CommonNewPath, "Common_icon_exp"))
    self:SetNameText(DataCenter.RewardManager:GetNameByType(self.param.rewardType))
  elseif self.param.rewardType == RewardType.TALENT then
    self:SetFlagActive(false)
    local template = DataCenter.TalentTemplateManager:GetTemplate(self.param.itemId)
    self:SetItemQualityImage(DataCenter.ItemTemplateManager:GetToolBgByColor(template.color))
    self:SetItemIconImage(template.icon)
    local nameStr = Localization:GetString("300665", template.lv) .. " " .. template.name
    self:SetNameText(nameStr)
  elseif self.param.rewardType == RewardType.OBSIDIAN then
    self:SetFlagActive(false)
    self:SetItemQualityImage(DataCenter.ItemTemplateManager:GetToolBgByColor(ItemColor.PURPLE))
    self:SetItemIconImage(string.format(LoadPath.LWCommonPath, "Common_icon_recruit_firecrystal"))
    self:SetNameText(Localization:GetString("110353"))
  elseif self.param.rewardType == RewardType.FLINT then
    self:SetFlagActive(false)
    self:SetItemQualityImage(DataCenter.ItemTemplateManager:GetToolBgByColor(ItemColor.PURPLE))
    self:SetItemIconImage(string.format(LoadPath.LWCommonPath, "Common_icon_recruit_massif3"))
    self:SetNameText(Localization:GetString("110353"))
  elseif self.param.rewardType == RewardType.ActGiftBox then
    local template = DataCenter.ActGiftBoxData:GetActBoxInfoByItemId(self.param.itemId)
    self:SetFlagActive(false)
    self:SetItemQualityImage(DataCenter.ItemTemplateManager:GetToolBgByColor(ItemColor.PURPLE))
    self:SetItemIconImage(string.format(LoadPath.UImystery, template.reward_icon))
    self:SetNameText(Localization:GetString(template.reward_name))
    self:SetItemCountActive(false)
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
      UIManager:GetInstance():OpenWindow(UIWindowNames.UIItemTips, {anim = true}, param)
    end
  elseif self.param.rewardType == RewardType.HERO then
    if self.heroUuid ~= nil then
      UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeroDetailPanel, {anim = false}, self.heroUuid, {
        self.heroUuid
      })
    elseif self.param.itemId ~= nil then
      local param = {}
      param.heroId = self.param.itemId
      UIManager:GetInstance():OpenWindow(UIWindowNames.UIShowFakeNewHero, {anim = false}, param)
    end
  end
end

local function SetItemIconImage(self, imageName)
  self.item_icon:SetActive(true)
  self.item_icon:LoadSprite(imageName)
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
    self.flag_go.gameObject:SetActive(value)
  end
end

local function SetFlagText(self, value)
  if self.flagText ~= value then
    self.flagText = value
    self.flag_text:SetText(value)
  end
end

local function SetNameText(self, value)
  if self.nameText ~= value then
    self.nameText = value
    self.name_text:SetText(value)
  end
end

local function Hide(self)
  if self.param.rewardType == RewardType.HERO then
    self.heroItemContainer:SetActive(false)
  else
    self.commonItemContainer:SetActive(false)
  end
end

local function Show(self, doAnim)
  local t
  if doAnim then
    t = 0
  else
    t = 1
  end
  DataCenter.LWSoundManager:PlaySound(SoundAssetId.Music_Effect_Ue_OneGood)
  if self.param.rewardType == RewardType.HERO then
    self.heroItemContainer:SetActive(true)
    self.heroItemAnim:Play("V_ui_jiesuo_wupin", 0, t)
  else
    self.commonItemContainer:SetActive(true)
    self.commonItemAnim:Play("V_ui_jiesuo_wupin", 0, t)
  end
end

UIGiftRewardCell.OnCreate = OnCreate
UIGiftRewardCell.OnDestroy = OnDestroy
UIGiftRewardCell.Param = Param
UIGiftRewardCell.OnBtnClick = OnBtnClick
UIGiftRewardCell.OnEnable = OnEnable
UIGiftRewardCell.OnDisable = OnDisable
UIGiftRewardCell.ComponentDefine = ComponentDefine
UIGiftRewardCell.ComponentDestroy = ComponentDestroy
UIGiftRewardCell.DataDefine = DataDefine
UIGiftRewardCell.DataDestroy = DataDestroy
UIGiftRewardCell.ReInit = ReInit
UIGiftRewardCell.SetItemIconImage = SetItemIconImage
UIGiftRewardCell.SetItemQualityImage = SetItemQualityImage
UIGiftRewardCell.SetItemCountActive = SetItemCountActive
UIGiftRewardCell.SetItemCount = SetItemCount
UIGiftRewardCell.SetFlagActive = SetFlagActive
UIGiftRewardCell.SetFlagText = SetFlagText
UIGiftRewardCell.SetNameText = SetNameText
UIGiftRewardCell.Hide = Hide
UIGiftRewardCell.Show = Show
return UIGiftRewardCell
