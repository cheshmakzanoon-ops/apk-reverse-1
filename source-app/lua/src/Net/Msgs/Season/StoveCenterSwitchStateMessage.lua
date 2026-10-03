local StoveCenterSwitchStateMessage = BaseClass("StoveCenterSwitchStateMessage", SFSBaseMessage)
local base = SFSBaseMessage

function StoveCenterSwitchStateMessage:OnCreate(buildingUuid, state)
  base.OnCreate(self)
  self.sfsObj:PutInt("state", state)
  self.sfsObj:PutLong("buildingUuid", buildingUuid)
end

function StoveCenterSwitchStateMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    if LuaEntry.Player:IsInSourceServer() then
      UIUtil.ShowTipsId(errCode)
    else
      UIUtil.ShowTipsId("season_tips166")
    end
    return
  end
end

return StoveCenterSwitchStateMessage
