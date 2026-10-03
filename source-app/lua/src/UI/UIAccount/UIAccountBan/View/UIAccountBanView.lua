local UIAccountBanView = BaseClass("UIAccountBanView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local Setting = CS.GameEntry.Setting
local title_path = "UICommonPopUpTitle/Common_img_title/titleText"
local name_text_path = "ImgBg/NameText"
local name_value_path = "ImgBg/NameText/NameValue"
local copy_btn_path = "ImgBg/NameText/NameValue/CopyBtn"
local server_text_path = "ImgBg/ServerText"
local server_value_path = "ImgBg/ServerText/ServerValue"
local ban_time_text_path = "ImgBg/BanTimeText"
local ban_time_value_path = "ImgBg/BanTimeText/BanTimeValue"
local ban_reason_text_path = "ImgBg/BanReasonText"
local ban_reason_value_path = "ImgBg/BanReasonText/BanReasonValue"
local exit_btn_path = "ImgBg/ExitBtn"
local exit_btn_name_path = "ImgBg/ExitBtn/ExitBtnName"
local new_game_btn_path = "ImgBg/NewGameBtn"
local new_game_btn_name_path = "ImgBg/NewGameBtn/NewGameBtnName"
local call_btn_path = "ImgBg/CallBtn"
local call_btn_name_path = "ImgBg/CallBtn/CallBtnName"
local switch_account_btn_path = "ImgBg/SwitchAccountBtn"
local switch_account_btn_name_path = "ImgBg/SwitchAccountBtn/SwitchAccountBtnName"
local AllTimeBan = "9223372036854775806"

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:ReInit()
end

local function OnDestroy(self)
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

local function ComponentDefine(self)
  self.title = self:AddComponent(UIText, title_path)
  self.name_text = self:AddComponent(UIText, name_text_path)
  self.name_value = self:AddComponent(UIText, name_value_path)
  self.copy_btn = self:AddComponent(UIButton, copy_btn_path)
  self.server_text = self:AddComponent(UIText, server_text_path)
  self.server_value = self:AddComponent(UIText, server_value_path)
  self.ban_time_text = self:AddComponent(UIText, ban_time_text_path)
  self.ban_time_value = self:AddComponent(UIText, ban_time_value_path)
  self.ban_reason_text = self:AddComponent(UIText, ban_reason_text_path)
  self.ban_reason_value = self:AddComponent(UIText, ban_reason_value_path)
  self.exit_btn = self:AddComponent(UIButton, exit_btn_path)
  self.exit_btn_name = self:AddComponent(UIText, exit_btn_name_path)
  self.new_game_btn = self:AddComponent(UIButton, new_game_btn_path)
  self.new_game_btn_name = self:AddComponent(UIText, new_game_btn_name_path)
  self.call_btn = self:AddComponent(UIButton, call_btn_path)
  self.call_btn_name = self:AddComponent(UIText, call_btn_name_path)
  self.switch_account_btn = self:AddComponent(UIButton, switch_account_btn_path)
  self.switch_account_btn_name = self:AddComponent(UIText, switch_account_btn_name_path)
  self.exit_btn:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self:OnExitBtnClick()
  end)
  self.new_game_btn:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self:OnNewGameBtnClick()
  end)
  self.call_btn:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self:OnCallBtnClick()
  end)
  self.copy_btn:SetOnClick(function()
    self:OnCopyBtnClick()
  end)
  self.switch_account_btn:SetOnClick(function()
    self:OnSwitchAccountBtnClick()
  end)
end

local function ComponentDestroy(self)
  self.title = nil
  self.name_text = nil
  self.name_value = nil
  self.copy_btn = nil
  self.server_text = nil
  self.server_value = nil
  self.ban_time_text = nil
  self.ban_time_value = nil
  self.ban_reason_text = nil
  self.ban_reason_value = nil
  self.exit_btn = nil
  self.exit_btn_name = nil
  self.new_game_btn = nil
  self.new_game_btn_name = nil
  self.call_btn = nil
  self.call_btn_name = nil
  self.switch_account_btn = nil
  self.switch_account_btn_name = nil
end

local function DataDefine(self)
  self.state = nil
end

local function DataDestroy(self)
  self.state = nil
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local reasonLocalName = {
  [705] = "operate_notice_10004",
  [727] = "operate_notice_10002",
  [706] = "operate_notice_10003",
  [602] = "operate_notice_10005"
}

local function ShumeiCreateAccountRiskUpdate(self)
  self.contactType = 2
  if LuaEntry and LuaEntry.Player then
    self.name_value:SetText(LuaEntry.Player:GetName())
  end
  local zoneName = CS.AccountCredentialManager.ServerInfo.zone
  if string.len(zoneName) > 3 then
    zoneName = string.sub(zoneName, 3)
  end
  self.server_value:SetText(zoneName)
  self.ban_time_value:SetLocalText(280098)
  self.ban_reason_text:SetLocalText("error_notice_001")
  self.title:SetLocalText(120069)
  self.name_text:SetLocalText(208186)
  self.server_text:SetLocalText(280060)
  self.exit_btn_name:SetLocalText(110043)
  self.call_btn_name:SetLocalText(280014)
  self.switch_account_btn_name:SetLocalText(280050)
  self.ban_time_text:SetLocalText(100242)
  self.new_game_btn:SetActive(false)
  self.switch_account_btn:SetActive(true)
  local level = self.param or 1
  if level == 2 then
    self.contactType = 3
    self.title:SetLocalText("error_notice_title_001")
    self.ban_time_text:SetText("")
    self.ban_time_value:SetText("")
  end
end

local function ReasonStrUpdate(self)
  if self.param == nil then
    return
  end
  local spl = string.split(self.param, ";")
  local splCount = #spl
  if 4 <= splCount then
    if 4 < splCount then
      self.name_value:SetText(spl[5])
      local reasonName = Localization:GetString(reasonLocalName[tonumber(spl[4])] or reasonLocalName[705])
      self.ban_reason_text:SetLocalText("operate_notice_10001", reasonName)
    elseif spl[3] == "--" then
      self.name_value:SetText(spl[3])
    else
      self.name_value:SetText(spl[4])
    end
    if spl[2] == AllTimeBan then
      self.ban_time_value:SetLocalText(280098)
    else
      local timeCode = tonumber(spl[2])
      if timeCode < 0 then
        self.ban_time_value:SetLocalText(280098)
      else
        self.ban_time_value:SetText(UITimeManager:GetInstance():TimeStampToTimeForLocal(timeCode * 1000 * 10000 / 10000000))
      end
    end
    local zoneName = CS.AccountCredentialManager.ServerInfo.zone
    if 3 < string.len(zoneName) then
      zoneName = string.sub(zoneName, 3)
    end
    self.server_value:SetText(zoneName)
  end
  self.title:SetLocalText(120069)
  self.name_text:SetLocalText(208186)
  self.server_text:SetLocalText(280060)
  self.exit_btn_name:SetLocalText(110043)
  self.new_game_btn_name:SetLocalText(280045)
  self.call_btn_name:SetLocalText(280014)
  self.ban_time_text:SetLocalText(100242)
  self.new_game_btn:SetActive(true)
  self.switch_account_btn:SetActive(false)
  if 4 < splCount and spl[4] and tonumber(spl[4]) == 602 then
    self.title:SetLocalText("user_delete_notice_title")
    self.ban_reason_text:SetLocalText("user_delete_notice_content")
    self.ban_time_text:SetText("")
    self.ban_time_value:SetText("")
  end
end

local function ReInit(self)
  self.param, self.showType = self:GetUserData()
  if self.showType == nil then
    self.showType = AccountBanViewShowType.DefaultReasonStr
  end
  if self.showType == AccountBanViewShowType.DefaultReasonStr then
    self.contactType = 1
    self:ReasonStrUpdate()
  elseif self.showType == AccountBanViewShowType.ShumeiCreateAccountRisk then
    self:ShumeiCreateAccountRiskUpdate()
  end
end

local function OnExitBtnClick(self)
  CS.ApplicationLaunch.Instance:Quit()
  self.ctrl:CloseSelf()
end

local function OnCallBtnClick(self)
  if self == nil or self.contactType == nil then
    CS.AIHelp.AIHelpProxy.Show("E001", Localization:GetString("2700006"))
    return
  end
  if self.contactType == 1 then
    CS.AIHelp.AIHelpProxy.Show("E001", Localization:GetString("2700006"))
  elseif self.contactType == 2 then
    CS.AIHelp.AIHelpProxy.Show("E021", Localization:GetString("2700006"))
  elseif self.contactType == 3 then
    CS.AIHelp.AIHelpProxy.Show("E022", Localization:GetString("2700006"))
  end
end

local function OnNewGameBtnClick(self)
  self:ResetData()
  self.ctrl:CloseSelf()
end

local function ResetData(self)
  Logger.LogInfo("[AT]ClearGUID&NetUid_AccountBanReset")
  CS.AccountCredentialManager.ClearAll()
  CS.ApplicationLaunch.Instance:ReloadGame()
end

local function OnCopyBtnClick(self)
  CommonUtil.CopyTextToClipboard(self.name_value:GetText())
end

local function OnSwitchAccountBtnClick(self)
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIChooseSwitchAccount, 110008)
end

UIAccountBanView.OnCreate = OnCreate
UIAccountBanView.OnDestroy = OnDestroy
UIAccountBanView.OnEnable = OnEnable
UIAccountBanView.OnDisable = OnDisable
UIAccountBanView.ComponentDefine = ComponentDefine
UIAccountBanView.ComponentDestroy = ComponentDestroy
UIAccountBanView.DataDefine = DataDefine
UIAccountBanView.DataDestroy = DataDestroy
UIAccountBanView.ReInit = ReInit
UIAccountBanView.OnCopyBtnClick = OnCopyBtnClick
UIAccountBanView.OnCallBtnClick = OnCallBtnClick
UIAccountBanView.OnExitBtnClick = OnExitBtnClick
UIAccountBanView.OnNewGameBtnClick = OnNewGameBtnClick
UIAccountBanView.ResetData = ResetData
UIAccountBanView.ReasonStrUpdate = ReasonStrUpdate
UIAccountBanView.OnSwitchAccountBtnClick = OnSwitchAccountBtnClick
UIAccountBanView.ShumeiCreateAccountRiskUpdate = ShumeiCreateAccountRiskUpdate
return UIAccountBanView
