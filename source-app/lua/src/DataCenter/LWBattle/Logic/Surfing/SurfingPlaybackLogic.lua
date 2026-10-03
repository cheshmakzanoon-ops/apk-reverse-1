local base = require("DataCenter.LWBattle.Logic.Surfing.SurfingLogic")
local SurfingPlaybackLogic = BaseClass("SurfingPlaybackLogic", base)
local SurfingPbMonsterManager = require("Scene.LWBattle.Surfing.Monster.SurfingPbMonsterManager")
local SurfingData = require("DataCenter.LWBattle.Logic.Surfing.SurfingData")
local SurfingPBPlayerUnit = require("Scene.LWBattle.Surfing.SurfingPBPlayerUnit")
local Const = require("Scene.LWBattle.Const")
local Queue = require("DataCenter.LWBattle.Logic.Surfing.Queue")

function SurfingPlaybackLogic:__init()
  base.__init(self)
  self.isPlayback = true
  self.buffInfo = nil
end

function SurfingPlaybackLogic:__delete()
  base.__delete(self)
  self.isPlayback = nil
  self.buffInfo = nil
end

function SurfingPlaybackLogic:InitMonsterManager()
  self.monsterMgr = SurfingPbMonsterManager.New()
end

function SurfingPlaybackLogic:InitData(param)
  local SurfingLogger = require("Scene.LWBattle.Surfing.SurfingLogger")
  self.surfingLogger = SurfingLogger.New(PVELogFuncType.Surfing, self.isEditor, self.isDebug)
  self.gm = false
  if param then
    ProfilerUtil.BeginSample("SurfingLogic:ReadLog")
    local fileName = param.fileName
    local recordInfo = self.surfingLogger:ReadSubRecords(fileName)
    self.recordInfo = recordInfo
    local ids = self:InitSceneIds(fileName)
    ProfilerUtil.EndSample()
    if recordInfo then
      local levelId = recordInfo.header and recordInfo.header.stageId
      self.gm = recordInfo.header.gm == 1
      self.data = SurfingData.New(self, levelId, ids, param, self.speedChangeTime)
      self.buffInfo = recordInfo.buffInfo
      local exitInfo = recordInfo.exitInfo
      self.exitQueue = Queue.new()
      if exitInfo then
        for _, v in ipairs(exitInfo) do
          self.exitQueue:enqueue(v)
        end
      end
      if self.data then
        self.data:InsertMonsterIds(recordInfo.objInfo)
      end
    end
  end
end

function SurfingPlaybackLogic:InitSceneIds(fileName)
  local content = self.surfingLogger:GetSceneIds(fileName)
  if string.IsNullOrEmpty(content) then
    Logger.LogError("cannot find scene id config")
    return
  end
  local ids = string.split(content, ",")
  if ids then
    local result = {}
    for i, v in ipairs(ids) do
      result[i] = tonumber(v)
    end
    return result
  end
end

function SurfingPlaybackLogic:OnUpdate()
  base.OnUpdate(self)
  if self.exitInfo == nil then
    self.exitInfo = self.exitQueue:dequeue()
  end
  if self.exitInfo and self.exitInfo.deadTimer <= self.totalRunTime then
    if self.exitInfo.exitFlag == EXIT_FLAGS.EXIT then
      self:ChangeState(Const.SurfingState.Pause)
    elseif self.exitInfo.exitFlag == EXIT_FLAGS.RESURGENCE then
      self:Resurgence()
    elseif self.exitInfo.exitFlag == EXIT_FLAGS.LOSE then
      self.player:ChangeToDie()
    end
    self.exitInfo = nil
  end
end

function SurfingPlaybackLogic:AutoMove()
end

function SurfingPlaybackLogic:CheckSceneData(oldIndex)
  if oldIndex % 5 == 0 then
    self:ReadSubRecords()
    return true
  end
  return false
end

function SurfingPlaybackLogic:ReadSubRecords()
  local fileName = self.param and self.param.fileName
  if not self.surfingLogger then
    return
  end
  local recordInfo = self.surfingLogger:ReadSubRecords(fileName)
  self.recordInfo = recordInfo
  if recordInfo then
    self.data:InsertMonsterIds(recordInfo.objInfo)
    self.player:UpdateRecordData(recordInfo.frameInfo)
    local exitInfo = recordInfo.exitInfo
    if exitInfo then
      for _, v in ipairs(exitInfo) do
        self.exitQueue:enqueue(v)
      end
    end
  end
end

function SurfingPlaybackLogic:LoadPlayer()
  self.player = SurfingPBPlayerUnit.New()
  if self.recordInfo then
    self.player:Init(self, self.recordInfo.frameInfo, self.recordInfo.eventInfo)
  else
    self.player:Init(self)
  end
  self:AddUnit(self.player)
end

function SurfingPlaybackLogic:OnPlayerDeath()
  self:ChangeState(Const.SurfingState.Lose)
end

function SurfingPlaybackLogic:Resurgence()
  self.player:ShowUnitEffect(SurfingUnitEffectType.Resurgence)
  self.player:Resurgence()
  self:ClearMonstersByOffset()
end

function SurfingPlaybackLogic:UpdateKeyboard()
end

function SurfingPlaybackLogic:UpdateCheck(deltaTime)
end

function SurfingPlaybackLogic:TryCheckObj(bornId, monsterId, oriId)
end

function SurfingPlaybackLogic:InitTouchInput()
end

function SurfingPlaybackLogic:UnInitTouchInput()
end

function SurfingPlaybackLogic:InitInviteAllyData(param)
end

function SurfingPlaybackLogic:EndStage(endZ)
end

function SurfingPlaybackLogic:SaveLog()
end

function SurfingPlaybackLogic:LogSceneIds()
end

function SurfingPlaybackLogic:ExitSurfing()
end

function SurfingPlaybackLogic:GetBuffLevel(type)
  if self.buffInfo then
    return self.buffInfo[type]
  end
end

return SurfingPlaybackLogic
