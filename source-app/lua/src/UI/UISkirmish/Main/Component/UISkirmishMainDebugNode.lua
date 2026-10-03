local UISkirmishMainDebugNode = BaseClass("UISkirmishMainDebugNode", UIBaseContainer)
local base = UIBaseContainer

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

local function OnDestroy(self)
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function ComponentDefine(self)
  self.debugNode = self:AddComponent(UIBaseComponent, "Debug")
  self.Debug_tog = self:AddComponent(UIToggle, "DebugToggle")
  self.debugNode:SetActive(false)
  self.Debug_tog:SetActive(false)
  if CS.CommonUtils.IsDebug() then
    self.Debug_tog:SetActive(true)
    self.Debug_tog:SetIsOn(false)
    self.Debug_tog:SetOnValueChanged(function(bool)
      self.debugNode:SetActive(bool)
    end)
    self.MinionPause_tog = self:AddComponent(UIToggle, "Debug/MinionPause")
    self.MinionPause_tog:SetIsOn(false)
    self.MinionPause_tog:SetOnValueChanged(function(bool)
      self.logic:SetMinionFightPause(bool)
    end)
    self.CaptainPause_tog = self:AddComponent(UIToggle, "Debug/CaptainPause")
    self.CaptainPause_tog:SetIsOn(false)
    self.CaptainPause_tog:SetOnValueChanged(function(bool)
      self.logic:SetCaptainFightPause(bool)
    end)
    self.BuffBar_tog = self:AddComponent(UIToggle, "Debug/BuffBar")
    self.BuffBar_tog:SetOnValueChanged(function(bool)
      if bool then
        UIManager:GetInstance():DestroyWindow(UIWindowNames.UIBuffBar, {anim = false})
      else
        UIManager:GetInstance():OpenWindow(UIWindowNames.UIBuffBar, {anim = false})
      end
    end)
    self.CaptainPause_tog:SetIsOn(false)
    self.UnDo_btn = self:AddComponent(UIButton, "Debug/UnDo")
    self.UnDo_btn:SetOnClick(function()
      self.logic:UnDo()
    end)
    self.UnReDo_btn = self:AddComponent(UIButton, "Debug/UnReDo")
    self.UnReDo_btn:SetOnClick(function()
      self.logic:UnReDo()
    end)
    self.ReDo_btn = self:AddComponent(UIButton, "Debug/ReDo")
    self.ReDo_btn:SetOnClick(function()
      self.logic:ReDo()
    end)
    self.CurAction = self:AddComponent(UIText, "Debug/CurAction")
    self.content = self:AddComponent(UIBaseContainer, "Debug/ScrollView/Viewport/Content")
    self.indexGO = self.transform:Find("Debug/ScrollView/Viewport/Content/Index").gameObject
    self.indexGO:GameObjectCreatePool()
    self.indexGO:SetActive(false)
    self.debugInfoText = self:AddComponent(UITextMeshProUGUI, "Debug/DebugInfoScrollView/Viewport/Content/Text")
    self.debugValueMap = {}
    local debugValueMap = self.debugValueMap
    debugValueMap.a = "attack"
    debugValueMap.d = "defense"
    debugValueMap.r = "restraintFactor"
    debugValueMap.c = "counterFactor"
    debugValueMap.g = "growFactor"
    debugValueMap.s = "skillAddition"
    debugValueMap.e = "extraFactor"
    debugValueMap.l = "levelFactor"
    debugValueMap.dp = "lwDamageParam"
    debugValueMap.pd = "pvpDamage"
    debugValueMap.dr = "damageRatio"
    debugValueMap.dm = "pveDamage"
  end
end

local function ComponentDestroy(self)
end

local function DataDefine(self)
  self.logic = DataCenter.LWBattleManager:GetCurBattleLogic()
end

local function DataDestroy(self)
end

local function OnAddListener(self)
  self:AddUIListener(EventId.SkirmishDoAction, self.OnSkirmishDoAction)
  self:AddUIListener(EventId.SkirmishUnDoAction, self.OnSkirmishUnDoAction)
end

local function OnRemoveListener(self)
  self:RemoveUIListener(EventId.SkirmishDoAction, self.OnSkirmishDoAction)
  self:RemoveUIListener(EventId.SkirmishUnDoAction, self.OnSkirmishUnDoAction)
end

local function OnSkirmishDoAction(self)
end

local function OnSkirmishUnDoAction(self, action)
  local index = action.order - 1
end

local function OnRefreshCurAction(self)
  if not CommonUtil.IsDebug() then
    return
  end
  if not action then
    self.CurAction:SetText("order:0")
    self.debugInfoText:SetText("")
    return
  end
  local targetStr = ""
  for i = 1, #action.targets do
    targetStr = targetStr .. action.targets[i].index .. "/"
  end
  self.CurAction:SetText("order" .. action.order .. " time" .. action.time .. " caster" .. action.casterIndex .. " phase" .. action.phase .. " skillId" .. action.skillId .. " targets" .. targetStr .. " uuid" .. self.logic.battleData.extData.pb_BattleReport.uuid)
  local debugInfo = action.debugInfo
  if string.IsNullOrEmpty(debugInfo) then
    self.debugInfoText:SetText("")
    return
  end
  local debugLog = ""
  local debugInfoArray = string.split(debugInfo, ";")
  local arrayLength = #debugInfoArray
  if 0 < arrayLength then
    local baseValue = debugInfoArray[1]
    if not string.IsNullOrEmpty(baseValue) then
      local baseValueArray = string.split(baseValue, ",")
      for _, v in ipairs(baseValueArray) do
        local arr = string.split(v, "=")
        if #arr == 2 then
          local key = self.debugValueMap[arr[1]] or "##"
          local con = string.format("%+40s = %-20s", key, arr[2])
          debugLog = debugLog .. con .. "\n"
        end
      end
    end
  end
  debugLog = debugLog .. "\n"
  if 2 < arrayLength then
    local attackEffect = debugInfoArray[2]
    local defenseEffect = debugInfoArray[3]
    local attackEffectArray = string.split(attackEffect, ",")
    local attackEffectArrayLength = #attackEffectArray
    local defenseEffectArray = string.split(defenseEffect, ",")
    local defenseEffectArrayLenght = #defenseEffectArray
    local effectMap = {}
    local num = Mathf.Max(attackEffectArrayLength, defenseEffectArrayLenght)
    local attack = num == attackEffectArrayLength
    if attack then
      for _, v in ipairs(defenseEffectArray) do
        local arr = string.split(v, ":")
        if #arr == 2 then
          local key = tonumber(arr[1]) or 0
          if 0 < key then
            effectMap[key] = tonumber(arr[2]) or 0
          end
        end
      end
    else
      for _, v in ipairs(attackEffectArray) do
        local arr = string.split(v, ":")
        if #arr == 2 then
          local key = tonumber(arr[1]) or 0
          if 0 < key then
            effectMap[key] = tonumber(arr[2]) or 0
          end
        end
      end
    end
    if attack then
      for _, v in ipairs(attackEffectArray) do
        local arr = string.split(v, ":")
        if #arr == 2 then
          local key = tonumber(arr[1]) or 0
          if 0 < key then
            local value = tonumber(arr[2]) or 0
            local difValue = effectMap[key] or 0
            if value ~= 0 or difValue ~= 0 then
              local cont = string.format("%-40s %+20s %+20s", key, value, difValue)
              debugLog = debugLog .. cont .. "\n"
            end
          end
        end
      end
    else
      for _, v in ipairs(defenseEffectArray) do
        local arr = string.split(v, ":")
        if #arr == 2 then
          local key = tonumber(arr[1]) or 0
          if 0 < key then
            local value = tonumber(arr[2]) or 0
            local difValue = effectMap[key] or 0
            if value ~= 0 or difValue ~= 0 then
              local cont = string.format("%-40s %+20s %+20s", key, difValue, value)
              debugLog = debugLog .. cont .. "\n"
            end
          end
        end
      end
    end
    Logger.Log(debugLog)
    self.debugInfoText:SetText(debugLog)
  end
end

UISkirmishMainDebugNode.OnCreate = OnCreate
UISkirmishMainDebugNode.OnDestroy = OnDestroy
UISkirmishMainDebugNode.OnEnable = OnEnable
UISkirmishMainDebugNode.OnDisable = OnDisable
UISkirmishMainDebugNode.ComponentDefine = ComponentDefine
UISkirmishMainDebugNode.ComponentDestroy = ComponentDestroy
UISkirmishMainDebugNode.DataDefine = DataDefine
UISkirmishMainDebugNode.DataDestroy = DataDestroy
UISkirmishMainDebugNode.OnAddListener = OnAddListener
UISkirmishMainDebugNode.OnRemoveListener = OnRemoveListener
UISkirmishMainDebugNode.OnSkirmishDoAction = OnSkirmishDoAction
UISkirmishMainDebugNode.OnSkirmishUnDoAction = OnSkirmishUnDoAction
UISkirmishMainDebugNode.OnRefreshCurAction = OnRefreshCurAction
return UISkirmishMainDebugNode
