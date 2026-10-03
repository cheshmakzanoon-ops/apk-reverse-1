local base = UIBaseContainer
local SuppliesSignalItem = BaseClass("SuppliesSignalItem", base)
local bgImg_path = "bg"
local title_path = "desc"
local position_path = "posGoto/pos"
local icon_path = "icon"
local iconType_path = "iconType"
local name_path = "name"
local gotoBtn_path = "gotoBtn"
local gotoBtnText_path = "gotoBtn/ConfirmBtnText"
local posGotoBtn_path = "posGoto"
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
  self.icon = self:AddComponent(UIImage, icon_path)
  self.iconType = self:AddComponent(UIImage, iconType_path)
  self.name = self:AddComponent(UIText, name_path)
  self.gotoBtn = self:AddComponent(UIButton, gotoBtn_path)
  self.gotoBtnText = self:AddComponent(UIText, gotoBtnText_path)
  self.posGotoBtn = self:AddComponent(UIButton, posGotoBtn_path)
  self.iconCharge = self:AddComponent(UIImage, iconCharge_path)
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
  self.icon = nil
  self.iconType = nil
  self.name = nil
  self.gotoBtn = nil
  self.gotoBtnText = nil
  self.posGotoBtn = nil
  self.iconCharge = nil
end

local function DataDefine(self)
end

local function DataDestroy(self)
end

function SuppliesSignalItem:SetData(data)
  self.data = data
  local config = LocalController:instance():getLine(TableName.LWIceSupplies, data.configId)
  if not config then
    return
  end
  self.name:SetLocalText(config.name)
  local desc = config.type == WorldSuppliesType.DarknessSeasonSmallType and "season4_supplies_UI_7" or "season4_supplies_UI_8"
  self.title:SetLocalText(desc)
  self.icon:LoadSprite(config.icon)
  local pos = SceneUtils.IndexToTilePos(data.pointId, ForceChangeScene.World)
  self.position:SetText(string.format("#%s X:%s Y:%s", tostring(data.serverId), tostring(pos.x), tostring(pos.y)))
  local iconType = config.type == WorldSuppliesType.DarknessSeasonSmallType and "Supplies/zxl_s4_wuzi_shoudian" or "Supplies/zxl_s4_wuzi_dengpao"
  self.iconType:LoadSprite(string.format(LoadPath.UISeason4Path, iconType))
  self.isCharging = self:IsCharging(self.data)
  if self.isCharging then
    self.iconCharge:SetActive(true)
    self.gotoBtnText:SetLocalText("season4_supplies_UI_12")
    CS.UIGray.SetGray(self.gotoBtn.transform, false, true)
  else
    self.iconCharge:SetActive(false)
    self:UpdateBtn(data.state)
  end
end

function SuppliesSignalItem:Jump()
  if not self.data then
    return
  end
  GoToUtil.CloseAllWindows()
  local pos = SceneUtils.TileIndexToWorld(self.data.pointId, ForceChangeScene.World)
  GoToUtil.GotoWorldPos(pos, CS.SceneManager.World.InitZoom, LookAtFocusTime, nil, self.data.serverId)
end

function SuppliesSignalItem:UpdateBtn(state)
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

function SuppliesSignalItem:IsCharging(data)
  if data.chargeEndTime <= 0 then
    return false
  end
  local curTime = UITimeManager:GetInstance():GetServerTime()
  if curTime > data.chargeStartTime and curTime < data.chargeEndTime then
    return true
  end
  return false
end

SuppliesSignalItem.OnCreate = OnCreate
SuppliesSignalItem.OnDestroy = OnDestroy
SuppliesSignalItem.OnEnable = OnEnable
SuppliesSignalItem.OnDisable = OnDisable
SuppliesSignalItem.ComponentDefine = ComponentDefine
SuppliesSignalItem.ComponentDestroy = ComponentDestroy
SuppliesSignalItem.DataDefine = DataDefine
SuppliesSignalItem.DataDestroy = DataDestroy
return SuppliesSignalItem
