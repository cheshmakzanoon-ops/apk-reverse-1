local UIVipExtendCitySkinProductDescView = BaseClass("UIVipExtendCitySkinProductDescView", UIBaseView)
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
  self.btnClose = self:AddComponent(UIButton, "close/closeBtn")
  self.btnClose:SetOnClick(function()
    self:OnBtnCloseClick()
  end)
  self.btnBg = self:AddComponent(UIButton, "bg")
  self.btnBg:SetOnClick(function()
    self:OnBtnCloseClick()
  end)
end

local function ComponentDestroy(self)
  self.btnClose = nil
  self.btnBg = nil
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

local function OnBtnCloseClick(self)
  self.ctrl:CloseSelf()
end

UIVipExtendCitySkinProductDescView.OnCreate = OnCreate
UIVipExtendCitySkinProductDescView.OnDestroy = OnDestroy
UIVipExtendCitySkinProductDescView.OnEnable = OnEnable
UIVipExtendCitySkinProductDescView.OnDisable = OnDisable
UIVipExtendCitySkinProductDescView.ComponentDefine = ComponentDefine
UIVipExtendCitySkinProductDescView.ComponentDestroy = ComponentDestroy
UIVipExtendCitySkinProductDescView.DataDefine = DataDefine
UIVipExtendCitySkinProductDescView.DataDestroy = DataDestroy
UIVipExtendCitySkinProductDescView.OnAddListener = OnAddListener
UIVipExtendCitySkinProductDescView.OnRemoveListener = OnRemoveListener
UIVipExtendCitySkinProductDescView.OnBtnCloseClick = OnBtnCloseClick
return UIVipExtendCitySkinProductDescView
