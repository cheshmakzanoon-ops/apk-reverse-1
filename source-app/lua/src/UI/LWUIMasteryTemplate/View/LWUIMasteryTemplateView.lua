local LWUIMasteryTemplateView = BaseClass("LWUIMasteryTemplateView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local close_btn_path = "UICommonMiniPopUpTitle/CloseBtn"
local txt_profession_path = "txt_profession"
local img_icon_path = "Template/img_icon_bg/img_Icon"
local txt_level_path = "Template/txt_level"
local txt_point_path = "Template/txt_point"
local text_path = "Import/Text"
local btn_import_change_path = "Import/btn_import_change"
local btn_not_import_change_path = "notImport/btn_not_import_change"

function LWUIMasteryTemplateView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:SetData()
end

function LWUIMasteryTemplateView:OnDestroy()
  self.data = nil
  self.parent = nil
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function LWUIMasteryTemplateView:ComponentDefine()
  self.close_btn = self:AddComponent(UIButton, close_btn_path)
  self.txt_profession = self:AddComponent(UITextMeshProUGUIEx, txt_profession_path)
  self.img_icon = self:AddComponent(UIImage, img_icon_path)
  self.txt_level = self:AddComponent(UITextMeshProUGUIEx, txt_level_path)
  self.txt_point = self:AddComponent(UITextMeshProUGUIEx, txt_point_path)
  self.text = self:AddComponent(UITextMeshProUGUIEx, text_path)
  self.btn_import_change = self:AddComponent(UIButton, btn_import_change_path)
  self.btn_not_import_change = self:AddComponent(UIButton, btn_not_import_change_path)
  self.btn_import_change:SetOnClick(BindCallback(self, self.OnClickImport))
  self.btn_not_import_change:SetOnClick(BindCallback(self, self.OnClickNotImport))
  self.close_btn:SetOnClick(BindCallback(self, self.OnClickClose))
end

function LWUIMasteryTemplateView:ComponentDestroy()
  self.close_btn = nil
  self.txt_profession = nil
  self.img_icon = nil
  self.txt_level = nil
  self.txt_point = nil
  self.text = nil
  self.btn_import_change = nil
  self.btn_not_import_change = nil
end

function LWUIMasteryTemplateView:OnClickImport()
  SFSNetwork.SendMessage(MsgDefines.LwSeasonMasteryHomeChange, self.data.homeId, 1)
  if self.parent ~= nil then
    self.parent.ctrl:CloseSelf()
  end
  self.ctrl:CloseSelf()
end

function LWUIMasteryTemplateView:OnClickNotImport()
  SFSNetwork.SendMessage(MsgDefines.LwSeasonMasteryHomeChange, self.data.homeId, 0)
  if self.parent ~= nil then
    self.parent.ctrl:CloseSelf()
  end
  self.ctrl:CloseSelf()
end

function LWUIMasteryTemplateView:OnClickClose()
  self.ctrl:CloseSelf()
end

function LWUIMasteryTemplateView:SetData()
  local data = self:GetUserData()
  self.parent = data[2]
  self.data = data[1]
  local showTemp = DataCenter.MasteryManager:GetHomeShowTempByHomeId(self.data.homeId)
  self.txt_profession:SetLocalText("season_switch_info02", Localization:GetString(showTemp.name))
  local imgPath = showTemp:GetIconFullPath()
  self.img_icon:LoadSprite(imgPath)
  self.txt_level:SetLocalText(140002, self.data.homeLv)
  self.txt_point:SetLocalText("season_switch_info04", Localization:GetString(135225, self.data.usePoint, self.data.totalPoint))
  self.text:SetLocalText("season_switch_info05", self.data.usePoint)
end

return LWUIMasteryTemplateView
