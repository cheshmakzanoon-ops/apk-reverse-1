local UIJoinAllianceCtrl = BaseClass("UIJoinAllianceCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIJoinAlliance)
end

local function Close(self)
  UIManager:GetInstance():DestroyWindowByLayer(UILayer.Normal)
end

local function InitData(self)
  self.currentAllianceId = ""
  self:SendSearchMessageToServer(1, 1, "", 0, true)
end

local function CheckIfHasAlliance()
  local hasAlliance = LuaEntry.Player:IsInAlliance()
  return hasAlliance
end

local function GetAllianceIdList(self)
  local list = DataCenter.AllianceTempListManager:GetSearchAllianceIdList()
  local isFirst = true
  table.walk(list, function(k, v)
    if isFirst then
      self:SelectOneAllianceItem(v)
    end
    isFirst = false
  end)
  return list
end

local function SendSearchMessageToServer(self, type, page, key, language, isRecommend)
  SFSNetwork.SendMessage(MsgDefines.AlSearch, type, page, key, language, isRecommend)
end

local function GetCurrentAlliance(self)
  return self:GetOneAllianceByUid(self.currentAllianceId)
end

local function GetOneAllianceByUid(self, uid)
  return DataCenter.AllianceTempListManager:GetSearchAllianceDataByUid(uid)
end

local function SelectOneAllianceItem(self, uid)
  if self.currentAllianceId ~= uid then
    local oldSelectId = self.currentAllianceId
    self.currentAllianceId = uid
    if oldSelectId ~= nil and oldSelectId ~= "" then
      EventManager:GetInstance():Broadcast(EventId.CLICK_ALLIANCE_ITEM, oldSelectId)
    end
  end
end

local function SendApplyMessageToServer(self, allianceId, applyType, language)
  SFSNetwork.SendMessage(MsgDefines.AlApply, allianceId, applyType, language)
end

local function SendCancelApplyMessageToServer(self, allianceId)
  SFSNetwork.SendMessage(MsgDefines.AlCancelApply, allianceId)
end

local function OnChatClick(self)
  local alliance = self:GetCurrentAlliance()
  if alliance ~= nil and alliance.leaderUid ~= nil and not alliance:CheckIfIsVirtualLeader() then
    local userId = alliance.leaderUid
    local roomId = ChatManager2:GetInstance().Room:GetPrivateRoomByUserId(userId)
    local param = {}
    param.roomId = roomId
    param.userId = userId
    param.username = alliance.leaderName
    GoToUtil.OpenChatView(true, {
      anim = false,
      hideTop = true,
      UIMainAnim = UIMainAnimType.AllHide
    }, param)
  end
end

local function OnInfoClick(self)
  local alliance = self:GetCurrentAlliance()
  if alliance ~= nil and alliance.uid ~= nil then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIAllianceDetail, {anim = true, hideTop = true}, alliance.allianceName, alliance.uid)
  end
end

local function OnClickCreate(self)
  UIManager:GetInstance():OpenWindow(UIWindowNames.UICreateAlliance, {anim = true, hideTop = true})
end

local function OnLeaderMailClick(self, leaderUid, leaderName)
  if not leaderUid or leaderUid == "" then
    UIUtil.ShowTipsId(390870)
    return
  end
  local userId = leaderUid
  local roomId = ChatManager2:GetInstance().Room:GetPrivateRoomByUserId(userId)
  local param = {}
  param.roomId = roomId
  param.userId = userId
  param.username = leaderName
  GoToUtil.OpenChatView(true, {
    anim = false,
    hideTop = true,
    UIMainAnim = UIMainAnimType.AllHide
  }, param)
end

UIJoinAllianceCtrl.CloseSelf = CloseSelf
UIJoinAllianceCtrl.Close = Close
UIJoinAllianceCtrl.GetAllianceIdList = GetAllianceIdList
UIJoinAllianceCtrl.InitData = InitData
UIJoinAllianceCtrl.SendSearchMessageToServer = SendSearchMessageToServer
UIJoinAllianceCtrl.GetCurrentAlliance = GetCurrentAlliance
UIJoinAllianceCtrl.GetOneAllianceByUid = GetOneAllianceByUid
UIJoinAllianceCtrl.SelectOneAllianceItem = SelectOneAllianceItem
UIJoinAllianceCtrl.SendApplyMessageToServer = SendApplyMessageToServer
UIJoinAllianceCtrl.SendCancelApplyMessageToServer = SendCancelApplyMessageToServer
UIJoinAllianceCtrl.OnChatClick = OnChatClick
UIJoinAllianceCtrl.OnInfoClick = OnInfoClick
UIJoinAllianceCtrl.OnClickCreate = OnClickCreate
UIJoinAllianceCtrl.OnLeaderMailClick = OnLeaderMailClick
UIJoinAllianceCtrl.CheckIfHasAlliance = CheckIfHasAlliance
return UIJoinAllianceCtrl
