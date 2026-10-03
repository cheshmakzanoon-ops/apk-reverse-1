local base = require("Scene.PVEBattleLevel.Player.PlayerAnimation.PlayerAniBase")
local PlayerAniHoldFlagCom = BaseClass("PlayerAniHoldFlagCom", base)
local Animator = typeof(CS.UnityEngine.Animator)
local Resource = CS.GameEntry.Resource
local _cp_spacemanSkin = "A_soldie_ben/A_soldie@ben_skin"
local _cp_objHand = "A_soldie_ben/A_soldie@ben_skin/To_unity/DeformationSystem/Root/Root_M/Spine1_M/Chest_M/Scapula_L/Shoulder_L/Elbow_L/Wrist_L/ThumbFinger1_L"
local _cp_objFlag = "A_soldie_ben/A_soldie@ben_skin/To_unity/DeformationSystem/Root/guadian/A_soldie_ben_flag"
local _cp_objAnimator = "A_soldie@qi_naqi_skin"
local AnimationType = {
  Idle = "idle2",
  Run = "idle2",
  Wave = "idle2"
}

function PlayerAniHoldFlagCom:__init(spaceman)
  self._req = {}
  self.m_curAnimationType = ""
  self.m_objFlag = self.m_citySpaceMan:GetTransform():Find(_cp_objFlag)
  self.m_objHand = self.m_citySpaceMan:GetTransform():Find(_cp_objHand)
  if self.m_objFlag then
    local skinFlag = self.m_objFlag:Find(_cp_objAnimator)
    if skinFlag then
      self.m_flagAnimator = skinFlag:GetComponent(Animator)
    end
    self.m_objFlag.gameObject:SetActive(false)
  end
  if self.m_citySpaceMan:GetTransform():Find(_cp_spacemanSkin) then
    self.actionListener = self.m_citySpaceMan:GetTransform():Find(_cp_spacemanSkin):GetComponent(typeof(CS.CitySpaceManAnimationListener))
    if self.actionListener then
      function self.actionListener.animation_placeFlag()
        self:PlaceFlagToWorld()
      end
    end
  end
end

function PlayerAniHoldFlagCom:__delete()
  self:ClearListener()
end

function PlayerAniHoldFlagCom:ClearListener()
  if self.actionListener then
    self.actionListener.animation_placeFlag = nil
    self.actionListener = nil
  end
end

function PlayerAniHoldFlagCom:OnExit()
  self:ClearListener()
  base.OnExit(self)
end

function PlayerAniHoldFlagCom:PlayAnimation(animationType)
  if self.m_curAnimationType == animationType then
    return
  end
  self.m_curAnimationType = animationType
  if self.m_flagAnimator ~= nil then
    self.m_flagAnimator:SetTrigger(animationType)
  end
end

function PlayerAniHoldFlagCom:KillAll()
  if self.m_objFlag ~= nil then
    self.m_objFlag.gameObject:SetActive(true)
  end
  self.m_citySpaceMan:PlayAnimation()
end

function PlayerAniHoldFlagCom:KillAllRun()
  self:PlayAnimation(AnimationType.Run)
end

function PlayerAniHoldFlagCom:killAllIdle()
  self:PlayAnimation(AnimationType.Idle)
end

function PlayerAniHoldFlagCom:PlaceFlagToWorld()
  if self.m_objFlag ~= nil then
    self.m_objFlag.gameObject:SetActive(false)
  end
  local tilePos = self.m_citySpaceMan:GetTilePos()
  local _req = Resource:InstantiateAsync("Assets/PackageRes/Solider/ShiHuangXiaoRen/prefab/A_soldie_shxr_flag.prefab")
  _req:completed("+", function()
    local _gameObject = _req.gameObject
    if _gameObject == nil then
      return
    end
    self._objWorldFlag = _gameObject
    local _transform = _gameObject.transform
    _transform.localScale = Vector3.New(2.5, 2.5, 2.5)
    local handPos = self.m_objHand.gameObject.transform.position
    _transform.position = Vector3.New(handPos.x + 0.85, 0, handPos.z)
  end)
  self._req[#self._req + 1] = _req
end

function PlayerAniHoldFlagCom:Over()
  if self.m_objFlag ~= nil then
    self.m_objFlag.gameObject:SetActive(true)
  end
  self.m_citySpaceMan:PlayAnimation()
  self:PlayAnimation(AnimationType.Wave)
end

function PlayerAniHoldFlagCom:HideFlag()
  if self.m_objFlag ~= nil then
    self.m_objFlag.gameObject:SetActive(false)
  end
end

function PlayerAniHoldFlagCom:Destroy()
  for _, v in pairs(self._req) do
    v:Destroy()
  end
  self._req = {}
  self:ClearListener()
end

function PlayerAniHoldFlagCom:RefreshBuff()
end

return PlayerAniHoldFlagCom
