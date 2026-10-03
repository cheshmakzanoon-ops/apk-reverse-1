local NewArenaBattleMessage = BaseClass("NewArenaBattleMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, otherUid, heroInfos, squadIdx, chipSetId)
  base.OnCreate(self)
  self.sfsObj:PutUtfString("otherUid", tostring(otherUid))
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
  self.sfsObj:PutInt("squadNo", squadIdx)
  if chipSetId and 0 < chipSetId and chipSetId <= 4 then
    self.sfsObj:PutInt("chipEquipGroup", chipSetId)
  end
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  if t ~= nil then
    if t.errorCode == nil then
      EventManager:GetInstance():Broadcast(EventId.NewPeakArenaSkirmishDataReceived, t)
    else
      UIUtil.ShowTipsId(t.errorCode)
    end
  end
end

NewArenaBattleMessage.OnCreate = OnCreate
NewArenaBattleMessage.HandleMessage = HandleMessage
return NewArenaBattleMessage
