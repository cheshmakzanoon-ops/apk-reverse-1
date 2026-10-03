local Season5EasterEggStateMachine = require("UI.LWSeason.LWSeasonEasterEgg.S5.Season5EasterEggStateMachine")
local Season5EasterEggComp = BaseClass("Season5EasterEggComp")

function Season5EasterEggComp:__init()
end

function Season5EasterEggComp:__delete()
end

function Season5EasterEggComp:ReInit(go)
  if self:InitData(go) then
    self:InitComp()
  end
end

function Season5EasterEggComp:Clear()
  if self.StateMachine ~= nil then
    self.StateMachine:Clear()
    self.StateMachine = nil
  end
end

function Season5EasterEggComp:InitData(go)
  if go ~= nil then
    self.Go = go
    return true
  end
  return false
end

function Season5EasterEggComp:InitComp()
  local goChicken = self.Go.transform:Find("Root/Xibujiedao/Xibujiedao_animals/chicken/A_Monster_chicken_skin")
  if goChicken ~= nil then
    self.animChicken = goChicken:GetComponent(typeof(CS.SimpleAnimation))
    local modelTrigger = goChicken:GetComponent(typeof(CS.TouchObjectEventTrigger))
    if modelTrigger then
      function modelTrigger.onPointerClick()
        self:OnClickChicken()
      end
    end
  end
  local goEgg = self.Go.transform:Find("Root/Xibujiedao/Xibujiedao_animals/egg/A_Build_xbxz_egg_skin")
  if goEgg ~= nil then
    self.animEgg = goEgg:GetComponent(typeof(CS.SimpleAnimation))
  end
  self.goVfxTips = self.Go.transform:Find("Root/Xibujiedao/Xibujiedao_animals/chicken/p_anim_tips").gameObject
  self.goVfxAngry = self.Go.transform:Find("Root/Xibujiedao/Xibujiedao_animals/chicken/p_anim_angry").gameObject
  self.goVfxSpawn = self.Go.transform:Find("Root/Xibujiedao/Xibujiedao_animals/chicken/p_anim_spawn").gameObject
  self.goVfxBreak = self.Go.transform:Find("Root/Xibujiedao/Xibujiedao_animals/chicken/p_anim_break").gameObject
  self.goVfxSpawnEgg = self.Go.transform:Find("Root/Xibujiedao/Xibujiedao_animals/egg/A_Build_xbxz_egg_skin/egg/p_anim_spawn_egg").gameObject
  DataCenter.SeasonEasterEggManager:SetEasterEggPos(goChicken.transform.position)
  self.StateMachine = Season5EasterEggStateMachine.New()
  self.StateMachine:Init(self.animChicken, self.animEgg, function(state)
    self:ChickenVfxProxy(state)
  end, function(state)
    self:EggVfxProxy(state)
  end)
  self.StateVfxChicken = {
    [self.StateMachine.StateConst.Idle] = {},
    [self.StateMachine.StateConst.Angry] = {
      self.goVfxAngry
    },
    [self.StateMachine.StateConst.Spawn] = {
      self.goVfxSpawn
    },
    [self.StateMachine.StateConst.Reward] = {},
    [self.StateMachine.StateConst.Break] = {
      self.goVfxBreak
    },
    [self.StateMachine.StateConst.None] = {},
    [self.StateMachine.StateConst.Tips] = {
      self.goVfxTips
    }
  }
  self.StateVfxEgg = {
    [self.StateMachine.StateConst.Idle] = {},
    [self.StateMachine.StateConst.Angry] = {},
    [self.StateMachine.StateConst.Spawn] = {
      self.goVfxSpawnEgg
    },
    [self.StateMachine.StateConst.Reward] = {},
    [self.StateMachine.StateConst.Break] = {},
    [self.StateMachine.StateConst.None] = {}
  }
  self:ChickenVfxProxy(self.StateMachine.StateConst.None)
  self:EggVfxProxy(self.StateMachine.StateConst.None)
  self.StateMachine:TryTrans()
end

function Season5EasterEggComp:OnClickChicken()
  if self.StateMachine == nil then
    return
  end
  if self.StateMachine:IsIdle() then
    self.StateMachine:TryTrans()
    return
  end
  if self.StateMachine:IsSpawn() then
    self.StateMachine:SetParam(self.StateMachine.ParamConst.ClickSpawn, UITimeManager:GetInstance():GetServerTime())
    local timingValid = self.StateMachine:CheckClaimValid()
    local claimed = self.StateMachine:CheckParam(self.StateMachine.ParamConst.Claimed, 1)
    if claimed then
      Logger.Log("\227\128\144\229\176\143\233\184\161\227\128\145 \232\191\153\230\172\161\230\181\129\231\168\139\229\183\178\231\187\143\229\143\145\233\128\129\232\191\135\229\165\150\229\138\177")
    end
    if timingValid and not claimed then
      Logger.Log("\227\128\144\229\176\143\233\184\161\227\128\145 \229\143\145\233\128\129\232\142\183\229\143\150\229\165\150\229\138\177")
      local tryClaim = DataCenter.SeasonEasterEggManager:SendClaimReward()
      self.StateMachine:SetParam(self.StateMachine.ParamConst.Claimed, tryClaim and 1 or 0)
      self.StateMachine:Shock()
      self.StateMachine:PlayEggIdle()
    end
  end
end

function Season5EasterEggComp:ChickenVfxProxy(state)
  self.goVfxTips:SetActive(false)
  self.goVfxAngry:SetActive(false)
  self.goVfxSpawn:SetActive(false)
  self.goVfxBreak:SetActive(false)
  local vfxGos = self.StateVfxChicken[state]
  if table.count(vfxGos) > 0 then
    for _, vfxGo in ipairs(vfxGos) do
      if vfxGo ~= nil then
        vfxGo:SetActive(false)
        vfxGo:SetActive(true)
      end
    end
  end
end

function Season5EasterEggComp:EggVfxProxy(state)
  self.goVfxSpawnEgg:SetActive(false)
  local vfxGos = self.StateVfxEgg[state]
  if table.count(vfxGos) > 0 then
    for _, vfxGo in ipairs(vfxGos) do
      if vfxGo ~= nil then
        vfxGo:SetActive(false)
        vfxGo:SetActive(true)
      end
    end
  end
end

return Season5EasterEggComp
