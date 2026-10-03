local BuildRoadCreateNewMessage = BaseClass("BuildRoadCreateNewMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, param)
  base.OnCreate(self)
  if param ~= nil then
    self.sfsObj:PutInt("pathTime", param.pathTime)
    if param.arr ~= nil then
      local oneArr = SFSArray.New()
      for k, v in ipairs(param.arr) do
        oneArr:AddInt(v)
      end
      self.sfsObj:PutSFSArray("pointArray", oneArr)
    end
  end
end

local function HandleMessage(self, message)
  base.HandleMessage(self, message)
  DataCenter.BoardManager:BuildRoadCreateNewHandle(message)
end

BuildRoadCreateNewMessage.OnCreate = OnCreate
BuildRoadCreateNewMessage.HandleMessage = HandleMessage
return BuildRoadCreateNewMessage
