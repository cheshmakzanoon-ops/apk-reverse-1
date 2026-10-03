local UICommonResItem = BaseClass("UICommonResItem", UIBaseContainer)
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
  itemDesc,
  enableClick
}
local item_bg_path = "clickBtn/item_bg"
local hero_quality_path = "clickBtn/HeroQuality"
local item_quality_path = "clickBtn/ImgQuality"
local item_icon_path = "clickBtn/ItemIcon"
local num_text_path = "clickBtn/NumText"
local flag_path = "clickBtn/FlagGo"
local flag_text_path = "clickBtn/FlagGo/FlagText"
local this_path = "clickBtn"
local name_text_path = "clickBtn/NameText"
local hero_debris_path = "clickBtn/HeroDebris"
local extra_path = "clickBtn/ImgExtra"
local rarity_path = "clickBtn/ImgRarity"
local camp_path = "clickBtn/ImgCamp"
local delete_path = "delete"
local img_arrow_path = "clickBtn/Img_Arrow"
local img_extra_mark_path = "Img_ExtraMark"
local img_recapture_mark_path = "Img_RecaptureMark"
local double_mark_path = "DoubleMark"
local img_rece_path = "clickBtn/ImgRece"

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
  self.seasonType = nil
  self.item_bg = self:AddComponent(UIImage, item_bg_path)
  self.hero_quality = self:AddComponent(UIImage, hero_quality_path)
  self.item_quality = self:AddComponent(UIImage, item_quality_path)
  self.item_icon = self:AddComponent(UIImage, item_icon_path)
  self.num_text = self:AddComponent(UIText, num_text_path)
  self.flag_text = self:AddComponent(UIText, flag_text_path)
  self.btn = self:AddComponent(UIButton, this_path)
  self.name_text = self:AddComponent(UIText, name_text_path)
  self.flag = self:AddComponent(UIBaseContainer, flag_path)
  self.nodeHeroDebris = self:AddComponent(UIBaseContainer, hero_debris_path)
  self.imgExtra = self:AddComponent(UIImage, extra_path)
  self.imgRarity = self:AddComponent(UIImage, rarity_path)
  self.imgCamp = self:AddComponent(UIImage, camp_path)
  self.btn:SetOnClick(function()
    self:OnBtnClick()
  end)
  if not IsNull(self.transform:Find(delete_path)) then
    self.delete = self:AddComponent(UIBaseComponent, delete_path)
    self.canvasGroup = self:AddComponent(UICanvasGroup, this_path)
    self:SetDelete(false)
  end
  if not IsNull(self.transform:Find(img_arrow_path)) then
    self.img_arrow = self:AddComponent(UIImage, img_arrow_path)
    self:SetArrowState(false)
  end
  if not IsNull(self.transform:Find(img_extra_mark_path)) then
    self.img_extra_mark = self:AddComponent(UIImage, img_extra_mark_path)
    self.img_extra_mark:SetActive(false)
  end
  if not IsNull(self.transform:Find(img_recapture_mark_path)) then
    self.img_recapture_mark = self:AddComponent(UIImage, img_recapture_mark_path)
    self.img_recapture_mark:SetActive(false)
  end
  if not IsNull(self.transform:Find(double_mark_path)) then
    self.double_mark = self:AddComponent(UIImage, double_mark_path)
    self.double_mark:SetActive(false)
  end
  self.rece_flag = self:AddComponent(UIBaseContainer, img_rece_path)
end

local function ComponentDestroy(self)
  self.seasonType = nil
  self.item_bg = nil
  self.hero_quality = nil
  self.item_quality = nil
  self.item_icon = nil
  self.num_text = nil
  self.flag_text = nil
  self.btn = nil
  self.flag = nil
  self.name_text = nil
  self.nodeHeroDebris = nil
  self.imgExtra = nil
  self.imgRarity = nil
  self.imgCamp = nil
  self.delete = nil
  self.canvasGroup = nil
  self.img_arrow = nil
  if self.eff then
    self.eff:Destroy()
    self.eff = nil
  end
end

local function DataDefine(self)
  self.param = {}
  self.flagText = nil
  self.flagActive = nil
  self.itemCount = nil
  self.itemCountActive = nil
  self.nameText = nil
  self.tweenSeq = nil
end

local function DataDestroy(self)
  self.param = nil
  self.flagText = nil
  self.flagActive = nil
  self.itemCount = nil
  self.itemCountActive = nil
  self.nameText = nil
  self:CloseTweenSeq()
end

local function CloseTweenSeq(self)
  if self.tweenSeq then
    self.tweenSeq:Kill()
    self.tweenSeq = nil
  end
end

local function ConvertGiftBoxQuality(quality)
  if quality == 1 or quality == 6 then
    return ItemColor.GREEN
  elseif quality == 2 then
    return ItemColor.BLUE
  elseif quality == 3 then
    return ItemColor.PURPLE
  elseif quality == 4 then
    return ItemColor.ORANGE
  elseif quality == 5 then
    return ItemColor.GOLDEN
  end
end

local function ReInit(self, param)
  self.param = param
  if param.isDelete then
    self:SetDelete(true)
  end
  if self.param.count == nil then
    self:SetItemCountActive(false)
  else
    self:SetItemCountActive(true)
    if self.param.rewardType == RewardType.GOODS and self.param.itemId ~= nil then
      local goods = DataCenter.ItemTemplateManager:GetItemTemplate(self.param.itemId)
      if goods and goods.type == GOODS_TYPE.GOODS_TYPE_146 then
        local countStr = string.GetFormattedStr2(self.param.count)
        self:SetItemCount(countStr)
      else
        self:SetItemCount(self.param.count)
      end
    else
      self:SetItemCount(self.param.count)
    end
  end
  self.nodeHeroDebris:SetActive(false)
  self.imgExtra:SetActive(false)
  self.imgRarity:SetActive(false)
  self.imgCamp:SetActive(false)
  self:SetItemCountColor(WhiteColor)
  self:SetDoubleMark(false)
  self:SetArrowState(false)
  self.rece_flag:SetActive(self.param.isShowReceFlag and self.param.isShowReceFlag == true)
  if self.param.isShowArrow then
    self:SetArrowState(true)
    self:SetItemCountColor(EffectGreenColor)
  end
  if self.param.trainRewardState then
    self:SetRewardMarkState(self.param.trainRewardState)
  end
  if self.param.isShowDoubleMark then
    self:SetDoubleMark(self.param.isShowDoubleMark)
  end
  if self.param.enableClick == nil then
    self.canClick = true
  else
    self.canClick = self.param.enableClick
  end
  if self.param.rewardType == nil then
    self:SetFlagActive(false)
    self.item_bg:SetActive(false)
    self.item_quality:SetActive(false)
    self.hero_quality:SetActive(false)
    self:SetItemIconImage(string.format(LoadPath.CommonNewPath, self.param.itemIcon))
  else
    self.item_bg:SetActive(true)
    self.item_quality:SetActive(true)
    self.hero_quality:SetActive(false)
    if self.param.rewardType == RewardType.GOODS then
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
    elseif self.param.rewardType == RewardType.OIL or self.param.rewardType == RewardType.METAL or self.param.rewardType == RewardType.Wood or self.param.rewardType == RewardType.WATER or self.param.rewardType == RewardType.FOOD or self.param.rewardType == RewardType.ELECTRICITY or self.param.rewardType == RewardType.PVE_POINT or self.param.rewardType == RewardType.DETECT_EVENT or self.param.rewardType == RewardType.WOOD or self.param.rewardType == RewardType.FLINT or self.param.rewardType == RewardType.OBSIDIAN or self.param.rewardType == RewardType.AllianceCoal or self.param.rewardType == RewardType.AllianceStone or self.param.rewardType == RewardType.AllianceFarmerExp or self.param.rewardType == RewardType.FORMATION_STAMINA or self.param.rewardType == RewardType.PVE_ACT_SCORE then
      self:SetFlagActive(false)
      self:SetItemIconImage(DataCenter.RewardManager:GetPicByType(self.param.rewardType))
      self:SetItemQualityImage(DataCenter.ItemTemplateManager:GetToolBgByColor(ItemColor.WHITE))
      self:SetNameText(DataCenter.RewardManager:GetNameByType(self.param.rewardType))
    elseif self.param.rewardType == RewardType.ARM then
      self:SetFlagActive(false)
      local army = DataCenter.ArmyTemplateManager:GetArmyTemplate(self.param.itemId)
      if army ~= nil then
        self:SetItemIconImage(string.format(LoadPath.SoldierIcons, army.icon))
        self:SetItemQualityImage(DataCenter.ItemTemplateManager:GetToolBgByColor(ItemColor.WHITE))
        self:SetNameText(Localization:GetString(army.name))
      end
    elseif self.param.rewardType == RewardType.DragonWorldPoint then
      self:SetFlagActive(false)
      self:SetItemIconImage(DataCenter.RewardManager:GetPicByType(self.param.rewardType))
      self:SetItemQualityImage(DataCenter.ItemTemplateManager:GetToolBgByColor(ItemColor.ORANGE))
      self:SetNameText(DataCenter.RewardManager:GetNameByType(self.param.rewardType))
    elseif self.param.rewardType == RewardType.EQUIP then
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
    elseif self.param.rewardType == RewardType.HERO then
      self:SetFlagActive(false)
      self:SetItemIconImage(DataCenter.RewardManager:GetPicByType(tonumber(self.param.rewardType), tonumber(self.param.itemId)))
      self:SetItemQualityImage(DataCenter.RewardManager:GetRewardQualityBg(tonumber(self.param.rewardType), tonumber(self.param.itemId)))
      self:SetNameText(DataCenter.RewardManager:GetNameByType(tonumber(self.param.rewardType), tonumber(self.param.itemId)))
    elseif self.param.rewardType == RewardType.HONOR or self.param.rewardType == RewardType.ALLIANCE_POINT then
      self:SetFlagActive(false)
      self:SetItemIconImage(DataCenter.RewardManager:GetPicByType(self.param.rewardType, self.param.itemId))
      self:SetNameText(DataCenter.RewardManager:GetNameByType(self.param.rewardType, self.param.itemId))
    elseif self.param.rewardType == RewardType.RESOURCE_ITEM then
      self:SetFlagActive(false)
      self:SetItemIconImage(DataCenter.RewardManager:GetPicByType(tonumber(self.param.rewardType), tonumber(self.param.itemId)))
      self:SetItemQualityImage(DataCenter.RewardManager:GetRewardQualityBg(tonumber(self.param.rewardType), tonumber(self.param.itemId)))
      self:SetNameText(DataCenter.RewardManager:GetNameByType(tonumber(self.param.rewardType), tonumber(self.param.itemId)))
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
    elseif self.param.rewardType == RewardType.UnlockModule then
      self:SetFlagActive(false)
      self.item_bg:SetActive(false)
      self.item_quality:SetActive(false)
      self.hero_quality:SetActive(false)
      self:SetItemIconImage(string.format(LoadPath.CommonNewPath, self.param.itemIcon))
    elseif self.param.rewardType == RewardType.HERO_EXP then
      self:SetFlagActive(false)
      self:SetItemQualityImage(DataCenter.ItemTemplateManager:GetToolBgByColor(ItemColor.GREEN))
      self:SetItemIconImage(string.format(LoadPath.CommonNewPath, "Common_icon_hero_exp"))
      self:SetNameText(DataCenter.RewardManager:GetNameByType(self.param.rewardType))
    elseif self.param.rewardType == RewardType.WORKER then
      self:SetFlagActive(false)
      self:SetItemQualityImage(DataCenter.RewardManager:GetRewardQualityBg(self.param.rewardType, self.param.itemId))
      self:SetItemIconImage(DataCenter.RewardManager:GetPicByType(self.param.rewardType, self.param.itemId))
      self:SetNameText(DataCenter.RewardManager:GetNameByType(self.param.rewardType, self.param.itemId))
    elseif self.param.rewardType == RewardType.VISITOR then
      self:SetFlagActive(false)
      if self.param.itemId then
        self:SetItemQualityImage(DataCenter.RewardManager:GetRewardQualityBg(self.param.rewardType, self.param.itemId))
        self:SetItemIconImage(DataCenter.RewardManager:GetPicByType(self.param.rewardType, self.param.itemId))
        self:SetNameText(DataCenter.RewardManager:GetNameByType(self.param.rewardType, self.param.itemId))
      elseif self.param.count then
        self:SetItemQualityImage(DataCenter.RewardManager:GetRewardQualityBg(self.param.rewardType, self.param.count.itemId))
        self:SetItemIconImage(DataCenter.RewardManager:GetPicByType(self.param.rewardType, self.param.count.itemId))
      end
    elseif self.param.rewardType == RewardType.RESOURCE then
      self:SetFlagActive(false)
      self:SetItemQualityImage(DataCenter.RewardManager:GetRewardQualityBg(tonumber(self.param.rewardType), tonumber(self.param.itemId)))
      self:SetItemIconImage(DataCenter.ResourceManager:GetResourceIconByType(self.param.itemId))
    elseif self.param.rewardType == RewardType.BATTLE_PASS then
      self:SetFlagActive(false)
      self:SetItemQualityImage(DataCenter.RewardManager:GetRewardQualityBg(self.param.rewardType, self.param.itemId))
      self:SetItemIconImage(DataCenter.RewardManager:GetPicByType(self.param.rewardType, self.param.itemId))
      self:SetNameText("")
    elseif self.param.rewardType == RewardType.MonthCard then
      self:SetFlagActive(false)
      self:SetItemQualityImage(DataCenter.ItemTemplateManager:GetToolBgByColor(ItemColor.PURPLE))
      self:SetItemIconImage("Assets/Main/Sprites/GiftPackageIcons/lyp_yueka_xuanzhong.png")
    elseif self.param.rewardType == RewardType.CommonEquip then
      self:SetItemIconImage(DataCenter.RewardManager:GetPicByType(tonumber(self.param.rewardType), tonumber(self.param.itemId)))
      self:SetItemQualityImage(DataCenter.RewardManager:GetRewardQualityBg(tonumber(self.param.rewardType), tonumber(self.param.itemId)))
      self:SetNameText(DataCenter.RewardManager:GetNameByType(tonumber(self.param.rewardType), tonumber(self.param.itemId)))
      local flagText = DataCenter.RewardManager:GetFlagText(RewardType.CommonEquip, self.param.itemId)
      if string.IsNullOrEmpty(flagText) then
        self:SetFlagActive(false)
      else
        self:SetFlagActive(true)
        self:SetFlagText(flagText)
      end
    elseif self.param.rewardType == RewardType.DecorateBuild then
      self:SetFlagActive(false)
      local buildData = DataCenter.BuildManager:GetBuildingDataByUuid(self.param.bUuid)
      if buildData then
        local level = buildData.level
        if 0 < level then
          self:SetFlagText(string.format("Lv.%d", level))
          self:SetFlagActive(true)
        else
          self:SetFlagActive(false)
        end
      end
      self:SetItemIconImage(DataCenter.BuildManager:GetBuildIconPath(param.itemId, 1))
      self:SetItemQualityImage(HeroUtils.GetQualityIconPath(BuildingUtils.GetDecorateColor(self.param.itemId, true), false))
      local buildTemp = DataCenter.BuildTemplateManager:GetBuildingDesTemplate(self.param.itemId)
      self:SetNameText(Localization:GetString(buildTemp.name))
    elseif self.param.rewardType == RewardType.ActGiftBox then
      local template = DataCenter.ActGiftBoxData:GetActBoxInfoByItemId(self.param.itemId)
      self:SetFlagActive(false)
      self:SetItemQualityImage(DataCenter.ItemTemplateManager:GetToolBgByColor(ConvertGiftBoxQuality(toInt(template.quality))))
      self:SetItemIconImage(string.format(LoadPath.UImystery, template.reward_icon))
      self:SetNameText(Localization:GetString(template.reward_name))
      self:SetItemCountActive(false)
    elseif self.param.rewardType == RewardType.PartyMonster then
      local template = DataCenter.ActivityPartyMonsterTemplateManager:GetTemplate(self.param.itemId)
      if template then
        self:SetFlagActive(false)
        self:SetItemCountActive(false)
        self:SetItemIconImage(string.format(LoadPath.PartyMonsterSpritePath, template.pic_name))
        self:SetItemQualityImage(DataCenter.ItemTemplateManager:GetToolBgByColor(ConvertGiftBoxQuality(template.quality)))
      end
    else
      self:SetFlagActive(false)
      if self.param.itemColor then
        self:SetItemQualityImage(DataCenter.ItemTemplateManager:GetToolBgByColor(self.param.itemColor))
      else
        self:SetItemQualityImage(DataCenter.RewardManager:GetRewardQualityBg(self.param.rewardType, self.param.itemId))
      end
      if self.param.iconName then
        self:SetItemIconImage(self.param.iconName)
      else
        self:SetItemIconImage(DataCenter.RewardManager:GetPicByType(self.param.rewardType, self.param.itemId))
      end
      if self.param.itemName then
        self:SetNameText(self.param.itemName)
      else
        self:SetNameText(DataCenter.RewardManager:GetNameByType(self.param.rewardType, self.param.itemId))
      end
    end
  end
end

function UICommonResItem:ParseInfo(info)
  local item = DataCenter.RewardManager:ParseRewardInfo(info)
  if item then
    self:ReInit(item)
  end
  return item
end

local function OnBtnClick(self)
  if self.canClick ~= nil and self.canClick == false then
    return
  end
  if self.param.clickCallBack ~= nil then
    self.param.clickCallBack(self.param)
    return
  end
  if self.param.rewardType == RewardType.GOODS then
    if self.param.itemId ~= nil then
      local goods = DataCenter.ItemTemplateManager:GetItemTemplate(self.param.itemId)
      local type = goods.type
      local type2 = goods.type2
      local tipsType = goods.tipsType
      if type2 == GOODS_TYPE2.DecoratorItem then
        local buildingId = tonumber(goods.para2)
        local baseBuildingId = CommonUtil.GetBuildBaseType(buildingId)
        local param = {}
        param.baseBuildingId = baseBuildingId
        param.alignObject = self.item_icon
        UIManager:GetInstance():OpenWindow(UIWindowNames.LWDecorationBookProperty, {anim = true}, param)
      elseif type == GOODS_TYPE.GOODS_TYPE_138 then
        UIManager:GetInstance():OpenWindow(UIWindowNames.UIDecorationChoiceBox, {anim = true}, self.param.itemId, true)
      elseif type == GOODS_TYPE.GOODS_TYPE_113 then
        local para5Num = tonumber(goods.para5) or 0
        if 0 < para5Num then
          UIUtil.OpenDecorationPrevieView(goods.para1, goods.id)
        else
          local param = {}
          param.itemId = self.param.itemId
          param.alignObject = self.item_icon
          param.hideHaveCountShow = self.param.hideHaveCountShow
          UIManager:GetInstance():OpenWindow(UIWindowNames.UIItemTips, {anim = true}, param)
        end
      elseif tipsType == GOODS_TIPS_TYPE.Box or tipsType == GOODS_TIPS_TYPE.BoxWithoutProbability or tipsType == GOODS_TIPS_TYPE.BoxTag then
        local param = {}
        param.itemId = self.param.itemId
        param.alignObject = self.item_icon
        param.showArrow = true
        UIManager:GetInstance():OpenWindow(UIWindowNames.UIBoxItemTips, {anim = true}, param)
      elseif tipsType == GOODS_TIPS_TYPE.BoxTacticalCard then
        local param = {}
        param.itemId = self.param.itemId
        param.alignObject = self.item_icon
        param.showArrow = true
        UIManager:GetInstance():OpenWindow(UIWindowNames.UITCCardChoiceBoxTips, {anim = true}, param)
      else
        local param = {}
        param.itemId = self.param.itemId
        param.alignObject = self.item_icon
        param.hideHaveCountShow = self.param.hideHaveCountShow
        param.showUse = self.param.showUse
        UIManager:GetInstance():OpenWindow(UIWindowNames.UIItemTips, {anim = true}, param)
      end
    elseif self.param.iconName ~= nil then
      local param = {}
      param.itemName = self.param.itemName
      param.itemDesc = self.param.itemDesc
      param.alignObject = self.item_icon
      param.showUse = self.param.showUse
      UIManager:GetInstance():OpenWindow(UIWindowNames.UIItemTips, {anim = true}, param)
    end
  elseif self.param.rewardType == RewardType.HERO then
    local heroId = self.param.itemId
    local heroWindow = UIManager:GetInstance():GetWindow(UIWindowNames.UIHeroDetailPanel)
    if not heroWindow then
      UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeroDetailPanel, {anim = false}, heroId, {heroId})
    end
  elseif self.param.rewardType == RewardType.UnlockModule then
    local param = {}
    param.itemName = self.param.itemName
    param.itemDesc = self.param.itemDesc
    param.alignObject = self.item_icon
    param.isLocal = false
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIItemTips, {anim = true}, param)
  elseif self.param.rewardType == RewardType.RESOURCE then
    local param = {}
    param.itemId = self.param.itemId
    param.alignObject = self.item_icon
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIItemTips, {anim = true}, param)
  elseif self.param.rewardType == RewardType.RESOURCE_ITEM then
    local desc = ""
    local name = ""
    if string.IsNullOrEmpty(self.param.itemName) then
      desc = DataCenter.RewardManager:GetDescByType(self.param.rewardType, self.param.itemId)
      name = DataCenter.RewardManager:GetNameByType(self.param.rewardType, self.param.itemId)
    elseif self.param.isLocal then
      desc = self.param.itemDesc
      name = self.param.itemName
    else
      desc = Localization:GetString(self.param.itemDesc)
      name = Localization:GetString(self.param.itemName)
    end
    if string.IsNullOrEmpty(desc) and string.IsNullOrEmpty(name) then
      return
    end
    if self.fetchMummyDesc then
      if self.theSoldierType == SoldierType.Player then
        name = Localization:GetString("season_s3_Mummy_ui_info03")
      elseif self.theSoldierType == SoldierType.Mummy then
        name = Localization:GetString("season_s3_soilder_Mummy")
      end
    end
    local param = {}
    param.rewardType = RewardType.RESOURCE_ITEM
    param.itemId = self.param.itemId
    param.itemName = name
    param.itemDesc = desc
    param.alignObject = self.item_icon
    if self.fetchMummyDesc then
      param.fetchMummyDesc = true
      param.theSoldierType = self.theSoldierType
      param.hasCount = self.param.count or 0
    end
    param.isLocal = true
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIItemTips, {anim = true}, param)
  elseif self.param.rewardType == RewardType.GOLD then
    local desc = DataCenter.RewardManager:GetDescByType(self.param.rewardType, self.param.itemId)
    local name = DataCenter.RewardManager:GetNameByType(self.param.rewardType, self.param.itemId)
    if string.IsNullOrEmpty(desc) and string.IsNullOrEmpty(name) then
      return
    end
    local param = {}
    param.rewardType = RewardType.GOLD
    param.itemName = name
    param.itemDesc = desc
    param.alignObject = self.item_icon
    param.isLocal = true
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIItemTips, {anim = true}, param)
  elseif self.param.rewardType == RewardType.TWSkillChip then
    local chipInfo
    if self.param.uuid then
      chipInfo = DataCenter.TWSkillChipManager:GetChipInfo(self.param.uuid)
    end
    if not chipInfo then
      chipInfo = TWSkillChipInfo.New()
      chipInfo:CreateFromTemplate(self.param.itemId, 1, 0)
    end
    if chipInfo then
      UIManager:GetInstance():OpenWindow(UIWindowNames.UILWTWSkillChipDetail, {anim = true}, chipInfo)
    end
  elseif self.param.rewardType == RewardType.ALLIANCE_GIFT then
    local desc = ""
    local name = ""
    if self.param.isLocal then
      desc = self.param.itemDesc
      name = self.param.itemName
    else
      desc = Localization:GetString(self.param.itemDesc)
      name = Localization:GetString(self.param.itemName)
    end
    if string.IsNullOrEmpty(desc) and string.IsNullOrEmpty(name) then
      return
    end
    local param = {}
    param.itemName = name
    param.itemDesc = desc
    param.alignObject = self.item_icon
    param.rewardType = self.param.rewardType
    param.itemColor = self.param.itemColor
    param.isLocal = true
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIItemTips, {anim = true}, param)
  elseif self.param.rewardType == RewardType.DecorateBuild then
    local buildTemp = DataCenter.BuildTemplateManager:GetBuildingDesTemplate(self.param.itemId)
    if buildTemp ~= nil then
      local param = {}
      param.baseBuildingId = buildTemp.id - buildTemp.id % BuildLevelCap
      param.alignObject = self.item_icon
      UIManager:GetInstance():OpenWindow(UIWindowNames.LWDecorationBookProperty, {anim = false}, param)
    end
  else
    local desc = ""
    local name = ""
    if string.IsNullOrEmpty(self.param.itemName) then
      desc = DataCenter.RewardManager:GetDescByType(self.param.rewardType, self.param.itemId)
      name = DataCenter.RewardManager:GetNameByType(self.param.rewardType, self.param.itemId)
    elseif self.param.isLocal then
      desc = self.param.itemDesc
      name = self.param.itemName
    else
      desc = Localization:GetString(self.param.itemDesc)
      name = Localization:GetString(self.param.itemName)
    end
    if string.IsNullOrEmpty(desc) and string.IsNullOrEmpty(name) then
      return
    end
    local param = {}
    param.itemName = name
    param.itemDesc = desc
    param.alignObject = self.item_icon
    param.isLocal = true
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIItemTips, {anim = true}, param)
  end
  if self.param.clickAfterCallBack ~= nil then
    self.param.clickAfterCallBack(self.param)
  end
end

local function SetItemIconImage(self, imageName)
  self.item_icon:LoadSpriteAuto(imageName)
end

local function SetItemQualityImage(self, imageName)
  self.qualityIndex = 1
  if imageName then
    if string.endswith(imageName, ".png") then
      local num = string.match(imageName, "%d+")
      if num then
        self.qualityIndex = toInt(num)
      end
    end
    self.item_quality:LoadSprite(imageName)
  end
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
    if type(value) == "number" then
      self.num_text:SetText(string.GetFormattedStr(value))
    else
      self.num_text:SetText(value)
    end
    if self.num_text and not self.num_text:HasTextComponent() then
      Logger.LogError("commonresitem lost textComponent")
    end
  end
end

local function SetItemCountColor(self, value)
  self.num_text:SetColor(value)
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

local function SetNameText(self, value, minSize, maxSize)
  if self.nameText ~= value then
    self.nameText = value
    self.name_text:SetText(value)
  end
  if minSize then
    self.name_text:SetBestFitMinSize(minSize)
  else
    self.name_text:SetBestFitMinSize(12)
  end
  if maxSize then
    self.name_text:SetBestFitMaxSize(maxSize)
  else
    self.name_text:SetBestFitMaxSize(20)
  end
end

local function GetResName(self)
  return self.nameText and self.nameText or ""
end

local function GetPosition(self)
  return self.btn.rectTransform.position
end

local function SetGray(self, isGray, canClick)
  CS.UIGray.SetGray(self.hero_quality.transform, isGray, canClick)
  CS.UIGray.SetGray(self.item_quality.transform, isGray, canClick)
  CS.UIGray.SetGray(self.item_icon.transform, isGray, canClick)
end

local function SetDelete(self, bool)
  if self.delete then
    self.delete:SetActive(bool)
  end
  if self.canvasGroup then
    self.canvasGroup:SetAlpha(bool and 0.4 or 1)
  end
end

local function ShowResAdvance(self)
  if self.itemCount then
    if type(self.itemCount) == "number" then
      self.num_text:SetText(string.format("<color=#5fef87>%s</color>", string.GetFormattedStr(self.itemCount)))
    else
      self.num_text:SetText(string.format("<color=#5fef87>%s</color>", self.itemCount))
    end
  end
end

local function SetArrowState(self, show)
  if self.img_arrow then
    self.img_arrow:SetActive(show)
    self:CloseTweenSeq()
    if show then
      self.img_arrow:SetLocalScaleXYZ(0.9, 0.9, 0.9)
      self.img_arrow.transform.localPosition = Vector3.New(-38, 38)
      self.tweenSeq = DOTween.Sequence()
      self.tweenSeq:AppendInterval(0.1)
      self.tweenSeq:Append(self.img_arrow.transform:DOLocalMoveY(48, 0.3)):SetLoops(-1, CS.DG.Tweening.LoopType.Yoyo)
    end
  end
end

local function SetRewardMarkState(self, trainRewardState)
  if self.img_extra_mark then
    self.img_extra_mark:SetActive(trainRewardState == TrainRewardState.Extra)
  end
  if self.img_recapture_mark then
    self.img_recapture_mark:SetActive(trainRewardState == TrainRewardState.Recapture)
  end
end

local function SetDoubleMark(self, state)
  if self.double_mark then
    self.double_mark:SetActive(state)
  end
end

local function ShowMultiMark(self, multiVal)
  if multiVal and 1 < multiVal then
    self:SetDoubleMark(true)
  end
end

local function HideMultiMark(self)
  self:SetDoubleMark(false)
end

local function SetImgQuailtyShow(self, show)
  if self.item_quality then
    self.item_quality:SetActive(show)
  end
end

function UICommonResItem:SetSeasonType(seasonType)
  self.seasonType = seasonType
  if self.commonResItem ~= nil and type(self.commonResItem.SetSeasonType) == "function" then
    self.commonResItem:SetSeasonType(seasonType)
  end
end

function UICommonResItem:SetItemCountActiveIgnoreStatus(active)
  if self.num_text then
    self.num_text.gameObject:SetActive(active)
  end
end

UICommonResItem.OnCreate = OnCreate
UICommonResItem.OnDestroy = OnDestroy
UICommonResItem.Param = Param
UICommonResItem.OnBtnClick = OnBtnClick
UICommonResItem.OnEnable = OnEnable
UICommonResItem.OnDisable = OnDisable
UICommonResItem.ComponentDefine = ComponentDefine
UICommonResItem.ComponentDestroy = ComponentDestroy
UICommonResItem.DataDefine = DataDefine
UICommonResItem.DataDestroy = DataDestroy
UICommonResItem.ReInit = ReInit
UICommonResItem.SetItemIconImage = SetItemIconImage
UICommonResItem.SetItemQualityImage = SetItemQualityImage
UICommonResItem.SetItemCountActive = SetItemCountActive
UICommonResItem.SetItemCount = SetItemCount
UICommonResItem.SetItemCountColor = SetItemCountColor
UICommonResItem.SetFlagActive = SetFlagActive
UICommonResItem.SetFlagText = SetFlagText
UICommonResItem.SetNameText = SetNameText
UICommonResItem.GetPosition = GetPosition
UICommonResItem.GetResName = GetResName
UICommonResItem.SetGray = SetGray
UICommonResItem.SetDelete = SetDelete
UICommonResItem.ShowResAdvance = ShowResAdvance
UICommonResItem.SetArrowState = SetArrowState
UICommonResItem.SetRewardMarkState = SetRewardMarkState
UICommonResItem.CloseTweenSeq = CloseTweenSeq
UICommonResItem.SetDoubleMark = SetDoubleMark
UICommonResItem.SetImgQuailtyShow = SetImgQuailtyShow
UICommonResItem.ShowMultiMark = ShowMultiMark
UICommonResItem.HideMultiMark = HideMultiMark
return UICommonResItem
