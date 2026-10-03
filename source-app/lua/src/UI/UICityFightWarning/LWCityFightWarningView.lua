local LWCityFightWarningView = BaseClass("LWCityFightWarningView", UIBaseView)
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
  self.compFolderClose = self:AddComponent(UIBaseContainer, "Bg/node/folderClose")
  self.compFolderOpen = self:AddComponent(UIBaseContainer, "Bg/node/folderOpen")
  self.compEffect1 = self:AddComponent(UIBaseContainer, "Bg/node/Effect1")
  self.textTip1 = self:AddComponent(UIText, "Bg/node/tip1")
  self.textTip1:SetText(Localization:GetString("tip1key"))
  self.textTip2 = self:AddComponent(UIText, "Bg/node/tip2")
  self.textTip2:SetText(Localization:GetString("tip2key"))
  self.btnClickOpen = self:AddComponent(UIButton, "Bg/node/ClickOpen")
  self.btnClickOpen:SetOnClick(function()
    self:OnBtnClickOpenClick()
  end)
  self.textTxtClickOpen = self:AddComponent(UIText, "Bg/node/ClickOpen/txtClickOpen")
  self.textTxtClickOpen:SetText(Localization:GetString("clickOpenKey"))
end

local function ComponentDestroy(self)
  self.compFolderClose = nil
  self.compFolderOpen = nil
  self.compEffect1 = nil
  self.textTip1 = nil
  self.textTip2 = nil
  self.btnClickOpen = nil
  self.textTxtClickOpen = nil
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

local function OnBtnClickOpenClick(self)
end

LWCityFightWarningView.OnCreate = OnCreate
LWCityFightWarningView.OnDestroy = OnDestroy
LWCityFightWarningView.OnEnable = OnEnable
LWCityFightWarningView.OnDisable = OnDisable
LWCityFightWarningView.ComponentDefine = ComponentDefine
LWCityFightWarningView.ComponentDestroy = ComponentDestroy
LWCityFightWarningView.DataDefine = DataDefine
LWCityFightWarningView.DataDestroy = DataDestroy
LWCityFightWarningView.OnAddListener = OnAddListener
LWCityFightWarningView.OnRemoveListener = OnRemoveListener
LWCityFightWarningView.OnBtnClickOpenClick = OnBtnClickOpenClick
return LWCityFightWarningView
