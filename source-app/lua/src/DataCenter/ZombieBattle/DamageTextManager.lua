local DamageTextManager = BaseClass("DamageTextManager")
local Resource = CS.GameEntry.Resource
local Localization = CS.GameEntry.Localization
local DamageTextGPUManager = CS.GPUDamageText.DamageNumManager
local SystemInfo = CS.UnityEngine.SystemInfo
local MAX_INSTANCE_PERFRAME = 20
local MAX_INSTANCE_ALIVE = 40
local PREFAB_PHYSIC_ATTACK = "Assets/Main/Prefabs/LWBattle/DamageFlyText_PhysicAttack.prefab"
local PREFAB_DRONE_ATTACK = "Assets/Main/Prefabs/LWBattle/DamageFlyText_DroneAttack.prefab"
local PREFAB_MAGIC_ATTACK = "Assets/Main/Prefabs/LWBattle/DamageFlyText_MagicAttack.prefab"
local PREFAB_SELF_HURT = "Assets/Main/Prefabs/LWBattle/DamageFlyText_SelfHurt.prefab"
local PREFAB_BUFF = "Assets/Main/Prefabs/LWBattle/BuffFlyText_Buff.prefab"
local PREFAB_DE_BUFF = "Assets/Main/Prefabs/LWBattle/BuffFlyText_DeBuff.prefab"
local PREFAB_REAL_DMG = "Assets/Main/Prefabs/LWBattle/DamageFlyText_RealDmg.prefab"
local PREFAB_SHIELD = "Assets/Main/Prefabs/LWBattle/DamageFlyText_Shield.prefab"
local PREFAB_PHYSIC_SKILL_ATTACK = "Assets/Main/Prefabs/LWBattle/DamageFlyText_PhysicSkillAttack.prefab"
local PREFAB_MAGIC_SKILL_ATTACK = "Assets/Main/Prefabs/LWBattle/DamageFlyText_MagicSkillAttack.prefab"
local PREFAB_REAL_DMG_SKILL = "Assets/Main/Prefabs/LWBattle/DamageFlyText_RealDmgSkill.prefab"
local textStyle = {
  FullText = 1,
  DamageText = 2,
  CritDamageText = 3
}
local GPUDamageStyleType = {
  Real = 0,
  Physic = 1,
  Magic = 2,
  Shield = 3,
  SelfHurt = 4,
  Plane = 5
}
local smallFontSize = 5.4
local normalFontSize = smallFontSize * 1.25
local BigFontSize = smallFontSize * 1.5
local iconDefaultSize = 1.2
local icon2FontOffset = -0.4

function DamageTextManager:__init(basicFontSize, bornOffsetY, optMaxNum)
  self.smallFontSize = basicFontSize or smallFontSize
  self.normalFontSize = basicFontSize and basicFontSize * 1.25 or normalFontSize
  self.bigFontSize = basicFontSize and basicFontSize * 1.5 or BigFontSize
  self.bornOffsetY = bornOffsetY or 0
  self.iconDefaultSize = basicFontSize and basicFontSize / smallFontSize * iconDefaultSize or iconDefaultSize
  self.icon2FontOffset = basicFontSize and basicFontSize / smallFontSize * icon2FontOffset or icon2FontOffset
  self.optMaxNum = optMaxNum
  if self.optMaxNum then
    self.maxInstanceAlive = 20
    self.maxInstancePerFrame = 10
  else
    self.maxInstanceAlive = MAX_INSTANCE_ALIVE
    self.maxInstancePerFrame = MAX_INSTANCE_PERFRAME
  end
  self.useGPUInstancing = DataCenter.FunctionOnManager:IsServerSwitchOn(ServerSwitch.GPUDamageNum) and SystemInfo.supportsInstancing
end

function DamageTextManager:__delete()
  self:Destroy()
end

function DamageTextManager:Init()
  self.flyTextReqs = {}
  self.flyTextList = list:new()
  self.flyTextMap = {}
  self.flyTextPool = {}
  self.curFrameTaskCount = 0
  self.lastFrameTaskCount = 0
  self.flyTextsType = {}
  self.normalAttackQueue = list:new()
  self.normalAttackMap = {}
  self.paramsPool = {}
  if self.useGPUInstancing then
    DamageTextGPUManager.Instance:Init()
  end
end

function DamageTextManager:Destroy()
  if self.flyTextReqs then
    for _, v in ipairs(self.flyTextReqs) do
      v:Destroy()
    end
  end
  if self.useGPUInstancing then
    DamageTextGPUManager.Instance:Clear()
  end
  self.flyTextReqs = nil
  self.flyTextList = nil
  self.flyTextMap = nil
  self.flyTextPool = nil
  self.curFrameTaskCount = 0
  self.lastFrameTaskCount = 0
  self.flyTextsType = {}
  self.normalAttackQueue = nil
  self.normalAttackMap = nil
  self.useGPUInstancing = false
end

function DamageTextManager.GetDamageTypePrefab(damageType)
  if damageType and damageType == DamageType.Physics then
    return PREFAB_PHYSIC_ATTACK
  elseif damageType and damageType == DamageType.Magic then
    return PREFAB_MAGIC_ATTACK
  else
    return PREFAB_REAL_DMG
  end
end

function DamageTextManager.GetDamageTypeSKillPrefab(damageType)
  if damageType and damageType == DamageType.Physics then
    return PREFAB_PHYSIC_SKILL_ATTACK
  elseif damageType and damageType == DamageType.Magic then
    return PREFAB_MAGIC_SKILL_ATTACK
  else
    return PREFAB_REAL_DMG_SKILL
  end
end

function DamageTextManager.GetGPUDamageType(damageType)
  if damageType and damageType == DamageType.Physics then
    return GPUDamageStyleType.Physic
  elseif damageType and damageType == DamageType.Magic then
    return GPUDamageStyleType.Magic
  else
    return GPUDamageStyleType.Real
  end
end

local color_cache = {}
local LUA_MATH_FLOOR = math.floor

function DamageTextManager.GetColor32(color)
  if color_cache[color] then
    return color_cache[color]
  end
  local color32 = Color32.New(LUA_MATH_FLOOR(color.r * 255), LUA_MATH_FLOOR(color.g * 255), LUA_MATH_FLOOR(color.b * 255), LUA_MATH_FLOOR(color.a * 255))
  color_cache[color] = color32
  return color32
end

local function AddNewFlyTextToList(self, flyText, style)
  local node = self.flyTextList:push(flyText)
  self.flyTextMap[flyText] = node
  if style == DamageTextType.HeroNormalAttack then
    node = self.normalAttackQueue:push(node)
    self.normalAttackMap[flyText] = node
  end
end

local function RemoveFlyTextFromListIndex(self, index)
  if index <= 0 then
    return
  end
  local node = self.flyTextList:findByIndex(index)
  if 0 < index and node then
    local flyText = node.value
    self.flyTextList:remove(node)
    if flyText then
      self.flyTextMap[flyText] = nil
    end
    local normalAttackNode = self.normalAttackMap[flyText]
    if normalAttackNode then
      self.normalAttackQueue:remove(normalAttackNode)
      self.normalAttackMap[flyText] = nil
    end
    self:FlyTextInPool(flyText)
  end
end

local function RemoveFlyTextFromHead(self)
  local flyText = self.flyTextList:shift()
  if not IsNull(flyText) then
    self.flyTextMap[flyText] = nil
    local normalAttackNode = self.normalAttackMap[flyText]
    if normalAttackNode then
      self.normalAttackQueue:remove(normalAttackNode)
      self.normalAttackMap[flyText] = nil
    end
    self:FlyTextInPool(flyText)
  end
end

local function RemoveFlyTextFromList(self, flyText)
  if flyText and self.flyTextMap[flyText] then
    local node = self.flyTextMap[flyText]
    self.flyTextList:remove(node)
    self.flyTextMap[flyText] = nil
    local normalAttackNode = self.normalAttackMap[flyText]
    if normalAttackNode then
      self.normalAttackQueue:remove(normalAttackNode)
      self.normalAttackMap[flyText] = nil
    end
    self:FlyTextInPool(flyText)
  end
end

local To_Delete = {}

function DamageTextManager:GenText(params)
  local style = params.style
  local time = params.time
  if self.useGPUInstancing and style ~= DamageTextType.Miss and style ~= DamageTextType.DisperseEffect and style ~= DamageTextType.TriggerItem and style ~= DamageTextType.GetBuff then
    if self.optMaxNum and DamageTextGPUManager.Instance:GetAliveCount() >= self.maxInstanceAlive then
      return
    end
    self.curFrameTaskCount = self.curFrameTaskCount + 1
    local paramsGen = self:GetFlyGPUParams(params)
    local flyTime = 1
    if time then
      flyTime = tonumber(time) or 1
    end
    local scaleGrowFactor = paramsGen.flyFontSize
    local damage = paramsGen.damage
    if not IsNumber(paramsGen.damage) then
      damage = tonumber(paramsGen.damage)
    end
    damage = math.ceil(damage)
    DamageTextGPUManager.Instance:AddDamageNum(paramsGen.gpuDamageStyleType, paramsGen.isCritical and 1 or 0, damage, paramsGen.showIcon, paramsGen.flyFontPosX, paramsGen.flyFontPosY, paramsGen.flyFontPosZ, paramsGen.flyAnimStyle, scaleGrowFactor, flyTime)
    self:RecycleParam(params)
  else
    if self.lastFrameTaskCount > self.maxInstancePerFrame and style == DamageTextType.HeroNormalAttack then
      return
    end
    for i = 1, #To_Delete do
      To_Delete[i] = nil
    end
    local aliveCount = self.flyTextList.length
    local needToUnload = aliveCount - self.maxInstanceAlive
    local unloadNormalAttackCount = 0
    if 0 < needToUnload then
      for i = 1, needToUnload do
        local flyTextInst = self.normalAttackQueue:shift()
        if not IsNull(flyTextInst) then
          unloadNormalAttackCount = unloadNormalAttackCount + 1
          To_Delete[unloadNormalAttackCount] = flyTextInst.value
        else
          break
        end
      end
    end
    for i = 1, #To_Delete do
      RemoveFlyTextFromList(self, To_Delete[i])
    end
    if self.optMaxNum and self.flyTextList.length >= self.maxInstanceAlive then
      return
    end
    self.curFrameTaskCount = self.curFrameTaskCount + 1
    local paramsGen = self:GetFlyParams(params)
    local prefabPath = paramsGen.flyPrefabPath
    local flyTime = 1
    if time then
      flyTime = tonumber(time) or 1
    end
    local flyText = self:GetFlyTextFromPool(prefabPath)
    if flyText then
      self:InitFlyText(paramsGen, flyTime, flyText)
      flyText.time = flyTime
      AddNewFlyTextToList(self, flyText, style)
      self:RecycleParam(paramsGen)
      return
    end
    local flyTextInst = Resource:InstantiateAsync(prefabPath, ObjectPoolTag.Battle)
    table.insert(self.flyTextReqs, flyTextInst)
    flyTextInst:completed("+", function(req)
      local go = req.gameObject
      local req_trans = go.transform
      local numTextTrans = req_trans:Find("Scale/num")
      local numText
      if IsNotNull(numTextTrans) then
        numText = numTextTrans:GetComponent(typeof(CS.TextMeshProEx))
      end
      local critIconTran = req_trans:Find("Scale/num/critIcon")
      local critIcon
      if IsNotNull(critIconTran) then
        critIcon = critIconTran:GetComponent(typeof(CS.UnityEngine.SpriteRenderer))
      end
      local simpleAnim = req_trans:GetComponent(typeof(CS.SimpleAnimation))
      local newFlyText = {
        go = go,
        req_trans = req_trans,
        numText = numText,
        critIcon = critIcon,
        simpleAnim = simpleAnim
      }
      newFlyText.prefabPath = prefabPath
      self:InitFlyText(paramsGen, flyTime, newFlyText)
      newFlyText.time = flyTime
      AddNewFlyTextToList(self, newFlyText, style)
      self:RecycleParam(paramsGen)
    end)
  end
end

function DamageTextManager:GetFlyGPUParams(param)
  local position = param.position
  local style = param.style
  local showIcon = false
  local damageType = param.damageType
  local isCritical = param.isCritical
  local gpuDamageStyleType = GPUDamageStyleType.Real
  local gpuAnimStyle = 1
  local randomX = 0
  local randomY = 0
  local randomYSpan = 2
  local showDamageStyle = textStyle.DamageText
  local fontSize = self.smallFontSize
  if style == DamageTextType.HeroNormalAttack then
    gpuDamageStyleType = self.GetGPUDamageType(damageType)
    if isCritical then
      gpuAnimStyle = 8
      fontSize = self.normalFontSize
    end
    if damageType == DamageType.RealDamage then
      gpuAnimStyle = 2
      fontSize = self.normalFontSize
      randomX = math.random() * 3 - 2
      randomY = math.random() * 1.5 + 2
    else
      randomX = 0
      randomY = math.ceil(math.random() * 5) * 0.2 * randomYSpan
    end
  elseif style == DamageTextType.ZombieNormalAttack then
    fontSize = self.normalFontSize
    gpuDamageStyleType = GPUDamageStyleType.SelfHurt
    randomX = 0
    randomY = math.ceil(math.random() * 5) * 0.2 * randomYSpan
  elseif style == DamageTextType.HeroUltimate then
    fontSize = self.normalFontSize
    gpuAnimStyle = 4
    showIcon = true
    if isCritical then
      fontSize = self.bigFontSize
    end
    if damageType == DamageType.RealDamage then
      gpuAnimStyle = 2
      fontSize = self.normalFontSize
    end
    gpuDamageStyleType = self.GetGPUDamageType(damageType)
    randomX = math.random() * 3 - 2
    randomY = math.random() * 1.5 + 2
  elseif style == DamageTextType.ZombieUltimate then
    fontSize = self.normalFontSize
    gpuAnimStyle = 4
    gpuDamageStyleType = GPUDamageStyleType.SelfHurt
    randomX = math.random() * 3 - 2
    randomY = math.random() * 1.5 + 2
  elseif style == DamageTextType.ReduceDamageBuff then
    fontSize = self.normalFontSize
    gpuAnimStyle = 2
    showDamageStyle = textStyle.DamageText
    gpuDamageStyleType = GPUDamageStyleType.Shield
    showIcon = true
  elseif style == DamageTextType.Drone then
    fontSize = self.normalFontSize
    gpuAnimStyle = 2
    gpuDamageStyleType = GPUDamageStyleType.Plane
    randomX = math.random() * 3 - 2
    randomY = math.random() * 1.5 + 2
    showIcon = true
  elseif style == DamageTextType.Dot then
    fontSize = self.smallFontSize
    gpuAnimStyle = 5
    gpuDamageStyleType = self.GetGPUDamageType(damageType)
    if damageType == DamageType.RealDamage then
      gpuAnimStyle = 2
      fontSize = self.normalFontSize
      randomX = math.random() * 3 - 2
      randomY = math.random() * 1.5 + 2
    end
  elseif style == DamageTextType.Splash then
    fontSize = self.smallFontSize
    gpuAnimStyle = 5
    gpuDamageStyleType = self.GetGPUDamageType(damageType)
    if damageType == DamageType.RealDamage then
      gpuAnimStyle = 2
      fontSize = self.normalFontSize
      randomX = math.random() * 3 - 2
      randomY = math.random() * 1.5 + 2
    end
  elseif style == DamageTextType.ShieldDamage then
    fontSize = self.normalFontSize
    gpuAnimStyle = 2
    gpuDamageStyleType = GPUDamageStyleType.Shield
    randomX = math.random() * 3 - 2
    randomY = math.random() * 1.5 + 2
    showIcon = true
  end
  local posX = position.x + randomX
  local posY = position.y + randomY + self.bornOffsetY
  local posZ = position.z
  param.gpuDamageStyleType = gpuDamageStyleType
  param.flyFontSize = fontSize
  param.flyFontPosX = posX
  param.flyFontPosY = posY
  param.flyFontPosZ = posZ
  param.flyAnimStyle = gpuAnimStyle
  param.isCritical = isCritical
  param.showIcon = showIcon
  return param
end

function DamageTextManager:GetFlyParams(param)
  local damage = param.damage or 0
  local position = param.position
  local style = param.style
  local damageType = param.damageType
  local isCritical = param.isCritical
  local combo = param.combo
  local prefabPath = PREFAB_REAL_DMG
  local isShield = false
  local iconPath
  local isCustomIcon = false
  local animName = "fly"
  local formattedDamage = ""
  local randomX = 0
  local randomY = 0
  local randomYSpan = 2
  local showDamageStyle = textStyle.DamageText
  if damage and type(damage) == "number" then
    formattedDamage = string.GetFormattedStr2(damage)
  else
    formattedDamage = damage
  end
  local txt = formattedDamage
  local fontSize = self.smallFontSize
  local yOffset = 0
  if style == DamageTextType.HeroNormalAttack then
    showDamageStyle = textStyle.DamageText
    if isCritical then
      showDamageStyle = textStyle.CritDamageText
      animName = "CritAttack"
      fontSize = self.normalFontSize
    end
    prefabPath = self.GetDamageTypePrefab(damageType)
    if damageType == DamageType.RealDamage then
      animName = "hold"
      fontSize = self.normalFontSize
      randomX = math.random() * 3 - 2
      randomY = math.random() * 1.5 + 2
    else
      randomX = 0
      randomY = math.ceil(math.random() * 5) * 0.2 * randomYSpan
    end
  elseif style == DamageTextType.ZombieNormalAttack then
    fontSize = self.normalFontSize
    showDamageStyle = textStyle.DamageText
    randomX = 0
    randomY = math.ceil(math.random() * 5) * 0.2 * randomYSpan
    prefabPath = PREFAB_SELF_HURT
  elseif style == DamageTextType.HeroUltimate then
    fontSize = self.normalFontSize
    showDamageStyle = textStyle.DamageText
    animName = "CritSkill"
    if isCritical then
      showDamageStyle = textStyle.CritDamageText
      fontSize = self.bigFontSize
    end
    if damageType == DamageType.RealDamage then
      animName = "hold"
      fontSize = self.normalFontSize
    end
    prefabPath = self.GetDamageTypeSKillPrefab(damageType)
    randomX = math.random() * 3 - 2
    randomY = math.random() * 1.5 + 2
  elseif style == DamageTextType.ZombieUltimate then
    fontSize = self.normalFontSize
    animName = "CritSkill"
    showDamageStyle = textStyle.DamageText
    prefabPath = PREFAB_SELF_HURT
    randomX = math.random() * 3 - 2
    randomY = math.random() * 1.5 + 2
  elseif style == DamageTextType.GetBuff then
    fontSize = self.normalFontSize
    txt = param.txt or ""
    showDamageStyle = textStyle.FullText
    animName = "Default"
    fontSize = self.bigFontSize
    isCustomIcon = true
    local isDebuff = param.isDebuff
    if isDebuff then
      animName = "Debuff"
      prefabPath = PREFAB_DE_BUFF
    else
      animName = "Buff"
      prefabPath = PREFAB_BUFF
    end
    local _iconPath = param.iconPath
    if not string.IsNullOrEmpty(_iconPath) then
      iconPath = _iconPath
    end
  elseif style == DamageTextType.TriggerItem then
    txt = param.txt or ""
    showDamageStyle = textStyle.FullText
    animName = "Buff"
    isCustomIcon = true
    prefabPath = PREFAB_BUFF
    yOffset = 0
  elseif style == DamageTextType.ReduceDamageBuff then
    fontSize = self.normalFontSize
    isShield = true
    animName = "hold"
    showDamageStyle = textStyle.DamageText
    prefabPath = PREFAB_SHIELD
  elseif style == DamageTextType.Drone then
    fontSize = self.normalFontSize
    animName = "hold"
    showDamageStyle = textStyle.DamageText
    prefabPath = PREFAB_DRONE_ATTACK
    randomX = math.random() * 3 - 2
    randomY = math.random() * 1.5 + 2
  elseif style == DamageTextType.Dot then
    fontSize = self.smallFontSize
    animName = "Dot"
    prefabPath = self.GetDamageTypePrefab(damageType)
    showDamageStyle = textStyle.DamageText
    if damageType == DamageType.RealDamage then
      animName = "hold"
      fontSize = self.normalFontSize
      randomX = math.random() * 3 - 2
      randomY = math.random() * 1.5 + 2
    end
  elseif style == DamageTextType.Miss then
    txt = "MISS"
    showDamageStyle = textStyle.FullText
  elseif style == DamageTextType.Splash then
    fontSize = self.smallFontSize
    animName = "Dot"
    prefabPath = self.GetDamageTypePrefab(damageType)
    showDamageStyle = textStyle.DamageText
    if damageType == DamageType.RealDamage then
      animName = "hold"
      fontSize = self.normalFontSize
      randomX = math.random() * 3 - 2
      randomY = math.random() * 1.5 + 2
    end
  elseif style == DamageTextType.DisperseEffect then
    fontSize = self.normalFontSize
    animName = "Default"
    txt = param.txt or ""
    isCustomIcon = true
    showDamageStyle = textStyle.FullText
    local isDebuff = param.isDebuff
    if isDebuff then
      animName = "Debuff"
      prefabPath = PREFAB_DE_BUFF
      iconPath = LuaEntry.DataConfig:TryGetStr("qusan_action", "k1")
      if combo and 1 < combo then
        txt = Localization:GetString("lw_action_qusan") .. "\195\151" .. combo
      else
        txt = Localization:GetString("lw_action_qusan")
      end
    else
      animName = "Buff"
      prefabPath = PREFAB_BUFF
      iconPath = LuaEntry.DataConfig:TryGetStr("qusan_action", "k2")
      if combo and 1 < combo then
        txt = Localization:GetString("lw_buff_jinghua") .. "\195\151" .. combo
      else
        txt = Localization:GetString("lw_buff_jinghua")
      end
    end
  elseif style == DamageTextType.ShieldDamage then
    fontSize = self.normalFontSize
    isShield = true
    animName = "hold"
    showDamageStyle = textStyle.DamageText
    prefabPath = PREFAB_SHIELD
    randomX = math.random() * 3 - 2
    randomY = math.random() * 1.5 + 2
  end
  local posX = position.x + randomX
  local posY = position.y + randomY + self.bornOffsetY
  local posZ = position.z
  param.flyText = txt
  param.showDamageStyle = showDamageStyle
  param.flyFontSize = fontSize
  param.flyFontPosX = posX
  param.flyFontPosY = posY
  param.flyFontPosZ = posZ
  param.flyIconPath = iconPath
  param.flyPrefabPath = prefabPath
  param.flyAnimName = animName
  param.isCustomIcon = isCustomIcon
  param.iconScaleFactor = fontSize / self.smallFontSize
  return param
end

function DamageTextManager:InitFlyText(param, flyTime, flyText)
  local req_trans = flyText.req_trans
  local numText = flyText.numText
  local critIcon = flyText.critIcon
  local simpleAnim = flyText.simpleAnim
  local prevIconPath = flyText.iconPath
  simpleAnim:Stop()
  if IsNotNull(numText) then
    if not (flyText.lastFlyText and flyText.lastShowDamageStyle) or flyText.lastFlyText ~= param.flyText or flyText.lastShowDamageStyle ~= param.showDamageStyle then
      local showedText = ""
      if param.showDamageStyle == textStyle.FullText then
        showedText = param.flyText
      elseif param.showDamageStyle == textStyle.DamageText then
        showedText = "-" .. param.flyText
      elseif param.showDamageStyle == textStyle.CritDamageText then
        showedText = "-" .. param.flyText .. "!"
      end
      numText.text = showedText
      flyText.lastFlyText = param.flyText
      flyText.lastShowDamageStyle = param.showDamageStyle
    end
    numText.fontSize = param.flyFontSize
  end
  req_trans:Set_localPosition(param.flyFontPosX or 0, param.flyFontPosY or 0, param.flyFontPosZ or 0)
  if IsNotNull(critIcon) then
    local showIcon = not param.isCustomIcon or param.isCustomIcon and param.flyIconPath ~= nil
    if showIcon then
      critIcon.enabled = true
      if param.flyIconPath and (prevIconPath == nil or param.flyIconPath ~= prevIconPath) then
        critIcon:LoadSprite(param.flyIconPath)
      end
      local scale = param.iconScaleFactor * self.iconDefaultSize
      critIcon.transform:Set_localScale(scale, scale, 1)
      local width = numText:GetPreferredValues(param.flyText).x
      critIcon.transform:Set_localPosition(self.icon2FontOffset * param.iconScaleFactor - width / 2, 0, 0)
    else
      critIcon.enabled = false
    end
    flyText.iconPath = param.flyIconPath
  end
  if 0 < flyTime and flyTime ~= 1 then
    simpleAnim:SetStateSpeed(param.flyAnimName, 1 / flyTime)
  else
    simpleAnim:SetStateSpeed(param.flyAnimName, 1)
  end
  simpleAnim:RewindAndPlay(param.flyAnimName)
end

function DamageTextManager:GetFlyTextFromPool(prefabPath)
  local pool = self.flyTextPool[prefabPath]
  if pool == nil then
    self.flyTextPool[prefabPath] = {}
    return nil
  end
  local count = #pool
  if 0 < count then
    local text = table.remove(pool, count)
    if IsNotNull(text.critIcon) then
      text.critIcon.enabled = true
    end
    return text
  end
  return nil
end

function DamageTextManager:FlyTextInPool(flyText)
  local prefabPath = flyText.prefabPath
  local pool = self.flyTextPool[prefabPath]
  if pool then
    table.insert(pool, flyText)
    if IsNotNull(flyText.numText) then
      flyText.numText.fontSize = 0
    end
    if IsNotNull(flyText.critIcon) then
      flyText.critIcon.enabled = false
    end
    if IsNotNull(flyText.simpleAnim) then
      flyText.simpleAnim:Stop()
    end
  end
end

function DamageTextManager:OnUpdate()
  self.lastFrameTaskCount = self.curFrameTaskCount
  self.curFrameTaskCount = 0
  local deltaTime = Time.deltaTime
  if self.useGPUInstancing then
    DamageTextGPUManager.Instance:Update()
  end
  if 0 >= self.flyTextList.length then
    return
  end
  for k, flyText in ilist(self.flyTextList) do
    local time = flyText.time
    time = time - deltaTime
    if time <= 0 then
      RemoveFlyTextFromList(self, flyText)
    else
      flyText.time = time
    end
  end
end

function DamageTextManager:RecycleParam(param)
  for k, v in pairs(param) do
    param[k] = nil
  end
  param.style = 0
  param.damage = ""
  self.paramsPool[#self.paramsPool + 1] = param
end

function DamageTextManager:GetParam()
  local param
  if #self.paramsPool > 0 then
    param = self.paramsPool[#self.paramsPool]
    self.paramsPool[#self.paramsPool] = nil
  else
    param = {}
  end
  return param
end

return DamageTextManager
