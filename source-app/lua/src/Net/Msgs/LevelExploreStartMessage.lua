local LevelExploreStartMessage = BaseClass("LevelExploreStartMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, id, armyDict)
  base.OnCreate(self)
  self.sfsObj:PutInt("id", id)
  if armyDict ~= nil then
    local armyArr = SFSArray.New()
    for k, v in pairs(armyDict) do
      local obj = SFSObject.New()
      obj:PutUtfString("armyId", tostring(k))
      obj:PutInt("count", tonumber(v))
      armyArr:AddSFSObject(obj)
    end
    self.sfsObj:PutSFSArray("formations", armyArr)
  end
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  DataCenter.BattleLevel:OnStartLevelMessage(t)
end

LevelExploreStartMessage.OnCreate = OnCreate
LevelExploreStartMessage.HandleMessage = HandleMessage
return LevelExploreStartMessage
