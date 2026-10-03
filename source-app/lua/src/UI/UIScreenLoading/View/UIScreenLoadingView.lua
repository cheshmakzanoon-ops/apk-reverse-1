local UIScreenLoadingView = BaseClass("UIScreenLoadingView", UIBaseView)
local base = UIBaseView
local btn_path = "panel"
local des_path = "Text_Des"

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self.openText = self:GetUserData()
  self:ReInit()
end

local function OnDestroy(self)
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

local function ComponentDefine(self)
  self.txt = self:AddComponent(UIText, des_path)
  self.btn = self:AddComponent(UIButton, btn_path)
  self.btn:SetOnClick(function()
    self:OnBtnClick()
  end)
end

local function ComponentDestroy(self)
  self.btn = nil
end

local function DataDefine(self)
  self.clickTime = 0
end

local function DataDestroy(self)
  self.clickTime = nil
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function ReInit(self)
  self.clickTime = 0
  if self.openText and (type(self.openText) == "string" or type(self.openText) == "number") then
    self.txt:SetLocalText(self.openText)
  else
    self.txt:SetLocalText(390789)
  end
end

local function OnBtnClick(self)
  self.clickTime = self.clickTime + 1
  if self.clickTime >= 8 then
    self.clickTime = 0
    self.ctrl:CloseSelf()
  end
end

local function CloseSignal(self, data)
  self.ctrl:CloseSelf()
end

UIScreenLoadingView.OnCreate = OnCreate
UIScreenLoadingView.OnDestroy = OnDestroy
UIScreenLoadingView.OnEnable = OnEnable
UIScreenLoadingView.OnDisable = OnDisable
UIScreenLoadingView.ComponentDefine = ComponentDefine
UIScreenLoadingView.ComponentDestroy = ComponentDestroy
UIScreenLoadingView.DataDefine = DataDefine
UIScreenLoadingView.DataDestroy = DataDestroy
UIScreenLoadingView.ReInit = ReInit
UIScreenLoadingView.OnBtnClick = OnBtnClick
UIScreenLoadingView.CloseSignal = CloseSignal
return UIScreenLoadingView
