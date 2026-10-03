local UIChangeNameCtrl = BaseClass("UIChangeNameCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIChangeName)
end

local function Close(self)
  UIManager:GetInstance():DestroyWindowByLayer(UILayer.Normal)
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

UIChangeNameCtrl.CloseSelf = CloseSelf
UIChangeNameCtrl.Close = Close
UIChangeNameCtrl.CheckName = CheckName
UIChangeNameCtrl.SendCheckNameMessage = SendCheckNameMessage
UIChangeNameCtrl.SendChangeNameMessage = SendChangeNameMessage
UIChangeNameCtrl.CheckHaveEnoughItem = CheckHaveEnoughItem
return UIChangeNameCtrl
