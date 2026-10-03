local ResourceManager = CS.GameEntry.Resource
local WorldBookMarkItem = BaseClass("WorldBookMarkItem")

function WorldBookMarkItem:__init()
  self.req = nil
  self.bookMark = nil
end

function WorldBookMarkItem:__delete()
end

function WorldBookMarkItem:Load(bookMark)
  if self.bookMark and self.bookMark.type ~= bookMark.type then
    self:Unload()
  end
  self.bookMark = bookMark
  if not self.req then
    local request = ResourceManager:InstantiateAsync((DataCenter.WorldFavoDataManager:GetBookMarkPrefabPath(bookMark.type)))
    request:completed("+", function()
      local go = request.gameObject
      go:SetActive(true)
      go.transform:SetParent(CS.SceneManager.World.DynamicObjNode)
      go.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
      self.trigger = go.transform:Find("Content/Trigger"):GetComponent(typeof(CS.TouchObjectEventTrigger))
      
      function self.trigger.onPointerClick()
        self:OnClickMark()
      end
      
      self:UpdatePosition()
    end)
    self.req = request
  end
  self:UpdatePosition()
end

function WorldBookMarkItem:OnClickMark()
  local share_param = {}
  local pointId = self.bookMark.pos // 10
  share_param.sid = LuaEntry.Player:GetCurServerId()
  share_param.pos = pointId * 10
  local tilePos = SceneUtils.IndexToTilePos(pointId)
  share_param.oname = string.format("#%d X:%d Y:%d", share_param.sid, tilePos.x, tilePos.y)
  share_param.panelType = MarkGroup.Personal
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIPositionAdd, {anim = true}, share_param)
end

function WorldBookMarkItem:UpdatePosition()
  if not self.req or IsNull(self.req.gameObject) then
    return
  end
  local edgeL = self.bookMark.pos % 10
  local tempPoint = (self.bookMark.pos - edgeL) / 10
  local worldPos = BuildingUtils.GetBuildModelCenterVec(tempPoint, 1, 1, ForceChangeScene.World, self.bookMark.server)
  local v3 = Vector3.New(worldPos.x, worldPos.y, worldPos.z)
  self.req.gameObject.transform.position = v3
end

function WorldBookMarkItem:Unload()
  if not IsNull(self.trigger) then
    self.trigger.onPointerClick = nil
  end
  self.trigger = nil
  if self.req then
    self.req:Destroy()
    self.req = nil
  end
  self.bookMark = nil
end

return WorldBookMarkItem
