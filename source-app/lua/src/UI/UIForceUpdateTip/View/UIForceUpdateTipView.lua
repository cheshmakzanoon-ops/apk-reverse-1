local UIForceUpdateTipView = BaseClass("UIForceUpdateTipView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local title_txt_path = "Layout/UICommonPopBg/TitleTxt"
local des_path = "Layout/Des"
local btn_path = "Layout/Btn"
local btn_name_path = "Layout/Btn/BtnName"

function UIForceUpdateTipView:OnCreate()
  base.OnCreate(self)
  PostEventLog.Track(PostEventLog.Defines.OpenForceUpdateView, {})
  self:ComponentDefine()
  self:DataDefine()
  self:ReInit()
end

function UIForceUpdateTipView:OnDestroy()
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

function UIForceUpdateTipView:OnAddListener()
  base.OnAddListener(self)
end

function UIForceUpdateTipView:OnRemoveListener()
  base.OnRemoveListener(self)
end

function UIForceUpdateTipView:ComponentDefine()
  self.title_txt = self:AddComponent(UITextMeshProUGUIEx, title_txt_path)
  self.des = self:AddComponent(UITextMeshProUGUIEx, des_path)
  self.btn = self:AddComponent(UIButton, btn_path)
  self.btn_name = self:AddComponent(UITextMeshProUGUIEx, btn_name_path)
  self.title_txt:SetLocalText("update_title_01")
  self.des:SetLocalText("update_tips_01")
  self.btn_name:SetLocalText("update_btn_01")
  self.btn:SetOnClick(function()
    self.ctrl:CloseSelf()
    CS.ApplicationLaunch.Instance:ReloadGame()
  end)
end

function UIForceUpdateTipView:DataDefine()
end

function UIForceUpdateTipView:ComponentDestroy()
  self.title_txt = nil
  self.des = nil
  self.btn = nil
  self.btn_name = nil
end

function UIForceUpdateTipView:DataDestroy()
end

function UIForceUpdateTipView:ReInit()
end

return UIForceUpdateTipView
