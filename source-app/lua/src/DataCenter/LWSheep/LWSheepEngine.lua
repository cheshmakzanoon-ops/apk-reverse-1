local LWSheep = require("DataCenter.LWSheep.LWSheep")
local LWSheepEngine = BaseClass("LWSheepEngine", Singleton)

function LWSheepEngine:__init()
  self.game = LWSheep.New()
end

function LWSheepEngine:__delete()
  if self.game == nil then
    return
  end
  self.game:Delete()
  self.game = nil
end

function LWSheepEngine:BuildGame(server)
  if self.game ~= nil then
    self.game:Build(server)
  end
end

function LWSheepEngine:ReBuild(server)
  if self.game ~= nil then
    self.game:ReBuild(server)
  end
end

function LWSheepEngine:RefreshGame(server)
  if self.game ~= nil then
    self.game:RefreshGame(server)
  end
end

function LWSheepEngine:EnterGame()
  if self.game ~= nil then
    self.game:Enter()
  end
end

function LWSheepEngine:BuildAction(buildAction, reBuildAction, fairAction, successAction, doAction, exceptionAction, syncException)
  if self.game ~= nil then
    self.game:BuildAction(buildAction, reBuildAction, fairAction, successAction, doAction, exceptionAction, syncException)
  end
end

function LWSheepEngine:ClickCard(gridId)
  if self.game ~= nil then
    return self.game:Click(gridId)
  end
end

function LWSheepEngine:UseItem(itemType)
  if self.game ~= nil then
    return self.game:UseItem(itemType)
  end
end

function LWSheepEngine:GetGameInfo()
  if self.game ~= nil then
    return self.game.showCards, self.game.removeList, self.game.temporaryList, self.game.visualList, self.game.itemIds
  end
  return nil, nil, nil, nil
end

function LWSheepEngine:GetRemoveList()
  if self.game ~= nil then
    return self.game.removeList
  end
  return nil
end

function LWSheepEngine:OpCheck(userData, syncData)
  if self.game ~= nil then
    return self.game:OpCheck(userData, syncData)
  end
end

function LWSheepEngine:CheckGameState()
  if self.game ~= nil then
    self.game:CheckGameState()
  end
end

function LWSheepEngine:GetGameState()
  if self.game ~= nil then
    return self.game.gameState
  end
  return SheepGameState.Exception
end

function LWSheepEngine:GetItemIdByType(type)
  if self.game ~= nil then
    return self.game:GetItemIdByType(type)
  end
end

function LWSheepEngine:GetLastOpAction()
  if self.game ~= nil then
    return self.game.lastOptAction
  end
  return nil
end

function LWSheepEngine:CanClickInTemp(card)
  if self.game ~= nil then
    return self.game:CanClickInTemp(card)
  end
  return false
end

function LWSheepEngine:CanUseItem(type)
  if self.game ~= nil then
    return self.game:CanUseItem(type)
  end
end

function LWSheepEngine:GetPassRewards()
  if self.game ~= nil then
    return self.game:GetPassRewards()
  end
  return false
end

return ConstClass("LWSheepEngine", LWSheepEngine)
