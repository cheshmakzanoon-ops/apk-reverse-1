local AllianceCompeteRewardItem = BaseClass("AllianceCompeteRewardItem", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local itemBg_path = "clickBtn/item_bg"
local itemQuality_path = "clickBtn/ImgQuality"
local itemIcon_path = "clickBtn/ItemIcon"
local itemNum_path = "clickBtn/NumText"
local flagGo_path = "clickBtn/FlagGo"
local flagTxt_path = "clickBtn/FlagGo/FlagText"
local clickBtn_path = "clickBtn"

local function OnCreate(self)
  base.OnCreate(self)
  self.itemBgN = self:AddComponent(UIImage, itemBg_path)
  self.itemQualityN = self:AddComponent(UIImage, itemQuality_path)
  self.itemIconN = self:AddComponent(UIImage, itemIcon_path)
  self.itemNumN = self:AddComponent(UIText, itemNum_path)
  self.flagGoN = self:AddComponent(UIBaseContainer, flagGo_path)
  self.flagTxtN = self:AddComponent(UIText, flagTxt_path)
  self.ClickBtn = self:AddComponent(UIButton, clickBtn_path)
  self.ClickBtn:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self:OnClickItemBtn()
  end)
end

local function OnDestroy(self)
  self.itemBgN = nil
  self.itemQualityN = nil
  self.itemIconN = nil
  self.itemNumN = nil
  self.flagGoN = nil
  self.flagTxtN = nil
  self.ClickBtn = nil
  base.OnDestroy(self)
end

local function RefreshDataByParms(self, tempType, tempId, tempCount)
  local reward = {
    rewardType = tempType,
    itemId = tempId,
    count = tempCount
  }
  self:RefreshData(reward)
end

local function RefreshData(self, reward)
  if not reward then
    return
  end
  local iconPath = self:GetIconPath(reward)
  self.itemIconN:LoadSprite(iconPath)
  self.itemNumN:SetText(string.GetFormattedStr(reward.count))
  local goods = DataCenter.ItemTemplateManager:GetItemTemplate(reward.itemId)
  local quality_name = DataCenter.ItemTemplateManager:GetToolBgByColor(goods.color)
  local join_method = -1
  local icon_join
  if goods.join_method ~= nil and goods.join_method > 0 and goods.icon_join ~= nil and goods.icon_join ~= "" then
    join_method = goods.join_method
    icon_join = goods.icon_join
  end
  if 0 < join_method and icon_join ~= nil and icon_join ~= "" then
    local tempJoin = string.split(icon_join, ";")
    if 1 < #tempJoin then
      quality_name = tempJoin[2]
    end
    if 2 < #tempJoin then
      quality_name = tempJoin[3]
    end
  end
  self.itemQualityN:LoadSprite(quality_name)
  local flagtxt = ""
  if goods.type == 2 then
    if goods.para1 ~= nil and goods.para1 ~= "" then
      local para1 = goods.para1
      local temp = string.split(para1, ";")
      if temp ~= nil and 1 < #temp then
        flagtxt = temp[1] .. temp[2]
      end
    end
  elseif goods.type == 3 then
    local type2 = goods.type2
    if type2 ~= 999 and goods.para ~= nil and goods.para ~= "" then
      local res_num = tonumber(goods.para)
      flagtxt = string.GetFormattedStr(res_num)
    end
  end
  if not flagtxt or flagtxt == "" then
    self.flagGoN:SetActive(false)
  else
    self.flagGoN:SetActive(true)
    self.flagTxtN:SetText(flagtxt)
  end
end

local function GetIconPath(self, reward)
  local retIconPath = ""
  if reward.rewardType == RewardType.GOODS then
    if reward.itemId == nil then
      if reward.iconName ~= nil and reward.itemColor ~= nil then
        retIconPath = reward.iconName
      end
    else
      local goods = DataCenter.ItemTemplateManager:GetItemTemplate(reward.itemId)
      if goods ~= nil then
        local join_method = -1
        local icon_join
        if goods.join_method ~= nil and goods.join_method > 0 and goods.icon_join ~= nil and goods.icon_join ~= "" then
          join_method = goods.join_method
          icon_join = goods.icon_join
        end
        if 0 < join_method and icon_join ~= nil and icon_join ~= "" then
          local tempJoin = string.split(icon_join, ";")
          if 1 < #tempJoin then
            retIconPath = tempJoin[2]
          end
          if 2 < #tempJoin then
            retIconPath = tempJoin[3]
          end
        elseif itemType == 9 then
          retIconPath = goods.icon
        else
          retIconPath = string.format(LoadPath.ItemPath, goods.icon)
        end
      else
        local resourceType = tonumber(reward.itemId)
        if resourceType < 100 then
          retIconPath = DataCenter.ResourceManager:GetResourceIconByType(resourceType)
        end
      end
    end
  elseif reward.rewardType == RewardType.GOLD then
    retIconPath = DataCenter.ResourceManager:GetResourceIconByType(ResourceType.Gold)
  elseif reward.rewardType == RewardType.OIL or reward.rewardType == RewardType.METAL or reward.rewardType == RewardType.WATER or reward.rewardType == RewardType.MONEY or reward.rewardType == RewardType.ELECTRICITY then
    retIconPath = DataCenter.RewardManager:GetPicByType(reward.rewardType)
  elseif reward.rewardType == RewardType.ARM then
    local army = DataCenter.ArmyTemplateManager:GetArmyTemplate(reward.itemId)
    if army ~= nil then
      retIconPath = string.format(LoadPath.SoldierIcons, army.icon)
    end
  elseif reward.rewardType == RewardType.HERO then
    local xmlData = LocalController:instance():getLine(HeroUtils.GetHeroXmlName(), reward.itemId)
    if xmlData ~= nil then
      retIconPath = xmlData.hero_icon
    end
  elseif reward.rewardType == RewardType.HONOR or reward.rewardType == RewardType.ALLIANCE_POINT then
    retIconPath = DataCenter.RewardManager:GetPicByType(reward.rewardType, reward.itemId)
  elseif reward.rewardType == RewardType.MATERIAL then
    local goods = DataCenter.ItemTemplateManager:GetItemTemplate(reward.itemId)
    if goods ~= nil then
      retIconPath = goods.icon
    end
  elseif reward.rewardType == RewardType.RESOURCE_ITEM then
    local template = DataCenter.ResourceItemDataManager:GetResourceItemTemplate(reward.itemId)
    if template ~= nil then
      retIconPath = string.format(LoadPath.ItemPath, template.pic)
    end
  end
  return retIconPath
end

local function OnClickItemBtn(self)
end

AllianceCompeteRewardItem.OnCreate = OnCreate
AllianceCompeteRewardItem.OnDestroy = OnDestroy
AllianceCompeteRewardItem.RefreshData = RefreshData
AllianceCompeteRewardItem.GetIconPath = GetIconPath
AllianceCompeteRewardItem.RefreshDataByParms = RefreshDataByParms
AllianceCompeteRewardItem.OnClickItemBtn = OnClickItemBtn
return AllianceCompeteRewardItem
