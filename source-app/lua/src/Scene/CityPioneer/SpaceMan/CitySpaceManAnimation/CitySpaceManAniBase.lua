local CitySpaceManAniBase = BaseClass("CitySpaceManAniBase")
local Animator = typeof(CS.UnityEngine.Animator)
local path_Animator_Body = "A_soldie_ben/A_soldie@ben_skin"
local _cp_spacemanSkin = "A_soldie_ben/A_soldie@ben_skin"
local _cp_objCollider = "A_soldie_ben/A_soldie@ben_skin/To_unity/DeformationSystem/Root/Root_M/Spine1_M/Chest_M/Scapula_R/Shoulder_R/Elbow_R/objCollider"

function CitySpaceManAniBase:__init(spaceman)
  self.m_citySpaceMan = spaceman
  local skinObj = self.m_citySpaceMan:GetTransform():Find(path_Animator_Body)
  if skinObj ~= nil then
    self.m_animator = skinObj:GetComponent(Animator)
  end
end

function CitySpaceManAniBase:SetActionListen()
  local objTransform = self.m_citySpaceMan:GetTransform()
  if objTransform:Find(_cp_spacemanSkin) then
    local actionListen = objTransform:Find(_cp_spacemanSkin):GetComponent(typeof(CS.CitySpaceManAnimationListener))
    if actionListen then
      function actionListen.animation_playBegin()
        self:Ani_Listen_PlayBegin()
      end
      
      function actionListen.animation_playEnd()
        self:Ani_Listen_PlayEnd()
      end
      
      function actionListen.animation_attackBegin()
        self:Ani_Listen_AttackBegin()
      end
      
      function actionListen.animation_attackDone()
        self:Ani_Listen_AttackDone()
      end
    end
  end
end

function CitySpaceManAniBase:ClearActionListen()
  local objTransform = self.m_citySpaceMan:GetTransform()
  if objTransform:Find(_cp_spacemanSkin) then
    local actionListen = objTransform:Find(_cp_spacemanSkin):GetComponent(typeof(CS.CitySpaceManAnimationListener))
    if actionListen then
      actionListen.animation_playBegin = nil
      actionListen.animation_playEnd = nil
      actionListen.animation_attackBegin = nil
      actionListen.animation_attackDone = nil
    end
  end
end

function CitySpaceManAniBase:SetTriggerListen()
  local objTransform = self.m_citySpaceMan:GetTransform()
  local _objCollider = objTransform:Find(_cp_objCollider)
  self.m_weaponTrigger = _objCollider:GetComponent(typeof(CS.CitySpaceManTrigger))
  if self.m_weaponTrigger then
    function self.m_weaponTrigger.TriggerEnterAction(uuid, resType)
      self:OnTriggerEnter_Weapon(uuid, resType)
    end
  end
end

function CitySpaceManAniBase:ClearTriggerListen()
  local objTransform = self.m_citySpaceMan:GetTransform()
  local _objCollider = objTransform:Find(_cp_objCollider)
  self.m_weaponTrigger = _objCollider:GetComponent(typeof(CS.CitySpaceManTrigger))
  if self.m_weaponTrigger then
    self.m_weaponTrigger.TriggerEnterAction = nil
  end
end

function CitySpaceManAniBase:OnTriggerEnter_Weapon(uuid, resType)
end

function CitySpaceManAniBase:Ani_Listen_AttackBegin()
end

function CitySpaceManAniBase:Ani_Listen_AttackDone()
end

function CitySpaceManAniBase:Ani_Listen_PlayBegin()
end

function CitySpaceManAniBase:Ani_Listen_PlayEnd()
end

function CitySpaceManAniBase:OnEnter()
  self.m_citySpaceMan:PlayAnimation()
end

function CitySpaceManAniBase:OnExit()
end

function CitySpaceManAniBase:OnUpdate()
end

return CitySpaceManAniBase
