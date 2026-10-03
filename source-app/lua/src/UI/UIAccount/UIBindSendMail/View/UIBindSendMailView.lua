local UIBindSendMailView = BaseClass("UIBindSendMailView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local txt_title_path = "ImgBg/TxtTitle"
local close_btn_path = "ImgBg/BtnClose"
local return_btn_path = "Panel"
local des_path = "ImgBg/DesBg/DesText"
local tip_text_path = "ImgBg/TipText"
local conform_btn_path = "ImgBg/ConfirmBtn"
local conform_btn_name_path = "ImgBg/ConfirmBtn/ConfirmBtnName"

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:ReInit()
end

local function OnDestroy(self)
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

local function ComponentDefine(self)
  self.txt_title = self:AddComponent(UIText, txt_title_path)
  self.close_btn = self:AddComponent(UIButton, close_btn_path)
  self.return_btn = self:AddComponent(UIButton, return_btn_path)
  self.des = self:AddComponent(UIText, des_path)
  self.tip_text = self:AddComponent(UIText, tip_text_path)
  self.conform_btn = self:AddComponent(UIButton, conform_btn_path)
  self.conform_btn_name = self:AddComponent(UIText, conform_btn_name_path)
  self.close_btn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.return_btn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.conform_btn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
end

local function ComponentDestroy(self)
  self.txt_title = nil
  self.close_btn = nil
  self.return_btn = nil
  self.des = nil
  self.tip_text = nil
  self.conform_btn = nil
  self.conform_btn_name = nil
end

local function DataDefine(self)
end

local function DataDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function ReInit(self)
  self.username = self:GetUserData()
  self.txt_title:SetLocalText(280109)
  if self.username ~= nil then
    self.des:SetText(self.username)
  else
    self.des:SetText("")
  end
  self.conform_btn_name:SetLocalText(GameDialogDefine.CONFIRM)
  self.tip_text:SetLocalText(280166)
end

local function OnAddListener(self)
  base.OnAddListener(self)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
end

UIBindSendMailView.OnCreate = OnCreate
UIBindSendMailView.OnDestroy = OnDestroy
UIBindSendMailView.OnEnable = OnEnable
UIBindSendMailView.OnDisable = OnDisable
UIBindSendMailView.OnAddListener = OnAddListener
UIBindSendMailView.OnRemoveListener = OnRemoveListener
UIBindSendMailView.ComponentDefine = ComponentDefine
UIBindSendMailView.ComponentDestroy = ComponentDestroy
UIBindSendMailView.DataDefine = DataDefine
UIBindSendMailView.DataDestroy = DataDestroy
UIBindSendMailView.ReInit = ReInit
return UIBindSendMailView
