local UILWPlayerDeatilServerInfoItem = BaseClass("UILWPlayerDeatilServerInfoItem", UIBaseContainer)
local base = UIBaseContainer
local careerIconPatch = "Assets/Main/Sprites/UI/LWPlayerInfo/Sprite/New/"

function UILWPlayerDeatilServerInfoItem:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:ReInit()
end

function UILWPlayerDeatilServerInfoItem:OnAddListener()
  self:AddUIListener(EventId.OfficialApplyTipRefresh, self.RefreshOfficialApplyPoint)
  self:AddUIListener(EventId.KingdomPositionInfoUpdate, self.RefreshOfficialApplyPoint)
  self:AddUIListener(EventId.ActMigrationOnUpdateOneServerInfo, self.RefreshNBServerState)
  base.OnAddListener(self)
end

function UILWPlayerDeatilServerInfoItem:OnRemoveListener()
  self:RemoveUIListener(EventId.OfficialApplyTipRefresh, self.RefreshOfficialApplyPoint)
  self:RemoveUIListener(EventId.KingdomPositionInfoUpdate, self.RefreshOfficialApplyPoint)
  self:RemoveUIListener(EventId.ActMigrationOnUpdateOneServerInfo, self.RefreshNBServerState)
  base.OnRemoveListener(self)
end

function UILWPlayerDeatilServerInfoItem:ComponentDefine()
  self.notCom = self:AddComponent(UIBaseContainer, "not")
  self.icon = self:AddComponent(UIImage, "icon")
  self.text = self:AddComponent(UIText, "text")
  self.btn = self:AddComponent(UIButton, "")
  self.tip = self:AddComponent(UIImage, "tip")
  self.bg = self:AddComponent(UIImage, "bg")
  self.haveApply_img = self:AddComponent(UIImage, "haveApplyImg")
  self.btn:SetOnClick(function()
    if self.notClick then
      return
    end
    self:OnClick()
  end)
  self:ShowNotIcon(false)
  self.goNBServer = self.transform:Find("iconNBServer")
  if IsNotNull(self.goNBServer) then
    self.goNBServer = self.goNBServer.gameObject
    self.goNBServer:SetActive(false)
  end
end

function UILWPlayerDeatilServerInfoItem:OnClick()
  if self.type == PlayerServerInfoType.Alliance then
    self:OnAllianceBtnClick()
  elseif self.type == PlayerServerInfoType.Server then
    self:OnServerBtnClick()
  end
end

function UILWPlayerDeatilServerInfoItem:OnServerBtnClick()
  if UIManager:GetInstance():IsWindowOpen(UIWindowNames.UIGovernmentOfficial) then
    UIManager:GetInstance():DestroyWindow(UIWindowNames.UIGovernmentOfficial)
  end
  if self.data.isSelf then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIGovernmentOfficial, {anim = true}, LuaEntry.Player:GetSourceServerId())
  elseif self.view.ctrl then
    local data = UIUtil.GetPlayerInfoShowByUid(self.data.uid)
    if data and data.serverId then
      UIManager:GetInstance():OpenWindow(UIWindowNames.UIGovernmentOfficial, {anim = true}, data.serverId)
    end
  end
end

function UILWPlayerDeatilServerInfoItem:RefreshOfficialApplyPoint()
  if self.type ~= PlayerServerInfoType.Server then
    return
  end
  if self.data.isSelf and DataCenter.GovernmentManager:SwitchOpenOrAtHomeNow() then
    self.haveApply_img:SetActive(DataCenter.OfficialApplyManager:HaveApplyRed())
  else
    self.haveApply_img:SetActive(false)
  end
end

function UILWPlayerDeatilServerInfoItem:OnAllianceBtnClick()
  if not self.data.isSelf then
    self:TryShowAllianceDetail()
    return
  end
  local data = DataCenter.AllianceBaseDataManager:GetAllianceBaseData()
  if data ~= nil and not string.IsNullOrEmpty(data.abbr) then
    if UIManager:GetInstance():IsWindowOpen(UIWindowNames.UILWAlMain) then
      UIManager:GetInstance():DestroyWindow(UIWindowNames.UILWAlMain)
    end
    UIManager:GetInstance():OpenWindow(UIWindowNames.UILWAlMain)
    self.view.ctrl:CloseSelf()
  elseif LuaEntry.Player:IsInSourceServer() then
    if LuaEntry.Player:IsFirstJoinAlliance() == true then
      UIManager:GetInstance():OpenWindow(UIWindowNames.UILWAllianceFirstJoin, {anim = true})
    else
      UIManager:GetInstance():OpenWindow(UIWindowNames.UILWAlCreateJoin, {anim = true}, {guide = false})
    end
  else
    UIUtil.ShowTipsId("season_tips166")
  end
end

function UILWPlayerDeatilServerInfoItem:TryShowAllianceDetail()
  if self.isDisguiser then
    UIUtil.ShowTipsId("season_mastery_174")
    return
  end
  if self.data then
    local allianceId = self.data.allianceId
    if string.IsNullOrEmpty(allianceId) or string.IsNullOrEmpty(self.data.allianceName) then
      UIUtil.ShowTipsId("900507")
      return
    end
    UIUtil.TryShowAllianceInfo(self.data.serverId, allianceId, self.data.allianceName)
  end
end

function UILWPlayerDeatilServerInfoItem:ReInit(data, type)
  self.data = data
  self.type = type
  if not data or not self.type then
    self:ShowNotIcon(true)
    return
  end
  self:ShowNotIcon(false)
  if self.type == PlayerServerInfoType.Alliance then
    self:InitAllianceView(data)
  elseif self.type == PlayerServerInfoType.Server then
    self:InitServerView(data)
  end
end

function UILWPlayerDeatilServerInfoItem:InitAllianceView(data)
  if data.isSelf then
    local dataAL = DataCenter.AllianceBaseDataManager:GetAllianceBaseData()
    if dataAL ~= nil and not string.IsNullOrEmpty(dataAL.abbr) then
      self.icon:LoadSprite(string.format(AL_FLAG_SPRITE_PATH, tostring(dataAL.icon)))
      self.text:SetText(UIUtil.FormatAllianceAndName(dataAL.abbr, dataAL.allianceName))
    else
      self.icon:LoadSprite(string.format(AL_FLAG_SPRITE_PATH, "1"))
      self.text:SetLocalText("455000")
    end
    self:RefreshAllianceRank(dataAL and dataAL.rank)
  elseif string.IsNullOrEmpty(data.allianceId) then
    self:ShowNotIcon(true)
  else
    if data.allianceIcon then
      self.icon:LoadSprite(string.format(AL_FLAG_SPRITE_PATH, tostring(data.allianceIcon)))
    end
    self.text:SetText(data.allianceName)
    self:RefreshAllianceRank(data and data.allianceRank)
  end
end

function UILWPlayerDeatilServerInfoItem:RefreshAllianceRank(rank)
  if type(rank) == "number" and rank >= LWAlMemberRankType.R4 and rank <= LWAlMemberRankType.R5 then
    self.tip:SetActive(true)
    self.tip:LoadSprite(LWAlMemberRankParam[rank].Icon)
  else
    self.tip:SetActive(false)
  end
end

function UILWPlayerDeatilServerInfoItem:InitServerView(data)
  if data.isSelf then
    self.icon:LoadSprite(DataCenter.GovernmentManager:GetKingdomBadgesIconPath())
    self.text:SetText("#" .. LuaEntry.Player:GetSourceServerId())
  else
    if data then
      self.icon:LoadSprite(DataCenter.ZoneWarManager:GetKingdomBadgesIconPath(data.serverId))
    end
    if toInt(data.serverId) > 0 then
      self.text:SetText("#" .. data.serverId)
    else
      self.text:SetLocalText("800941")
    end
  end
  self:RefreshOfficialApplyPoint()
  self.tip:SetActive(false)
  self:RefreshNBServerState()
end

function UILWPlayerDeatilServerInfoItem:RefreshNBServerState()
  if self.type ~= PlayerServerInfoType.Server then
    return
  end
  if not DataCenter.ActMigrationManager:IsZoneStarEnable() then
    return
  end
  if IsNotNull(self.goNBServer) and self.data and self.data.serverId then
    local serverInfo = DataCenter.ServerStatusManager:GetOneServerInfo(self.data.serverId)
    if serverInfo then
      if serverInfo.zoneStar > 0 then
        local zoneStarMeta = LocalController:instance():getLine(TableName.LW_Migration_Zone_Star, serverInfo.zoneStar)
        if zoneStarMeta and zoneStarMeta.id == 1 then
          if not self.btnNBServerIcon then
            self.btnNBServerIcon = self:AddComponent(UIButton, self.goNBServer)
            self.btnNBServerIcon:SetOnClick(function()
              UIManager:GetInstance():OpenWindow(UIWindowNames.LWUIMigrationZoneStarPreview, {anim = true}, {
                star = serverInfo.zoneStar,
                serverId = self.data.serverId
              })
              return
            end)
          end
          if self.btnNBServerIcon then
            self.btnNBServerIcon:LoadSpriteAsync(zoneStarMeta.icon)
            self.btnNBServerIcon:SetAspectSize(80)
            self.goNBServer:SetActive(true)
          else
            self.goNBServer:SetActive(false)
          end
        else
          self.goNBServer:SetActive(false)
        end
      else
        self.goNBServer:SetActive(false)
      end
    else
      self.goNBServer:SetActive(false)
    end
  end
end

function UILWPlayerDeatilServerInfoItem:InitCareer()
  local isMasteryOpen = DataCenter.MasteryManager:Enabled()
  if isMasteryOpen and self.data.careerType ~= MasteryHome.None and toInt(self.data.careerLv) > 0 then
    local seasonClassTemp = DataCenter.MasteryManager:GetHomeShowTempByHomeId(self.data.careerType)
    if seasonClassTemp ~= nil then
      self.text:SetText(Localization:GetString("300665", data.careerLv))
      self.icon:LoadSprite(careerIconPatch .. seasonClassTemp.icon)
      return
    end
  end
  self.notClick = true
  self:ShowNotIcon(true)
end

function UILWPlayerDeatilServerInfoItem:ShowNotIcon(isOn)
  self.notCom:SetActive(isOn)
  self.icon:SetActive(not isOn)
  self.text:SetActive(not isOn)
  self.tip:SetActive(not isOn)
  self.bg:SetActive(not isOn)
end

function UILWPlayerDeatilServerInfoItem:ComponentDestroy()
  self.notCom = nil
  self.icon = nil
  self.text = nil
  self.btn = nil
  self.tip = nil
  self.bg = nil
  self.goNBServer = nil
  self.btnNBServerIcon = nil
end

function UILWPlayerDeatilServerInfoItem:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UILWPlayerDeatilServerInfoItem:DataDestroy()
  self.data = nil
  self.config = nil
  self.notClick = nil
end

return UILWPlayerDeatilServerInfoItem
