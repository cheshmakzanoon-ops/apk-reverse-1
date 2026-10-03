local base = UIBaseContainer
local BankDepositItem = BaseClass("BankDepositItem", base)
local tog_path = "tog"
local text_path = "tog/text"
local icon_path = "tog/layout/icon"
local count_path = "tog/layout/count"
local checkButton_path = "tog/CheckButton"
local togBg_path = "tog/Background "

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
  self.tog = self:AddComponent(UIToggle, tog_path)
  self.text = self:AddComponent(UIText, text_path)
  self.icon = self:AddComponent(UIImage, icon_path)
  self.count = self:AddComponent(UIText, count_path)
  self.checkButton = self:AddComponent(UIButton, checkButton_path)
  self.togBg = self:AddComponent(UIBaseContainer, togBg_path)
  self.tog:SetOnValueChanged(function(tf)
    self:OnTogChanged(tf)
  end)
  self.checkButton:SetOnClick(function()
    if self.openTime and self.openTime > 0 and UITimeManager:GetInstance():GetServerTime() < self.openTime then
      local str = CS.GameEntry.Localization:GetString("s5_map_ui_30", UITimeManager:GetInstance():MilliSecondToFmtString(self.openTime - UITimeManager:GetInstance():GetServerTime()))
      UIUtil.ShowTips(str)
    else
      self.tog:SetIsOn(true)
    end
  end)
end

local function ComponentDestroy(self)
  self.tog = nil
  self.text = nil
  self.icon = nil
  self.count = nil
  self.checkButton = nil
  self.togBg = nil
end

local function DataDefine(self)
end

local function DataDestroy(self)
end

function BankDepositItem:ReInit(data, index, day, cityTemplate, callBack, target, openTime_)
  self.data = data
  self.day = day
  self.callBack = callBack
  self.target = target
  DataCenter.SeasonBankManager:LoadItemIcon(self.icon, cityTemplate)
  self.text:SetLocalText("s5_bank_ui31", day)
  if openTime_ and 0 < openTime_ then
    self.openTime = openTime_
    self.checkButton:SetActive(true)
    self.togBg:SetActive(false)
  else
    self.openTime = nil
    self.checkButton:SetActive(false)
    self.togBg:SetActive(true)
  end
end

function BankDepositItem:OnTogChanged(value)
  if not value then
    return
  end
  if self.callBack then
    self.callBack(self.target, self.day)
  end
end

function BankDepositItem:RefreshValue(baseValue)
  local rate = self.data + LuaEntry.Effect:GetGameEffect(EffectDefine.BANK_DEPOSIT_PERCENT)
  local settle = DataCenter.SeasonBankManager:GetSettleAmount(baseValue, rate)
  self.count:SetText(settle)
end

BankDepositItem.OnCreate = OnCreate
BankDepositItem.OnDestroy = OnDestroy
BankDepositItem.OnEnable = OnEnable
BankDepositItem.OnDisable = OnDisable
BankDepositItem.ComponentDefine = ComponentDefine
BankDepositItem.ComponentDestroy = ComponentDestroy
BankDepositItem.DataDefine = DataDefine
BankDepositItem.DataDestroy = DataDestroy
return BankDepositItem
