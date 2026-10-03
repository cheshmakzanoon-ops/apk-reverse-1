local LWSeason5RewardTabItem = BaseClass("LWSeason5RewardTabItem", UIToggle)
local base = UIToggle
local Localization = CS.GameEntry.Localization
local SeasonRedPointUtils = require("UI.LWSeason.LWSeasonMain.Utils.SeasonRedPointUtils")

function LWSeason5RewardTabItem:OnCreate()
  base.OnCreate(self)
  self.condition_dark = self:AddComponent(UIText, "ConditionDark")
  self.condition = self:AddComponent(UIText, "ConditionSelect/Condition")
  self:SetOnValueChanged(function(tf)
    self:OnSelectStatusChanged(tf)
  end)
  self.red_point = self:AddComponent(UIImage, "RedPoint")
  self.red_num = self:AddComponent(UIText, "RedPoint/RedNum")
  self.red_point:SetActive(false)
end

function LWSeason5RewardTabItem:OnDestroy()
  self.condition_dark = nil
  self.condition = nil
  self.red_point = nil
  self.red_num = nil
  base.OnDestroy(self)
end

function LWSeason5RewardTabItem:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.LWSeasonPersonalRewardGetRedPoint, self.RefreshRed)
  self:AddUIListener(EventId.LWSeasonAllianceRewardInfoUpdate, self.RefreshRed)
  self:AddUIListener(EventId.LWSeasonAllianceRewardCountUpdate, self.RefreshRed)
end

function LWSeason5RewardTabItem:OnRemoveListener()
  self:RemoveUIListener(EventId.LWSeasonPersonalRewardGetRedPoint, self.RefreshRed)
  self:RemoveUIListener(EventId.LWSeasonAllianceRewardInfoUpdate, self.RefreshRed)
  self:RemoveUIListener(EventId.LWSeasonAllianceRewardCountUpdate, self.RefreshRed)
  base.OnRemoveListener(self)
end

function LWSeason5RewardTabItem:OnEnable()
  base.OnEnable(self)
end

function LWSeason5RewardTabItem:OnDisable()
  base.OnDisable(self)
end

function LWSeason5RewardTabItem:ReInit(index, class, assetPath, tabName, param)
  self.index = index
  self.assetPath = assetPath
  self.class = class
  self.param = param
  self.name = tabName
  self.condition_dark:SetLocalText(self.name)
  self.condition:SetLocalText(self.name)
  self:RefreshRed()
end

function LWSeason5RewardTabItem:OnSelectStatusChanged(selected)
  if selected then
    self.view:OnTabActive(self)
  end
end

function LWSeason5RewardTabItem:RefreshRed()
  if self.index == 1 then
    self.red_point:SetActive(SeasonRedPointUtils.SeasonAllianceRewardDistributeBtnRedState())
  elseif self.index == 2 then
    self.red_point:SetActive(SeasonRedPointUtils.SeasonPersonalRewardAllGetBtnRedState())
  else
    self.red_point:SetActive(false)
  end
end

return LWSeason5RewardTabItem
