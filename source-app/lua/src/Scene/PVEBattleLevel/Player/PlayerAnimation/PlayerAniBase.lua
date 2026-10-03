local PlayerAniBase = BaseClass("PlayerAniBase")
local Animator = typeof(CS.UnityEngine.Animator)
local path_Animator_Body = "A_soldie_ben/A_soldie@ben_skin"
local _cp_spacemanSkin = "A_soldie_ben/A_soldie@ben_skin"
local _cp_objCollider = "A_soldie_ben/A_soldie@ben_skin/To_unity/DeformationSystem/Root/Root_M/Spine1_M/Chest_M/Scapula_R/Shoulder_R/Elbow_R/objCollider"
local path_Animator_Body_hero = "A_Hero_low/A_Hero_low_skin"
local _cp_spacemanSkin_hero = "A_Hero_low/A_Hero_low_skin"
local _cp_objCollider_hero = "A_Hero_low/A_Hero_low_skin/To_unity/DeformationSystem/Root/guadian/objCollider"

function PlayerAniBase:__init(spaceman)
  self.m_citySpaceMan = spaceman
  if self.m_citySpaceMan.isHero ~= nil and self.m_citySpaceMan.isHero == true then
    local skinObj = self.m_citySpaceMan:GetTransform():Find(path_Animator_Body_hero)
    if skinObj ~= nil then
      self.m_animator = skinObj:GetComponent(Animator)
    end
  else
    local skinObj = self.m_citySpaceMan:GetTransform():Find(path_Animator_Body)
    if skinObj ~= nil then
      self.m_animator = skinObj:GetComponent(Animator)
    end
  end
end

function PlayerAniBase:SetActionListen()
  local objTransform = self.m_citySpaceMan:GetTransform()
  if self.m_citySpaceMan.isHero ~= nil and self.m_citySpaceMan.isHero == true then
    if objTransform:Find(_cp_spacemanSkin_hero) then
      local actionListen = objTransform:Find(_cp_spacemanSkin_hero):GetComponent(typeof(CS.CitySpaceManAnimationListener))
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
        
        if actionListen.OnAnimationEvent_ShowTrail ~= nil then
          function actionListen.animation_showTrail()
            self:Ani_Listen_ShowTrail()
          end
        end
      end
    end
  elseif objTransform:Find(_cp_spacemanSkin) then
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
      
      if actionListen.OnAnimationEvent_ShowTrail ~= nil then
        function actionListen.animation_showTrail()
          self:Ani_Listen_ShowTrail()
        end
      end
    end
  end
end

function PlayerAniBase:ClearActionListen()
  local objTransform = self.m_citySpaceMan:GetTransform()
  if self.m_citySpaceMan.isHero ~= nil and self.m_citySpaceMan.isHero == true then
    if objTransform:Find(_cp_spacemanSkin_hero) then
      local actionListen = objTransform:Find(_cp_spacemanSkin_hero):GetComponent(typeof(CS.CitySpaceManAnimationListener))
      if actionListen then
        actionListen.animation_playBegin = nil
        actionListen.animation_playEnd = nil
        actionListen.animation_attackBegin = nil
        actionListen.animation_attackDone = nil
        if actionListen.OnAnimationEvent_ShowTrail ~= nil then
          actionListen.animation_showTrail = nil
        end
      end
    end
  elseif objTransform:Find(_cp_spacemanSkin) then
    local actionListen = objTransform:Find(_cp_spacemanSkin):GetComponent(typeof(CS.CitySpaceManAnimationListener))
    if actionListen then
      actionListen.animation_playBegin = nil
      actionListen.animation_playEnd = nil
      actionListen.animation_attackBegin = nil
      actionListen.animation_attackDone = nil
      if actionListen.OnAnimationEvent_ShowTrail ~= nil then
        actionListen.animation_showTrail = nil
      end
    end
  end
end

function PlayerAniBase:SetTriggerListen()
  local objTransform = self.m_citySpaceMan:GetTransform()
  if self.m_citySpaceMan.isHero ~= nil and self.m_citySpaceMan.isHero == true then
    local _objCollider = objTransform:Find(_cp_objCollider_hero)
    self.m_weaponTrigger = _objCollider:GetComponent(typeof(CS.CitySpaceManTrigger))
    if self.m_weaponTrigger then
      function self.m_weaponTrigger.TriggerEnterAction(uuid, resType)
        self:OnTriggerEnter_Weapon(uuid, resType)
      end
    end
  else
    local _objCollider = objTransform:Find(_cp_objCollider)
    self.m_weaponTrigger = _objCollider:GetComponent(typeof(CS.CitySpaceManTrigger))
    if self.m_weaponTrigger then
      function self.m_weaponTrigger.TriggerEnterAction(uuid, resType)
        self:OnTriggerEnter_Weapon(uuid, resType)
      end
    end
  end
end

function PlayerAniBase:ClearTriggerListen()
  local objTransform = self.m_citySpaceMan:GetTransform()
  if self.m_citySpaceMan.isHero ~= nil and self.m_citySpaceMan.isHero == true then
    local _objCollider = objTransform:Find(_cp_objCollider_hero)
    self.m_weaponTrigger = _objCollider:GetComponent(typeof(CS.CitySpaceManTrigger))
    if self.m_weaponTrigger then
      self.m_weaponTrigger.TriggerEnterAction = nil
    end
  else
    local _objCollider = objTransform:Find(_cp_objCollider)
    self.m_weaponTrigger = _objCollider:GetComponent(typeof(CS.CitySpaceManTrigger))
    if self.m_weaponTrigger then
      self.m_weaponTrigger.TriggerEnterAction = nil
    end
  end
end

function PlayerAniBase:OnTriggerEnter_Weapon(uuid, resType)
end

function PlayerAniBase:Ani_Listen_AttackBegin()
end

function PlayerAniBase:Ani_Listen_AttackDone()
end

function PlayerAniBase:Ani_Listen_PlayBegin()
end

function PlayerAniBase:Ani_Listen_ShowTrail()
end

function PlayerAniBase:Ani_Listen_PlayEnd()
end

function PlayerAniBase:OnEnter()
  self.m_citySpaceMan:PlayAnimation()
end

function PlayerAniBase:OnExit()
end

function PlayerAniBase:OnUpdate()
end

return PlayerAniBase
