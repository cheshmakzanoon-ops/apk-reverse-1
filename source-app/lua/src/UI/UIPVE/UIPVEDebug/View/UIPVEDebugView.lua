local UIPVEDebug = BaseClass("UIPVEDebug", UIBaseView)
local base = UIBaseView
local close_path = "UICommonMidPopUpTitle/CloseBtn"
local panel_path = "UICommonMidPopUpTitle/panel"
local content_path = "ScrollView/Viewport/Content"
local x_input_path = content_path .. "/Pos/XInput"
local y_input_path = content_path .. "/Pos/YInput"
local pos_type_path = content_path .. "/Pos/PosType"
local teleport_path = content_path .. "/Pos/Teleport"
local trigger_input_path = content_path .. "/Trigger/TriggerInput"
local do_trigger_path = content_path .. "/Trigger/DoTrigger"
local tel_trigger_path = content_path .. "/Trigger/TelTrigger"
local attack_input_path = content_path .. "/Player/AttackInput"
local attack_speed_input_path = content_path .. "/Player/AttackSpeedInput"
local move_speed_input_path = content_path .. "/Player/MoveSpeedInput"
local clear_fog_path = content_path .. "/Common/ClearFog"
local finish_level_path = content_path .. "/Common/FinishLevel"

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

local function OnDestroy(self)
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

local function ComponentDefine(self)
  self.close_btn = self:AddComponent(UIButton, close_path)
  self.close_btn:SetOnClick(function()
    self:Close()
  end)
  self.panel_btn = self:AddComponent(UIButton, panel_path)
  self.panel_btn:SetOnClick(function()
    self:Close()
  end)
  self.x_input = self:AddComponent(UIInput, x_input_path)
  self.y_input = self:AddComponent(UIInput, y_input_path)
  self.pos_type_dropdown = self:AddComponent(UIDropdown, pos_type_path)
  self.teleport_btn = self:AddComponent(UIButton, teleport_path)
  self.teleport_btn:SetOnClick(function()
    self:OnTeleportClick()
  end)
  self.trigger_input = self:AddComponent(UIInput, trigger_input_path)
  self.do_trigger_btn = self:AddComponent(UIButton, do_trigger_path)
  self.do_trigger_btn:SetOnClick(function()
    self:OnDoTriggerClick()
  end)
  self.tel_trigger_btn = self:AddComponent(UIButton, tel_trigger_path)
  self.tel_trigger_btn:SetOnClick(function()
    self:OnTelTriggerClick()
  end)
  self.attack_input = self:AddComponent(UIInput, attack_input_path)
  self.attack_input:SetOnValueChange(function()
    self:OnAttackChange()
  end)
  self.attack_speed_input = self:AddComponent(UIInput, attack_speed_input_path)
  self.attack_speed_input:SetOnValueChange(function()
    self:OnAttackSpeedChange()
  end)
  self.move_speed_input = self:AddComponent(UIInput, move_speed_input_path)
  self.move_speed_input:SetOnValueChange(function()
    self:OnMoveSpeedChange()
  end)
  self.clear_fog_btn = self:AddComponent(UIButton, clear_fog_path)
  self.clear_fog_btn:SetOnClick(function()
    self:OnClearFogClick()
  end)
  self.finish_level_btn = self:AddComponent(UIButton, finish_level_path)
  self.finish_level_btn:SetOnClick(function()
    self:OnFinishLevelClick()
  end)
end

local function ComponentDestroy(self)
  self.x_input = nil
  self.y_input = nil
  self.pos_type_dropdown = nil
  self.teleport_btn = nil
  self.trigger_input = nil
  self.do_trigger_btn = nil
  self.tel_trigger_btn = nil
  self.attack_input = nil
  self.attack_speed_input = nil
  self.move_speed_input = nil
  self.clear_fog_btn = nil
  self.finish_level_btn = nil
end

local function DataDefine(self)
end

local function DataDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
  self:ReInit()
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function OnAddListener(self)
  base.OnAddListener(self)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
end

local function ReInit(self)
  local pos = DataCenter.BattleLevel:GetPosition()
  self.x_input:SetText(toInt(pos.x))
  self.y_input:SetText(toInt(pos.z))
  self.pos_type_dropdown:SetValue(0)
  self.move_speed_input:SetText(DataCenter.BattleLevel:GetSpeedMulti())
  local player = DataCenter.BattleLevel:GetPlayer()
  if player then
    self.attack_input:SetText(player:GetAttack())
    self.attack_speed_input:SetText(player:GetAttackSpeed())
  end
end

local function Close(self)
  self.ctrl:CloseSelf()
end

local function OnTeleportClick(self)
  local x = tonumber(self.x_input:GetText()) or 0
  local y = tonumber(self.y_input:GetText()) or 0
  if x ~= 0 and y ~= 0 then
    local worldPos = Vector3.zero
    local posType = self.pos_type_dropdown:GetText()
    if posType == "Tile" then
      local tilePos = Vector2.New(x, y)
      worldPos = SceneUtils.TileToWorld(tilePos)
    elseif posType == "World" then
      worldPos = Vector3.New(x, 0, y)
    end
    DataCenter.BattleLevel:SetPosition(worldPos, true)
    self:Close()
  end
end

local function OnDoTriggerClick(self)
  local triggerId = tonumber(self.trigger_input:GetText()) or 0
  local trigger = DataCenter.BattleLevel:GetTriggerByTriggerId(triggerId)
  if trigger ~= nil then
    DataCenter.BattleLevel:DoTrigger(trigger)
    trigger:SetVisible(false)
    self:Close()
  end
end

local function OnTelTriggerClick(self)
  local triggerId = tonumber(self.trigger_input:GetText()) or 0
  local trigger = DataCenter.BattleLevel:GetTriggerByTriggerId(triggerId)
  if trigger ~= nil then
    DataCenter.BattleLevel:SetPosition(trigger:GetPosition(), true)
    self:Close()
  end
end

local function OnAttackChange(self)
  local player = DataCenter.BattleLevel:GetPlayer()
  if player then
    player:SetAttack(tonumber(self.attack_input:GetText()) or 1)
  end
end

local function OnAttackSpeedChange(self)
  local player = DataCenter.BattleLevel:GetPlayer()
  if player then
    player:SetAttackSpeed(tonumber(self.attack_speed_input:GetText()) or 1)
  end
end

local function OnMoveSpeedChange(self)
  DataCenter.BattleLevel:SetSpeedMulti(tonumber(self.move_speed_input:GetText()) or 1)
end

local function OnClearFogClick(self)
  for i = 1, 10000 do
    DataCenter.BattleLevel.fog:UnlockOneFogEx(i)
  end
  self:Close()
end

local function OnFinishLevelClick(self)
  DataCenter.BattleLevel:DebugWin()
  self:Close()
end

UIPVEDebug.OnCreate = OnCreate
UIPVEDebug.OnDestroy = OnDestroy
UIPVEDebug.OnEnable = OnEnable
UIPVEDebug.OnDisable = OnDisable
UIPVEDebug.ComponentDefine = ComponentDefine
UIPVEDebug.ComponentDestroy = ComponentDestroy
UIPVEDebug.DataDefine = DataDefine
UIPVEDebug.DataDestroy = DataDestroy
UIPVEDebug.OnAddListener = OnAddListener
UIPVEDebug.OnRemoveListener = OnRemoveListener
UIPVEDebug.ReInit = ReInit
UIPVEDebug.Close = Close
UIPVEDebug.OnTeleportClick = OnTeleportClick
UIPVEDebug.OnDoTriggerClick = OnDoTriggerClick
UIPVEDebug.OnTelTriggerClick = OnTelTriggerClick
UIPVEDebug.OnAttackChange = OnAttackChange
UIPVEDebug.OnAttackSpeedChange = OnAttackSpeedChange
UIPVEDebug.OnMoveSpeedChange = OnMoveSpeedChange
UIPVEDebug.OnClearFogClick = OnClearFogClick
UIPVEDebug.OnFinishLevelClick = OnFinishLevelClick
return UIPVEDebug
