local AlMonsterChallengeGetProgresMessage = BaseClass("AlMonsterChallengeGetProgresMessage", SFSBaseMessage)
local base = SFSBaseMessage

function AlMonsterChallengeGetProgresMessage:OnCreate(difficulty)
  base.OnCreate(self)
  self.sfsObj:PutInt("difficulty", difficulty)
end

function AlMonsterChallengeGetProgresMessage:HandleMessage(data)
  base.HandleMessage(self, data)
  if data == nil then
    return
  end
  local errorCode = data.errorCode
  if errorCode ~= nil then
    UIUtil.ShowTipsId(errorCode)
  else
    local mgr = DataCenter.ActivityListDataManager
    if data.list ~= nil then
      table.sort(data.list, function(a, b)
        return a.level < b.level
      end)
      mgr:UpdateExtraData(KILL_ZOMBIE_ACTIVITY_AL_CUR_DIFFICULT_RANK, data.list)
      EventManager:GetInstance():Broadcast(EventId.MonsterChallengeALProgressUpdate)
    else
      mgr:UpdateExtraData(KILL_ZOMBIE_ACTIVITY_AL_CUR_DIFFICULT_RANK, nil)
    end
  end
end

return AlMonsterChallengeGetProgresMessage
