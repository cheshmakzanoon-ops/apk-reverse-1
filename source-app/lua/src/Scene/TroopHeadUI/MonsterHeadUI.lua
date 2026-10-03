local MonsterHeadUI = BaseClass("MonsterHeadUI")
local hp_spr_path = "Transform/back/hp"
local hp_red_spr_path = "Transform/back/hp/hpRed"
local blood_num_path = "Transform/back/hp/bloodNum"
local attack_name_path = "Transform/back/monsterNameBg/monsterName"
local icon_path = "Transform/back/monsterNameBg/icon"
local monsterBg = "Transform/back/monsterNameBg"
local ResourceManager = CS.GameEntry.Resource
local Localization = CS.GameEntry.Localization

local function OnCreate(self, go)
  if go ~= nil then
    self.request = go
    self.gameObject = go.gameObject
    self.transform = go.gameObject.transform
  end
  self:ComponentDefine()
end

local function OnDestroy(self)
  self:SetHP(1, 1)
  self:ComponentDestroy()
end

local function Hit(self)
end

local function ComponentDefine(self)
  self.hp_spr = self.transform:Find(hp_spr_path):GetComponent(typeof(CS.UnityEngine.SpriteRenderer))
  self.hp_spr_red = self.transform:Find(hp_red_spr_path):GetComponent(typeof(CS.UnityEngine.SpriteRenderer))
  self.icon = self.transform:Find(icon_path):GetComponent(typeof(CS.UnityEngine.SpriteRenderer))
  self.attack_name = self.transform:Find(attack_name_path):GetComponent(typeof(CS.SuperTextMesh))
  self.blood_num = self.transform:Find(blood_num_path):GetComponent(typeof(CS.SuperTextMesh))
  self.cacheHpImg = ""
  self.startBloodPercent = 0
  self.endBloodPercent = 0
  self.isDoAnim = false
  
  function self.__update_handle()
    self:Update()
  end
  
  UpdateManager:GetInstance():AddUpdate(self.__update_handle)
end

local function ComponentDestroy(self)
  self.hp_spr = nil
  self.icon = nil
  self.attack_name = nil
  self.blood_num = nil
  self.cacheHpImg = nil
  self.cacheBloodPercent = nil
end

local function RemoveTimer(self)
  UpdateManager:GetInstance():RemoveUpdate(self.__update_handle)
  self.__update_handle = nil
end

local function ShowAnger(self)
end

local function ShowExploreInfo(self, pointIndex, soliderNum, hp, hpMax)
  local data = CS.SceneManager.World:GetExplorePointInfoByIndex(pointIndex)
  if data ~= nil then
    local template = DataCenter.DetectEventTemplateManager:GetDetectEventTemplate(data.eventId)
    if template ~= nil then
      local name = template:GetRealName()
      self:SetName(name)
    end
    self:SetHP(hp, hpMax)
  end
end

local function ShowMarchInfo(self, marchInfo, isCreate)
  if isCreate == true then
    if marchInfo:IsMonsterOrOrdinaryBoss() or marchInfo:GetMarchType() == NewMarchType.CHALLENGE_BOSS then
      local monster = DataCenter.MonsterTemplateManager:GetMonsterTemplate(tostring(marchInfo.monsterId))
      local name = Localization:GetString(monster.name)
      self:SetName(name)
    end
    self:SetHP(1, 1)
  end
end

local function SetName(self, name, allianceAbbr)
  if allianceAbbr ~= nil and allianceAbbr ~= "" then
    self.attack_name.text = "[" .. allianceAbbr .. "] " .. name
  else
    self.attack_name.text = name
  end
end

local function SetHP(self, hp, maxhp)
  if 1 < hp then
    self.blood_num.text = hp
  else
    self.blood_num.text = ""
  end
  local percent = hp / math.max(maxhp, 1)
  if percent <= 0 then
    percent = 0
  elseif 1 <= percent then
    percent = 1
  end
  self.curTime = 0
  self.startBloodPercent = self.endBloodPercent
  self.endBloodPercent = percent
  if self.startBloodPercent ~= 0 then
    self.hp_spr_red.size = Vector2.New(self.startBloodPercent * 1.39, 0.17)
    self.deltaPro = self.endBloodPercent - self.startBloodPercent
    self.isDoAnim = true
    self:Update()
  end
  local spr = ""
  if percent < 0.3 then
    spr = "Assets/Main/Sprites/UI/UIWorldBattle/UIWorldBattle_pro_monster_red.png"
  elseif 0.3 <= percent and percent < 0.7 then
    spr = "Assets/Main/Sprites/UI/UIWorldBattle/UIWorldBattle_pro_monster_yellow.png"
  elseif 0.7 <= percent then
    spr = "Assets/Main/Sprites/UI/UIWorldBattle/UIWorldBattle_pro_monster_green.png"
  end
  if self.cacheHpImg ~= spr then
    self.hp_spr:LoadSprite(spr)
    self.cacheHpImg = spr
  end
  self.hp_spr.size = Vector2.New(percent * 1.39, 0.17)
end

local function Update(self)
  if self.isDoAnim then
    self.curTime = self.curTime + Time.deltaTime
    if self.curTime > 0.3 then
      self.hp_spr_red.size = Vector2.New(self.endBloodPercent * 1.39, 0.17)
      self.isDoAnim = false
    else
      local changePro = self.curTime / 0.3
      local curPro = self.startBloodPercent + changePro * self.deltaPro
      if curPro < 0 then
        curPro = 0
      elseif 1 <= curPro then
        curPro = 1
      end
      self.hp_spr_red.size = Vector2.New(curPro * 1.39, 0.17)
    end
  end
end

local function SetAnger(self, anger, maxAnger)
end

local function SetSelectCircle(self, value)
end

local function ShowBattleRedName(self)
end

local function HideSkillHeadEffect(self)
end

local function SetSelectRotation(self, value)
end

local function SetForWasteland(self)
  local obj = self.transform:Find(monsterBg)
  if obj ~= nil then
    obj.gameObject:SetActive(false)
  end
  self:SetHP(100, 100)
end

local function SetPowerInPve(self, value)
  local obj = self.transform:Find(monsterBg)
  if obj ~= nil then
    obj.gameObject:SetActive(true)
  end
  self.attack_name.text = value
  self.hp_spr.gameObject:SetActive(false)
end

local function SetForPve(self)
  local obj = self.transform:Find(monsterBg)
  if obj ~= nil then
    obj.gameObject:SetActive(false)
  end
  self.hp_spr.gameObject:SetActive(true)
  self:SetHP(100, 100)
end

MonsterHeadUI.SetForPve = SetForPve
MonsterHeadUI.SetPowerInPve = SetPowerInPve
MonsterHeadUI.SetForWasteland = SetForWasteland
MonsterHeadUI.OnCreate = OnCreate
MonsterHeadUI.OnDestroy = OnDestroy
MonsterHeadUI.ComponentDefine = ComponentDefine
MonsterHeadUI.ComponentDestroy = ComponentDestroy
MonsterHeadUI.ShowMarchInfo = ShowMarchInfo
MonsterHeadUI.SetName = SetName
MonsterHeadUI.SetHP = SetHP
MonsterHeadUI.SetAnger = SetAnger
MonsterHeadUI.ShowExploreInfo = ShowExploreInfo
MonsterHeadUI.ShowAnger = ShowAnger
MonsterHeadUI.Hit = Hit
MonsterHeadUI.SetSelectCircle = SetSelectCircle
MonsterHeadUI.SetSelectRotation = SetSelectRotation
MonsterHeadUI.ShowBattleRedName = ShowBattleRedName
MonsterHeadUI.HideSkillHeadEffect = HideSkillHeadEffect
MonsterHeadUI.Update = Update
MonsterHeadUI.RemoveTimer = RemoveTimer
return MonsterHeadUI
