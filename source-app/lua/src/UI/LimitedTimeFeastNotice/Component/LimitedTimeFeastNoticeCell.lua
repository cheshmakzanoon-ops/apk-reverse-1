local LimitedTimeFeastNoticeCell = BaseClass("LimitedTimeFeastNoticeCell", UIBaseContainer)
local base = UIBaseContainer
local UILWUniversalItem = require("UI.UILWUniversalItem.UILWUniversalItem")
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
  self.resItem = self:AddComponent(UILWUniversalItem, "UILWUniversalItem")
  self.rateText = self:AddComponent(UIText, "rateText")
end

local function ComponentDestroy(self)
  self.resItem = nil
  self.rateText = nil
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

local function SetData(self, data)
  self.data = data
  local param = UICommonResItem.Param.New()
  param.rewardType = GetRewardTypeByData(self.data)
  param.itemId = self.data.id
  param.count = self.data.num
  self.resItem:ReInit(param)
  self.rateText:SetText(self.data.rate .. "%")
end

LimitedTimeFeastNoticeCell.OnCreate = OnCreate
LimitedTimeFeastNoticeCell.OnDestroy = OnDestroy
LimitedTimeFeastNoticeCell.ComponentDefine = ComponentDefine
LimitedTimeFeastNoticeCell.ComponentDestroy = ComponentDestroy
LimitedTimeFeastNoticeCell.SetData = SetData
return LimitedTimeFeastNoticeCell
