local FSMachine = require("Common.FSMachine")
local Resource = CS.GameEntry.Resource
local GameObject = CS.UnityEngine.GameObject
local base = require("DataCenter/LWBattle/Logic/TorchRelayBattle/Cheer/TorchRelayBattleCheerBase")
local TorchConstant = require("DataCenter/LWBattle/Logic/TorchRelayBattle/TorchRelayBattleConstant")
local TorchRelayBattleCheerNormal = BaseClass("TorchRelayBattleCheerNormal", base)

function TorchRelayBattleCheerNormal:__init(cheerTemplate, sceneIndex, logic, cheerData)
  self.logic = logic
  self.cheerTemplate = cheerTemplate
  self.cheerData = cheerData
  self.worldPos = nil
  self.scene = nil
  self.sceneIndex = sceneIndex
  self.obj = nil
  self.trans = nil
  self.req = nil
  self.itemIdList = nil
  self.props = {}
  self.animData = nil
  self.isTriggered = false
  if self.logic and self.logic.activityId and self.logic.data then
    local actData = DataCenter.ActivityTorchRelayManager:GetActivityData(self.logic.activityId)
    if actData then
      local growUpSpeedLevel = actData:GetGrowUpLevelByType(DataCenter.ActivityTorchRelayManager.GrowUpType.Speed)
      local growUpSpeedTemplate = actData:GetGrowUpConfig(DataCenter.ActivityTorchRelayManager.GrowUpType.Speed, growUpSpeedLevel)
      if growUpSpeedTemplate then
        self.animData = growUpSpeedTemplate:GetNormalCheerShowData()
        if self.animData then
          self.logic:PrintEditorLog(string.format("\230\153\174\233\128\154\229\138\169\229\168\129\232\167\166\229\143\145\232\183\157\231\166\187\239\188\154%s, \233\151\180\233\154\148\230\151\182\233\151\180\239\188\154%s", tostring(self.animData.triggerDistance), tostring(self.animData.triggerGapTime)))
        end
      end
    end
  end
  if self.animData == nil and self.logic then
    self.logic:PrintRealErrorLog("normal cheer init failed, null anim data")
  end
  math.randomseed(SafeLocalOsTime())
  self.randomAnimListLeft = {}
  local totalAnimCount = #TorchConstant.CHEER_NORMAL_ANIMS
  for i, v in pairs(TorchConstant.CHEER_NORMAL_POSITIONS_LEFT) do
    self.randomAnimListLeft[i] = TorchConstant.CHEER_NORMAL_ANIMS[math.random(1, totalAnimCount)]
  end
  self.randomAnimListRight = {}
  for i, v in pairs(TorchConstant.CHEER_NORMAL_POSITIONS_RIGHT) do
    self.randomAnimListRight[i] = TorchConstant.CHEER_NORMAL_ANIMS[math.random(1, totalAnimCount)]
  end
end

function TorchRelayBattleCheerNormal:__delete()
  self.logic = nil
  self.cheerTemplate = nil
  self.localPos = nil
  self.worldPos = nil
  self.scene = nil
  self.sceneIndex = nil
  self.obj = nil
  self.trans = nil
end

function TorchRelayBattleCheerNormal:AddListener()
  if self.onSceneLoadedFunc == nil then
    function self.onSceneLoadedFunc(evtData)
      self:OnSceneAssetLoaded(evtData)
    end
    
    EventManager:GetInstance():AddListener(EventId.ActivityTorchRelayBattleSceneAssetLoaded, self.onSceneLoadedFunc)
  end
  if self.onSceneChangedFunc == nil then
    function self.onSceneChangedFunc(evtData)
      self:OnSceneChanged(evtData)
    end
    
    EventManager:GetInstance():AddListener(EventId.ActivityTorchRelayBattleCurSceneChange, self.onSceneChangedFunc)
  end
end

function TorchRelayBattleCheerNormal:RemoveListener()
  if self.onSceneLoadedFunc ~= nil then
    EventManager:GetInstance():RemoveListener(EventId.ActivityTorchRelayBattleSceneAssetLoaded, self.onSceneLoadedFunc)
    self.onSceneLoadedFunc = nil
  end
  if self.onSceneChangedFunc ~= nil then
    EventManager:GetInstance():RemoveListener(EventId.ActivityTorchRelayBattleCurSceneChange, self.onSceneChangedFunc)
    self.onSceneChangedFunc = nil
  end
end

function TorchRelayBattleCheerNormal:OnSceneAssetLoaded(evtData)
  if evtData == nil or evtData.scene == nil or self.sceneIndex == nil then
    return
  end
  local scene = evtData.scene
  if scene.sceneData ~= nil and scene.sceneData.index == self.sceneIndex then
    self:LoadCheer(scene)
  end
end

function TorchRelayBattleCheerNormal:ClearReqs()
  if self.reqs then
    for i, v in pairs(self.reqs) do
      v:Destroy()
    end
  end
  self.reqs = nil
end

function TorchRelayBattleCheerNormal:LoadCheer(scene)
  if not (scene ~= nil and scene.assetReq ~= nil and scene.assetReq.isDone) or IsNull(scene.assetReq.gameObject) then
    return
  end
  self.scene = scene
  self:ClearReqs()
  self.reqs = {}
  for i, pos in pairs(TorchConstant.CHEER_NORMAL_POSITIONS_LEFT) do
    local req = Resource:InstantiateAsync(TorchConstant.CHEER_NORMAL_ASSET_PATH)
    req:completed("+", function()
      if req.isError then
        req:Destroy()
        return
      end
      local realPos = Vector3.New(pos.x, pos.y, pos.z)
      realPos.z = realPos.z + scene.sceneData.startZ
      req.gameObject.transform:Set_position(realPos:Split())
      req.gameObject.transform:Set_localScale(1.5, 1.5, 1.5)
      req.gameObject.transform.rotation = Quaternion.Euler(0, TorchConstant.CHEER_NORMAL_ROTATION_Y_LEFT, 0)
      local anim = req.gameObject.transform:GetComponentInChildren(typeof(CS.SimpleAnimation), true)
      if not IsNull(anim) and self.randomAnimListLeft and self.randomAnimListLeft[i] then
        anim:Play(self.randomAnimListLeft[i])
      end
      local collider = req.gameObject:GetComponent(typeof(CS.UnityEngine.Collider))
      if not IsNull(collider) then
        collider.enabled = false
      end
    end)
    table.insert(self.reqs, req)
  end
  for i, pos in pairs(TorchConstant.CHEER_NORMAL_POSITIONS_RIGHT) do
    local req = Resource:InstantiateAsync(TorchConstant.CHEER_NORMAL_ASSET_PATH)
    req:completed("+", function()
      if req.isError then
        req:Destroy()
        return
      end
      local realPos = Vector3.New(pos.x, pos.y, pos.z)
      realPos.z = realPos.z + scene.sceneData.startZ
      req.gameObject.transform:Set_position(realPos:Split())
      req.gameObject.transform:Set_localScale(1.5, 1.5, 1.5)
      req.gameObject.transform.rotation = Quaternion.Euler(0, TorchConstant.CHEER_NORMAL_ROTATION_Y_RIGHT, 0)
      local anim = req.gameObject.transform:GetComponentInChildren(typeof(CS.SimpleAnimation), true)
      if not IsNull(anim) and self.randomAnimListRight and self.randomAnimListRight[i] then
        anim:Play(self.randomAnimListRight[i])
      end
      local collider = req.gameObject:GetComponent(typeof(CS.UnityEngine.Collider))
      if not IsNull(collider) then
        collider.enabled = false
      end
    end)
    table.insert(self.reqs, req)
  end
  local req = Resource:InstantiateAsync(TorchConstant.CHEER_NORMAL_PROP_PERSON_ASSET_PATH)
  req:completed("+", function()
    if req.isError then
      req:Destroy()
      return
    end
    self.worldPos = DeepCopy(TorchConstant.CHEER_NORMAL_PROP_PERSON_POSITION)
    self.worldPos.z = self.worldPos.z + scene.sceneData.startZ
    req.gameObject.transform:Set_position(self.worldPos:Split())
    req.gameObject.transform:Set_localScale(TorchConstant.CHEER_NORMAL_PROP_PERSON_SCALE:Split())
    req.gameObject.transform.rotation = Quaternion.Euler(0, TorchConstant.CHEER_NORMAL_PROP_PERSON_ROTATION_Y, 0)
    local anim = req.gameObject.transform:GetComponentInChildren(typeof(CS.SimpleAnimation), true)
    if not IsNull(anim) then
      anim:Play("Happy03")
    end
    self.obj = req.gameObject
    self.trans = req.gameObject.transform
    local collider = req.gameObject:GetComponent(typeof(CS.UnityEngine.Collider))
    if not IsNull(collider) then
      collider.enabled = false
    end
  end)
  table.insert(self.reqs, req)
end

function TorchRelayBattleCheerNormal:OnSceneChanged(evtData)
  if evtData ~= nil and evtData.curSceneData ~= nil and self.sceneIndex ~= nil then
    local sceneData = evtData.curSceneData
    if sceneData.index == self.sceneIndex then
      local itemIdList = self.cheerTemplate:GetRandomIdList()
      for i, v in pairs(itemIdList) do
      end
    elseif sceneData.index > self.sceneIndex then
      self:RecycleProps()
    end
  end
end

function TorchRelayBattleCheerNormal:CreateItem(itemId)
  if self.logic then
    self.logic:PrintEditorLog("\230\153\174\233\128\154\229\138\169\229\168\129", "\232\167\166\229\143\145\228\186\134\231\148\159\230\136\144\228\186\134\228\184\128\228\184\170\233\129\147\229\133\183")
  end
  local config = DataCenter.TorchRelayTemplateManager:GetStageItemTemplate(itemId)
  if config then
    local newBornData = {}
    newBornData.props = {config = config, id = itemId}
    newBornData.configId = itemId
    newBornData.mainType = TorchRelayScenePropsMainType.Buff
    newBornData.propsType = config.buff_type
    newBornData.line = config:GetRandomLine()
    local pos = self.scene.sceneRoot:InverseTransformPoint(self.trans.position)
    newBornData.x = pos.x
    newBornData.y = 0
    newBornData.z = pos.z
    local param = {}
    param.propsType = config.buff_type
    param.bornData = newBornData
    param.sceneRoot = self.scene.sceneRoot
    param.logic = self.logic
    if self.props then
      local item = self.logic.scenePropsPool:Get(param, function(item)
        self:OnPropsItemLoadCallback(item)
      end)
      if item then
        table.insert(self.props, item)
      end
    end
  end
end

function TorchRelayBattleCheerNormal:Destroy()
  self:ClearReqs()
  self:RecycleProps()
end

function TorchRelayBattleCheerNormal:OnPropsItemLoadCallback(item)
  if item and item.isLoaded and item.SetIsCheerItem then
    item:SetIsCheerItem(true)
  end
end

function TorchRelayBattleCheerNormal:OnUpdate(dt)
  self:TryTrigger()
  if self.props then
    for i, v in pairs(self.props) do
      v:OnUpdate(dt)
    end
  end
end

function TorchRelayBattleCheerNormal:RecycleProps()
  if self.logic and self.logic.scenePropsPool and self.props then
    for i, v in pairs(self.props) do
      if v then
        self.logic.scenePropsPool:Recycle(v)
      end
    end
    self.props = nil
  end
end

function TorchRelayBattleCheerNormal:TryTrigger()
  if not self.isTriggered and self.cheerTemplate and self.logic and self.logic.player then
    local playerPos = self.logic.player:GetPosition()
    if self.worldPos and self.animData and playerPos.z >= self.worldPos.z - self.animData.triggerDistance then
      self.isTriggered = true
      self.itemIdList = self.cheerTemplate:GetRandomIdList()
      
      function self.timerAction()
        self:CreateNextItem()
      end
      
      self.timer = TimerManager:GetInstance():GetTimer(self.animData.triggerGapTime, self.timerAction, self, false, false, false)
      self.timer:Start()
      self:TriggerMainUI()
    end
  end
end

function TorchRelayBattleCheerNormal:StopTimer()
  if self.timer then
    self.timer:Stop()
    self.timer = nil
  end
end

function TorchRelayBattleCheerNormal:CreateNextItem()
  if table.IsNullOrEmpty(self.itemIdList) then
    self:StopTimer()
    return
  end
  for i, v in pairs(self.itemIdList) do
    self:CreateItem(v)
    table.remove(self.itemIdList, i)
    return
  end
end

function TorchRelayBattleCheerNormal:GetSceneIndex()
  return self.sceneIndex
end

function TorchRelayBattleCheerNormal:GetRare()
  if self.cheerTemplate ~= nil then
    return self.cheerTemplate.cheer_rare
  end
  return -1
end

function TorchRelayBattleCheerNormal:GetTemplate()
  return self.cheerTemplate
end

return TorchRelayBattleCheerNormal
