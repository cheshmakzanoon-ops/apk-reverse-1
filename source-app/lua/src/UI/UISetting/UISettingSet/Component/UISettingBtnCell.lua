local UISettingBtnCell = BaseClass("UISettingBtnCell", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local Setting = CS.GameEntry.Setting
local Param = DataClass("Param", ParamData)
local ParamData = {
  setType
}
local push_name_path = "PushName"
local push_des_path = "PushDes"
local btn_name_path = "ConfirmBtn/ConfirmBtnName"
local btn_path = "ConfirmBtn"

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

local function OnDestroy(self)
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
  self.push_des = self:AddComponent(UIText, push_des_path)
  self.btn_name = self:AddComponent(UIText, btn_name_path)
  self.btn = self:AddComponent(UIButton, btn_path)
  self.btn:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self:OnBtnClick()
  end)
end

local function ComponentDestroy(self)
  self.push_name = nil
  self.push_des = nil
  self.btn_name = nil
  self.btn = nil
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
end

local function OnBtnClick(self)
  if self.param.setType == SettingSetType.Message then
    UIUtil.ShowMessage(Localization:GetString("280079"), 1, GameDialogDefine.CONFIRM, GameDialogDefine.CANCEL, function()
      CS.ApplicationLaunch.Instance:ReloadGame()
    end)
  elseif self.param.setType == SettingSetType.Game then
    UIUtil.ShowMessage(Localization:GetString("120079"), 1, GameDialogDefine.CONFIRM, GameDialogDefine.CANCEL, function()
      CS.CommonUtils.DeleteCache(false)
      CS.ApplicationLaunch.Instance:ReloadGameInOtherProcess()
    end)
  elseif self.param.setType == SettingSetType.PveResetPos then
    UIUtil.ShowMessage(Localization:GetString(GameDialogDefine.RESET_POSITION_TIP), 2, tostring(GameDialogDefine.RESET_POSITION), GameDialogDefine.CANCEL, function()
      DataCenter.BattleLevel:SetPosition(DataCenter.BattleLevel:GetResetPosition(), true)
      self.view.ctrl:CloseSelf()
    end)
  elseif self.param.setType == SettingSetType.DeleteAccount then
    if not LuaEntry.Player:IsInSelfServer() then
      UIUtil.ShowTipsId("delete_account_content_15")
      return
    end
    SFSNetwork.SendMessage(MsgDefines.GetAllianceLeaderList)
    UIUtil.ShowMessage(Localization:GetString("delete_account_content_12"), 2, "121074", "delete_account_title_01", function()
      UIUtil.DeleteAccountBtnClick()
    end, function()
      local state = DataCenter.AccountManager:GetAccountBindState()
      if state == AccountBandState.Band then
        if DataCenter.AccountAllianceLeaderListManager:GetLeaderNum() > 0 then
          UIManager:GetInstance():OpenWindow(UIWindowNames.UIDeleteAccountListPop, {anim = true})
        else
          UIManager:GetInstance():OpenWindow(UIWindowNames.UIDelAllAcctProtConfirm, {anim = true})
        end
      else
        UIUtil.ShowMessage(Localization:GetString("delete_account_content_13"), 1, "121074", "delete_account_title_01", function()
          UIUtil.DeleteAccountBtnClick()
        end)
      end
    end, nil, "delete_account_title_02", nil, nil, nil, nil, nil, nil, nil, nil, "tongyong_cfm_anniu_5", "tongyong_cfm_anniu_4")
  end
end

local function SetName(self)
  if self.param.setType == SettingSetType.Message then
    self.push_name:SetLocalText(280078)
    self.push_des:SetLocalText(310033)
    self.btn_name:SetLocalText(150141)
  elseif self.param.setType == SettingSetType.Game then
    self.push_name:SetLocalText(100244)
    self.push_des:SetLocalText(120078)
    self.btn_name:SetLocalText(150141)
  elseif self.param.setType == SettingSetType.PveResetPos then
    self.push_name:SetLocalText(400094)
    self.push_des:SetLocalText(400095)
    self.btn_name:SetLocalText(400090)
  elseif self.param.setType == SettingSetType.DeleteAccount then
    self.push_name:SetLocalText("delete_account_title_01")
    self.push_des:SetText("")
    self.btn_name:SetLocalText(110036)
  end
end

UISettingBtnCell.OnCreate = OnCreate
UISettingBtnCell.OnDestroy = OnDestroy
UISettingBtnCell.Param = Param
UISettingBtnCell.OnEnable = OnEnable
UISettingBtnCell.OnDisable = OnDisable
UISettingBtnCell.ComponentDefine = ComponentDefine
UISettingBtnCell.ComponentDestroy = ComponentDestroy
UISettingBtnCell.DataDefine = DataDefine
UISettingBtnCell.DataDestroy = DataDestroy
UISettingBtnCell.ReInit = ReInit
UISettingBtnCell.OnBtnClick = OnBtnClick
UISettingBtnCell.SetName = SetName
return UISettingBtnCell
