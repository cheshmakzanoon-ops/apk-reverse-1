local UILWSeasonMakeFriendsDetailCDView = BaseClass("UILWSeasonMakeFriendsDetailCDView", UIBaseView)
local base = UIBaseView
local UIGray = CS.UIGray
local Localization = CS.GameEntry.Localization
local UILWSeasonMakeFriendsDetailCDItem = require("UI.LWSeason6.MakeFriends.UILWSeasonMakeFriendsDetailCD.Component.UILWSeasonMakeFriendsDetailCDItem")
local panel_path = "panel"
local dialog_title_text_path = "PopUpTitle/Common_img_title/titleText"
local close_btn_path = "PopUpTitle/CloseBtn"
local content_path = "PopUpTitle/GridContent_ScrollView/Viewport/Content"
local text_time1_path = "PopUpTitle/GridContent_ScrollView/Viewport/Content/Content/Line1/TextTime1"
local text_time2_path = "PopUpTitle/GridContent_ScrollView/Viewport/Content/Content/Line2/TextTime2"
local text_time3_path = "PopUpTitle/GridContent_ScrollView/Viewport/Content/Content/Line3/TextTime3"
local text_time4_path = "PopUpTitle/GridContent_ScrollView/Viewport/Content/Content/Line4/TextTime4"
local text_time5_path = "PopUpTitle/GridContent_ScrollView/Viewport/Content/Content/Line5/TextTime5"

function UILWSeasonMakeFriendsDetailCDView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:UpdateData()
end

function UILWSeasonMakeFriendsDetailCDView:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UILWSeasonMakeFriendsDetailCDView:ComponentDefine()
  self.dialog_title_text = self:AddComponent(UIText, dialog_title_text_path)
  self.close_btn = self:AddComponent(UIButton, close_btn_path)
  self.dialog_title_text:SetLocalText("s6_alliance_ally_limit_desc13")
  self.close_btn:SetOnClick(BindCallback(self.ctrl, self.ctrl.CloseSelf))
  self.close_btn1 = self:AddComponent(UIButton, panel_path)
  self.close_btn1:SetOnClick(BindCallback(self.ctrl, self.ctrl.CloseSelf))
  self.content = self:AddComponent(UIBaseContainer, content_path)
  self.text_time1 = self:AddComponent(UITextMeshProUGUIEx, text_time1_path)
  self.text_time2 = self:AddComponent(UITextMeshProUGUIEx, text_time2_path)
  self.text_time3 = self:AddComponent(UITextMeshProUGUIEx, text_time3_path)
  self.text_time4 = self:AddComponent(UITextMeshProUGUIEx, text_time4_path)
  self.text_time5 = self:AddComponent(UITextMeshProUGUIEx, text_time5_path)
end

function UILWSeasonMakeFriendsDetailCDView:ComponentDestroy()
  self.btn_back = nil
  self.content = nil
  self.text_time1 = nil
  self.text_time2 = nil
  self.text_time3 = nil
  self.text_time4 = nil
  self.text_time5 = nil
end

function UILWSeasonMakeFriendsDetailCDView:UpdateData()
  local k1 = LuaEntry.DataConfig:TryGetNum("season6_alliance_ally_config", "k1", 72)
  local k2 = LuaEntry.DataConfig:TryGetNum("season6_alliance_ally_config", "k2", 24)
  local k3 = LuaEntry.DataConfig:TryGetNum("season6_alliance_ally_config", "k3", 24)
  local k4 = LuaEntry.DataConfig:TryGetNum("season6_alliance_ally_config", "k4", 24)
  self.text_time1:SetLocalText("100206")
  self.text_time2:SetLocalText("season_s2_achievement_alliance_04", k1)
  self.text_time3:SetLocalText("season_s2_achievement_alliance_04", k2)
  self.text_time4:SetLocalText("season_s2_achievement_alliance_04", k3)
  self.text_time5:SetLocalText("season_s2_achievement_alliance_04", k4)
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.content.rectTransform)
end

return UILWSeasonMakeFriendsDetailCDView
