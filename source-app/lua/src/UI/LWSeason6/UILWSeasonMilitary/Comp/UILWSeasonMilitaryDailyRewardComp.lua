local p_list_view_daily_reward_path = "content/p_list_view_daily_reward"
local p_btn_claim_daily_path = "content/p_btn_claim_daily"
local p_text_claim_daily_path = "content/p_btn_claim_daily/base/p_text_claim_daily"
local base = UIBaseContainer
local RewardUtil = require("Util.RewardUtil")
local UILWSeasonMilitaryItemCell = require("UI.LWSeason6.UILWSeasonMilitary.Cell.UILWSeasonMilitaryItemCell")
local UILWSeasonMilitaryDailyRewardComp = BaseClass("UILWSeasonMilitaryDailyRewardComp", UIBaseContainer)

function UILWSeasonMilitaryDailyRewardComp:ComponentDefine()
  self.p_list_view_daily_reward = self:AddComponent(UILoopListViewSimple, p_list_view_daily_reward_path)
  self.p_btn_claim_daily = self:AddComponent(UIButton, p_btn_claim_daily_path)
  self.p_btn_claim_daily:SetOnClick(BindCallback(self, self.OnClaimClicked))
  self.p_text_claim_daily = self:AddComponent(UITextMeshProUGUIEx, p_text_claim_daily_path)
end

function UILWSeasonMilitaryDailyRewardComp:ComponentDestroy()
  self.p_list_view_daily_reward = nil
  self.p_btn_claim_daily = nil
  self.p_text_claim_daily = nil
end

function UILWSeasonMilitaryDailyRewardComp:DataDefine()
end

function UILWSeasonMilitaryDailyRewardComp:DataDestroy()
end

function UILWSeasonMilitaryDailyRewardComp:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UILWSeasonMilitaryDailyRewardComp:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UILWSeasonMilitaryDailyRewardComp:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.SeasonMilitaryClaimDaily, self.OnClaimDaily)
end

function UILWSeasonMilitaryDailyRewardComp:OnRemoveListener()
  self:RemoveUIListener(EventId.SeasonMilitaryClaimDaily, self.OnClaimDaily)
  base.OnRemoveListener(self)
end

function UILWSeasonMilitaryDailyRewardComp:ReInit(data)
  if self:InitData(data) then
    self:InitUi()
    if self:UpdateData() then
      self:UpdateUi()
    end
  end
end

function UILWSeasonMilitaryDailyRewardComp:InitData(data)
  self.InfoData = DataCenter.SeasonMilitaryManager.InfoData
  if self.InfoData ~= nil then
    local cell = self.InfoData.Cell
    if cell ~= nil then
      self.Rewards = RewardUtil.GetRewardItem(cell.daily_salary)
      return not table.IsNullOrEmpty(self.Rewards)
    end
  end
  return false
end

function UILWSeasonMilitaryDailyRewardComp:InitUi()
  self.p_list_view_daily_reward:Init(UILWSeasonMilitaryItemCell)
  self.p_list_view_daily_reward:Clear()
  for _, reward in pairs(self.Rewards) do
    self.p_list_view_daily_reward:AddData(reward)
  end
  self.p_list_view_daily_reward:Show()
end

function UILWSeasonMilitaryDailyRewardComp:UpdateData()
  return true
end

function UILWSeasonMilitaryDailyRewardComp:UpdateUi()
  self:UpdateBtnState()
end

function UILWSeasonMilitaryDailyRewardComp:UpdateBtnState()
  if self.InfoData == nil then
    return
  end
  local canClaim = self.InfoData:CanClaim()
  CS.UIGray.SetGray(self.p_btn_claim_daily.transform, not canClaim, true)
  if canClaim then
    self.p_text_claim_daily:SetLocalText("season_military_claim_salary_btn")
  end
end

function UILWSeasonMilitaryDailyRewardComp:OnClaimClicked()
  if self.InfoData == nil then
    return
  end
  if self.InfoData:CanClaim() then
    DataCenter.SeasonMilitaryManager:SendClaimDaily(self.InfoData:GetLevel())
  else
  end
end

function UILWSeasonMilitaryDailyRewardComp:OnClaimDaily(evt)
  if self:UpdateData() then
    self:UpdateUi()
  end
end

function UILWSeasonMilitaryDailyRewardComp:Update1000MS()
  if self.InfoData == nil then
    return
  end
  if not self.InfoData:CanClaim() then
    local nextTime = UITimeManager:GetInstance():GetTomorrowZero()
    local leftTime = Mathf.Max(0, nextTime - UITimeManager:GetInstance():GetServerTime())
    self.p_text_claim_daily:SetText(UITimeManager:GetInstance():MilliSecondToFmtString(leftTime))
  end
end

return UILWSeasonMilitaryDailyRewardComp
