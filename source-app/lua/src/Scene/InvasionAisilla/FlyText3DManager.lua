local FlyText3DManager = BaseClass("FlyText3DManager")
local Resource = CS.GameEntry.Resource
local DamageFlyText = "Assets/Main/Prefabs/UI/Common/FlyText3D.prefab"
local White = Color.New(1, 1, 1, 1)
local Red = Color.New(0.9333333, 0, 0, 1)
local Blue = Color.New(0.29, 0.6, 0.87, 1)
local MAX_INSTANCE_ALIVE = 20

function FlyText3DManager:__init()
end

function FlyText3DManager:__delete()
  self:Destroy()
end

function FlyText3DManager:Init()
  self.flyTextReqs = {}
  self.flyTextList = {}
  self.flyTextMap = {}
  self.flyTextPool = {}
  self.flyTextsType = {}
  self.normalQueue = {}
  self.flyTextAlive = 0
  self.paramsPool = {}
end

function FlyText3DManager:Destroy()
  self:Clear()
  self.flyTextPool = nil
  self.paramsPool = nil
  self.flyTextList = nil
  self.flyTextMap = nil
  self.flyTextsType = nil
  self.normalQueue = nil
  self.flyTextAlive = nil
end

local color_cache = {}
local LUA_MATH_FLOOR = math.floor

function FlyText3DManager.GetColor32(color)
  if color_cache[color] then
    return color_cache[color]
  end
  local color32 = Color32.New(LUA_MATH_FLOOR(color.r * 255), LUA_MATH_FLOOR(color.g * 255), LUA_MATH_FLOOR(color.b * 255), LUA_MATH_FLOOR(color.a * 255))
  color_cache[color] = color32
  return color32
end

local function AddNewFlyTextToList(self, flyText)
  table.insert(self.flyTextList, flyText)
  self.flyTextMap[flyText] = true
end

local function RemoveFlyTextFromListIndex(self, index)
  if 0 < index and self.flyTextList[index] then
    local flyText = self.flyTextList[index]
    table.remove(self.flyTextList, index)
    if flyText then
      self.flyTextMap[flyText] = nil
    end
    self:FlyTextInPool(flyText)
  end
end

local function RemoveFlyTextFromList(self, flyText)
  if flyText and self.flyTextMap[flyText] then
    for i = #self.flyTextList, 1, -1 do
      if self.flyTextList[i] == flyText then
        table.remove(self.flyTextList, i)
        self:FlyTextInPool(flyText)
        break
      end
    end
  end
end

function FlyText3DManager:GenText(params)
  local style = params.style
  local time = params.duration
  if self.flyTextAlive > MAX_INSTANCE_ALIVE then
    local needToUnload = self.flyTextAlive - MAX_INSTANCE_ALIVE
    local unloadCnt = 0
    for _ = 1, needToUnload do
      local flyTextInst = self.normalQueue[1]
      if not IsNull(flyTextInst) then
        RemoveFlyTextFromList(self, flyTextInst)
        table.remove(self.normalQueue, 1)
        unloadCnt = unloadCnt + 1
      else
        break
      end
    end
  end
  local flyTime = 1
  if time then
    flyTime = tonumber(time) or 1
  end
  local flyText = self:GetFlyTextFromPool(DamageFlyText)
  if flyText then
    self:InitFlyText(params, flyTime, flyText)
    flyText.time = flyTime
    AddNewFlyTextToList(self, flyText)
    return
  end
  local flyTextInst = Resource:InstantiateAsync(DamageFlyText)
  table.insert(self.flyTextReqs, flyTextInst)
  flyTextInst:completed("+", function(req)
    local go = req.gameObject
    local req_trans = go.transform
    local numText = req_trans:Find("Scale/num"):GetComponent(typeof(CS.TextMeshProEx))
    local critIcon = req_trans:Find("Scale/num/critIcon"):GetComponent(typeof(CS.UnityEngine.SpriteRenderer))
    local simpleAnim = req_trans:GetComponent(typeof(CS.SimpleAnimation))
    local newFlyText = {
      go = go,
      req_trans = req_trans,
      numText = numText,
      critIcon = critIcon,
      simpleAnim = simpleAnim
    }
    newFlyText.prefabPath = DamageFlyText
    self:InitFlyText(params, flyTime, newFlyText)
    newFlyText.time = flyTime
    AddNewFlyTextToList(self, newFlyText)
    self:RecycleParam(params)
  end)
  if style == FlyText3DType.Normal then
    table.insert(self.normalQueue, flyTextInst)
  end
end

function FlyText3DManager:InitFlyText(param, flyTime, flyText)
  local damage = param.damage or 0
  local position = param.position
  local style = param.style
  local hasOffset = param.hasOffset
  local req_trans = flyText.req_trans
  local numText = flyText.numText
  local critIcon = flyText.critIcon
  local simpleAnim = flyText.simpleAnim
  local txt = ""
  local textColor = self.GetColor32(White)
  local animName = "fly"
  local showIcon = false
  local formattedDamage = ""
  if damage and type(damage) == "number" then
    formattedDamage = string.GetFormattedStr2(damage)
  else
    formattedDamage = damage
  end
  local yOffset = 0.1
  if style == FlyText3DType.Crit then
    textColor = self.GetColor32(Red)
    showIcon = true
  elseif style == FlyText3DType.ShieldBreaking then
    textColor = self.GetColor32(Blue)
  end
  txt = "-" .. formattedDamage
  simpleAnim:Stop()
  numText.text = txt
  numText.color32 = textColor
  local posX = position.x
  local posY = position.y
  local posZ = position.z
  if hasOffset then
    posX = posX + math.random() * 1.5 - 2
    posY = posY + math.random()
    req_trans:Set_localPosition(posX, posY, posZ)
  else
    req_trans:Set_localPosition(posX, posY, posZ)
  end
  req_trans:Set_localRotation(0, 0, 0, 1)
  if showIcon then
    local width = numText:GetPreferredValues(txt).x
    critIcon.transform:Set_localPosition(-0.6 - width / 2, yOffset, 0)
    critIcon.transform:Set_localScale(1.3, 1.3, 1)
  else
    critIcon.transform:Set_localScale(0, 0, 0)
  end
  simpleAnim:Rewind(animName)
  simpleAnim:Play(animName)
  if 0 < flyTime and flyTime ~= 1 then
    simpleAnim:SetStateSpeed(animName, 1 / flyTime)
  else
    simpleAnim:SetStateSpeed(animName, 1)
  end
end

function FlyText3DManager:GetFlyTextFromPool(prefabPath)
  local pool = self.flyTextPool[prefabPath]
  if pool == nil then
    self.flyTextPool[prefabPath] = {}
    return nil
  end
  local count = #pool
  if 0 < count then
    local text = table.remove(pool, count)
    text.go:SetActive(true)
    return text
  end
  return nil
end

function FlyText3DManager:FlyTextInPool(flyText)
  local prefabPath = flyText.prefabPath
  local pool = self.flyTextPool[prefabPath]
  if pool then
    table.insert(pool, flyText)
    flyText.go:SetActive(false)
  end
end

function FlyText3DManager:OnUpdate()
  local deltaTime = Time.deltaTime
  local count = #self.flyTextList
  self.flyTextAlive = count
  for i = count, 1, -1 do
    local flyText = self.flyTextList[i]
    local time = flyText.time
    if time <= 0 then
      RemoveFlyTextFromListIndex(self, i)
    else
      time = time - deltaTime
      flyText.time = time
      self.flyTextAlive = self.flyTextAlive + 1
    end
  end
  for i = #self.normalQueue, 1, -1 do
    local flyTextInst = self.normalQueue[i]
    if not self.flyTextMap[flyTextInst] then
      table.remove(self.normalQueue, i)
    end
  end
end

function FlyText3DManager:Clear()
  if self.flyTextReqs then
    for _, v in ipairs(self.flyTextReqs) do
      if v then
        v:Destroy()
      end
    end
    self.flyTextReqs = nil
  end
end

function FlyText3DManager:ClearAllActive()
  if self.flyTextList then
    local count = #self.flyTextList
    for i = count, 1, -1 do
      RemoveFlyTextFromListIndex(self, i)
    end
  end
  self.flyTextAlive = 0
  if self.normalQueue then
    table.clear(self.normalQueue)
  end
end

function FlyText3DManager:RecycleParam(param)
  for k, v in pairs(param) do
    param[k] = nil
  end
  param.style = 0
  param.damage = ""
  self.paramsPool[#self.paramsPool + 1] = param
end

function FlyText3DManager:GetParam()
  local param
  if #self.paramsPool > 0 then
    param = self.paramsPool[#self.paramsPool]
    self.paramsPool[#self.paramsPool] = nil
  else
    param = {}
  end
  return param
end

return FlyText3DManager
