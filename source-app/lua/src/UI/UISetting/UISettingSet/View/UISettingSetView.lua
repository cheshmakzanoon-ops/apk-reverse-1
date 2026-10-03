local UISettingSetView = BaseClass("UISettingSetView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local UISettingSetSound = require("UI.UISetting.UISettingSet.Component.UISettingSetSound")
local UISettingSetChat = require("UI.UISetting.UISettingSet.Component.UISettingSetChat")
local UISettingSetPower = require("UI.UISetting.UISettingSet.Component.UISettingSetPower")
local UISettingSetPrompt = require("UI.UISetting.UISettingSet.Component.UISettingSetPrompt")
local UISettingSetGame = require("UI.UISetting.UISettingSet.Component.UISettingSetGame")
local UISettingSetPerformance = require("UI.UISetting.UISettingSet.Component.UISettingSetPerformance")
local UISettingSetClear = require("UI.UISetting.UISettingSet.Component.UISettingSetClear")
local UISettingSetDeleteAccount = require("UI.UISetting.UISettingSet.Component.UISettingSetDeleteAccount")
local UISettingSetFullScreen = require("UI.UISetting.UISettingSet.Component.UISettingSetFullScreen")
local txt_title_path = "UICommonPopUpTitle/Common_img_title/titleText"
local close_btn_path = "UICommonPopUpTitle/CloseBtn"
local return_btn_path = "UICommonPopUpTitle/panel"
local sound_go_path = "ImgBg/Scroll View/Viewport/Content/SoundGo"
local chat_go_path = "ImgBg/Scroll View/Viewport/Content/ChatGo"
local power_go_path = "ImgBg/Scroll View/Viewport/Content/PowerGo"
local prompt_go_path = "ImgBg/Scroll View/Viewport/Content/PromptGo"
local game_set_go_path = "ImgBg/Scroll View/Viewport/Content/GameSetGo"
local performance_go_path = "ImgBg/Scroll View/Viewport/Content/PerformanceGo"
local clear_go_path = "ImgBg/Scroll View/Viewport/Content/ClearGo"
local delete_account_go_path = "ImgBg/Scroll View/Viewport/Content/DeleteAccountGo"
local full_screen_go_path = "ImgBg/Scroll View/Viewport/Content/FullScreenGo"
local setting_go_path = "CellGo/SettingGo"
local setting_go_slider_path = "CellGo/SettingGoSlider"
local setting_btn_path = "CellGo/SettingBtnGo"
local setting_input_path = "CellGo/SettingInputGo"

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
  self.power_go = self:AddComponent(UISettingSetPower, power_go_path)
  self.sound_go = self:AddComponent(UISettingSetSound, sound_go_path)
  self.chat_go = self:AddComponent(UISettingSetChat, chat_go_path)
  self.prompt_go = self:AddComponent(UISettingSetPrompt, prompt_go_path)
  self.game_set_go = self:AddComponent(UISettingSetGame, game_set_go_path)
  self.clear_go = self:AddComponent(UISettingSetClear, clear_go_path)
  self.delete_account_go = self:AddComponent(UISettingSetDeleteAccount, delete_account_go_path)
  self.performance_go = self:AddComponent(UISettingSetPerformance, performance_go_path)
  self.full_screen_go = self:AddComponent(UISettingSetFullScreen, full_screen_go_path)
  self.setting_go = self:AddComponent(UIBaseContainer, setting_go_path).gameObject
  self.setting_go_slider = self:AddComponent(UIBaseContainer, setting_go_slider_path).gameObject
  self.setting_btn = self:AddComponent(UIBaseContainer, setting_btn_path).gameObject
  self.setting_input = self:AddComponent(UIBaseContainer, setting_input_path).gameObject
  self.setting_go:GameObjectCreatePool()
  self.setting_btn:GameObjectCreatePool()
  self.setting_input:GameObjectCreatePool()
  self.setting_go_slider:GameObjectCreatePool()
end

local function ComponentDestroy(self)
  self.txt_title = nil
  self.close_btn = nil
  self.return_btn = nil
  self.power_go = nil
  self.sound_go = nil
  self.chat_go = nil
  self.prompt_go = nil
  self.game_set_go = nil
  self.clear_go = nil
  self.delete_account_go = nil
  self.performance_go = nil
  self.setting_go = nil
  self.setting_go_slider = nil
  self.setting_btn = nil
  self.setting_input = nil
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
  self.txt_title:SetLocalText(280012)
  self.power_go:ReInit({
    cell = self.setting_go
  })
  self.sound_go:ReInit({
    cell = self.setting_go
  })
  self.chat_go:ReInit({
    cell = self.setting_go
  })
  self.prompt_go:ReInit({
    cell = self.setting_go
  })
  self.game_set_go:ReInit({
    cell = self.setting_go
  })
  self.performance_go:ReInit({
    cell = self.setting_go,
    cell1 = self.setting_go_slider,
    cell2 = self.setting_btn
  })
  self.clear_go:ReInit({
    cell = self.setting_btn
  })
  self.delete_account_go:ReInit({
    cell = self.setting_btn
  })
  if Config.IsPC() then
    self.full_screen_go:SetActive(true)
    self.full_screen_go:ReInit({
      cell = self.setting_go
    })
  else
    self.full_screen_go:SetActive(false)
  end
  self.power_go:SetActive(true)
  self.sound_go:SetActive(true)
  self.chat_go:SetActive(true)
  self.performance_go:SetActive(true)
  if CS.SceneManager.IsInPVE() then
    self.prompt_go:SetActive(false)
    self.clear_go:SetActive(false)
    self.delete_account_go:SetActive(false)
  else
    self.prompt_go:SetActive(true)
    self.clear_go:SetActive(true)
    local delAllAcctFuncOn = LuaEntry.DataConfig:CheckSwitch("account_del")
    self.delete_account_go:SetActive(delAllAcctFuncOn)
  end
  self.game_set_go:RefreshShow()
end

local function SetAllCellsDestroy(self)
  self.setting_go:GameObjectRecycleAll()
  self.setting_btn:GameObjectRecycleAll()
  self.setting_input:GameObjectRecycleAll()
  self.setting_go_slider:GameObjectRecycleAll()
end

local function OnAddListener(self)
  base.OnAddListener(self)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
end

UISettingSetView.OnCreate = OnCreate
UISettingSetView.OnDestroy = OnDestroy
UISettingSetView.OnEnable = OnEnable
UISettingSetView.OnDisable = OnDisable
UISettingSetView.OnAddListener = OnAddListener
UISettingSetView.OnRemoveListener = OnRemoveListener
UISettingSetView.ComponentDefine = ComponentDefine
UISettingSetView.ComponentDestroy = ComponentDestroy
UISettingSetView.DataDefine = DataDefine
UISettingSetView.DataDestroy = DataDestroy
UISettingSetView.ReInit = ReInit
UISettingSetView.SetAllCellsDestroy = SetAllCellsDestroy
return UISettingSetView
