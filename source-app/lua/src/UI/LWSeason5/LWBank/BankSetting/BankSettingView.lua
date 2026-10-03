local base = UIBaseView
local BankSetting = BaseClass("BankSetting", base)
local Localization = CS.GameEntry.Localization
local btnBack_path = "panel"
local btnClose_path = "PopUpTitle/CloseBtn"
local sliderGroup_path = "PopUpTitle/Content/UISliderGroup"
local sliderIcon_path = "PopUpTitle/Content/UISliderGroup/sliderIcon"
local sliderBtn_path = "PopUpTitle/Content/UISliderGroup/sliderIcon"
local tog1_path = "PopUpTitle/Content/Range/Tog1"
local tog2_path = "PopUpTitle/Content/Range/Tog2"
local tog3_path = "PopUpTitle/Content/Range/Tog3"
local handle1_path = "PopUpTitle/Content/Range/Tog1/Handle1"
local handle2_path = "PopUpTitle/Content/Range/Tog2/Handle2"
local handle3_path = "PopUpTitle/Content/Range/Tog3/Handle3"
local btn1_path = "PopUpTitle/Content/Range/Tog1/icon1"
local icon1_path = "PopUpTitle/Content/Range/Tog1/icon1"
local btn2_path = "PopUpTitle/Content/Range/Tog2/icon2"
local icon2_path = "PopUpTitle/Content/Range/Tog2/icon2"
local btn3_path = "PopUpTitle/Content/Range/Tog3/icon3"
local icon3_path = "PopUpTitle/Content/Range/Tog3/icon3"
local TxtSetTips_path = "PopUpTitle/Content/TxtSetTips"
local BtnSet_path = "PopUpTitle/Content/BtnSet"
local TxtHistory_path = "PopUpTitle/Content/BgHistory/TxtHistory"
local BgHistory_path = "PopUpTitle/Content/BgHistory"

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self.cityId, self.serverId = self:GetUserData()
  self.meta = DataCenter.AllianceCityTemplateManager:GetTemplate(self.cityId, self.serverId)
  DataCenter.SeasonBankManager:LoadItemIcon(self.sliderIcon, self.meta)
  SFSNetwork.SendMessage(MsgDefines.WorldGetCityStrongholdDetail, self.cityId, self.serverId)
  self:RefreshView()
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
  self.btnBack = self:AddComponent(UIButton, btnBack_path)
  self.btnClose = self:AddComponent(UIButton, btnClose_path)
  self.sliderGroup = self:AddComponent(UIBaseContainer, sliderGroup_path)
  self.sliderIcon = self:AddComponent(UIImage, sliderIcon_path)
  self.sliderBtn = self:AddComponent(UIButton, sliderBtn_path)
  self.tog1 = self:AddComponent(UIToggle, tog1_path)
  self.tog2 = self:AddComponent(UIToggle, tog2_path)
  self.tog3 = self:AddComponent(UIToggle, tog3_path)
  self.handle1 = self:AddComponent(UIImage, handle1_path)
  self.handle2 = self:AddComponent(UIImage, handle2_path)
  self.handle3 = self:AddComponent(UIImage, handle3_path)
  self.btn1 = self:AddComponent(UIButton, btn1_path)
  self.icon1 = self:AddComponent(UIImage, icon1_path)
  self.btn2 = self:AddComponent(UIButton, btn2_path)
  self.icon2 = self:AddComponent(UIImage, icon2_path)
  self.btn3 = self:AddComponent(UIButton, btn3_path)
  self.icon3 = self:AddComponent(UIImage, icon3_path)
  self.TxtSetTips = self:AddComponent(UIText, TxtSetTips_path)
  self.BtnSet = self:AddComponent(UIButton, BtnSet_path)
  self.TxtHistory = self:AddComponent(UIText, TxtHistory_path)
  self.BgHistory = self:AddComponent(UIImage, BgHistory_path)
  self.btnBack:SetOnClick((BindCallback(self.ctrl, self.ctrl.CloseSelf)))
  self.btnClose:SetOnClick((BindCallback(self.ctrl, self.ctrl.CloseSelf)))
  self.sliderGroup = self:AddComponent(UISliderGroup, sliderGroup_path)
  self.sliderGroup:InitTextInput()
  self.sliderGroup:SetGap(1000)
  self.sliderGroup:SetOnNumChangedHandler(function(num)
    self.sliderGroup:SetTipText(num)
  end)
  self.sliderBtn:SetOnClick(function()
    DataCenter.SeasonBankManager:ShowItemTips(self.sliderIcon, self.meta)
  end)
  self.btn1:SetOnClick(function()
    UIUtil.ShowBubbleTips(Localization:GetString("s5_bank_ui24"), self.btn1.transform.position, 0, -30, 0)
  end)
  self.btn2:SetOnClick(function()
    UIUtil.ShowBubbleTips(Localization:GetString("s5_bank_ui25"), self.btn2.transform.position, 0, -30, 0)
  end)
  self.btn3:SetOnClick(function()
    UIUtil.ShowBubbleTips(Localization:GetString("s5_bank_ui26"), self.btn3.transform.position, 0, -30, 0)
  end)
  self.tog1:SetOnValueChanged(function(tf)
    self:OnTogChanged(1, tf)
  end)
  self.tog2:SetOnValueChanged(function(tf)
    self:OnTogChanged(2, tf)
  end)
  self.tog3:SetOnValueChanged(function(tf)
    self:OnTogChanged(3, tf)
  end)
  self.BtnSet:SetOnClick(function()
    self:OnClickSet()
  end)
  DataCenter.SeasonBankManager:LoadServiceScopeIcon(self.icon1, 0)
  DataCenter.SeasonBankManager:LoadServiceScopeIcon(self.icon2, 1)
  DataCenter.SeasonBankManager:LoadServiceScopeIcon(self.icon3, 2)
end

local function ComponentDestroy(self)
  self.btnBack = nil
  self.btnClose = nil
  self.sliderGroup = nil
  self.sliderIcon = nil
  self.sliderBtn = nil
  self.tog1 = nil
  self.tog2 = nil
  self.tog3 = nil
  self.handle1 = nil
  self.handle2 = nil
  self.handle3 = nil
  self.btn1 = nil
  self.icon1 = nil
  self.btn2 = nil
  self.icon2 = nil
  self.btn3 = nil
  self.icon3 = nil
  self.TxtSetTips = nil
  self.BtnSet = nil
  self.TxtHistory = nil
  self.BgHistory = nil
end

local function DataDefine(self)
end

local function DataDestroy(self)
end

function BankSetting:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.WorldAllianceCityDetail, self.RefreshView)
  self:AddUIListener(EventId.ModifyStrongholdBank, self.RefreshView)
end

function BankSetting:OnRemoveListener()
  self:RemoveUIListener(EventId.WorldAllianceCityDetail, self.RefreshView)
  self:RemoveUIListener(EventId.ModifyStrongholdBank, self.RefreshView)
  base.OnRemoveListener(self)
end

function BankSetting:RefreshView()
  self.detail = DataCenter.WorldPointDetailManager:GetAllianceCityData(self.cityId)
  local bankDetail = self.detail and self.detail.bankDetail
  local setting = bankDetail and bankDetail.setting
  local meta = self.meta
  self.sliderGroup:SetMinNum(LuaEntry.DataConfig:TryGetNum("s5_bank_config", "k2", 1000))
  self.sliderGroup:SetMaxNum(meta.max_into_asset)
  self.sliderGroup:SetDefaultNum(setting and setting.minDepositAmount or 0)
  self.sliderGroup:ReInit()
  self.selectIndex = setting and setting.serviceScope or 0
  self.selectIndex = self.selectIndex + 1
  self["tog" .. self.selectIndex]:SetIsOn(true)
  if setting and not string.IsNullOrEmpty(setting.lastSetUserName) then
    local timeStr = UITimeManager:GetInstance():TimeStampToDayForLocal(setting.lastSetTime)
    self.TxtHistory:SetLocalText("s5_bank_ui73", string.format("%s %s ", timeStr, setting.lastSetUserName))
    self.BgHistory:SetActive(true)
  else
    self.BgHistory:SetActive(false)
  end
  self.EndTime = setting and setting.lastSetTime
  if self.EndTime then
    self.EndTime = self.EndTime + LuaEntry.DataConfig:TryGetNum("s5_bank_config", "k3", 48) * 1000 * 60
    self.TxtSetTips:SetActive(true)
    self:Update1000MS()
  else
    self.TxtSetTips:SetActive(false)
  end
  CS.UIGray.SetGray(self.BtnSet.transform, not self:CheckCanSet(), true)
end

function BankSetting:Update1000MS()
  if self.EndTime and UIUtil.SetLeftTimeText(self.TxtSetTips, nil, self.EndTime, "s5_bank_ui27") then
    self.TxtSetTips:SetActive(false)
    CS.UIGray.SetGray(self.BtnSet.transform, not self:CheckCanSet(), true)
  end
end

function BankSetting:OnTogChanged(index, tf)
  if not tf then
    return
  end
  for i = 1, 3 do
    self["handle" .. i]:SetActive(i ~= index)
  end
  self.selectIndex = index
end

function BankSetting:OnClickSet()
  if not self:CheckCanSet(true) then
    return
  end
  SFSNetwork.SendMessage(MsgDefines.LwModifyStrongholdBank, self.cityId, self.sliderGroup:GetCurNum(), self.selectIndex - 1, self.serverId)
end

function BankSetting:CheckCanSet(showTips)
  local bankDetail = self.detail and self.detail.bankDetail
  local setting = bankDetail and bankDetail.setting
  if setting and setting.minDepositAmount == self.sliderGroup:GetCurNum() and setting.serviceScope == self.selectIndex - 1 then
    if showTips then
      UIUtil.ShowTipsId("208255")
    end
    return false
  end
  if not DataCenter.AllianceBaseDataManager:IsR4orR5() then
    if showTips then
      UIUtil.ShowTipsId("s5_bank_tips07")
    end
    return false
  end
  local deltaTime = self.EndTime and self.EndTime - UITimeManager:GetInstance():GetServerTime() or 0
  if 0 < deltaTime then
    if showTips then
      UIUtil.ShowTips(Localization:GetString("s5_bank_tips06", UITimeManager:GetInstance():MilliSecondToFmtString(deltaTime)))
    end
    return false
  end
  return true
end

BankSetting.OnCreate = OnCreate
BankSetting.OnDestroy = OnDestroy
BankSetting.OnEnable = OnEnable
BankSetting.OnDisable = OnDisable
BankSetting.ComponentDefine = ComponentDefine
BankSetting.ComponentDestroy = ComponentDestroy
BankSetting.DataDefine = DataDefine
BankSetting.DataDestroy = DataDestroy
return BankSetting
