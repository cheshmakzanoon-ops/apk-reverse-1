local UIPinInputView = BaseClass("UIPinInputView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local return_btn_path = "ReturnGo"
local des_text_path = "ReturnGo/TxtDesc"
local title_name_path = "Input/TitleName"
local txt_name_path = "Input/TxtName"
local select_path = "Input/Align/PIN%s/PINMark%s"
local forget_btn_path = "Input/Btn/BtnForget"
local forget_btn_name_path = "Input/Btn/BtnForget/BtnForgetText"
local new_game_btn_path = "Input/Btn/BtnNewGame"
local new_game_btn_name_path = "Input/Btn/BtnNewGame/BtnNewGameText"
local btn_group_path = "Input/ImgBottom/Row%s/Button%s"
local btn_name_group_path = "Input/ImgBottom/Row%s/Button%s/ButtonName%s"
local back_btn_path = "Input/ImgBottom/Row4/ButtonBack"
local back_btn_name_path = "Input/ImgBottom/Row4/ButtonBack/ButtonNameBack"
local zero_btn_path = "Input/ImgBottom/Row4/Button0"
local zero_btn_name_path = "Input/ImgBottom/Row4/Button0/ButtonName0"
local maxNum = 6

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
  self.des_text = self:AddComponent(UIText, des_text_path)
  self.title_name = self:AddComponent(UIText, title_name_path)
  self.return_btn = self:AddComponent(UIButton, return_btn_path)
  self.txt_name = self:AddComponent(UIText, txt_name_path)
  self.forget_btn = self:AddComponent(UIButton, forget_btn_path)
  self.forget_btn_name = self:AddComponent(UIText, forget_btn_name_path)
  self.new_game_btn = self:AddComponent(UIButton, new_game_btn_path)
  self.new_game_btn_name = self:AddComponent(UIText, new_game_btn_name_path)
  self.back_btn = self:AddComponent(UIButton, back_btn_path)
  self.back_btn_name = self:AddComponent(UIText, back_btn_name_path)
  self.select_group = {}
  for i = 1, maxNum do
    self.select_group[i] = self:AddComponent(UIBaseContainer, string.format(select_path, i, i))
  end
  self.btn_group = {}
  self.btn_name_group = {}
  self.btn_group[0] = self:AddComponent(UIButton, zero_btn_path)
  self.btn_name_group[0] = self:AddComponent(UIText, zero_btn_name_path)
  for i = 1, 9 do
    local row = math.modf((i - 1) / 3) + 1
    self.btn_group[i] = self:AddComponent(UIButton, string.format(btn_group_path, row, i))
    self.btn_name_group[i] = self:AddComponent(UIText, string.format(btn_name_group_path, row, i, i))
    self.btn_group[i]:SetOnClick(function()
      DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
      self:OnNumberBtnClick(i)
    end)
  end
  self.new_game_btn:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self:OnNewGameBtnClick()
  end)
  self.return_btn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.forget_btn:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self:OnForgetBtnClick()
  end)
  self.back_btn:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self:OnBackBtnClick()
  end)
  self.btn_group[0]:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self:OnNumberBtnClick(0)
  end)
end

local function ComponentDestroy(self)
  self.des_text = nil
  self.title_name = nil
  self.return_btn = nil
  self.txt_name = nil
  self.forget_btn = nil
  self.forget_btn_name = nil
  self.new_game_btn = nil
  self.new_game_btn_name = nil
  self.back_btn = nil
  self.back_btn_name = nil
  self.select_group = nil
  self.btn_group = nil
  self.btn_name_group = nil
end

local function DataDefine(self)
  self.inputType = nil
  self.inputNum = {}
  self.inputIndex = 1
  self.firstPinCode = ""
end

local function DataDestroy(self)
  self.inputType = nil
  self.inputNum = nil
  self.inputIndex = nil
  self.firstPinCode = nil
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function ReInit(self)
  for k, v in pairs(self.select_group) do
    v:SetActive(false)
  end
  for k, v in pairs(self.btn_name_group) do
    v:SetText(k)
  end
  self.inputIndex = 1
  self.back_btn_name:SetLocalText(110038)
  self.inputType = tonumber(self:GetUserData())
  if self.inputType == UIPinInputType.Enter then
    self.title_name:SetLocalText(280093)
    self.forget_btn:SetActive(true)
    self.new_game_btn:SetActive(true)
    self.return_btn:SetActive(false)
    self.forget_btn_name:SetLocalText(280086)
    self.new_game_btn_name:SetLocalText(280045)
  else
    self.title_name:SetLocalText(280087)
    self.forget_btn:SetActive(false)
    self.new_game_btn:SetActive(false)
    self.return_btn:SetActive(true)
    self.des_text:SetLocalText(280083)
  end
end

local function OnAddListener(self)
  base.OnAddListener(self)
  self:AddUIListener(EventId.PinInputReset, self.PinInputResetSignal)
  self:AddUIListener(EventId.PinInputClose, self.PinInputCloseSignal)
  self:AddUIListener(EventId.PinInputNext, self.PinInputNextSignal)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
  self:RemoveUIListener(EventId.PinInputReset, self.PinInputResetSignal)
  self:RemoveUIListener(EventId.PinInputClose, self.PinInputCloseSignal)
  self:RemoveUIListener(EventId.PinInputNext, self.PinInputNextSignal)
end

local function OnNumberBtnClick(self, num)
  if self.inputIndex <= maxNum then
    self.inputNum[self.inputIndex] = num
    self.select_group[self.inputIndex]:SetActive(true)
    self.inputIndex = self.inputIndex + 1
    if self.inputIndex > maxNum then
      self:OnComplete()
    end
  end
end

local function OnComplete(self)
  local code = ""
  for k, v in ipairs(self.inputNum) do
    code = code .. v
  end
  if self.inputType == UIPinInputType.Enter then
    SFSNetwork.SendMessage(MsgDefines.PinPwdCheck, {pwd = code})
  elseif self.firstPinCode == "" then
    self.firstPinCode = code
    SFSNetwork.SendMessage(MsgDefines.PinOldPwdCheck, {pwd = code})
  elseif self.firstPinCode == code or self.inputType == UIPinInputType.Change then
    local oldPwd = ""
    if self.inputType == UIPinInputType.Change then
      oldPwd = self.firstPinCode
    end
    SFSNetwork.SendMessage(MsgDefines.PinSetPwd, {
      pwd = code,
      oldPwd = oldPwd,
      isOnlyChangePwd = true
    })
  else
    UIUtil.ShowTipsId(280094)
    self.title_name:SetLocalText(280092)
    self.firstPinCode = ""
    for k, v in pairs(self.select_group) do
      v:SetActive(false)
    end
    self.inputIndex = 1
    self.inputNum = {}
  end
end

local function OnNewGameBtnClick(self)
  UIUtil.ShowMessage(Localization:GetString("280095"), 1, GameDialogDefine.CONFIRM, GameDialogDefine.CANCEL, function()
    SFSNetwork.SendMessage(MsgDefines.NewAccount, {confirm = 2})
    self.ctrl:CloseSelf()
  end)
end

local function OnForgetBtnClick(self)
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIPinForget, {anim = true})
end

local function OnBackBtnClick(self)
  if self.inputIndex > 1 then
    self.inputIndex = self.inputIndex - 1
    self.inputNum[self.inputIndex] = nil
    self.select_group[self.inputIndex]:SetActive(false)
  end
end

local function PinInputResetSignal(self)
  for k, v in pairs(self.select_group) do
    v:SetActive(false)
  end
  self.inputIndex = 1
  self.inputNum = {}
  if self.inputType == UIPinInputType.Enter then
    self.title_name:SetLocalText(280093)
  elseif LuaEntry.Player.pinPwdStatus == PinPwdStatus.Have then
    self.title_name:SetLocalText(280087)
  else
    self.title_name:SetLocalText(280092)
  end
end

local function PinInputCloseSignal(self)
  self.ctrl:CloseSelf()
end

local function PinInputNextSignal(self)
  if LuaEntry.Player.pinPwdStatus == PinPwdStatus.Have then
    self.title_name:SetLocalText(280092)
  else
    self.title_name:SetLocalText(280090)
  end
  for k, v in pairs(self.select_group) do
    v:SetActive(false)
  end
  self.inputIndex = 1
  self.inputNum = {}
end

UIPinInputView.OnCreate = OnCreate
UIPinInputView.OnDestroy = OnDestroy
UIPinInputView.OnEnable = OnEnable
UIPinInputView.OnDisable = OnDisable
UIPinInputView.ComponentDefine = ComponentDefine
UIPinInputView.ComponentDestroy = ComponentDestroy
UIPinInputView.DataDefine = DataDefine
UIPinInputView.DataDestroy = DataDestroy
UIPinInputView.OnNumberBtnClick = OnNumberBtnClick
UIPinInputView.ReInit = ReInit
UIPinInputView.OnAddListener = OnAddListener
UIPinInputView.OnRemoveListener = OnRemoveListener
UIPinInputView.PinInputResetSignal = PinInputResetSignal
UIPinInputView.OnNewGameBtnClick = OnNewGameBtnClick
UIPinInputView.OnForgetBtnClick = OnForgetBtnClick
UIPinInputView.OnBackBtnClick = OnBackBtnClick
UIPinInputView.PinInputCloseSignal = PinInputCloseSignal
UIPinInputView.PinInputNextSignal = PinInputNextSignal
UIPinInputView.OnComplete = OnComplete
return UIPinInputView
