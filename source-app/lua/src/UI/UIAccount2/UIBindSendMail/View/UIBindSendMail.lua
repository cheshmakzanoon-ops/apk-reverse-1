local UIBindSendMail = BaseClass("UIBindSendMail", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local SDKManager = CS.SDKManager
local Setting = CS.GameEntry.Setting

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:OnOpen()
end

local function OnDestroy(self)
  self:ComponentDestroy()
  base.OnDestroy(self)
end

local function ComponentDefine(self)
end

local function ComponentDestroy(self)
end

local function OnOpen(self)
end

local function OnBtnBindClick(self)
end

local function OnBtnSwitchClick(self)
end

UIBindSendMail.OnCreate = OnCreate
UIBindSendMail.OnDestroy = OnDestroy
UIBindSendMail.ComponentDefine = ComponentDefine
UIBindSendMail.ComponentDestroy = ComponentDestroy
UIBindSendMail.OnOpen = OnOpen
UIBindSendMail.OnBtnBindClick = OnBtnBindClick
UIBindSendMail.OnBtnSwitchClick = OnBtnSwitchClick
return UIBindSendMail
