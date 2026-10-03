local CityStrongholdBoss = BaseClass("CityStrongholdBoss")
local SpriteRenderer = CS.UnityEngine.SpriteRenderer
local SuperTextMesh = CS.SuperTextMesh

function CityStrongholdBoss:OnCreate(go)
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

function CityStrongholdBoss:OnDestroy()
  self:DeleteTimer()
  self.boss_root = nil
  self.boss_icon = nil
  self.boss_pro = nil
  self.boss_pro_num = nil
end

function CityStrongholdBoss:DeleteTimer()
  if self.timer ~= nil then
    self.timer:Stop()
    self.timer = nil
  end
end

function CityStrongholdBoss:AddTimer()
  if self.timer == nil then
    self.timer = TimerManager:GetInstance():GetTimer(1, self.timer_action, self, false, false, false)
  end
  self.timer:Start()
end

function CityStrongholdBoss:ReInit(marchUuid, lod)
  self.marchUuid = marchUuid
  self.lodCache = toInt(lod)
  local marchInfo = CS.SceneManager.World:GetMarch(marchUuid)
  if marchInfo ~= nil then
    local theCurServerId = LuaEntry.Player:GetCurServerId()
    local zoneId = SceneUtils.GetZoneIdByPosId(marchInfo.targetPos, marchInfo.targetServer)
    local cityMeta = DataCenter.AllianceCityTemplateManager:GetTemplate(zoneId, theCurServerId)
    if cityMeta ~= nil then
      local cityIconType = toInt(cityMeta.stronghold_army_type)
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

function CityStrongholdBoss:UpdateLod(lod)
  self.lodCache = toInt(lod)
  local theDetail = DataCenter.SeasonDataManager:GetMonsterDetail(self.marchUuid)
  if theDetail and toInt(theDetail.maxNum) > 0 then
    local curNum = toInt(theDetail.curNum)
    local maxNum = toInt(theDetail.maxNum)
    self:UpdateBlood(curNum, maxNum)
  else
    self.boss_root:SetActive(false)
  end
  self:CheckBossStatus()
end

function CityStrongholdBoss:CheckBossStatus()
  local theWorld = CS.SceneManager.World
  if theWorld and self.marchUuid then
    local marchInfo = theWorld:GetMarch(self.marchUuid)
    if marchInfo ~= nil then
      local curNum = toInt(marchInfo.strongholdBossNum)
      local maxNum = toInt(marchInfo.strongholdBossMax)
      if 0 < curNum and curNum <= maxNum and 0 < maxNum then
        self:UpdateBlood(curNum, maxNum)
      end
    end
  end
end

function CityStrongholdBoss:UpdateBlood(curNum, maxNum)
  if curNum ~= nil and maxNum ~= nil and type(maxNum) == "number" and 0 < maxNum and IsNotNull(self.boss_root) then
    if 0 >= toInt(curNum) or self.lodCache >= 3 then
      self.boss_root:SetActive(false)
      return
    end
    local rate = toInt(curNum) / maxNum
    local rateStr = string.percentage(toInt(curNum), maxNum, 2)
    self.boss_pro_num.text = rateStr
    self.boss_pro:Set_size(1.3 * rate, 0.19)
    self.boss_root:SetActive(true)
  end
end

return CityStrongholdBoss
