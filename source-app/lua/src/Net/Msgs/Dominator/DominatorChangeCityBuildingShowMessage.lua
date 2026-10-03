local DominatorChangeCityBuildingShowMessage = BaseClass("DominatorChangeCityBuildingShowMessage", SFSBaseMessage)
local base = SFSBaseMessage

function DominatorChangeCityBuildingShowMessage:OnCreate(param)
  base.OnCreate(self)
  self.sfsObj:PutInt("dominatorId", param.dominatorId)
end

function DominatorChangeCityBuildingShowMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  elseif t.buildInfo then
    DataCenter.BuildManager:AddBuilding(t.buildInfo)
    EventManager:GetInstance():Broadcast(EventId.DominatorAppearanceUpdate)
  end
end

return DominatorChangeCityBuildingShowMessage
