local UIMainMiniMapCtrl = BaseClass("UIMainMiniMapCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIMainMiniMap, {
    anim = true,
    UIMainAnim = UIMainAnimType.AllShow
  })
end

local function GetCityPointDataFast(allMembers, oneData, length)
  ProfilerUtil.BeginSample("UIMainMiniMapView:ShowCityPoint.GetAllMainBaseList")
  local list = CS.SceneManager.World:GetAllMainBaseListByType(CS.PlayerType.PlayerAlliance, CS.PlayerType.PlayerAllianceLeader)
  ProfilerUtil.EndSample()
  if list ~= nil then
    ProfilerUtil.BeginSample("UIMainMiniMapView:ShowCityPoint UpdateList")
    local playerUid = LuaEntry.Player.uid
    for k, v in pairs(list) do
      local ownerUid = v.ownerUid
      local data = allMembers[ownerUid]
      if ownerUid ~= playerUid and (data == nil or v.mainIndex ~= data.pointId) then
        if data ~= nil then
          data.pointId = v.mainIndex
        end
        if v:GetPlayerType() == CS.PlayerType.PlayerAllianceLeader then
          oneData.myLeader = {
            uid = ownerUid,
            serverId = v.serverId,
            pos = v.mainIndex
          }
        else
          oneData.members[ownerUid] = {
            serverId = v.serverId,
            pos = v.mainIndex
          }
        end
        oneData.isNew = true
      end
    end
    ProfilerUtil.EndSample()
  end
end

local function GetCityPointData(self, dataCityPoint)
  local oneData = {}
  local playerUid = LuaEntry.Player.uid
  local mainIndex = LuaEntry.Player:GetMainWorldPos()
  local selfAllianceId = LuaEntry.Player.allianceId
  local selfData = {
    serverId = LuaEntry.Player.serverId,
    pos = mainIndex
  }
  oneData.members = {}
  oneData.isNew = dataCityPoint == nil or dataCityPoint.myPos == nil or dataCityPoint.myPos.pos ~= mainIndex
  oneData.myPos = selfData
  if selfAllianceId == nil or selfAllianceId == "" then
    return oneData
  end
  local allMembers = DataCenter.AllianceMemberDataManager:GetAllMember()
  if allMembers ~= nil then
    for _, v in pairs(allMembers) do
      if v.uid == playerUid then
      elseif v.pointId > 0 then
        if v.rank == 5 then
          oneData.myLeader = {
            uid = v.uid,
            serverId = v.curServerId or v.serverId,
            pos = v.pointId
          }
          if not oneData.isNew and (dataCityPoint.myLeader == nil or dataCityPoint.myLeader.uid ~= v.uid or dataCityPoint.myLeader.pos ~= v.pointId) then
            oneData.isNew = true
          end
        else
          oneData.members[v.uid] = {
            serverId = v.curServerId or v.serverId,
            pos = v.pointId
          }
        end
      end
    end
  end
  GetCityPointDataFast(allMembers, oneData)
  return oneData
end

function UIMainMiniMapCtrl:OnCustomKeyCodeEscape()
end

UIMainMiniMapCtrl.CloseSelf = CloseSelf
UIMainMiniMapCtrl.GetCityPointData = GetCityPointData
return UIMainMiniMapCtrl
