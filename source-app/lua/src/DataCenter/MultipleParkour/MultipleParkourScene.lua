local MultipleParkourScene = BaseClass("MultipleParkourScene")
local Resource = CS.GameEntry.Resource
local PVEScenePath = "Assets/Main/Prefabs/PVELevel/%s/scene.prefab"
local PVEDecorationPath = "Assets/Main/Prefabs/PVELevel/%s/decoration.bytes"

function MultipleParkourScene:__init(mgr, index, sceneCfgArr, mgrCallback)
  self.mgr = mgr
  self.index = index
  self.offset = sceneCfgArr.offset
  self.cfgArr = sceneCfgArr.cfgArr
  self.totalSize = sceneCfgArr.totalSize
  self.endPos = self.offset + self.totalSize
  self.mgrCallback = mgrCallback
  self.finishedScene = 0
  self.sceneLoadRequest = {}
  self.loaded = false
  if self.index == 1 then
    self:Load()
  end
end

function MultipleParkourScene:Load()
  if self.loaded then
    return
  end
  self.loaded = true
  for i, sceneCfg in ipairs(self.cfgArr) do
    local req = Resource:InstantiateAsync(string.format(PVEScenePath, sceneCfg.meta.asset))
    req:completed("+", function()
      local sceneRoot = req.gameObject.transform
      sceneRoot:Set_position(0, 0, sceneCfg.offset + self.offset)
      self.finishedScene = self.finishedScene + 1
      if self.finishedScene >= #self.cfgArr and self.mgrCallback then
        pcall(self.mgrCallback)
        self.mgrCallback = nil
      end
    end)
    table.insert(self.sceneLoadRequest, req)
    if self.mgr.staticMgr then
      self.mgr.staticMgr:Append(string.format(PVEDecorationPath, sceneCfg.meta.asset), sceneCfg.offset + self.offset)
    end
  end
end

function MultipleParkourScene:__delete()
  if self.sceneLoadRequest then
    for _, sceneReq in pairs(self.sceneLoadRequest) do
      sceneReq:Destroy()
    end
  end
  self.sceneLoadRequest = nil
end

return MultipleParkourScene
