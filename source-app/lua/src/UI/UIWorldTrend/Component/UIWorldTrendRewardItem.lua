local UIWorldTrendRewardItem = BaseClass("UIWorldTrendRewardItem", UIBaseContainer)
local base = UIBaseContainer
local UIGray = CS.UIGray
local ImgQuality = "UICommonResItem/clickBtn/ImgQuality"
local ItemIcon = "UICommonResItem/clickBtn/ItemIcon"
local FlagGo = "UICommonResItem/clickBtn/FlagGo"
local FlagText = "UICommonResItem/clickBtn/FlagGo/FlagText"
local NumText = "UICommonResItem/clickBtn/NumText"
local ImgExtra = "UICommonResItem/clickBtn/ImgExtra"
local Check = "UICommonResItem/Check"
local Mask = "UICommonResItem/Mask"
local clickBtn = "UICommonResItem/clickBtn"
local Rect_RewardEffect = "Rect_RewardEffect"
local anim_path = "UICommonResItem"

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
  self.item_quality = self:AddComponent(UIImage, ImgQuality)
  self.item_icon = self:AddComponent(UIImage, ItemIcon)
  self.flag = self:AddComponent(UIBaseContainer, FlagGo)
  self.flag_text = self:AddComponent(UIText, FlagText)
  self.num_text = self:AddComponent(UIText, NumText)
  self.imgExtra = self:AddComponent(UIImage, ImgExtra)
  self.check = self:AddComponent(UIBaseContainer, Check)
  self.mask = self:AddComponent(UIBaseContainer, Mask)
  self.select_btn = self:AddComponent(UIButton, clickBtn)
  self.select_btn:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self:OnBtnClick()
  end)
  self._rewardEffect_rect = self:AddComponent(UIBaseContainer, Rect_RewardEffect)
  self.anim = self:AddComponent(UIAnimator, anim_path)
  self.anim:Play("V_ui_tubiaolingqu_default", 0, 0)
end

local function ComponentDestroy(self)
  self.item_quality = nil
  self.item_icon = nil
  self.flag = nil
  self.flag_text = nil
  self.num_text = nil
  self.select_btn = nil
  self.check = nil
  self.mask = nil
end

local function DataDefine(self)
  self.param = {}
end

local function DataDestroy(self)
  self.param = nil
  self.state = nil
end

local function RefreshData(self, param)
  self.param = param
  self.imgExtra:SetActive(false)
  self.flag:SetActive(false)
  self.num_text:SetText(self.param.count)
  if self.param.rewardType == RewardType.GOODS then
    local goods = DataCenter.ItemTemplateManager:GetItemTemplate(self.param.itemId)
    local flagtxt = ""
    self.item_quality:LoadSprite(DataCenter.ItemTemplateManager:GetToolBgByColor(goods.color))
    self:SetItemIconImage(string.format(LoadPath.ItemPath, goods.icon))
    if goods.type == 2 then
      if goods.para1 ~= nil and goods.para1 ~= "" then
        local para1 = goods.para1
        local temp = string.split(para1, ";")
        if temp ~= nil and 1 < #temp then
          flagtxt = temp[1] .. temp[2]
        end
      end
    elseif goods.type == GOODS_TYPE.GOODS_TYPE_110 then
      if goods.para2 ~= nil and goods.para2 ~= "" then
        local res_num = tonumber(goods.para2)
        flagtxt = string.GetFormattedStr(res_num)
      end
    elseif goods.type == 3 or goods.type == GOODS_TYPE.GOODS_TYPE_91 then
      local type2 = goods.type2
      if type2 ~= 999 and goods.para ~= nil and goods.para ~= "" then
        local res_num = tonumber(goods.para)
        flagtxt = string.GetFormattedStr(res_num)
      end
    end
    self.flag:SetActive(flagtxt ~= "")
    self.flag_text:SetText(flagtxt)
  elseif self.param.rewardType == RewardType.GOLD then
    self.item_quality:LoadSprite(DataCenter.ItemTemplateManager:GetToolBgByColor(ItemColor.PURPLE))
    self:SetItemIconImage(DataCenter.ResourceManager:GetResourceIconByType(ResourceType.Gold))
  elseif self.param.rewardType == RewardType.OIL or self.param.rewardType == RewardType.METAL or self.param.rewardType == RewardType.WATER or self.param.rewardType == RewardType.FOOD or self.param.rewardType == RewardType.ELECTRICITY or self.param.rewardType == RewardType.WOOD or self.param.rewardType == RewardType.FLINT or self.param.rewardType == RewardType.OBSIDIAN then
    self.item_quality:LoadSprite(DataCenter.ItemTemplateManager:GetToolBgByColor(ItemColor.PURPLE))
    self:SetItemIconImage(DataCenter.RewardManager:GetPicByType(self.param.rewardType))
  elseif self.param.rewardType == RewardType.HERO then
    local xmlData = LocalController:instance():getLine(HeroUtils.GetHeroXmlName(), self.param.itemId)
    if xmlData ~= nil then
      self:SetItemIconImage(xmlData.hero_icon)
    end
  elseif self.param.rewardType == RewardType.RESOURCE_ITEM then
    local template = DataCenter.ResourceItemDataManager:GetResourceItemTemplate(self.param.itemId)
    if template ~= nil then
      self:SetItemIconImage(template:GetIconPath())
    end
  end
end

local function SetItemIconImage(self, imageName)
  self.item_icon:LoadSprite(imageName)
end

local function SetRewardState(self, state)
  self.check:SetActive(state)
  self.mask:SetActive(state)
end

local function SetQuestState(self, state)
  if self.state ~= state then
    self.mask:SetActive(state)
    self.state = state
  end
end

local function SetReceiveState(self, state)
  self._rewardEffect_rect:SetActive(state)
  if state then
    self.anim:Play("V_ui_tubiaolingqu_huxi", 0, 0)
  else
    self.anim:Play("V_ui_tubiaolingqu_default", 0, 0)
  end
end

local function OnBtnClick(self)
  if self.param.rewardType == RewardType.GOODS then
    local param = {}
    param.itemId = self.param.itemId
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

UIWorldTrendRewardItem.OnCreate = OnCreate
UIWorldTrendRewardItem.OnDestroy = OnDestroy
UIWorldTrendRewardItem.OnEnable = OnEnable
UIWorldTrendRewardItem.OnDisable = OnDisable
UIWorldTrendRewardItem.ComponentDefine = ComponentDefine
UIWorldTrendRewardItem.ComponentDestroy = ComponentDestroy
UIWorldTrendRewardItem.DataDefine = DataDefine
UIWorldTrendRewardItem.DataDestroy = DataDestroy
UIWorldTrendRewardItem.RefreshData = RefreshData
UIWorldTrendRewardItem.SetItemIconImage = SetItemIconImage
UIWorldTrendRewardItem.SetRewardState = SetRewardState
UIWorldTrendRewardItem.SetQuestState = SetQuestState
UIWorldTrendRewardItem.SetReceiveState = SetReceiveState
UIWorldTrendRewardItem.OnBtnClick = OnBtnClick
return UIWorldTrendRewardItem
