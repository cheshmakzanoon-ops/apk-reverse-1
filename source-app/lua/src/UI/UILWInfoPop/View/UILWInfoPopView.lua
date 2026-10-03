local UILWInfoPopView = BaseClass("UILWInfoPopView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local black_path = "black"
local title_path = "mailBg/title"
local content_text_path = "mailBg/ContentScroll/Viewport/ContentText"
local confirm_btn_path = "mailBg/ConfirmBtn"
local text_path = "mailBg/ConfirmBtn/Text"

function UILWInfoPopView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:ReInit()
end

function UILWInfoPopView:OnDestroy()
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

function UILWInfoPopView:OnAddListener()
  base.OnAddListener(self)
end

function UILWInfoPopView:OnRemoveListener()
  base.OnRemoveListener(self)
end

function UILWInfoPopView:ComponentDefine()
  self.black = self:AddComponent(UIButton, black_path)
  self.title = self:AddComponent(UITextMeshProUGUIEx, title_path)
  self.content_text = self:AddComponent(UITextMeshProUGUIEx, content_text_path)
  self.confirm_btn = self:AddComponent(UIButton, confirm_btn_path)
  self.text = self:AddComponent(UITextMeshProUGUIEx, text_path)
  self.black:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.confirm_btn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
end

function UILWInfoPopView:DataDefine()
end

function UILWInfoPopView:ComponentDestroy()
  self.black = nil
  self.title = nil
  self.content_text = nil
  self.confirm_btn = nil
  self.text = nil
end

function UILWInfoPopView:DataDestroy()
end

function UILWInfoPopView:ReInit()
  local param = self:GetUserData()
  self.title:SetText(param.title)
  self.content_text:SetText(param.content)
end

return UILWInfoPopView
