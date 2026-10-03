local base = UIBaseView
local UIDefenceFailTipView = BaseClass("UIDefenceFailTipView", base)
local Localization = CS.GameEntry.Localization

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  local abbr, alName = self:GetUserData()
  self:ShowTip(abbr, alName)
end

local function OnDestroy(self)
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

local function ComponentDefine(self)
  self.titleN = self:AddComponent(UIText, "UICommonPopUpTitle/Common_img_title/titleText")
  self.titleN:SetLocalText(390824)
  self.contentN = self:AddComponent(UIText, "InfoScrollView/Viewport/Content/DesText")
  self.closeBtnN = self:AddComponent(UIButton, "UICommonPopUpTitle/CloseBtn")
  self.closeBtnN:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.bgBtnN = self:AddComponent(UIButton, "UICommonPopUpTitle/panel")
  self.bgBtnN:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.BtnN = self:AddComponent(UIButton, "Btn")
  self.BtnN:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.btn_txt = self:AddComponent(UIText, "Btn/Btn_Text")
  self.btn_txt:SetLocalText(GameDialogDefine.CONFIRM)
end

local function ComponentDestroy(self)
  self.titleN = nil
  self.contentHeadN = nil
  self.contentN = nil
  self.closeBtnN = nil
  self.bgBtnN = nil
end

local function DataDefine(self)
end

local function DataDestroy(self)
end

local function ShowTip(self, abbr, alName)
  local msg = Localization:GetString("390825") .. "\n" .. Localization:GetString("390826", abbr, alName)
  self.contentN:SetText(msg)
end

UIDefenceFailTipView.OnCreate = OnCreate
UIDefenceFailTipView.OnDestroy = OnDestroy
UIDefenceFailTipView.ComponentDefine = ComponentDefine
UIDefenceFailTipView.ComponentDestroy = ComponentDestroy
UIDefenceFailTipView.DataDefine = DataDefine
UIDefenceFailTipView.DataDestroy = DataDestroy
UIDefenceFailTipView.ShowTip = ShowTip
return UIDefenceFailTipView
