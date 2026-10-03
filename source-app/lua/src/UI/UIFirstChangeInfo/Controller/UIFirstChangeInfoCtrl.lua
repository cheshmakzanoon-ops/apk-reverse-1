local UIFirstChangeInfoCtrl = BaseClass("UIFirstChangeInfoCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager.Instance:DestroyWindow(UIWindowNames.UIFirstChangeInfo, {
    anim = true,
    UIMainAnim = UIMainAnimType.AllShow
  })
  if self.callback then
    self.callback.func(self.callback.caller)
  end
end

local function CheckName(self, value)
  local type = CheckNameType.None
  local len = #value
  if len < MIN_AL_NAME_CHAR then
    type = CheckNameType.MinNameChar
  elseif len > MAX_AL_NAME_CHAR then
    type = CheckNameType.MaxNameChar
  end
  Logger.Log("check type", type)
  return type
end

local function CheckHaveEnoughItem(self)
  local isEnough = UIUtil.CheckHaveEnoughItemRename()
  return isEnough
end

local function SendCheckNameMessage(self, value)
  SFSNetwork.SendMessage(MsgDefines.NickNameCheck, value)
end

local function SendChangeNameMessage(self, value)
  SFSNetwork.SendMessage(MsgDefines.NickNameChange, value)
end

local function HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    print("Change Name Faile")
  else
    UIUtil.ShowTipsId(280032)
  end
end

UIFirstChangeInfoCtrl.CheckName = CheckName
UIFirstChangeInfoCtrl.SendCheckNameMessage = SendCheckNameMessage
UIFirstChangeInfoCtrl.SendChangeNameMessage = SendChangeNameMessage
UIFirstChangeInfoCtrl.CheckHaveEnoughItem = CheckHaveEnoughItem
UIFirstChangeInfoCtrl.CloseSelf = CloseSelf
return UIFirstChangeInfoCtrl
