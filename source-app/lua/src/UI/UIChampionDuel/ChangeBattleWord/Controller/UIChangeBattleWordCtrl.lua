local UIChangeBattleWordCtrl = BaseClass("UIChangeBattleWordCtrl", UIBaseCtrl)

function UIChangeBattleWordCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIChampionDuelChangeBattleWord)
end

function UIChangeBattleWordCtrl:CheckName(value)
  local type = CheckNameType.None
  local len = #value
  local tmpV = string.trim(value)
  if #tmpV == 0 or len < MIN_AL_NAME_CHAR then
    type = CheckNameType.MinNameChar
  elseif len > MAX_AL_NAME_CHAR * 2 then
    type = CheckNameType.MaxNameChar
  end
  return type
end

return UIChangeBattleWordCtrl
