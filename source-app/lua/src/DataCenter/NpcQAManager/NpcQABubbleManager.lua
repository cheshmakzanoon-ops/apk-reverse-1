local NpcQABubbleManager = BaseClass("NpcQABubbleManager")
local UINpcQABubble = require("UI.UINpcQABubble.UINpcQABubble")
local ResourceManager = CS.GameEntry.Resource
local NpcName = "CityNpc_nvzhubo"

local function __init(self)
  self.bubble = nil
  self.showFlag = true
  self:AddListener()
end

local function __delete(self)
  self.bubble = nil
  self.showFlag = nil
  self:RemoveQuestionBubble()
  self:RemoveListener()
end

local function AddListener(self)
  EventManager:GetInstance():AddListener(EventId.NPCQuestBubbleNeedRefresh, self.DoWhenQuestionNeedRefresh)
end

local function RemoveListener(self)
  EventManager:GetInstance():RemoveListener(EventId.NPCQuestBubbleNeedRefresh, self.DoWhenQuestionNeedRefresh)
end

local function StartUp(self)
end

local function DoWhenQuestionNeedRefresh()
end

local function AddQuestionBubble(self)
  if self.request ~= nil or self.bubble ~= nil then
    return
  end
end

local function RemoveQuestionBubble(self)
  if self.bubble ~= nil then
    self.bubble:OnDestroy()
    self.bubble = nil
  end
  if self.request ~= nil then
    if self.request.gameObject ~= nil then
      self.request.gameObject:Destroy()
    end
    self.request = nil
  end
end

local function SetQuestionBubbleFlag(self, flag)
  self.showFlag = flag
  if not self.showFlag then
    self:RemoveQuestionBubble()
    return
  end
end

local function IsNpcQABubbleShow(self)
  return self.request ~= nil and self.bubble ~= nil
end

NpcQABubbleManager.__init = __init
NpcQABubbleManager.__delete = __delete
NpcQABubbleManager.AddQuestionBubble = AddQuestionBubble
NpcQABubbleManager.RemoveQuestionBubble = RemoveQuestionBubble
NpcQABubbleManager.StartUp = StartUp
NpcQABubbleManager.SetQuestionBubbleFlag = SetQuestionBubbleFlag
NpcQABubbleManager.AddListener = AddListener
NpcQABubbleManager.RemoveListener = RemoveListener
NpcQABubbleManager.DoWhenQuestionNeedRefresh = DoWhenQuestionNeedRefresh
NpcQABubbleManager.IsNpcQABubbleShow = IsNpcQABubbleShow
return NpcQABubbleManager
