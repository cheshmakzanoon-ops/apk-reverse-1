local UIMainWolfShadowObj = BaseClass("UIMainWolfShadowObj", UIAsyncContainer)
local base = UIAsyncContainer

function UIMainWolfShadowObj:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
end

function UIMainWolfShadowObj:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIMainWolfShadowObj:ComponentDefine()
  self.btn = self:AddComponent(UIButton, "")
  self.btn:SetSafeClickMode(true)
  self.btn:SetOnClick(function()
    self:OnClickBtn()
  end)
end

function UIMainWolfShadowObj:ComponentDestroy()
  self.btn = nil
end

function UIMainWolfShadowObj:OnClickBtn()
  local serverId, pointId = DataCenter.SeasonHunterManager:GetShadow()
  if serverId == nil then
    EventManager:GetInstance():Broadcast(EventId.WolfShadowRefresh)
    return
  end
  local worldPos = SceneUtils.TileIndexToWorld(pointId, ForceChangeScene.World, serverId)
  GoToUtil.GotoWorldPos(worldPos, nil, 0, function()
  end, serverId)
end

return UIMainWolfShadowObj
