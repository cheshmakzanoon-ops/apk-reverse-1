local UICommonRewardCell = BaseClass("UICommonRewardCell", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local quality_bg_path = "QualityBg"
local icon_path = "Icon"
local numText_path = "NumText"

function UICommonRewardCell:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
end

function UICommonRewardCell:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UICommonRewardCell:ComponentDefine()
  self.qualityBg = self:AddComponent(UIImage, quality_bg_path)
  self.btn = self:AddComponent(UIButton, quality_bg_path)
  self.icon = self:AddComponent(UIImage, icon_path)
  self.numText = self:AddComponent(UIText, numText_path)
  self.btn:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self:OnBtnClick()
  end)
end

function UICommonRewardCell:ComponentDestroy()
  self.qualityBg = nil
  self.icon = nil
  self.numText = nil
  self.btn = nil
end

function UICommonRewardCell:SetItemIconImage(imageName)
  self.icon:LoadSpriteAuto(imageName)
end

function UICommonRewardCell:SetDefault(param)
  local t = type(param.value)
  if t == "number" then
    self.numText:SetText("+" .. param.value)
    self:SetItemIconImage(DataCenter.RewardManager:GetPicByType(tonumber(param.type)))
  else
    if param.value.num then
      self.numText:SetText("" .. param.value.num)
    end
    self:SetItemIconImage(DataCenter.RewardManager:GetPicByType(tonumber(param.type), tonumber(param.value.id)))
    self.qualityBg:LoadSprite(DataCenter.RewardManager:GetRewardQualityBg(tonumber(param.type), tonumber(param.value.id)))
  end
  self.qualityBg:LoadSprite("Assets/Main/Sprites/UI/LWCommon/Sprite/tongyong_cfm_daojukuang_5.png")
end

function UICommonRewardCell:SetGoods(param)
  local itemId = tonumber(param.value.itemId)
  if param.value.count then
    self.numText:SetText("" .. param.value.count)
  end
  local goods = DataCenter.ItemTemplateManager:GetItemTemplate(itemId)
  if goods ~= nil then
    self:SetItemIconImage(string.format(LoadPath.ItemPath, goods.icon))
    self.qualityBg:LoadSprite(DataCenter.ItemTemplateManager:GetToolBgByColor(goods.color))
  else
    self:SetItemIconImage(DataCenter.RewardManager:GetPicByType(param.type, itemId))
    self.qualityBg:LoadSprite("Assets/Main/Sprites/UI/LWCommon/Sprite/tongyong_cfm_daojukuang_5.png")
  end
end

function UICommonRewardCell:SetHero(param)
  local heroId = tonumber(param.value.heroId)
  self.numText:SetText("")
  self:SetItemIconImage(DataCenter.RewardManager:GetPicByType(param.type, heroId))
  self.qualityBg:LoadSprite(DataCenter.RewardManager:GetRewardQualityBg(param.type, heroId))
end

function UICommonRewardCell:SetWorker(param)
  self.numText:SetText("")
  self:SetItemIconImage(DataCenter.RewardManager:GetPicByType(param.type))
  self.qualityBg:LoadSprite("Assets/Main/Sprites/UI/LWCommon/Sprite/tongyong_cfm_daojukuang_5.png")
end

function UICommonRewardCell:SetEquip(param)
  if param.value.add then
    self.numText:SetText("" .. param.value.add)
  end
  self:SetItemIconImage(DataCenter.RewardManager:GetPicByType(tonumber(param.type), tonumber(param.value.itemId)))
  self.qualityBg:LoadSprite(DataCenter.RewardManager:GetRewardQualityBg(tonumber(param.type), tonumber(param.value.itemId)))
end

function UICommonRewardCell:SetResourceItem(param)
  local resourceType = tonumber(param.value.itemId)
  if param.value.count then
    if param.value.count > 999 then
      self.numText:SetText(string.numbericFormationWithPrefix(param.value.count, 5, ","))
    else
      self.numText:SetText("" .. param.value.count)
    end
  end
  if resourceType < 100 then
    if resourceType == RewardType.GOLD then
      self:SetItemIconImage(DataCenter.ResourceManager:GetResourceIconByType(ResourceType.Gold))
    else
      self:SetItemIconImage(DataCenter.ResourceManager:GetResourceIconByType(resourceType))
    end
    self.qualityBg:LoadSprite(DataCenter.ItemTemplateManager:GetToolBgByColor(ItemColor.PURPLE))
  end
end

function UICommonRewardCell:SetVisitor(param)
  self.numText:SetText("" .. param.value.count)
  self.qualityBg:LoadSprite(DataCenter.ItemTemplateManager:GetToolBgByColor(ItemColor.GREEN))
  self:SetItemIconImage(DataCenter.RewardManager:GetPicByType(RewardType.WORKER))
end

local TypeRewardMap = {
  [RewardType.HERO] = UICommonRewardCell.SetHero,
  [RewardType.WORKER] = UICommonRewardCell.SetWorker,
  [RewardType.GOODS] = UICommonRewardCell.SetGoods,
  [RewardType.EQUIP] = UICommonRewardCell.SetEquip,
  [RewardType.RESOURCE_ITEM] = UICommonRewardCell.SetResourceItem,
  [RewardType.GOLD] = UICommonRewardCell.SetResourceItem,
  [RewardType.VISITOR] = UICommonRewardCell.SetVisitor,
  Default = UICommonRewardCell.SetDefault
}

function UICommonRewardCell:ReInit(param)
  self.param = param
  if TypeRewardMap[param.type] then
    TypeRewardMap[param.type](self, param)
  else
    TypeRewardMap.Default(self, param)
  end
end

function UICommonRewardCell:OnBtnClick()
  if self.param == nil then
    return
  end
  if self.param.clickCallBack ~= nil then
    self.param.clickCallBack(self.param)
    return
  end
  local itemId = self.param.itemId or self.param.value.itemId
  local rewardType = self.param.type or self.param.rewardType
  if rewardType == RewardType.GOODS then
    local param = {}
    param.itemId = itemId
    param.alignObject = self.icon
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIItemTips, {anim = true}, param)
  elseif rewardType == RewardType.HERO then
    local heroId = itemId
    local heroWindow = UIManager:GetInstance():GetWindow(UIWindowNames.UIHeroDetailPanel)
    if not heroWindow then
      UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeroDetailPanel, {anim = false}, heroId, {heroId})
    end
  else
    local desc = DataCenter.RewardManager:GetDescByType(rewardType, itemId)
    local name = DataCenter.RewardManager:GetNameByType(rewardType, itemId)
    if string.IsNullOrEmpty(desc) or string.IsNullOrEmpty(name) then
      return
    end
    local param = {}
    param.itemName = name
    param.itemDesc = desc
    param.alignObject = self.icon
    param.isLocal = true
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIItemTips, {anim = true}, param)
  end
end

return UICommonRewardCell
