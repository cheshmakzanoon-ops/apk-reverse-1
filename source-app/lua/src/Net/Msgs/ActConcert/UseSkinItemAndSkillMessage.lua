local UseSkinItemAndSkillMessage = BaseClass("UseSkinItemAndSkillMessage", SFSBaseMessage)
local base = SFSBaseMessage

function UseSkinItemAndSkillMessage:OnCreate(param)
  base.OnCreate(self)
  if not param or not param.itemId then
    Logger.LogError("UseSkinItemAndSkillMessage:OnCreate - itemId is required")
    return
  end
  self.sfsObj:PutInt("itemId", param.itemId)
end

function UseSkinItemAndSkillMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    local pointId = LuaEntry.Player:GetMainWorldPos()
    GoToUtil.CloseAllWindows()
    GoToUtil.MoveToWorldPoint(pointId, nil, nil)
  end
end

return UseSkinItemAndSkillMessage
