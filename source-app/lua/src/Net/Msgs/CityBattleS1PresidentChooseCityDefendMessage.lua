local CityBattleS1PresidentChooseCityDefendMessage = BaseClass("CityBattleS1PresidentChooseCityDefendMessage", SFSBaseMessage)
local base = SFSBaseMessage

function CityBattleS1PresidentChooseCityDefendMessage:OnCreate(operateType, monsterUid)
  base.OnCreate(self)
  self.sfsObj:PutInt("operateType", operateType)
  self.sfsObj:PutLong("monsterUid", monsterUid)
end

function CityBattleS1PresidentChooseCityDefendMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  elseif t.operateType then
    if t.operateType == 1 then
      UIUtil.ShowTipsId("s1_offseason_activity_recapture_firstAttackTips1")
    elseif t.operateType == -1 then
      UIUtil.ShowTipsId("s1_offseason_activity_recapture_firstAttackTips2")
    end
  end
end

return CityBattleS1PresidentChooseCityDefendMessage
