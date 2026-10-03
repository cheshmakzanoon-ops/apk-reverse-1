local DefenseInfoSaveMessage = BaseClass("DefenseInfoSaveMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

local function OnCreate(self, uuid, heroInfos)
  base.OnCreate(self)
  self.sfsObj:PutLong("uuid", uuid)
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
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.ArmyFormationDataManager:SaveDefenceFormation(t)
    EventManager:GetInstance():Broadcast(EventId.ArmyFormatUpdate)
    UIUtil.ShowTipsId(300056)
  end
end

DefenseInfoSaveMessage.OnCreate = OnCreate
DefenseInfoSaveMessage.HandleMessage = HandleMessage
return DefenseInfoSaveMessage
