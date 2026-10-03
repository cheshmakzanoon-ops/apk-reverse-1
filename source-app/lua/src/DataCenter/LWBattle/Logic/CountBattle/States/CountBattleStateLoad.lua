local FSMachine = require("Common.FSMachine")
local State = {}
State.__index = State
setmetatable(State, FSMachine.State)
local Consts = require("DataCenter.LWBattle.Logic.CountBattle.CountBattleConsts")
local Resource = CS.GameEntry.Resource
local PVEScenePath = "Assets/Main/Prefabs/PVELevel/%s/scene.prefab"
local PVEDecorationPath = "Assets/Main/Prefabs/PVELevel/%s/decoration.bytes"

function State.Create()
  local copy = {}
  setmetatable(copy, State)
  copy:Init()
  return copy
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
  owner.staticMgr = CS.PVEStaticManager()
  owner.staticMgr:InitLW(10, 10)
  owner.staticMgr:SetVisibleChunk(3)
  self.sceneLoadRequest = {}
  local finishedScene = 0
  for _, sceneCfg in ipairs(owner.cfg.sceneCfgs) do
    local req = Resource:InstantiateAsync(string.format(PVEScenePath, sceneCfg.asset))
    req:completed("+", function()
      local sceneRoot = req.gameObject.transform
      sceneRoot:Set_position(0, 0, sceneCfg.offset)
      finishedScene = finishedScene + 1
      if finishedScene >= #owner.cfg.sceneCfgs then
        self:LoadPlayerGroup()
        self:LoadMainUI()
        if owner.cfg.sound_id_bgm == 0 then
          Logger.LogError("CM\229\133\179\229\141\161bgm\228\184\186\231\169\186\239\188\140levelId=" .. owner.cfg.levelId)
        else
          CommonUtil.ClearGameBgMusicData()
          DataCenter.LWSoundManager:PlayMusicById(owner.cfg.sound_id_bgm, true)
        end
        if owner.param.firstGuideStage then
          owner.fsm:Switch("Guide", self.callBack)
        else
          owner.fsm:Switch("Ready", self.callBack)
        end
      end
    end)
    table.insert(self.sceneLoadRequest, req)
    owner.staticMgr:Append(string.format(PVEDecorationPath, sceneCfg.asset), sceneCfg.offset)
  end
  local nightColor = owner.cfg.nightColor
  if nightColor and type(nightColor) == "table" and #nightColor == 4 then
    CS.SceneManager.SetNightColor(nightColor[1], nightColor[2], nightColor[3], nightColor[4])
  end
end

function State:LoadPlayerGroup()
  local owner = self.owner
  owner.playerGroupProxy = owner:CreateSteerGroup(owner.cfg.playerGroupCfg, "player", "PLAYER", Consts.DEFAULT_REP_FACTOR, Consts.DEFAULT_ATT_FACTOR, true, true)
  for _, initSoilderCfg in ipairs(owner.cfg.initSoilderCfgs) do
    owner.playerGroupProxy:DoSpawn(initSoilderCfg.amount, initSoilderCfg.raw)
  end
  owner.playerGroupProxy:SetBubbleVisible(false)
  owner.playerGroupProxy:SetUnitsVisible(false)
end

function State:LoadMainUI()
  if not UIManager:GetInstance():IsWindowOpen(UIWindowNames.LWCountBattleMain) then
    local isFirstStage = DataCenter.LWGuideManager:GetCurGuideId() == GuideState.LevelOne
    if not isFirstStage then
      UIManager:GetInstance():OpenWindow(UIWindowNames.LWCountBattleMain, {
        anim = true,
        UIMainAnim = UIMainAnimType.AllHide
      }, {
        showGuide = self.owner.param.firstGuideStage
      })
    end
  end
end

function State:Dispose()
  local owner = self.owner
  if owner.staticMgr then
    owner.staticMgr:UnInit()
    owner.staticMgr = nil
  end
  if self.sceneLoadRequest then
    for _, sceneReq in pairs(self.sceneLoadRequest) do
      sceneReq:Destroy()
    end
    self.sceneLoadRequest = nil
  end
end

return State
