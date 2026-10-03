local base = UIBaseContainer
local UIActValentineBoxProbabilityRewardItem = BaseClass("UIActValentineBoxProbabilityRewardItem", base)
local Localization = CS.GameEntry.Localization
local M = UIActValentineBoxProbabilityRewardItem
local resItem_path = "ResItem"
local probabilityNum_path = "ProbabilityNum"

function M:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function M:OnDestroy()
  self:ClearRewards()
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

function M:ComponentDefine()
  self.probabilityNum = self:AddComponent(UIText, probabilityNum_path)
  self.item = self:AddComponent(UICommonResItem, resItem_path)
end

function M:ComponentDestroy()
  self.probabilityNum = nil
  self.item = nil
end

function M:DataDefine()
  self.probabilityInfo = {}
end

function M:DataDestroy()
  self.probabilityInfo = nil
end

function M:OnEnable()
  base.OnEnable(self)
end

function M:OnDisable()
  base.OnDisable(self)
end

function M:SetData(data, actId)
  self.probabilityInfo = data
  self:RefreshAll()
end

function M:ClearRewards()
  self.item:RemoveComponents(UICommonResItem)
end

function M:RefreshAll()
  local rate = self.probabilityInfo.rate * 100 .. "%"
  self.probabilityNum:SetText(rate)
  local param = {}
  param.itemId = self.probabilityInfo.id
  param.count = self.probabilityInfo.num
  param.rewardType = RewardType.GOODS
  self.item:ReInit(param)
end

return UIActValentineBoxProbabilityRewardItem
