local UIZendeskView = BaseClass("UIZendeskView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

local function OnDestroy(self)
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function ComponentDefine(self)
  self.textTitle = self:AddComponent(UITextMeshProUGUIEx, "Root/TopBar/TextTitle")
  self.btnBack = self:AddComponent(UIButton, "Root/BottomBar/BtnBack")
  self.btnBack:SetOnClick(function()
    self:OnBtnBackClick()
  end)
  self.btnMessage = self:AddComponent(UIButton, "Root/BottomBar/BtnMessage")
  self.btnMessage:SetOnClick(function()
    self:OnBtnMessageClick()
  end)
  self.textMessage = self:AddComponent(UITextMeshProUGUIEx, "Root/BottomBar/BtnMessage/TextMessage")
  self.compContainer = self:AddComponent(UIBaseContainer, "Root/Middle/Container")
  self.imgDot = self:AddComponent(UIImage, "Root/BottomBar/BtnMessage/dot")
end

local function ComponentDestroy(self)
  self.textTitle = nil
  self.btnBack = nil
  self.btnMessage = nil
  self.textMessage = nil
  self.compContainer = nil
  self.imgDot = nil
end

local function DataDefine(self)
  self.textTitle:SetLocalText("gm_title_helpcenter")
  self.textMessage:SetLocalText("gm_btn_contactus")
  self.url = self:GetUserData()
  self.ctrl:CreateZendeskSupportView(self.compContainer, self.url)
  self:OnRedDotUpdate()
end

local function DataDestroy(self)
  self.url = nil
  self.ctrl:CloseZendeskSupportView()
end

local function OnAddListener(self)
  base.OnAddListener(self)
  self:AddUIListener(EventId.UpdateAIHelpRedPoint, self.OnRedDotUpdate)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
  self:RemoveUIListener(EventId.UpdateAIHelpRedPoint, self.OnRedDotUpdate)
end

local function OnBtnBackClick(self)
  self.ctrl:CloseSelf()
end

local function OnBtnMessageClick(self)
  DataCenter.LWCustomerServiceManager:DoCloseCustomerServiceRedPointData()
  self.ctrl:ShowZendeskMessaging()
  self.ctrl:CloseSelf()
end

local function OnRedDotUpdate(self)
  local isShow = DataCenter.LWCustomerServiceManager:GetCustomerServiceRedPointData()
  self.imgDot:SetActive(isShow)
end

UIZendeskView.OnCreate = OnCreate
UIZendeskView.OnDestroy = OnDestroy
UIZendeskView.OnEnable = OnEnable
UIZendeskView.OnDisable = OnDisable
UIZendeskView.ComponentDefine = ComponentDefine
UIZendeskView.ComponentDestroy = ComponentDestroy
UIZendeskView.DataDefine = DataDefine
UIZendeskView.DataDestroy = DataDestroy
UIZendeskView.OnAddListener = OnAddListener
UIZendeskView.OnRemoveListener = OnRemoveListener
UIZendeskView.OnBtnBackClick = OnBtnBackClick
UIZendeskView.OnBtnMessageClick = OnBtnMessageClick
UIZendeskView.OnRedDotUpdate = OnRedDotUpdate
return UIZendeskView
