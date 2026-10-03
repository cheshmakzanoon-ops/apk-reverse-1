local UIGhostParkourPlaybackEndView = BaseClass("UIGhostParkourPlaybackEndView", UIBaseView)
local base = UIBaseView
local UIGhostParkourSettleTopItem = require("UI.UIGhostParkour.Inside.Result.Component.UIGhostParkourSettleTopItem")
local top_root_path = "SafeArea/TopRoot"
local back_btn_path = "SafeArea/BottomGroup/BackBtnRoot/BackBtn"
local back_btn_text_path = "SafeArea/BottomGroup/BackBtnRoot/BackBtn/LW_Btn_Common_New_Base/BackBtnText"

function UIGhostParkourPlaybackEndView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:InitView()
end

function UIGhostParkourPlaybackEndView:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIGhostParkourPlaybackEndView:ComponentDefine()
  self.rootAnim = self:AddComponent(UIAnimator, "")
  self.top_root = self:AddComponent(UIGhostParkourSettleTopItem, top_root_path)
  self.back_btn = self:AddComponent(UIButton, back_btn_path)
  self.back_btn:SetOnClick(function()
    self:OnBackBtnClick()
  end)
  self.back_btn_text = self:AddComponent(UITextMeshProUGUIEx, back_btn_text_path)
  self.back_btn_text:SetLocalText("ghost_parkour_back_btn")
end

function UIGhostParkourPlaybackEndView:ComponentDestroy()
  self.rootAnim = nil
  self.top_root = nil
  self.result_text = nil
  self.back_btn = nil
  self.back_btn_text = nil
end

function UIGhostParkourPlaybackEndView:OnAddListener()
  base.OnAddListener(self)
end

function UIGhostParkourPlaybackEndView:OnRemoveListener()
  base.OnRemoveListener(self)
end

function UIGhostParkourPlaybackEndView:InitView()
  local param = self:GetUserData()
  if param then
    local rank = param.rank or 1
    self.top_root:InitView(param, rank)
    self.rootAnim:Play("V_ui_UIGhostParkourPlaybackEnd_in", 0, 0)
    self.top_root:PlayPanelAnim()
  elseif self.ctrl then
    self.ctrl:CloseSelf()
  end
end

function UIGhostParkourPlaybackEndView:OnBackBtnClick()
  self.ctrl:CloseSelf()
  DataCenter.LWGhostParkourDataManager:GoBackToActivityPanel()
end

return UIGhostParkourPlaybackEndView
