local LwGetSkyBattleStageMessage = BaseClass("LwGetSkyBattleStageMessage", SFSBaseMessage)
local base = SFSBaseMessage

function LwGetSkyBattleStageMessage:OnCreate(chapterId, stageType)
  base.OnCreate(self)
  self.sfsObj:PutInt("chapter", chapterId)
  self.sfsObj:PutInt("stageType", stageType)
end

function LwGetSkyBattleStageMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  elseif t.stageType and t.stageType == 1 then
    DataCenter.LWSkyBattleGrowthChapterManager:InitChapterData(t)
  else
    DataCenter.LWSkyBattleChapterManager:InitChapterData(t)
  end
end

return LwGetSkyBattleStageMessage
