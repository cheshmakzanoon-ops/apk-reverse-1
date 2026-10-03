local UIAllianceAlertDetailCtrl = BaseClass("UIAllianceAlertDetailCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIAllianceAlertDetail)
end

local function Close(self)
  UIManager:GetInstance():DestroyWindowByLayer(UILayer.Normal)
end

local function OnClickPosBtn(self, pos)
  if pos ~= 0 then
    self:Close()
    local worldPos = SceneUtils.TileIndexToWorld(pos)
    worldPos.x = worldPos.x
    worldPos.z = worldPos.z
    pos = SceneUtils.WorldToTileIndex(worldPos)
    EventManager:GetInstance():Broadcast(EventId.UIMAIN_VISIBLE, true)
    GoToUtil.GotoPos(SceneUtils.TileIndexToWorld(pos), CS.SceneManager.World.InitZoom)
  end
end

local function OnCloseClick(self)
  self:CloseSelf()
end

local function CloseMainTable(self)
  self:CloseSelf()
  DataCenter.AllianceWarDataManager:CloseALWarMain()
end

UIAllianceAlertDetailCtrl.CloseSelf = CloseSelf
UIAllianceAlertDetailCtrl.Close = Close
UIAllianceAlertDetailCtrl.OnClickPosBtn = OnClickPosBtn
UIAllianceAlertDetailCtrl.OnCloseClick = OnCloseClick
UIAllianceAlertDetailCtrl.CloseMainTable = CloseMainTable
return UIAllianceAlertDetailCtrl
