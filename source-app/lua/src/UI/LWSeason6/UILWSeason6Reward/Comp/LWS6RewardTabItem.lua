local LWS6RewardTabItem = BaseClass("LWS6RewardTabItem", UIToggle)
local base = UIToggle
local Localization = CS.GameEntry.Localization
local SeasonRedPointUtils = require("UI.LWSeason.LWSeasonMain.Utils.SeasonRedPointUtils")

function LWS6RewardTabItem:OnCreate()
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

function LWS6RewardTabItem:OnDestroy()
  self.condition_dark = nil
  self.condition = nil
  self.red_point = nil
  self.red_num = nil
  base.OnDestroy(self)
end

function LWS6RewardTabItem:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.LWSeasonPersonalRewardGetRedPoint, self.RefreshRed)
  self:AddUIListener(EventId.LWSeasonAllianceRewardInfoUpdate, self.RefreshRed)
  self:AddUIListener(EventId.LWSeasonAllianceRewardCountUpdate, self.RefreshRed)
end

function LWS6RewardTabItem:OnRemoveListener()
  self:RemoveUIListener(EventId.LWSeasonPersonalRewardGetRedPoint, self.RefreshRed)
  self:RemoveUIListener(EventId.LWSeasonAllianceRewardInfoUpdate, self.RefreshRed)
  self:RemoveUIListener(EventId.LWSeasonAllianceRewardCountUpdate, self.RefreshRed)
  base.OnRemoveListener(self)
end

function LWS6RewardTabItem:OnEnable()
  base.OnEnable(self)
end

function LWS6RewardTabItem:OnDisable()
  base.OnDisable(self)
end

function LWS6RewardTabItem:ReInit(index, class, assetPath, tabName, param)
  self.index = index
  self.assetPath = assetPath
  self.class = class
  self.param = param
  self.name = tabName
  self.condition_dark:SetLocalText(self.name)
  self.condition:SetLocalText(self.name)
  self:RefreshRed()
end

function LWS6RewardTabItem:OnSelectStatusChanged(selected)
  if selected then
    self.view:OnTabActive(self)
  end
end

function LWS6RewardTabItem:RefreshRed()
  if self.index == 1 then
    self.red_point:SetActive(SeasonRedPointUtils.SeasonAllianceRewardDistributeBtnRedState())
  else
    self.red_point:SetActive(false)
  end
end

return LWS6RewardTabItem
