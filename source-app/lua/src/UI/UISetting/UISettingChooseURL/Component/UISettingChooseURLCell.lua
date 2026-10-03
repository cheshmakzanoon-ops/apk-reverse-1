local UISettingChooseURLCell = BaseClass("UISettingChooseURLCell", UIBaseContainer)
local base = UIBaseContainer
local Setting = CS.GameEntry.Setting
local Param = DataClass("Param", ParamData)
local ParamData = {
  setType
}
local push_name_path = "PushName"
local toggle_path = "Toggle"

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

local function OnDestroy(self)
  self.toggle:SetIsOn(false)
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function ComponentDefine(self)
  self.push_name = self:AddComponent(UIText, push_name_path)
  self.toggle = self:AddComponent(UIToggle, toggle_path)
end

local function ComponentDestroy(self)
  self.push_name = nil
  self.toggle = nil
end

local function DataDefine(self)
  self.param = {}
end

local function DataDestroy(self)
  self.param = nil
end

local function ReInit(self, param)
  self.param = param
  self:SetName()
  local groupAsInt = CS.System.Convert.ToInt32(self.param.group)
  if self.param.curGroup == groupAsInt then
    self.toggle:SetIsOn(true)
  end
  self.toggle:SetOnValueChanged(function(tf)
    if tf then
      self:OnSelect()
    end
  end)
  self.toggle:SetInteractable(self.param.curGroup ~= groupAsInt)
end

local function SetName(self)
  self.push_name:SetText(self.param.name)
end

local function OnSelect(self)
  UIUtil.ShowMessage("\230\155\180\230\141\162\231\186\191\232\183\175\228\185\139\229\144\142\233\156\128\232\166\129\233\135\141\229\144\175", 1, GameDialogDefine.CONFIRM, GameDialogDefine.CANCEL, function()
    local enumName = CS.System.Enum.GetName(typeof(CS.URLGroupType), self.param.group)
    CS.NetworkURLConfig.SetURLGroupEnv(enumName)
    CS.NetworkURLConfig.IsChangeDebugURLGroup = true
    CS.ApplicationLaunch.Instance:ReloadGame()
  end, nil, function()
    self.view:ShowCells()
  end)
end

UISettingChooseURLCell.OnCreate = OnCreate
UISettingChooseURLCell.OnDestroy = OnDestroy
UISettingChooseURLCell.Param = Param
UISettingChooseURLCell.OnEnable = OnEnable
UISettingChooseURLCell.OnDisable = OnDisable
UISettingChooseURLCell.ComponentDefine = ComponentDefine
UISettingChooseURLCell.ComponentDestroy = ComponentDestroy
UISettingChooseURLCell.DataDefine = DataDefine
UISettingChooseURLCell.DataDestroy = DataDestroy
UISettingChooseURLCell.ReInit = ReInit
UISettingChooseURLCell.OnSelect = OnSelect
UISettingChooseURLCell.SetName = SetName
return UISettingChooseURLCell
