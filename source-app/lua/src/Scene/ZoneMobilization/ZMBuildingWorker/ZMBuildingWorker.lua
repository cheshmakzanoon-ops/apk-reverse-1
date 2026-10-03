local ZMBuildingWorker = BaseClass("ZMBuildingWorker")
local UILWZMBuildHeadBubble = require("Scene.ZoneMobilization.ZMBuildingWorker.UILWZMBuildHeadBubble")
local prefabPath = "Assets/Main/Prefabs/March/WorldTroopJianZaoBen.prefab"
local Resource = CS.GameEntry.Resource
local HEIGHT = 3.5

local function __init(self)
  self.headBubbleHandle = nil
  self.headBubble = nil
end

local function __delete(self)
  self:Destroy()
end

local function Destroy(self)
  if self.headBubble then
    self.headBubble:Delete()
    self.headBubble = nil
  end
  if self.headBubbleHandle then
    self.headBubbleHandle:Destroy()
    self.headBubbleHandle = nil
  end
  if not IsNull(self.req) then
    self.req:Destroy()
  end
  self.req = nil
end

local function Init(self, pos, targetPos)
  if self.req then
    return
  end
  self.req = Resource:InstantiateAsync(prefabPath)
  self.req:completed("+", function(handle)
    self.gameObject = self.req.gameObject
    self.transform = self.gameObject.transform
    self.transform.position = pos + targetPos
    self.transform:LookAt(targetPos)
    local simpleAnimation = self.gameObject:GetComponentInChildren(typeof(CS.SimpleAnimation))
    if simpleAnimation then
      simpleAnimation:Play("building")
    end
    if self.mark and self.playerInfo then
      self.mark = nil
      self:PlayHeadBubble(self.playerInfo)
    end
  end)
end

local function Refresh(self, message)
  if message == nil then
    return
  end
  if self.req and self.gameObject then
    self:PlayHeadBubble(message.playerInfo)
  else
    self.mark = true
    self.playerInfo = message.playerInfo
  end
end

local function PlayHeadBubble(self, param)
  if param == nil then
    return
  end
  if self.headBubble then
    self.headBubble:Refresh(param)
    if self.headBubbleHandle then
      local trans = self.headBubbleHandle.gameObject.transform
      local pos = self.transform.position
      trans.position = Vector3.New(pos.x, pos.y + HEIGHT, pos.z)
    end
    return
  end
  if self.headBubbleHandle then
    return
  end
  local headBubbleHandle = CS.GameEntry.Resource:InstantiateAsync("Assets/Main/Prefabs/UI/LWUIZoneMobilization/Component/UILWZMBuildHeadBubble.prefab")
  headBubbleHandle:completed("+", function(handle)
    local bubble
    local ok, msg = xpcall(function()
      local trans = handle.gameObject.transform
      bubble = UILWZMBuildHeadBubble.New(param, trans)
      trans:SetParent(UIManager:GetInstance():GetLayer(UILayer.World.Name).transform)
      local pos = self.transform.position
      trans.position = Vector3.New(pos.x, pos.y + HEIGHT, pos.z)
    end, debug.traceback)
    if ok and bubble ~= nil then
      self.headBubble = bubble
    else
      Logger.LogError(msg)
      ok, msg = xpcall(function()
        if bubble ~= nil then
          bubble:Dispose()
        end
      end, debug.traceback)
      if not ok and handle and not IsNull(handle.gameObject) then
        handle.gameObject:SetActive(false)
      end
    end
  end)
  self.headBubbleHandle = headBubbleHandle
end

ZMBuildingWorker.__init = __init
ZMBuildingWorker.__delete = __delete
ZMBuildingWorker.Init = Init
ZMBuildingWorker.Destroy = Destroy
ZMBuildingWorker.Refresh = Refresh
ZMBuildingWorker.PlayHeadBubble = PlayHeadBubble
return ZMBuildingWorker
