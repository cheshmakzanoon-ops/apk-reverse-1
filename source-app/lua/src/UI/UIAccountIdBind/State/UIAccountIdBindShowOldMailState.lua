local UIAccountIdBindInputMailBaseState = require("UI.UIAccountIdBind.State.UIAccountIdBindInputMailBaseState")
local AccountScoreConst = require("DataCenter.AccountScore.AccountScoreConst")
local UIAccountIdBindShowOldMailState = BaseClass("UIAccountIdBindShowOldMailState", UIAccountIdBindInputMailBaseState)
local base = UIAccountIdBindInputMailBaseState

function UIAccountIdBindShowOldMailState:__init(view)
  base.__init(self, view, AccountScoreConst.ViewState.ShowOldMail, {
    isEdit = false,
    getDefaultMail = function()
      return DataCenter.AccountManager.MailAccount.gameAccount
    end,
    onEnter = function()
    end,
    onRequest = function()
      DataCenter.AccountManager.MailAccount:OnBtnHasBound()
    end,
    localization = {
      titleStr = "id_account_ID11_desc_1",
      contentStr = "id_account_ID11_desc_2",
      cancelBtnStr = "id_account_ID_btn_cancel",
      sendMailBtnStr = "id_account_ID11_btn_3"
    }
  })
  
  function self._onBindHandler(state)
    self:OnBind(state)
  end
end

function UIAccountIdBindShowOldMailState:OnEnter()
  base.OnEnter(self)
  EventManager:GetInstance():AddListener(EventId.AccountPushChangeBindAccountEmail, self._onBindHandler)
end

function UIAccountIdBindShowOldMailState:OnExit()
  base.OnExit(self)
  EventManager:GetInstance():RemoveListener(EventId.AccountPushChangeBindAccountEmail, self._onBindHandler)
end

function UIAccountIdBindShowOldMailState:OnBind(state)
  if state ~= AccountScoreConst.ViewState.ShowOldMail then
    Logger.LogError("UIAccountIdBindShowOldMailState:OnBind, state is ", state, " but not ", AccountScoreConst.ViewState.ShowOldMail)
    return
  end
  self.view:SwitchToNextState()
end

return UIAccountIdBindShowOldMailState
