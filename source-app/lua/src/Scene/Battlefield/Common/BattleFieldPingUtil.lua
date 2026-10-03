local BattleFieldPingUtil = {}
local BFPingData = require("Scene.Battlefield.Common.BFPingData")
local BFPingMark = require("Scene.Battlefield.Common.BFPingMark")
local ResourceManager = CS.GameEntry.Resource
local BASE_PING_MARK_PATH = "Assets/Main/Prefabs/Effect/BattleField/%s.prefab"

function BattleFieldPingUtil.HandlePingList(bfType, t)
  BattleFieldPingUtil._pingDic = {}
  local pings = t.orders
  if pings then
    for _, v in ipairs(pings) do
      local data = BFPingData.New()
      data:ParseData(v, bfType)
      BattleFieldPingUtil._pingDic[data.uuid] = data
    end
  end
  BattleFieldPingUtil.RefreshPingMarkShow()
end

function BattleFieldPingUtil.HandlePingOpt(bfType, t, bAdd)
  BattleFieldUtil.SetLastPingSec()
end

function BattleFieldPingUtil.HandlePingOptPush(bfType, t, bAdd)
  local hasChange = false
  if bAdd and t.cfgid then
    local data = BFPingData.New()
    data:ParseData(t, bfType)
    BattleFieldPingUtil._pingDic = BattleFieldPingUtil._pingDic or {}
    BattleFieldPingUtil._pingDic[data.uuid] = data
    local bShow = false
    if bfType == BattleFieldType.WinterStorm then
      bShow = true
    elseif bfType == BattleFieldType.EpidemicZone then
      bShow = DataCenter.ActEpidemicZoneManager:CheckOrderMarkPopCanShow(data.cfg)
    end
    if bShow then
      EventManager:GetInstance():Broadcast(EventId.BattleFieldPingAdd, data)
    end
    hasChange = true
  elseif t.uuids then
    for _, uuid in pairs(t.uuids) do
      BattleFieldPingUtil.RemovePingData(uuid)
    end
    hasChange = true
  end
  if hasChange then
    BattleFieldPingUtil.RefreshPingMarkShow()
  end
end

local function SortPing(a, b)
  return a.cTime > b.cTime
end

function BattleFieldPingUtil.RefreshPingMarkShow()
  if not SceneUtils.GetIsInWorld() then
    return
  end
  local list = {}
  local idx
  for _, v in pairs(BattleFieldPingUtil._pingDic) do
    if not v:CheckEnd() then
      idx = 0
      for i, od in ipairs(list) do
        if v.cfgId == od.cfgId and v.pid == od.pid and v.cTime > od.cTime then
          idx = i
          break
        end
      end
      if idx ~= 0 then
        table.remove(list, idx)
      end
      table.insert(list, v)
    end
  end
  table.sort(list, SortPing)
  local curCnt = 0
  local maxCnt = BattleFieldPingUtil._pingMaxCnt
  if maxCnt == nil then
    maxCnt = LuaEntry.DataConfig:TryGetNum("battlefield_ping", "k2", 8)
    BattleFieldPingUtil._pingMaxCnt = maxCnt
  end
  local showDic = {}
  for _, v in ipairs(list) do
    curCnt = curCnt + 1
    BattleFieldPingUtil.AddPingMark(v.uuid)
    showDic[v.uuid] = true
    if curCnt == maxCnt then
      break
    end
  end
  if BattleFieldPingUtil._pingMarkDic then
    local removeList = {}
    for uuid, v in pairs(BattleFieldPingUtil._pingMarkDic) do
      if v ~= nil and not showDic[uuid] then
        table.insert(removeList, uuid)
      end
    end
    for _, uuid in ipairs(removeList) do
      BattleFieldPingUtil.RemovePingMark(uuid)
    end
  end
end

function BattleFieldPingUtil.RemovePingData(uuid)
  if BattleFieldPingUtil._pingDic then
    BattleFieldPingUtil._pingDic[uuid] = nil
  end
  BattleFieldPingUtil.RemovePingMark(uuid)
end

function BattleFieldPingUtil.RemovePingMark(uuid)
  local mark = BattleFieldPingUtil._pingMarkDic and BattleFieldPingUtil._pingMarkDic[uuid]
  if mark ~= nil then
    mark:Destroy()
    BattleFieldPingUtil._pingMarkDic[uuid] = nil
  end
  local markReq = BattleFieldPingUtil._pingMarkReqDic and BattleFieldPingUtil._pingMarkReqDic[uuid]
  if markReq ~= nil then
    markReq:Destroy()
    BattleFieldPingUtil._pingMarkReqDic[uuid] = nil
  end
end

function BattleFieldPingUtil.CleanPingMark()
  if BattleFieldPingUtil._pingMarkDic then
    for _, v in pairs(BattleFieldPingUtil._pingMarkDic) do
      if v ~= nil then
        v:Destroy()
      end
    end
    BattleFieldPingUtil._pingMarkDic = nil
  end
  if BattleFieldPingUtil._pingMarkReqDic then
    for _, v in pairs(BattleFieldPingUtil._pingMarkReqDic) do
      if v ~= nil then
        v:Destroy()
      end
    end
    BattleFieldPingUtil._pingMarkReqDic = nil
  end
  BattleFieldPingUtil._pingDic = {}
end

function BattleFieldPingUtil.AddPingMark(uuid)
  local pingData = BattleFieldPingUtil._pingDic[uuid]
  if pingData == nil then
    return
  end
  local mark = BattleFieldPingUtil._pingMarkDic ~= nil and BattleFieldPingUtil._pingMarkDic[uuid] or nil
  if mark ~= nil then
    return
  end
  local markReq = BattleFieldPingUtil._pingMarkReqDic ~= nil and BattleFieldPingUtil._pingMarkReqDic[uuid] or nil
  if markReq ~= nil then
    return
  end
  local cfg = pingData.cfg
  if cfg == nil then
    BattleFieldPingUtil.RemovePingData(uuid)
    return
  end
  local req = ResourceManager:InstantiateAsync(string.format(BASE_PING_MARK_PATH, cfg.world_res))
  BattleFieldPingUtil._pingMarkReqDic = BattleFieldPingUtil._pingMarkReqDic or {}
  BattleFieldPingUtil._pingMarkReqDic[uuid] = req
  req:completed("+", function(request)
    pingData = BattleFieldPingUtil._pingDic[uuid]
    if request.isError or pingData == nil or not SceneUtils.GetIsInWorld() then
      BattleFieldPingUtil.RemovePingData(uuid)
      return
    end
    local go = request.gameObject
    go.name = "BF_PingMark_" .. uuid
    go:SetActive(true)
    local tf = go.transform
    tf:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
    local worldPoint = BuildingUtils.GetBuildModelCenterVec(pingData.pid, 1, 1, ForceChangeScene.World)
    tf.position = worldPoint
    tf:SetParent(CS.SceneManager.World.DynamicObjNode)
    mark = BFPingMark.New()
    BattleFieldPingUtil._pingMarkDic = BattleFieldPingUtil._pingMarkDic or {}
    BattleFieldPingUtil._pingMarkDic[uuid] = mark
    mark:OnCreate(go, pingData)
  end)
end

return BattleFieldPingUtil
