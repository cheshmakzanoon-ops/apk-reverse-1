local LWSeasonMainTabItem = BaseClass("LWSeasonMainTabItem", UIToggle)
local base = UIToggle
local Localization = CS.GameEntry.Localization
local SeasonRedPointUtils = require("UI.LWSeason.LWSeasonMain.Utils.SeasonRedPointUtils")

function LWSeasonMainTabItem:OnCreate()
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

function LWSeasonMainTabItem:OnDestroy()
  self.condition_dark = nil
  self.condition = nil
  self.icon = nil
  self.red_point = nil
  self.red_num = nil
  self.new_dot = nil
  base.OnDestroy(self)
end

function LWSeasonMainTabItem:OnEnable()
  base.OnEnable(self)
  self:SetRedPoint()
end

function LWSeasonMainTabItem:OnDisable()
  base.OnDisable(self)
end

function LWSeasonMainTabItem:OnAddListener()
  base.OnAddListener(self)
  if CS.ClientSwitch.IsOn(CS.ClientSwitch.DISABLE_RED_POINT_TREE) then
    self:AddUIListener(EventId.LWSeasonWeekCardTabRedPoint, self.WeekDataUpdate)
    self:AddUIListener(EventId.LWSeasonHeroPromoteTabRedPoint, self.HeroPromoteUpdate)
  end
  self:AddUIListener(EventId.LWSeasonBattlePassTabRedPoint, self.BattlePassUpdate)
  self:AddUIListener(EventId.LWSeasonCrossAttackCityInfo, self.OnCrossAttackCityInfoUpdate)
  self:AddUIListener(EventId.LWSeasonCrossDeclareWarInfo, self.OnCrossDeclareWarInfoUpdate)
  self:AddUIListener(EventId.LWSeasonCrossDeclareWarRedPointUpdate, self.OnCrossDeclareWarInfoUpdate)
  self:AddUIListener(EventId.LWSeasonPersonalRewardGetRedPoint, self.SeasonMainTab)
  self:AddUIListener(EventId.LWSeasonTrendsRewardRedPoint, self.SeasonMainTab)
end

function LWSeasonMainTabItem:OnRemoveListener()
  if CS.ClientSwitch.IsOn(CS.ClientSwitch.DISABLE_RED_POINT_TREE) then
    self:RemoveUIListener(EventId.LWSeasonWeekCardTabRedPoint, self.WeekDataUpdate)
    self:RemoveUIListener(EventId.LWSeasonHeroPromoteTabRedPoint, self.HeroPromoteUpdate)
  end
  self:RemoveUIListener(EventId.LWSeasonBattlePassTabRedPoint, self.BattlePassUpdate)
  self:RemoveUIListener(EventId.LWSeasonCrossAttackCityInfo, self.OnCrossAttackCityInfoUpdate)
  self:RemoveUIListener(EventId.LWSeasonCrossDeclareWarInfo, self.OnCrossDeclareWarInfoUpdate)
  self:RemoveUIListener(EventId.LWSeasonCrossDeclareWarRedPointUpdate, self.OnCrossDeclareWarInfoUpdate)
  self:RemoveUIListener(EventId.LWSeasonPersonalRewardGetRedPoint, self.SeasonMainTab)
  self:RemoveUIListener(EventId.LWSeasonTrendsRewardRedPoint, self.SeasonMainTab)
  base.OnRemoveListener(self)
end

function LWSeasonMainTabItem:ReInit(index, class, assetPath, data, tabName, tabIdentify)
  self.index = index
  self.assetPath = assetPath
  self.class = class
  self.data = data
  self.name = data and data.name or tabName or "372337"
  if tabIdentify then
    self.activityId = tostring(tabIdentify)
  elseif data and data.activityId then
    self.activityId = tostring(data.activityId)
  elseif data and data.id then
    self.activityId = tostring(data.id)
  else
    self.activityId = tostring(self.name)
  end
  self.condition:SetLocalText(self.name)
  self.condition_dark:SetLocalText(self.name)
  if data and not string.IsNullOrEmpty(data.list_icon) then
    self.icon:SetActive(true)
    self.condition:SetActive(false)
    self.icon_path = string.format(LoadPath.ActivityIconPath, data.list_icon)
  else
    self.icon:SetActive(false)
    self.condition:SetActive(true)
  end
  self:SetRedPoint()
end

function LWSeasonMainTabItem:OnSelectStatusChanged(selected)
  if selected then
    if self.icon_path then
      self.icon:LoadSprite(self.icon_path)
      self.icon:SetNativeSize()
      self.icon_path = nil
    end
    if self.assetPath == nil and self.data and self.data.id then
      local handlerData = SeasonUtil.GetSeasonActivityContentHandler(self.data.type)
      if handlerData == nil then
        handlerData = DataCenter.ActivityListDataManager:GetActivityShowData(self.data.id)
      elseif handlerData.cls == nil and handlerData.clsPath ~= nil then
        handlerData.cls = require(handlerData.clsPath)
      end
      if handlerData ~= nil and handlerData.assetPath ~= nil and handlerData.cls ~= nil then
        self.assetPath = handlerData.assetPath
        self.class = handlerData.cls
      end
    end
    self.view:OnTabActive(self)
  end
end

function LWSeasonMainTabItem:SetRedPoint()
  if self.activityId == "WeekCard" then
    if CS.ClientSwitch.IsOn(CS.ClientSwitch.DISABLE_RED_POINT_TREE) then
      self.red_point:SetActive(SeasonRedPointUtils.GetWeekCardTabBtn(self.data))
    end
    return
  end
  if self.class and self.class.__cname == "SeasonInfo" then
    self.red_point:SetActive(SeasonRedPointUtils.SeasonMainTab())
    self.red_num:SetActive(false)
    return
  end
  if not (self.data and self.data.instanceOf) or not self.data:instanceOf("ActivityInfoData") then
    return
  end
  if self.data.type == EnumActivity.BattlePass_new.Type then
    self.red_point:SetActive(SeasonRedPointUtils.SeasonBattlePassTabRedPoint(self.data.activityId))
  elseif self.data.type == EnumActivity.ActHeroPromotion.Type then
    self.red_point:SetActive(SeasonRedPointUtils.SeasonHeroPromotionRedPoint(self.data.activityId))
  elseif self.data.type == EnumActivity.SeasonCrossAttackCityActivity.Type then
    local count = SeasonRedPointUtils.GetCrossAttackCityRedPoint()
    self.red_num:SetText(tostring(count))
    self.red_num:SetActive(1 < count)
    self.red_point:SetActive(0 < count)
  elseif self.data.type == EnumActivity.SeasonCrossDeclareWarActivity.Type then
    local count = SeasonRedPointUtils.GetCrossDeclareWarRedPoint(nil)
    self.red_num:SetText(tostring(count))
    self.red_num:SetActive(1 < count)
    self.red_point:SetActive(0 < count)
  elseif self.data.type == EnumActivity.SeasonAttackCityActivity.Type then
    local count = 0
    if LuaEntry.Player:IsInAlliance() then
      local data = DataCenter.AllianceDeclareWarManager:GetSelfDeclareWarData()
      if data and data.content then
        local click_count = UIUtil.GetTodayActiveCount("SeasonAttackCity" .. data.content, false)
        if click_count == 0 then
          count = 1
        end
      end
    end
    self.red_num:SetActive(false)
    self.red_point:SetActive(0 < count)
  end
end

function LWSeasonMainTabItem:OnCrossAttackCityInfoUpdate()
  if self.data and self.data.type == EnumActivity.SeasonCrossAttackCityActivity.Type then
    self:SetRedPoint()
  end
end

function LWSeasonMainTabItem:OnCrossDeclareWarInfoUpdate()
  if self.data and self.data.type == EnumActivity.SeasonCrossDeclareWarActivity.Type then
    self:SetRedPoint()
  end
end

function LWSeasonMainTabItem:WeekDataUpdate(cardId)
  if not CS.ClientSwitch.IsOn(CS.ClientSwitch.DISABLE_RED_POINT_TREE) then
    return
  end
  if self.data and self.activityId == "WeekCard" and tostring(self.data) == tostring(cardId) then
    self:SetRedPoint()
  end
end

function LWSeasonMainTabItem:BattlePassUpdate(activityId)
  if self.data and self.data.activityId == tostring(activityId) then
    self:SetRedPoint()
  end
end

function LWSeasonMainTabItem:HeroPromoteUpdate(activityId)
  self:SetRedPoint()
end

function LWSeasonMainTabItem:SeasonMainTab()
  self:SetRedPoint()
end

return LWSeasonMainTabItem
