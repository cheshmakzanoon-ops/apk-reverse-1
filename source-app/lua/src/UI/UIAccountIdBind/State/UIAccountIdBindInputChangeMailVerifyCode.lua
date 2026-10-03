local UIAccountIdBindInputVerifyBaseState = require("UI.UIAccountIdBind.State.UIAccountIdBindInputVerifyBaseState")
local AccountScoreConst = require("DataCenter.AccountScore.AccountScoreConst")
local UIAccountIdBindInputChangeMailVerifyCode = BaseClass("UIAccountIdBindInputChangeMailVerifyCode", UIAccountIdBindInputVerifyBaseState)
local base = UIAccountIdBindInputVerifyBaseState

function UIAccountIdBindInputChangeMailVerifyCode:__init(view)
  base.__init(self, view, AccountScoreConst.ViewState.InputChangeMailVerifyCode, {
    componentType = AccountScoreConst.ComponentType.InputVerifyCode,
    mailAddress = self:GetChangeMailAddress(),
    onRequest = function(_, verifyCode)
      local oldVerifyCode = DataCenter.AccountManager:GetOldEmailVerifyCode()
      SFSNetwork.SendMessage(MsgDefines.VerifyBindAccountEmail, {
        changeType = 2,
        oldVerifyCode = oldVerifyCode,
        newVerifyCode = verifyCode
      })
    end,
    onResendRequest = function(_)
      local mailAddress = self:GetChangeMailAddress()
      if string.IsNullOrEmpty(mailAddress) then
        Logger.LogError("[UIAccountIdBindInputChangeMailVerifyCode] resend mailAddress is empty")
        return
      end
      SFSNetwork.SendMessage(MsgDefines.ChangeBindAccountEmail, {changeType = 2, newMail = mailAddress})
    end,
    localization = {
      titleStr = "id_account_ID1_title_1",
      contentStr = "id_account_ID14_desc_1",
      cancelBtnStr = "id_account_ID_btn_goback",
      sendMailBtnStr = "id_account_ID_btn_confirm",
      resendBtnStr = "id_account_ID_desc_resend2",
      didNotReceiveBtnStr = "id_account_ID_desc_notreceived"
    }
  })
  
  function self._onBindHandler()
    self:OnBind()
  end
end

function UIAccountIdBindInputChangeMailVerifyCode:OnEnter()
  self.config.mailAddress = self:GetChangeMailAddress()
  base.OnEnter(self)
  EventManager:GetInstance():AddListener(EventId.AccountBindOKEvent, self._onBindHandler)
end

function UIAccountIdBindInputChangeMailVerifyCode:OnExit()
  base.OnExit(self)
  EventManager:GetInstance():RemoveListener(EventId.AccountBindOKEvent, self._onBindHandler)
end

function UIAccountIdBindInputChangeMailVerifyCode:GetChangeMailAddress()
  local accountIdBindData = self:GetAccountIdBindData()
  return accountIdBindData and accountIdBindData.changeMail or ""
end

function UIAccountIdBindInputChangeMailVerifyCode:OnBind()
  self.view:SwitchToNextState()
end

return UIAccountIdBindInputChangeMailVerifyCode
