local CaveExplorationManager = BaseClass("CaveExplorationManager")
local CaveExplorationTemplate = require("DataCenter.RadarCenterDataManager.CaveExploration.CaveExplorationTemplate")

local function __init(self)
  self.caveTemplateDic = {}
  self.sendMsgUuid = {}
  self.cachedRewards = {}
  EventManager:GetInstance():AddListener(EventId.CloseUI, self.HandleCloseUI)
end

local function __delete(self)
  self.caveTemplateDic = nil
  self.sendMsgUuid = nil
  self.cachedRewards = nil
  EventManager:GetInstance():RemoveListener(EventId.CloseUI, self.HandleCloseUI)
end

local function HandleCloseUI(winName)
  local caveManager = DataCenter.CaveExplorationManager
  if winName == UIWindowNames.UIExplorationRewardGet and caveManager.shareId ~= nil then
    UIUtil.OpenLWUIChatCommonShare(caveManager.shareId)
    caveManager.shareId = nil
  end
end

function CaveExplorationManager:SetShareInfo(shareId)
  self.shareId = shareId
end

function CaveExplorationManager:GetTempData(id)
  local result = self.caveTemplateDic[id]
  if result == nil then
    result = self:CreateTempData(id)
  end
  return result
end

function CaveExplorationManager:CreateTempData(id)
  local t = LocalController:instance():getLine(TableName.CaveExploration, id)
  if not t then
    return nil
  end
  local data = CaveExplorationTemplate.New()
  data:InitData(t)
  self.caveTemplateDic[id] = data
  return data
end

function CaveExplorationManager:AddSyncMsgUuid(uuid)
  self.sendMsgUuid[uuid] = true
end

function CaveExplorationManager:DeleteSyncMsgUuid(uuid)
  self.sendMsgUuid[uuid] = nil
end

function CaveExplorationManager:IsSynchronizing(uuid)
  return self.sendMsgUuid[uuid] ~= nil
end

function CaveExplorationManager:TryNextStep(eventUuid, configId, index)
  local template = self:GetTempData(configId)
  if not template then
    return
  end
  local _type = template:GetTypeByIndex(index)
  if _type == 1 or _type == 6 then
    SFSNetwork.SendMessage(MsgDefines.EnterNextCaveExplore, eventUuid, configId, index)
    self:AddSyncMsgUuid(eventUuid)
  elseif _type == 2 or _type == 3 or _type == 4 then
    SFSNetwork.SendMessage(MsgDefines.FinishCaveExplore, eventUuid, index)
    self:AddSyncMsgUuid(eventUuid)
  else
    Logger.LogError("CaveExplorationManager.TryNextStep failed. Type = " .. tostring(_type))
  end
end

function CaveExplorationManager:TryShipStep(eventUuid, configId)
  SFSNetwork.SendMessage(MsgDefines.ShipCaveExplore, eventUuid, configId)
  self:AddSyncMsgUuid(eventUuid)
end

function CaveExplorationManager:TempCacheRewards(uuid, rewards, pathRewards, showTip)
  table.insert(self.cachedRewards, {
    reward = rewards,
    pathReward = pathRewards,
    showTip = showTip
  })
end

function CaveExplorationManager:DequeueTempCacheRewards()
  if #self.cachedRewards > 0 then
    return table.remove(self.cachedRewards, 1)
  end
end

function CaveExplorationManager:Description()
  local sb = StringBuilder.New()
  sb:AppendLine("---\229\164\186\229\174\157\229\165\135\229\133\181---")
  local tCount = self.caveTemplateDic and table.count(self.caveTemplateDic)
  sb:AppendFormatLine("\229\189\147\229\137\141\233\133\141\231\189\174\229\138\160\232\189\189\230\149\176\233\135\143:%s", tCount)
  sb:AppendFormatLine("\229\189\147\229\137\141\231\173\137\229\190\133\229\155\158\229\164\141\231\154\132\230\182\136\230\129\175\230\149\176\233\135\143:%s", table.count(self.sendMsgUuid))
  sb:AppendFormatLine("\231\188\147\229\173\152\229\165\150\229\138\177\230\149\176\233\135\143:%s", #self.cachedRewards)
  sb:AppendLine("-------")
  local window = UIManager:GetInstance():GetWindow(UIWindowNames.UIDetectCaveExploration)
  local view = window and window.View
  if view then
    sb:AppendLine(view:Description())
  else
    sb:AppendLine("\231\149\140\233\157\162\230\156\170\230\137\147\229\188\128...")
  end
  return sb:ToString()
end

CaveExplorationManager.__init = __init
CaveExplorationManager.__delete = __delete
CaveExplorationManager.HandleCloseUI = HandleCloseUI
return CaveExplorationManager
