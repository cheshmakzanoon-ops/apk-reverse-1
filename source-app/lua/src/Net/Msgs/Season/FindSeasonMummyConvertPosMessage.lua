local FindSeasonMummyConvertPosMessage = BaseClass("FindSeasonMummyConvertPosMessage", SFSBaseMessage)
local base = SFSBaseMessage

function FindSeasonMummyConvertPosMessage:OnCreate()
  base.OnCreate(self)
end

function FindSeasonMummyConvertPosMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    local findPos = toInt(t.findPos)
    if findPos <= 0 then
      UIUtil.ShowTipsId(129072)
    else
      GoToUtil.CloseAllWindows()
      GoToUtil.MoveToWorldPointAndOpen(findPos)
    end
  end
end

return FindSeasonMummyConvertPosMessage
