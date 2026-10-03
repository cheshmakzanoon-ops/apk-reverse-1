local WorldGotoItemNew = BaseClass("WorldGotoItemNew", UIAsyncContainer)
local base = UIAsyncContainer
local Localization = CS.GameEntry.Localization
local LWSeasonComboBox = require("UI.LWSeasonShared.Component.LWSeasonComboBox")
local x_input_path = "Root/xInputField"
local x_input_placeholder_path = "Root/xInputField/viewport/xPlaceholder"
local y_input_path = "Root/yInputField"
local y_input_placeholder_path = "Root/yInputField/viewport/yPlaceholder"
local btn_path = "Root/Goto_Btn"
local btn_text_path = "Root/Goto_Btn/Goto_Btn_Text"
local posX_text_path = "Root/PosX_Text"
local posY_text_path = "Root/PosY_Text"
local select_mode_path = "Root/SelectMode"
local this_path = ""

function WorldGotoItemNew:OnCreate()
  base.OnCreate(self)
  self.x_input = self:AddComponent(UIInput, x_input_path)
  self.x_input:SetOnEndEdit(function(value)
    self:IptOnXValueChange(value)
  end)
  self.x_inputEvent = self:AddComponent(UIEventTrigger, x_input_path)
  self.x_inputEvent:OnPointerDown(function(eventData)
    self:OnPointerDown(1)
  end)
  self.x_input_placeholder = self:AddComponent(UITextMeshProUGUIEx, x_input_placeholder_path)
  self.x_input_placeholder:SetText("")
  self.y_input = self:AddComponent(UIInput, y_input_path)
  self.y_input:SetOnEndEdit(function(value)
    self:IptOnYValueChange(value)
  end)
  self.y_inputEvent = self:AddComponent(UIEventTrigger, y_input_path)
  self.y_inputEvent:OnPointerDown(function(eventData)
    self:OnPointerDown(2)
  end)
  self.y_input_placeholder = self:AddComponent(UITextMeshProUGUIEx, y_input_placeholder_path)
  self.y_input_placeholder:SetText("")
  self.btn = self:AddComponent(UIButton, btn_path)
  self.btn:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self:OnClickJump()
  end)
  self.btn_text = self:AddComponent(UITextMeshProUGUIEx, btn_text_path)
  self.posX_text = self:AddComponent(UITextMeshProUGUIEx, posX_text_path)
  self.posY_text = self:AddComponent(UITextMeshProUGUIEx, posY_text_path)
  self.btn_text:SetLocalText(GameDialogDefine.GOTO)
  self.posX_text:SetText("X:")
  self.posY_text:SetText("Y:")
  self.animator = self:AddComponent(UIAnimator, this_path)
  self.select_mode = self:AddComponent(LWSeasonComboBox, select_mode_path)
  self.server = -1
  self.x = -1
  self.y = -1
  self.lastTxt = ""
  local curServerId = LuaEntry.Player:GetCurServerId()
  local ComboBoxDataList = {}
  local seasonInfo = SeasonUtil.GetSeasonInfo(curServerId)
  for k = 1, 9 do
    local serverId = seasonInfo:GetNinePalacesServer(k)
    table.insert(ComboBoxDataList, {
      txt = "#" .. serverId,
      serverId = serverId,
      isLocal = true
    })
  end
  local mapIndex = seasonInfo:GetNinePalacesIndex(curServerId)
  self.select_mode:SelectedIndexChanged(nil)
  self.select_mode:FillData(ComboBoxDataList, mapIndex)
  self.select_mode:SelectedIndexChanged(function(index, data)
    self:OnSelectedIndexChanged(index, data)
  end)
end

function WorldGotoItemNew:OnDestroy()
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

function WorldGotoItemNew:OnEnable()
  base.OnEnable(self)
  if self.animator then
    self.animator:Play("CommonPopup_movein", 0, 0)
  end
end

function WorldGotoItemNew:OnDisable()
  if self.animator then
    self.animator:Play("CommonPopup_moveout", 0, 0)
  end
  base.OnDisable(self)
end

function WorldGotoItemNew:OnSelectedIndexChanged(index, data)
  self.selectData = data
  self.server = data.serverId
end

function WorldGotoItemNew:UpdateData()
  if IsNotNull(self.gameObject) then
    self:InputCoordinate(true)
    self:InitState()
  end
end

function WorldGotoItemNew:InputCoordinate(isOn)
  self.inputCoordinate = isOn
  self.x_input:SetInteractable(isOn)
  self.btn:SetActive(isOn)
  self.y_input:SetInteractable(isOn)
end

local function GetCurrentState()
  local showData = {}
  local pos = CS.SceneManager.World.CurTarget
  local tile = SceneUtils.WorldToTile(pos, ForceChangeScene.World)
  showData.x = Mathf.Mod(tile.x, WorldTileCount)
  showData.y = Mathf.Mod(tile.y, WorldTileCount)
  showData.serverId = LuaEntry.Player:GetCurServerId()
  return showData
end

function WorldGotoItemNew:InitState()
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

function WorldGotoItemNew:IptOnXValueChange(value)
  if value == "" then
    value = self.lastTxt
  end
  self.x = tonumber(value)
  self.x = self.x or 0
  self.x_input:SetText(tostring(self.x))
end

function WorldGotoItemNew:OnPointerDown(XorY)
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

function WorldGotoItemNew:IptOnYValueChange(value)
  if value == "" then
    value = self.lastTxt
  end
  self.y = tonumber(value)
  self.y = self.y or 0
  self.y_input:SetText(tostring(self.y))
end

function WorldGotoItemNew:OnClickJump()
  local serverId = toInt(self.server)
  local x = toInt(self.x)
  local y = toInt(self.y)
  if CS.CommonUtils.IsDebug() and self.x == 987123 then
    local _serverId = toInt(self.y)
    local _maxServerId = math.min(toInt(DataCenter.AccountManager.maxServerId), 8000)
    if (_serverId <= _maxServerId or _maxServerId == 0) and 1 < _serverId then
      GoToUtil.GotoWorldPos({
        x = 1001,
        y = 0,
        z = 1001
      }, CS.SceneManager.World.Zoom, nil, function()
      end, _serverId)
      return
    end
  end
  if serverId <= 0 or x < 0 or y < 0 or 1000 <= x or 1000 <= y then
    UIUtil.ShowTips(Localization:GetString(CS.GameDialogDefine.OUT_UNLOCK_RANGE_REASON, 0, 0, 999, 999))
    return
  end
  local worldPos = SceneUtils.TileToWorld(Vector2.New(self.x, self.y), ForceChangeScene.World)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UISearch, {
    anim = true,
    UIMainAnim = UIMainAnimType.AllShow
  })
  GoToUtil.GotoPos(worldPos, CS.SceneManager.World.Zoom, nil, nil, serverId)
end

return WorldGotoItemNew
