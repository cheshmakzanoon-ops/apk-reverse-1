local AccountScoreConst = {}
AccountScoreConst.AccountIdBindStage = {
  Mail = 1,
  Verify = 2,
  Confirm = 3
}
AccountScoreConst.OpenType = {
  BindMail = 1,
  ChangeMail = 2,
  ChangeSignIn = 3
}
AccountScoreConst.ViewState = {
  FirstBindInputMail = 1,
  InputVerifyCode = 2,
  BindPlayerInfo = 3,
  BindSuccess = 4,
  ActiveCard = 5,
  ShowOldMail = 6,
  InputOldMailVerifyCode = 7,
  InputChangeMail = 8,
  InputChangeMailVerifyCode = 9,
  SignIn = 10
}
AccountScoreConst.OpenStateMap = {
  [AccountScoreConst.OpenType.BindMail] = {
    AccountScoreConst.ViewState.FirstBindInputMail,
    AccountScoreConst.ViewState.InputVerifyCode,
    AccountScoreConst.ViewState.BindPlayerInfo,
    AccountScoreConst.ViewState.BindSuccess,
    AccountScoreConst.ViewState.ActiveCard
  },
  [AccountScoreConst.OpenType.ChangeMail] = {
    AccountScoreConst.ViewState.ShowOldMail,
    AccountScoreConst.ViewState.InputOldMailVerifyCode,
    AccountScoreConst.ViewState.InputChangeMail,
    AccountScoreConst.ViewState.InputChangeMailVerifyCode,
    AccountScoreConst.ViewState.BindPlayerInfo,
    AccountScoreConst.ViewState.BindSuccess
  },
  [AccountScoreConst.OpenType.ChangeSignIn] = {
    AccountScoreConst.ViewState.SignIn
  }
}
AccountScoreConst.ComponentType = {
  InputMail = 1,
  InputVerifyCode = 2,
  PersonalInfo = 3,
  SwitchLogIn = 4,
  CardActive = 5,
  SwitchLogIn = 6
}
AccountScoreConst.ComponentConfigMap = {
  [AccountScoreConst.ComponentType.InputMail] = {
    prefabPath = "Assets/Main/Prefabs/UI/UIAccountIdBind/UIAccountIdBind_InputEmail.prefab",
    compPath = "UI.UIAccountIdBind.Component.UIAccountIdBindInputEmailComponent"
  },
  [AccountScoreConst.ComponentType.InputVerifyCode] = {
    prefabPath = "Assets/Main/Prefabs/UI/UIAccountIdBind/UIAccountIdBind_VerifyCode.prefab",
    compPath = "UI.UIAccountIdBind.Component.UIAccountIdBindVerifyCodeComponent"
  },
  [AccountScoreConst.ComponentType.PersonalInfo] = {
    prefabPath = "Assets/Main/Prefabs/UI/UIAccountIdBind/UIAccountIdBind_PersonalInfo.prefab",
    compPath = "UI.UIAccountIdBind.Component.UIAccountIdBindPersonalInfoComponent"
  },
  [AccountScoreConst.ComponentType.CardActive] = {
    prefabPath = "Assets/Main/Prefabs/UI/UIAccountIdBind/UIAccountIdBind_CardActive.prefab",
    compPath = "UI.UIAccountIdBind.Component.UIAccountIdBindCardActiveComponent"
  },
  [AccountScoreConst.ComponentType.SwitchLogIn] = {
    prefabPath = "Assets/Main/Prefabs/UI/UIAccountIdBind/UIAccountIdBind_SwitchLogIn.prefab",
    compPath = "UI.UIAccountIdBind.Component.UIAccountIdBindSwitchLogInComponent"
  }
}
return AccountScoreConst
