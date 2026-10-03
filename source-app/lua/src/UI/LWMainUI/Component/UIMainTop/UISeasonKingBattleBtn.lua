local UISeasonKingBattleBtn = BaseClass("UISeasonKingBattleBtn", UIAsyncContainer)
local base = UIAsyncContainer
local bg_path = "Bg"
local btn_text_path = "BtnText"
local red_point_num_path = "RedPointNum"
local text_path = "RedPointNum/Text"

function UISeasonKingBattleBtn:UpdateData()
  self:RefreshShowState()
end

function UISeasonKingBattleBtn:RefreshShowState()
  if not self:AsyncLoadDone() then
    return
  end
  if self:CheckShowBtn() then
    self.activityId = DataCenter.SeasonNineKingManager:GetActivityId()
    self:SetActive(true)
    self.btnText:SetLocalText("season_s5_activity_1200067_name02")
    self:OnRedPointRefresh()
    return
  end
  self:SetActive(false)
  self.redPoint:SetActive(false)
end

function UISeasonKingBattleBtn:CheckShowBtn()
  return DataCenter.SeasonNineKingManager:IsActive(true)
end

function UISeasonKingBattleBtn:OnBtnClick()
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIKingBattle, {anim = true})
end

function UISeasonKingBattleBtn:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:AddUIListener(EventId.MainLvUp, self.RefreshShowState)
  self:AddUIListener(EventId.NineNationKingBattleEventInfoUpdate, self.RefreshShowState)
  self:AddUIListener(EventId.SeasonNineKingRewardRedPointChange, self.OnRedPointRefresh)
end

function UISeasonKingBattleBtn:OnDestroy()
  self:RemoveUIListener(EventId.MainLvUp, self.RefreshShowState)
  self:RemoveUIListener(EventId.NineNationKingBattleEventInfoUpdate, self.RefreshShowState)
  self:RemoveUIListener(EventId.SeasonNineKingRewardRedPointChange, self.OnRedPointRefresh)
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UISeasonKingBattleBtn:OnRedPointRefresh()
  if not self:AsyncLoadDone() then
    return
  end
  local count = DataCenter.SeasonNineKingManager.redPointCount
  self.redPoint:SetActive(0 < count)
  self.redText:SetActive(0 < count)
  self.redText:SetText(tostring(count))
end

function UISeasonKingBattleBtn:ComponentDefine()
  self.bg = self:AddComponent(UIImage, bg_path)
  self.btnText = self:AddComponent(UIText, btn_text_path)
  self.btn = self:AddComponent(UIButton, "")
  self.redPoint = self:AddComponent(UIBaseContainer, red_point_num_path)
  self.redText = self:AddComponent(UIText, text_path)
  self.btn:SetOnClick(function()
    self:OnBtnClick()
  end)
  self.redText:SetActive(false)
end

function UISeasonKingBattleBtn:ComponentDestroy()
  self.bg = nil
  self.icon = nil
  self.btnText = nil
  self.redPoint = nil
  self.redText = nil
end

return UISeasonKingBattleBtn
