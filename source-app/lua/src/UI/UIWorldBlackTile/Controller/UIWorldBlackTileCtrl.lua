local UIWorldBlackTileCtrl = BaseClass("UIWorldBlackTileCtrl", UIBaseCtrl)

function UIWorldBlackTileCtrl:CloseSelf(isNoDoAnim)
  if isNoDoAnim then
    UIManager:GetInstance():DestroyWindow(UIWindowNames.UIWorldBlackTile, {anim = true})
  else
    UIManager:GetInstance():DestroyWindow(UIWindowNames.UIWorldBlackTile)
  end
end

function UIWorldBlackTileCtrl:Close()
  UIManager:GetInstance():DestroyWindowByLayer(UILayer.Normal)
end

function UIWorldBlackTileCtrl:GetBlackData(pointId)
end

function UIWorldBlackTileCtrl:OnAttackClick(point)
  MarchUtil.OnClickStartMarch(MarchTargetType.STATE, point)
  self:CloseSelf(true)
end

function UIWorldBlackTileCtrl:OnMoveCityClick(pointId)
  local selfMarchCount = UIUtil.GetSelfMarchCountExceptGolloes()
  if 0 < selfMarchCount then
    UIUtil.ShowMessage(CS.GameEntry.Localization:GetString(GameDialogDefine.PLEASE_BACK_MARCH), 2, GameDialogDefine.CONFIRM, GameDialogDefine.CANCEL, function()
    end, function()
    end)
    self:CloseSelf(false)
  else
    local serverId = LuaEntry.Player:GetCurServerId()
    MoveCityUtil.TryShowMoveCityModel(PlaceBuildType.MoveCity, serverId, pointId)
    self:CloseSelf(true)
  end
end

function UIWorldBlackTileCtrl:OnPlayerDetailClick(uid)
  UIManager:GetInstance():OpenWindow(UIWindowNames.UILWPlayerDetail, {anim = true, hideTop = true}, uid)
end

function UIWorldBlackTileCtrl:OnShareClick(server, point, oname)
  local share_param = {}
  share_param.sid = server
  share_param.pos = point
  share_param.oname = oname
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIPositionShare, {anim = true}, share_param)
  self:CloseSelf(true)
end

function UIWorldBlackTileCtrl:OnMarkClick(server, point, oname, olv)
  local share_param = {}
  share_param.sid = server
  share_param.pos = point
  share_param.oname = oname
  share_param.olv = olv
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIPositionAdd, {anim = true}, share_param)
  self:CloseSelf(true)
end

return UIWorldBlackTileCtrl
