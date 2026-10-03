local NoticeState = {}
local FSMachine = require("Common.FSMachine")
NoticeState.__index = NoticeState
setmetatable(NoticeState, FSMachine.State)

function NoticeState.Create()
  local copy = {}
  setmetatable(copy, NoticeState)
  copy:Init()
  return copy
end

local SURPRISE_VFX = "Assets/Main/Prefabs/LWOpeningStage/Eff_Surprise.prefab"

function NoticeState:Init()
  self.surpriseHandle = CS.GameEntry.Resource:InstantiateAsync(SURPRISE_VFX)
  self.surpriseHandle:completed("+", function(handle)
    handle:Destroy()
  end)
end

function NoticeState:Dispose()
  if not IsNull(self.surpriseHandle) then
    self.surpriseHandle:Destroy()
    self.surpriseHandle = nil
  end
end

function NoticeState:OnEnter(target)
  self.target = target
  self.delay = self.owner.boss and 0 or math.random() * 1
  if self.owner.stage == DataCenter.LWOpeningStageManager.MaxStageID and self.owner.boss then
    self.owner.animator:Play("show")
  else
    self.owner.animator:Play("idle")
  end
end

function NoticeState:OnUpdate(deltaTime)
  if self.delay > 0 then
    self.delay = self.delay - deltaTime
    if self.delay <= 0 then
      if not IsNull(self.surpriseHandle) then
        self.surpriseHandle:Destroy()
      end
      self.surpriseHandle = CS.GameEntry.Resource:InstantiateAsync(SURPRISE_VFX)
      self.surpriseHandle:completed("+", function(handle)
        if self.owner == nil or IsNull(self.owner.transform) then
          return
        end
        handle.gameObject.transform.position = self.owner.transform.position + Vector3(0, 3, 0)
        handle.gameObject.transform.localScale = Vector3(1, 1, 1)
        handle.gameObject.transform:DOScale(Vector3(0.5, 1.8, 1), 0.15):SetLoops(2, CS.DG.Tweening.LoopType.Yoyo)
      end)
    end
  else
    local targetPos = self.target.position
    local selfPos = self.owner.transform.position
    local dir = targetPos - selfPos
    if dir.x == 0 and dir.z == 0 then
      return
    end
    dir = Vector3(dir.x, 0, dir.z)
    local rot = Quaternion.LookRotation(dir)
    self.owner.transform.rotation = Quaternion.Slerp(self.owner.transform.rotation, rot, deltaTime * 10)
  end
end

function NoticeState:OnExit()
  self.target = nil
end

return NoticeState
