local UILWDominatorEditUserNameCtrl = BaseClass("UILWDominatorEditUserNameCtrl", UIBaseCtrl)

function UILWDominatorEditUserNameCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UILWDominatorEditUserName)
end

function UILWDominatorEditUserNameCtrl:CheckNameLength(name)
  local type = CheckNameType.None
  local len = #name
  if len < MIN_AL_NAME_CHAR then
    type = CheckNameType.MinNameChar
  elseif len > MAX_AL_NAME_CHAR then
    type = CheckNameType.MaxNameChar
  end
  return type
end

return UILWDominatorEditUserNameCtrl
