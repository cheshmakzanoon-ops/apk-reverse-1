local GhostReconJoinTeamMessage = BaseClass("GhostReconJoinTeamMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, uuid, heroList, type)
  base.OnCreate(self)
  self.sfsObj:PutLong("uuid", uuid)
  self.sfsObj:PutLongArray("heroList", heroList)
  self.sfsObj:PutInt("type", type)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  if t ~= nil then
    if t.errorCode == nil then
      if t.type == 2 or t.type == 3 then
        UIUtil.ShowTipsId("ghostrecon_064")
      end
      DataCenter.ActGhostreconManager:GhostReconJoinTeamHandler(t)
    else
      UIUtil.ShowTipsId(t.errorCode)
      if t.errorCode == "ghostrecon_086" then
        local useHeroList = DataCenter.ActGhostreconManager:GetAllUsedHeroList()
        local str = ""
        for key, value in pairs(useHeroList) do
          str = str .. "_" .. DataCenter.HeroDataManager:GetHeroUuidByHeroId(value)
        end
        Logger.LogInfo("GhostRecon UseHeroList:" .. str)
        SFSNetwork.SendMessage(MsgDefines.GhostreconGetTaskList)
      end
      EventManager:GetInstance():Broadcast(EventId.GhostreconAllianceTaskRefresh)
    end
  end
end

GhostReconJoinTeamMessage.OnCreate = OnCreate
GhostReconJoinTeamMessage.HandleMessage = HandleMessage
return GhostReconJoinTeamMessage
