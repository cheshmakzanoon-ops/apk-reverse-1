local AisillaBossBornState = BaseClass("AisillaBossBornState")
local bornAnimLen = 12
local bornTimelinePath = "Assets/Main/Prefabs/PVE/Timeline/aisila_timeline.prefab"
local effPath1 = "Assets/_Art_LastWar/Effect/Prefab/RiChang/aisila/Eff_s_aisila_born_Root.prefab"
local effPath1Root = "A_Mongster@Boss_aisila01_skin/To_unity/DeformationSystem/Root"
local effPath2 = "Assets/_Art_LastWar/Effect/Prefab/Boss/Eff_Boss_aisila_skill_02.prefab"
local effPath2Root = "A_Mongster@Boss_aisila01_skin/To_unity/DeformationSystem/Root/Root_M/Spine1_M/Chest_M/Neck0_M/Head_M/Jaw_M/JawEnd_M/firepoint_mouth"

function AisillaBossBornState:Init(unit)
  self.unit = unit
end

function AisillaBossBornState:__delete()
  self.unit = nil
  self:ClearDelay()
  self:ClearAsset()
end

function AisillaBossBornState:OnEnter()
  self.bornTime = Time.time + bornAnimLen
  self.unit:PlaySimpleAnim("born_show", 1)
  DataCenter.LWBattleManager:SetGamePause(true)
  self.timeline = CS.GameEntry.Resource:InstantiateAsync(bornTimelinePath)
  self.timeline:completed("+", function(handle)
    if handle.isError then
      Logger.LogError("AisillaBossBornTime Load Error !")
      return
    end
    local pos = self.unit:GetPosition()
    local director = handle.gameObject:GetComponentInChildren(typeof(CS.UnityEngine.Playables.PlayableDirector))
    handle.gameObject.transform:Set_localPosition(pos.x, pos.y, pos.z)
    self.director = director
    if not IsNull(director) then
      director:Play()
    end
  end)
  self:ClearDelay()
  self.delay = TimerManager:GetInstance():DelayInvoke(function()
    DataCenter.LWBattleManager:SetGamePause(false)
    local CanvasNormal = UIManager:GetInstance():GetLayer(UILayer.HpBar.Name)
    if CanvasNormal then
      CanvasNormal.gameObject:SetActive(true)
    end
    if self.unit then
      if self.eff1 then
        self.unit.logic:RemoveEffectObj(self.eff1)
        self.eff1 = nil
      end
      if self.eff2 then
        self.unit.logic:RemoveEffectObj(self.eff2)
        self.eff2 = nil
      end
    end
  end, bornAnimLen)
  local CanvasNormal = UIManager:GetInstance():GetLayer(UILayer.HpBar.Name)
  if CanvasNormal then
    CanvasNormal.gameObject:SetActive(false)
  end
  if IsNotNull(self.unit.transform) then
    local root1 = self.unit.transform:Find(effPath1Root)
    if IsNotNull(root1) then
      self.eff1 = self.unit.logic:ShowEffectObj(effPath1, nil, nil, 1, root1, 10)
    end
  end
  self.effect2Delay = TimerManager:GetInstance():DelayInvoke(function()
    self.effect2Delay = nil
    if IsNotNull(self.unit.transform) then
      local root1 = self.unit.transform:Find(effPath2Root)
      if IsNotNull(root1) then
        self.eff2 = self.unit.logic:ShowEffectObj(effPath2, nil, nil, 1, root1, 10)
      end
    end
  end, 7)
  DataCenter.LWSoundManager:PlaySound(SoundAssetId.SFX_Enemy_Boss_Aisila_Born, false)
  if self.unit.logic.PlaySceneAnim then
    self.unit.logic:PlaySceneAnim("Default")
  end
end

function AisillaBossBornState:ClearDelay()
  if self.delay then
    self.delay:Stop()
    self.delay = nil
  end
  if self.effect1Delay then
    self.effect1Delay:Stop()
    self.effect1Delay = nil
  end
  if self.effect2Delay then
    self.effect2Delay:Stop()
    self.effect2Delay = nil
  end
end

function AisillaBossBornState:ClearAsset()
  self.director = nil
  if self.timeline then
    self.timeline:RealDestroy()
    self.timeline = nil
  end
  local CanvasNormal = UIManager:GetInstance():GetLayer(UILayer.HpBar.Name)
  if CanvasNormal then
    CanvasNormal.gameObject:SetActive(true)
  end
  if self.unit then
    if self.eff1 then
      self.unit.logic:RemoveEffectObj(self.eff1)
      self.eff1 = nil
    end
    if self.eff2 then
      self.unit.logic:RemoveEffectObj(self.eff2)
      self.eff2 = nil
    end
  end
end

function AisillaBossBornState:OnExit()
  self:ClearDelay()
  self:ClearAsset()
end

function AisillaBossBornState:OnUpdate(deltaTime)
  if Time.time > self.bornTime then
    self.unit.fsm:ChangeState(ZombieState.Idle)
  end
end

return AisillaBossBornState
