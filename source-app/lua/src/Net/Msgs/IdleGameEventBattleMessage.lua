local IdleGameEventBattleMessage = BaseClass("IdleGameEventBattleMessage", SFSBaseMessage)
local base = SFSBaseMessage

function IdleGameEventBattleMessage:OnCreate(param)
  base.OnCreate(self)
  self.sfsObj:PutLong("eventUuid", param.eventUuid)
  self.sfsObj:PutInt("armyId", param.armyId)
  local heroInfos = param.heroInfo
  if heroInfos then
    if heroInfos.AddSFSObject then
      self.sfsObj:PutSFSArray("heroInfo", heroInfos)
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
  local chipSetId = param.chipEquipGroup
  if chipSetId and 0 < chipSetId and chipSetId <= 4 then
    self.sfsObj:PutInt("chipEquipGroup", chipSetId)
  end
end

function IdleGameEventBattleMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  elseif t.contentsArr or t.content then
    EventManager:GetInstance():Broadcast(EventId.TowerupFakePVPBattleDataGet, t)
  end
end

return IdleGameEventBattleMessage
