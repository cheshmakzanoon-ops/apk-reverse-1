local StartHeroBountyTaskMessage = BaseClass("StartHeroBountyTaskMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

local function OnCreate(self, index, heroes)
  base.OnCreate(self)
  self.sfsObj:PutInt("index", index)
  if heroes then
    local heroInfos = heroes
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
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.HeroBountyDataManager:OnStartTaskReceive(t)
  end
end

StartHeroBountyTaskMessage.OnCreate = OnCreate
StartHeroBountyTaskMessage.HandleMessage = HandleMessage
return StartHeroBountyTaskMessage
