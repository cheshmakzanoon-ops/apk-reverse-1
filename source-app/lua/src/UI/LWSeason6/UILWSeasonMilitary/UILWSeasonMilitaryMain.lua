local p_comp_level_path = "Root/mid/p_comp_level"
local p_content_benefit_path = "Root/mid/content_detail/p_content_benefit"
local p_content_daily_reward_path = "Root/mid/content_detail/p_content_daily_reward"
local p_content_upgrade_path = "Root/mid/content_detail/p_content_upgrade"
local p_content_settlement_reward_path = "Root/mid/content_detail/p_content_settlement_reward"
local p_toggle_group_path = "Root/bottom/base/p_toggle_group"
local p_act_name_path = "Root/top/p_act_name"
local p_btn_info_path = "Root/top/p_btn_info"
local p_btn_record_path = "Root/top/p_btn_record"
local p_btn_reward_path = "Root/top/p_btn_reward"
local p_btn_trend_path = "Root/top/p_btn_trend"
local p_text_btn_trend_path = "Root/top/p_btn_trend/p_text_btn_trend"
local p_go_reward_tips_path = "Root/top/p_btn_reward/p_go_reward_tips"
local p_template_reward_path = "Root/top/p_btn_reward/p_go_reward_tips/p_template_reward"
local p_content_reward_root_path = "Root/top/p_btn_reward/p_go_reward_tips/p_content_reward_root"
local UILWSeasonMilitaryLevelPreviewComp = require("UI.LWSeason6.UILWSeasonMilitary.Comp.UILWSeasonMilitaryLevelPreviewComp")
local UILWSeasonMilitaryBenefitComp = require("UI.LWSeason6.UILWSeasonMilitary.Comp.UILWSeasonMilitaryBenefitComp")
local UILWSeasonMilitaryDailyRewardComp = require("UI.LWSeason6.UILWSeasonMilitary.Comp.UILWSeasonMilitaryDailyRewardComp")
local UILWSeasonMilitarySettlementComp = require("UI.LWSeason6.UILWSeasonMilitary.Comp.UILWSeasonMilitarySettlementComp")
local UILWSeasonMilitaryUpgradeComp = require("UI.LWSeason6.UILWSeasonMilitary.Comp.UILWSeasonMilitaryUpgradeComp")
local UICommonToggleListComponent = require("UI.UILWCommon.UICommonToggleList.UICommonToggleListComponent")
local base = UIBaseContainer
local UILWSeasonMilitaryMain = BaseClass("UILWSeasonMilitaryMain", UIBaseContainer)

function UILWSeasonMilitaryMain:ComponentDefine()
  self.compAnimator = self:AddComponent(UIAnimator, "")
  self.compAnimator:Play("S6MilitaryMain_movein")
  self.IsOpenAnimDone = false
  self.p_toggle_list = self:AddComponent(UICommonToggleListComponent, p_toggle_group_path)
  self.p_act_name = self:AddComponent(UITextMeshProUGUIEx, p_act_name_path)
  self.p_btn_info = self:AddComponent(UIButton, p_btn_info_path)
  self.p_btn_info:SetOnClick(BindCallback(self, self.OnInfoClicked))
  self.p_btn_record = self:AddComponent(UIButton, p_btn_record_path)
  self.p_btn_record:SetOnClick(BindCallback(self, self.OnRecordClicked))
  self.p_btn_reward = self:AddComponent(UIButton, p_btn_reward_path)
  self.p_btn_reward:SetOnClick(BindCallback(self, self.OnRewardClicked))
  self.p_btn_trend = self:AddComponent(UIButton, p_btn_trend_path)
  self.p_btn_trend:SetOnClick(BindCallback(self, self.OnTrendClicked))
  self.p_text_btn_trend = self:AddComponent(UITextMeshProUGUIEx, p_text_btn_trend_path)
  self.p_go_reward_tips = self:AddComponent(UIBaseContainer, p_go_reward_tips_path)
  self.p_template_reward = self:AddComponent(UIBaseContainer, p_template_reward_path)
  self.p_content_reward_root = self:AddComponent(UIGameObjectPoolRoot, p_content_reward_root_path)
  self.p_content_reward_root:Init(self.p_template_reward.gameObject, UICommonResItem)
  self.p_content_reward_root:Clear()
  self.p_go_reward_tips:SetActive(false)
  self.p_comp_level = self:AddComponent(UILWSeasonMilitaryLevelPreviewComp, p_comp_level_path)
  self.p_content_benefit = self:AddComponent(UILWSeasonMilitaryBenefitComp, p_content_benefit_path)
  self.p_content_daily_reward = self:AddComponent(UILWSeasonMilitaryDailyRewardComp, p_content_daily_reward_path)
  self.p_content_settlement_reward = self:AddComponent(UILWSeasonMilitarySettlementComp, p_content_settlement_reward_path)
  self.p_content_upgrade = self:AddComponent(UILWSeasonMilitaryUpgradeComp, p_content_upgrade_path)
end

function UILWSeasonMilitaryMain:ComponentDestroy()
  self.compAnimator = nil
  self.p_comp_level = nil
  self.p_content_benefit = nil
  self.p_content_daily_reward = nil
  self.p_content_upgrade = nil
  self.p_content_settlement_reward = nil
  self.p_toggle_list = nil
  self.p_act_name = nil
  self.p_btn_info = nil
  self.p_btn_record = nil
  self.p_btn_reward = nil
  self.p_btn_trend = nil
  self.p_text_btn_trend = nil
  self.p_go_reward_tips = nil
  self.p_template_reward = nil
  self.p_content_reward_root = nil
end

function UILWSeasonMilitaryMain:DataDefine()
  self.CurTab = -1
  self.Tab = {Detail = 1, Upgrade = 2}
  self.TickAct = false
end

function UILWSeasonMilitaryMain:DataDestroy()
  self.CurTab = -1
  self.TickAct = false
  if self.OpenAnimTimer ~= nil then
    self.OpenAnimTimer:Stop()
    self.OpenAnimTimer = nil
  end
  if self.OpenTipsTimer ~= nil then
    self.OpenTipsTimer:Stop()
    self.OpenTipsTimer = nil
  end
  if self.OpenTrendPopupTimer ~= nil then
    self.OpenTrendPopupTimer:Stop()
    self.OpenTrendPopupTimer = nil
  end
  if self.CloseTipsTimer ~= nil then
    self.CloseTipsTimer:Stop()
    self.CloseTipsTimer = nil
    self:CloseTips()
  end
end

function UILWSeasonMilitaryMain:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UILWSeasonMilitaryMain:OnDestroy()
  DataCenter.SeasonMilitaryManager.AnimLevel = -1
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UILWSeasonMilitaryMain:SetData(actId, _)
  self.ActData = DataCenter.ActivityListDataManager:GetActivityDataById(actId)
  if self.ActData ~= nil then
    self:ReInit()
  end
end

function UILWSeasonMilitaryMain:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.SeasonMilitaryInfoUpdate, self.OnInfoUpdateEvt)
  self:AddUIListener(EventId.SeasonMilitaryLevelPreview, self.OnLevelPreviewEvt)
  self:AddUIListener(EventId.SeasonMilitaryLevelUpUpdate, self.OnLevelUpEvt)
  self:AddUIListener(EventId.SeasonMilitaryClaimDaily, self.OnClaimDailyEvt)
end

function UILWSeasonMilitaryMain:OnRemoveListener()
  self:RemoveUIListener(EventId.SeasonMilitaryInfoUpdate, self.OnInfoUpdateEvt)
  self:RemoveUIListener(EventId.SeasonMilitaryLevelPreview, self.OnLevelPreviewEvt)
  self:RemoveUIListener(EventId.SeasonMilitaryLevelUpUpdate, self.OnLevelUpEvt)
  self:RemoveUIListener(EventId.SeasonMilitaryClaimDaily, self.OnClaimDailyEvt)
  base.OnRemoveListener(self)
end

function UILWSeasonMilitaryMain:ReInit()
  if self:InitData() then
    self:InitUi()
    if self:UpdateData() then
      self:UpdateUi()
    end
    self:Update1000MS()
    DataCenter.SeasonMilitaryManager:SendGetInfo()
  end
end

function UILWSeasonMilitaryMain:InitData()
  self.InfoData = DataCenter.SeasonMilitaryManager.InfoData
  self.IsNewInfoCallback = false
  self.CurActState = DataCenter.SeasonMilitaryManager:GetCurActState()
  if self.InfoData ~= nil then
    return true
  end
  return false
end

function UILWSeasonMilitaryMain:InitUi()
  self.p_act_name:SetLocalText(self.ActData.name)
  self:InitToggle(self.Tab.Detail)
  self.WillShowTrend = false
  self.OpenAnimTimer = TimerManager:GetInstance():DelayInvoke(function()
    self:OnOpenAnimDone()
  end, 2)
end

function UILWSeasonMilitaryMain:UpdateRewardTips()
  local hasShown = CommonUtil.PlayerPrefsGetBool(SettingKeys.S6_MILITARY_REWARD_POPUP_SHOWN, false)
  if not hasShown then
    self.p_go_reward_tips:SetActive(true)
    self.p_content_reward_root:Clear()
    local rewardData = {
      rewardType = RewardType.GOODS,
      itemId = 510033,
      count = nil
    }
    self.p_content_reward_root:AddData(rewardData)
  else
    self.p_go_reward_tips:SetActive(false)
  end
end

function UILWSeasonMilitaryMain:OnOpenAnimDone()
  self.IsOpenAnimDone = true
  local endShowTime = DataCenter.SeasonMilitaryManager:GetTrendSettlementTime()
  local leftTime = endShowTime - UITimeManager:GetInstance():GetServerTime()
  if leftTime <= OneDayTime * 1000 then
    if 0 < leftTime then
      self:OpenTips()
    elseif LuaEntry.Player:GetUserSetting(UserSettingKey.SeasonMilitaryTradePopup) ~= "1" then
      self.WillShowTrend = true
      LuaEntry.Player:SetUserSetting(UserSettingKey.SeasonMilitaryTradePopup, "1")
      SFSNetwork.SendMessage(MsgDefines.UserSetting, UserSettingKey.SeasonMilitaryTradePopup, "1")
      self:OnTrendClicked()
    end
  end
  if not self.WillShowTrend then
    self:TryShowLevelSettlement()
  end
  self:UpdateRewardTips()
end

function UILWSeasonMilitaryMain:TryShowLevelSettlement()
  if self.InfoData ~= nil and self.IsNewInfoCallback and self.IsOpenAnimDone then
    local lastSettlementTime = checknumber(LuaEntry.Player:GetUserSetting(UserSettingKey.SeasonMilitaryAutoUpgrade))
    if not DataCenter.SeasonMilitaryManager:IsSameSettlementCycle(lastSettlementTime) then
      local level = checknumber(self.InfoData:GetLevel())
      local maxManualLevel = DataCenter.SeasonMilitaryManager:GetMaxManualLevel()
      if level > maxManualLevel then
        local now = checkstring(UITimeManager:GetInstance():GetServerTime())
        LuaEntry.Player:SetUserSetting(UserSettingKey.SeasonMilitaryAutoUpgrade, now)
        SFSNetwork.SendMessage(MsgDefines.UserSetting, UserSettingKey.SeasonMilitaryAutoUpgrade, now)
        local param = {}
        param.Level = level
        param.IsAuto = true
        UIManager:GetInstance():OpenWindow(UIWindowNames.S6MilitaryLevelUp, {anim = true}, param)
      end
    end
  end
end

function UILWSeasonMilitaryMain:OpenTips()
  local param = {}
  param.type = "desc"
  param.title = ""
  param.desc = "season_military_sp_reward_tips"
  param.alignObject = self.p_btn_trend
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIItemTips, {anim = true}, param)
  self.CloseTipsTimer = TimerManager:GetInstance():DelayInvoke(function()
    self:CloseTips()
  end, 2)
end

function UILWSeasonMilitaryMain:CloseTips()
  if UIManager:GetInstance():IsWindowOpen(UIWindowNames.UIItemTips) then
    UIManager:GetInstance():DestroyWindow(UIWindowNames.UIItemTips)
  end
end

function UILWSeasonMilitaryMain:UpdateData()
  self.InfoData = DataCenter.SeasonMilitaryManager.InfoData
  if self.InfoData ~= nil then
    self.LastTickTime = UITimeManager:GetInstance():GetServerSeconds()
    self.CurActState = DataCenter.SeasonMilitaryManager:GetCurActState()
    if self.CurActState == DataCenter.SeasonMilitaryManager.ActState.Normal then
      self.EndTime = DataCenter.SeasonMilitaryManager:GetEndShowStartTime()
    else
      self.EndTime = self.ActData:GetShowEndTime()
    end
    self.TickAct = true
    return true
  end
  return false
end

function UILWSeasonMilitaryMain:UpdateUi()
end

function UILWSeasonMilitaryMain:UpdateTradeBtn()
  local endShowTime = DataCenter.SeasonMilitaryManager:GetTrendSettlementTime()
  local leftTime = endShowTime - UITimeManager:GetInstance():GetServerTime()
  if 0 <= leftTime then
    self.p_btn_trend:SetActive(true)
    self.p_text_btn_trend:SetText(UITimeManager:GetInstance():MilliSecondToFmtString(leftTime))
  else
    self.p_btn_trend:SetActive(false)
  end
end

function UILWSeasonMilitaryMain:InitToggle(defaultTabIndex)
  defaultTabIndex = Mathf.Clamp(checknumber(defaultTabIndex), 1, 2)
  local tabKeys = {
    "season_military_tab_details_name",
    "season_military_tab_promote_name"
  }
  local tabs = {}
  for _, key in pairs(tabKeys) do
    local tabData = {}
    tabData.name = CS.GameEntry.Localization:GetString(key)
    table.insert(tabs, tabData)
  end
  local toggleListData = {}
  toggleListData.itemsDataList = tabs
  toggleListData.defaultSelectIndex = defaultTabIndex
  
  function toggleListData.onItemSelect(index, itemData)
    self:OnToggle(index)
  end
  
  function toggleListData.isCanSelect(index, itemData)
    local pastTime = UITimeManager:GetInstance():GetServerTime() - DataCenter.SeasonMilitaryManager.LastToggleTime
    if pastTime < 700 then
      return false
    end
    return index == self.Tab.Detail or index == self.Tab.Upgrade and self.CurActState == DataCenter.SeasonMilitaryManager.ActState.Normal
  end
  
  function toggleListData.isShowRed(index, itemData)
    if index == self.Tab.Detail then
      return DataCenter.SeasonMilitaryManager:ShowDailyRed()
    end
    if index == self.Tab.Upgrade then
      return DataCenter.SeasonMilitaryManager:ShowUpgradeRed()
    end
    return false
  end
  
  self.p_toggle_list:ReInit(toggleListData)
end

function UILWSeasonMilitaryMain:OnToggle(index, force)
  if self.CurTab == index and not force then
    return
  end
  DataCenter.SeasonMilitaryManager.LastToggleTime = UITimeManager:GetInstance():GetServerTime()
  if self.CurTab ~= -1 and not force then
    self.compAnimator:Play("S6MilitaryMain_switch")
  end
  self.CurTab = index
  self:ShowDetail(self.InfoData:GetLevel())
  self:ShowDailyReward()
  self:ShowSettlement()
  self:ShowUpgrade(self.InfoData:GetLevel())
end

function UILWSeasonMilitaryMain:InDetailTab()
  return self.CurTab == self.Tab.Detail
end

function UILWSeasonMilitaryMain:InUpgradeTab()
  return self.CurTab == self.Tab.Upgrade
end

function UILWSeasonMilitaryMain:ShowDetail(level)
  local curLevel = self.InfoData:GetLevel()
  self.p_comp_level:SetActive(true)
  local data = {}
  data.Level = level
  data.ShowSwitch = self.CurTab == 2
  data.MinLevel = self.InfoData:GetLevel()
  data.MaxLevel = DataCenter.SeasonMilitaryManager:GetMaxLevel()
  self.p_comp_level:ReInit(data)
  self.p_content_benefit:SetActive(true)
  local benefitData = {}
  benefitData.Level = level
  benefitData.IsPreview = self.CurTab == 2 and level > curLevel
  benefitData.IsUpgrade = self.CurTab == 2 and curLevel == level
  self.p_content_benefit:ReInit(benefitData)
end

function UILWSeasonMilitaryMain:ShowDailyReward()
  local isShow = self.CurTab == self.Tab.Detail
  isShow = isShow and self.CurActState == DataCenter.SeasonMilitaryManager.ActState.Normal
  self.p_content_daily_reward:SetActive(isShow)
  if isShow then
    self.p_content_daily_reward:ReInit()
  end
end

function UILWSeasonMilitaryMain:ShowSettlement()
  local isShow = self.CurTab == self.Tab.Detail
  isShow = isShow and self.CurActState == DataCenter.SeasonMilitaryManager.ActState.EndShow
  self.p_content_settlement_reward:SetActive(isShow)
  if isShow then
    self.p_content_settlement_reward:ReInit()
  end
end

function UILWSeasonMilitaryMain:ShowUpgrade(level)
  local isShow = self.CurTab == self.Tab.Upgrade
  isShow = isShow and self.CurActState == DataCenter.SeasonMilitaryManager.ActState.Normal
  self.p_content_upgrade:SetActive(isShow)
  if isShow then
    local curLevel = self.InfoData:GetLevel()
    local data = {}
    data.Level = level
    data.IsUpgrade = curLevel == level
    data.IsPreview = level > curLevel
    self.p_content_upgrade:ReInit(data)
  end
end

function UILWSeasonMilitaryMain:OnInfoClicked()
  if not self.IsOpenAnimDone then
    return
  end
  if self.ActData == nil or table.IsNullOrEmpty(self.ActData.howtoplay) then
    return
  end
  local param = {}
  param.howToPlayList = self.ActData.howtoplay
  param.story = self.ActData.story
  param.defaultTitle = self.ActData.name
  UIManager:GetInstance():OpenWindow(UIWindowNames.UILWHowToPlay, {anim = true}, param)
end

function UILWSeasonMilitaryMain:OnRecordClicked()
  if not self.IsOpenAnimDone then
    return
  end
  DataCenter.SeasonMilitaryManager.AnimLevel = -1
  DataCenter.SeasonMilitaryEliteManager:SetOpenParam("open_default_period", 2)
  GoToUtil.GotoSeasonActivityView(EnumActivity.SeasonMilitaryElite.Type)
end

function UILWSeasonMilitaryMain:OnRewardClicked()
  if not self.IsOpenAnimDone then
    return
  end
  local hasShown = CommonUtil.PlayerPrefsGetBool(SettingKeys.S6_MILITARY_REWARD_POPUP_SHOWN, false)
  local data = {}
  data.DefaultIndex = hasShown and 1 or 2
  CommonUtil.PlayerPrefsSetBool(SettingKeys.S6_MILITARY_REWARD_POPUP_SHOWN, true)
  self:UpdateRewardTips()
  UIManager:GetInstance():OpenWindow(UIWindowNames.S6MilitaryReward, {anim = true}, data)
end

function UILWSeasonMilitaryMain:OnInfoUpdateEvt(evt)
  if self:InitData() then
    if self:UpdateData() then
      self:OnToggle(self.CurTab, true)
    end
    self.p_toggle_list:UpdateRed()
    self.IsNewInfoCallback = true
    if not self.WillShowTrend then
      self:TryShowLevelSettlement()
    end
  end
end

function UILWSeasonMilitaryMain:OnLevelPreviewEvt(evt)
  if checknumber(self.CurTab) ~= 2 then
    return
  end
  local previewLevel = checknumber(evt)
  self:ShowDetail(previewLevel)
  self:ShowUpgrade(previewLevel)
end

function UILWSeasonMilitaryMain:OnLevelUpEvt(payload)
  if payload == nil then
    return
  end
  local level = checknumber(payload.militaryLevel)
  if 1 < level then
    local param = {}
    param.Level = level
    UIManager:GetInstance():OpenWindow(UIWindowNames.S6MilitaryLevelUp, {anim = true}, param)
  end
  if self:UpdateData() then
    self:OnToggle(self.CurTab, true)
  end
  self.p_toggle_list:UpdateRed()
end

function UILWSeasonMilitaryMain:OnClaimDailyEvt()
  self:InitToggle(self.CurTab)
end

function UILWSeasonMilitaryMain:OnTrendClicked()
  if not self.IsOpenAnimDone then
    return
  end
  UIManager:GetInstance():OpenWindow(UIWindowNames.S6MilitaryTrendPopupView)
end

function UILWSeasonMilitaryMain:Update1000MS()
  self:UpdateTradeBtn()
  if not self.TickAct then
    return
  end
  local now = UITimeManager:GetInstance():GetServerSeconds()
  if not UITimeManager:GetInstance():IsSameDayForServer(checknumber(self.LastTickTime), now) then
    self:ReInit()
  end
  self.LastTickTime = now
end

return UILWSeasonMilitaryMain
