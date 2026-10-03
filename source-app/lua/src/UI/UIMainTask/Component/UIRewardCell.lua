local UIRewardCell = BaseClass("UIRewardCell", UIBaseContainer)
local base = UIBaseContainer
local Param = DataClass("Param", ParamData)
local ParamData = {
  rewardType,
  itemId,
  count
}
local item_icon_path = "ItemIcon"
local num_text_path = "ItemIcon/Num"

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
  self.item_icon = self:AddComponent(UIImage, item_icon_path)
  self.num_text = self:AddComponent(UIText, num_text_path)
end

local function ComponentDestroy(self)
  self.item_icon = nil
  self.num_text = nil
end

local function DataDefine(self)
  self.param = {}
end

local function DataDestroy(self)
  self.param = nil
end

local function ReInit(self, param)
  self.param = param
  self.num_text:SetText(param.count)
  if self.param.rewardType ~= nil then
    if self.param.rewardType == RewardType.GOODS then
      if self.param.itemId == nil then
      else
        local goods = DataCenter.ItemTemplateManager:GetItemTemplate(self.param.itemId)
        if goods ~= nil then
          local join_method = -1
          local icon_join
          if goods.join_method ~= nil and goods.join_method > 0 and goods.icon_join ~= nil and goods.icon_join ~= "" then
            join_method = goods.join_method
            icon_join = goods.icon_join
          end
          if 0 < join_method and icon_join ~= nil and icon_join ~= "" then
            local tempJoin = string.split(icon_join, ";")
            if 2 < #tempJoin then
              self:SetItemIconImage(tempJoin[3])
            end
          else
            local itemType = goods.type
            if itemType == 9 then
              self:SetItemIconImage(goods.icon)
            else
              self:SetItemIconImage(goods.icon)
            end
          end
        else
          local resourceType = tonumber(self.param.itemId)
          if resourceType < 100 then
            self:SetItemIconImage(DataCenter.ResourceManager:GetResourceIconByType(resourceType))
          end
        end
      end
    elseif self.param.rewardType == RewardType.GOLD then
      self:SetItemIconImage(DataCenter.ResourceManager:GetResourceIconByType(ResourceType.Gold))
    elseif self.param.rewardType == RewardType.OIL or self.param.rewardType == RewardType.METAL or self.param.rewardType == RewardType.WATER or self.param.rewardType == RewardType.FOOD or self.param.rewardType == RewardType.ELECTRICITY or self.param.rewardType == RewardType.WOOD or self.param.rewardType == RewardType.FLINT or self.param.rewardType == RewardType.OBSIDIAN then
      self:SetItemIconImage(DataCenter.RewardManager:GetPicByType(self.param.rewardType))
    elseif self.param.rewardType == RewardType.ARM then
      local army = DataCenter.ArmyTemplateManager:GetArmyTemplate(self.param.itemId)
      if army ~= nil then
        self:SetItemIconImage(army.icon)
      end
    elseif self.param.rewardType == RewardType.EQUIP then
      local xmlData = LocalController:instance():getLine("equip_info_new_equip", self.param.itemId)
      if xmlData ~= nil then
        self:SetItemIconImage(xmlData:GetString("icon"))
      end
    elseif self.param.rewardType == RewardType.HERO then
      local xmlData = LocalController:instance():getLine(HeroUtils.GetHeroXmlName(), self.param.itemId)
      if xmlData ~= nil then
        self:SetItemIconImage(xmlData.hero_icon)
      end
    elseif self.param.rewardType == RewardType.HONOR or self.param.rewardType == RewardType.ALLIANCE_POINT then
      self:SetItemIconImage(DataCenter.RewardManager:GetPicByType(self.param.rewardType, self.param.itemId))
    elseif self.param.rewardType == RewardType.MATERIAL then
      local goods = DataCenter.ItemTemplateManager:GetItemTemplate(self.param.itemId)
      if goods ~= nil then
        self:SetItemIconImage(goods.icon)
      end
    elseif self.param.rewardType == RewardType.RESOURCE_ITEM then
      local template = DataCenter.ResourceItemDataManager:GetResourceItemTemplate(self.param.itemId)
      if template ~= nil then
        self:SetItemIconImage(template.pic)
      end
    end
  end
end

local function SetItemIconImage(self, imageName)
  self.item_icon:LoadSprite(imageName)
end

UIRewardCell.OnCreate = OnCreate
UIRewardCell.OnDestroy = OnDestroy
UIRewardCell.Param = Param
UIRewardCell.OnEnable = OnEnable
UIRewardCell.OnDisable = OnDisable
UIRewardCell.ComponentDefine = ComponentDefine
UIRewardCell.ComponentDestroy = ComponentDestroy
UIRewardCell.DataDefine = DataDefine
UIRewardCell.DataDestroy = DataDestroy
UIRewardCell.ReInit = ReInit
UIRewardCell.SetItemIconImage = SetItemIconImage
return UIRewardCell
