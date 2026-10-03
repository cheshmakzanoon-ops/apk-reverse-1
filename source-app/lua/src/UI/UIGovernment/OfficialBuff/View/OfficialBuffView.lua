local OfficialBuffView = BaseClass("OfficialBuffView", UIBaseView)
local base = UIBaseView
local panel_path = "panel"
local dialog_title_text_path = "PopUpTitle/Common_img_title/titleText"
local close_btn_path = "PopUpTitle/CloseBtn"
local title_text_path = "Content/TitleText"
local unset_path = "Content/unset"
local player_path = "Content/player"
local name_path = "Content/Name"
local icon_path = "Content/icon"
local eff1_path = "Content/effect/eff1"
local eff2_path = "Content/effect/eff2"
local value1_path = "Content/effect/value1"
local value2_path = "Content/effect/value2"

function OfficialBuffView:OnCreate()
  base.OnCreate(self)
  local param = self:GetUserData()
  self.param = param
  self:ComponentDefine()
end

function OfficialBuffView:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function OfficialBuffView:OnAddListener()
  base.OnAddListener(self)
end

function OfficialBuffView:OnRemoveListener()
  base.OnRemoveListener(self)
end

function OfficialBuffView:ComponentDefine()
  self.dialog_title_text = self:AddComponent(UIText, dialog_title_text_path)
  self.close_btn = self:AddComponent(UIButton, close_btn_path)
  self.title_text = self:AddComponent(UIText, title_text_path)
  self.unset = self:AddComponent(UIText, unset_path)
  self.player = self:AddComponent(UICommonHead, player_path)
  self.playerName = self:AddComponent(UIText, name_path)
  self.icon = self:AddComponent(UIImage, icon_path)
  self.eff1 = self:AddComponent(UIText, eff1_path)
  self.eff2 = self:AddComponent(UIText, eff2_path)
  self.value1 = self:AddComponent(UIText, value1_path)
  self.value2 = self:AddComponent(UIText, value2_path)
  self.dialog_title_text:SetText("\227\128\144\229\174\152\232\129\140\229\138\160\230\136\144\230\149\136\230\158\156\227\128\145")
  self.title_text:SetText("\227\128\144\229\141\171\231\148\159\233\131\168\233\149\191\227\128\145")
  self.close_btn:SetOnClick(BindCallback(self.ctrl, self.ctrl.CloseSelf))
  self.close_btn1 = self:AddComponent(UIButton, panel_path)
  self.close_btn1:SetOnClick(BindCallback(self.ctrl, self.ctrl.CloseSelf))
  self.player:SetActive(false)
  self.playerName:SetActive(false)
  self.icon:SetActive(true)
  self.unset:SetActive(true)
end

function OfficialBuffView:ComponentDestroy()
  self.btn_back = nil
end

function OfficialBuffView:UpdateData()
end

return OfficialBuffView
