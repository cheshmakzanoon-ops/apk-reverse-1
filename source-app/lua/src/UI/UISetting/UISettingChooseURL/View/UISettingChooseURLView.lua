local UISettingChooseURLView = BaseClass("UISettingChooseURLView", UIBaseView)
local base = UIBaseView
local Setting = CS.GameEntry.Setting
local UISettingChooseURLCell = require("UI.UISetting.UISettingChooseURL.Component.UISettingChooseURLCell")
local Localization = CS.GameEntry.Localization
local URLGroupType = CS.URLGroupType
local txt_title_path = "UICommonPopUpTitle/Common_img_title/titleText"
local close_btn_path = "UICommonPopUpTitle/CloseBtn"
local return_btn_path = "UICommonPopUpTitle/panel"
local title_name_path = "ImgBg/Scroll View/Viewport/Content/TitleBg/TitleName"
local performance_go_path = "ImgBg/Scroll View/Viewport/Content"
local setting_go_path = "SettingGo"
local URLGroupTypeName = {
  [URLGroupType.Online] = "\231\190\142\228\184\156\231\186\191\228\184\138",
  [URLGroupType.PressureTest] = "\229\142\139\230\181\139",
  [URLGroupType.Vietnam] = "\232\182\138\229\141\151\230\181\139\232\175\149",
  [URLGroupType.GCP] = "GCP\230\181\139\232\175\149",
  [URLGroupType.Local] = "\229\134\133\231\189\145",
  [URLGroupType.AWS] = "AWS\230\181\139\232\175\149"
}

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:ReInit()
end

local function OnDestroy(self)
  self:SetAllCellsDestroy()
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

local function ComponentDefine(self)
  self.txt_title = self:AddComponent(UIText, txt_title_path)
  self.close_btn = self:AddComponent(UIButton, close_btn_path)
  self.return_btn = self:AddComponent(UIButton, return_btn_path)
  self.close_btn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.return_btn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.performance_go = self:AddComponent(UIBaseContainer, performance_go_path)
  self.title_name = self:AddComponent(UIText, title_name_path)
  self.setting_go = self:AddComponent(UIBaseContainer, setting_go_path).gameObject
  self.setting_go:GameObjectCreatePool()
end

local function ComponentDestroy(self)
  self.txt_title = nil
  self.close_btn = nil
  self.return_btn = nil
  self.performance_go = nil
  self.setting_go = nil
end

local function DataDefine(self)
end

local function DataDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function ReInit(self)
  self.txt_title:SetText("\232\135\170\233\128\137\231\186\191\232\183\175")
  self:ShowCells()
end

local function ShowCells(self)
  self:SetAllCellsDestroy()
  local enumValues = CS.System.Enum.GetValues(typeof(CS.URLGroupType))
  for i = 0, enumValues.Length - 1 do
    self:AddOneCell(enumValues[i])
  end
end

local function AddOneCell(self, setType)
  local numberGroupType = CS.System.Convert.ToInt32(setType)
  local temp = self.setting_go:GameObjectSpawn(self.performance_go.transform)
  temp.name = tostring(numberGroupType)
  local cell = self:AddComponent(UISettingChooseURLCell, performance_go_path .. "/" .. temp.name)
  local param = {}
  param.name = URLGroupTypeName[setType]
  param.group = setType
  local defaultValue = CS.System.Convert.ToInt32(URLGroupType.Local)
  local curGroup = Setting:GetInt(SettingKeys.DEBUG_CHOOSE_URL_GROUP, defaultValue)
  param.curGroup = curGroup
  temp:SetActive(true)
  cell:ReInit(param)
end

local function SetAllCellsDestroy(self)
  self:RemoveComponents(UISettingChooseURLCell)
  self.setting_go:GameObjectRecycleAll()
end

local function OnAddListener(self)
  base.OnAddListener(self)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
end

UISettingChooseURLView.OnCreate = OnCreate
UISettingChooseURLView.OnDestroy = OnDestroy
UISettingChooseURLView.OnEnable = OnEnable
UISettingChooseURLView.OnDisable = OnDisable
UISettingChooseURLView.OnAddListener = OnAddListener
UISettingChooseURLView.OnRemoveListener = OnRemoveListener
UISettingChooseURLView.ComponentDefine = ComponentDefine
UISettingChooseURLView.ComponentDestroy = ComponentDestroy
UISettingChooseURLView.DataDefine = DataDefine
UISettingChooseURLView.DataDestroy = DataDestroy
UISettingChooseURLView.ReInit = ReInit
UISettingChooseURLView.SetAllCellsDestroy = SetAllCellsDestroy
UISettingChooseURLView.ShowCells = ShowCells
UISettingChooseURLView.AddOneCell = AddOneCell
return UISettingChooseURLView
