local UIStorageShopGo = BaseClass("UIStorageShopGo", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local this_path = ""
local desc_path = "Desc"

local function OnCreate(self)
  base.OnCreate(self)
  self:DataDefine()
  self:ComponentDefine()
end

local function OnDestroy(self)
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

local function ComponentDefine(self)
  self.btn = self:AddComponent(UIButton, this_path)
  self.btn:SetOnClick(function()
    self:OnClick()
  end)
  self.desc_text = self:AddComponent(UITweenNumberText, desc_path)
  self.desc_text:SetLocalText(372131)
end

local function ComponentDestroy(self)
  self.btn = nil
  self.desc_text = nil
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

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function ReInit(self)
  local needLv = LuaEntry.DataConfig:TryGetNum("tradingbank_para", "k17") or 0
  self:SetActive(needLv <= DataCenter.BuildManager.MainLv)
end

local function OnClick(self)
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIStorageShopMain, nil, 3)
end

UIStorageShopGo.OnCreate = OnCreate
UIStorageShopGo.OnDestroy = OnDestroy
UIStorageShopGo.ComponentDefine = ComponentDefine
UIStorageShopGo.ComponentDestroy = ComponentDestroy
UIStorageShopGo.DataDefine = DataDefine
UIStorageShopGo.DataDestroy = DataDestroy
UIStorageShopGo.OnAddListener = OnAddListener
UIStorageShopGo.OnRemoveListener = OnRemoveListener
UIStorageShopGo.OnEnable = OnEnable
UIStorageShopGo.OnDisable = OnDisable
UIStorageShopGo.ReInit = ReInit
UIStorageShopGo.OnClick = OnClick
return UIStorageShopGo
