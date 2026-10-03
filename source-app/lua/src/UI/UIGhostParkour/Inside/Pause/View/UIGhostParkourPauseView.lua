local UIGhostParkourPauseView = BaseClass("UIGhostParkourPauseView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local title_text_path = "UICommonPopUpTitle/Common_img_title/titleText"
local close_btn_path = "UICommonPopUpTitle/CloseBtn"
local content_text_path = "SafeArea/ContentRoot/ContentText"
local continue_btn_path = "SafeArea/ContinueBtn"
local continue_btn_text_path = "SafeArea/ContinueBtn/LW_Btn_Common_New_Base/ContinueBtnText"

function UIGhostParkourPauseView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:InitView()
end

function UIGhostParkourPauseView:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIGhostParkourPauseView:ComponentDefine()
  self.title_text = self:AddComponent(UITextMeshProUGUIEx, title_text_path)
  self.title_text:SetLocalText("parkour_pause_title")
  self.close_btn = self:AddComponent(UIButton, close_btn_path)
  self.close_btn:SetOnClick(BindCallback(self, self.OnCloseClick))
  self.content_text = self:AddComponent(UITextMeshProUGUIEx, content_text_path)
  self.continue_btn = self:AddComponent(UIButton, continue_btn_path)
  self.continue_btn:SetOnClick(BindCallback(self, self.OnContinueClick))
  self.continue_btn_text = self:AddComponent(UITextMeshProUGUIEx, continue_btn_text_path)
  self.continue_btn_text:SetLocalText("parkour_pause_btn")
end

function UIGhostParkourPauseView:ComponentDestroy()
  self.panel = nil
  self.title_text = nil
  self.close_btn = nil
  self.content_text = nil
  self.continue_btn = nil
  self.continue_btn_text = nil
end

function UIGhostParkourPauseView:InitView()
  local logic = DataCenter.LWBattleManager:GetCurBattleLogic()
  self.logic = logic
  self.isPlayback = logic and logic.isPlayback
  self.content_text:SetLocalText("ghost_parkour_network_error")
end

function UIGhostParkourPauseView:OnCloseClick()
  if self.context == nil then
    if self.isPlayback then
      self.context = Localization:GetString("ghost_parkour_exit_check_playback")
    else
      self.context = Localization:GetString("ghost_parkour_exit_check")
    end
  end
  UIUtil.ShowConfirmNew({
    contentText = self.context,
    btnNum = 2,
    showToggle = false,
    confirmBtnParam = {
      action = function()
        if self.ctrl then
          self.ctrl:CloseSelf()
        end
        DataCenter.LWBattleManager:SetGameOver(true)
        if self.logic then
          self.logic:ExitSurfing()
        end
        DataCenter.LWGhostParkourDataManager:GoBackToActivityPanel()
      end
    }
  })
end

function UIGhostParkourPauseView:OnContinueClick()
  self.ctrl:CloseSelf()
  if self.logic then
    self.logic:Pause(false)
  end
end

return UIGhostParkourPauseView
