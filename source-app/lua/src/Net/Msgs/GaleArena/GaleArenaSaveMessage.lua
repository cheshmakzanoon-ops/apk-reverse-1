local GaleArenaSaveMessage = BaseClass("GaleArenaSaveMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, heroInfos, squadIdx, chipSetId)
  base.OnCreate(self)
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
  if t ~= nil and t.errorCode ~= nil then
    UIUtil.ShowTipsId(t.errorCode)
  end
end

GaleArenaSaveMessage.OnCreate = OnCreate
GaleArenaSaveMessage.HandleMessage = HandleMessage
return GaleArenaSaveMessage
