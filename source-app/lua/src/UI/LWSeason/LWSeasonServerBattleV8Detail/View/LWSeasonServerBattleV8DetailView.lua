local LWSeasonServerBattleV8DetailView = BaseClass("LWSeasonServerBattleV8DetailView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local panel_path = "panel"
local dialog_title_text_path = "PopUpTitle/Common_img_title/titleText"
local close_btn_path = "PopUpTitle/CloseBtn"
local desc_path = "PopUpTitle/Common_bg_orange2/ScrollView/Viewport/Content/desc"
local v11_path = "PopUpTitle/Common_bg_orange2/ScrollView/Viewport/Content/itemList/item1/Content2/v11"
local v12_path = "PopUpTitle/Common_bg_orange2/ScrollView/Viewport/Content/itemList/item1/Content2/v12"
local v21_path = "PopUpTitle/Common_bg_orange2/ScrollView/Viewport/Content/itemList/item2/Content2/v21"
local v22_path = "PopUpTitle/Common_bg_orange2/ScrollView/Viewport/Content/itemList/item2/Content2/v22"
local v31_path = "PopUpTitle/Common_bg_orange2/ScrollView/Viewport/Content/itemList/item3/Content2/v31"
local v32_path = "PopUpTitle/Common_bg_orange2/ScrollView/Viewport/Content/itemList/item3/Content2/v32"

function LWSeasonServerBattleV8DetailView:OnCreate()
  base.OnCreate(self)
  local param = self:GetUserData()
  self.param = param
  self:ComponentDefine()
end

function LWSeasonServerBattleV8DetailView:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function LWSeasonServerBattleV8DetailView:ComponentDefine()
  self.dialog_title_text = self:AddComponent(UIText, dialog_title_text_path)
  self.close_btn = self:AddComponent(UIButton, close_btn_path)
  self.dialog_title_text:SetLocalText("2901005")
  self.close_btn:SetOnClick(BindCallback(self.ctrl, self.ctrl.CloseSelf))
  self.close_btn1 = self:AddComponent(UIButton, panel_path)
  self.close_btn1:SetOnClick(BindCallback(self.ctrl, self.ctrl.CloseSelf))
  self.desc = self:AddComponent(UIText, desc_path)
  self.v11 = self:AddComponent(UIText, v11_path)
  self.v21 = self:AddComponent(UIText, v21_path)
  self.v31 = self:AddComponent(UIText, v31_path)
  self.v12 = self:AddComponent(UIText, v12_path)
  self.v22 = self:AddComponent(UIText, v22_path)
  self.v32 = self:AddComponent(UIText, v32_path)
  self.desc:SetText(Localization:GetString("season_zone_war_02"))
  self.v11:SetText("1")
  self.v21:SetText("2")
  self.v31:SetText("3")
  local dataList = DataCenter.ActivityListDataManager:GetActivityDataByType(EnumActivity.SeasonServerBattleV8Activity.Type)
  if 0 < #dataList then
    local data = dataList[1]
    if data then
      self.v12:SetText(string.GetFormattedSeparatorNum(toInt(data.para_1)))
      self.v22:SetText(string.GetFormattedSeparatorNum(toInt(data.para_2)))
      self.v32:SetText(string.GetFormattedSeparatorNum(toInt(data.para_3)))
    end
  else
    self.v12:SetText("400,000")
    self.v22:SetText("600,000")
    self.v32:SetText("1000,000")
  end
end

function LWSeasonServerBattleV8DetailView:ComponentDestroy()
  self.btn_back = nil
end

return LWSeasonServerBattleV8DetailView
