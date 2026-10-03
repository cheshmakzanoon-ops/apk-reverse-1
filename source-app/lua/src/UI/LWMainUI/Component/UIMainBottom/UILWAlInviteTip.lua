local UILWAlInviteTip = BaseClass("UILWAlInviteTip", UIAsyncContainer)
local base = UIAsyncContainer
local click_btn_path = "Btn"

function UILWAlInviteTip:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
end

function UILWAlInviteTip:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UILWAlInviteTip:ComponentDefine()
  self.clickBtn = self:AddComponent(UIButton, click_btn_path)
  self.clickBtn:SetOnClick(function()
    self:OnClick()
  end)
end

function UILWAlInviteTip:ComponentDestroy()
  self.clickBtn = nil
end

function UILWAlInviteTip:OnEnable()
  base.OnEnable(self)
end

function UILWAlInviteTip:OnDisable()
  base.OnDisable(self)
end

function UILWAlInviteTip:OnAddListener()
  base.OnAddListener(self)
end

function UILWAlInviteTip:OnRemoveListener()
  base.OnRemoveListener(self)
end

function UILWAlInviteTip:OnClick()
  local inviteList = DataCenter.AllianceAutoInviteManager:GetAutoInviteList()
  if inviteList and 0 < #inviteList then
    local inviteInfo = inviteList[#inviteList]
    if inviteInfo then
      UIManager:GetInstance():OpenWindow(UIWindowNames.UILWAllianceInvite, {anim = true}, inviteInfo)
    end
  end
  self.holder:OnHideTip()
end

return UILWAlInviteTip
