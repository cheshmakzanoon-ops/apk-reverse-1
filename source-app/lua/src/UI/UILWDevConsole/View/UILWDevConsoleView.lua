local UILWDevConsoleView = BaseClass("UILWDevConsoleView", UIBaseView)
local base = UIBaseView
local COMMANDS_WITH_HELP = {
  "cmd_skip",
  "cmd_pve",
  "cmd_dump",
  "cmd_guide",
  "cmd_plot",
  "cmd_head"
}
local helpInited = false
local compBook = {
  {
    path = "Panel/input",
    name = "input",
    type = UIInput,
    text = ""
  },
  {
    path = "Panel/output/Viewport/Content",
    name = "output",
    type = UITextMeshProUGUI,
    text = ""
  },
  {
    path = "Panel/btn_close",
    name = "btn_close",
    type = UIButton,
    onClick = function(self)
      self.ctrl:CloseSelf()
    end
  },
  {
    path = "Panel/btn_help",
    name = "btn_help",
    type = UIButton,
    onClick = function(self)
      if self.helpOn then
        self:FoldHelp()
      else
        self:UnfoldHelp()
      end
    end
  },
  {
    path = "Panel/btn_execute",
    name = "btn_execute",
    type = UIButton,
    onClick = function(self)
      self:TryExecute()
    end
  },
  {
    path = "Panel/btn_history_up",
    name = "btn_history_up",
    type = UIButton,
    onClick = function(self)
      self:HistoryUp()
    end
  },
  {
    path = "Panel/btn_history_down",
    name = "btn_history_down",
    type = UIButton,
    onClick = function(self)
      self:HistoryDown()
    end
  },
  {
    path = "Panel/btn_shortcut",
    name = "btn_shortcut",
    type = UIButton,
    onClick = function(self)
      if self.shortcutOn then
        self:FoldShortcut()
      else
        self:UnfoldShortcut()
      end
    end
  },
  {
    path = "Panel/panel_help",
    name = "panel_help",
    type = UIBaseContainer
  },
  {
    path = "Panel/panel_help/drop_commands",
    name = "drop_cmds",
    type = UIDropdown
  },
  {
    path = "Panel/panel_help/content",
    name = "txt_help",
    type = UIText
  },
  {
    path = "Panel/panel_shortcut",
    name = "panel_shortcut",
    type = UIBaseComponent
  },
  {
    path = "Panel/panel_shortcut/btn_skip_op",
    name = "shortcuts.btn_skip_op",
    type = UIButton
  }
}

function UILWDevConsoleView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  local historyBuffer, initPrint = self:GetUserData()
  self.historyBuffer = historyBuffer
  self.historyIdx = 0
  self.tempInput = ""
  if initPrint then
    self:Print2Output(initPrint)
  end
end

function UILWDevConsoleView:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UILWDevConsoleView:ComponentDestroy()
  self:ClearCompsByBook(compBook)
end

function UILWDevConsoleView:ComponentDefine()
  self:DefineCompsByBook(compBook)
  self.input:Select()
  self.input:SetOnValueChange(function()
    self.historyIdx = 0
  end)
  self.panel_help:SetOffsetMinXY(Screen.width, 0)
  self.panel_help:SetOffsetMaxXY(Screen.width, 0)
  self.drop_cmds:SetOnValueChanged(function(value)
    self.helpCmdIdx = value + 1
    self:ShowHelp()
  end)
  if not helpInited then
    for _, v in ipairs(COMMANDS_WITH_HELP) do
      self.drop_cmds:Add(CS.UnityEngine.UI.Dropdown.OptionData(v))
    end
    helpInited = true
  end
  self.drop_cmds:SetValue(0)
  self.panel_shortcut:SetOffsetMinXY(0, -Screen.height * self.panel_shortcut:GetAnchorMax().y)
  self.panel_shortcut:SetOffsetMaxXY(0, -Screen.height * self.panel_shortcut:GetAnchorMax().y)
  for key, btn in pairs(self.shortcuts) do
    btn:SetOnClick(function()
      local arr = string.split(key, "_")
      assert(2 <= #arr, "DevConsole Error: invalid shortcut key -> " .. key)
      local shortcutCmd = ""
      for i = 2, #arr do
        shortcutCmd = shortcutCmd .. arr[i]
        if i ~= #arr then
          shortcutCmd = shortcutCmd .. " "
        end
      end
      self.input:SetText(shortcutCmd)
      self:TryExecute()
    end)
  end
end

function UILWDevConsoleView:Print2Output(content)
  self.output:SetText(content)
end

function UILWDevConsoleView:TryExecute()
  self.historyIdx = 0
  local cmdStr = self.input:GetText()
  if not string.IsNullOrEmpty(string.trim(cmdStr)) then
    local idx = table.indexof(self.historyBuffer, cmdStr)
    if idx then
      table.remove(self.historyBuffer, idx)
    end
    table.insert(self.historyBuffer, 1, cmdStr)
    DataCenter.LWDevConsoleManager:SaveHistory(self.historyBuffer)
    self.ctrl:ExecuteCommand(cmdStr)
  end
end

function UILWDevConsoleView:HistoryUp()
  if #self.historyBuffer <= self.historyIdx then
    return
  end
  if self.historyIdx == 0 then
    self.tempInput = self.input:GetText()
  end
  self.historyIdx = self.historyIdx + 1
  self.input:SetOnValueChange(nil)
  self.input:SetText(self.historyBuffer[self.historyIdx])
  self.input:SetOnValueChange(function()
    self.historyIdx = 0
  end)
end

function UILWDevConsoleView:HistoryDown()
  if self.historyIdx <= 0 then
    return
  end
  if self.historyIdx == 1 then
    self.input:SetText(self.tempInput)
    self.historyIdx = 0
    return
  end
  self.historyIdx = self.historyIdx - 1
  self.input:SetOnValueChange(nil)
  self.input:SetText(self.historyBuffer[self.historyIdx])
  self.input:SetOnValueChange(function()
    self.historyIdx = 0
  end)
end

function UILWDevConsoleView:UnfoldHelp()
  if self.tweenHelp ~= nil then
    self.tweenHelp:Kill()
  end
  self.tweenHelp = CS.DG.Tweening.DOTween.To(function()
    return self.panel_help.transform.offsetMin.x
  end, function(x)
    self.panel_help.transform.offsetMin = Vector2(x, 0)
    self.panel_help.transform.offsetMax = Vector2(x, 0)
  end, 0, 0.5):SetEase(CS.DG.Tweening.Ease.OutQuart)
  self.helpOn = true
  if self.helpCmdIdx == nil then
    self.helpCmdIdx = 1
    self:ShowHelp()
  end
end

function UILWDevConsoleView:FoldHelp()
  if self.tweenHelp ~= nil then
    self.tweenHelp:Kill()
  end
  self.tweenHelp = CS.DG.Tweening.DOTween.To(function()
    return self.panel_help.transform.offsetMin.x
  end, function(x)
    self.panel_help.transform.offsetMin = Vector2(x, 0)
    self.panel_help.transform.offsetMax = Vector2(x, 0)
  end, Screen.width, 0.5):SetEase(CS.DG.Tweening.Ease.OutQuart)
  self.helpOn = false
end

function UILWDevConsoleView:ShowHelp()
  local cmd = require("UI.UILWDevConsole.Cmd." .. COMMANDS_WITH_HELP[self.helpCmdIdx])
  self.txt_help:SetText(cmd.Help())
end

function UILWDevConsoleView:UnfoldShortcut()
  if self.tweenShortcut ~= nil then
    self.tweenShortcut:Kill()
  end
  self.tweenShortcut = CS.DG.Tweening.DOTween.To(function()
    return self.panel_shortcut.transform.offsetMin.y
  end, function(y)
    self.panel_shortcut.transform.offsetMin = Vector2(0, y)
    self.panel_shortcut.transform.offsetMax = Vector2(0, y)
  end, 0, 0.5):SetEase(CS.DG.Tweening.Ease.OutQuart)
  self.shortcutOn = true
  if self.helpCmdIdx == nil then
    self.helpCmdIdx = 1
    self:ShowHelp()
  end
end

function UILWDevConsoleView:FoldShortcut()
  if self.tweenShortcut ~= nil then
    self.tweenShortcut:Kill()
  end
  self.tweenShortcut = CS.DG.Tweening.DOTween.To(function()
    return self.panel_shortcut.transform.offsetMin.y
  end, function(y)
    self.panel_shortcut.transform.offsetMin = Vector2(0, y)
    self.panel_shortcut.transform.offsetMax = Vector2(0, y)
  end, -Screen.height * self.panel_shortcut:GetAnchorMax().y, 0.5):SetEase(CS.DG.Tweening.Ease.OutQuart)
  self.shortcutOn = false
end

return UILWDevConsoleView
