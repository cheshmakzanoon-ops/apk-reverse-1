local p_btn_blur_path = "p_btn_blur"
local p_text_title_path = "Root/bg/title/Common_img_title/p_text_title"
local p_btn_close_path = "Root/bg/title/p_btn_close"
local content_path = "Root/bg/content"
local content_desc_scroll_path = "Root/bg/content/content_desc_scroll"
local viewport_path = "Root/bg/content/content_desc_scroll/Viewport"
local p_text_desc_path = "Root/bg/content/content_desc_scroll/Viewport/p_text_desc"
local p_text_city_rule_path = "Root/bg/content/content_text_city/p_text_city_rule"
local p_text_stronghold_rule_path = "Root/bg/content/content_text_stronghold/p_text_stronghold_rule"
local p_btn_info_path = "Root/bg/title/p_btn_info"
local base = UIBaseView
local SeasonAllianceWarTimeSetInfoView = BaseClass("SeasonAllianceWarTimeSetInfoView", UIBaseView)

function SeasonAllianceWarTimeSetInfoView:ComponentDefine()
  self.p_btn_blur = self:AddComponent(UIButton, p_btn_blur_path)
  self.p_btn_blur:SetOnClick(BindCallback(self, self.OnCloseClicked))
  self.p_text_title = self:AddComponent(UITextMeshProUGUIEx, p_text_title_path)
  self.p_btn_close = self:AddComponent(UIButton, p_btn_close_path)
  self.p_btn_close:SetOnClick(BindCallback(self, self.OnCloseClicked))
  self.p_text_desc = self:AddComponent(UITextMeshProUGUIEx, p_text_desc_path)
  self.content = self:AddComponent(UIBaseContainer, content_path)
  self.content_desc_scroll = self:AddComponent(UIScrollRect, content_desc_scroll_path)
  self.viewport = self:AddComponent(UIBaseContainer, viewport_path)
  self.p_text_city_rule = self:AddComponent(UITextMeshProUGUIEx, p_text_city_rule_path)
  self.p_text_stronghold_rule = self:AddComponent(UITextMeshProUGUIEx, p_text_stronghold_rule_path)
  self.p_btn_info = self:AddComponent(UIButton, p_btn_info_path)
  self.p_btn_info:SetOnClick(BindCallback(self, self.OnInfoClicked))
end

function SeasonAllianceWarTimeSetInfoView:ComponentDestroy()
  self.p_btn_blur = nil
  self.p_text_title = nil
  self.p_btn_close = nil
  self.p_text_desc = nil
  self.content = nil
  self.content_desc_scroll = nil
  self.viewport = nil
  self.p_text_city_rule = nil
  self.p_text_stronghold_rule = nil
  self.p_btn_info = nil
end

function SeasonAllianceWarTimeSetInfoView:DataDefine()
end

function SeasonAllianceWarTimeSetInfoView:DataDestroy()
  self.Data = nil
end

function SeasonAllianceWarTimeSetInfoView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:ReInit(self:GetUserData())
end

function SeasonAllianceWarTimeSetInfoView:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function SeasonAllianceWarTimeSetInfoView:OnAddListener()
  base.OnAddListener(self)
end

function SeasonAllianceWarTimeSetInfoView:OnRemoveListener()
  base.OnRemoveListener(self)
end

function SeasonAllianceWarTimeSetInfoView:ReInit(data)
  if self:InitData(data) then
    self:InitUi()
  end
end

function SeasonAllianceWarTimeSetInfoView:InitData(data)
  return true
end

function SeasonAllianceWarTimeSetInfoView:InitUi()
  self.p_text_title:SetLocalText("s5_alliance_battle_time_ui60")
  self.p_text_desc:SetLocalText("s5_alliance_battle_time_ui17")
  local cityRule = self:ConcatText("s5_alliance_battle_time_ui19", "s5_alliance_battle_time_ui20", "s5_alliance_battle_time_ui21", "s5_alliance_battle_time_ui22")
  self.p_text_city_rule:SetText(cityRule)
  local strongholdRule = self:ConcatText("s5_alliance_battle_time_ui23", "s5_alliance_battle_time_ui24", "s5_alliance_battle_time_ui25", "s5_alliance_battle_time_ui26")
  self.p_text_stronghold_rule:SetText(strongholdRule)
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.viewport.transform)
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.content_desc_scroll.transform)
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.content.transform)
end

function SeasonAllianceWarTimeSetInfoView:ConcatText(key1, key2, key3, key4)
  local text1 = CS.GameEntry.Localization:GetString(key1)
  local text2 = CS.GameEntry.Localization:GetString(key2)
  local text3 = CS.GameEntry.Localization:GetString(key3)
  local text4 = CS.GameEntry.Localization:GetString(key4)
  return string.format([[
%s%s
%s%s]], string.bold(text1), text2, string.bold(text3), text4)
end

function SeasonAllianceWarTimeSetInfoView:OnCloseClicked()
  self.ctrl:CloseSelf()
end

function SeasonAllianceWarTimeSetInfoView:OnInfoClicked()
  local param = {}
  param.howToPlayList = {500004}
  UIManager:GetInstance():OpenWindow(UIWindowNames.UILWHowToPlay, {anim = true}, param)
end

return SeasonAllianceWarTimeSetInfoView
