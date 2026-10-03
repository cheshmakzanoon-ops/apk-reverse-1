local UIAccountIdBindInputVerifyBaseState = require("UI.UIAccountIdBind.State.UIAccountIdBindInputVerifyBaseState")
local AccountScoreConst = require("DataCenter.AccountScore.AccountScoreConst")
local UIAccountIdBindInputVerifyCodeState = BaseClass("UIAccountIdBindInputVerifyCodeState", UIAccountIdBindInputVerifyBaseState)
local base = UIAccountIdBindInputVerifyBaseState

function UIAccountIdBindInputVerifyCodeState:__init(view)
  base.__init(self, view, AccountScoreConst.ViewState.InputVerifyCode, {
    componentType = AccountScoreConst.ComponentType.InputVerifyCode,
    mailAddress = self:GetMailAddress(),
    onRequest = function(_, verifyCode)
      SFSNetwork.SendMessage(MsgDefines.AccountVerify, verifyCode)
    end,
    onResendRequest = function(_)
      local mailAddress = self:GetMailAddress()
      if string.IsNullOrEmpty(mailAddress) then
        Logger.LogError("[UIAccountIdBindInputVerifyCodeState] resend mailAddress is empty")
        return
      end
      SFSNetwork.SendMessage(MsgDefines.AccountBind, {userName = mailAddress})
    end,
    localization = {
      titleStr = "id_account_ID1_title_1",
      contentStr = "id_account_ID1_desc_2",
      cancelBtnStr = "id_account_ID_btn_goback",
      sendMailBtnStr = "id_account_ID_btn_confirm",
      resendBtnStr = "id_account_ID_desc_resend2",
      didNotReceiveBtnStr = "id_account_ID_desc_notreceived"
    }
  })
  
  function self._bindOKHandler()
    self:OnBindOK()
  end
end

function UIAccountIdBindInputVerifyCodeState:GetMailAddress()
  local accountIdBindData = self:GetAccountIdBindData()
  return accountIdBindData and accountIdBindData.firstBindMail or ""
end

function UIAccountIdBindInputVerifyCodeState:OnEnter()
  self.config.mailAddress = self:GetMailAddress()
  base.OnEnter(self)
  EventManager:GetInstance():AddListener(EventId.AccountBindOKEvent, self._bindOKHandler)
end

function UIAccountIdBindInputVerifyCodeState:OnExit()
  base.OnExit(self)
  EventManager:GetInstance():RemoveListener(EventId.AccountBindOKEvent, self._bindOKHandler)
end

function UIAccountIdBindInputVerifyCodeState:OnBindOK()
  self.view:SwitchToNextState()
end

return UIAccountIdBindInputVerifyCodeState
