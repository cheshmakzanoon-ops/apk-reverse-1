local UserBuildingFurnaceSettingAutoMessage = BaseClass("UserBuildingFurnaceSettingAutoMessage", SFSBaseMessage)
local base = SFSBaseMessage

function UserBuildingFurnaceSettingAutoMessage:OnCreate(state)
  base.OnCreate(self)
  self.sfsObj:PutInt("auto", state)
end

function UserBuildingFurnaceSettingAutoMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
    return
  end
  DataCenter.BuildManager:UpdateFurnaceSettingData(t)
end

return UserBuildingFurnaceSettingAutoMessage
