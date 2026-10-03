local BattlefieldDsbDuelMailResultData = BaseClass("BattlefieldDsbDuelMailResultData")
local ActDragonPlayerData = require("DataCenter.ActDragonManager.ActDragonPlayerData")

function BattlefieldDsbDuelMailResultData:__init()
  self.allyList = {}
  self.battleMvp = nil
  self.cooperationMvp = nil
  self.firstMvp = nil
  self.tacticsMvp = nil
  self.rankList = {}
end

function BattlefieldDsbDuelMailResultData:__delete()
  self.allyList = {}
  self.battleMvp = nil
  self.cooperationMvp = nil
  self.firstMvp = nil
  self.tacticsMvp = nil
  self.rankList = {}
end

function BattlefieldDsbDuelMailResultData:ParseData(message)
  if message == nil then
    return
  end
  if message.result ~= nil then
    local emptyRoles = BattlefieldDsbConst.RoleType.MAX - #message.result
    for k, v in pairs(message.result) do
      self.allyList[k] = DeepCopy(v)
      self.allyList[k].emptyRoles = emptyRoles
    end
  end
  if message.mvp then
    local playerDic = {}
    if message.mvp.userList ~= nil then
      self.rankList = {}
      for k, v in ipairs(message.mvp.userList) do
        local player = ActDragonPlayerData.New()
        player:ParseData(v)
        if string.IsNullOrEmpty(player.abbr) then
          player.abbr = DataCenter.AllianceBaseDataManager:GetAllianceBaseData().abbr
        end
        player.rank = k
        self.rankList[k] = player
        playerDic[v.uid] = v
      end
    end
    if message.mvp.battleMvp ~= nil then
      self.battleMvp = ActDragonPlayerData.New()
      self.battleMvp:ParseData(message.mvp.battleMvp)
      if playerDic[self.battleMvp.uid] then
        local battleMvp = playerDic[self.battleMvp.uid]
        self.battleMvp.score = battleMvp.battleScore
      end
    end
    if message.mvp.cooperationMvp ~= nil then
      self.cooperationMvp = ActDragonPlayerData.New()
      self.cooperationMvp:ParseData(message.mvp.cooperationMvp)
      if playerDic[self.cooperationMvp.uid] then
        local cooperationMvp = playerDic[self.cooperationMvp.uid]
        self.cooperationMvp.score = cooperationMvp.cooperationScore
      end
    end
    if message.mvp.firstMvp ~= nil then
      self.firstMvp = ActDragonPlayerData.New()
      self.firstMvp:ParseData(message.mvp.firstMvp)
      if playerDic[self.firstMvp.uid] then
        local firstMvp = playerDic[self.firstMvp.uid]
        self.firstMvp.score = firstMvp.score
      end
    end
    if message.mvp.tacticsMvp ~= nil then
      self.tacticsMvp = ActDragonPlayerData.New()
      self.tacticsMvp:ParseData(message.mvp.tacticsMvp)
      if playerDic[self.tacticsMvp.uid] then
        local tacticsMvp = playerDic[self.tacticsMvp.uid]
        self.tacticsMvp.score = tacticsMvp.tacticsScore
      end
    end
  end
end

return BattlefieldDsbDuelMailResultData
