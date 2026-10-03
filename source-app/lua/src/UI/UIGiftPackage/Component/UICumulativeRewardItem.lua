local UICumulativeRewardItem = BaseClass("UICumulativeRewardItem", UIBaseContainer)
local base = UIBaseContainer
local item_quality_path = "GameObject/clickBtn/ImgQuality"
local item_icon_path = "GameObject/clickBtn/ItemIcon"
local flag_text_path = "GameObject/clickBtn/FlagGo/FlagText"
local flag_go_path = "GameObject/clickBtn/FlagGo"
local count_text_path = "GameObject/clickBtn/NumText"
local btn_path = "GameObject/clickBtn"
local imgExtra = "GameObject/clickBtn/ImgExtra"
local check = "GameObject/clickBtn/Check"
local hero_debris_path = "GameObject/clickBtn/HeroDebris"
local Rect_RewardEffect = "GameObject/Rect_RewardEffect"

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
  self.item_quality = self:AddComponent(UIImage, item_quality_path)
  self.item_icon = self:AddComponent(UIImage, item_icon_path)
  self.flag_text = self:AddComponent(UIText, flag_text_path)
  self.flag_go = self:AddComponent(UIBaseContainer, flag_go_path)
  self.count_text = self:AddComponent(UIText, count_text_path)
  self.imgExtra = self:AddComponent(UIImage, imgExtra)
  self.check = self:AddComponent(UIBaseComponent, check)
  self.btn = self:AddComponent(UIButton, btn_path)
  self.btn:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self:OnBtnClick()
  end)
  self.nodeHeroDebris = self:AddComponent(UIBaseContainer, hero_debris_path)
  self.nodeHeroDebris:SetActive(false)
  self._rewardEffect_rect = self:AddComponent(UIBaseContainer, Rect_RewardEffect)
end

local function ComponentDestroy(self)
  self.item_quality = nil
  self.item_icon = nil
  self.flag_text = nil
  self.flag_go = nil
  self.count_text = nil
  self.btn = nil
end

local function DataDefine(self)
  self.param = {}
  self.flagText = nil
  self.flagActive = nil
end

local function DataDestroy(self)
  self.param = nil
  self.flagText = nil
  self.flagActive = nil
end

local function ReInit(self, param, state, rewardEffect)
  self.param = param
  self.imgExtra:SetActive(false)
  self.nodeHeroDebris:SetActive(false)
  self:SetCheckActive(state)
  self:SetReceiveState(rewardEffect)
  if self.param.isSimple then
    self:SetFlagActive(false)
    self:SetItemIconImage(self.param.iconName)
    self:SetItemQualityImage(DataCenter.ItemTemplateManager:GetToolBgByColor(ItemColor.GREEN))
    self.count_text:SetText("")
  elseif self.param.itemId == nil then
    if self.param.iconName ~= nil and self.param.itemColor ~= nil then
      self:SetFlagActive(false)
      self:SetItemIconImage(self.param.iconName)
      self:SetItemQualityImage(DataCenter.ItemTemplateManager:GetToolBgByColor(tonumber(self.param.itemColor)))
      self.count_text:SetText("")
    elseif self.param.heroConfigId ~= nil then
      self:SetFlagActive(false)
      local _heroConfigId = self.param.heroConfigId
      self:SetItemIconImage(HeroUtils.GetHeroIconPath(_heroConfigId, false))
      local rarity = GetTableData(HeroUtils.GetHeroXmlName(), _heroConfigId, "rarity")
      local qualityimg = HeroUtils.GetRarityIconPath(rarity, false)
      self:SetItemQualityImage(qualityimg)
    end
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
        if param.count ~= nil then
          self:SetCountText(param.count)
        else
          self:SetCountText("")
        end
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
        elseif itemType == 3 or itemType == GOODS_TYPE.GOODS_TYPE_91 then
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
        local iconImg = string.format(LoadPath.ItemPath, goods.icon)
        self:SetItemIconImage(iconImg)
      end
    else
      local resourceType = tonumber(self.param.itemId)
      if resourceType < 100 then
        self:SetFlagActive(false)
        self:SetItemIconImage(CS.ResourceUtils.GetResourceImagePath(resourceType))
        self:SetItemQualityImage(DataCenter.ItemTemplateManager:GetToolBgByColor(ItemColor.PURPLE))
        if self.param.count ~= nil then
          self:SetCountText(self.param.count)
        else
          self:SetCountText("")
        end
      end
    end
  end
end

local function SetReceiveState(self, state)
  self._rewardEffect_rect:SetActive(state)
end

local function OnBtnClick(self)
  if self.param.itemId ~= nil then
    local param = {}
    param.itemId = self.param.itemId
    param.alignObject = self.item_icon
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIItemTips, {anim = true}, param)
  elseif self.param.iconName ~= nil then
    local param = {}
    param.itemName = self.param.itemName
    param.itemDesc = self.param.itemDes
    param.alignObject = self.item_icon
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIItemTips, {anim = true}, param)
  end
end

local function SetItemIconImage(self, imageName)
  self.item_icon:LoadSpriteAuto(imageName)
end

local function SetItemQualityImage(self, imageName)
  self.item_quality:LoadSpriteAuto(imageName)
end

local function SetFlagActive(self, value)
  if self.flagActive ~= value then
    self.flagActive = value
    self.flag_text.gameObject:SetActive(value)
    if self.flag_go ~= nil then
      self.flag_go:SetActive(value)
    end
  end
end

local function SetFlagText(self, value)
  if self.flagText ~= value then
    self.flagText = value
    self.flag_text:SetText(value)
  end
end

local function SetCountText(self, value)
  self.count_text:SetText(value)
end

local function SetCheckActive(self, state)
  self.check:SetActive(state == 1)
end

UICumulativeRewardItem.OnCreate = OnCreate
UICumulativeRewardItem.OnDestroy = OnDestroy
UICumulativeRewardItem.OnBtnClick = OnBtnClick
UICumulativeRewardItem.OnEnable = OnEnable
UICumulativeRewardItem.OnDisable = OnDisable
UICumulativeRewardItem.ComponentDefine = ComponentDefine
UICumulativeRewardItem.ComponentDestroy = ComponentDestroy
UICumulativeRewardItem.DataDefine = DataDefine
UICumulativeRewardItem.DataDestroy = DataDestroy
UICumulativeRewardItem.ReInit = ReInit
UICumulativeRewardItem.SetItemIconImage = SetItemIconImage
UICumulativeRewardItem.SetItemQualityImage = SetItemQualityImage
UICumulativeRewardItem.SetFlagActive = SetFlagActive
UICumulativeRewardItem.SetFlagText = SetFlagText
UICumulativeRewardItem.SetCountText = SetCountText
UICumulativeRewardItem.SetCheckActive = SetCheckActive
UICumulativeRewardItem.SetReceiveState = SetReceiveState
return UICumulativeRewardItem
