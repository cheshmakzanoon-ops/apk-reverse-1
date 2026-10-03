local UIActContinuePayRewardNoticePanelView = BaseClass("UIActContinuePayRewardNoticePanelView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local title_path = "PopUpTitle/Common_img_title/titleText"
local return_btn_path = "panel"
local close_btn_path = "PopUpTitle/CloseBtn"
local content_txt_path = "PopUpTitle/Common_bg_orange2/AvailableTimesText"

local function DoClosePanel(self)
  self.ctrl:CloseSelf()
end

function UIActContinuePayRewardNoticePanelView:OnCreate()
  base.OnCreate(self)
  self.desc = self:AddComponent(UITextMeshProUGUI, content_txt_path)
  self.desc:SetText(Localization:GetString("\231\188\186key") .. "<sprite=0>")
  self.title = self:AddComponent(UIText, title_path)
  self.title:SetLocalText("\231\188\186key")
  self.close_btn = self:AddComponent(UIButton, close_btn_path)
  self.close_btn:SetOnClick(function()
    DoClosePanel(self)
  end)
  self.return_btn = self:AddComponent(UIButton, return_btn_path)
  self.return_btn:SetOnClick(function()
    DoClosePanel(self)
  end)
end

function UIActContinuePayRewardNoticePanelView:OnDestroy()
  self.title = nil
  self.close_btn = nil
  self.return_btn = nil
  self.desc = nil
  base.OnDestroy(self)
end

function UIActContinuePayRewardNoticePanelView:OnAddListener()
end

function UIActContinuePayRewardNoticePanelView:OnRemoveListener()
end

function UIActContinuePayRewardNoticePanelView:OnEnable()
  base.OnEnable(self)
end

function UIActContinuePayRewardNoticePanelView:OnDisable()
  base.OnDisable(self)
end

function UIActContinuePayRewardNoticePanelView:SetData()
end

return UIActContinuePayRewardNoticePanelView
