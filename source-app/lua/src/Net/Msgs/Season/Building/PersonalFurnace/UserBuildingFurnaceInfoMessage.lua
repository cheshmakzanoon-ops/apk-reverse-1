local UserBuildingFurnaceInfoMessage = BaseClass("UserBuildingFurnaceInfoMessage", SFSBaseMessage)
local base = SFSBaseMessage

function UserBuildingFurnaceInfoMessage:OnCreate()
  base.OnCreate(self)
end

function UserBuildingFurnaceInfoMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
    return
  end
  DataCenter.BuildManager:UpdateFurnaceData(t)
end

return UserBuildingFurnaceInfoMessage
