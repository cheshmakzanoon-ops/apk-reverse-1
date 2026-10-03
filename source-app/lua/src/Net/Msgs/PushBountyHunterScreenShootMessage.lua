local PushBountyHunterScreenShootMessage = BaseClass("PushBountyHunterScreenShootMessage", SFSBaseMessage)
local base = SFSBaseMessage

function PushBountyHunterScreenShootMessage:OnCreate(param)
  base.OnCreate(self)
end

function PushBountyHunterScreenShootMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    if not t.result then
      return
    end
    local fullAtkResult = t.result
    if not fullAtkResult then
      return
    end
    local actData
    local allDmgDataList = {}
    local activityId, finalScore, finalStashReward, finalTodayShoot, finalTotalShoot, finalNextBossCount
    for _, data in ipairs(fullAtkResult) do
      activityId = activityId or toInt(data.activityId)
      actData = actData or DataCenter.BountyHunterActDataManager:GetActData(activityId)
      if not actData then
        return
      end
      if data.stashReward then
        finalStashReward = data.stashReward
      end
      if data.score then
        finalScore = data.score
      end
      if data.todayShoot then
        finalTodayShoot = data.todayShoot
      end
      if data.nextBossCount then
        finalNextBossCount = data.nextBossCount
      end
      if data.totalShoot then
        finalTotalShoot = data.totalShoot
      end
      if actData.sceneData then
        local sdata = {}
        sdata.dropReward = data.monsterReward
        sdata.monsterChange = data.monsterChange
        table.insert(allDmgDataList, sdata)
      end
      if data.log then
        actData:AppendBatLogData(data.log)
      end
    end
    if actData then
      if finalStashReward then
        actData:UpdateStashReward(finalStashReward)
      end
      if finalScore then
        actData:UpdateScore(finalScore)
      end
      if finalTodayShoot then
        actData:UpdateTodayConsume({todayShoot = finalTodayShoot})
      end
      if finalNextBossCount then
        actData:UpdateNextBossCount({nextBossCount = finalNextBossCount})
      end
      if finalTotalShoot then
        actData:UpdateTotalConsume({totalShoot = finalTotalShoot})
      end
      actData.sceneData:UpdateMonsterDataAfterFullScreenAttack(allDmgDataList)
    end
  end
end

return PushBountyHunterScreenShootMessage
