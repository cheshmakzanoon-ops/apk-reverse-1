local UISurfingBattlePauseView = BaseClass("UISurfingBattlePauseView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local title_text_path = "UICommonPopUpTitle/Common_img_title/titleText"
local close_btn_path = "UICommonPopUpTitle/CloseBtn"
local content_text_path = "SafeArea/ContentRoot/ContentText"
local hint_text_path = "SafeArea/HintText"
local continue_btn_path = "SafeArea/ContinueBtn"
local continue_btn_text_path = "SafeArea/ContinueBtn/LW_Btn_Common_New_Base/ContinueBtnText"

function UISurfingBattlePauseView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:InitView()
end

function UISurfingBattlePauseView:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UISurfingBattlePauseView:ComponentDefine()
  self.title_text = self:AddComponent(UITextMeshProUGUIEx, title_text_path)
  self.title_text:SetLocalText("parkour_pause_title")
  self.close_btn = self:AddComponent(UIButton, close_btn_path)
  self.close_btn:SetOnClick(BindCallback(self, self.OnCloseClick))
  self.content_text = self:AddComponent(UITextMeshProUGUIEx, content_text_path)
  self.hint_text = self:AddComponent(UITextMeshProUGUIEx, hint_text_path)
  self.hint_text:SetLocalText("parkour_pause_desc")
  self.continue_btn = self:AddComponent(UIButton, continue_btn_path)
  self.continue_btn:SetOnClick(BindCallback(self, self.OnContinueClick))
  self.continue_btn_text = self:AddComponent(UITextMeshProUGUIEx, continue_btn_text_path)
  self.continue_btn_text:SetLocalText("parkour_pause_btn")
end

function UISurfingBattlePauseView:ComponentDestroy()
  self.panel = nil
  self.title_text = nil
  self.close_btn = nil
  self.content_text = nil
  self.hint_text = nil
  self.continue_btn = nil
  self.continue_btn_text = nil
end

function UISurfingBattlePauseView:InitView()
  local logic = DataCenter.LWBattleManager:GetCurBattleLogic()
  local currentInt = Mathf.Floor(logic:GetCurDistanceData())
  local score = logic:GetGameScore()
  self.content_text:SetLocalText("parkour_pause_desc_1", currentInt, score + 72)
end

function UISurfingBattlePauseView:OnCloseClick()
  UIUtil.ShowConfirmNew({
    contentText = Localization:GetString("parkour_pause_check"),
    btnNum = 2,
    showToggle = false,
    confirmBtnParam = {
      action = function()
        self.ctrl:CloseSelf()
        local logic = DataCenter.LWBattleManager:GetCurBattleLogic()
        if logic then
          logic:ExitSurfing()
        end
        DataCenter.LWSurfingDataManager:GoBackToActivityPanel()
      end
    }
  })
end

function UISurfingBattlePauseView:OnContinueClick()
  self.ctrl:CloseSelf()
  UIManager:GetInstance():OpenWindow(UIWindowNames.UISurfingBattleCountDown, {anim = true})
end

return UISurfingBattlePauseView
