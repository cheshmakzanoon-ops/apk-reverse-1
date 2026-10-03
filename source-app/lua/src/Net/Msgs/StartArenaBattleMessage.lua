local StartArenaBattleMessage = BaseClass("StartArenaBattleMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

local function OnCreate(self, target, type, heroes, power)
  base.OnCreate(self)
  self.sfsObj:PutUtfString("target", target)
  self.sfsObj:PutInt("type", type)
  self.sfsObj:PutLong("power", power)
  if heroes then
    local heroesArray = SFSArray.New()
    for i, hero in pairs(heroes) do
      local obj = SFSObject.New()
      obj:PutInt("index", hero.index)
      obj:PutLong("uuid", hero.uuid)
      heroesArray:AddSFSObject(obj)
    end
    self.sfsObj:PutSFSArray("heroes", heroesArray)
  end
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
    local levelType = DataCenter.BattleLevel:GetLevelType()
    if levelType == PveLevelType.FightLevel then
      DataCenter.BattleLevel:Exit()
    elseif levelType == PveLevelType.NormalLevel or levelType == PveLevelType.HeroExpLevel or levelType == PveLevelType.SkillLevel then
      PveActorMgr:GetInstance():Leave()
    end
    return
  end
  if t == nil then
    return
  end
  local battleContent = ""
  if t.battleContent ~= nil then
    battleContent = t.battleContent
  elseif t.battleContentArr ~= nil then
    local tabCnt = table.count(t.battleContentArr)
    if 0 < tabCnt then
      for i = 1, tabCnt do
        battleContent = battleContent .. t.battleContentArr[i]
      end
    end
  end
  local detailContent = ""
  if t.detailContent ~= nil then
    detailContent = t.detailContent
  elseif t.detailContentArr ~= nil then
    local tabCnt = table.count(t.detailContentArr)
    if 0 < tabCnt then
      for i = 1, tabCnt do
        detailContent = detailContent .. t.detailContentArr[i]
      end
    end
  end
  local expContent = t.heroExpReward
  PveActorMgr:GetInstance():ParseData(battleContent, detailContent, expContent)
  local tempRank, tempScore
  if t.rank then
    tempRank = t.rank
  end
  if t.score then
    tempScore = t.score
  end
  DataCenter.ArenaManager:CacheRankChange(tempRank, tempScore)
  DataCenter.ArenaManager:CacheRewards(t.reward)
  DataCenter.ArenaManager:OnArenaBattleFinish(t)
  DataCenter.BattleLevel:OnBattleMessage(t)
end

StartArenaBattleMessage.OnCreate = OnCreate
StartArenaBattleMessage.HandleMessage = HandleMessage
return StartArenaBattleMessage
