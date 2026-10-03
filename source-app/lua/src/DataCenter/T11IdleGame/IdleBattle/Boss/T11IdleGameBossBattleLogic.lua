local T11IdleGameBossBattleLogic = BaseClass("T11IdleGameBossBattleLogic")
local FSMachine = require("Common.FSMachine")
local Camera = CS.UnityEngine.Camera
local Screen = CS.UnityEngine.Screen
local RenderTextureFormat = CS.UnityEngine.RenderTextureFormat
local RenderTexture = CS.UnityEngine.RenderTexture
local ResourceManager = CS.GameEntry.Resource
local Localization = CS.GameEntry.Localization
local Const = require("DataCenter/T11IdleGame/IdleBattle/T11IdleGameIdleBattleConstant")
local InitState = require("DataCenter/T11IdleGame/IdleBattle/Boss/State/T11IdleGameBossBattleStateInit")
local MatchInitState = require("DataCenter/T11IdleGame/IdleBattle/Boss/State/T11IdleGameBossBattleStateMatchInit")
local MatchReadyState = require("DataCenter/T11IdleGame/IdleBattle/Boss/State/T11IdleGameBossBattleStateMatchReady")
local MatchFightState = require("DataCenter/T11IdleGame/IdleBattle/Boss/State/T11IdleGameBossBattleStateMatchFight")
local MatchStrikeState = require("DataCenter/T11IdleGame/IdleBattle/Boss/State/T11IdleGameBossBattleStateMatchStrike")
local MatchEndState = require("DataCenter/T11IdleGame/IdleBattle/Boss/State/T11IdleGameBossBattleStateMatchEnd")
local T11IdleGameBossBattleSquad = require("DataCenter/T11IdleGame/IdleBattle/Boss/Soldier/T11IdleGameBossBattleSquad")
local T11IdleGameBossBattleBoss = require("DataCenter/T11IdleGame/IdleBattle/Boss/Boss/T11IdleGameBossBattleBoss")

function T11IdleGameBossBattleLogic:__init()
  self.param = nil
  self.sceneRootReq = nil
  self.sceneCamera = nil
  self.sceneCameraAnim = nil
  self.sceneRoot = nil
  self.soldierRoot = nil
  self.bossRoot = nil
  self.renderTexture = nil
  self.squad = nil
  self.boss = nil
  self.mainView = nil
  self.battleUIComponent = nil
  self.isAutoModeOn = false
  self.rewardDataCache = {}
end

function T11IdleGameBossBattleLogic:__delete()
  self:Destroy()
end

function T11IdleGameBossBattleLogic:Enter(param)
  self.param = param
  self.mainView = nil
  self.rewardDataCache = {}
  self.isAutoModeOn = false
  self.curState = Const.BossBattleState.None
  self.fsm = FSMachine.Create(self)
  self.fsm:Add(Const.BossBattleState.Init, InitState.New(self))
  self.fsm:Add(Const.BossBattleState.Match_Init, MatchInitState.New(self))
  self.fsm:Add(Const.BossBattleState.Match_Ready, MatchReadyState.New(self))
  self.fsm:Add(Const.BossBattleState.Match_Fight, MatchFightState.New(self))
  self.fsm:Add(Const.BossBattleState.Match_Strike, MatchStrikeState.New(self))
  self.fsm:Add(Const.BossBattleState.Match_End, MatchEndState.New(self))
  self:OnEnterGame()
  DataCenter.CityLightManager:AddDeactiveRef()
  self:AddUpdateTimer()
  self:AddListener(EventId.T11IdleGameOnChallengeBossMessage, self.OnChallengeBossSuccess)
end

function T11IdleGameBossBattleLogic:Destroy()
  if self.fsm ~= nil then
    self.fsm:Dispose()
    self.fsm = nil
  end
  if self.squad then
    self.squad:Destroy()
    self.squad = nil
  end
  if self.boss then
    self.boss:Destroy()
    self.boss = nil
  end
  self:DestroyRenderTexture()
  self:DestroySceneRoot()
  self.sceneCamera = nil
  self.sceneRoot = nil
  self.sceneCameraAnim = nil
  self.soldierRoot = nil
  self.bossRoot = nil
  self.renderTexture = nil
  self.mainView = nil
  self.battleUIComponent = nil
  self.param = nil
  self.isAutoModeOn = nil
  self.rewardDataCache = nil
  DataCenter.CityLightManager:DecreaseDeactiveRef()
  self:RemoveAllListeners()
end

function T11IdleGameBossBattleLogic:OnUpdate()
  local dt = Time.deltaTime
  if self.fsm then
    self.fsm:Update(dt)
  end
  if self.squad then
    self.squad:OnUpdate(dt)
  end
end

function T11IdleGameBossBattleLogic:OnEnterGame()
  self:ChangeState(Const.BossBattleState.Init)
end

function T11IdleGameBossBattleLogic:OnInitFinish()
  self:SetSceneCameraActive(true)
  self:PlaySquadAnim("Default")
  local mainData = self:GetMainData()
  if not mainData then
    DataCenter.T11IdleGameManager:PrintRealErrorLog("T11IdleGameBossBattleLogic:OnInitFinish with no mainData")
    return
  end
  if mainData:IsFinishedAllBoss() then
    local uiComp = self:GetBattleUIComponent()
    if uiComp then
      uiComp:ShowYellowTips(Localization:GetString("t11_idle_game_desc_18"))
    end
  else
    local curBoss = self:GetCurBossTemplate()
    if curBoss then
      self:ChangeState(Const.BossBattleState.Match_Init, curBoss, true)
    else
      DataCenter.T11IdleGameManager:PrintRealErrorLog("T11IdleGameBossBattleLogic:OnInitFinish with no boss")
    end
  end
end

function T11IdleGameBossBattleLogic:OnMatchInitFinish(boss)
  self:ChangeState(Const.BossBattleState.Match_Ready, boss)
end

function T11IdleGameBossBattleLogic:EnterFightState(boss, resultData)
  self:ChangeState(Const.BossBattleState.Match_Fight, boss, resultData)
end

function T11IdleGameBossBattleLogic:IsAutoModeOn()
  return self.isAutoModeOn
end

function T11IdleGameBossBattleLogic:SetAutoMode(isOn)
  self.isAutoModeOn = isOn
  if self.isAutoModeOn and self.curState == Const.BossBattleState.Match_Ready then
    local state = self.fsm:GetCurState()
    if state and state.OnAutoModeChanged then
      state:OnAutoModeChanged()
    end
  end
end

function T11IdleGameBossBattleLogic:OnClickChallengeBtn()
  if not self:IsCanChallengeNow() then
    return
  end
  if self:IsAutoModeOn() then
    return
  end
  local state = self.fsm:GetCurState()
  if state and state.ChallengeNow then
    state:ChallengeNow()
  end
end

function T11IdleGameBossBattleLogic:OnChallengeBossSuccess(eventData)
  if not eventData then
    return
  end
  self:EnterFightState(eventData.challengeBoss, eventData)
  local rewardDataShow = DataCenter.RewardManager:ReturnRewardParamForView(eventData.reward)
  self:AddToRewardCache(rewardDataShow)
end

function T11IdleGameBossBattleLogic:ChangeState(state, ...)
  if self.curState == state then
    return
  end
  DataCenter.T11IdleGameManager:PrintEditorCustomLog("T11IdleGameBossBattleLogic:ChangeState " .. state)
  self.curState = state
  self.fsm:Switch(state, ...)
end

function T11IdleGameBossBattleLogic:CreateSceneRoot(finishCallback)
  if self.sceneRootReq ~= nil then
    if not IsNull(self.sceneRootReq.gameObject) and finishCallback then
      finishCallback()
    else
    end
    return
  end
  local request = ResourceManager:InstantiateAsync(Const.BossBattleSceneRootAssetPath)
  self.sceneRootReq = request
  self.sceneRootReq:completed("+", function()
    if request.isError then
      return
    end
    request.gameObject:SetActive(true)
    request.gameObject.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
    request.gameObject.transform:Set_position(Const.DefaultBossSceneRootPos.x, Const.DefaultBossSceneRootPos.y, Const.DefaultBossSceneRootPos.z)
    self.sceneRoot = request.gameObject
    self.soldierRoot = request.gameObject.transform:Find("Squad").gameObject
    self.bossRoot = request.gameObject.transform:Find("Boss").gameObject
    self.sceneCameraAnim = request.gameObject.transform:Find("CameraRoot01/CameraRoot02"):GetComponent(typeof(CS.SimpleAnimation))
    local bossShieldEffect = request.gameObject.transform:Find("Boss/Eff_T11_Boss_Shield").gameObject
    local bossShieldCrackEffect = request.gameObject.transform:Find("Boss/Eff_T11_Boss_Shield_Crack").gameObject
    bossShieldEffect:SetActive(false)
    bossShieldCrackEffect:SetActive(false)
    local cameraTrans = request.gameObject.transform:Find("CameraRoot01/CameraRoot02/Camera")
    if not IsNull(cameraTrans) then
      local camera = cameraTrans:GetComponentInChildren(typeof(Camera), true)
      self.sceneCamera = camera
    end
    if finishCallback then
      finishCallback()
    end
  end)
end

function T11IdleGameBossBattleLogic:DestroySceneRoot()
  if self.sceneRootReq ~= nil then
    self.sceneRootReq:Destroy()
  end
  self.sceneRootReq = nil
end

function T11IdleGameBossBattleLogic:SetSceneCameraActive(isActive)
  local sceneCamera = self.sceneCamera
  if IsNotNull(sceneCamera) then
    sceneCamera.gameObject:SetActive(isActive)
    if isActive then
      self:SetRenderTexture()
    else
      sceneCamera.targetTexture = nil
    end
  end
end

function T11IdleGameBossBattleLogic:PlaySceneCameraAnim(anim)
  if IsNotNull(self.sceneCameraAnim) then
    self.sceneCameraAnim:Play(anim)
  end
end

function T11IdleGameBossBattleLogic:SetRenderTexture()
  if IsNull(self.sceneCamera) or self.param == nil then
    return
  end
  if self.renderTexture == nil then
    local rtWidth = self.param.rtWidth
    local rtHeight = self.param.rtHeight
    local rtFormat = RenderTextureFormat.ARGBHalf
    self.renderTexture = RenderTexture.GetTemporary(rtWidth, rtHeight, 24, rtFormat)
    self.renderTexture.name = "T11IdleGameTexture" .. rtWidth .. "*" .. rtHeight
  end
  if self.param and self.param.renderTexture then
    self.param.renderTexture:SetTexture(self.renderTexture)
    self.param.renderTexture:SetEnable(true)
    self.param.renderTexture:SetColor(Color.New(1, 1, 1, 1))
  end
  self.sceneCamera.targetTexture = self.renderTexture
end

function T11IdleGameBossBattleLogic:DestroyRenderTexture()
  if IsNotNull(self.sceneCamera) then
    self.sceneCamera.targetTexture = nil
  end
  if self.renderTexture ~= nil then
    RenderTexture.ReleaseTemporary(self.renderTexture)
    self.renderTexture = nil
  end
end

function T11IdleGameBossBattleLogic:AddUpdateTimer()
  if self.updateTimer == nil then
    function self.updateTimer()
      self:OnUpdate()
    end
    
    UpdateManager:GetInstance():AddUpdate(self.updateTimer)
  end
end

function T11IdleGameBossBattleLogic:RemoveUpdateTimer()
  if self.updateTimer then
    UpdateManager:GetInstance():RemoveUpdate(self.updateTimer)
    self.updateTimer = nil
  end
end

function T11IdleGameBossBattleLogic:AddListener(msg_name, callback)
  if not self.__event_handlers then
    self.__event_handlers = {}
  end
  
  local function bindFunc(...)
    callback(self, ...)
  end
  
  self.__event_handlers[msg_name] = bindFunc
  EventManager:GetInstance():AddListener(msg_name, bindFunc)
end

function T11IdleGameBossBattleLogic:RemoveAllListeners()
  if not self.__event_handlers then
    return
  end
  for name, bindFunc in pairs(self.__event_handlers) do
    if bindFunc then
      EventManager:GetInstance():RemoveListener(name, bindFunc)
    end
  end
  self.__event_handlers = nil
end

function T11IdleGameBossBattleLogic:GetBossRoot()
  return self.bossRoot
end

function T11IdleGameBossBattleLogic:DestroyBoss()
  if self.boss then
    self.boss:ClearBoss()
  end
  local uiComp = self:GetBattleUIComponent()
  if uiComp then
    uiComp:HideBossInfo()
  end
end

function T11IdleGameBossBattleLogic:CreateBoss(bossTemplate, bornFinishCallback)
  if not bossTemplate then
    return
  end
  if self.boss == nil then
    self.boss = T11IdleGameBossBattleBoss.New(self, self.bossRoot)
  end
  self.boss:ClearBoss()
  self.boss:Load(bossTemplate, bornFinishCallback)
end

function T11IdleGameBossBattleLogic:PlayBossAnim(name)
  if self.boss then
    self.boss:PlayAnim(name)
  end
end

function T11IdleGameBossBattleLogic:GetMainData()
  if self.param then
    return self.param.mainData
  end
end

function T11IdleGameBossBattleLogic:GetInfoData()
  if self.param then
    return self.param.infoData
  end
end

function T11IdleGameBossBattleLogic:GetCurBossTemplate()
  local mainData = self:GetMainData()
  if mainData then
    return mainData:GetCurBossTemplate()
  end
end

function T11IdleGameBossBattleLogic:ChangeBossState(state, ...)
  if self.boss then
    self.boss:ChangeState(state, ...)
  end
end

function T11IdleGameBossBattleLogic:CreateSquad(finishCallback)
  if IsNull(self.soldierRoot) then
    return
  end
  self.squad = T11IdleGameBossBattleSquad.New(self, self.soldierRoot)
  self.squad:LoadSoldiers(finishCallback)
end

function T11IdleGameBossBattleLogic:ChangeSquadState(state, ...)
  if self.squad then
    self.squad:ChangeSoldiersState(state, ...)
  end
end

function T11IdleGameBossBattleLogic:SoldierEnterFireState(boss)
  if IsNull(self.boss) or boss == nil then
    return
  end
  self.squad:EnterFire(self.boss)
end

function T11IdleGameBossBattleLogic:PlaySquadAnim(name, finishCallback)
  if self.squad then
    self.squad:PlayAnim(name, finishCallback)
  end
end

function T11IdleGameBossBattleLogic:GetBattleMainView()
  if self.mainView == nil then
    local window = UIManager:GetInstance():GetWindow(UIWindowNames.UILWT11IdleGameBattleMain)
    if window then
      self.mainView = window.View
    end
  end
  return self.mainView
end

function T11IdleGameBossBattleLogic:GetBattleUIComponent()
  if self.battleUIComponent == nil then
    local mainView = self:GetBattleMainView()
    if mainView then
      self.battleUIComponent = mainView:GetBossComponent()
    end
  end
  return self.battleUIComponent
end

function T11IdleGameBossBattleLogic:ShowBossInfoUI(boss)
  local comp = self:GetBattleUIComponent()
  if comp and boss then
    comp:ShowBossInfo(boss)
  end
end

function T11IdleGameBossBattleLogic:IsCanChallengeNow()
  return self.curState == Const.BossBattleState.Match_Ready
end

function T11IdleGameBossBattleLogic:RefreshUIBottomBtn()
  local comp = self:GetBattleUIComponent()
  if comp then
    comp:RefreshBottomBtn()
  end
end

function T11IdleGameBossBattleLogic:AddToRewardCache(rewards)
  if rewards == nil then
    return
  end
  if self.rewardDataCache == nil then
    self.rewardDataCache = {}
  end
  for i, v in ipairs(rewards) do
    table.insert(self.rewardDataCache, v)
  end
end

return T11IdleGameBossBattleLogic
