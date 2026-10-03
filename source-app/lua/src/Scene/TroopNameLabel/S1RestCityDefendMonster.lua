local S1RestCityDefendMonster = BaseClass("S1RestCityDefendMonster")
local SpriteRenderer = CS.UnityEngine.SpriteRenderer
local SuperTextMesh = CS.SuperTextMesh

function S1RestCityDefendMonster:OnCreate(go)
  if go ~= nil then
    self.request = go
    self.gameObject = go.gameObject
    self.transform = go.gameObject.transform
    self.boss_root = self.transform:Find("Root").gameObject
    self.boss_icon = self.transform:Find("Root/iconArmy"):GetComponent(typeof(SpriteRenderer))
    self.boss_pro = self.transform:Find("Root/pro_bg/pro"):GetComponent(typeof(SpriteRenderer))
    self.boss_pro_num = self.transform:Find("Root/pro_bg/pro_num"):GetComponent(typeof(SuperTextMesh))
    
    function self.timer_action()
      self:CheckBossStatus()
    end
  end
end

function S1RestCityDefendMonster:OnDestroy()
  self:DeleteTimer()
  self.boss_root = nil
  self.boss_icon = nil
  self.boss_pro = nil
  self.boss_pro_num = nil
end

function S1RestCityDefendMonster:DeleteTimer()
  if self.timer ~= nil then
    self.timer:Stop()
    self.timer = nil
  end
end

function S1RestCityDefendMonster:AddTimer()
  if self.timer == nil then
    self.timer = TimerManager:GetInstance():GetTimer(1, self.timer_action, self, false, false, false)
  end
  self.timer:Start()
end

function S1RestCityDefendMonster:ReInit(marchUuid, lod)
  self.marchUuid = marchUuid
  self.lodCache = toInt(lod)
  local marchInfo = CS.SceneManager.World:GetMarch(marchUuid)
  if marchInfo ~= nil then
    local cityBattleS1MonsterInfo = marchInfo.cityBattleS1MonsterInfo
    if cityBattleS1MonsterInfo ~= nil then
      local cityIconType = toInt(cityBattleS1MonsterInfo.soldierType)
      if cityIconType == 1 then
        self.boss_icon:LoadSprite("Assets/Main/Sprites/UI/UILWHeroSquad/zyf_biandui_tanke_da.png")
      elseif cityIconType == 2 then
        self.boss_icon:LoadSprite("Assets/Main/Sprites/UI/UILWHeroSquad/zyf_biandui_daodan_da.png")
      elseif cityIconType == 3 then
        self.boss_icon:LoadSprite("Assets/Main/Sprites/UI/UILWHeroSquad/zyf_biandui_feiji_da.png")
      end
    end
  end
  self:UpdateLod(self.lodCache)
  self:AddTimer()
end

function S1RestCityDefendMonster:UpdateLod(lod)
  self.lodCache = toInt(lod)
  self:CheckBossStatus()
end

function S1RestCityDefendMonster:CheckBossStatus()
  self.boss_root:SetActive(false)
  local theWorld = CS.SceneManager.World
  if theWorld and self.marchUuid then
    local marchInfo = theWorld:GetMarch(self.marchUuid)
    if marchInfo ~= nil then
      local monsterHpRatio = marchInfo.monsterHpRatio
      if monsterHpRatio and 0 < monsterHpRatio then
        self:UpdateBlood(monsterHpRatio)
      else
      end
    end
  end
end

function S1RestCityDefendMonster:UpdateBlood(monsterHpRatio)
  if monsterHpRatio and 0 < monsterHpRatio and IsNotNull(self.boss_root) then
    if monsterHpRatio <= 0 or self.lodCache >= 3 then
      self.boss_root:SetActive(false)
      return
    end
    local rate = monsterHpRatio / 100
    local rateStr = string.percentage(monsterHpRatio, 100, 2)
    self.boss_pro_num.text = rateStr
    self.boss_pro:Set_size(1.3 * rate, 0.19)
    self.boss_root:SetActive(true)
  end
end

return S1RestCityDefendMonster
