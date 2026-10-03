local MailRewardItem = BaseClass("MailRewardItem", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local item_bg_path = "clickBtn/item_bg"
local item_quality_path = "clickBtn/ImgQuality"
local item_icon_path = "clickBtn/ItemIcon"
local num_text_path = "clickBtn/NumText"
local name_text_path = "clickBtn/NameText"
local flag_text_path = "clickBtn/FlagGo/FlagText"
local flag_obj_path = "clickBtn/FlagGo"
local btn_path = "clickBtn"
local extra_path = "clickBtn/ImgExtra"
local hero_quality_path = "clickBtn/HeroQuality"
local select_path = "clickBtn/select"
local rece_img_path = "clickBtn/ImgRece"
local rarity_img_path = "clickBtn/ImgRarity"
local camp_img_path = "clickBtn/ImgCamp"
local redDot_img_path = "clickBtn/redDot"
local hero_debris_path = "clickBtn/HeroDebris"

local function OnCreate(self)
  base.OnCreate(self)
  self.item_bg = self:AddComponent(UIBaseContainer, item_bg_path)
  self.item_quality = self:AddComponent(UIImage, item_quality_path)
  self.item_icon = self:AddComponent(UIImage, item_icon_path)
  self.num_text = self:AddComponent(UIText, num_text_path)
  self.name_text = self:AddComponent(UIText, name_text_path)
  self.flag_text = self:AddComponent(UIText, flag_text_path)
  self.objFlag = self:AddComponent(UIBaseContainer, flag_obj_path)
  self.btn = self:AddComponent(UIButton, btn_path)
  self.imgExtra = self:AddComponent(UIImage, extra_path)
  self.btn:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self:OnBtnClick()
  end)
  self.nodeHeroDebris = self:AddComponent(UIBaseContainer, hero_debris_path)
  self.nodeHeroDebris:SetActive(false)
  self.hero_quality = self:AddComponent(UIImage, hero_quality_path)
  self.select = self:AddComponent(UIImage, select_path)
  self.rece_img = self:AddComponent(UIImage, rece_img_path)
  self.rarity_img = self:AddComponent(UIImage, rarity_img_path)
  self.camp_img = self:AddComponent(UIImage, camp_img_path)
  self.redDot_img = self:AddComponent(UIImage, redDot_img_path)
end

local function OnDestroy(self)
  self.item_bg = nil
  self.item_quality = nil
  self.item_icon = nil
  self.num_text = nil
  self.name_text = nil
  self.flag_text = nil
  self.btn = nil
  self.param = nil
  self.nodeHeroDebris = nil
  self.hero_quality = nil
  self.select = nil
  self.rece_img = nil
  self.rarity_img = nil
  self.camp_img = nil
  self.redDot_img = nil
  base.OnDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function RefreshData(self, data, hideName)
  self.param = data
  local itemId = data.itemId
  local count = tonumber(data.count)
  count = count < 0 and "" or count
  local rewardType = data.rewardType
  local resourceType = data.resourceType
  if rewardType == nil and resourceType == nil then
    return
  end
  self.imgExtra:SetActive(false)
  self.item_bg:SetActive(false)
  self.nodeHeroDebris:SetActive(false)
  self.hero_quality:SetActive(false)
  self.select:SetActive(false)
  self.rece_img:SetActive(false)
  self.rarity_img:SetActive(false)
  self.camp_img:SetActive(false)
  self.redDot_img:SetActive(false)
  self.item_icon:SetActive(true)
  self.item_quality:SetActive(false)
  if resourceType ~= nil then
    self.objFlag:SetActive(false)
    self.item_icon:LoadSprite(DataCenter.ResourceManager:GetResourceIconByType(self.param.resourceType))
    self.name_text:SetText(DataCenter.ResourceManager:GetResourceNameByType(self.param.resourceType))
    self.num_text:SetText(string.GetFormattedSeperatorNum(math.floor(count)))
    self.name_text:SetActive(false)
    return
  end
  self.item_icon:LoadSprite(DataCenter.RewardManager:GetPicByType(rewardType, itemId))
  self.name_text:SetText(DataCenter.RewardManager:GetNameByType(rewardType, itemId))
  if rewardType == RewardType.GOODS then
    local goods = DataCenter.ItemTemplateManager:GetItemTemplate(itemId)
    if goods == nil then
      return
    end
    self.num_text:SetText(string.GetFormattedSeperatorNum(math.floor(count)))
    local itemColor = DataCenter.ItemTemplateManager:GetToolBgByColor(goods.color)
    self.item_bg:SetActive(true)
    self.item_quality:SetActive(true)
    self.item_quality:LoadSprite(itemColor)
    self.name_text:SetActive(true)
    local itemFlag = ""
    local itemType = goods.type
    if itemType == 2 then
      if goods.para1 ~= nil and goods.para1 ~= "" then
        local para1 = goods.para1
        local temp = string.split(para1, ";")
        if temp ~= nil and 1 < #temp then
          itemFlag = temp[1] .. temp[2]
        end
      end
    elseif itemType == GOODS_TYPE.GOODS_TYPE_110 then
      if goods.para2 ~= nil and goods.para2 ~= "" then
        local res_num = tonumber(goods.para2)
        itemFlag = string.GetFormattedStr(res_num)
      end
    elseif itemType == 3 or itemType == GOODS_TYPE.GOODS_TYPE_91 then
      local type2 = goods.type2
      if type2 ~= 999 and not string.IsNullOrEmpty(goods.para) then
        local res_num = tonumber(goods.para)
        itemFlag = string.GetFormattedStr(res_num)
      end
    elseif itemType == 5 and goods.para3 ~= nil and goods.para3 ~= "" then
      local res_num = tonumber(goods.para3)
      itemFlag = string.GetFormattedStr(res_num)
    end
    self.flag_text:SetText(itemFlag)
    if string.IsNullOrEmpty(itemFlag) then
      self.objFlag:SetActive(false)
    else
      self.objFlag:SetActive(true)
    end
  elseif rewardType == RewardType.OIL or rewardType == RewardType.METAL or rewardType == RewardType.WATER or rewardType == RewardType.FOOD or rewardType == RewardType.ELECTRICITY or rewardType == RewardType.PVE_POINT or rewardType == RewardType.DETECT_EVENT or rewardType == RewardType.FORMATION_STAMINA or rewardType == RewardType.EXP or rewardType == RewardType.WOOD or rewardType == RewardType.FLINT or rewardType == RewardType.OBSIDIAN then
    self.objFlag:SetActive(false)
    self.num_text:SetText(string.GetFormattedSeperatorNum(math.floor(count)))
    self.name_text:SetActive(false)
  elseif rewardType == RewardType.GOLD or rewardType == RewardType.VISITOR or rewardType == RewardType.WORKER then
    self.objFlag:SetActive(false)
    self.num_text:SetText(count)
    self.name_text:SetActive(false)
  elseif rewardType == RewardType.MuseumArtifact then
    self.objFlag:SetActive(false)
    self.num_text:SetText(1)
    self.name_text:SetActive(false)
  elseif rewardType == RewardType.RESOURCE_ITEM then
    self.objFlag:SetActive(false)
    local template = DataCenter.ResourceItemDataManager:GetResourceItemTemplate(itemId)
    if template then
      self.item_bg:SetActive(true)
      self.item_quality:SetActive(true)
      self.item_quality:LoadSprite("Assets/Main/Sprites/ItemIcons/Common_img_quality_green.png")
      self.num_text:SetText(string.GetFormattedSeperatorNum(math.floor(count)))
      self.name_text:SetActive(true)
    end
  elseif rewardType == RewardType.MATERIAL then
    self.objFlag:SetActive(false)
    local goods = DataCenter.ItemTemplateManager:GetItemTemplate(self.param.itemId)
    if goods ~= nil then
      self.item_quality:SetActive(true)
      self.item_quality:LoadSprite(DataCenter.ItemTemplateManager:GetToolBgByColor(tonumber(goods.color)))
      self.num_text:SetText(string.GetFormattedSeperatorNum(math.floor(count)))
    end
  elseif rewardType == RewardType.ARM then
    local army = DataCenter.ArmyTemplateManager:GetArmyTemplate(itemId)
    if army ~= nil then
      self.item_quality:SetActive(false)
      self.num_text:SetText(string.GetFormattedSeperatorNum(math.floor(count)))
      self.name_text:SetActive(true)
    end
  end
  if hideName ~= nil and hideName == true then
    self.name_text:SetActive(false)
  end
end

local function ShowCount(self, hideCount)
  self.num_text:SetActive(not hideCount)
end

local function SetNameText(self, name)
  self.name_text:SetText(name)
end

local function OnBtnClick(self)
  local itemType = self.param.rewardType
  if itemType ~= RewardType.GOODS and itemType ~= RewardType.RESOURCE_ITEM then
    return
  end
  if self.param.itemId ~= nil then
    local param = {}
    param.rewardType = self.param.rewardType
    param.itemId = self.param.itemId
    param.alignObject = self.item_icon
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIItemTips, {anim = true}, param)
  end
end

MailRewardItem.OnCreate = OnCreate
MailRewardItem.OnDestroy = OnDestroy
MailRewardItem.OnBtnClick = OnBtnClick
MailRewardItem.OnEnable = OnEnable
MailRewardItem.OnDisable = OnDisable
MailRewardItem.RefreshData = RefreshData
MailRewardItem.ShowCount = ShowCount
MailRewardItem.SetNameText = SetNameText
return MailRewardItem
