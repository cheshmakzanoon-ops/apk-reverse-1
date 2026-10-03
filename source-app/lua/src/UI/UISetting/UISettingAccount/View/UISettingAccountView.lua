local UISettingAccountView = BaseClass("UISettingAccountView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local txt_title_path = "UICommonPopUpTitle/Common_img_title/titleText"
local close_btn_path = "UICommonPopUpTitle/CloseBtn"
local return_btn_path = "UICommonPopUpTitle/panel"
local player_head_path = "ImgBg/PlayerGo/HeadImg"
local player_name_path = "ImgBg/PlayerGo/PlayerName"
local player_base_path = "ImgBg/PlayerGo/PlayerBase"
local player_state_path = "ImgBg/PlayerGo/BandStateText"
local band_btn_path = "ImgBg/BandBtn"
local band_btn_name_path = "ImgBg/BandBtn/BandBtnName"
local change_account_btn_path = "ImgBg/ChangeAccountBtn"
local change_account_btn_name_path = "ImgBg/ChangeAccountBtn/ChangeAccountBtnName"
local new_game_btn_path = "ImgBg/NewGameBtn"
local new_game_btn_name_path = "ImgBg/NewGameBtn/NewGameBtnName"
local first_text_path = "ImgBg/FirstText"
local find_text_path = "ImgBg/RetrievingBtn/RetrievingBtnName"

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
  self.txt_title = self:AddComponent(UIText, txt_title_path)
  self.close_btn = self:AddComponent(UIButton, close_btn_path)
  self.return_btn = self:AddComponent(UIButton, return_btn_path)
  self.player_head = self:AddComponent(UIImage, player_head_path)
  self.player_name = self:AddComponent(UIText, player_name_path)
  self.player_base = self:AddComponent(UIText, player_base_path)
  self.player_state = self:AddComponent(UIText, player_state_path)
  self.band_btn = self:AddComponent(UIButton, band_btn_path)
  self.band_btn_name = self:AddComponent(UIText, band_btn_name_path)
  self.change_account_btn = self:AddComponent(UIButton, change_account_btn_path)
  self.change_account_btn_name = self:AddComponent(UIText, change_account_btn_name_path)
  self.new_game_btn = self:AddComponent(UIButton, new_game_btn_path)
  self.new_game_btn_name = self:AddComponent(UIText, new_game_btn_name_path)
  self.first_text = self:AddComponent(UIText, first_text_path)
  self.find_text = self:AddComponent(UIText, find_text_path)
  self.close_btn:SetOnClick(function()
    self.ctrl:CloseAll()
  end)
  self.return_btn:SetOnClick(function()
    self.ctrl:CloseAll()
  end)
  self.band_btn:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self:OnBandBtnClick()
  end)
  self.change_account_btn:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self:OnChangeAccountBtnClick()
  end)
  self.new_game_btn:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self:OnNewGameBtnClick()
  end)
end

local function ComponentDestroy(self)
  self.txt_title = nil
  self.close_btn = nil
  self.return_btn = nil
  self.player_head = nil
  self.player_name = nil
  self.player_base = nil
  self.player_state = nil
  self.band_btn = nil
  self.band_btn_name = nil
  self.change_account_btn = nil
  self.change_account_btn_name = nil
  self.new_game_btn = nil
  self.new_game_btn_name = nil
  self.first_text = nil
  self.find_text = nil
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
  self.txt_title:SetLocalText(280039)
  self.band_btn_name:SetLocalText(280041)
  self.change_account_btn_name:SetLocalText(280050)
  self.new_game_btn_name:SetLocalText(100243)
  self.find_text:SetLocalText(110047)
  self.first_text:SetLocalText(280160)
  self:SetState()
  local Player = LuaEntry.Player
  self.player_name:SetText(string.format("%s(%s)", Player.name, Localization:GetString("100217", Player:GetSelfServerId())))
  self.player_base:SetLocalText(280036, Player.level)
  self.player_head:LoadSprite("Assets/Main/Sprites/UI/LWCommon/Sprite/Common_icon_player_head_big.png" .. Player.pic)
end

local function OnAddListener(self)
  base.OnAddListener(self)
  self:AddUIListener(EventId.AccountBindOKEvent, self.AccountBindOKEventSignal)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
  self:RemoveUIListener(EventId.AccountBindOKEvent, self.AccountBindOKEventSignal)
end

local function OnBandBtnClick(self)
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIBindAccount, {anim = true, hideTop = true}, AccountBindType.Bind)
end

local function OnChangeAccountBtnClick(self)
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIBindAccount, {anim = true, hideTop = true}, AccountBindType.Change)
end

local function OnNewGameBtnClick(self)
  if self.state == AccountBandState.Band then
    UIUtil.ShowMessage(Localization:GetString("280095"), 1, GameDialogDefine.CONFIRM, GameDialogDefine.CANCEL, function()
      SFSNetwork.SendMessage(MsgDefines.NewAccount, {confirm = 2})
      self.ctrl:CloseSelf()
    end)
  elseif self.state == AccountBandState.UnCheck then
    UIUtil.ShowMessage(Localization:GetString("280096"), 1, GameDialogDefine.CONFIRM, GameDialogDefine.CANCEL, function()
      SFSNetwork.SendMessage(MsgDefines.NewAccount, {confirm = 2})
      self.ctrl:CloseSelf()
    end)
  elseif self.state == AccountBandState.UnBand then
    if not CS.GameEntry.GlobalData.statNewGame then
      UIUtil.ShowMessage(Localization:GetString("280096"), 1, GameDialogDefine.CONFIRM, GameDialogDefine.CANCEL, function()
        SFSNetwork.SendMessage(MsgDefines.NewAccount, {confirm = 2})
        self.ctrl:CloseSelf()
      end)
    else
      UIUtil.ShowMessage(Localization:GetString("280067"), 1, "106012")
    end
  end
end

local function SetState(self)
  self.state = self.ctrl:GetAccountBindState()
  self.player_state:SetText(self.ctrl:GetAccountBindStateName())
end

local function AccountBindOKEventSignal(self)
  self:SetState()
end

UISettingAccountView.OnCreate = OnCreate
UISettingAccountView.OnDestroy = OnDestroy
UISettingAccountView.OnEnable = OnEnable
UISettingAccountView.OnDisable = OnDisable
UISettingAccountView.OnAddListener = OnAddListener
UISettingAccountView.OnRemoveListener = OnRemoveListener
UISettingAccountView.ComponentDefine = ComponentDefine
UISettingAccountView.ComponentDestroy = ComponentDestroy
UISettingAccountView.DataDefine = DataDefine
UISettingAccountView.DataDestroy = DataDestroy
UISettingAccountView.ReInit = ReInit
UISettingAccountView.OnBandBtnClick = OnBandBtnClick
UISettingAccountView.SetState = SetState
UISettingAccountView.AccountBindOKEventSignal = AccountBindOKEventSignal
UISettingAccountView.OnChangeAccountBtnClick = OnChangeAccountBtnClick
UISettingAccountView.OnNewGameBtnClick = OnNewGameBtnClick
return UISettingAccountView
