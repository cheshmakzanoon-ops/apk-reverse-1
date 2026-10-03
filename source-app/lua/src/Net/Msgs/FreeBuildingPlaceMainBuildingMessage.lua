local FreeBuildingPlaceMainBuildingMessage = BaseClass("FreeBuildingPlaceMainBuildingMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, param)
  base.OnCreate(self)
  if param ~= nil then
    self.sfsObj:PutInt("pointId", param.pointId)
    if param.pointId ~= nil then
      DataCenter.BuildManager:AddOneChangeMoveBuild(param.pointId)
    end
  end
  DataCenter.BuildManager:SetCurrentBuildMoveState(BuildMoveState.None)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  local success = t.errorCode == nil
  DataCenter.BuildManager:SetCurrentBuildMoveState(success and BuildMoveState.Success or BuildMoveState.Fail)
  DataCenter.BuildManager:FreeBuildingPlaceMainBuildingHandle(t)
end

FreeBuildingPlaceMainBuildingMessage.OnCreate = OnCreate
FreeBuildingPlaceMainBuildingMessage.HandleMessage = HandleMessage
return FreeBuildingPlaceMainBuildingMessage
