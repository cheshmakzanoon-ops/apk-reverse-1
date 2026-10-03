local ChampionDuelGroupListMessage = BaseClass("ChampionDuelGroupListMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, group, startRank, pageSize, stageId)
  base.OnCreate(self)
  self.sfsObj:PutInt("group", group)
  self.sfsObj:PutInt("startRank", startRank)
  self.sfsObj:PutInt("pageSize", pageSize)
  if stageId then
    self.sfsObj:PutInt("stageId", stageId)
  end
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
    return
  end
  DataCenter.ChampionDuelManager:HandleGroupList(t)
end

ChampionDuelGroupListMessage.OnCreate = OnCreate
ChampionDuelGroupListMessage.HandleMessage = HandleMessage
return ChampionDuelGroupListMessage
