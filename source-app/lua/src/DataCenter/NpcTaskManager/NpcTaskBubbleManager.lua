local NpcTaskBubbleManager = BaseClass("NpcTaskBubbleManager")
local UINpcTaskBubble = require("UI.UINpcTaskBubble.UINpcTaskBubble")
local ResourceManager = CS.GameEntry.Resource
local NpcName = "CityNpc_nvzhubo"

local function __init(self)
  self.bubble = nil
  self.TaskPeopleIndex = nil
  self.isCreate = false
  
  function self.timer_action(temp)
    self:UpdateTaskBubble()
  end
  
  self.currentFollow = nil
  self:AddTimer()
  self:AddListener()
end

local function __delete(self)
  self.bubble = nil
  self.isCreate = nil
  self.currentFollow = nil
  self.TaskPeopleIndex = nil
  self:RemoveTaskBubble()
  self:RemoveTimer()
  self:RemoveListener()
end

local function StartUp(self)
end

local function AddTimer(self)
end

local function RemoveTimer(self)
end

local function AddTaskBubble(self)
  if self.request ~= nil or self.bubble ~= nil then
    return
  end
  if self.isCreate == false then
    return
  end
end

local function RemoveTaskBubble(self)
  if self.bubble ~= nil then
    self.bubble:OnDestroy()
    self.bubble = nil
  end
  if self.request ~= nil then
    self.request:Destroy()
    self.request = nil
  end
end

local function ClearBubble(self)
  self.bubble = nil
  self.request = nil
end

local function OnEnterCrossServer(data)
  DataCenter.NpcTaskBubbleManager:RemoveTaskBubble()
end

local function UpdateTaskBubble(self, param)
  local target = param.target
  self.currentFollow = target
  if not CS.SceneManager:IsInWorld() and not CS.SceneManager:IsInCity() then
    return
  end
  if CS.SceneManager.World == nil then
    return
  end
  local mainTask = DataCenter.TaskManager:IsHaveMainTask()
  if mainTask == false then
    return
  end
  local chapterId = DataCenter.ChapterTaskManager:GetCurChapterId()
  local allNum = DataCenter.ChapterTaskManager:GetAllNum()
  if 0 < allNum and chapterId < self.quest_earlyId then
    return
  end
  if self.currentFollow == nil then
    return
  end
  self:AddTaskBubble()
end

local function GetTaskBubbleObj(self)
  return self.bubble
end

local function IsTaskBubbleShow(self)
  return self.bubble and self.bubble:IsMainTaskRedShow()
end

local function AddListener(self)
  EventManager:GetInstance():AddListener(EventId.MainTaskSuccess, self.RefreshMainTaskRedNum)
  EventManager:GetInstance():AddListener(EventId.PveLevelExit, self.OnExitPveLevel)
  EventManager:GetInstance():AddListener(EventId.BuildMainZeroUpgradeSuccess, self.BuildMainZeroUpgradeSuccessSignal)
  EventManager:GetInstance():AddListener(EventId.OnEnterCrossServer, self.OnEnterCrossServer)
  EventManager:GetInstance():AddListener(EventId.OnQuitCrossServer, self.OnExitPveLevel)
  EventManager:GetInstance():AddListener(EventId.OnEnterWorld, self.OnEnterWorld)
  EventManager:GetInstance():AddListener(EventId.OnEnterCity, self.OnEnterCity)
end

local function RemoveListener(self)
  EventManager:GetInstance():RemoveListener(EventId.MainTaskSuccess, self.RefreshMainTaskRedNum)
  EventManager:GetInstance():RemoveListener(EventId.PveLevelExit, self.OnExitPveLevel)
  EventManager:GetInstance():RemoveListener(EventId.BuildMainZeroUpgradeSuccess, self.BuildMainZeroUpgradeSuccessSignal)
  EventManager:GetInstance():RemoveListener(EventId.OnEnterCrossServer, self.OnEnterCrossServer)
  EventManager:GetInstance():RemoveListener(EventId.OnQuitCrossServer, self.OnExitPveLevel)
  EventManager:GetInstance():RemoveListener(EventId.OnEnterWorld, self.OnEnterWorld)
  EventManager:GetInstance():RemoveListener(EventId.OnEnterCity, self.OnEnterCity)
end

local function OnExitPveLevel()
  DataCenter.NpcTaskBubbleManager:RemoveTaskBubble()
  if SceneUtils.GetIsInCity() then
    DataCenter.NpcTaskBubbleManager:AddTaskBubble()
  end
end

local function OnEnterWorld()
  DataCenter.NpcTaskBubbleManager:HideNpc()
end

local function OnEnterCity()
  DataCenter.NpcTaskBubbleManager:ShowNpc()
end

local function RefreshMainTaskRedNum()
  local bubble = DataCenter.NpcTaskBubbleManager:GetTaskBubbleObj()
  if bubble then
    if IsNull(bubble.request.gameObject) then
      if CS.SceneManager.IsInPVE() then
        return
      end
      DataCenter.NpcTaskBubbleManager:ClearBubble()
      DataCenter.NpcTaskBubbleManager:AddTaskBubble()
    else
      bubble:RefreshRed()
    end
  end
end

local function BuildMainZeroUpgradeSuccessSignal()
end

local function HideNpc(self)
  self.isCreate = false
  DataCenter.NpcTaskBubbleManager:RemoveTaskBubble()
  DataCenter.CityNpcManager:RemoveOneNpc(NpcName)
end

local function ShowNpc(self)
  DataCenter.NpcTaskBubbleManager:RemoveTaskBubble()
  DataCenter.CityNpcManager:RemoveOneNpc(NpcName)
end

NpcTaskBubbleManager.__init = __init
NpcTaskBubbleManager.__delete = __delete
NpcTaskBubbleManager.AddTaskBubble = AddTaskBubble
NpcTaskBubbleManager.RemoveTaskBubble = RemoveTaskBubble
NpcTaskBubbleManager.ClearBubble = ClearBubble
NpcTaskBubbleManager.UpdateTaskBubble = UpdateTaskBubble
NpcTaskBubbleManager.AddTimer = AddTimer
NpcTaskBubbleManager.RemoveTimer = RemoveTimer
NpcTaskBubbleManager.StartUp = StartUp
NpcTaskBubbleManager.GetTaskBubbleObj = GetTaskBubbleObj
NpcTaskBubbleManager.AddListener = AddListener
NpcTaskBubbleManager.RemoveListener = RemoveListener
NpcTaskBubbleManager.OnExitPveLevel = OnExitPveLevel
NpcTaskBubbleManager.RefreshMainTaskRedNum = RefreshMainTaskRedNum
NpcTaskBubbleManager.BuildMainZeroUpgradeSuccessSignal = BuildMainZeroUpgradeSuccessSignal
NpcTaskBubbleManager.OnEnterCrossServer = OnEnterCrossServer
NpcTaskBubbleManager.OnEnterWorld = OnEnterWorld
NpcTaskBubbleManager.OnEnterCity = OnEnterCity
NpcTaskBubbleManager.ShowNpc = ShowNpc
NpcTaskBubbleManager.HideNpc = HideNpc
NpcTaskBubbleManager.IsTaskBubbleShow = IsTaskBubbleShow
return NpcTaskBubbleManager
