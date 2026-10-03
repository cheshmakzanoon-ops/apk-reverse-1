local UIAccountIdBindInputVerifyBaseState = require("UI.UIAccountIdBind.State.UIAccountIdBindInputVerifyBaseState")
local AccountScoreConst = require("DataCenter.AccountScore.AccountScoreConst")
local UIAccountIdBindInputOldMailVerifyCodeState = BaseClass("UIAccountIdBindInputOldMailVerifyCodeState", UIAccountIdBindInputVerifyBaseState)
local base = UIAccountIdBindInputVerifyBaseState

function UIAccountIdBindInputOldMailVerifyCodeState:__init(view)
  base.__init(self, view, AccountScoreConst.ViewState.InputOldMailVerifyCode, {
    componentType = AccountScoreConst.ComponentType.InputVerifyCode,
    onRequest = function(_, verifyCode)
      SFSNetwork.SendMessage(MsgDefines.VerifyBindAccountEmail, {changeType = 1, oldVerifyCode = verifyCode})
      DataCenter.AccountManager:SetOldEmailVerifyCode(verifyCode)
    end,
    onResendRequest = function(_)
      SFSNetwork.SendMessage(MsgDefines.ChangeBindAccountEmail, {changeType = 1})
    end,
    localization = {
      titleStr = "id_account_ID1_title_1",
      contentStr = "email_bind_new_des1",
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

function UIAccountIdBindInputOldMailVerifyCodeState:OnEnter()
  self.config.mailAddress = DataCenter.AccountManager.MailAccount.gameAccount or ""
  base.OnEnter(self)
  EventManager:GetInstance():AddListener(EventId.AccountPushChangeMailVerify, self._onBindHandler)
end

function UIAccountIdBindInputOldMailVerifyCodeState:OnExit()
  base.OnExit(self)
  EventManager:GetInstance():RemoveListener(EventId.AccountPushChangeMailVerify, self._onBindHandler)
end

function UIAccountIdBindInputOldMailVerifyCodeState:OnBind()
  self.view:SwitchToNextState()
end

return UIAccountIdBindInputOldMailVerifyCodeState
