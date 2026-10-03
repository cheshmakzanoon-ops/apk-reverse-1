local base = UIBaseContainer
local UILWSeasonMilitaryEliteTopPlayerComp = BaseClass("UILWSeasonMilitaryEliteTopPlayerComp", UIBaseContainer)
local p_img_top_title_path = "p_img_top_title"
local p_img_top_score_path = "p_img_top_score"
local p_go_top_head_path = "p_go_top_head"
local p_btn_top_head_path = "p_btn_top_head"
local p_text_top_score_path = "p_text_top_score"
local p_text_top_name_path = "p_text_top_name"
local p_comp_military_path = "p_comp_military"
local UILWSeasonMilitaryLevelComp = require("UI.LWSeason6.UILWSeasonMilitary.Comp.UILWSeasonMilitaryLevelComp")

function UILWSeasonMilitaryEliteTopPlayerComp:ComponentDefine()
  self.p_go_top_head = self:AddComponent(UIBaseContainer, p_go_top_head_path)
  self.p_btn_top_head = self:AddComponent(UIButton, p_btn_top_head_path)
  self.p_text_top_score = self:AddComponent(UITextMeshProUGUIEx, p_text_top_score_path)
  self.p_text_top_name = self:AddComponent(UITextMeshProUGUIEx, p_text_top_name_path)
  self.p_img_top_title = self:AddComponent(UIImage, p_img_top_title_path)
  self.p_img_top_score = self:AddComponent(UIImage, p_img_top_score_path)
  self.p_comp_military = self:AddComponent(UILWSeasonMilitaryLevelComp, p_comp_military_path)
  self.p_btn_top_head:SetOnClick(BindCallback(self, self.OnHeadClicked))
end

function UILWSeasonMilitaryEliteTopPlayerComp:ComponentDestroy()
  self.p_go_top_head = nil
  self.p_btn_top_head = nil
  self.p_text_top_score = nil
  self.p_text_top_name = nil
  self.p_img_top_title = nil
  self.p_img_top_score = nil
  self.compPlayerHead = nil
  self.p_comp_military = nil
end

function UILWSeasonMilitaryEliteTopPlayerComp:DataDefine()
end

function UILWSeasonMilitaryEliteTopPlayerComp:DataDestroy()
end

function UILWSeasonMilitaryEliteTopPlayerComp:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UILWSeasonMilitaryEliteTopPlayerComp:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UILWSeasonMilitaryEliteTopPlayerComp:OnAddListener()
  base.OnAddListener(self)
end

function UILWSeasonMilitaryEliteTopPlayerComp:OnRemoveListener()
  base.OnRemoveListener(self)
end

function UILWSeasonMilitaryEliteTopPlayerComp:ReInit(data)
  if self:InitData(data) then
    self:InitUi()
  end
end

function UILWSeasonMilitaryEliteTopPlayerComp:InitData(data)
  self.Data = data
  return true
end

function UILWSeasonMilitaryEliteTopPlayerComp:InitUi()
  if self.Data == nil then
    self:SetEmpty(true)
    return
  end
  self:SetEmpty(false)
  local playerName = self.Data.PlayerData.name
  if not string.IsNullOrEmpty(self.Data.PlayerData.abbr) then
    playerName = "[" .. self.Data.PlayerData.abbr .. "]" .. playerName
  end
  self.p_text_top_name:SetText(playerName)
  self.p_text_top_score:SetText(string.GetFormattedSeparatorNum(self.Data.PlayerData.score))
  self.compPlayerHead = self.p_go_top_head.gameObject:GetComponent(typeof(CS.UIPlayerHead))
  self.compPlayerHead:SetData(self.Data.PlayerData.uid, self.Data.PlayerData.pic, self.Data.PlayerData.picver)
  self.p_comp_military:ReInit(self.Data.PlayerData.militaryLevel, self.Data.PlayerData.serverId)
end

function UILWSeasonMilitaryEliteTopPlayerComp:SetEmpty(empty)
  self.p_img_top_title:SetActive(not empty)
  self.p_go_top_head:SetActive(not empty)
  self.p_btn_top_head:SetActive(not empty)
  self.p_text_top_score:SetActive(not empty)
  self.p_img_top_score:SetActive(not empty)
  self.p_comp_military:SetActive(not empty)
  if empty then
    self.p_text_top_name:SetLocalText("season_s5_activity_1200046_desc20")
  end
end

function UILWSeasonMilitaryEliteTopPlayerComp:OnHeadClicked()
  if self.Data ~= nil and self.Data.PlayerData ~= nil then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UILWPlayerDetail, {anim = true}, self.Data.PlayerData.uid)
  end
end

return UILWSeasonMilitaryEliteTopPlayerComp
