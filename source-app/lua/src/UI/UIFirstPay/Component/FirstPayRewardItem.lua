local FirstPayRewardItem = BaseClass("FirstPayRewardItem", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local Param = DataClass("Param", ParamData)
local ParamData = {
  itemType = nil,
  itemId = nil,
  itemCount = nil
}

local function OnCreate(self)
  base.OnCreate(self)
  self.item = self:AddComponent(UICommonResItem, "")
  self.countText = self:AddComponent(UIText, "NumText")
  self.effectObj = self:AddComponent(UIBaseContainer, "clickBtn/effect")
end

local function OnDestroy(self)
  self.item = nil
  self.countText = nil
  base.OnDestroy(self)
end

local function ReInit(self, reward)
  self.param = DeepCopy(reward)
  local count = reward.count
  self.param.count = nil
  self.item:ReInit(self.param)
  self.effectObj:SetActive(self.param.rewardType == RewardType.HERO)
  if count and 0 < count then
    self.countText:SetText(string.GetFormattedStr(count))
  else
    self.countText:SetText("")
  end
end

function FirstPayRewardItem:SetNumTextScale(scale)
  self.countText:SetLocalScaleXYZ(scale, scale, scale)
end

FirstPayRewardItem.OnCreate = OnCreate
FirstPayRewardItem.OnDestroy = OnDestroy
FirstPayRewardItem.ReInit = ReInit
return FirstPayRewardItem
