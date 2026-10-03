local UILLGroupInvitationView = BaseClass("UILLGroupInvitationView", UIBaseView)
local base = UIBaseView
local ActMgr = DataCenter.LandlordMgr
local CLS = "UI.Landlord.GroupInvitation.Component.UILLGroupInvitationMain"
local PREFAB = "Assets/Main/Prefabs/UI/Landlord/LLGroupInvitationMain.prefab"

function UILLGroupInvitationView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UILLGroupInvitationView:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UILLGroupInvitationView:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.panel = self.viewSkin:AddComponent(self, UIButton, 1)
  self.panel:SetOnClick(function()
    self:OnPanelClick()
  end)
  self.animator = self.viewSkin:AddComponent(self, UIAnimator, 2)
  self.compMailBg = self.viewSkin:AddComponent(self, UIBaseContainer, 3)
end

function UILLGroupInvitationView:ComponentDestroy()
  self.viewSkin = nil
  self.panel = nil
  self.animator = nil
  self.compMailBg = nil
end

function UILLGroupInvitationView:DataDefine()
  local info = self:GetUserData()
  if info == nil then
    self:RealClose()
    return
  end
  self.curPartIdx = ActMgr:GetCurGroupPartIndex()
  self.compMain = self:LoadComponentAsync(CLS, PREFAB, self.compMailBg)
  self.compMain:SetData(self, info)
  local ud = self:GetUserData()
  if not ud.isInvite then
    ActMgr:SignBeInvited()
  end
end

function UILLGroupInvitationView:DataDestroy()
  self.compMain = nil
  self.canClick = 0
  if self.delay ~= nil then
    self.delay:Stop()
    self.delay = nil
  end
end

function UILLGroupInvitationView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.LandlordActInfoRefresh, self.OnActInfoRefresh)
end

function UILLGroupInvitationView:OnRemoveListener()
  self:RemoveUIListener(EventId.LandlordActInfoRefresh, self.OnActInfoRefresh)
  base.OnRemoveListener(self)
end

function UILLGroupInvitationView:OnEnable()
  base.OnEnable(self)
  local info = self:GetUserData()
  if self.delay ~= nil then
    self.delay:Stop()
    self.delay = nil
  end
  if info.isInvite or self.canClick == 0 then
    self.canClick = 0
    self.animator:Play("LWAllyDrillLevelTipLetterLoop")
  else
    if self.delay ~= nil then
      self.delay:Stop()
      self.delay = nil
    end
    self.canClick = 2
    local ret, time = self.animator:PlayAnimationReturnTime("LWAllyDrillLevelTipOpen")
    if ret then
      self.delay = TimerManager:GetInstance():DelayInvoke(function()
        self.delay = nil
        self.animator:PlayAnimationReturnTime("LWAllyDrillLevelTipLoop")
        self.canClick = 1
      end, time)
    end
  end
end

function UILLGroupInvitationView:RealClose()
  if self.compMain and self.compMain.flying then
    return
  end
  self.ctrl:CloseSelf()
end

function UILLGroupInvitationView:OnPanelClick()
  if self.canClick == 2 then
    return
  end
  if self.canClick == 1 then
    local ret, time = self.animator:PlayAnimationReturnTime("LWAllyDrillLevelTipLetterOpen")
    if ret then
      self.canClick = 2
      self.delay = TimerManager:GetInstance():DelayInvoke(function()
        self.delay = nil
        self.animator:PlayAnimationReturnTime("LWAllyDrillLevelTipLetterLoop")
        self.canClick = 0
      end, time)
    end
    return
  end
  self:RealClose()
end

function UILLGroupInvitationView:OnBtnCloseClick()
  if self.canClick ~= 0 then
    return
  end
  DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
  self:RealClose()
end

function UILLGroupInvitationView:OnActInfoRefresh()
  if self.compMain == nil then
    return
  end
  local gpIdx = DataCenter.LandlordMgr:GetCurGroupPartIndex()
  if gpIdx ~= self.curPartIdx then
    self.compMain = nil
    self:RealClose()
  end
end

return UILLGroupInvitationView
