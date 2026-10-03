local UIWorldActRadarTreasurePointCtrl = BaseClass("UIWorldActRadarTreasurePointCtrl", UIBaseCtrl)
local Localization = CS.GameEntry.Localization

local function CloseSelf(self, hidAnim)
  if hidAnim ~= nil and hidAnim == true then
    UIManager.Instance:DestroyWindow(UIWindowNames.UIWorldActRadarTreasurePoint, {
      anim = true,
      playEffect = false,
      UIMainAnim = UIMainAnimType.ChangeAllShow
    })
  else
    UIManager.Instance:DestroyWindow(UIWindowNames.UIWorldActRadarTreasurePoint)
  end
end

local function InitData(self, uuid, pointId, ownerUid, type, isAlliance, buildId, isArrow, desertId)
  self.uuid = tonumber(uuid) or 0
  self.pointId = tonumber(pointId) or -1
  self.ownerUid = ownerUid
  self.type = tonumber(type)
  self.isAlliance = tonumber(isAlliance) == 1
  self.buildId = tonumber(buildId) or 0
  self.desertId = tonumber(desertId) or 0
  self.isArrow = isArrow
  local info = CS.SceneManager.World:GetPointInfoByUuid(self.uuid)
  if info ~= nil then
    self.serverId = info.serverId
  else
    self.serverId = LuaEntry.Player:GetCurServerId()
  end
end

local function ClearData(self)
end

local function GetIsArrow(self)
  return self.isArrow
end

local function SetIsArrow(self)
  self.isArrow = nil
end

local function GetTreasureData(self)
  local oneData = {}
  oneData.uuid = self.uuid
  local info = CS.SceneManager.World:GetPointInfoByUuid(self.uuid)
  if info == nil then
    info = CS.SceneManager.World:GetPointInfo(self.pointId)
  end
  if info == nil then
    return oneData
  end
  local template = DataCenter.DetectEventTemplateManager:GetDetectEventTemplate(info.eventId)
  if template == nil then
    local eventId = info.eventId
    Logger.LogError("GetTreasureData template is nil, eventId = " .. tostring(eventId))
    return oneData
  end
  oneData.eventId = template.id
  oneData.type = WorldPointUIType.Treasure
  oneData.shareName = template.name
  oneData.pointData = info
  if info.startTime > 0 then
    oneData.refreshTime = info.completionTime
  else
    oneData.refreshTime = info.expireTime
  end
  oneData.serverId = self.serverId
  oneData.shareName = template.name
  oneData.name = template:GetRealName()
  if template:JudgeIsDroneTreasure() then
    oneData.des = "detect_event_desc_1901"
  else
    oneData.des = "activity_wajueji_27000_tips15"
  end
  oneData.icon = LoadPath.GarbageIconsPath .. template.pic .. ".png"
  return oneData
end

local function GetPointData(self)
  local oneData = {}
  oneData.pointData = {}
  oneData.btnList = {}
  if self.type == WorldPointUIType.Treasure then
    oneData.pointData = self:GetTreasureData()
    local info = CS.SceneManager.World:GetPointInfoByUuid(self.uuid)
    if info ~= nil then
      cast(info, typeof(CS.TreasurePointInfo))
      local isHaveWorking = info:IsHaveWorking(LuaEntry.Player.uid)
      if isHaveWorking then
        table.insert(oneData.btnList, WorldPointBtnType.CallBack)
      else
        table.insert(oneData.btnList, WorldPointBtnType.Treasure)
      end
    end
  end
  if oneData.btnList and #oneData.btnList < 5 and UIUtil.CanPutAllianceRallyPoint(self.pointId, self.serverId) and SeasonUtil.IsInSeasonDesertMode() then
    table.insert(oneData.btnList, WorldPointBtnType.PutAlliancePoint)
  end
  if oneData.pointData == nil then
    local uuid = self.uuid and self.uuid or -1
    Logger.LogError("oneData.pointData is nil, self.type:" .. self.type .. ", ,self.pointId: " .. self.pointId .. ", uuid: " .. uuid)
  end
  return oneData
end

local function GetPointBtnEnumName(self, btnValue)
  for k, v in pairs(WorldPointBtnType) do
    if v == btnValue then
      return k
    end
  end
end

function UIWorldActRadarTreasurePointCtrl:ShareTreasure(oneData)
  local share_param = {}
  share_param.sid = self.serverId
  share_param.pos = self.pointId
  share_param.oname = oneData.pointData.shareName
  share_param.postType = PostType.Text_PointShare_Alliance
  share_param.treasureId = oneData.pointData.eventId
  share_param.shareType = oneData.pointData.type
  share_param.uuid = oneData.pointData.uuid
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIPositionShare, {anim = true}, share_param)
  self:CloseSelf()
end

local function OnShareClick(self, server, point, oname, uname, olv, postType)
  local share_param = {}
  share_param.sid = self.serverId
  share_param.pos = point
  share_param.oname = oname
  share_param.uname = uname
  share_param.olv = olv
  share_param.postType = postType
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIPositionShare, {anim = true}, share_param)
  self:CloseSelf()
end

local function OnMarkClick(self, server, point, oname, olv, panelType)
  local share_param = {}
  share_param.sid = self.serverId
  share_param.pos = point
  share_param.oname = oname
  share_param.olv = olv
  panelType = panelType or MarkGroup.Personal
  share_param.panelType = panelType
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIPositionAdd, {anim = true}, share_param)
  self:CloseSelf()
end

local function GetPlayerData(self, pointId)
  local data = {}
  data.playerData = DataCenter.WorldPointDetailManager:GetDetailByPointId(pointId)
  data.name = ""
  data.curHp = 0
  data.maxHp = 0
  data.endTime = 0
  data.shareName = ""
  return data
end

UIWorldActRadarTreasurePointCtrl.CloseSelf = CloseSelf
UIWorldActRadarTreasurePointCtrl.GetIsArrow = GetIsArrow
UIWorldActRadarTreasurePointCtrl.SetIsArrow = SetIsArrow
UIWorldActRadarTreasurePointCtrl.GetPointData = GetPointData
UIWorldActRadarTreasurePointCtrl.InitData = InitData
UIWorldActRadarTreasurePointCtrl.ClearData = ClearData
UIWorldActRadarTreasurePointCtrl.GetTreasureData = GetTreasureData
UIWorldActRadarTreasurePointCtrl.GetPointBtnEnumName = GetPointBtnEnumName
UIWorldActRadarTreasurePointCtrl.OnShareClick = OnShareClick
UIWorldActRadarTreasurePointCtrl.OnMarkClick = OnMarkClick
UIWorldActRadarTreasurePointCtrl.GetPlayerData = GetPlayerData
return UIWorldActRadarTreasurePointCtrl
