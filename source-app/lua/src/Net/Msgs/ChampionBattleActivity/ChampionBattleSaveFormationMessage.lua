local ChampionBattleSaveFormationMessage = BaseClass("ChampionBattleSaveFormationMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, formationArr)
  base.OnCreate(self)
  self.sfsObj:PutSFSArray("formation", formationArr)
end

local function HandleMessage(self, message)
  base.HandleMessage(self, message)
  if message.errorCode ~= nil then
    UIUtil.ShowTipsId(message.errorCode)
    return
  end
end

ChampionBattleSaveFormationMessage.OnCreate = OnCreate
ChampionBattleSaveFormationMessage.HandleMessage = HandleMessage
return ChampionBattleSaveFormationMessage
