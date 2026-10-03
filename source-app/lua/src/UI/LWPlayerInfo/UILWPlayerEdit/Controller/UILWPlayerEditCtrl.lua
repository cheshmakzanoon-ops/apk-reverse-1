local UILWPlayerEditCtrl = BaseClass("UILWPlayerEditCtrl", UIBaseCtrl)

function UILWPlayerEditCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UILWPlayerEdit)
end

function UILWPlayerEditCtrl:CheckName(value)
  local type = CheckNameType.None
  local len = #value
  if len < MIN_AL_NAME_CHAR then
    type = CheckNameType.MinNameChar
  elseif len > MAX_AL_NAME_CHAR then
    type = CheckNameType.MaxNameChar
  end
  return type
end

function UILWPlayerEditCtrl:CheckHaveEnoughItem()
  local isEnough = UIUtil.CheckHaveEnoughItemRename()
  return isEnough
end

function UILWPlayerEditCtrl:SendCheckNameMessage(value)
  SFSNetwork.SendMessage(MsgDefines.NickNameCheck, value)
end

function UILWPlayerEditCtrl:SendChangeNameMessage(value)
  SFSNetwork.SendMessage(MsgDefines.NickNameChange, value)
end

return UILWPlayerEditCtrl
