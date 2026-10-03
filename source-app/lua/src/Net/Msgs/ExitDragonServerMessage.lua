local ExitDragonServerMessage = BaseClass("ExitDragonServerMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

local function OnCreate(self, group)
  base.OnCreate(self)
  self.sfsObj:PutInt("group", group)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  if t.errorCode ~= nil then
    local errorCode = t.errorCode
    if errorCode ~= SeverErrorCode then
      UIUtil.ShowTips(Localization:GetString(t.errorCode))
    end
  else
    DataCenter.ActDragonManager:SignTodayLevelDragonWorld()
    DataCenter.BuildManager:FreeBuildingFoldUpNewHandle(t)
    local pos = LuaEntry.Player:GetMainWorldPos()
    GoToUtil.GotoDragonPos(SceneUtils.TileIndexToWorld(pos, ForceChangeScene.World))
  end
end

ExitDragonServerMessage.OnCreate = OnCreate
ExitDragonServerMessage.HandleMessage = HandleMessage
return ExitDragonServerMessage
