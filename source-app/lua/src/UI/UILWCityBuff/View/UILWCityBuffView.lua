local UILWCityBuffView = BaseClass("UILWCityBuffView", UIBaseView)
local base = UIBaseView
local CityBuffItemCell = require("UI.UILWCityBuff.Component.CityBuffItemCell")
local Localization = CS.GameEntry.Localization
local empty_tip_path = "ImgBg/emptyTip"

function UILWCityBuffView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:RequestKingdomCountDown()
  self:ReInit()
end

function UILWCityBuffView:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UILWCityBuffView:ComponentDefine()
  self.close_btn = self:AddComponent(UIButton, "ImgBg/UICommonPopUpTitle/CloseBtn")
  self.return_btn = self:AddComponent(UIButton, "ImgBg/UICommonPopUpTitle/panel")
  self.title_txt = self:AddComponent(UIText, "ImgBg/UICommonPopUpTitle/Common_img_title/titleText")
  self.title_txt:SetLocalText("effect_interface_title")
  self.close_btn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.return_btn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.content = self:AddComponent(UIBaseContainer, "ImgBg/ScrollView/Viewport/Content")
  self.empty_tip = self:AddComponent(UITextMeshProUGUIEx, empty_tip_path)
  self.dataList = {}
  self.cells = {}
  self.officialPositionBuffViewData = nil
  self.collectLimitBuffData = nil
end

function UILWCityBuffView:ComponentDestroy()
  self:SetAllCellDestroy()
  self.dataList = nil
  self.cells = nil
  self.content = nil
  self.close_btn = nil
  self.return_btn = nil
  self.title_txt = nil
  self.empty_tip = nil
  self.officialPositionBuffViewData = nil
  self.collectLimitBuffData = nil
end

function UILWCityBuffView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.LuaEntryEffectRefreshStatus, self.ReInit)
  self:AddUIListener(EventId.SelfOfficialPositionChange, self.ReInit)
  self:AddUIListener(EventId.MSG_ITME_STATUS_TIME_CHANGE, self.ReInit)
  self:AddUIListener(EventId.SelfCollectLimitLevelChange, self.ReInit)
  self:AddUIListener(EventId.SandWormWrapRefresh, self.ReInit)
  self:AddUIListener(EventId.JungleTrialWrapRefresh, self.ReInit)
  self:AddUIListener(EventId.RefreshKingdomPositionCountDown, self.RequestKingdomCountDown)
  self:AddUIListener(EventId.RefreshMyWallBar, self.ReInit)
end

function UILWCityBuffView:OnRemoveListener()
  base.OnRemoveListener(self)
  self:RemoveUIListener(EventId.LuaEntryEffectRefreshStatus, self.ReInit)
  self:RemoveUIListener(EventId.SelfOfficialPositionChange, self.ReInit)
  self:RemoveUIListener(EventId.MSG_ITME_STATUS_TIME_CHANGE, self.ReInit)
  self:RemoveUIListener(EventId.SelfCollectLimitLevelChange, self.ReInit)
  self:RemoveUIListener(EventId.SandWormWrapRefresh, self.ReInit)
  self:RemoveUIListener(EventId.JungleTrialWrapRefresh, self.ReInit)
  self:RemoveUIListener(EventId.RefreshKingdomPositionCountDown, self.RequestKingdomCountDown)
  self:RemoveUIListener(EventId.RefreshMyWallBar, self.ReInit)
end

function UILWCityBuffView:ReInit()
  if BattleFieldUtil.InBattleField() then
    self.dataBattleFieldList = BattleFieldUtil.GetEffectListWithInfo()
    self:RefreshBattleFieldCell()
  else
    self.collectLimitBuffData = DataCenter.CollectRewardDataManager:GetNowCollectLimitBuffData()
    self.officialPositionBuffViewData = DataCenter.BuildingOfficialManager:GetOfficialPositionBuffViewData()
    self.dataList = DataCenter.StatusManager:GetAllBuffData(true)
    self.warFlagList = DataCenter.WarFlagDataManager:GetAllFlagAffectMe()
    self:RefreshCityManageCell()
  end
  if table.count(self.cells) == 0 then
    self.empty_tip.gameObject:SetActive(true)
  else
    self.empty_tip.gameObject:SetActive(false)
  end
end

function UILWCityBuffView:RefreshCityManageCell()
  local inSeason = SeasonUtil.IsInSeason(true)
  local seasonType = SeasonUtil.GetSeasonType()
  self:SetAllCellDestroy()
  if self.collectLimitBuffData then
    local cell = self:GameObjectInstantiateAsync(UIAssets.UICityBuffCell, function(request)
      local go = request.gameObject
      if IsNull(go) then
        return
      end
      go.gameObject:SetActive(true)
      go.transform:SetParent(self.content.transform)
      go.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
      go.name = "collectLimitBuff"
      local cell = self.content:AddComponent(CityBuffItemCell, go.name)
      cell:SetCollectLimtFlag(self.collectLimitBuffData, 0.8)
    end)
    table.insert(self.cells, cell)
  end
  if self.officialPositionBuffViewData then
    for i, v in ipairs(self.officialPositionBuffViewData) do
      local cell = self:GameObjectInstantiateAsync(UIAssets.UICityBuffCell, function(request)
        local go = request.gameObject
        if IsNull(go) then
          return
        end
        go.gameObject:SetActive(true)
        go.transform:SetParent(self.content.transform)
        go.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
        go.name = "OfficialPositionBuff" .. i
        local cell = self.content:AddComponent(CityBuffItemCell, go.name)
        cell:SetOfficialPositionBuff(v, 0.8)
      end)
      table.insert(self.cells, cell)
    end
  end
  local list = self.dataList
  if list ~= nil then
    for i = 1, table.length(list) do
      local cell = self:GameObjectInstantiateAsync(UIAssets.UICityBuffCell, function(request)
        local go = request.gameObject
        if IsNull(go) then
          return
        end
        go.gameObject:SetActive(true)
        go.transform:SetParent(self.content.transform)
        go.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
        go.name = "CityBuffItemCell" .. i
        local cell = self.content:AddComponent(CityBuffItemCell, go.name)
        cell:SetStatus(list[i])
      end)
      table.insert(self.cells, cell)
    end
  end
  local wallBarBuffData = DataCenter.DefenceWallDataManager:GetWallBarBuffData()
  if wallBarBuffData then
    local cell = self:GameObjectInstantiateAsync(UIAssets.UICityBuffCell, function(request)
      local go = request.gameObject
      if IsNull(go) then
        return
      end
      go.gameObject:SetActive(true)
      go.transform:SetParent(self.content.transform)
      go.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
      go.name = "wallBar"
      local cell = self.content:AddComponent(CityBuffItemCell, go.name)
      cell:SetWallBar(wallBarBuffData)
    end)
    table.insert(self.cells, cell)
  end
  for i = 1, #self.warFlagList do
    local flagData = self.warFlagList[i]
    local cell = self:GameObjectInstantiateAsync(UIAssets.UICityBuffCell, function(request)
      local go = request.gameObject
      if IsNull(go) then
        return
      end
      go.gameObject:SetActive(true)
      go.transform:SetParent(self.content.transform)
      go.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
      go.name = "WarFlagItemCell" .. flagData.uuid
      local cell = self.content:AddComponent(CityBuffItemCell, go.name)
      cell:SetWarFlag(flagData)
    end)
    table.insert(self.cells, cell)
  end
  local temperatureBuffs = DataCenter.TemperatureManager:GetMyTemperatureBuff()
  for k, tempBuff in ipairs(temperatureBuffs) do
    local cell = self:GameObjectInstantiateAsync(UIAssets.UICityBuffCell, function(request)
      local go = request.gameObject
      if IsNull(go) then
        return
      end
      go.gameObject:SetActive(true)
      go.transform:SetParent(self.content.transform)
      go.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
      go.name = "TemperatureBuff" .. k
      local cell = self.content:AddComponent(CityBuffItemCell, go.name)
      cell:SetTemperatureBuff(tempBuff)
    end)
    table.insert(self.cells, cell)
  end
  if inSeason then
    local numResistance = SeasonUtil.GetSelfSeasonResistanceValue()
    if 0 < numResistance then
      local cell = self:GameObjectInstantiateAsync(UIAssets.UICityBuffCell, function(request)
        local go = request.gameObject
        if IsNull(go) then
          return
        end
        go.gameObject:SetActive(true)
        go.transform:SetParent(self.content.transform)
        go.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
        go.name = "ResistanceBuff"
        local cell = self.content:AddComponent(CityBuffItemCell, go.name)
        cell:SetResistanceBuff()
      end)
      table.insert(self.cells, cell)
    end
  end
  if SeasonUtil.IsMummySoldierFunctionEnabled() then
    if seasonType == SeasonMapType.Darkness then
      local stateMeta = LocalController:instance():getLine(TableName.StatusTab, 704201)
      if stateMeta then
        do
          local cell = self:GameObjectInstantiateAsync(UIAssets.UICityBuffCell, function(request)
            local go = request.gameObject
            if IsNull(go) then
              return
            end
            go.gameObject:SetActive(true)
            go.transform:SetParent(self.content.transform)
            go.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
            go.name = "DarknessMummy"
            local cell = self.content:AddComponent(CityBuffItemCell, go.name)
            cell:SetSeasonFarmerBuff(nil, nil, stateMeta.name, stateMeta.description, stateMeta.icon, stateMeta)
          end)
          table.insert(self.cells, cell)
        end
      end
    else
      local v94081 = LuaEntry.Effect:GetGameEffect(94081)
      if v94081 ~= 0 then
        do
          local effectLine = LocalController:instance():getLine(TableName.LW_Effect_Number, 94081)
          if effectLine then
            do
              local cell = self:GameObjectInstantiateAsync(UIAssets.UICityBuffCell, function(request)
                local go = request.gameObject
                if IsNull(go) then
                  return
                end
                go.gameObject:SetActive(true)
                go.transform:SetParent(self.content.transform)
                go.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
                go.name = "MummyBuff94081"
                local cell = self.content:AddComponent(CityBuffItemCell, go.name)
                local icon = "Assets/Main/SeasonRes/Shared/Sprites/UIMummy/ljq_saijis3_huanxing_buff.png"
                cell:SetSeasonFarmerBuff(94081, v94081, effectLine.name, effectLine.desc, icon)
              end)
              table.insert(self.cells, cell)
            end
          end
        end
      end
    end
    local isMyBaseWormWrap, expireTime, monsterId = DataCenter.SandWormHuntDataManager:IsMyBaseWormWrap()
    if isMyBaseWormWrap then
      local cell = self:GameObjectInstantiateAsync(UIAssets.UICityBuffCell, function(request)
        local go = request.gameObject
        if IsNull(go) then
          return
        end
        go.gameObject:SetActive(true)
        go.transform:SetParent(self.content.transform)
        go.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
        go.name = "SandWormWrapBuff"
        local cell = self.content:AddComponent(CityBuffItemCell, go.name)
        cell:SetSandWormWrapBuff()
      end)
      table.insert(self.cells, cell)
    end
    local isMyBaseSwallow = DataCenter.JungleTrialDataManager:IsMyBaseSwallow()
    if isMyBaseSwallow then
      local cell = self:GameObjectInstantiateAsync(UIAssets.UICityBuffCell, function(request)
        local go = request.gameObject
        if IsNull(go) then
          return
        end
        go.gameObject:SetActive(true)
        go.transform:SetParent(self.content.transform)
        go.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
        go.name = "JungleTrialWrapBuff"
        local cell = self.content:AddComponent(CityBuffItemCell, go.name)
        cell:SetSandWormWrapBuff(true)
      end)
      table.insert(self.cells, cell)
    end
  end
  local effectList = DataCenter.SeasonFarmerManager:GetCityAttachmentEffectInfo()
  if effectList and effectList.effect then
    local attachmentInfo = effectList.newAttachmentEffects
    for effectId, effectValue in pairs(effectList.effect) do
      local builders_alliance_buff = GetTableData(TableName.LW_Effect_Number, effectId, "builders_alliance_buff")
      if builders_alliance_buff then
        local name, desc, iconPath = string.match(builders_alliance_buff, "([^;|]+)[;|]([^;|]+)[;|]([^;|]+)")
        if name and desc and iconPath then
          do
            local cell = self:GameObjectInstantiateAsync(UIAssets.UICityBuffCell, function(request)
              local go = request.gameObject
              if IsNull(go) then
                return
              end
              go.gameObject:SetActive(true)
              go.transform:SetParent(self.content.transform)
              go.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
              go.name = "SeasonFarmerBuff" .. effectId
              local cell = self.content:AddComponent(CityBuffItemCell, go.name)
              cell:SetSeasonFarmerBuff(effectId, effectValue, name, desc, iconPath, nil, attachmentInfo)
            end)
            table.insert(self.cells, cell)
          end
        end
      end
    end
  end
  local tradeBuff = DataCenter.SeasonTradeDataManager:GetShowBuffData()
  if tradeBuff ~= nil then
    local cell = self:GameObjectInstantiateAsync(UIAssets.UICityBuffCell, function(request)
      local go = request.gameObject
      if IsNull(go) then
        return
      end
      go.gameObject:SetActive(true)
      go.transform:SetParent(self.content.transform)
      go.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
      go.name = "tradeBuff" .. tradeBuff.effectId
      local cell = self.content:AddComponent(CityBuffItemCell, go.name)
      cell:SetSeasonFarmerBuff(tradeBuff.effectId, tradeBuff.effectValue, tradeBuff.nameKey, tradeBuff.descKey, tradeBuff.icon)
    end)
    table.insert(self.cells, cell)
  end
  local sort_buff = {}
  if effectList and effectList.state then
    for _, stateId in pairs(effectList.state) do
      local stateMeta = LocalController:instance():getLine(TableName.StatusTab, stateId)
      if stateMeta then
        table.insert(sort_buff, stateMeta)
      end
    end
    table.sort(sort_buff, function(a, b)
      if a.order and b.order then
        return a.order > b.order
      end
      return toInt(a.order) > toInt(b.order)
    end)
    for _, theMeta in ipairs(sort_buff) do
      local stateMeta = theMeta
      local stateId = theMeta.id
      local cell = self:GameObjectInstantiateAsync(UIAssets.UICityBuffCell, function(request)
        local go = request.gameObject
        if IsNull(go) then
          return
        end
        go.gameObject:SetActive(true)
        go.transform:SetParent(self.content.transform)
        go.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
        go.name = "StatusBuff" .. UIUtil.GetLoopListItemIndex()
        local cell = self.content:AddComponent(CityBuffItemCell, go.name)
        local layer = LuaEntry.Effect:GetStatusLayer(stateId)
        if 0 < layer then
          local description = stateMeta.description
          local num = string.match(description, "([0-9]+)")
          local strNew, count = string.gsub(description, "([0-9]+)", toInt(num) * layer)
          if count == 1 then
            cell:SetSeasonFarmerBuff(nil, nil, stateMeta.name, strNew, stateMeta.icon, stateMeta)
          else
            cell:SetSeasonFarmerBuff(nil, nil, stateMeta.name, description, stateMeta.icon, stateMeta)
          end
        else
          cell:SetSeasonFarmerBuff(nil, nil, stateMeta.name, stateMeta.description, stateMeta.icon, stateMeta)
        end
      end)
      table.insert(self.cells, cell)
    end
  end
  sort_buff = {}
  local GlobalState = DataCenter.SeasonDataManager:GetGlobalStatus()
  if GlobalState then
    for k, v in pairs(GlobalState) do
      if v and v.effects and v.reason and v.stateId then
        local stateMeta = LocalController:instance():getLine(TableName.StatusTab, v.stateId)
        if stateMeta then
          table.insert(sort_buff, {meta = stateMeta, data = v})
        end
      end
    end
    table.sort(sort_buff, function(a, b)
      local am, bm = a.meta, b.meta
      if am.order and bm.order then
        return am.order > bm.order
      end
      return toInt(am.order) > toInt(bm.order)
    end)
    for _, entry in ipairs(sort_buff) do
      local stateMeta = entry.meta
      local globalStateItem = entry.data
      local cell = self:GameObjectInstantiateAsync(UIAssets.UICityBuffCell, function(request)
        local go = request.gameObject
        if IsNull(go) then
          return
        end
        go.gameObject:SetActive(true)
        go.transform:SetParent(self.content.transform)
        go.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
        go.name = "GlobalState" .. UIUtil.GetLoopListItemIndex()
        local cell = self.content:AddComponent(CityBuffItemCell, go.name)
        cell:SetSeasonFarmerBuff(nil, nil, stateMeta.name, stateMeta.description, stateMeta.icon, stateMeta)
      end)
      table.insert(self.cells, cell)
    end
  end
  local ServerGlobalState = DataCenter.ServerStatusManager:GetGlobalStatus()
  if ServerGlobalState then
    sort_buff = {}
    local _extendInfo = {}
    for k, v in pairs(ServerGlobalState) do
      if v and v.effects and v.reason and v.stateId then
        local stateMeta = LocalController:instance():getLine(TableName.StatusTab, v.stateId)
        if stateMeta then
          table.insert(sort_buff, stateMeta)
          _extendInfo[v.stateId] = v
        end
      end
    end
    table.sort(sort_buff, function(a, b)
      if a.order and b.order then
        return a.order > b.order
      end
      return toInt(a.order) > toInt(b.order)
    end)
    for _, theMeta in ipairs(sort_buff) do
      local stateMeta = theMeta
      local cell = self:GameObjectInstantiateAsync(UIAssets.UICityBuffCell, function(request)
        local go = request.gameObject
        if IsNull(go) then
          return
        end
        go.gameObject:SetActive(true)
        go.transform:SetParent(self.content.transform)
        go.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
        go.name = "ServerGlobalState" .. UIUtil.GetLoopListItemIndex()
        local cell = self.content:AddComponent(CityBuffItemCell, go.name)
        if DataCenter.LandlordMgr:IsLandlordStatus(stateMeta.id) then
          local description = DataCenter.LandlordMgr:GetStatusDesc(stateMeta.id)
          cell:SetLandlordBuff(stateMeta.name, description, stateMeta.icon, stateMeta)
        else
          cell:SetSeasonFarmerBuff(nil, nil, stateMeta.name, stateMeta.description, stateMeta.icon, stateMeta)
        end
        cell:RefreshSpecialRenderer(_extendInfo[stateMeta.id])
      end)
      table.insert(self.cells, cell)
    end
  end
  if inSeason and seasonType == SeasonMapType.Darkness then
    local sunrise = DataCenter.BloodyNightDataManager:IsSunrise()
    if not sunrise then
      sort_buff = {}
      local lightBuffDict = DataCenter.SeasonLightDataManager:GetAllLightBuff()
      if lightBuffDict then
        for stateId, lightStatus in pairs(lightBuffDict) do
          local stateMeta = LocalController:instance():getLine(TableName.StatusTab, stateId)
          if stateMeta and not string.IsNullOrEmpty(stateMeta.icon) and (toInt(stateMeta.type3) > 0 or stateMeta.id == 704101) then
            lightStatus.meta = stateMeta
            lightStatus.order = toInt(stateMeta.order) + 1
            table.insert(sort_buff, lightStatus)
          end
        end
      end
      table.sort(sort_buff, function(a, b)
        return a.order > b.order
      end)
      for _, theData in ipairs(sort_buff) do
        local lightStatus = theData
        local stateMeta = theData.meta
        local name = stateMeta.name
        local desc = stateMeta.description
        local iconPath = stateMeta.icon
        if name and desc and iconPath then
          do
            local cell = self:GameObjectInstantiateAsync(UIAssets.UICityBuffCell, function(request)
              local go = request.gameObject
              if IsNull(go) then
                return
              end
              go.gameObject:SetActive(true)
              go.transform:SetParent(self.content.transform)
              go.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
              go.name = "LightBuff" .. UIUtil.GetLoopListItemIndex()
              local cell = self.content:AddComponent(CityBuffItemCell, go.name)
              cell:SetSeasonDarknessBuff(stateMeta, lightStatus, name, desc, iconPath, stateMeta)
            end)
            table.insert(self.cells, cell)
          end
        end
      end
    end
  end
  local campScienceBuffData = DataCenter.CampScienceDataManager:GetCampScienceBuffData()
  if campScienceBuffData and 0 < table.count(campScienceBuffData) then
    for i, v in ipairs(campScienceBuffData) do
      local cell = self:GameObjectInstantiateAsync(UIAssets.UICityBuffCell, function(request)
        local go = request.gameObject
        if IsNull(go) then
          return
        end
        go.gameObject:SetActive(true)
        go.transform:SetParent(self.content.transform)
        go.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
        go.name = "campScienceBuffData" .. i
        local cell = self.content:AddComponent(CityBuffItemCell, go.name)
        cell:SetCustomCampScienceInfoClick(v.type)
        cell:SetCampScienceBuff(v, 0.8)
      end)
      table.insert(self.cells, cell)
    end
  end
end

function UILWCityBuffView:RefreshBattleFieldCell()
  self:SetAllCellDestroy()
  if self.dataBattleFieldList ~= nil then
    for i, info in ipairs(self.dataBattleFieldList) do
      local cell = self:GameObjectInstantiateAsync(UIAssets.UICityBuffCell, function(request)
        local go = request.gameObject
        if IsNull(go) then
          return
        end
        go.gameObject:SetActive(true)
        go.transform:SetParent(self.content.transform)
        go.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
        go.name = "BattleFieldBuff" .. i
        local cell = self.content:AddComponent(CityBuffItemCell, go.name)
        cell:SetDragonEffect(info)
      end)
      table.insert(self.cells, cell)
    end
  end
end

function UILWCityBuffView:SetAllCellDestroy()
  self.content:RemoveComponents(CityBuffItemCell)
  if self.cells then
    for k, v in pairs(self.cells) do
      if v ~= nil then
        self:GameObjectDestroy(v)
      end
    end
  end
  self.cells = {}
end

function UILWCityBuffView:RequestKingdomCountDown()
  DataCenter.GovernmentManager:CheckRequestKingdomPositionTimes()
end

return UILWCityBuffView
