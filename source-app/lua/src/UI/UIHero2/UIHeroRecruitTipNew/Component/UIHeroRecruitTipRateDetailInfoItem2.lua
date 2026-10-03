local UIHeroRecruitTipRateDetailInfoItem2 = BaseClass("UIHeroRecruitTipRateDetailInfoItem2", UIBaseContainer)
local base = UIBaseContainer
local UILWUniversalItem = require("UI.UILWUniversalItem.UILWUniversalItem")
local Localization = CS.GameEntry.Localization
local u_i_l_w_universal_item_click_path = "UILWUniversalItemClick"

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
end

local function OnDestroy(self)
  self:ComponentDestroy()
  base.OnDestroy(self)
end

local function ComponentDefine(self)
  self.resItem = self:AddComponent(UILWUniversalItem, "UILWUniversalItem")
  self.rateText = self:AddComponent(UIText, "rateText")
  self.NameText = self:AddComponent(UIText, "NameText")
  self.newFlag = self:AddComponent(UIText, "newflag")
  self.upFlag = self:AddComponent(UIText, "upflag")
  self.newFlag:SetActive(false)
  self.upFlag:SetActive(false)
  self.u_i_l_w_universal_item_click = self:TryAddComponent(UIButton, u_i_l_w_universal_item_click_path)
  if self.u_i_l_w_universal_item_click then
    self.u_i_l_w_universal_item_click:SetOnClick(function()
      self:OnResItemClick()
    end)
  end
end

local function ComponentDestroy(self)
  self.resItem = nil
  self.rateText = nil
  self.NameText = nil
  self.u_i_l_w_universal_item_click = nil
end

local function SetData(self, param, rate, name)
  self.param = param
  self.resItem:ReInit(param)
  self.rateText:SetText(rate .. "%")
  self.NameText:SetText(name)
  if param.flag then
    self.newFlag:SetActive(param.flag == 1)
    self.upFlag:SetActive(param.flag == 2)
  else
    self.newFlag:SetActive(false)
    self.upFlag:SetActive(false)
  end
  if self.u_i_l_w_universal_item_click then
    if self.param.rewardType and (self.param.rewardType == RewardType.HERO or self.param.rewardType == RewardType.WORKER) then
      self.u_i_l_w_universal_item_click:SetActive(true)
    else
      self.u_i_l_w_universal_item_click:SetActive(false)
    end
  end
end

local function OnResItemClick(self)
  if self.param == nil then
    return
  end
  if self.param.rewardType then
    if self.param.rewardType == RewardType.HERO then
      local heroId = self.param.itemId
      local heroUuid = DataCenter.HeroDataManager:GetHeroUuidByHeroId(heroId)
      if not string.IsNullOrEmpty(heroUuid) then
        heroId = heroUuid
      end
      local heroWindow = UIManager:GetInstance():GetWindow(UIWindowNames.UIHeroDetailPanel)
      if not heroWindow then
        UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeroDetailPanel, {anim = false}, heroId, {heroId})
      end
    elseif self.param.rewardType == RewardType.WORKER then
      local workerCfgId = self.param.itemId
      UIUtil.OpenWorkerPreviewView(workerCfgId)
    end
  end
end

UIHeroRecruitTipRateDetailInfoItem2.OnCreate = OnCreate
UIHeroRecruitTipRateDetailInfoItem2.OnDestroy = OnDestroy
UIHeroRecruitTipRateDetailInfoItem2.ComponentDefine = ComponentDefine
UIHeroRecruitTipRateDetailInfoItem2.ComponentDestroy = ComponentDestroy
UIHeroRecruitTipRateDetailInfoItem2.SetData = SetData
UIHeroRecruitTipRateDetailInfoItem2.OnResItemClick = OnResItemClick
return UIHeroRecruitTipRateDetailInfoItem2
