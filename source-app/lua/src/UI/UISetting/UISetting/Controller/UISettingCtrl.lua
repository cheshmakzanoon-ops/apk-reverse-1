local UISettingCtrl = BaseClass("UISettingCtrl", UIBaseCtrl)
local Localization = CS.GameEntry.Localization

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UISetting)
end

local function CloseAll(self)
  UIManager.Instance:DestroyWindow(UIWindowNames.UISetting)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UILWPlayerDetail)
end

local function Close(self)
  UIManager:GetInstance():DestroyWindowByLayer(UILayer.Normal)
end

local function GetSettingSort()
  local lanage = Localization:GetLanguage()
  local settings = {}
  table.insert(settings, SettingType.Setting)
  table.insert(settings, SettingType.Language)
  table.insert(settings, SettingType.CopyAccount)
  if lanage ~= Language.Japanese then
    table.insert(settings, SettingType.AIHelp)
  elseif ChatInterface.GetMomentIsOpen() then
    table.insert(settings, SettingType.Attention)
  end
  table.insert(settings, SettingType.PlayerNation)
  table.insert(settings, SettingType.push)
  table.insert(settings, SettingType.Ban)
  table.insert(settings, SettingType.NewGame)
  table.insert(settings, SettingType.Voice)
  table.insert(settings, SettingType.DeleteAccount)
  table.insert(settings, SettingType.PrivacyAgreement)
  table.insert(settings, SettingType.UserAgreement)
  table.insert(settings, SettingType.AutoMarch)
  table.insert(settings, SettingType.RemarkNameList)
  if GMUtils.IsGM() then
    table.insert(settings, SettingType.DebugChooseURL)
    table.insert(settings, SettingType.GMPanel)
  end
  local openLv = LuaEntry.DataConfig:TryGetNum("undo_system", "k2")
  local mainLv = DataCenter.BuildManager.MainLv
  local isFunctionOn = LuaEntry.DataConfig:CheckSwitch("undo_system_switch")
  if openLv <= mainLv and isFunctionOn then
    table.insert(settings, SettingType.ItemRevert)
  end
  local isOn = DataCenter.PlayerDownloadCenterManager:IsDownloadCenterFunctionOn()
  if isOn then
    table.insert(settings, SettingType.DownloadCenter)
  end
  return settings
end

UISettingCtrl.CloseSelf = CloseSelf
UISettingCtrl.Close = Close
UISettingCtrl.CloseAll = CloseAll
UISettingCtrl.GetSettingSort = GetSettingSort
return UISettingCtrl
