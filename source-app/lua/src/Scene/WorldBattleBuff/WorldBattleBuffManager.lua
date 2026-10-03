local WorldBattleBuffManager = BaseClass("WorldBattleBuffManager", Singleton)
local ResourceManager = CS.GameEntry.Resource
local WorldBattleBuff = require("Scene.WorldBattleBuff.WorldBattleBuff")

local function __init(self)
  self.allTips = {}
  self.OnCreateTips = {}
  self.buffList = {}
  self:AddListener()
end

local function __delete(self)
  self.buffList = nil
  self:RemoveListener()
  if self.allTips ~= nil then
    for k, v in pairs(self.allTips) do
      local request = v.request
      v:OnDestroy()
      request:Destroy()
    end
    self.allTips = nil
  end
  if self.OnCreateTips ~= nil then
    for k, v in pairs(self.OnCreateTips) do
      v:Destroy()
    end
    self.OnCreateTips = nil
  end
end

local function AddListener(self)
  EventManager:GetInstance():AddListener(EventId.PveLevelEnter, self.RemoveAllTips)
  EventManager:GetInstance():AddListener(EventId.ShowBattleBuff, self.ShowBattleBuffSignal)
  EventManager:GetInstance():AddListener(EventId.HideBattleBuff, self.HideBattleBuffSignal)
  EventManager:GetInstance():AddListener(EventId.ChangeCameraLod, self.ChangeCameraLodSignal)
end

local function RemoveListener(self)
  EventManager:GetInstance():RemoveListener(EventId.PveLevelEnter, self.RemoveAllTips)
  EventManager:GetInstance():RemoveListener(EventId.ShowBattleBuff, self.ShowBattleBuffSignal)
  EventManager:GetInstance():RemoveListener(EventId.HideBattleBuff, self.HideBattleBuffSignal)
  EventManager:GetInstance():RemoveListener(EventId.ChangeCameraLod, self.ChangeCameraLodSignal)
end

local function ChangeCameraLodSignal(lod)
  WorldBattleBuffManager:GetInstance():UpdateLod(lod)
end

local function UpdateLod(self, lod)
  if self.lodCache ~= lod then
    self.lodCache = lod
    if self.lodCache > 3 then
      self:RemoveAllBuff()
    end
  end
end

local function RemoveAllTips(data)
  WorldBattleBuffManager:GetInstance():RemoveAllBuff()
end

local function RemoveAllBuff(self)
  self.buffList = {}
  if self.allTips ~= nil then
    for k, v in pairs(self.allTips) do
      local request = v.request
      v:OnDestroy()
      request:Destroy()
    end
    self.allTips = {}
  end
  if self.OnCreateTips ~= nil then
    for k, v in pairs(self.OnCreateTips) do
      v:Destroy()
    end
    self.OnCreateTips = {}
  end
end

local function ShowBattleBuffSignal(data)
  WorldBattleBuffManager:GetInstance():CheckShowBattleBuff(data)
end

local function HideBattleBuffSignal(data)
  WorldBattleBuffManager:GetInstance():RemoveOneEffect(tonumber(data))
end

local function CheckShowBattleBuff(self, data)
  if self.lodCache > 3 then
    return
  end
  local buffStr = string.split(data, "|")
  if 3 <= #buffStr then
    local uuid = tonumber(buffStr[1])
    local pointId = tonumber(buffStr[2])
    local str = string.split(buffStr[3], ";")
    local pointType = -1
    if 4 <= #buffStr then
      pointType = tonumber(buffStr[4])
    end
    for i = 1, #str do
      local buffId = tonumber(str[i])
      local statItem = LocalController:instance():getLine(TableName.StatusTab, buffId)
      if statItem ~= nil and statItem.buff_is_green ~= "" and statItem.buff_is_add ~= "" and statItem.effect ~= "" then
        local effectStr = string.split(statItem.effect, "|")
        local isGreen = statItem.buff_is_green == "1"
        local isAdd = statItem.buff_is_add == "1"
        if 0 < #effectStr then
          local effectArr = string.split(effectStr[1], ";")
          if 0 < #effectArr then
            for j = 1, #effectArr do
              local effectDes = GetTableData(TableName.EffectNumDesc, tonumber(effectArr[j]), "des")
              if effectDes ~= nil and effectDes ~= "" then
                local oneData = {}
                oneData.uuid = uuid
                oneData.pointId = pointId
                oneData.isGreen = isGreen
                oneData.isAdd = isAdd
                oneData.desc = effectDes
                oneData.pointType = pointType
                if self.buffList[uuid] == nil then
                  self.buffList[uuid] = {}
                end
                table.insert(self.buffList[uuid], oneData)
              end
            end
          end
        end
      end
    end
    local list = self.buffList[uuid]
    if list ~= nil and 0 < #list and #str >= #list then
      self:ShowBattleBuff(uuid)
    end
  end
end

local function CheckRemove(self, uuid)
  if self.buffList ~= nil and self.buffList[uuid] ~= nil then
    local list = self.buffList[uuid]
    if 0 < #list then
      table.remove(list, 1)
      if 0 < #list then
        self:ShowBattleBuff(uuid)
        return
      end
    end
  end
  self:RemoveOneEffect(uuid)
end

local function ShowBattleBuff(self, uuid)
  if self.buffList ~= nil and self.buffList[uuid] ~= nil and #self.buffList[uuid] > 0 then
    local msgData = self.buffList[uuid][1]
    if msgData ~= nil then
      do
        local pointType = msgData.pointType
        local pointId = msgData.pointId
        if 0 <= pointType then
          if pointType == WorldPointType.WorldResource then
            local pointInfo = CS.SceneManager.World:GetPointInfo(pointId)
            if pointInfo == nil then
              self.buffList[uuid] = nil
              return
            end
          else
            local pointInfo = CS.SceneManager.World:GetPointInfoByUuid(uuid)
            if pointInfo == nil then
              self.buffList[uuid] = nil
              return
            end
          end
        else
          local troop = CS.SceneManager.World:GetTroop(uuid)
          if troop == nil then
            self.buffList[uuid] = nil
            return
          end
        end
        if self.allTips[uuid] == nil and self.OnCreateTips[uuid] == nil then
          local request = ResourceManager:InstantiateAsync(UIAssets.BattleBuffTip)
          self.OnCreateTips[uuid] = request
          request:completed("+", function()
            self.OnCreateTips[uuid] = nil
            if request.isError then
              return
            end
            request.gameObject:SetActive(true)
            request.gameObject.transform:SetParent(CS.SceneManager.World.DynamicObjNode)
            request.gameObject.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
            local buffTip = WorldBattleBuff.New()
            buffTip:OnCreate(request)
            buffTip:ReInit(msgData)
            self.allTips[uuid] = buffTip
          end)
        elseif self.allTips[uuid] ~= nil then
          self.allTips[uuid]:ReInit(msgData)
        end
      end
    end
  end
end

local function RemoveOneEffect(self, uuid)
  if self.buffList ~= nil and self.buffList[uuid] ~= nil then
    self.buffList[uuid] = nil
  end
  local temp = self.allTips[uuid]
  if temp ~= nil then
    local request = temp.request
    temp:OnDestroy()
    request:Destroy()
    self.allTips[uuid] = nil
  end
  temp = self.OnCreateTips[uuid]
  if temp ~= nil then
    temp:Destroy()
    self.OnCreateTips[uuid] = nil
  end
end

WorldBattleBuffManager.__init = __init
WorldBattleBuffManager.__delete = __delete
WorldBattleBuffManager.AddListener = AddListener
WorldBattleBuffManager.RemoveListener = RemoveListener
WorldBattleBuffManager.RemoveOneEffect = RemoveOneEffect
WorldBattleBuffManager.ShowBattleBuff = ShowBattleBuff
WorldBattleBuffManager.CheckRemove = CheckRemove
WorldBattleBuffManager.CheckShowBattleBuff = CheckShowBattleBuff
WorldBattleBuffManager.HideBattleBuffSignal = HideBattleBuffSignal
WorldBattleBuffManager.ShowBattleBuffSignal = ShowBattleBuffSignal
WorldBattleBuffManager.UpdateLod = UpdateLod
WorldBattleBuffManager.RemoveAllBuff = RemoveAllBuff
WorldBattleBuffManager.ChangeCameraLodSignal = ChangeCameraLodSignal
WorldBattleBuffManager.RemoveAllTips = RemoveAllTips
return WorldBattleBuffManager
