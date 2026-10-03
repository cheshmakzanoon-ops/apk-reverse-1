local UIInteractionBubbleView = BaseClass("UIInteractionBubbleView", UIBaseView)
local base = UIBaseView
local InteractionBubble = require("UI.UIInteractionBubble.Component.InteractionBubble")
local FSM = require("Framework.Common.FSM")
local StateIdle = require("UI.UIInteractionBubble.State.StateIdle")
local StateInOut = require("UI.UIInteractionBubble.State.StateInOut")
local StateUp = require("UI.UIInteractionBubble.State.StateUp")
local MAX_BUBBLE_NUM = 3

function UIInteractionBubbleView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UIInteractionBubbleView:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIInteractionBubbleView:ComponentDefine()
  self.slot = {}
  for i = 1, 7 do
    self.slot[i] = self:AddComponent(UIBaseComponent, "Bg/Slots/Slot" .. i)
  end
  self.root = self:AddComponent(UIBaseContainer, "Bg/Root")
  self.bubbles = {}
  self.requests = {}
  self.flyOutTaskQueue = {}
end

function UIInteractionBubbleView:ComponentDestroy()
  self.root:RemoveComponents(InteractionBubble)
  for k, req in pairs(self.requests) do
    self:GameObjectDestroy(req)
  end
  self.requests = nil
  self.slot = nil
  self.root = nil
  self.flyOutTaskQueue = nil
  self.bubbles = nil
end

function UIInteractionBubbleView:DataDefine()
  self.fsm = FSM.New()
  self.fsm:AddState(UIInteractionBubbleState.Idle, StateIdle.New(self))
  self.fsm:AddState(UIInteractionBubbleState.InOut, StateInOut.New(self))
  self.fsm:AddState(UIInteractionBubbleState.Up, StateUp.New(self))
  self.fsm:ChangeState(ZombieState.Idle)
end

function UIInteractionBubbleView:DataDestroy()
  if self.timerFlyUp then
    self.timerFlyUp:Stop()
    self.timerFlyUp = nil
  end
  if self.fsm then
    self.fsm:Delete()
    self.fsm = nil
  end
end

function UIInteractionBubbleView:Update()
  if self.fsm then
    self.fsm:OnUpdate()
  end
end

function UIInteractionBubbleView:HasFlyOutTask()
  return self.flyOutTaskQueue[1]
end

function UIInteractionBubbleView:TopBubbleEnqueueFlyOut()
  local topBubble = self.bubbles[MAX_BUBBLE_NUM]
  if not topBubble then
    Logger.LogError("TopBubbleEnqueueFlyOut:topBubble is nil")
    return
  end
  table.insert(self.flyOutTaskQueue, topBubble)
end

function UIInteractionBubbleView:FlyOutTaskEnqueue(bubble)
  if not table.hasvalue(self.flyOutTaskQueue, bubble) then
    table.insert(self.flyOutTaskQueue, bubble)
  end
end

function UIInteractionBubbleView:ExecuteAllFlyOutTask()
  for k, v in pairs(self.flyOutTaskQueue) do
    v:FlyOut()
  end
  self.flyOutTaskQueue = {}
end

function UIInteractionBubbleView:DestroyBubble(bubble)
  self.root:RemoveComponent(bubble:GetName(), InteractionBubble)
  for pos, v in pairs(self.bubbles) do
    if v == bubble then
      self.bubbles[pos] = nil
      self:GameObjectDestroy(self.requests[pos])
      self.requests[pos] = nil
      break
    end
  end
  if table.count(self.bubbles) == 0 and not DataCenter.InteractionBubbleManager:HasFlyInTask() then
    self.ctrl:CloseSelf()
  end
end

function UIInteractionBubbleView:IsAllEmpty()
  return table.count(self.requests) == 0
end

function UIInteractionBubbleView:GetMaxBubbleNum()
  return MAX_BUBBLE_NUM
end

function UIInteractionBubbleView:IsBottomEmpty()
  return not self.requests[1]
end

function UIInteractionBubbleView:IsFull()
  return table.count(self.requests) == MAX_BUBBLE_NUM
end

function UIInteractionBubbleView:CreateBubbleAndFlyIn(pos, data)
  self.requests[pos] = self:GameObjectInstantiateAsync(UIAssets.InteractionBubble, function(req)
    if req == nil or IsNull(req.gameObject) then
      return
    end
    local go = req.gameObject
    NameCount = NameCount + 1
    go.name = "InteractionBubble" .. NameCount
    go:SetActive(true)
    go.transform:SetParent(self.root.transform)
    go.transform:Set_localScale(1, 1, 1)
    go.transform.position = self.slot[pos].transform.position
    local bubble = self.root:AddComponent(InteractionBubble, go.name)
    self.bubbles[pos] = bubble
    bubble:Init(data)
  end)
end

function UIInteractionBubbleView:CreateBottomBubbleAndFlyIn(data)
  self:CreateBubbleAndFlyIn(1, data)
end

function UIInteractionBubbleView:AllBubbleUp()
  local max = MAX_BUBBLE_NUM
  for pos = 1, MAX_BUBBLE_NUM do
    if self.bubbles[pos] == nil then
      max = pos - 1
      break
    end
  end
  for pos = 1, max do
    self.bubbles[pos].transform:DOMove(self.slot[pos + 1].transform.position, UIInteractionBubbleFlyUpTime):SetEase(CS.DG.Tweening.Ease.OutCubic)
  end
  self.timerFlyUp = TimerManager:GetInstance():DelayInvoke(function()
    for i = max + 1, 1, -1 do
      self.bubbles[i] = self.bubbles[i - 1]
      self.requests[i] = self.requests[i - 1]
    end
    self.fsm:ChangeState(UIInteractionBubbleState.Idle)
  end, UIInteractionBubbleFlyUpTime)
end

return UIInteractionBubbleView
