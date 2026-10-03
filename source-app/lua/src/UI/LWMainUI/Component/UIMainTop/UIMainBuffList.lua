local base = UIBaseContainer
local UIMainBuffList = BaseClass("UIMainBuffList", UIBaseContainer)
local BuffIcon = require("UI.LWMainUI.Component.UIMainLeft.BuffIcon")
local Localization = CS.GameEntry.Localization

function UIMainBuffList:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UIMainBuffList:OnDestroy()
  self:DestroyBuff()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIMainBuffList:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.gridLayoutGroupBuffList = self.viewSkin:AddComponent(self, UIGridLayoutGroup, 1)
  self.compBuffListRoot = self.viewSkin:AddComponent(self, UIBaseContainer, 2)
  self.view:RegisterFunctionUnlock(LWFunctionUnlockType.MainUI_Buff, self.gridLayoutGroupBuffList)
end

function UIMainBuffList:ComponentDestroy()
  self.viewSkin = nil
  self.gridLayoutGroupBuffList = nil
  self.compBuffListRoot = nil
end

function UIMainBuffList:DataDefine()
  self.buff_content_item_max = toInt(LuaEntry.DataConfig:TryGetNum("interface_buff_icon", "k1", 8))
  if self.buff_content_item_max < 1 then
    self.buff_content_item_max = 8
  end
end

function UIMainBuffList:DataDestroy()
  if self.delayTimeRefreshBuff ~= nil then
    self.delayTimeRefreshBuff:Stop()
    self.delayTimeRefreshBuff = nil
  end
end

function UIMainBuffList:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.LuaEntryEffectRefreshStatus, self.RefreshBuff)
  self:AddUIListener(EventId.SetMainWorldPointId, self.RefreshBuff)
  self:AddUIListener(EventId.WarFlagAdd, self.RefreshBuff)
  self:AddUIListener(EventId.MyBaseTemperatureConfigChange, self.RefreshBuff)
  self:AddUIListener(EventId.MyBasePhaseChange, self.RefreshBuff)
  self:AddUIListener(EventId.SelfOfficialPositionChange, self.RefreshBuff)
  self:AddUIListener(EventId.SelfCollectLimitLevelChange, self.RefreshBuff)
  self:AddUIListener(EventId.SandWormWrapRefresh, self.RefreshBuff)
  self:AddUIListener(EventId.JungleTrialWrapRefresh, self.RefreshBuff)
  self:AddUIListener(EventId.RefreshMyWallBar, self.RefreshBuff)
  self:AddUIListener(EventId.BloodyNightActivityRefresh, self.RefreshBuff)
  self:AddUIListener(EventId.MyPositionRefresh, self.RefreshBuff)
end

function UIMainBuffList:OnRemoveListener()
  self:RemoveUIListener(EventId.LuaEntryEffectRefreshStatus, self.RefreshBuff)
  self:RemoveUIListener(EventId.SetMainWorldPointId, self.RefreshBuff)
  self:RemoveUIListener(EventId.WarFlagAdd, self.RefreshBuff)
  self:RemoveUIListener(EventId.MyBaseTemperatureConfigChange, self.RefreshBuff)
  self:RemoveUIListener(EventId.MyBasePhaseChange, self.RefreshBuff)
  self:RemoveUIListener(EventId.SelfOfficialPositionChange, self.RefreshBuff)
  self:RemoveUIListener(EventId.SelfCollectLimitLevelChange, self.RefreshBuff)
  self:RemoveUIListener(EventId.SandWormWrapRefresh, self.RefreshBuff)
  self:RemoveUIListener(EventId.JungleTrialWrapRefresh, self.RefreshBuff)
  self:RemoveUIListener(EventId.RefreshMyWallBar, self.RefreshBuff)
  self:RemoveUIListener(EventId.BloodyNightActivityRefresh, self.RefreshBuff)
  self:RemoveUIListener(EventId.MyPositionRefresh, self.RefreshBuff)
  base.OnRemoveListener(self)
end

function UIMainBuffList:RefreshBuff()
  if self.delayTimeRefreshBuff == nil then
    local pThis = self
    self.delayTimeRefreshBuff = TimerManager:GetInstance():DelayInvoke(function()
      pThis.delayTimeRefreshBuff = nil
      CommonUtil.ProtectCall(function()
        pThis:DelayRefreshBuff()
      end)
    end, 0.1)
  end
end

function UIMainBuffList:DelayRefreshBuff()
  local shows = self:PrepareBuffData()
  local lastBuffDataShown = self.lastBuffDataShown
  if lastBuffDataShown ~= nil and shows ~= nil and #lastBuffDataShown == #shows then
    local is_same = true
    for index, new_data in ipairs(shows) do
      local old = lastBuffDataShown[index]
      if old == nil or old.id ~= new_data.id or old.icon ~= new_data.icon or old.name ~= new_data.name or old.desc ~= new_data.desc or old.order ~= new_data.order or old.endTime ~= new_data.endTime or old.totalTime ~= new_data.totalTime or old.effectScale ~= new_data.effectScale or old.showEffectPath ~= new_data.showEffectPath then
        is_same = false
        break
      end
    end
    if is_same then
      self:SetRootActive(0 < #lastBuffDataShown)
      self.gridLayoutGroupBuffList:SetActive(0 < #lastBuffDataShown)
      return
    end
  end
  self:DestroyBuff()
  local buff_content_item_max = toInt(self.buff_content_item_max)
  local count = 0
  self.lastBuffDataShown = shows
  self.buffIcons = {}
  if shows ~= nil then
    if buff_content_item_max < 1 then
      buff_content_item_max = 8
    end
    count = #shows
    if buff_content_item_max < count then
      count = buff_content_item_max
    end
    for i = 1, count do
      local theIconPath
      local hideFrame = false
      local playerData
      if i >= buff_content_item_max then
        hideFrame = true
        theIconPath = "Assets/Main/Sprites/UI/LWCommon/Sprite/zyf_zhujiemian_buff_button.png"
      else
        hideFrame = false
        if shows[i].meta then
          theIconPath = shows[i].meta.icon
        elseif shows[i].icon then
          theIconPath = shows[i].icon
        end
      end
      if shows[i].playerData then
        playerData = shows[i].playerData
      end
      self.buffIcons[i] = self:GameObjectInstantiateAsync(UIAssets.BuffIcon, function(request)
        if request.isError then
          return
        end
        local go = request.gameObject
        go.gameObject:SetActive(true)
        go.transform:SetParent(self.gridLayoutGroupBuffList.transform)
        go.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
        go.name = "BuffIcon" .. i
        local cell = self.gridLayoutGroupBuffList:AddComponent(BuffIcon, go.name)
        cell:SetIcon(theIconPath)
        cell:HideFrame(hideFrame)
        if not string.IsNullOrEmpty(shows[i].showEffectPath) then
          cell:ShowBuffEffectView(shows[i].showEffectPath, shows[i].effectScale)
        end
        if playerData then
          cell:SetPlayerData(playerData, 0.275)
        end
      end)
    end
  end
  local row = 0
  if count <= 0 then
    self:SetRootActive(false)
    self.gridLayoutGroupBuffList:SetActive(false)
  else
    row = 1
    self:SetRootActive(true)
    self.gridLayoutGroupBuffList:SetActive(true)
  end
  EventManager:GetInstance():Broadcast(EventId.MSG_ITME_STATUS_TIME_CHANGE)
end

function UIMainBuffList:DestroyBuff()
  self.lastBuffDataShown = nil
  self.gridLayoutGroupBuffList:RemoveComponents(BuffIcon)
  if self.buffIcons ~= nil then
    for k, v in pairs(self.buffIcons) do
      if v ~= nil then
        self:GameObjectDestroy(v)
      end
    end
    self.buffIcons = {}
  end
end

function UIMainBuffList:PrepareBuffData()
  local buff_content_item_max = toInt(self.buff_content_item_max)
  if buff_content_item_max < 1 then
    buff_content_item_max = 8
  end
  local buffDatas = DataCenter.StatusManager:GetAllBuffData(true)
  if buff_content_item_max <= #buffDatas then
    return buffDatas
  end
  local wallBarBuffData = DataCenter.DefenceWallDataManager:GetWallBarBuffData()
  if wallBarBuffData then
    table.insert(buffDatas, wallBarBuffData)
    if buff_content_item_max <= #buffDatas then
      return buffDatas
    end
  end
  local flags = DataCenter.WarFlagDataManager:GetAllFlagAffectMe()
  buffDatas = table.mergeArray(buffDatas, flags)
  if buff_content_item_max <= #buffDatas then
    return buffDatas
  end
  local temperatureBuffs = DataCenter.TemperatureManager:GetMyTemperatureBuff()
  table.extendArray(buffDatas, temperatureBuffs)
  if buff_content_item_max <= #buffDatas then
    return buffDatas
  end
  local officialPositionBuffViewDataList = DataCenter.BuildingOfficialManager:GetOfficialPositionBuffViewData()
  if 0 < #officialPositionBuffViewDataList then
    table.extendArray(officialPositionBuffViewDataList, buffDatas)
    buffDatas = officialPositionBuffViewDataList
    if buff_content_item_max <= #buffDatas then
      return buffDatas
    end
  end
  local inSeason = SeasonUtil.IsInSeason()
  if inSeason then
    local theSeasonType = SeasonUtil.GetSeasonType()
    local numResistance = SeasonUtil.GetSelfSeasonResistanceValue()
    if 0 < numResistance then
      local buffViewData = {}
      buffViewData.name = Localization:GetString("alliance_science_name011")
      buffViewData.icon = "Assets/Main/Sprites/UI/LWCommon/Sprite/zyf_saijikaifa_dangqiankangxing_icon.png"
      buffViewData.desc = Localization:GetString("season_trends_info002")
      table.insert(buffDatas, buffViewData)
    end
    if buff_content_item_max <= #buffDatas then
      return buffDatas
    end
    if theSeasonType == SeasonMapType.Mummy then
      local v94081 = LuaEntry.Effect:GetGameEffect(94081)
      if v94081 ~= 0 then
        local effectLine = LocalController:instance():getLine(TableName.LW_Effect_Number, 94081)
        if effectLine then
          local buffViewData = {}
          buffViewData.name = Localization:GetString(effectLine.name)
          buffViewData.icon = "Assets/Main/SeasonRes/Shared/Sprites/UIMummy/ljq_saijis3_huanxing_buff.png"
          buffViewData.desc = Localization:GetString(effectLine.desc)
          table.insert(buffDatas, buffViewData)
        end
      end
      if DataCenter.SandWormHuntDataManager:IsMyBaseWormWrap() then
        table.insert(buffDatas, {
          icon = "Assets/Main/SeasonRes/S3/Sprites/Sandworm/mjc_S3_sc_zhuye_icon.png"
        })
      end
    elseif theSeasonType == SeasonMapType.Darkness then
      local stateMeta = LocalController:instance():getLine(TableName.StatusTab, 704201)
      if stateMeta then
        local buffViewData = {}
        buffViewData.icon = stateMeta.icon
        buffViewData.name = Localization:GetString(stateMeta.name)
        buffViewData.desc = Localization:GetString(stateMeta.description)
        table.insert(buffDatas, buffViewData)
      end
    elseif theSeasonType == SeasonMapType.NineNation then
      local subType = SeasonUtil.GetSeasonSubdivisionType()
      if subType == SeasonMapType.NineNationRainforest and DataCenter.JungleTrialDataManager:IsMyBaseSwallow() then
        table.insert(buffDatas, {
          icon = "Assets/Main/SeasonRes/S6/Sprites/JungleTrial/zxl_s6shirenhua_buff.png"
        })
      end
    end
    if buff_content_item_max <= #buffDatas then
      return buffDatas
    end
    local effectList = DataCenter.SeasonFarmerManager:GetCityAttachmentEffectInfo()
    if effectList and effectList.effect then
      for effectId, effectValue in pairs(effectList.effect) do
        local effectValueExist = 0
        if effectValueExist == 0 then
          local builders_alliance_buff = GetTableData(TableName.LW_Effect_Number, effectId, "builders_alliance_buff")
          if builders_alliance_buff then
            local name, desc, iconPath = string.match(builders_alliance_buff, "([^;|]+)[;|]([^;|]+)[;|]([^;|]+)")
            if name and desc and iconPath then
              local buffViewData = {}
              buffViewData.icon = iconPath
              buffViewData.name = Localization:GetString(name)
              buffViewData.desc = Localization:GetString(desc)
              table.insert(buffDatas, buffViewData)
            end
          end
        end
      end
    end
    if buff_content_item_max <= #buffDatas then
      return buffDatas
    end
    local sort_buff = {}
    if effectList and effectList.state then
      for _, stateId in pairs(effectList.state) do
        local stateMeta = LocalController:instance():getLine(TableName.StatusTab, stateId)
        if stateMeta then
          local buffViewData = {}
          buffViewData.order = toInt(stateMeta.order) + 1
          buffViewData.icon = stateMeta.icon
          buffViewData.name = Localization:GetString(stateMeta.name)
          buffViewData.desc = Localization:GetString(stateMeta.description)
          table.insert(sort_buff, buffViewData)
        end
      end
      table.sort(sort_buff, function(a, b)
        return a.order > b.order
      end)
    end
    table.extendArray(buffDatas, sort_buff)
    if buff_content_item_max <= #buffDatas then
      return buffDatas
    end
    sort_buff = {}
    local GlobalState = DataCenter.SeasonDataManager:GetGlobalStatus()
    if GlobalState then
      for k, v in pairs(GlobalState) do
        if v and v.effects and v.reason and v.stateId then
          local stateMeta = LocalController:instance():getLine(TableName.StatusTab, v.stateId)
          if stateMeta then
            local buffViewData = {}
            buffViewData.order = toInt(stateMeta.order) + 1
            buffViewData.icon = stateMeta.icon
            buffViewData.name = Localization:GetString(stateMeta.name)
            buffViewData.desc = Localization:GetString(stateMeta.description)
            table.insert(sort_buff, buffViewData)
          end
        end
      end
      table.sort(sort_buff, function(a, b)
        return a.order > b.order
      end)
    end
    table.extendArray(buffDatas, sort_buff)
    if buff_content_item_max <= #buffDatas then
      return buffDatas
    end
    local sunrise = DataCenter.BloodyNightDataManager:IsSunrise()
    if not sunrise then
      sort_buff = {}
      local lightBuffDict = DataCenter.SeasonLightDataManager:GetAllLightBuff()
      if lightBuffDict then
        for stateId, lightStatus in pairs(lightBuffDict) do
          local stateMeta = LocalController:instance():getLine(TableName.StatusTab, stateId)
          if stateMeta and (0 < toInt(stateMeta.type3) or stateId == 704101) then
            local buffViewData = {}
            buffViewData.order = toInt(stateMeta.order) + 1
            buffViewData.icon = stateMeta.icon
            buffViewData.name = Localization:GetString(stateMeta.name)
            buffViewData.desc = Localization:GetString(stateMeta.description)
            if lightStatus and lightStatus.lightPlayer then
              buffViewData.playerData = lightStatus.lightPlayer
            end
            table.insert(sort_buff, buffViewData)
          end
        end
        table.sort(sort_buff, function(a, b)
          return a.order > b.order
        end)
      end
      table.extendArray(buffDatas, sort_buff)
      if buff_content_item_max <= #buffDatas then
        return buffDatas
      end
    end
  end
  local sort_buff = {}
  local GlobalState = DataCenter.ServerStatusManager:GetGlobalStatus()
  if GlobalState then
    for k, v in pairs(GlobalState) do
      if v and v.effects and v.reason and v.stateId then
        local stateMeta = LocalController:instance():getLine(TableName.StatusTab, v.stateId)
        if stateMeta then
          local buffViewData = {}
          buffViewData.order = toInt(stateMeta.order) + 1
          buffViewData.icon = stateMeta.icon
          buffViewData.name = Localization:GetString(stateMeta.name)
          buffViewData.desc = Localization:GetString(stateMeta.description)
          table.insert(sort_buff, buffViewData)
        end
      end
    end
    table.sort(sort_buff, function(a, b)
      return a.order > b.order
    end)
  end
  table.extendArray(buffDatas, sort_buff)
  if buff_content_item_max <= #buffDatas then
    return buffDatas
  end
  sort_buff = {}
  local campScienceBuff = DataCenter.CampScienceDataManager:GetAllCampScienceBuff()
  if campScienceBuff and 0 < table.count(campScienceBuff) then
    for k, v in pairs(campScienceBuff) do
      local buffViewData = {}
      local config = v.config
      buffViewData.order = toInt(config.type) + 1
      buffViewData.icon = config.icon
      buffViewData.name = CS.GameEntry.Localization:GetString(config.name, config.name_cfg)
      local strArray = string.split_ss_array(config.description_cfg, "|")
      buffViewData.desc = CS.GameEntry.Localization:GetString(v.config.description, table.unpack(strArray))
      table.insert(sort_buff, buffViewData)
    end
    table.sort(sort_buff, function(a, b)
      return a.order > b.order
    end)
    for _, v in ipairs(sort_buff) do
      table.insert(buffDatas, v)
      if buff_content_item_max <= #buffDatas then
        return buffDatas
      end
    end
  end
  local collectLimitBuffData = DataCenter.CollectRewardDataManager:GetNowCollectLimitBuffData()
  if collectLimitBuffData ~= nil then
    table.insert(buffDatas, collectLimitBuffData)
  end
  local tradeBuff = DataCenter.SeasonTradeDataManager:GetShowBuffData()
  if tradeBuff ~= nil then
    table.insert(buffDatas, tradeBuff)
  end
  return buffDatas
end

function UIMainBuffList:SetListVisible(bool)
  self.gridLayoutGroupBuffList:SetActive(bool)
end

function UIMainBuffList:GetIconWorldPos()
  return self.gridLayoutGroupBuffList.transform.position
end

function UIMainBuffList:SetRootActive(bool)
  return self.compBuffListRoot:SetActive(bool)
end

return UIMainBuffList
