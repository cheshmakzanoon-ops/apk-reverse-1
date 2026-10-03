local LWUIMasteryView = BaseClass("LWUIMasteryView", UIBaseView)
local base = UIBaseView
local LWUIMasteryMain = require("UI.LWUIMastery.Component.LWUIMasteryMain")
local back_path = "SafeArea/BtnClose"
local main_path = "SafeArea/LWUIMasteryMain"
local text_title_path = "SafeArea/TopBar/TextTitle"

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
end

local function OnDestroy(self)
  self:ComponentDestroy()
  base.OnDestroy(self)
end

local function ComponentDefine(self)
  self.back_btn = self:AddComponent(UIButton, back_path)
  self.back_btn:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self.ctrl:CloseSelf()
  end)
  self.text_title = self:AddComponent(UIText, text_title_path)
  self.text_title:SetLocalText("building_name_10218000")
  self.main = self:AddComponent(LWUIMasteryMain, main_path)
  self.main:ReInit()
end

local function ComponentDestroy(self)
  self.back_btn = nil
  self.main = nil
  self.text_title = nil
end

local function OnAddListener(self)
  base.OnAddListener(self)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
end

LWUIMasteryView.OnCreate = OnCreate
LWUIMasteryView.OnDestroy = OnDestroy
LWUIMasteryView.ComponentDefine = ComponentDefine
LWUIMasteryView.ComponentDestroy = ComponentDestroy
LWUIMasteryView.OnAddListener = OnAddListener
LWUIMasteryView.OnRemoveListener = OnRemoveListener
return LWUIMasteryView
