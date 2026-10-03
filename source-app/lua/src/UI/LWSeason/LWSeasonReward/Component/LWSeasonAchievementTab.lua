local LWSeasonAchievementTab = BaseClass("LWSeasonAchievementTab", UIToggle)
local base = UIToggle
local Localization = CS.GameEntry.Localization
local SeasonRedPointUtils = require("UI.LWSeason.LWSeasonMain.Utils.SeasonRedPointUtils")

function LWSeasonAchievementTab:OnCreate()
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
  self.red_num:SetText("")
  self.red_point:SetActive(false)
  self.new_dot:SetActive(false)
end

function LWSeasonAchievementTab:OnDestroy()
  self.condition_dark = nil
  self.condition = nil
  self.icon = nil
  self.red_point = nil
  self.red_num = nil
  self.new_dot = nil
  base.OnDestroy(self)
end

function LWSeasonAchievementTab:OnEnable()
  base.OnEnable(self)
end

function LWSeasonAchievementTab:OnDisable()
  base.OnDisable(self)
end

function LWSeasonAchievementTab:OnAddListener()
  base.OnAddListener(self)
end

function LWSeasonAchievementTab:OnRemoveListener()
  base.OnRemoveListener(self)
end

function LWSeasonAchievementTab:ReInit(data, index, parent)
  self.index = index
  self.parent = parent
  self.data = data
  self.condition:SetLocalText(data.key)
  self.condition_dark:SetLocalText(data.key)
  self.icon:SetActive(false)
  self:InitRedPoint()
  self:RefreshRed()
end

function LWSeasonAchievementTab:OnSelectStatusChanged(selected)
  if selected then
    if not self.selecting then
      DataCenter.LWSoundManager:PlaySound(6100022, false)
    end
    self.parent:OnTabActive(self)
  end
  self.selecting = false
end

function LWSeasonAchievementTab:RefreshRed()
  if not CS.ClientSwitch.IsOn(CS.ClientSwitch.DISABLE_RED_POINT_TREE) then
    return
  end
  self.red_point:SetActive(DataCenter.SeasonRewardDataManager:IsGetRewardTabRed(self.data.type))
end

function LWSeasonAchievementTab:InitRedPoint()
  if CS.ClientSwitch.IsOn(CS.ClientSwitch.DISABLE_RED_POINT_TREE) then
    return
  end
  self:BindRedPointUI(self.red_point, nil, {
    RedDef.Season,
    RedDef.SeasonMainTab,
    RedDef.SeasonPersonalReward,
    self.data.type
  })
end

return LWSeasonAchievementTab
