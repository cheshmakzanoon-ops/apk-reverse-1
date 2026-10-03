local SeasonSelectLocationGameRewardView = BaseClass("SeasonSelectLocationGameRewardView", UIBaseView)
local base = UIBaseView
local SeasonSelectLocationGameRewardDailyComp = require("UI.LWSeason5.SeasonSelectLocationGame.Reward.Comp.SeasonSelectLocationGameRewardDailyComp")
local SeasonSelectLocationGameRewardTotalComp = require("UI.LWSeason5.SeasonSelectLocationGame.Reward.Comp.SeasonSelectLocationGameRewardTotalComp")
local panel_path = "Panel"
local text_title_path = "safearea/TopBar/TextTitle"
local btn_close_path = "safearea/BtnClose"
local toggle1_path = "mainObj/Tab/Toggle1"
local tab1_text_path = "mainObj/Tab/Toggle1/tab1_text"
local tab12_text_path = "mainObj/Tab/Toggle1/Choose/tab12_text"
local toggle2_path = "mainObj/Tab/Toggle2"
local tab2_text_path = "mainObj/Tab/Toggle2/tab2_text"
local tab22_text_path = "mainObj/Tab/Toggle2/Choose/tab22_text"
local atk_time_scroll_view_path = "mainObj/MiddleBg/atkTimeScrollView"
local allianceRankScrollView_path = "mainObj/MiddleBg/allianceRankScrollView"
local p_text_reward_hint_path = "mainObj/MiddleBg/p_text_reward_hint"

function SeasonSelectLocationGameRewardView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:RefreshList()
end

function SeasonSelectLocationGameRewardView:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function SeasonSelectLocationGameRewardView:ComponentDefine()
  self.panel = self:AddComponent(UIButton, panel_path)
  self.panel:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.btn_close = self:AddComponent(UIButton, btn_close_path)
  self.btn_close:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.text_title = self:AddComponent(UIText, text_title_path)
  self.text_title:SetLocalText("zone_selection_location_game_name_UI_3")
  self.toggle1 = self:AddComponent(UIToggle, toggle1_path)
  self.toggle1:SetIsOn(true)
  self.toggle1:SetOnValueChanged(function(tf)
    if tf then
      self:ToggleControlBorS()
    end
  end)
  self.tab1_text = self:AddComponent(UIText, tab1_text_path)
  self.tab1_text:SetLocalText("zone_selection_location_UI_37")
  self.tab12_text = self:AddComponent(UIText, tab12_text_path)
  self.tab12_text:SetLocalText("zone_selection_location_UI_37")
  self.toggle2 = self:AddComponent(UIToggle, toggle2_path)
  self.toggle2:SetIsOn(false)
  self.toggle2:SetOnValueChanged(function(tf)
    if tf then
      self:ToggleControlBorS()
    end
  end)
  self.tab2_text = self:AddComponent(UIText, tab2_text_path)
  self.tab2_text:SetLocalText("zone_selection_location_UI_38")
  self.tab22_text = self:AddComponent(UIText, tab22_text_path)
  self.tab22_text:SetLocalText("zone_selection_location_UI_38")
  self.atk_time_scroll_view = self:AddComponent(SeasonSelectLocationGameRewardDailyComp, atk_time_scroll_view_path)
  self.allianceRankScrollView = self:AddComponent(SeasonSelectLocationGameRewardTotalComp, allianceRankScrollView_path)
  self.p_text_reward_hint = self:AddComponent(UITextMeshProUGUIEx, p_text_reward_hint_path)
end

function SeasonSelectLocationGameRewardView:ComponentDestroy()
  self.panel = nil
  self.btn_close = nil
  self.text_title = nil
  self.toggle1 = nil
  self.tab1_text = nil
  self.tab12_text = nil
  self.toggle2 = nil
  self.tab2_text = nil
  self.tab22_text = nil
  self.atk_time_scroll_view = nil
  self.allianceRankScrollView = nil
  self.p_text_reward_hint = nil
end

function SeasonSelectLocationGameRewardView:OnEnable()
  base.OnEnable(self)
end

function SeasonSelectLocationGameRewardView:OnDisable()
  base.OnDisable(self)
end

function SeasonSelectLocationGameRewardView:OnAddListener()
  base.OnAddListener(self)
end

function SeasonSelectLocationGameRewardView:OnRemoveListener()
  base.OnRemoveListener(self)
end

function SeasonSelectLocationGameRewardView:RefreshList()
  if self.toggle2:GetIsOn() == true then
    self.atk_time_scroll_view:SetActive(true)
    self.atk_time_scroll_view:RefreshList()
    self.allianceRankScrollView:SetActive(false)
    self.p_text_reward_hint:SetLocalText("zone_selection_location_UI_41")
  elseif self.toggle1:GetIsOn() == true then
    self.atk_time_scroll_view:SetActive(false)
    self.allianceRankScrollView:SetActive(true)
    self.allianceRankScrollView:RefreshList()
    self.p_text_reward_hint:SetLocalText("zone_selection_location_UI_40")
  end
end

function SeasonSelectLocationGameRewardView:ToggleControlBorS()
  self:RefreshList()
end

return SeasonSelectLocationGameRewardView
