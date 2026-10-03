local UIBFDsbDuelBattleBuildStateItem = BaseClass("UIBFDsbDuelBattleBuildStateItem", UIBaseContainer)
local LWAllianceWarPlayerHead = require("UI.UIAlliance.UIAllianceWarMainTable.Component.LWAllianceWarPlayerHead")
local base = UIBaseContainer
local UIGray = CS.UIGray
local Localization = CS.GameEntry.Localization
local AllianceWarMemberShow = {
  ownerName = "",
  leader = false,
  cancel = false,
  status = MarchStatus.DEFAULT,
  endTime = 0,
  startTime = 0
}
local OnePlayerData = DataClass("OnePlayerData", AllianceWarMemberShow)
local icon_attack_path = "iconAttack"
local icon_defence_path = "iconDefence"
local march_time_path = "marchTime"
local u_i_player_head_path = "UIPlayerHead"
local dist_txt_path = "distTxt"
local btn_add_path = "btnAdd"
local name_txt_path = "info/nameTxt"
local content_path = "info/content"

function UIBFDsbDuelBattleBuildStateItem:OnCreate()
  base.OnCreate(self)
  self.icon_attack = self:AddComponent(UIImage, icon_attack_path)
  self.icon_defence = self:AddComponent(UIImage, icon_defence_path)
  self.march_time = self:AddComponent(UIText, march_time_path)
  self.player_head = self:AddComponent(UICommonHead, u_i_player_head_path)
  self.dist_txt = self:AddComponent(UIText, dist_txt_path)
  self.player_join_btn = self:AddComponent(UIButton, btn_add_path)
  self.name_txt = self:AddComponent(UIText, name_txt_path)
  self.playerRoot = self:AddComponent(UIBaseContainer, content_path)
  self.player_head_list = {}
  for i = 1, 6 do
    self.player_head_list[i] = self:AddComponent(LWAllianceWarPlayerHead, "info/content/player" .. i)
  end
  self.player_head_list[5]:SetActive(false)
  self.player_head_list[6]:SetActive(false)
  self.player_join_btn:SetOnClick(function()
    self:JoinTeam()
  end)
end

function UIBFDsbDuelBattleBuildStateItem:OnDestroy()
  base.OnDestroy(self)
end

function UIBFDsbDuelBattleBuildStateItem:OnEnable()
  base.OnEnable(self)
end

function UIBFDsbDuelBattleBuildStateItem:OnDisable()
  base.OnDisable(self)
end

function UIBFDsbDuelBattleBuildStateItem:JoinTeam()
  if self:CheckIsJoin() then
    local data = DataCenter.AllianceWarDataManager:GetAllianceWarDataByUuid(self.uuid)
    if data ~= nil then
      UIManager:GetInstance():DestroyWindow(UIWindowNames.UIBFDsbDuelBattleBuildState)
      MarchUtil.OnClickStartMarch(MarchTargetType.JOIN_RALLY, data.leaderMarch.startId, self.uuid, -1, 1, MarchTargetType.RALLY_EPIDEMIC_BUILDING)
    end
  else
    UIUtil.ShowTipsId(120226)
  end
end

function UIBFDsbDuelBattleBuildStateItem:CheckIsJoin()
  return DataCenter.AllianceWarDataManager:CheckJoinAllianceWar(self.uuid)
end

function UIBFDsbDuelBattleBuildStateItem:ReInit(warId, data, pointData, one)
  local myAllianceId = LuaEntry.Player.allianceId
  self.uuid = warId
  self.dist_txt:SetActive(true)
  if data ~= nil and one then
    self.playerRoot:SetActive(false)
    self.player_join_btn:SetActive(false)
    self.name_txt:SetText("[" .. data.allianceAbbr .. "]" .. data.ownerName)
    if data.teamUuid ~= nil then
      local dataAL = DataCenter.AllianceWarDataManager:GetAllianceWarDataByUuid(data.teamUuid)
      if dataAL and dataAL.leaderMarch then
        local dataInfo = self:GetPlayerItemData(dataAL.leaderMarch.uuid, dataAL)
        self.player_head:SetData(dataInfo.ownerUid, dataInfo.ownerIcon, dataInfo.ownerIconVer, nil, dataInfo.headBg)
      else
        self.player_head:SetData(data.ownerUid, data.pic, data.picVer)
      end
    else
      self.player_head:SetData(data.ownerUid, data.pic, data.picVer)
    end
    local attackPos = SceneUtils.IndexToTilePos(data.startPos, ForceChangeScene.World)
    local targetPos = SceneUtils.IndexToTilePos(data.targetPos, ForceChangeScene.World)
    local distance = math.ceil(SceneUtils.TileDistance(attackPos, targetPos))
    self.dist_txt:SetLocalText(141020, distance)
    if distance == 0 then
      self.dist_txt:SetActive(false)
    end
    if data:GetMarchStatus() == MarchStatus.ASSISTANCE or data:GetMarchStatus() == MarchStatus.STATION then
      self.icon_attack:SetActive(false)
      self.icon_defence:SetActive(true)
    elseif pointData.state == 1 then
      self.icon_attack:SetActive(false)
      self.icon_defence:SetActive(true)
    else
      self.icon_attack:SetActive(data.allianceUid == myAllianceId)
      self.icon_defence:SetActive(data.allianceUid ~= myAllianceId)
    end
    self.dataInfo1 = data
  elseif data ~= nil and not one then
    local index = 1
    self.playerRoot:SetActive(true)
    self.name_txt:SetText("[" .. data.attackAllianceAbbr .. "]" .. data.attackName)
    if data.leaderMarch ~= nil then
      local dataInfo = self:GetPlayerItemData(data.leaderMarch.uuid, data)
      self.player_head:SetData(dataInfo.ownerUid, dataInfo.ownerIcon, dataInfo.ownerIconVer, nil, dataInfo.headBg)
    end
    if data.memberList ~= nil then
      for uuid, memberMarch in pairs(data.memberList) do
        local dataInfo = self:GetPlayerItemData(uuid, data)
        self.player_head_list[index]:SetActive(true)
        self.player_head_list[index]:SetJoinActive(false)
        self.player_head_list[index]:RefreshData(dataInfo)
        index = index + 1
      end
    end
    local showJoin = self:CheckIsJoin()
    self.player_join_btn:SetActive(showJoin)
    for i = index, 6 do
      self.player_head_list[i]:SetActive(true)
      self.player_head_list[i]:SetEmpty()
    end
    self.player_head_list[5]:SetActive(false)
    self.player_head_list[6]:SetActive(false)
    local attackPos = SceneUtils.IndexToTilePos(data.attackPointId, ForceChangeScene.World)
    local targetPos = SceneUtils.IndexToTilePos(data.targetPointId, ForceChangeScene.World)
    local distance = math.ceil(SceneUtils.TileDistance(attackPos, targetPos))
    self.dist_txt:SetLocalText(141020, distance)
    self.icon_attack:SetActive(data.attackAllianceId == myAllianceId)
    self.icon_defence:SetActive(data.attackAllianceId ~= myAllianceId)
    self.dataInfo2 = data
  end
  self:Update1000MS()
end

function UIBFDsbDuelBattleBuildStateItem:Update1000MS()
  local curTime = UITimeManager:GetInstance():GetServerTime()
  if self.dataInfo1 ~= nil then
    local deltaTime = self.dataInfo1.endTime - curTime
    if self.dataInfo1.status == MarchStatus.ASSISTANCE or self.dataInfo1.status == MarchStatus.STATION then
      self.icon_attack:SetActive(false)
      self.icon_defence:SetActive(true)
      self.dist_txt:SetActive(false)
      self.march_time:SetText(Localization:GetString("458223"))
    else
      self.march_time:SetLocalText(390135, UITimeManager:GetInstance():MilliSecondToFmtString(deltaTime))
    end
  elseif self.dataInfo2 ~= nil then
    local dialog = "141032"
    local deltaTime = 0
    if self.dataInfo2.marchendTime and curTime < self.dataInfo2.marchendTime then
      deltaTime = self.dataInfo2.marchendTime - curTime
      dialog = "390789"
    elseif self.dataInfo2.waitTime and curTime < self.dataInfo2.waitTime then
      deltaTime = self.dataInfo2.waitTime - curTime
      dialog = "141032"
    elseif self.dataInfo2.marchTime and curTime < self.dataInfo2.marchTime then
      deltaTime = self.dataInfo2.marchTime - curTime
      dialog = "390789"
    else
      dialog = "390789"
    end
    if 0 < deltaTime then
      self.march_time:SetText(Localization:GetString(dialog) .. UITimeManager:GetInstance():MilliSecondToFmtString(deltaTime))
    else
      self.march_time:SetLocalText(dialog)
    end
  end
end

function UIBFDsbDuelBattleBuildStateItem:GetPlayerItemData(marchUuid, info)
  local oneData = OnePlayerData.New()
  local selfUid = LuaEntry.Player.uid
  if info ~= nil then
    if info.memberList[marchUuid] ~= nil then
      local data = info.memberList[marchUuid]
      oneData.ownerName = data.ownerName
      oneData.status = data.status
      oneData.endTime = data.endTime
      oneData.startTime = data.startTime
      oneData.leader = false
      oneData.cancel = data.ownerUid == selfUid or info.attackUid == selfUid
      oneData.ownerUid = data.ownerUid
      oneData.teamUuid = data.teamUuid
      oneData.attackUid = info.attackUid
      oneData.ownerIcon = data.ownerIcon
      oneData.ownerIconVer = data.ownerIconVer
      oneData.headBg = data:GetHeadBgImg()
    elseif info.leaderMarch ~= nil and info.leaderMarch.uuid == marchUuid then
      local data = info.leaderMarch
      oneData.ownerName = data.ownerName
      oneData.status = data.status
      oneData.endTime = data.endTime
      oneData.startTime = data.startTime
      oneData.leader = true
      oneData.cancel = data.ownerUid == selfUid
      oneData.ownerUid = data.ownerUid
      oneData.teamUuid = data.teamUuid
      oneData.attackUid = info.attackUid
      oneData.ownerIcon = data.ownerIcon
      oneData.ownerIconVer = data.ownerIconVer
      oneData.headBg = data:GetHeadBgImg()
    end
  end
  return oneData
end

function UIBFDsbDuelBattleBuildStateItem:CheckIsJoin()
  return DataCenter.AllianceWarDataManager:CheckJoinAllianceWar(self.uuid)
end

return UIBFDsbDuelBattleBuildStateItem
