local UIPVEBattleBuff = BaseClass("UIPVEBattleBuff", UIBaseContainer)
local base = UIBaseContainer
local UIPVEBattleBuffItem = require("UI.UIPVE.UIPVEMain.Component.UIPVEBattleBuffItem")
local list_path = "List"

local function OnCreate(self)
  base.OnCreate(self)
  self:DataDefine()
  self:ComponentDefine()
end

local function OnDestroy(self)
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

local function ComponentDefine(self)
  self.list_go = self:AddComponent(UIBaseContainer, list_path)
end

local function ComponentDestroy(self)
  self.list_go = nil
end

local function DataDefine(self)
  self.dataList = {}
  self.itemList = {}
  self.reqList = {}
end

local function DataDestroy(self)
  self.dataList = nil
  self.itemList = nil
  self.reqList = nil
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function OnAddListener(self)
  base.OnAddListener(self)
  self:AddUIListener(EventId.PveBattleBuffRefresh, self.OnPveBattleBuffRefresh)
end

local function OnRemoveListener(self)
  self:RemoveUIListener(EventId.PveBattleBuffRefresh, self.OnPveBattleBuffRefresh)
  base.OnRemoveListener(self)
end

local function ReInit(self)
  self:Refresh()
end

local function Refresh(self)
  self.dataList = {}
  local curTime = UITimeManager:GetInstance():GetServerTime()
  local list = DataCenter.BattleLevel:GetBattleBuffList()
  for _, v in ipairs(list) do
    local id = v.id or v.bId
    local line = LocalController:instance():getLine(TableName.BattleBuff, id)
    if line == nil then
      Logger.LogError("Error config aps_battlebuff id = " .. id)
      break
    end
    local type = tonumber(line:getValue("type"))
    if type == BattleBuffType.Effect then
      local buffListStr = tostring(line:getValue("buffId"))
      local icon = tostring(line:getValue("icon"))
      local localType = tonumber(line:getValue("LocalType"))
      local strs = string.split(buffListStr, "|")
      local timeType = tonumber(line:getValue("timetype")) or BattleBuffTimeType.Normal
      local total = tonumber(line:getValue("time")) or 0
      local startTime = v.st or 0
      local usedCount = v.ct or 0
      for _, str in ipairs(strs) do
        local spls = string.split(str, ";")
        if #spls == 2 then
          local buff = tonumber(spls[1])
          local val = tonumber(spls[2])
          local add = true
          if timeType == BattleBuffTimeType.Normal then
            for _, data in ipairs(self.dataList) do
              if data.buff == buff then
                data.val = data.val + val
                add = false
                break
              end
            end
          elseif timeType == BattleBuffTimeType.Battle then
            if total <= usedCount then
              add = false
            end
          elseif timeType == BattleBuffTimeType.Time and curTime < data.startTime + data.total * 1000 then
            add = false
          end
          if add then
            local data = {}
            data.type = type
            data.buff = buff
            data.val = val
            data.icon = icon
            data.localType = localType
            data.timeType = timeType
            data.total = total
            data.startTime = startTime
            data.usedCount = usedCount
            table.insert(self.dataList, data)
          end
        end
      end
    end
  end
  for index, data in pairs(self.dataList) do
    if self.itemList[index] == nil then
      if self.reqList[index] ~= nil then
        self.itemList[index]:Destroy()
      end
      self.reqList[index] = self:GameObjectInstantiateAsync(UIAssets.UIPVEBattleBuffItem, function(request)
        if request.isError then
          return
        end
        local go = request.gameObject
        go:SetActive(true)
        go.transform:SetParent(self.list_go.transform)
        go.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
        local nameStr = tostring(index)
        go.name = nameStr
        local item = self.list_go:AddComponent(UIPVEBattleBuffItem, nameStr)
        item:SetData(data)
        self.itemList[index] = item
      end)
    else
      self.itemList[index]:SetData(data)
    end
  end
  self:SetBuffEffectDict()
end

local function Update(self)
  local deltaTime = Time.deltaTime
  for _, item in ipairs(self.itemList) do
    item:OnUpdate(deltaTime)
  end
end

local function SetBuffEffectDict(self)
  local dict = {}
  for _, data in ipairs(self.dataList) do
    local buff = data.buff
    if dict[buff] == nil then
      dict[buff] = 0
    end
    dict[buff] = dict[buff] + data.val
  end
  DataCenter.BattleLevel:SetBuffEffectDict(dict)
end

local function OnPveBattleBuffRefresh(self)
  self:Refresh()
end

UIPVEBattleBuff.OnCreate = OnCreate
UIPVEBattleBuff.OnDestroy = OnDestroy
UIPVEBattleBuff.ComponentDefine = ComponentDefine
UIPVEBattleBuff.ComponentDestroy = ComponentDestroy
UIPVEBattleBuff.DataDefine = DataDefine
UIPVEBattleBuff.DataDestroy = DataDestroy
UIPVEBattleBuff.OnEnable = OnEnable
UIPVEBattleBuff.OnDisable = OnDisable
UIPVEBattleBuff.OnAddListener = OnAddListener
UIPVEBattleBuff.OnRemoveListener = OnRemoveListener
UIPVEBattleBuff.ReInit = ReInit
UIPVEBattleBuff.Refresh = Refresh
UIPVEBattleBuff.Update = Update
UIPVEBattleBuff.SetBuffEffectDict = SetBuffEffectDict
UIPVEBattleBuff.OnPveBattleBuffRefresh = OnPveBattleBuffRefresh
return UIPVEBattleBuff
