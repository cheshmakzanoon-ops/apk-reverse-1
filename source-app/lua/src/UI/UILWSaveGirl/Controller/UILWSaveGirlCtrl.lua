local UILWSaveGirlCtrl = BaseClass("UILWSaveGirl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UILWSaveGirl, {anim = false})
  DataCenter.LWSaveGirlManager:PlayReward()
  self:TryOpenWarning()
end

function UILWSaveGirlCtrl:OnCustomKeyCodeEscape()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UILWSaveGirl, {anim = true})
end

function UILWSaveGirlCtrl:OnUseBtnClick(costItemId)
  local itemCount = DataCenter.ItemData:GetItemCount(costItemId)
  if 0 < itemCount then
    SFSNetwork.SendMessage(MsgDefines.LWSaveGirl)
  else
    local buildList = DataCenter.BuildManager:GetAllBuildingByItemIdWithoutPickUp(BuildingTypes.LW_BUILD_RADAR)
    if buildList == nil or table.count(buildList) == 0 or buildList[1] == nil then
      UIManager:GetInstance():DestroyWindow(UIWindowNames.UILWSaveGirl, {anim = false})
      GoToUtil.CloseAllWindows()
      self:TryOpenWarning(true)
      return
    end
    local data = DataCenter.MonopolyManager:GetCurData()
    if data ~= nil then
      GoToUtil.GotoCityPos(data:GetCenterWorldPos(), CS.SceneManager.World.InitZoom, 0.5, nil)
    end
    self:CloseSelf()
  end
end

function UILWSaveGirlCtrl:TryOverlookFlow()
  local hasBuilding = DataCenter.BuildManager:GetBuildingDatasByBuildingId(BuildingTypes.FUN_BUILD_RADAR_CENTER)[1] ~= nil
  if hasBuilding then
    return false
  end
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UILWSaveGirl)
  GoToUtil.GotoCityByBuildId(BuildingTypes.FUN_BUILD_RADAR_CENTER)
  return true
end

function UILWSaveGirlCtrl:TryOpenWarning(guide)
  if not self.first then
    if guide then
      GoToUtil.GotoBuildListByBuildId(BuildingTypes.LW_BUILD_RADAR)
    end
    return
  end
  if DataCenter.LWBeginnerDirectorManager:GetCurCityEventID() ~= -1 then
    return
  end
  EventManager:GetInstance():Broadcast(EventId.MainUIBottomHide)
  if LuaEntry.Player.JPUser and DataCenter.LWSaveGirlManager:IsJPGirlOpen() then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UILWSaveGirlWarningJp, {anim = false}, {guide = guide})
  else
    UIManager:GetInstance():OpenWindow(UIWindowNames.UILWSaveGirlWarning, {anim = false}, {guide = guide})
  end
end

function UILWSaveGirlCtrl:Reset()
  self.first = false
end

function UILWSaveGirlCtrl:SetFirst()
  self.first = true
end

UILWSaveGirlCtrl.CloseSelf = CloseSelf
return UILWSaveGirlCtrl
