local UIServerBattleWeekItem = BaseClass("UIServerBattleWeekItem", UICanvasGroup)
local base = UICanvasGroup
local UIServerBattleWeekItemAL = require("UI.UIGovernment.ServerBattleMain.Component.UIServerBattleWeekItemAL")
local UIServerBattleWeekItemPlayer = require("UI.UIGovernment.ServerBattleMain.Component.UIServerBattleWeekItemPlayer")
local UIServerBattleWeekItemZone = require("UI.UIGovernment.ServerBattleMain.Component.UIServerBattleWeekItemZone")

function UIServerBattleWeekItem:OnCreate()
  base.OnCreate(self)
  self.time = self:AddComponent(UIText, "time")
  self.info1 = self:AddComponent(UIServerBattleWeekItemAL, "info1")
  self.info2 = self:AddComponent(UIServerBattleWeekItemPlayer, "info2")
  self.info3 = self:AddComponent(UIServerBattleWeekItemZone, "info3")
end

function UIServerBattleWeekItem:OnDestroy()
  base.OnDestroy(self)
end

function UIServerBattleWeekItem:ReInit(configScore, config, serverBattleType, scoreData, leftInfo, rightInfo)
  if self.configScore ~= nil and self.scoreData ~= nil and configScore ~= nil and scoreData ~= nil and self.configScore.type2 == configScore.type2 and self.scoreData.time == scoreData.time and self.scoreData.type == scoreData.type and self.scoreData.score == scoreData.score then
    return
  end
  self.configScore = configScore
  self.config = config
  self.serverBattleType = serverBattleType
  self.scoreData = scoreData
  local isWinner = DataCenter.ZoneWarManager:IsAlly(scoreData.serverId, leftInfo.serverId)
  local xOffset = isWinner and -20 or 20
  local yOffset = -18
  if isWinner then
    self.time:SetAlignment(CS.UnityEngine.TextAnchor.MiddleLeft)
    self.time:SetColorRGBA(0, 0.9647058823529412, 1, 1)
  else
    self.time:SetAlignment(CS.UnityEngine.TextAnchor.MiddleRight)
    self.time:SetColorRGBA(1, 0.5490196078431373, 0.4745098039215686, 1)
  end
  if configScore.type2 == 1 then
    self.info1:SetActive(false)
    self.info2:SetActive(true)
    self.info3:SetActive(false)
    self.info2:ReInit(configScore, config, serverBattleType, isWinner, scoreData)
    self.info2:SetAnchoredPositionXY(xOffset, yOffset)
  elseif configScore.type2 == 2 then
    self.info1:SetActive(true)
    self.info2:SetActive(false)
    self.info3:SetActive(false)
    self.info1:ReInit(configScore, config, serverBattleType, isWinner, scoreData)
    self.info1:SetAnchoredPositionXY(xOffset, yOffset)
  elseif configScore.type2 == 3 then
    self.info1:SetActive(false)
    self.info2:SetActive(false)
    self.info3:SetActive(true)
    self.info3:ReInit(configScore, config, serverBattleType, isWinner, scoreData, leftInfo, rightInfo)
    self.info3:SetAnchoredPositionXY(xOffset, yOffset)
  else
    self.info1:SetActive(false)
    self.info2:SetActive(false)
    self.info3:SetActive(false)
  end
  self.time:SetText(UITimeManager:GetInstance():TimeStampToTimeForServer(scoreData.time, false))
end

return UIServerBattleWeekItem
