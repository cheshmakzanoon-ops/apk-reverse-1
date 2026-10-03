local WorldGotoItem = BaseClass("WorldGotoItem", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local x_input_path = "xInputField"
local x_input_placeholder_path = "xInputField/viewport/xPlaceholder"
local y_input_path = "yInputField"
local y_input_placeholder_path = "yInputField/viewport/yPlaceholder"
local btn_path = "Goto_Btn"
local btn_text_path = "Goto_Btn/Goto_Btn_Text"
local posX_text_path = "PosX_Text"
local posY_text_path = "PosY_Text"
local this_path = ""

local function OnCreate(self)
  base.OnCreate(self)
  self.x_input = self:AddComponent(UIInput, x_input_path)
  self.x_input:SetOnEndEdit(function(value)
    self:IptOnXValueChange(value)
  end)
  self.x_inputEvent = self:AddComponent(UIEventTrigger, x_input_path)
  self.x_inputEvent:OnPointerDown(function(eventData)
    self:OnPointerDown(1)
  end)
  self.x_input_placeholder = self:AddComponent(UIText, x_input_placeholder_path)
  self.x_input_placeholder:SetText("")
  self.y_input = self:AddComponent(UIInput, y_input_path)
  self.y_input:SetOnEndEdit(function(value)
    self:IptOnYValueChange(value)
  end)
  self.y_inputEvent = self:AddComponent(UIEventTrigger, y_input_path)
  self.y_inputEvent:OnPointerDown(function(eventData)
    self:OnPointerDown(2)
  end)
  self.y_input_placeholder = self:AddComponent(UIText, y_input_placeholder_path)
  self.y_input_placeholder:SetText("")
  self.btn = self:AddComponent(UIButton, btn_path)
  self.btn:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self:OnClickJump()
  end)
  self.btn_text = self:AddComponent(UIText, btn_text_path)
  self.posX_text = self:AddComponent(UIText, posX_text_path)
  self.posY_text = self:AddComponent(UIText, posY_text_path)
  self.btn_text:SetLocalText(GameDialogDefine.GOTO)
  self.posX_text:SetText("X:")
  self.posY_text:SetText("Y:")
  self.animator = self:AddComponent(UIAnimator, this_path)
  self.server = -1
  self.x = -1
  self.y = -1
  self.lastTxt = ""
  self:InputCoordinate(true)
end

local function OnDestroy(self)
  self.animator = nil
  self.x_input = nil
  self.x_inputEvent = nil
  self.y_input = nil
  self.y_inputEvent = nil
  self.btn = nil
  self.btn_text = nil
  self.posX_text = nil
  self.posY_text = nil
  self.x = nil
  self.y = nil
  self.lastTxt = nil
  base.OnDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
  self:InitState()
  if self.animator then
    self.animator:Play("CommonPopup_movein", 0, 0)
  end
end

local function OnDisable(self)
  if self.animator then
    self.animator:Play("CommonPopup_moveout", 0, 0)
  end
  base.OnDisable(self)
end

function WorldGotoItem:InputCoordinate(isOn)
  self.inputCoordinate = isOn
  self.x_input:SetInteractable(isOn)
  self.btn:SetActive(isOn)
  self.y_input:SetInteractable(isOn)
end

local function GetCurrentState()
  local showData = {}
  local pos = CS.SceneManager.World.CurTarget
  local tile = SceneUtils.WorldToTileIndex(pos, ForceChangeScene.World)
  local v2 = SceneUtils.IndexToTilePos(tile, ForceChangeScene.World)
  showData.x = v2.x
  showData.y = v2.y
  showData.serverId = LuaEntry.Player:GetCurServerId()
  return showData
end

local function InitState(self)
  local data = GetCurrentState()
  self.server = data.serverId
  self.x = data.x
  self.y = data.y
  if self.x >= 0 and self.y >= 0 then
    self.x_input:SetText(tostring(self.x))
    self.y_input:SetText(tostring(self.y))
  else
    self.x_input:SetText("")
    self.y_input:SetText("")
  end
end

local function IptOnXValueChange(self, value)
  if value == "" then
    value = self.lastTxt
  end
  self.x = tonumber(value)
  self.x = self.x or 0
  self.x_input:SetText(tostring(self.x))
end

local function OnPointerDown(self, XorY)
  if not self.inputCoordinate then
    return
  end
  self.view:HideBg()
  if XorY == 1 then
    self.lastTxt = self.x_input:GetText()
    self.x_input:SetText("")
  elseif XorY == 2 then
    self.lastTxt = self.y_input:GetText()
    self.y_input:SetText("")
  end
end

local function IptOnYValueChange(self, value)
  if value == "" then
    value = self.lastTxt
  end
  self.y = tonumber(value)
  self.y = self.y or 0
  self.y_input:SetText(tostring(self.y))
end

local function OnClickJump(self)
  if CS.CommonUtils.IsDebug() then
    local serverId = toInt(self.y)
    local maxServerId = math.min(toInt(DataCenter.AccountManager.maxServerId), 8000)
    if self.x == 987123 and (serverId <= maxServerId or maxServerId == 0) and 1 < serverId then
      GoToUtil.GotoWorldPos({
        x = 1001,
        y = 0,
        z = 1001
      }, MoveCityCameraHeight, nil, function()
      end, serverId)
      return
    end
  end
  if self.view.ctrl:CheckCanGo(self.server, self.x, self.y) == false then
    UIUtil.ShowTips(Localization:GetString(CS.GameDialogDefine.OUT_UNLOCK_RANGE_REASON, CS.SceneManager.World.CurTileCountXMin, CS.SceneManager.World.CurTileCountYMin, CS.SceneManager.World.CurTileCountXMax, CS.SceneManager.World.CurTileCountYMax))
  else
    self.view.ctrl:OnJumpClick(self.server, self.x, self.y)
  end
end

WorldGotoItem.OnCreate = OnCreate
WorldGotoItem.OnDestroy = OnDestroy
WorldGotoItem.InitState = InitState
WorldGotoItem.OnEnable = OnEnable
WorldGotoItem.OnDisable = OnDisable
WorldGotoItem.IptOnXValueChange = IptOnXValueChange
WorldGotoItem.IptOnYValueChange = IptOnYValueChange
WorldGotoItem.OnClickJump = OnClickJump
WorldGotoItem.OnEnable = OnEnable
WorldGotoItem.OnDisable = OnDisable
WorldGotoItem.OnPointerDown = OnPointerDown
return WorldGotoItem
