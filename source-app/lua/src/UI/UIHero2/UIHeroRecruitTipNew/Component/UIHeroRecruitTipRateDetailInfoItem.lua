local UIHeroRecruitTipRateDetailInfoItem = BaseClass("UIHeroRecruitTipRateDetailInfoItem", UIBaseContainer)
local base = UIBaseContainer
local UILWUniversalItem = require("UI.UILWUniversalItem.UILWUniversalItem")
local UIHeroRecruitTipRateDetailInfoItem2 = require("UI.UIHero2.UIHeroRecruitTipNew.Component.UIHeroRecruitTipRateDetailInfoItem2")
local Localization = CS.GameEntry.Localization

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
end

local function OnDestroy(self)
  self:ComponentDestroy()
  base.OnDestroy(self)
end

local function ComponentDefine(self)
  self.svGoodsN = self:AddComponent(UIBaseContainer, "midContent")
  self.contentN = self:AddComponent(GridInfinityScrollView, "midContent/Content")
  self.titleN = self:AddComponent(UIText, "topContent/titleText")
  self.rateN = self:AddComponent(UIText, "topContent/rateText")
  self.listGO = {}
end

local function ComponentDestroy(self)
  self:ClearItemCell()
  self.svGoodsN = nil
  self.contentN = nil
  self.listGO = nil
end

local function ClearItemCell(self)
  self.svGoodsN:RemoveComponents(UIHeroRecruitTipRateDetailInfoItem2)
  self.contentN:DestroyChildNode()
end

local function OnInitScroll(self, go, index)
  local item = self.svGoodsN:AddComponent(UIHeroRecruitTipRateDetailInfoItem2, go)
  self.listGO[go] = item
end

local function GetRewardTypeByData(data)
  local rewardType
  if data.type == HeroRecruitRateDetailInfoType.Hero then
    rewardType = RewardType.HERO
  elseif data.type == HeroRecruitRateDetailInfoType.Goods then
    rewardType = RewardType.GOODS
  elseif data.type == HeroRecruitRateDetailInfoType.ResItem then
    rewardType = RewardType.RESOURCE_ITEM
  elseif data.type == HeroRecruitRateDetailInfoType.Worker then
    rewardType = RewardType.WORKER
  elseif data.type == HeroRecruitRateDetailInfoType.SquadEquip then
    rewardType = RewardType.CommonEquip
  elseif data.type == HeroRecruitRateDetailInfoType.Equip then
    rewardType = RewardType.EQUIP
  elseif data.type == HeroRecruitRateDetailInfoType.SkillChip then
    rewardType = RewardType.TWSkillChip
  end
  return rewardType
end

local function GetRewardNameByData(data)
  local name = ""
  if data.type == HeroRecruitRateDetailInfoType.Hero then
    name = DataCenter.RewardManager:GetNameByType(RewardType.HERO, data.id)
  elseif data.type == HeroRecruitRateDetailInfoType.Goods then
    name = DataCenter.RewardManager:GetNameByType(RewardType.GOODS, data.id)
  elseif data.type == HeroRecruitRateDetailInfoType.ResItem then
    name = DataCenter.RewardManager:GetNameByType(RewardType.RESOURCE_ITEM, data.id)
  elseif data.type == HeroRecruitRateDetailInfoType.Worker then
    name = DataCenter.RewardManager:GetNameByType(RewardType.WORKER, data.id)
  elseif data.type == HeroRecruitRateDetailInfoType.SquadEquip then
    name = DataCenter.RewardManager:GetNameByType(RewardType.CommonEquip, data.id)
  elseif data.type == HeroRecruitRateDetailInfoType.Equip then
    name = DataCenter.RewardManager:GetNameByType(RewardType.EQUIP, data.id)
  elseif data.type == HeroRecruitRateDetailInfoType.SkillChip then
    name = DataCenter.RewardManager:GetNameByType(RewardType.TWSkillChip, data.id)
  end
  return name
end

local function OnUpdateScroll(self, go, index)
  local conf = self.data.dataList[index + 1]
  if conf == nil then
    return
  end
  go.name = conf.id
  local cellItem = self.listGO[go]
  if not cellItem then
    return
  end
  local param = UICommonResItem.Param.New()
  param.rewardType = GetRewardTypeByData(conf)
  param.itemId = conf.id
  param.count = conf.num
  local name = GetRewardNameByData(conf)
  cellItem:SetData(param, conf.rate, name)
end

local function OnDestroyScrollItem(self, go, index)
end

local function SetData(self, data)
  self.data = data
  self.titleN:SetText(self.data.name)
  local totalRate = 0
  for itemIndex = 1, #self.data.dataList do
    local itemData = self.data.dataList[itemIndex]
    totalRate = totalRate + itemData.rate
  end
  if 100 < totalRate then
    totalRate = 100.0
  end
  self.rateN:SetText(totalRate .. "%")
  local dataCount = #self.data.dataList
  self.svGoodsN.rectTransform:Set_sizeDelta(700, math.min((dataCount - 1) // 5 + 1, 2) * 178)
  TimerManager:GetInstance():DelayFrameInvoke(function()
    self:ClearItemCell()
    local bindFunc1 = BindCallback(self, self.OnInitScroll)
    local bindFunc2 = BindCallback(self, self.OnUpdateScroll)
    local bindFunc3 = BindCallback(self, self.OnDestroyScrollItem)
    self.contentN:Init(bindFunc1, bindFunc2, bindFunc3)
    self.contentN:SetItemCount(dataCount)
  end, 1)
end

UIHeroRecruitTipRateDetailInfoItem.OnCreate = OnCreate
UIHeroRecruitTipRateDetailInfoItem.OnDestroy = OnDestroy
UIHeroRecruitTipRateDetailInfoItem.ComponentDefine = ComponentDefine
UIHeroRecruitTipRateDetailInfoItem.ComponentDestroy = ComponentDestroy
UIHeroRecruitTipRateDetailInfoItem.ClearItemCell = ClearItemCell
UIHeroRecruitTipRateDetailInfoItem.OnInitScroll = OnInitScroll
UIHeroRecruitTipRateDetailInfoItem.OnUpdateScroll = OnUpdateScroll
UIHeroRecruitTipRateDetailInfoItem.OnDestroyScrollItem = OnDestroyScrollItem
UIHeroRecruitTipRateDetailInfoItem.SetData = SetData
UIHeroRecruitTipRateDetailInfoItem.GetRewardTypeByData = GetRewardTypeByData
UIHeroRecruitTipRateDetailInfoItem.GetRewardNameByData = GetRewardNameByData
return UIHeroRecruitTipRateDetailInfoItem
