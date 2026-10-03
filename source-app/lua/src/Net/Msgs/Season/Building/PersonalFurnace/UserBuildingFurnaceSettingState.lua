local UserBuildingFurnaceSettingState = BaseClass("UserBuildingFurnaceSettingState", SFSBaseMessage)
local base = SFSBaseMessage

function UserBuildingFurnaceSettingState:OnCreate(uuid, state)
  base.OnCreate(self)
  self.sfsObj:PutLong("uuid", uuid)
  self.sfsObj:PutInt("state", state)
end

function UserBuildingFurnaceSettingState:HandleMessage(t)
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

return UserBuildingFurnaceSettingState
