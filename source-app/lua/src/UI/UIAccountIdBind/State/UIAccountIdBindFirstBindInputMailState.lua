local UIAccountIdBindInputMailBaseState = require("UI.UIAccountIdBind.State.UIAccountIdBindInputMailBaseState")
local AccountScoreConst = require("DataCenter.AccountScore.AccountScoreConst")
local UIAccountIdBindFirstBindInputMailState = BaseClass("UIAccountIdBindFirstBindInputMailState", UIAccountIdBindInputMailBaseState)
local base = UIAccountIdBindInputMailBaseState

function UIAccountIdBindFirstBindInputMailState:__init(view)
  base.__init(self, view, AccountScoreConst.ViewState.FirstBindInputMail, {
    isEdit = true,
    onRequest = function(_, mailAddress)
      local accountIdBindData = self:GetAccountIdBindData()
      if accountIdBindData then
        accountIdBindData.firstBindMail = mailAddress
      end
      SFSNetwork.SendMessage(MsgDefines.AccountBind, {userName = mailAddress})
    end,
    localization = {
      titleStr = "id_account_ID3_desc_1",
      contentStr = "id_account_ID3_desc_2",
      cancelBtnStr = "id_account_ID_btn_cancel",
      sendMailBtnStr = "id_account_ID_btn_send"
    }
  })
  
  function self._onBindHandler()
    self:OnBind()
  end
end

function UIAccountIdBindFirstBindInputMailState:OnEnter()
  base.OnEnter(self)
  EventManager:GetInstance():AddListener(EventId.AccountBindEvent, self._onBindHandler)
end

function UIAccountIdBindFirstBindInputMailState:OnExit()
  base.OnExit(self)
  EventManager:GetInstance():RemoveListener(EventId.AccountBindEvent, self._onBindHandler)
end

function UIAccountIdBindFirstBindInputMailState:OnBind()
  self.view:SwitchToNextState()
end

return UIAccountIdBindFirstBindInputMailState
