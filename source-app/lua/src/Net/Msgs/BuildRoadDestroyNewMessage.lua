local BuildRoadDestroyNewMessage = BaseClass("BuildRoadDestroyNewMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, param)
  base.OnCreate(self)
  if param ~= nil and param.arr ~= nil then
    local oneArr = SFSArray.New()
    for k, v in pairs(param.arr) do
      oneArr:AddInt(v)
      CS.SceneManager.World:HideObject(v)
    end
    self.sfsObj:PutSFSArray("pointArray", oneArr)
    DataCenter.BoardManager:AddOneDeleteRoads(param.arr)
  end
end

local function HandleMessage(self, message)
  base.HandleMessage(self, message)
  DataCenter.BoardManager:BuildRoadDestroyNewHandle(message)
end

BuildRoadDestroyNewMessage.OnCreate = OnCreate
BuildRoadDestroyNewMessage.HandleMessage = HandleMessage
return BuildRoadDestroyNewMessage
