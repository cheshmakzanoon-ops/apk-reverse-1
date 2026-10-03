local UIAccountIdBindInputMailBaseState = require("UI.UIAccountIdBind.State.UIAccountIdBindInputMailBaseState")
local AccountScoreConst = require("DataCenter.AccountScore.AccountScoreConst")
local UIAccountIdBindInputChangeMailState = BaseClass("UIAccountIdBindInputChangeMailState", UIAccountIdBindInputMailBaseState)
local base = UIAccountIdBindInputMailBaseState

function UIAccountIdBindInputChangeMailState:__init(view)
  base.__init(self, view, AccountScoreConst.ViewState.InputChangeMail, {
    isEdit = true,
    onRequest = function(_, mailAddress)
      local accountIdBindData = self:GetAccountIdBindData()
      if accountIdBindData then
        accountIdBindData.changeMail = mailAddress
      end
      SFSNetwork.SendMessage(MsgDefines.ChangeBindAccountEmail, {changeType = 2, newMail = mailAddress})
    end,
    localization = {
      titleStr = "id_account_ID3_desc_1",
      contentStr = "id_account_ID3_desc_2",
      cancelBtnStr = "id_account_ID_btn_cancel",
      sendMailBtnStr = "id_account_ID_btn_send"
    }
  })
  
  function self._onBindHandler(state)
    self:OnBind(state)
  end
end

function UIAccountIdBindInputChangeMailState:OnEnter()
  base.OnEnter(self)
  EventManager:GetInstance():AddListener(EventId.AccountPushChangeBindAccountEmail, self._onBindHandler)
end

function UIAccountIdBindInputChangeMailState:OnExit()
  base.OnExit(self)
  EventManager:GetInstance():RemoveListener(EventId.AccountPushChangeBindAccountEmail, self._onBindHandler)
end

function UIAccountIdBindInputChangeMailState:OnBind(state)
  if state ~= AccountScoreConst.ViewState.InputChangeMail then
    Logger.LogError("UIAccountIdBindInputChangeMailState:OnBind, state is ", state, " but not ", AccountScoreConst.ViewState.InputChangeMail)
    return
  end
  self.view:SwitchToNextState()
end

return UIAccountIdBindInputChangeMailState
