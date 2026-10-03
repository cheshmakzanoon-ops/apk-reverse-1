local AssistanceWarPlayerItem = require("UI.UIFormationAssistance.Component.AssistanceWarPlayerItem")
local JoinAssistanceItem = require("UI.UIFormationAssistance.Component.JoinAssistanceItem")
local UIFormationAssistanceView = BaseClass("UIFormationAssistanceView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local txt_title_path = "UICommonPopUpTitle/Common_img_title/titleText"
local content_path = "ImgBg/ScrollView/Viewport/Content"
local return_btn_path = "UICommonPopUpTitle/panel"
local close_btn_path = "UICommonPopUpTitle/CloseBtn"
local join_obj_path = "JoinBtn"
local join_obj_text_path = "JoinBtn/JoinBtnText"
local edit_city_defence_path = "EditCityDefenceBtn"
local edit_city_defence_text_path = "EditCityDefenceBtn/EditCityDefenceBtnText"
local name_txt_path = "ImgBg/mainContent/nameTxt"
local num_txt_path = "ImgBg/mainContent/numTxt"
local num_txt2_path = "ImgBg/mainContent/numTxt2"
local power_txt_path = "ImgBg/mainContent/powerTxt"
local info_btn_path = "ImgBg/mainContent/Info"
local head_path = "ImgBg/mainContent/playerHead/UIPlayerHead"
local emptyTips_path = "emptyTips"
local server_flag_path = "ImgBg/mainContent/playerHead/serverFlag"
local server_id_path = "ImgBg/mainContent/playerHead/serverFlag/icon/serverId"

local function OnCreate(self)
  base.OnCreate(self)
  self:DataDefine()
  self:ComponentDefine()
end

local function OnDestroy(self)
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

local function ComponentDefine(self)
  self.title = self:AddComponent(UIText, txt_title_path)
  self.title:SetLocalText(GameDialogDefine.ASSISTANCE)
  self.name_txt = self:AddComponent(UIText, name_txt_path)
  self.num_txt = self:AddComponent(UIText, num_txt_path)
  self.num_txt2 = self:AddComponent(UIText, num_txt2_path)
  self.power_txt = self:AddComponent(UIText, power_txt_path)
  self.emptyTips = self:AddComponent(UIText, emptyTips_path)
  self.emptyTips:SetLocalText("393068")
  self.info_btn = self:AddComponent(UIButton, info_btn_path)
  self.info_btn:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self:OnInfoClick()
  end)
  self.close_btn = self:AddComponent(UIButton, close_btn_path)
  self.close_btn:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self.ctrl:OnCloseClick()
  end)
  self.return_btn = self:AddComponent(UIButton, return_btn_path)
  self.return_btn:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self.ctrl:OnCloseClick()
  end)
  self.join_obj = self:AddComponent(UIButton, join_obj_path)
  self.join_obj:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self:OnJoinClick()
  end)
  self.join_obj:SetSafeClickMode(true)
  self.join_obj:SetSafeClickModeTime(1)
  self.join_obj_text = self:AddComponent(UIText, join_obj_text_path)
  self.join_obj_text:SetLocalText(300516)
  self.edit_city_defence = self:AddComponent(UIButton, edit_city_defence_path)
  self.edit_city_defence_text = self:AddComponent(UIText, edit_city_defence_text_path)
  self.edit_city_defence_text:SetLocalText(457593)
  self.edit_city_defence:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    UIManager:GetInstance():OpenWindow(UIWindowNames.LWCityDefence)
  end)
  self.content = self:AddComponent(UIBaseContainer, content_path)
  self.cells = {}
  self.loopListView = self:AddComponent(UILoopListView2, "ImgBg/ScrollView")
  self.loopListView:InitListView(0, function(listview, index)
    return self:GetScrollItem(listview, index)
  end)
  self.playerUI = self:AddComponent(UICommonHead, head_path)
  self.server_flag = self:AddComponent(UIImage, server_flag_path)
  self.server_id = self:AddComponent(UIText, server_id_path)
end

local function ComponentDestroy(self)
  if self.timerDelayRefreshLoopListView then
    self.timerDelayRefreshLoopListView:Stop()
    self.timerDelayRefreshLoopListView = nil
  end
  self:SetAllCellDestroy()
  self.title = nil
  self.name_txt = nil
  self.num_txt = nil
  self.num_txt2 = nil
  self.close_btn = nil
  self.return_btn = nil
  self.join_obj = nil
  self.content = nil
  self.loopListView = nil
end

local function DataDefine(self)
  self.dataList = {}
  self.lastDataList = {}
  self.expandTable = {}
  self.uuid = nil
  self.asType = nil
  self.ownerUid = nil
  self.pointId = nil
  self.nameCount = 0
  self.isFull = nil
  self.tryJoinAfterRefresh = nil
  self.hasShowAssistanceTips = nil
  self.hasJumpSelf = nil
end

local function DataDestroy(self)
  self.dataList = nil
  self.lastDataList = nil
  self.uuid = nil
  self.asType = nil
  self.ownerUid = nil
  self.pointId = nil
  self.nameCount = nil
  self.isFull = nil
  self.tryJoinAfterRefresh = nil
  self.hasShowAssistanceTips = nil
  self.hasJumpSelf = nil
end

local function OnAddListener(self)
  base.OnAddListener(self)
  self:AddUIListener(EventId.PlayerMessageInfo, self.OnRefreshPlayerDataDelay)
  self:AddUIListener(EventId.GetNewUserInfoSucc, self.OnRefreshPlayerDataDelay)
  self:AddUIListener(EventId.GetNewUserInfoMultiSucc, self.OnRefreshPlayerDataDelay)
  self:AddUIListener(EventId.GetAssistanceData, self.OnRefreshDelay)
  self:AddUIListener(EventId.UIRefreshAssistanceDetailInfo, self.OnAssistanceDetailInfo)
  self:AddUIListener(EventId.NeedUpdateAssistanceData, self.NeedUpdateAssistanceData)
  self:AddUIListener(EventId.SingleMarchStateUpdate, self.OnMarchStateUpdate)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
  self:RemoveUIListener(EventId.PlayerMessageInfo, self.OnRefreshPlayerDataDelay)
  self:RemoveUIListener(EventId.GetNewUserInfoSucc, self.OnRefreshPlayerDataDelay)
  self:RemoveUIListener(EventId.GetNewUserInfoMultiSucc, self.OnRefreshPlayerDataDelay)
  self:RemoveUIListener(EventId.GetAssistanceData, self.OnRefreshDelay)
  self:RemoveUIListener(EventId.UIRefreshAssistanceDetailInfo, self.OnAssistanceDetailInfo)
  self:RemoveUIListener(EventId.NeedUpdateAssistanceData, self.NeedUpdateAssistanceData)
  self:RemoveUIListener(EventId.SingleMarchStateUpdate, self.OnMarchStateUpdate)
end

local function OnEnable(self)
  base.OnEnable(self)
  self:ReInit()
end

local function OnDisable(self)
  base.OnDisable(self)
end

function UIFormationAssistanceView:NeedUpdateAssistanceData()
  if self.buildId == BuildingTypes.LW_ALLIANCE_WAR_CAMP_2 then
    SFSNetwork.SendMessage(MsgDefines.AllianceAssistCampInfo, self.uuid)
  else
    SFSNetwork.SendMessage(MsgDefines.AllianceAssistanceInfo, self.uuid, self.asType)
  end
end

local function ReInit(self)
  local uuid, playerUid, pointId, asType, isThroneCity, isCrossServerThrone = self:GetUserData()
  self.uuid = tonumber(uuid)
  self.ownerUid = playerUid
  self.pointId = tonumber(pointId)
  self.asType = asType
  self.isThroneCity = isThroneCity
  self.isCrossServerThrone = isCrossServerThrone
  self.name_txt:SetText("")
  if self.asType == AssistanceType.Build or self.asType == AssistanceType.Desert or self.asType == AssistanceType.CityStronghold or self.asType == AssistanceType.AllianceBuild then
    self.join_obj:SetActive(true)
    self.edit_city_defence:SetActive(false)
  else
    self.join_obj:SetActive(uuid ~= nil and playerUid ~= LuaEntry.Player.uid)
    self.edit_city_defence:SetActive(uuid == nil or playerUid == LuaEntry.Player.uid)
  end
  self.ctrl:SetUuid(self.uuid, self.ownerUid)
  if not string.IsNullOrEmpty(self.ownerUid) and (self.asType == AssistanceType.MainCity or self.asType == AssistanceType.Build or self.asType == AssistanceType.CityStronghold or self.asType == AssistanceType.AllianceBuild or self.asType == AssistanceType.Desert) then
    DataCenter.PlayerInfoDataManager:RequestPlayerDataMulti(self.ownerUid)
  end
  local pointInfo = CS.SceneManager.World:GetPointInfo(self.pointId)
  if pointInfo then
    self.buildId = pointInfo.buildId
  else
    self.buildId = nil
  end
  self:NeedUpdateAssistanceData()
  if isCrossServerThrone then
    self.server_flag:SetActive(true)
    self.playerUI:SetActive(false)
    self.ownerServerId = nil
    self.ownerInfo = {}
    if pointInfo ~= nil then
      local allianceCityPointInfo = SeasonUtil.TryParseAllianceCityPointInfo(pointInfo.PointType, pointInfo.extraInfo, pointInfo)
      if allianceCityPointInfo ~= nil then
        self.ownerServerId = allianceCityPointInfo.serverId
        self.ownerInfo.serverId = self.ownerServerId
        self.ownerInfo.allianceAbbr = allianceCityPointInfo.alAbbr
        self.serverKingInfo = DataCenter.ZoneWarManager:GetServerInfo(self.ownerServerId)
        if self.serverKingInfo.cfgId then
          local itemCfg = DataCenter.ItemTemplateManager:GetItemTemplate(self.serverKingInfo.cfgId)
          if itemCfg ~= nil then
            self.server_flag:LoadSprite(string.format(LoadPath.ItemPath, itemCfg.icon))
          end
        end
        self.server_id:SetText(SeasonUtil.GetWorldBattleName(self.ownerInfo))
      end
    end
  else
    self.playerUI:SetActive(true)
    self.server_flag:SetActive(false)
  end
  if self.asType == AssistanceType.AllianceCity or self.asType == AssistanceType.ASSISTANCE_OUTPOST then
    self:OnRefreshAllianceCityData()
  elseif self.asType == AssistanceType.AllianceBuild then
    self:OnRefreshAllianceBuildData()
  elseif self.asType == AssistanceType.CityStronghold then
    self:OnRefreshAllianceCityData()
  elseif self.asType == AssistanceType.ASSISTANCE_ZWL_BUILDING then
    self:OnRefreshAllianceCityData()
  elseif self.asType == AssistanceType.WinterEntity then
    self:OnRefreshWinterEntityData()
  end
end

function UIFormationAssistanceView:CanMultiAssistance()
  if BattleFieldUtil.InBattleField() then
    local mgr = BattleFieldUtil.GetMgrActive()
    if mgr and mgr:CanMultiAssistance() then
      return true
    end
  end
  return false
end

local function OnRefresh(self)
  local data = self.ctrl:GetBuildData(self.asType)
  local list = self.ctrl:GetPlayerIdList()
  local power = 0
  local mgr = DataCenter.SeasonAllyFriendManager
  local helpMarchCount = 0
  local length = list ~= nil and table.length(list) or 0
  self.lastDataList = self.dataList or {}
  self.dataList = list or {}
  self.dataLength = length
  self.isFull = length >= data.maxNum
  if 0 < length then
    self.num_txt:SetText(Localization:GetString(GameDialogDefine.ASSISTANCE_NUM) .. " " .. length .. "/" .. data.maxNum)
    local ownIdx = 0
    local myUid = LuaEntry.Player:GetUid()
    local keepIndex, keepOffset
    for i = 0, self.loopListView.unity_looplistview2.ItemTotalCount do
      local item = self.loopListView:GetShownItemByIndex(i)
      if item then
        local corners = self.loopListView:GetItemCornerPosInViewPort(item, CS.SuperScrollView.ItemCornerEnum.LeftTop)
        if corners and 0 > corners.y then
          local lastData = self.lastDataList[item.ItemIndex + 1]
          if lastData then
            for k, v in ipairs(self.dataList) do
              if v == lastData then
                keepIndex = k - 1
                keepOffset = corners.y
                break
              end
            end
            if not keepIndex then
              keepIndex = item.ItemIndex
              keepOffset = corners.y
            end
          end
          if keepIndex then
            break
          end
        end
      end
    end
    self.loopListView:SetListItemCount_Mod(length, false, false, true)
    if keepIndex then
      TimerManager:GetInstance():DelayFrameInvoke(function()
        if self.loopListView then
          self.loopListView:MovePanelToItemIndex(keepIndex, -keepOffset)
        end
      end)
    end
    for i = 1, length do
      local marchUuid = list[i]
      local dataInfo = self.ctrl:GetPlayerItemData(marchUuid, self.isCrossServerThrone)
      if dataInfo.ownerUid then
        if dataInfo.ownerUid == myUid then
          ownIdx = i
        end
        if self.ownerAllianceId ~= dataInfo.allianceId and self.asType == AssistanceType.AllianceCity and (mgr:IsMyFriendAlly(dataInfo.allianceId) or mgr:IsMyFriendAlly(self.ownerAllianceId)) then
          helpMarchCount = helpMarchCount + 1
        end
        power = power + (dataInfo.power or 0)
      end
    end
    if 0 < ownIdx then
      TimerManager:GetInstance():DelayFrameInvoke(function()
        if self.loopListView and not self.hasJumpSelf then
          self.hasJumpSelf = true
          self.loopListView:MovePanelToItemIndex(ownIdx - 1, 0)
        end
      end)
      if not self.hasShowAssistanceTips and not self:CanMultiAssistance() then
        self.hasShowAssistanceTips = true
        UIUtil.ShowTipsId(121219)
      end
    end
    self.emptyTips:SetActive(false)
  else
    self:SetAllCellDestroy()
    self.num_txt:SetText(Localization:GetString(GameDialogDefine.ASSISTANCE_NUM) .. " 0/" .. data.maxNum)
    self.emptyTips:SetActive(true)
  end
  if self.num_txt2 then
    if 0 < helpMarchCount then
      self.num_txt2:SetActive(true)
      self.num_txt2:SetLocalText("s6_alliance_ally_desc56", helpMarchCount)
    else
      self.num_txt2:SetActive(false)
    end
  end
  self.power_txt:SetText(Localization:GetString("393066") .. ": " .. string.GetFormattedSeparatorNum(power))
  self:RefreshPlayerHead()
  if self.tryJoinAfterRefresh then
    self.tryJoinAfterRefresh = false
    if self.isFull then
      UIUtil.ShowTipsId(120738)
    else
      self.ctrl:OnJoinClick(self.asType, self.pointId, self.isThroneCity, self.isCrossServerThrone)
    end
  end
end

local function RefreshPlayerHead(self)
  if self.asType == AssistanceType.WinterEntity then
    local template = self.ctrl:GetBattleFieldData(self.pointId, BattleFieldType.WinterStorm)
    if template ~= nil then
      self.playerUI:SetData(nil, template:GetIconPath())
    end
  elseif self.asType == AssistanceType.AllianceCity or self.asType == AssistanceType.ASSISTANCE_OUTPOST or self.asType == AssistanceType.ASSISTANCE_ZWL_BUILDING then
    local cityData = DataCenter.AllianceCityTemplateManager:GetCityDataByPointIndex(self.pointId, LuaEntry.Player:GetCurServerId())
    if cityData ~= nil then
      local iconPath = cityData:GetIconPath(false)
      self.playerUI:SetData(nil, iconPath)
    end
  elseif self.asType == AssistanceType.DragonBuild then
    local pointInfo = CS.SceneManager.World:GetPointInfo(self.pointId)
    if pointInfo ~= nil then
      local detailInfo = pointInfo.detail
      if detailInfo then
        local buildId = detailInfo.BuildId or detailInfo.ItemId
        local template = DataCenter.DragonBuildTemplateManager:GetTemplate(buildId)
        if template then
          self.playerUI:SetData(nil, template:GetDetailPath())
        end
      end
    end
  elseif self.asType == AssistanceType.CityStronghold then
    local cityData = DataCenter.AllianceCityTemplateManager:GetCityDataByPointIndex(self.pointId, LuaEntry.Player:GetCurServerId())
    if cityData ~= nil then
      local iconPath = cityData:GetIconPath(false)
      self.playerUI:SetData(nil, iconPath)
    end
  elseif self.ownerUid then
    local member = DataCenter.AllianceMemberDataManager:GetAllianceMemberByUid(self.ownerUid)
    if member then
      self.playerUI:SetData(member.uid, member.pic, member.picVer, false, member:GetHeadBgImg())
    end
  else
    Logger.LogInfo("RefreshPlayerHead." .. self.asType)
  end
end

local function SetAllCellDestroy(self)
  self.content:RemoveComponents(AssistanceWarPlayerItem)
  self.loopListView:ClearAllItems()
  self.cells = {}
end

local function OnRefreshPlayerData(self)
  if self.asType == AssistanceType.Build or self.asType == AssistanceType.MainCity or self.asType == AssistanceType.Desert then
    local data = self.ctrl:GetPlayerData(self.ownerUid, self.pointId, self.asType)
    if data ~= nil then
      local playerName = ""
      if data.playerData then
        playerName = data.playerData.name
        if data.playerData.alAbbr ~= nil and data.playerData.alAbbr ~= "" then
          playerName = "[" .. data.playerData.alAbbr .. "]" .. data.playerData.name
        end
      end
      if self.asType == AssistanceType.MainCity then
        self.name_txt:SetLocalText(GameDialogDefine.DOME_OF_A, playerName)
      elseif self.asType == AssistanceType.Build then
        if data.name ~= nil and data.name ~= "" then
          local buildName = Localization:GetString(data.name)
          self.name_txt:SetLocalText(GameDialogDefine.B_OF_A, playerName, buildName)
        else
          self.name_txt:SetLocalText(GameDialogDefine.B_OF_A, playerName, "")
        end
      elseif self.asType == AssistanceType.Desert then
        local buildName = ""
        if data.level > 0 then
          buildName = Localization:GetString(data.name, data.level)
        else
          buildName = Localization:GetString("110245")
        end
        self.name_txt:SetLocalText(GameDialogDefine.B_OF_A, playerName, buildName)
      end
    end
  end
end

local function OnRefreshWinterEntityData(self)
  if self.asType == AssistanceType.WinterEntity then
    local template = self.ctrl:GetBattleFieldData(self.pointId, BattleFieldType.WinterStorm)
    if template ~= nil then
      self.name_txt:SetLocalText(template.name)
    end
  end
end

local function OnRefreshAllianceCityData(self)
  if self.asType == AssistanceType.AllianceCity or self.asType == AssistanceType.CityStronghold or self.asType == AssistanceType.ASSISTANCE_ZWL_BUILDING or self.asType == AssistanceType.ASSISTANCE_OUTPOST then
    local data = self.ctrl:GetAllianceCityData(self.pointId)
    if data ~= nil then
      self.ownerAllianceId = data.allianceId
      if self.isCrossServerThrone then
        self.name_txt:SetText(data.name)
      else
        local ownerName = ""
        if data.alAbbr ~= nil and data.alAbbr ~= "" then
          ownerName = "[" .. data.alAbbr .. "]" .. data.alName
        end
        if string.IsNullOrEmpty(ownerName) then
          self.name_txt:SetLocalText("310161", data.name, data.level)
        else
          local cityName = Localization:GetString("140205", data.level, data.name)
          self.name_txt:SetLocalText(GameDialogDefine.B_OF_A, ownerName, cityName)
        end
      end
    end
  end
  if self.asType == AssistanceType.ASSISTANCE_OUTPOST then
    self.pointInfo = CS.SceneManager.World:GetPointInfoByUuid(self.uuid)
    if self.pointInfo ~= nil then
      self.serverId = self.pointInfo.serverId
      self.cityId = self.pointInfo.CityId
      self.ownerAllianceId = self.pointInfo.ownerAllianceId
      local FetchOutpostDetailInfo = require("Net.Msgs.Season5.Outpost.FetchOutpostDetailInfoMessage")
      if FetchOutpostDetailInfo then
        local outpostDetailInfo = FetchOutpostDetailInfo.GetDetailInfo(self.serverId, self.cityId, false)
        if outpostDetailInfo ~= nil then
          local mySourceServerId = LuaEntry.Player:GetSourceServerId()
          local now = UITimeManager:GetInstance():GetServerTime()
          local ownerServerId = outpostDetailInfo.ownerServerId
          local tmpOwnerServerId = outpostDetailInfo.tmpOwnerServerId
          if tmpOwnerServerId == 0 then
            if mySourceServerId ~= ownerServerId then
              self.join_obj:SetActive(false)
            end
          elseif mySourceServerId ~= tmpOwnerServerId then
            self.join_obj:SetActive(false)
          end
          if outpostDetailInfo.protectTime then
            local protectTime = toInt(outpostDetailInfo.protectTime)
            local inProtectMode = now < protectTime
            if inProtectMode then
              self.join_obj:SetActive(false)
            end
          end
        end
      end
    end
  end
end

local function OnRefreshAllianceBuildData(self)
  if self.asType == AssistanceType.AllianceBuild or self.asType == AssistanceType.CityStronghold or self.asType == AssistanceType.ASSISTANCE_OUTPOST then
    local data = self.ctrl:GetAllianceBuildData(self.pointId)
    if data ~= nil then
      self.name_txt:SetText(UIUtil.FormatAllianceAndName(data.alAbbr, Localization:GetString(data.name)))
    end
  end
end

local function OnInfoClick(self)
  local param = {}
  param.type = "desc"
  param.isLocal = true
  if self.isCrossServerThrone then
    local cityData = DataCenter.AllianceCityTemplateManager:GetCityDataByPointIndex(self.pointId, LuaEntry.Player:GetCurServerId())
    if cityData ~= nil and cityData:IsMissileFactory() then
      param.desc = Localization:GetString("season_activity_1000086_tips41")
    else
      param.desc = Localization:GetString(801494)
    end
  else
    param.desc = Localization:GetString(110222)
  end
  param.alignObject = self.info_btn
  param.isModify = true
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIItemTips, {anim = true}, param)
end

function UIFormationAssistanceView:ScrollToBottom()
  local dataList = self.dataList
  if dataList == nil or #dataList <= 0 then
    return
  end
  if self.loopListView then
    self.loopListView:MovePanelToItemIndex(#dataList - 1, 0)
  end
end

function UIFormationAssistanceView:OnJoinClick()
  local data = self.ctrl:GetBuildData(self.asType)
  if data.alreadyHave and not self:CanMultiAssistance() then
    UIUtil.ShowTipsId(121219)
    return
  end
  if self.isFull then
    self:ReInit()
    self.tryJoinAfterRefresh = true
    return
  end
  self.ctrl:OnJoinClick(self.asType, self.pointId, self.isThroneCity, self.isCrossServerThrone)
end

function UIFormationAssistanceView:GetScrollItem(listview, index)
  local dataList = self.dataList
  if dataList == nil or #dataList <= 0 then
    return nil
  end
  index = index + 1
  if index < 1 or index > #dataList then
    return nil
  end
  local expand = self.expandTable[index]
  local csItem = listview:NewListViewItem(expand and "AllianceWarPlayerItemExpand" or "AllianceWarPlayerItem")
  if self.cells[csItem] == nil then
    self.nameCount = self.nameCount + 1
    local nameStr = tostring(self.nameCount)
    csItem.gameObject.name = nameStr
    local cell = self.content:AddComponent(AssistanceWarPlayerItem, nameStr)
    cell.ctrl = self.ctrl
    self.cells[csItem] = cell
  end
  self.cells[csItem]:SetUuid(dataList[index], self.ownerServerId, self.isCrossServerThrone, index, expand)
  self.cells[csItem]:RefreshData()
  return csItem
end

function UIFormationAssistanceView:RefreshAllShownItem(index, expand)
  self.expandTable[index] = expand
  if self.timerDelayRefreshLoopListView then
    self.timerDelayRefreshLoopListView:Stop()
  end
  self.timerDelayRefreshLoopListView = TimerManager:GetInstance():DelayFrameInvoke(function()
    self.loopListView:RefreshAllShownItem()
  end, 2)
  local dataList = self.dataList
  if dataList == nil or #dataList <= 0 then
    return
  end
  if #dataList == index then
    TimerManager:GetInstance():DelayFrameInvoke(function()
      self:ScrollToBottom()
    end, 4)
  end
end

function UIFormationAssistanceView:OnAssistanceDetailInfo(pointId)
  pointId = pointId and tonumber(pointId)
  if pointId and pointId == self.pointId then
    self:ReInitDelay()
  end
end

function UIFormationAssistanceView:OnMarchStateUpdate(marchUuid)
  local marchData = DataCenter.WorldMarchDataManager:GetMarch(marchUuid)
  if marchData == nil then
    return
  end
  local isAssistingMarch = marchData.status == CS.MarchStatus.ASSISTANCE
  if isAssistingMarch and marchData.targetPos == self.pointId then
    self:NeedUpdateAssistanceData()
  end
end

local function Update100MS(self)
  if self.reInitDirty then
    self.reInitDirty = false
    self:ReInit()
  end
  if self.refreshPlayerDataDirty then
    self.refreshPlayerDataDirty = false
    self:OnRefreshPlayerData()
  end
  if self.refreshDirty then
    self.refreshDirty = false
    self:OnRefresh()
  end
end

local function ReInitDelay(self)
  if self.isFull or self.dataLength and self.dataLength > 30 then
    self.reInitDirty = true
    return
  end
  self:ReInit()
end

local function OnRefreshDelay(self)
  if self.isFull or self.dataLength and self.dataLength > 30 then
    self.refreshDirty = true
    return
  end
  self:OnRefresh()
end

local function OnRefreshPlayerDataDelay(self)
  if self.isFull or self.dataLength and self.dataLength > 30 then
    self.refreshPlayerDataDirty = true
    return
  end
  self:OnRefreshPlayerData()
end

UIFormationAssistanceView.OnCreate = OnCreate
UIFormationAssistanceView.OnDestroy = OnDestroy
UIFormationAssistanceView.ComponentDefine = ComponentDefine
UIFormationAssistanceView.ComponentDestroy = ComponentDestroy
UIFormationAssistanceView.DataDefine = DataDefine
UIFormationAssistanceView.DataDestroy = DataDestroy
UIFormationAssistanceView.OnEnable = OnEnable
UIFormationAssistanceView.OnDisable = OnDisable
UIFormationAssistanceView.OnAddListener = OnAddListener
UIFormationAssistanceView.OnRemoveListener = OnRemoveListener
UIFormationAssistanceView.ReInit = ReInit
UIFormationAssistanceView.Update100MS = Update100MS
UIFormationAssistanceView.OnRefresh = OnRefresh
UIFormationAssistanceView.OnRefreshPlayerData = OnRefreshPlayerData
UIFormationAssistanceView.SetAllCellDestroy = SetAllCellDestroy
UIFormationAssistanceView.OnRefreshAllianceCityData = OnRefreshAllianceCityData
UIFormationAssistanceView.OnRefreshWinterEntityData = OnRefreshWinterEntityData
UIFormationAssistanceView.RefreshPlayerHead = RefreshPlayerHead
UIFormationAssistanceView.OnInfoClick = OnInfoClick
UIFormationAssistanceView.OnRefreshAllianceBuildData = OnRefreshAllianceBuildData
UIFormationAssistanceView.ReInitDelay = ReInitDelay
UIFormationAssistanceView.OnRefreshDelay = OnRefreshDelay
UIFormationAssistanceView.OnRefreshPlayerDataDelay = OnRefreshPlayerDataDelay
return UIFormationAssistanceView
