local UIBPTaskRewardCell = BaseClass("UIBPTaskRewardCell", UIBaseContainer)
local base = UIBaseContainer
local num_text_path = "NumText"
local icon_path = "IconImg"
local hero_debris_path = "HeroDebris"
local hero_debris_icon_path = "HeroDebris/ImgHeroDebrisIcon"

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
  self.num_text = self:AddComponent(UIText, num_text_path)
  self.icon = self:AddComponent(UIImage, icon_path)
  self.nodeHeroDebris = self:AddComponent(UIBaseContainer, hero_debris_path)
  self.imgHeroDebrisIcon = self:AddComponent(UIImage, hero_debris_icon_path)
end

local function ComponentDestroy(self)
  self.num_text = nil
  self.icon = nil
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
  self.icon:SetActive(true)
  self.num_text:SetText("x" .. string.GetFormattedSeperatorNum(param.count))
  if self.param.rewardType ~= nil then
    if self.param.rewardType == RewardType.GOODS then
      if self.param.itemId == nil then
      else
        local goods = DataCenter.ItemTemplateManager:GetItemTemplate(self.param.itemId)
        if goods ~= nil then
          self.icon:LoadSprite(string.format(LoadPath.ItemPath, goods.icon))
        else
          local resourceType = tonumber(self.param.itemId)
          if resourceType < 100 then
            self.icon:LoadSprite(DataCenter.ResourceManager:GetResourceIconByType(resourceType))
          end
        end
      end
    elseif self.param.rewardType == RewardType.GOLD then
      self.icon:LoadSprite(DataCenter.ResourceManager:GetResourceIconByType(ResourceType.Gold))
    elseif self.param.rewardType == RewardType.OIL or self.param.rewardType == RewardType.METAL or self.param.rewardType == RewardType.WATER or self.param.rewardType == RewardType.FOOD or self.param.rewardType == RewardType.ELECTRICITY or self.param.rewardType == RewardType.WOOD then
      self.icon:LoadSprite(DataCenter.RewardManager:GetPicByType(self.param.rewardType))
    elseif self.param.rewardType == RewardType.ARM then
      local army = DataCenter.ArmyTemplateManager:GetArmyTemplate(self.param.itemId)
      if army ~= nil then
        self.icon:LoadSprite(string.format(LoadPath.SoldierIcons, army.icon))
      end
    elseif self.param.rewardType == RewardType.EQUIP then
    elseif self.param.rewardType == RewardType.HERO then
      local xmlData = LocalController:instance():getLine(HeroUtils.GetHeroXmlName(), self.param.itemId)
      if xmlData ~= nil then
        self:SetItemIconImage(xmlData.hero_icon)
      end
    elseif self.param.rewardType == RewardType.RESOURCE_ITEM then
      local template = DataCenter.ResourceItemDataManager:GetResourceItemTemplate(self.param.itemId)
      if template ~= nil then
        self.icon:LoadSprite(string.format(LoadPath.ItemPath, template.pic))
      end
    end
  end
end

UIBPTaskRewardCell.OnCreate = OnCreate
UIBPTaskRewardCell.OnDestroy = OnDestroy
UIBPTaskRewardCell.Param = Param
UIBPTaskRewardCell.OnEnable = OnEnable
UIBPTaskRewardCell.OnDisable = OnDisable
UIBPTaskRewardCell.ComponentDefine = ComponentDefine
UIBPTaskRewardCell.ComponentDestroy = ComponentDestroy
UIBPTaskRewardCell.DataDefine = DataDefine
UIBPTaskRewardCell.DataDestroy = DataDestroy
UIBPTaskRewardCell.ReInit = ReInit
return UIBPTaskRewardCell
