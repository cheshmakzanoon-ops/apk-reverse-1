local LWSeasonTabItem = BaseClass("LWSeasonTabItem", UIToggle)
local base = UIToggle
local Localization = CS.GameEntry.Localization
local SeasonRedPointUtils = require("UI.LWSeason.LWSeasonMain.Utils.SeasonRedPointUtils")

function LWSeasonTabItem:OnCreate()
  base.OnCreate(self)
  self.condition_dark = self:AddComponent(UIText, "ConditionDark")
  self.condition = self:AddComponent(UIText, "ConditionSelect/Condition")
  self:SetOnValueChanged(function(tf)
    self:OnSelectStatusChanged(tf)
  end)
  self.icon = self:AddComponent(UIImage, "ConditionSelect/Icon")
  self.red_point = self:AddComponent(UIImage, "RedPoint")
  self.red_num = self:AddComponent(UIText, "RedPoint/RedNum")
  self.new_dot = self:AddComponent(UIBaseContainer, "NewDot")
  self.red_point:SetActive(false)
  self.new_dot:SetActive(false)
end

function LWSeasonTabItem:OnDestroy()
  self.condition_dark = nil
  self.condition = nil
  self.icon = nil
  self.red_point = nil
  self.red_num = nil
  self.new_dot = nil
  base.OnDestroy(self)
end

function LWSeasonTabItem:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.LWSeasonPersonalRewardGetRedPoint, self.RefreshRed)
  self:AddUIListener(EventId.LWSeasonAllianceRewardInfoUpdate, self.RefreshRed)
  self:AddUIListener(EventId.LWSeasonAllianceRewardCountUpdate, self.RefreshRed)
end

function LWSeasonTabItem:OnRemoveListener()
  self:RemoveUIListener(EventId.LWSeasonPersonalRewardGetRedPoint, self.RefreshRed)
  self:RemoveUIListener(EventId.LWSeasonAllianceRewardInfoUpdate, self.RefreshRed)
  self:RemoveUIListener(EventId.LWSeasonAllianceRewardCountUpdate, self.RefreshRed)
  base.OnRemoveListener(self)
end

function LWSeasonTabItem:OnEnable()
  base.OnEnable(self)
end

function LWSeasonTabItem:OnDisable()
  base.OnDisable(self)
end

function LWSeasonTabItem:ReInit(index, class, assetPath, tabName, param)
  self.index = index
  self.assetPath = assetPath
  self.class = class
  self.param = param
  self.name = tabName
  self.condition_dark:SetLocalText(self.name)
  self.condition:SetLocalText(self.name)
  self:RefreshRed()
end

function LWSeasonTabItem:OnSelectStatusChanged(selected)
  if selected then
    self.view:OnTabActive(self)
  end
end

function LWSeasonTabItem:RefreshRed()
  if self.index == 1 then
    self.red_point:SetActive(SeasonRedPointUtils.SeasonAllianceRewardDistributeBtnRedState())
  elseif self.index == 2 then
    self.red_point:SetActive(SeasonRedPointUtils.SeasonPersonalRewardAllGetBtnRedState())
  else
    self.red_point:SetActive(false)
  end
end

return LWSeasonTabItem
