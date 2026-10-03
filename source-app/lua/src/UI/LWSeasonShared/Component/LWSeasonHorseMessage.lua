local base = UIBaseContainer
local LWSeasonHorseMessage = BaseClass("LWSeasonHorseMessage", base)

function LWSeasonHorseMessage:OnCreate()
  base.OnCreate(self)
  self.horse_text = self:AddComponent(UITextMeshProUGUIEx, "HorseText")
  self.horse_text:SetActive(false)
  self.theItemPool = self.horse_text.gameObject
  self.theItemPool:GameObjectCreatePool()
  self.nodePool = {}
  self.mirrorFactor = CommonUtil.ArabicAutoMirrorFactor()
end

function LWSeasonHorseMessage:OnDestroy()
  if self.nodePool then
    for _, v in pairs(self.nodePool) do
      if v and v.tweenSeq ~= nil then
        v.tweenSeq:Kill()
        v.tweenSeq = nil
      end
    end
    self.nodePool = nil
  end
  self:RemoveComponents(UITextMeshProUGUIEx)
  self.theItemPool:GameObjectRecycleAll()
  self.horse_text = nil
  base.OnDestroy(self)
end

function LWSeasonHorseMessage:SetMessageList(msgList)
  if msgList then
    self.msgList = msgList
    self.msgCursor = 1
    self:ShowNext()
  end
end

function LWSeasonHorseMessage:Update1000MS()
  self:ShowNext()
end

function LWSeasonHorseMessage:InitLineData()
  if self.lineDict == nil then
    local _, height = self:GetSizeDeltaXY()
    local lineHeight = 70
    local lineCount = math.ceil(height / lineHeight)
    local maxY = toInt((height - lineHeight + 18) / 2)
    local lineDict = {}
    for lineNum = 1, lineCount do
      local y = maxY - lineHeight * (lineNum - 1)
      if maxY >= math.abs(y) then
        table.insert(lineDict, y)
      end
    end
    self.lineDict = lineDict
  end
end

function LWSeasonHorseMessage:TryGetEmptyLine()
  if self.lineDict == nil then
    self:InitLineData()
  end
  local can_use_Y
  for _, y in ipairs(self.lineDict) do
    can_use_Y = y
    for _, v in pairs(self.nodePool) do
      if v.y == y then
        can_use_Y = nil
        break
      end
    end
    if can_use_Y ~= nil then
      return can_use_Y
    end
  end
  return nil
end

function LWSeasonHorseMessage:CreateTextNode(msg)
  if msg == nil or msg == "" then
    return nil
  end
  local idleOne
  if self.nodePool then
    for _, v in pairs(self.nodePool) do
      if v.msg == msg then
        return nil
      end
      if v and v.tweenSeq == nil and v.y == nil and v.txtNode ~= nil then
        idleOne = v
      end
    end
    if idleOne ~= nil then
      idleOne.msg = msg
      idleOne.txtNode:SetText(msg)
      idleOne.txtNode:SetActive(true)
      return idleOne
    end
  end
  local goItem, theTextItem
  goItem = self.theItemPool:GameObjectSpawn(self.transform)
  goItem.name = "txt_" .. UIUtil.GetLoopListItemIndex()
  theTextItem = self:AddComponent(UITextMeshProUGUIEx, goItem.name)
  theTextItem:SetText(msg)
  theTextItem:SetActive(true)
  idleOne = {
    msg = msg,
    txtNode = theTextItem,
    go = goItem,
    y = nil,
    tweenSeq = nil
  }
  table.insert(self.nodePool, idleOne)
  return idleOne
end

function LWSeasonHorseMessage:ShowNext()
  if self.nodePool and self.horse_text and self.theItemPool and self.msgList then
    local msgCount = #self.msgList
    if msgCount < 5 then
      return
    end
    local can_use_Y = self:TryGetEmptyLine()
    if can_use_Y == nil then
      return
    end
    local node = self:CreateTextNode(self.msgList[self.msgCursor])
    if node then
      self:SetHorseRaceLamp(node, can_use_Y)
    end
    self.msgCursor = self.msgCursor + 1
    if msgCount < self.msgCursor then
      self.msgCursor = 1
    end
  end
end

local QUEST_ENTRY_WIDTH_Min = 880
local QUEST_START_POS_X = 430
local QUEST_ENTRY_ROLLING_Time_MIN = 6
local QUEST_ENTRY_ROLLING_Time_MAX = 13
local QUEST_ENTRY_ROLLING_DELAY = 0
local QUEST_ENTRY_ROLLING_HOLD = 0.33

function LWSeasonHorseMessage:SetHorseRaceLamp(horseNode, y)
  local horse_text = horseNode.txtNode
  local rectTransform = horse_text.rectTransform
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(rectTransform)
  local rawWidth = horse_text:GetWidth()
  local Difference = rawWidth - QUEST_ENTRY_WIDTH_Min
  local endPosX = (-1300 - Difference) * self.mirrorFactor
  local startPosX = QUEST_START_POS_X * self.mirrorFactor
  if CommonUtil.IsArabic() and self.mirrorFactor == 1 then
    startPosX = endPosX
    endPosX = QUEST_START_POS_X
  end
  local useTime = math.random(QUEST_ENTRY_ROLLING_Time_MIN, QUEST_ENTRY_ROLLING_Time_MAX)
  if horseNode.tweenSeq then
    horseNode.tweenSeq:Kill()
  end
  rectTransform:Set_anchoredPosition(startPosX, y)
  local tweenSeq = DOTween.Sequence()
  tweenSeq:AppendInterval(QUEST_ENTRY_ROLLING_DELAY)
  tweenSeq:Append(rectTransform:DOAnchorPosX(endPosX * 0.7, useTime * 0.7):SetEase(CS.DG.Tweening.Ease.Linear))
  tweenSeq:AppendCallback(function()
    horseNode.y = nil
  end)
  tweenSeq:Append(rectTransform:DOAnchorPosX(endPosX, useTime * 0.3):SetEase(CS.DG.Tweening.Ease.Linear))
  tweenSeq:AppendInterval(QUEST_ENTRY_ROLLING_HOLD)
  
  function tweenSeq.onComplete()
    horseNode.tweenSeq = nil
    horseNode.msg = nil
    horseNode.y = nil
  end
  
  horseNode.y = y
  horseNode.tweenSeq = tweenSeq
end

return LWSeasonHorseMessage
