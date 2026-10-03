local FindResourceMessage = BaseClass("FindResourceMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, resType, level, param)
  base.OnCreate(self)
  self.sfsObj:PutInt("type", resType)
  self.sfsObj:PutInt("level", level)
  if param then
    self.sfsObj:PutUtfString("param", param)
  end
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  if t.errorCode ~= nil then
    UIUtil.ShowTipsId(170475)
  elseif t.pointId and t.pointId ~= 0 then
    local worldPointPos = SceneUtils.TileIndexToWorld(t.pointId, ForceChangeScene.World)
    GoToUtil.GotoWorldPos(worldPointPos, nil, nil, function()
      if DataCenter.GuideManager:InGuide() then
        DataCenter.CollectResourceManager:SetFindResPoint(t.pointId)
        return
      end
      UIManager:GetInstance():DestroyWindow(UIWindowNames.UISearch, {
        anim = true,
        UIMainAnim = UIMainAnimType.AllShow
      })
      GoToUtil.OnClickWorldPoint(t.pointId)
    end)
    return
  end
  UIUtil.ShowTipsId(129108)
end

FindResourceMessage.OnCreate = OnCreate
FindResourceMessage.HandleMessage = HandleMessage
return FindResourceMessage
