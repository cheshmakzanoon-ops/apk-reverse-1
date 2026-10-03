local base = UIBaseContainer
local SuppliesShareItem = BaseClass("SuppliesShareItem", base)
local Localization = CS.GameEntry.Localization
local bgImg_path = "bg"
local title_path = "info/desc"
local position_path = "posGoto/pos"
local head_path = "headRoot/UIPlayerHead"
local name_path = "info/name"
local gotoBtn_path = "gotoBtn"
local gotoBtnText_path = "gotoBtn/ConfirmBtnText"
local posGotoBtn_path = "posGoto"
local state_path = "info/state"
local iconCharge_path = "iconCharge"

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
  self.bgImg = self:AddComponent(UIImage, bgImg_path)
  self.title = self:AddComponent(UIText, title_path)
  self.position = self:AddComponent(UIText, position_path)
  self.head = self:AddComponent(UIBaseContainer, head_path)
  self.name = self:AddComponent(UIText, name_path)
  self.gotoBtn = self:AddComponent(UIButton, gotoBtn_path)
  self.gotoBtnText = self:AddComponent(UIText, gotoBtnText_path)
  self.posGotoBtn = self:AddComponent(UIButton, posGotoBtn_path)
  self.state = self:AddComponent(UIText, state_path)
  self.iconCharge = self:AddComponent(UIBaseContainer, iconCharge_path)
  self.playerIcon = self:AddComponent(UICommonHead, head_path)
  self.playerIcon:SetEnableClickShowInfo(true, true)
  self.gotoBtn:SetOnClick(function()
    self:Jump()
  end)
  self.posGotoBtn:SetOnClick(function()
    self:Jump()
  end)
end

local function ComponentDestroy(self)
  self.bgImg = nil
  self.title = nil
  self.position = nil
  self.head = nil
  self.name = nil
  self.gotoBtn = nil
  self.gotoBtnText = nil
  self.posGotoBtn = nil
  self.state = nil
  self.iconCharge = nil
end

local function DataDefine(self)
end

local function DataDestroy(self)
end

function SuppliesShareItem:SetData(data)
  self.data = data
  self.playerIcon:SetHeadAndFrame(self.data.uid, self.data.pic, self.data.picver, false, self.data.headSkinId, self.data.headSkinET)
  local configData = LocalController:instance():getLine(TableName.LWIceSupplies, self.data.configId)
  local param = {}
  param[1] = Localization:GetString("season_s2_ice_supplies_3", tostring(configData.level))
  param[2] = Localization:GetString(configData.name)
  local count = configData.total_limit - self.data.progress
  if 0 < count then
    param[3] = "<color=#0aa032>" .. tostring(count) .. "</color>"
  else
    param[3] = tostring(count)
  end
  param[4] = configData.total_limit
  local title = string.format("%s %s %s/%s", SafeUnpack(param))
  self.title:SetText(title)
  self.name:SetText(self.data.userName)
  local pos = SceneUtils.IndexToTilePos(self.data.pointId, ForceChangeScene.World)
  self.position:SetText(string.format("#%s X:%s Y:%s", tostring(self.data.pointServerid), tostring(pos.x), tostring(pos.y)))
  self.isCharging = self.data.chargeData:IsCharging()
  if self.isCharging then
    self.state:SetActive(true)
    self.iconCharge:SetActive(true)
    self.gotoBtnText:SetLocalText("season4_supplies_UI_12")
    CS.UIGray.SetGray(self.gotoBtn.transform, false, true)
    self:Update1000MS()
  else
    self.state:SetActive(false)
    self.iconCharge:SetActive(false)
    self:UpdateBtn(self.data.state)
  end
end

function SuppliesShareItem:Jump()
  if not self.data then
    return
  end
  GoToUtil.CloseAllWindows()
  local pos = SceneUtils.TileIndexToWorld(self.data.pointId, ForceChangeScene.World)
  GoToUtil.GotoWorldPos(pos, CS.SceneManager.World.InitZoom, LookAtFocusTime, nil, self.data.pointServerid)
end

function SuppliesShareItem:UpdateBtn(state)
  if state == 1 then
    self.gotoBtnText:SetLocalText("season_s2_ice_supplies_21")
    CS.UIGray.SetGray(self.gotoBtn.transform, false, true)
  else
    CS.UIGray.SetGray(self.gotoBtn.transform, true, false)
    if state == 2 then
      self.gotoBtnText:SetLocalText("season_s2_ice_supplies_22")
    elseif state == 3 then
      self.gotoBtnText:SetLocalText("season_s2_ice_supplies_23")
    end
  end
end

function SuppliesShareItem:Update1000MS()
  if not self.isCharging then
    return
  end
  local str = Localization:GetString("season4_supplies_UI_12")
  str = string.format("(%s <color=#FF0000>%0.1f%%</color>)", str, self.data.chargeData:GetPercent() * 100)
  self.state:SetText(str)
  return true
end

SuppliesShareItem.OnCreate = OnCreate
SuppliesShareItem.OnDestroy = OnDestroy
SuppliesShareItem.OnEnable = OnEnable
SuppliesShareItem.OnDisable = OnDisable
SuppliesShareItem.ComponentDefine = ComponentDefine
SuppliesShareItem.ComponentDestroy = ComponentDestroy
SuppliesShareItem.DataDefine = DataDefine
SuppliesShareItem.DataDestroy = DataDestroy
return SuppliesShareItem
