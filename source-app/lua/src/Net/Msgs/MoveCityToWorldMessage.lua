local MoveCityToWorldMessage = BaseClass("MoveCityToWorldMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, param)
  base.OnCreate(self)
  if param ~= nil then
    if param.asAlLeader ~= nil then
      self.sfsObj:PutInt("chooseLeader", param.asAlLeader)
    end
    if param.status ~= nil then
      self.sfsObj:PutInt("status", param.status)
    end
  end
  DataCenter.GuideManager:SetWaitingMessage(WaitMessageFinishType.MoveCityToWorld, true)
end

local function HandleMessage(self, message)
  base.HandleMessage(self, message)
  local oldCityPoint = LuaEntry.Player:GetMainWorldPos()
  DataCenter.GuideCityManager:MoveCityToWorldHandle(message)
  local newCityPoint = LuaEntry.Player:GetMainWorldPos()
  if SceneUtils.GetIsInWorld() and oldCityPoint < 0 and oldCityPoint < newCityPoint then
    CS.SceneManager.World:Lookat(SceneUtils.TileIndexToWorld(newCityPoint))
  end
end

MoveCityToWorldMessage.OnCreate = OnCreate
MoveCityToWorldMessage.HandleMessage = HandleMessage
return MoveCityToWorldMessage
