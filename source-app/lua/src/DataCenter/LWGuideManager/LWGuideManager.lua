local LWGuideManager = BaseClass("LWGuideManager")
local LWGuideUtil = require("DataCenter.LWGuideManager.LWGuideUtil")
local nowTime
local lasterTime = 0
local maxTimeOffset = 7
local offsetTime
local relaxGuideTable = {}

local function __init(self)
  self.guideId = 0
  self.curGuideId = 0
  self.isStart = false
  self.AddListener(self)
  self.AddListenersUpdate(self)
end

local function __delete(self)
  self.guideId = 0
  self.curGuideId = 0
  self.RemoveListener(self)
  self.isStart = false
  LWGuideUtil:ClearData()
  UpdateManager:GetInstance():RemoveUpdate(self.OnUpdate)
end

local function GuideFire(self, isInit)
  if self.curGuideId == GuideState.LevelOne then
    DataCenter.LWBattleManager:Destroy()
    self:ClearData()
    LWGuideUtil:OnLevelOne()
  elseif self.curGuideId == GuideState.OpeningDebut then
    LWGuideUtil:OnOpeningDebut()
  end
end

local function GetCurGuideId(self)
  return self.curGuideId
end

local function GetIsInGuide(self)
  return self.guideId ~= -1
end

local function UpdateGuide(self, message)
  if message.lwGuideRecord then
    self.guideId = tonumber(message.lwGuideRecord) or 0
    self.curGuideId = self.guideId + 1
  end
end

local function InitData(self, message)
  UpdateGuide(self, message)
  local relaxGuide = LuaEntry.DataConfig:TryGetStr("relax_guide", "k1", "")
  if not string.IsNullOrEmpty(relaxGuide) then
    relaxGuideTable = {}
    local data = string.split(relaxGuide, ",")
    if table.count(data) >= 2 then
      local levelArray = string.split(data[1], "|")
      local timeArray = string.split(data[2], "|")
      local count = table.count(levelArray)
      for i = 1, count do
        relaxGuideTable[tonumber(levelArray[i])] = tonumber(timeArray[i]) / 1000
      end
    end
  end
  if self.curGuideId == GuideState.LevelOne then
    if DataCenter.LWOpeningStageManager:IsAllDone() then
      DataCenter.LWOpeningStageManager:ResetDataAndSyncServer(0)
    end
  else
    local oldAccountProtect = message.openingStageInfo == nil and self.curGuideId > GuideState.LevelOne
    if oldAccountProtect then
      local serverStageId = DataCenter.LWOpeningStageManager.MaxStageID
      DataCenter.LWOpeningStageManager:ResetDataAndSyncServer(serverStageId)
    end
  end
  if self.curGuideId == GuideState.LevelOne then
    GuideFire(self, true)
  end
  EventManager:GetInstance():Broadcast(EventId.GuideInitFinish)
end

local function BuildInView(bUuid)
  local buildData = DataCenter.BuildManager:GetBuildingDataByUuid(bUuid)
  if buildData.itemId == BuildingTypes.Lw_BUILD_BATTLE_FEATURE_ENTRY and (DataCenter.LWGuideManager:GetCurGuideId() == GuideState.Soldier or DataCenter.LWGuideManager:GetCurGuideId() == GuideState.CityCopter) and UIManager:GetInstance():IsWindowOpen(UIWindowNames.UIMain) then
    DataCenter.LWGuideManager:GuideFire()
  end
end

local function OnEnterBattle()
  LWGuideUtil:ClearData()
  if DataCenter.LWGuideManager:GetCurGuideId() == GuideState.LevelOne then
    LWGuideUtil:LoadGuideTimeLine()
  end
end

local function OnParkourBattleWin(id)
  LWGuideUtil:BattleWinUpdateGuide(id)
end

local function OnCountBattleWin(id)
  LWGuideUtil:BattleWinUpdateGuide(id)
end

local function GuideStartGame()
  LWGuideUtil:GuideStartGame()
end

local function OnEnterGame()
end

local function AddListenersUpdate(self)
  UpdateManager:GetInstance():AddUpdate(self.OnUpdate)
end

local isShowArrow

local function OnEnterCity()
  isShowArrow = false
  lasterTime = Time.time
end

local function OnUpdate()
  if not CS.SceneManager.IsInCity() then
    return
  end
  local mainLevel = DataCenter.BuildManager:GetMainLevel()
  if relaxGuideTable and relaxGuideTable[mainLevel] then
    maxTimeOffset = relaxGuideTable[mainLevel]
  else
    if isShowArrow then
      EventManager:GetInstance():Broadcast(EventId.StopShowQuestArrow)
      isShowArrow = false
    end
    return
  end
  nowTime = Time.time
  if CS.UnityEngine.Input.anyKey or DataCenter.LWGuideFlowManager:IsRunning() then
    lasterTime = nowTime
    if isShowArrow then
      EventManager:GetInstance():Broadcast(EventId.StopShowQuestArrow)
    end
    isShowArrow = false
  end
  if not isShowArrow then
    offsetTime = Mathf.Abs(nowTime - lasterTime)
    if offsetTime > maxTimeOffset then
      EventManager:GetInstance():Broadcast(EventId.NoInputShowArrow)
      isShowArrow = true
    end
  end
end

local function GetIsStart(self)
  return self.isStart
end

local function SetIsStart(self, isStart)
  self.isStart = isStart
end

local function OnLanLock(id)
  if id == 2 then
    local t = {
      lwGuideRecord = GuideState.Soldier
    }
    DataCenter.LWGuideManager:UpdateGuide(t)
    SFSNetwork.SendMessage(MsgDefines.LWSaveGuide, GuideState.Soldier)
    DataCenter.LWGuideManager:GuideFire()
  end
end

local function OnOldGuideDone()
  LWGuideUtil:OnCityCopter_New2_Done()
end

local function AddListener(self)
  EventManager:GetInstance():AddListener(EventId.PveLevelEnter, self.OnEnterBattle)
  EventManager:GetInstance():AddListener(EventId.BUILD_IN_VIEW, self.BuildInView)
  EventManager:GetInstance():AddListener(EventId.ParkourBattleWin, self.OnParkourBattleWin)
  EventManager:GetInstance():AddListener(EventId.GF_count_battle_win, self.OnCountBattleWin)
  EventManager:GetInstance():AddListener(EventId.Unlandlock, self.OnLanLock)
  EventManager:GetInstance():AddListener(EventId.GF_old_guide_done, self.OnOldGuideDone)
  EventManager:GetInstance():AddListener(EventId.OnEnterCity, self.OnEnterCity)
end

local function RemoveListener(self)
  EventManager:GetInstance():RemoveListener(EventId.PveLevelEnter, self.OnEnterBattle)
  EventManager:GetInstance():RemoveListener(EventId.BUILD_IN_VIEW, self.BuildInView)
  EventManager:GetInstance():RemoveListener(EventId.ParkourBattleWin, self.OnParkourBattleWin)
  EventManager:GetInstance():RemoveListener(EventId.GF_count_battle_win, self.OnCountBattleWin)
  EventManager:GetInstance():RemoveListener(EventId.Unlandlock, self.OnLanLock)
  EventManager:GetInstance():RemoveListener(EventId.GF_old_guide_done, self.OnOldGuideDone)
  EventManager:GetInstance():RemoveListener(EventId.OnEnterCity, self.OnEnterCity)
end

local function ClearData()
  LWGuideUtil:ClearData()
end

local function CheckShowFinger()
  return isShowArrow or false
end

LWGuideManager.__init = __init
LWGuideManager.__delete = __delete
LWGuideManager.GetIsInGuide = GetIsInGuide
LWGuideManager.GetCurGuideId = GetCurGuideId
LWGuideManager.UpdateGuide = UpdateGuide
LWGuideManager.AddListener = AddListener
LWGuideManager.InitData = InitData
LWGuideManager.GetIsStart = GetIsStart
LWGuideManager.SetIsStart = SetIsStart
LWGuideManager.OnEnterBattle = OnEnterBattle
LWGuideManager.GuideFire = GuideFire
LWGuideManager.BuildInView = BuildInView
LWGuideManager.OnParkourBattleWin = OnParkourBattleWin
LWGuideManager.OnCountBattleWin = OnCountBattleWin
LWGuideManager.GuideStartGame = GuideStartGame
LWGuideManager.OnEnterGame = OnEnterGame
LWGuideManager.RemoveListener = RemoveListener
LWGuideManager.OnLanLock = OnLanLock
LWGuideManager.ClearData = ClearData
LWGuideManager.AddListenersUpdate = AddListenersUpdate
LWGuideManager.OnUpdate = OnUpdate
LWGuideManager.OnOldGuideDone = OnOldGuideDone
LWGuideManager.OnEnterCity = OnEnterCity
LWGuideManager.CheckShowFinger = CheckShowFinger
return LWGuideManager
