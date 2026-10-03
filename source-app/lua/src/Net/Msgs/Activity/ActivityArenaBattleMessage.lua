local ActivityArenaBattleMessage = BaseClass("ActivityArenaBattleMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, activityId, rank, heroInfos, squadNo, chipSetId)
  base.OnCreate(self)
  self.sfsObj:PutInt("activityId", tonumber(activityId))
  if heroInfos then
    if heroInfos.AddSFSObject then
      self.sfsObj:PutSFSArray("heroInfos", heroInfos)
    else
      local heroArray = SFSArray.New()
      table.walk(heroInfos, function(k, v)
        local key = k
        if type(key) == "number" then
          key = tostring(key)
        end
        local obj = SFSObject.New()
        obj:PutLong("heroUuid", v)
        obj:PutUtfString("index", key)
        heroArray:AddSFSObject(obj)
      end)
      self.sfsObj:PutSFSArray("heroInfos", heroArray)
    end
  else
    Logger.LogError("heroInfos is nil")
  end
  self.sfsObj:PutInt("rank", tostring(rank))
  self.sfsObj:PutInt("squadNo", squadNo)
  if chipSetId and 0 < chipSetId and chipSetId <= 4 then
    self.sfsObj:PutInt("chipEquipGroup", chipSetId)
  end
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
    EventManager:GetInstance():Broadcast(EventId.ServerError, MsgDefines.ActivityArenaBattle)
  else
    EventManager:GetInstance():Broadcast(EventId.PVPArenaSkirmishDataReceived, t)
  end
end

ActivityArenaBattleMessage.OnCreate = OnCreate
ActivityArenaBattleMessage.HandleMessage = HandleMessage
return ActivityArenaBattleMessage
