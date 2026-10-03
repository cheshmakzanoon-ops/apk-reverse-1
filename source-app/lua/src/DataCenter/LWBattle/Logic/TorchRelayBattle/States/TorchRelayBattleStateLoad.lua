local FSMachine = require("Common.FSMachine")
local State = {}
State.__index = State
setmetatable(State, FSMachine.State)
local Const = require("Scene.LWBattle.Const")
local Resource = CS.GameEntry.Resource
local PVEScenePath = "Assets/Main/Prefabs/PVELevel/%s/scene.prefab"
local PVEDecorationPath = "Assets/Main/Prefabs/PVELevel/%s/decoration.bytes"
local TorchConstant = require("DataCenter/LWBattle/Logic/TorchRelayBattle/TorchRelayBattleConstant")
local Player = require("DataCenter/LWBattle/Logic/TorchRelayBattle/Player/TorchRelayBattlePlayer")

function State.Create()
  local copy = {}
  setmetatable(copy, State)
  copy:Init()
  return copy
end

function State:Init()
  self.syncCamera = false
  self.canInput = false
end

function State:OnExit()
  self.callBack = nil
end

function State:OnEnter(callBack)
  self.callBack = callBack
  self:LoadScene()
end

function State:LoadScene()
  local owner = self.owner
  self:LoadPlayer()
  self:LoadMainUI()
  self:LoadRecordLine()
  if owner then
    owner.staticMgr = CS.PVEStaticManager()
    owner.staticMgr:InitLW(10, 10)
    owner.staticMgr:SetVisibleChunk(TorchConstant.PRELOAD_GROUND_RANGE)
    owner:LoadSceneByCount(TorchConstant.INIT_LOAD_SCENE_COUNT, function()
      self:OnLoadComplete()
    end)
  end
end

function State:LoadPlayer()
  local owner = self.owner
  owner.player = Player.New(owner)
end

function State:LoadMainUI()
  local owner = self.owner
  if not UIManager:GetInstance():IsWindowOpen(UIWindowNames.TorchRelayBattleMain) then
    local param = {
      enterCallback = function()
        owner:OnStartGame()
      end,
      cheerData = owner.data.cheerData
    }
    UIManager:GetInstance():OpenWindow(UIWindowNames.TorchRelayBattleMain, {
      anim = true,
      UIMainAnim = UIMainAnimType.AllHide
    }, param)
  end
end

function State:LoadRecordLine()
  local owner = self.owner
  owner:InitRecordLine()
end

function State:OnLoadComplete()
  if self.callBack then
    self.callBack()
  end
  local owner = self.owner
  owner:ChangeState(owner.State.Ready)
end

function State:Dispose()
  local owner = self.owner
  if owner.staticMgr then
    owner.staticMgr:UnInit()
    owner.staticMgr = nil
  end
end

return State
