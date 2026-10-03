local BuildingDigTreasureManager = BaseClass("BuildingDigTreasureManager", CEventable)
local Localization = CS.GameEntry.Localization
local DiggingMapData = require("DataCenter.DiggingGame.DiggingMapData")

function BuildingDigTreasureManager:SetCurData(tBuildingData)
  self.tCurBuildingData = tBuildingData
  self.tCurMapData = tBuildingData.buildingDigGame.gameInfo
  self:UpdateRewardData(tBuildingData.buildingDigGame.mapBoxList)
end

function BuildingDigTreasureManager:OpenGameWindowByBuildingUuid(uuid)
  local tBuildData = DataCenter.BuildManager:GetBuildingDataByUuid(uuid)
  self:SetCurData(tBuildData)
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIBuildingDigTreasure, {anim = true}, tBuildData)
end

function BuildingDigTreasureManager:InitMapData(tServerMapData)
  local data = DiggingMapData.New()
  data:UpdateData(tServerMapData)
  return data
end

function BuildingDigTreasureManager:ReceiveFreeHammer()
  if not (self.tCurBuildingData and self.tCurMapData) or self.tCurMapData.rewardState ~= DigRewardState.NotBegin then
    return
  end
  local nBuildingUuid = self.tCurBuildingData.uuid
  SFSNetwork.SendMessage(MsgDefines.BuildingDigGameReceiveHammer, nBuildingUuid)
end

function BuildingDigTreasureManager:OnGetFreeHammer(isPlayAnim)
  if self.tCurMapData and self.tCurMapData.rewardState == DigRewardState.NotBegin then
    self.tCurMapData.rewardState = DigRewardState.CanNotGet
  end
  if isPlayAnim then
    EventManager:GetInstance():Broadcast(EventId.OnGetFreeHammer)
  end
end

function BuildingDigTreasureManager:CheckIsShowGuide()
  local bIsShow = Setting:GetPrivateBool(SettingKeys.BUILDING_DIG_TREASURE_GUIDE_SHOWN, false)
  return bIsShow
end

function BuildingDigTreasureManager:OpenBrick(nPos)
  local nCount = self:GetUseItemNum()
  if nCount <= 0 then
    UIUtil.ShowTipsId("treasure_map_hummer_tips_01")
    return false
  end
  if not self.tCurBuildingData or not self.tCurMapData then
    return
  end
  local nBuildingUuid = self.tCurBuildingData.uuid
  SFSNetwork.SendMessage(MsgDefines.BuildingDigGameOpenBlock, nBuildingUuid, nPos)
end

function BuildingDigTreasureManager:OnOpenBrick(t)
  if not self:CheckIsShowGuide() then
    Setting:SetPrivateBool(SettingKeys.BUILDING_DIG_TREASURE_GUIDE_SHOWN, true)
  end
  EventManager:GetInstance():Broadcast(EventId.BuildingDigGameOpen, t)
end

function BuildingDigTreasureManager:GetReward()
  if not self.tCurBuildingData or not self.tCurMapData then
    return
  end
  local nBuildingUuid = self.tCurBuildingData.uuid
  SFSNetwork.SendMessage(MsgDefines.BuildingGetDigGameReward, nBuildingUuid)
end

function BuildingDigTreasureManager:PassAllLevel()
  if not self.tMapBoxList then
    return
  end
  for k, v in ipairs(self.tMapBoxList) do
    v.rewardState = DigRewardState.HaveGot
  end
end

function BuildingDigTreasureManager:GetUseItemId()
  if not self.nUseItemId then
    self.nUseItemId = LuaEntry.DataConfig:TryGetNum("early_digging_hummer", "k1")
  end
  return self.nUseItemId
end

function BuildingDigTreasureManager:GetUseItemNum()
  local nId = self:GetUseItemId()
  local tItemInfo = DataCenter.ItemData:GetItemById(nId)
  if not tItemInfo then
    return 0
  end
  return tItemInfo.count
end

function BuildingDigTreasureManager:GetOpenBlockSingleCost()
  if not self.nOpenSingleCost then
    self.nOpenSingleCost = LuaEntry.DataConfig:TryGetNum("early_digging_hummer", "k2")
  end
  return self.nOpenSingleCost
end

function BuildingDigTreasureManager:ClearAllMapInfo()
  self.tNormalMapData = nil
  self.tTimeLimitMapData = nil
  self.tMapBoxList = nil
end

function BuildingDigTreasureManager:GetCurMapData()
  return self.tCurBuildingData.buildingDigGame.gameInfo
end

function BuildingDigTreasureManager:UpdateRewardData(tRewardList)
  if not tRewardList then
    return
  end
  local bHaveChange = false
  local tNewRewardList = tRewardList
  self:SortRewardData(tNewRewardList)
  if self.tMapBoxList then
    for i = 1, #tNewRewardList do
      if tNewRewardList[i].rewardState ~= self.tMapBoxList[i].rewardState then
        bHaveChange = true
        break
      end
    end
  end
  self.tMapBoxList = tNewRewardList
  if bHaveChange then
    self.tCurBuildingData.buildingDigGame.mapBoxList = tNewRewardList
    EventManager:GetInstance():Broadcast(EventId.DigTreasureUpdateRewardData)
  end
end

function BuildingDigTreasureManager:GetRewardData()
  return self.tMapBoxList
end

function BuildingDigTreasureManager:SortRewardData(tRewardList)
  if not tRewardList then
    return
  end
  table.sort(tRewardList, function(a, b)
    local tCfgA = DataCenter.DiggingDataTemplateManager:GetConfigData(a.mapConfigId)
    local tCfgB = DataCenter.DiggingDataTemplateManager:GetConfigData(b.mapConfigId)
    if tCfgA and tCfgB then
      return tCfgA.layer < tCfgB.layer
    end
  end)
end

function BuildingDigTreasureManager:GetMaxLayer()
  if not self.nMaxLevel then
    self.nMaxLevel = LuaEntry.DataConfig:TryGetNum("Treasure_map_max_level", "k2")
  end
  return self.nMaxLevel
end

function BuildingDigTreasureManager:GetCurLayer()
  local tCurMapData = self:GetCurMapData()
  if not tCurMapData then
    return 0
  end
  local nConfigId = tCurMapData.mapConfigId
  local tCfg = DataCenter.DiggingDataTemplateManager:GetConfigData(nConfigId)
  local nLayer = tCfg and tCfg.layer or 0
  return nLayer
end

function BuildingDigTreasureManager:GetPreviewReward(nIndex)
  if self.tPreviewReward == nil then
    self.tPreviewReward = {}
    for i = 4, 1, -1 do
      local tData = LuaEntry.DataConfig:TryGetStr("Treasure_map_box_show", "k" .. i)
      if tData then
        local tList = string.split(tData, "|")
        local tInfo = {}
        local nLayer = tonumber(tList[1])
        local nRewardId = tonumber(tList[2])
        tInfo.nameStrId = Localization:GetString("treasure_map_reward_show_03", nLayer)
        local showCfg = LocalController:instance():getLine(TableName.RewardConfig, nRewardId)
        local allProp = 0
        local propTab = string.split(showCfg.rate, ";")
        local itemTab = string.split(showCfg.item, ";")
        local numTab = string.split(showCfg.num, ";")
        local index = string.find(showCfg.rate, "|")
        if index ~= nil then
          propTab = string.split(showCfg.rate, "|")
          itemTab = string.split(showCfg.item, "|")
          numTab = string.split(showCfg.num, "|")
          allProp = 100
        else
          for index, value in ipairs(propTab) do
            allProp = allProp + tonumber(value)
          end
        end
        tInfo.boxIconPath = string.format(LoadPath.UIDigTreasureSpritePath, "lyt_S3_xiusaiqi_jidongduiwabao_baoxiang_jin2")
        tInfo.rewardInfo = {}
        for j = 1, #propTab do
          local rewardItem = ActDispatchTreasureRewardItemTemplate.New()
          rewardItem:InitData(propTab[j] / allProp, itemTab[j], numTab[j])
          table.insert(tInfo.rewardInfo, rewardItem)
        end
        table.insert(self.tPreviewReward, tInfo)
      end
    end
  end
  if self.tPreviewReward[nIndex] then
    return self.tPreviewReward[nIndex]
  end
end

return BuildingDigTreasureManager
