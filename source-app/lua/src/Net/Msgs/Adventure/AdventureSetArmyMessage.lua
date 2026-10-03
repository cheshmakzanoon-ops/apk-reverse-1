local AdventureSetArmyMessage = BaseClass("AdventureSetArmyMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, heroes, army)
  base.OnCreate(self)
  local sfsHeroes = SFSArray.New()
  for _, v in pairs(heroes) do
    local index = v.index
    local uuid = v.uuid
    local obj = SFSObject.New()
    obj:PutInt("index", index)
    obj:PutLong("uuid", uuid)
    sfsHeroes:AddSFSObject(obj)
  end
  self.sfsObj:PutSFSArray("heroes", sfsHeroes)
  local formationArray = SFSArray.New()
  for k, v in pairs(army) do
    local obj = SFSObject.New()
    obj:PutUtfString("armyId", tostring(k))
    obj:PutInt("count", tonumber(v))
    formationArray:AddSFSObject(obj)
  end
  self.sfsObj:PutSFSArray("formations", formationArray)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  if t.errorCode ~= nil then
    return
  end
  DataCenter.AdventureManager:HandleSetArmy(t)
end

AdventureSetArmyMessage.OnCreate = OnCreate
AdventureSetArmyMessage.HandleMessage = HandleMessage
return AdventureSetArmyMessage
