local UILWSeasonInviteMailPopupView = BaseClass("UILWSeasonInviteMailPopupView", UIBaseView)
local base = UIBaseView

function UILWSeasonInviteMailPopupView:OnCreate()
  base.OnCreate(self)
  self.dataType, self.data = self:GetUserData()
  self:ComponentDefine()
end

function UILWSeasonInviteMailPopupView:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UILWSeasonInviteMailPopupView:ComponentDefine()
  self.close_btn = self:AddComponent(UIButton, "panel")
  self.close_btn:SetOnClick(function()
    self:OnBtnClick()
  end)
  self.bg = self:AddComponent(UIButton, "PopUpTitle/bg")
  self.bg:SetOnClick(function()
    self:OnBtnClick()
  end)
  self.text = self:AddComponent(UITextMeshProUGUIEx, "PopUpTitle/bg/Text")
  self.text:SetLocalText("alliance_boss_tips_010")
  self.animRoot = self:AddComponent(UIAnimator, "")
  self.animRoot:SetActive(true)
end

function UILWSeasonInviteMailPopupView:ComponentDestroy()
  self.bg = nil
  self.text = nil
  self.animRoot = nil
end

function UILWSeasonInviteMailPopupView:OnBtnClick()
  local dataType = self.dataType
  local data = self.data
  self.animRoot:Play("SeasonInviteMailPopup_open")
  TimerManager:GetInstance():DelayInvoke(function()
    if self.animRoot then
      self.animRoot:SetActive(false)
    end
    UIManager:GetInstance():DestroyWindow(UIWindowNames.UILWSeasonInviteMailPopup)
    if dataType and data then
      UIManager:GetInstance():OpenWindow(UIWindowNames.UILWSeasonMakeFriendsShowInvite, {anim = false}, dataType, data)
    end
  end, 1)
end

return UILWSeasonInviteMailPopupView
