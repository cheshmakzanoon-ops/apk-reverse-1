local LWPVPArenaRewardView = BaseClass("LWPVPArenaRewardView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local LWPVPArenaRewardObj = require("UI.LWPVPArena.RewardView.Component.LWPVPArenaRewardObj")
local LWPVPArenaAtkTimeRewardObj = require("UI.LWPVPArena.RewardView.Component.LWPVPArenaAtkTimeRewardObj")
local LWPVPArenaAllianceRewardObj = require("UI.LWPVPArena.RewardView.Component.LWPVPArenaAllianceRewardObj")
local panel_path = "Panel"
local text_title_path = "safearea/TopBar/TextTitle"
local btn_close_path = "safearea/BtnClose"
local toggle1_path = "mainObj/Tab/Toggle1"
local tab1_text_path = "mainObj/Tab/Toggle1/tab1_text"
local tab12_text_path = "mainObj/Tab/Toggle1/Choose/tab12_text"
local toggle2_path = "mainObj/Tab/Toggle2"
local tab2_text_path = "mainObj/Tab/Toggle2/tab2_text"
local tab22_text_path = "mainObj/Tab/Toggle2/Choose/tab22_text"
local toggle3_path = "mainObj/Tab/Toggle3"
local tab3_text_path = "mainObj/Tab/Toggle3/tab3_text"
local tab32_text_path = "mainObj/Tab/Toggle3/Choose/tab32_text"
local rank_scroll_view_path = "mainObj/MiddleBg/rankScrollView"
local atk_time_scroll_view_path = "mainObj/MiddleBg/atkTimeScrollView"
local allianceRankScrollView_path = "mainObj/MiddleBg/allianceRankScrollView"

function LWPVPArenaRewardView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:TrySendGetDataMsg()
  self:RefreshList()
end

function LWPVPArenaRewardView:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function LWPVPArenaRewardView:ComponentDefine()
  self.panel = self:AddComponent(UIButton, panel_path)
  self.panel:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.btn_close = self:AddComponent(UIButton, btn_close_path)
  self.btn_close:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.text_title = self:AddComponent(UIText, text_title_path)
  self.text_title:SetLocalText(801103)
  self.toggle1 = self:AddComponent(UIToggle, toggle1_path)
  self.toggle1:SetIsOn(true)
  self.toggle1:SetOnValueChanged(function(tf)
    if tf then
      self:ToggleControlBorS()
    end
  end)
  self.tab1_text = self:AddComponent(UIText, tab1_text_path)
  self.tab1_text:SetLocalText(456003)
  self.tab12_text = self:AddComponent(UIText, tab12_text_path)
  self.tab12_text:SetLocalText(456003)
  self.toggle2 = self:AddComponent(UIToggle, toggle2_path)
  self.toggle2:SetIsOn(false)
  self.toggle2:SetOnValueChanged(function(tf)
    if tf then
      self:ToggleControlBorS()
    end
  end)
  self.tab2_text = self:AddComponent(UIText, tab2_text_path)
  self.tab2_text:SetLocalText(500202)
  self.tab22_text = self:AddComponent(UIText, tab22_text_path)
  self.tab22_text:SetLocalText(500202)
  self.toggle3 = self:AddComponent(UIToggle, toggle3_path)
  self.toggle3:SetIsOn(false)
  self.toggle3:SetOnValueChanged(function(tf)
    if tf then
      self:ToggleControlBorS()
    end
  end)
  self.tab3_text = self:AddComponent(UIText, tab3_text_path)
  self.tab3_text:SetLocalText(2010310)
  self.tab32_text = self:AddComponent(UIText, tab32_text_path)
  self.tab32_text:SetLocalText(2010310)
  self.rank_scroll_view = self:AddComponent(LWPVPArenaRewardObj, rank_scroll_view_path)
  self.atk_time_scroll_view = self:AddComponent(LWPVPArenaAtkTimeRewardObj, atk_time_scroll_view_path)
  self.allianceRankScrollView = self:AddComponent(LWPVPArenaAllianceRewardObj, allianceRankScrollView_path)
end

function LWPVPArenaRewardView:ComponentDestroy()
  self.panel = nil
  self.btn_close = nil
  self.text_title = nil
  self.toggle1 = nil
  self.tab1_text = nil
  self.tab12_text = nil
  self.toggle2 = nil
  self.tab2_text = nil
  self.tab22_text = nil
  self.toggle3 = nil
  self.tab3_text = nil
  self.tab32_text = nil
  self.rank_scroll_view = nil
  self.atk_time_scroll_view = nil
  self.allianceRankScrollView = nil
end

function LWPVPArenaRewardView:OnEnable()
  base.OnEnable(self)
end

function LWPVPArenaRewardView:OnDisable()
  base.OnDisable(self)
end

function LWPVPArenaRewardView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.ArenaPVPRewardDataGet, self.RefreshList)
end

function LWPVPArenaRewardView:OnRemoveListener()
  base.OnRemoveListener(self)
  self:RemoveUIListener(EventId.ArenaPVPRewardDataGet, self.RefreshList)
end

function LWPVPArenaRewardView:RefreshList()
  if self.toggle3:GetIsOn() == true then
    self.rank_scroll_view:SetActive(true)
    self.rank_scroll_view:RefreshList()
    self.atk_time_scroll_view:SetActive(false)
    self.allianceRankScrollView:SetActive(false)
  elseif self.toggle2:GetIsOn() == true then
    self.rank_scroll_view:SetActive(false)
    self.atk_time_scroll_view:SetActive(true)
    self.atk_time_scroll_view:RefreshList()
    self.allianceRankScrollView:SetActive(false)
  elseif self.toggle1:GetIsOn() == true then
    self.rank_scroll_view:SetActive(false)
    self.atk_time_scroll_view:SetActive(false)
    self.allianceRankScrollView:SetActive(true)
    self.allianceRankScrollView:RefreshList()
  end
end

function LWPVPArenaRewardView:ToggleControlBorS()
  self:RefreshList()
end

function LWPVPArenaRewardView:TrySendGetDataMsg()
  local showData = DataCenter.LW3V3ArenaManager:GetRankRewardData()
  if showData == nil then
    SFSNetwork.SendMessage(MsgDefines.Get3V3ArenaRewardPreview)
  end
end

return LWPVPArenaRewardView
