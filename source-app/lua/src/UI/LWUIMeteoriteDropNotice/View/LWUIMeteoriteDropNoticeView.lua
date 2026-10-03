local base = UIBaseView
local LWUIMeteoriteDropNotice = BaseClass("LWUIMeteoriteDropNotice", base)
local btnConfirm_path = "MainRect/btnConfirm"
local btnBackground_path = "btnBackground"
local btnClose_path = "MainRect/UICommonWindow/bg_3/CloseBtn"
local goItem0_path = "MainRect/itemsNode/item_0"
local goItem1_path = "MainRect/itemsNode/item_1"
local tmpCount0_path = "MainRect/itemsNode/item_0/tmpCount_0"
local tmpCount1_path = "MainRect/itemsNode/item_1/tmpCount_1"
local btnCancel_path = "MainRect/btnCancel"
local btnSelection_path = "MainRect/btnSelection"
local imgSelected_path = "MainRect/btnSelection/imgSelected"
local tmpToggleNotice_path = "MainRect/btnSelection/tmpToggleNotice"
local tmpNotice_path = "MainRect/tmpNotice"
local tmpTitle_path = "MainRect/UICommonWindow/bg_3/TitleTxt"
local txtConfirm_path = "MainRect/btnConfirm/LW_Btn_Common_New_Base/BtnTextConfirm"
local txtCancel_path = "MainRect/btnCancel/LW_Btn_Common_New_Base/BtnTextCancel"

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
  local data = self:GetUserData()
  self.ok = data and data.ok
  self.notice = data and data.notice or ""
  self.cancel = data and data.cancel
  self.crystal = data and data.crystal
  self.nucleus = data and data.nucleus
  self.ignoreNoticeKey = data and data.ignoreKey or SettingKeys.NO_METEORITE_DROP_PROMPT
  self:RefreshMeteoriteCount()
  self:RefreshRemember()
  self:RefreshNotice()
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function ComponentDefine(self)
  self.btnConfirm = self:AddComponent(UIButton, btnConfirm_path)
  self.btnBackground = self:AddComponent(UIButton, btnBackground_path)
  self.btnClose = self:AddComponent(UIButton, btnClose_path)
  self.goItem0 = self:AddComponent(UIBaseContainer, goItem0_path)
  self.goItem1 = self:AddComponent(UIBaseContainer, goItem1_path)
  self.tmpCount0 = self:AddComponent(UIText, tmpCount0_path)
  self.tmpCount1 = self:AddComponent(UIText, tmpCount1_path)
  self.btnCancel = self:AddComponent(UIButton, btnCancel_path)
  self.btnSelection = self:AddComponent(UIButton, btnSelection_path)
  self.imgSelected = self:AddComponent(UIImage, imgSelected_path)
  self.tmpToggleNotice = self:AddComponent(UIText, tmpToggleNotice_path)
  self.tmpNotice = self:AddComponent(UIText, tmpNotice_path)
  self.tmpTitle = self:AddComponent(UIText, tmpTitle_path)
  self.txtConfirm = self:AddComponent(UIText, txtConfirm_path)
  self.txtCancel = self:AddComponent(UIText, txtCancel_path)
  local close = Bind(self, self.OnClickedCancel)
  self.btnClose:SetOnClick(close)
  self.btnCancel:SetOnClick(close)
  self.btnConfirm:SetOnClick(Bind(self, self.OnClickedOk))
  self.btnSelection:SetOnClick(Bind(self, self.ClickedRemember))
  self.tmpToggleNotice:SetLocalText("120059")
  self.tmpTitle:SetLocalText("building_finish_remind_title")
  self.txtConfirm:SetLocalText("building_finish_confirm_button")
  self.txtCancel:SetLocalText("building_finish_cancel_button")
end

local function ComponentDestroy(self)
  self.btnConfirm = nil
  self.btnBackground = nil
  self.btnClose = nil
  self.goItem0 = nil
  self.goItem1 = nil
  self.tmpCount0 = nil
  self.tmpCount1 = nil
  self.btnCancel = nil
  self.btnSelection = nil
  self.imgSelected = nil
  self.tmpToggleNotice = nil
  self.tmpNotice = nil
  self.tmpTitle = nil
  self.txtConfirm = nil
  self.txtCancel = nil
end

local function DataDefine(self)
  self.remember = false
end

function LWUIMeteoriteDropNotice:ClickedRemember()
  self.remember = not self.remember
  self:RefreshRemember()
end

function LWUIMeteoriteDropNotice:RefreshRemember()
  self.imgSelected:SetActive(self.remember)
end

function LWUIMeteoriteDropNotice:RefreshNotice()
  if self.tmpNotice then
    self.tmpNotice:SetLocalText(self.notice)
  end
end

local function DataDestroy(self)
  self.crystal = nil
  self.nucleus = nil
end

function LWUIMeteoriteDropNotice:OnClickedOk()
  CommonUtil.PlayerPrefsSetBool(self.ignoreNoticeKey, self.remember)
  if CommonUtil.IsDebug() and self.remember then
    UIUtil.ShowTips("[Debug]\228\191\157\229\173\152\228\184\139\230\172\161\228\184\141\229\134\141\230\143\144\231\164\186\239\188\129\239\188\129")
  end
  if self.ok then
    self.ok()
  end
  self.ctrl:CloseSelf()
end

function LWUIMeteoriteDropNotice:OnClickedCancel()
  if self.cancel then
    self.cancel()
  end
  self.ctrl:CloseSelf()
end

function LWUIMeteoriteDropNotice:RefreshMeteoriteCount()
  local m1, m2 = DataCenter.ActMeteoriteBattleManager:GetCityMeteoriteCount()
  local m11, m22 = DataCenter.ActMeteoriteBattleManager:GetMarchMeteoriteCount()
  m1 = m1 + m11
  m2 = m2 + m22
  local crystal = self.crystal or m1
  local nucleus = self.nucleus or m2
  if crystal and 0 < crystal then
    self.goItem0:SetActive(true)
    self.tmpCount0:SetText(tostring(crystal))
  else
    self.goItem0:SetActive(false)
  end
  if nucleus and 0 < nucleus then
    self.goItem1:SetActive(true)
    self.tmpCount1:SetText(tostring(nucleus))
  else
    self.goItem1:SetActive(false)
  end
end

LWUIMeteoriteDropNotice.OnCreate = OnCreate
LWUIMeteoriteDropNotice.OnDestroy = OnDestroy
LWUIMeteoriteDropNotice.OnEnable = OnEnable
LWUIMeteoriteDropNotice.OnDisable = OnDisable
LWUIMeteoriteDropNotice.ComponentDefine = ComponentDefine
LWUIMeteoriteDropNotice.ComponentDestroy = ComponentDestroy
LWUIMeteoriteDropNotice.DataDefine = DataDefine
LWUIMeteoriteDropNotice.DataDestroy = DataDestroy
return LWUIMeteoriteDropNotice
