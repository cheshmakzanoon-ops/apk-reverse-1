local UIActEasterRuesDetailView = BaseClass("UIActEasterRuesDetailView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization

local function OnCreate(self)
  base.OnCreate(self)
  local param = self:GetUserData()
  self.param = param
  if self.param == nil then
    self.ctrl:CloseSelf()
    return
  end
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
  self.btnPanel = self:AddComponent(UIButton, "panel")
  self.btnPanel:SetOnClick(function()
    self:OnBtnPanelClick()
  end)
  self.btnGo = self:AddComponent(UIButton, "goBtn")
  self.btnGo:SetOnClick(function()
    self:OnBtnGoClick()
  end)
  self.btnClose = self:AddComponent(UIButton, "UICommonPopUpTitle/CloseBtn")
  self.btnClose:SetOnClick(function()
    self:OnBtnCloseClick()
  end)
  self.subTextTitle = self:AddComponent(UITextMeshProUGUIEx, "Content/TitleText")
  self.textContent = self:AddComponent(UITextMeshProUGUIEx, "Content/ContentScroll/Viewport/ContentText")
  self.textTitle = self:AddComponent(UITextMeshProUGUIEx, "UICommonPopUpTitle/Common_img_title/titleText")
  self.textTitle:SetLocalText(self.param.title or 2000047)
  self.subTextTitle:SetLocalText(self.param.subTitle or 2000048)
  self.textContent:SetText(self.param.activityRulesStr)
end

local function ComponentDestroy(self)
  self.btnPanel = nil
  self.btnGo = nil
  self.btnClose = nil
  self.subTextTitle = nil
  self.textContent = nil
  self.textTitle = nil
end

local function DataDefine(self)
end

local function DataDestroy(self)
end

local function OnAddListener(self)
  base.OnAddListener(self)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
end

local function OnBtnPanelClick(self)
  self.ctrl:CloseSelf()
end

local function OnBtnGoClick(self)
  self.ctrl:CloseSelf()
end

local function OnBtnCloseClick(self)
  self.ctrl:CloseSelf()
end

UIActEasterRuesDetailView.OnCreate = OnCreate
UIActEasterRuesDetailView.OnDestroy = OnDestroy
UIActEasterRuesDetailView.OnEnable = OnEnable
UIActEasterRuesDetailView.OnDisable = OnDisable
UIActEasterRuesDetailView.ComponentDefine = ComponentDefine
UIActEasterRuesDetailView.ComponentDestroy = ComponentDestroy
UIActEasterRuesDetailView.DataDefine = DataDefine
UIActEasterRuesDetailView.DataDestroy = DataDestroy
UIActEasterRuesDetailView.OnAddListener = OnAddListener
UIActEasterRuesDetailView.OnRemoveListener = OnRemoveListener
UIActEasterRuesDetailView.OnBtnPanelClick = OnBtnPanelClick
UIActEasterRuesDetailView.OnBtnGoClick = OnBtnGoClick
UIActEasterRuesDetailView.OnBtnCloseClick = OnBtnCloseClick
return UIActEasterRuesDetailView
