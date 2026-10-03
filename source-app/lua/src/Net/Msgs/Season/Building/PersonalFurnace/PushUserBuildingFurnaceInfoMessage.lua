local PushUserBuildingFurnaceInfoMessage = BaseClass("PushUserBuildingFurnaceInfoMessage", SFSBaseMessage)
local base = SFSBaseMessage

function PushUserBuildingFurnaceInfoMessage:OnCreate()
  base.OnCreate(self)
end

function PushUserBuildingFurnaceInfoMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
    return
  end
  if t.furnace then
    DataCenter.BuildManager:UpdateFurnaceData(t.furnace)
  end
  if t.resources and LuaEntry.Resource ~= nil then
    LuaEntry.Resource:UpdateResource(t.resources)
  end
end

return PushUserBuildingFurnaceInfoMessage
