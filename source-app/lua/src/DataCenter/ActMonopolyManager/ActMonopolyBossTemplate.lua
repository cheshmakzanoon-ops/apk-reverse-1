local ActMonopolyBossTemplate = BaseClass("ActMonopolyBossTemplate")

local function __init(self)
  self.id = 0
  self.name = ""
  self.model = ""
  self.effect1 = ""
  self.effect2 = ""
  self.effect3_desc = ""
  self.bullet_boss_hp_total = 0
  self.bullet_boss_hp = ""
  self.bullet_boss_hp_list = {}
  self.alliance_boss_gift = ""
  self.alliance_boss_gift_list = {}
  self.bullet_boss_hp_weak = 0
  self.bullet_boss_reward_limit_num = 0
  self.atk_goods_id = 0
  self.atkGoodsDamage1 = nil
  self.atkGoodsDamage2 = nil
end

local function __delete(self)
  self.id = nil
  self.name = nil
  self.model = nil
  self.effect1 = nil
  self.effect2 = nil
  self.effect3_desc = nil
  self.bullet_boss_hp_total = nil
  self.bullet_boss_hp = nil
  self.alliance_boss_gift = nil
  self.alliance_boss_gift_list = nil
  self.bullet_boss_reward = nil
  self.alliance_boss_gift = nil
  self.bullet_boss_hp_weak = nil
  self.bullet_boss_reward_limit_num = nil
  self.atk_goods_id = nil
  self.atkGoodsDamage1 = nil
  self.atkGoodsDamage2 = nil
end

local function InitData(self, row)
  if row == nil then
    return
  end
  self.id = tonumber(row:getValue("id")) or 0
  self.name = row:getValue("name") or ""
  self.model = row:getValue("model") or ""
  self.effect1 = row:getValue("effect1") or ""
  self.effect2 = row:getValue("effect2") or ""
  self.effect3_desc = row:getValue("effect3_desc") or ""
  self.bullet_boss_hp_total = tonumber(row:getValue("bullet_boss_hp_total")) or 0
  self.bullet_boss_hp = row:getValue("bullet_boss_hp")
  if not string.IsNullOrEmpty(self.bullet_boss_hp) then
    self.bullet_boss_hp_list = string.string2array_i_oneSep(self.bullet_boss_hp, ",")
  end
  self.alliance_boss_gift = row:getValue("alliance_boss_gift")
  if not string.IsNullOrEmpty(self.alliance_boss_gift) then
    self.alliance_boss_gift_list = string.string2array_i_oneSep(self.alliance_boss_gift, ",")
  end
  self.bullet_boss_hp_weak = tonumber(row:getValue("bullet_boss_hp_weak")) or 0
  self.atk_goods_id = tonumber(row:getValue("atk_goods_id")) or 0
  local rewardLimitStr = row:getValue("bullet_boss_reward_limit") or ""
  if not string.IsNullOrEmpty(rewardLimitStr) then
    local rewardLimitList = string.string2array_i_oneSep(rewardLimitStr)
    if 2 <= #rewardLimitList then
      self.bullet_boss_reward_limit_num = tonumber(rewardLimitList[2]) or 0
    end
  end
end

local function GetAtkGoodsDamage(self)
  if self.atkGoodsDamage1 == nil then
    self.atkGoodsDamage1 = 0
    self.atkGoodsDamage2 = 0
    if 0 < self.atk_goods_id then
      local good = DataCenter.ItemTemplateManager:GetItemTemplate(self.atk_goods_id)
      if good then
        local damageStr = good.para1
        local damageData = string.string2array_i(damageStr, ";", "|")
        if 1 <= #damageData then
          self.atkGoodsDamage1 = damageData[1][1]
        end
        if 2 <= #damageData then
          self.atkGoodsDamage2 = damageData[2][1]
        end
      end
    end
  end
  return self.atkGoodsDamage1, self.atkGoodsDamage2
end

ActMonopolyBossTemplate.__init = __init
ActMonopolyBossTemplate.__delete = __delete
ActMonopolyBossTemplate.InitData = InitData
ActMonopolyBossTemplate.GetAtkGoodsDamage = GetAtkGoodsDamage
return ActMonopolyBossTemplate
