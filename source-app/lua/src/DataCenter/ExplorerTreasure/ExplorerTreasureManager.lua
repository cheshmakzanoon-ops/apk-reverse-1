local ExplorerTreasureManager = BaseClass("ExplorerTreasureManager")
local ResourceManager = CS.GameEntry.Resource
local Setting = CS.GameEntry.Setting
local ActDispatchTreasureRewardItemTemplate = require("DataCenter.ActivityListData.ActDispatchTreasureRewardItemTemplate")
local EXPLORER_MODEL_PATH = "Assets/Main/Prefabs/DispatchTask/ExplorerTreasure/A_Hero_feihongqibing02.prefab"
local EXPLORER_MODEL_TARGET_POS = Vector3.New(60, 0, 62)
local EXPLORER_PLOT_ID = 8162

function ExplorerTreasureManager:__init()
end

function ExplorerTreasureManager:OnEnterGame()
  self:AddListener()
end

function ExplorerTreasureManager:__delete()
  self:RemoveListener()
  self:OnReleaseCity()
end

function ExplorerTreasureManager:AddListener()
  if self.inited then
    return
  end
  self.inited = true
  self.onEnterCityBindFunc = BindCallback(self, self.OnEnterCity)
  self.onReleaseCityBindFunc = BindCallback(self, self.OnReleaseCity)
  self.onRefreshBubbleBindFunc = BindCallback(self, self.RefreshBubble)
  EventManager:GetInstance():AddListener(EventId.GF_enter_city, self.onEnterCityBindFunc)
  EventManager:GetInstance():AddListener(EventId.BeforeReleaseCity, self.onReleaseCityBindFunc)
  EventManager:GetInstance():AddListener(EventId.RefreshItems, self.onRefreshBubbleBindFunc)
  if not self:IsAutoShownDispatchTask() then
    self.onPlotFinishBindFunc = BindCallback(self, self.onPlotFinish)
    EventManager:GetInstance():AddListener(EventId.GF_plot_group_done, self.onPlotFinishBindFunc)
  end
end

function ExplorerTreasureManager:RemoveListener()
  if not self.inited then
    return
  end
  self.inited = false
  EventManager:GetInstance():RemoveListener(EventId.GF_enter_city, self.onEnterCityBindFunc)
  EventManager:GetInstance():RemoveListener(EventId.BeforeReleaseCity, self.onReleaseCityBindFunc)
  EventManager:GetInstance():RemoveListener(EventId.RefreshItems, self.onRefreshBubbleBindFunc)
  self.onEnterCityBindFunc = nil
  self.onReleaseCityBindFunc = nil
  self.onRefreshBubbleBindFunc = nil
  if self.onPlotFinishBindFunc then
    EventManager:GetInstance():RemoveListener(EventId.GF_plot_group_done, self.onPlotFinishBindFunc)
    self.onPlotFinishBindFunc = nil
  end
end

function ExplorerTreasureManager:OnEnterCity()
  local tBuildData = DataCenter.BuildManager:GetFunbuildByItemID(BuildingTypes.LW_BUILD_DISPATCH_TASK)
  if not tBuildData or tBuildData.level < 1 then
    return
  end
  if not DataCenter.ActDispatchTaskDataManager:CheckUnlock() then
    return
  end
  if not self:IsOpen() then
    return
  end
  if self.request and IsNotNull(self.explorerTrans) then
    return
  end
  self.request = ResourceManager:InstantiateAsync(EXPLORER_MODEL_PATH)
  self.request:completed("+", function(req)
    if req.isError then
      return
    end
    local go = req.gameObject
    local transform = go.transform
    self.explorerTrans = transform
    self.explorerTrans:SetParent(nil)
    self.explorerTrans:Set_localScale(1, 1, 1)
    go.name = "ExplorerTreasureModel"
    self.keyIconTrans = transform:Find("TipRoot/Go/Icon/key")
    self.boxIconTrans = transform:Find("TipRoot/Go/Icon/box")
    self.emojiIconTrans = transform:Find("TipRoot/Go/Icon/emoji")
    self.bubbleSimpleAnim = transform:Find("TipRoot/Go"):GetComponent(typeof(CS.SimpleAnimation))
    self.modelSkinTrans = transform:Find("A_Hero_feihongqibing_skin")
    self.modelSkinTrans:Set_localRotation(0, 0, 0)
    self.explorerAnim = self.modelSkinTrans:GetComponent(typeof(CS.SimpleAnimation))
    local modelTrigger = go:GetComponent(typeof(CS.TouchObjectEventTrigger))
    if modelTrigger then
      function modelTrigger.onPointerClick()
        self:OnTriggerClick()
      end
    end
    local bubbleTrigger = transform:Find("TipRoot/Trigger"):GetComponent(typeof(CS.TouchObjectEventTrigger))
    if bubbleTrigger then
      function bubbleTrigger.onPointerClick()
        self:OnBubbleClick()
      end
    end
    local bNeedGuide = self.bNeedGuide
    if bNeedGuide then
      self:DoGuide()
    else
      self:SetTargetPos()
      self:RefreshBubble()
    end
  end)
end

function ExplorerTreasureManager:OnReleaseCity()
  if self.request then
    self.request:Destroy()
    self.request = nil
  end
  if self.sequence then
    self.sequence:Kill()
    self.sequence = nil
  end
  self.explorerTrans = nil
  self.keyIconTrans = nil
  self.boxIconTrans = nil
  self.boxIconImg = nil
  self.explorerAnim = nil
  self.bubbleSimpleAnim = nil
  self.modelSkinTrans = nil
  self.emojiIconTrans = nil
end

function ExplorerTreasureManager:GotoExplorerModel()
  local buildData = DataCenter.BuildManager:GetFunbuildByItemID(BuildingTypes.LW_BUILD_DISPATCH_TASK)
  if buildData ~= nil and self:IsOpen() then
    SceneUtils.ChangeToCity(function()
      local worldPos = buildData:GetCenterVec()
      GoToUtil.GotoCityPos(worldPos, CS.SceneManager.World.InitZoom, LookAtFocusTime, function()
        local param = {
          position = CS.CSUtils.WorldPositionToUISpacePosition(EXPLORER_MODEL_TARGET_POS),
          positionType = PositionType.Screen,
          useLiteAnim = true,
          arrowType = ArrowType.CityNpc
        }
        DataCenter.ArrowManager:ShowArrow(param)
      end)
    end)
  end
end

function ExplorerTreasureManager:onPlotFinish(id)
  if id == EXPLORER_PLOT_ID then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIDispatchTaskMain, {
      anim = true,
      UIMainAnim = UIMainAnimType.AllHide
    })
    Setting:SetPrivateBool("IsAutoShownDispatchTask", true)
  end
end

function ExplorerTreasureManager:ShowGuide()
  if self:IsGuideShown() then
    return
  end
  self.bNeedGuide = true
  if self.request and IsNotNull(self.explorerTrans) then
    self.modelSkinTrans:Set_localRotation(0, 0, 0)
    self:DoGuide()
  end
end

function ExplorerTreasureManager:DoGuide()
  self.emojiIconTrans.gameObject:SetActive(true)
  GoToUtil.GotoCityByBuildId(BuildingTypes.LW_BUILD_DISPATCH_TASK)
  self:DoMove()
  self.bNeedGuide = false
end

function ExplorerTreasureManager:SetTargetPos()
  if IsNotNull(self.explorerTrans) then
    self.explorerTrans:Set_localPosition(EXPLORER_MODEL_TARGET_POS.x, EXPLORER_MODEL_TARGET_POS.y, EXPLORER_MODEL_TARGET_POS.z)
    self.modelSkinTrans:Set_localRotation(0, 180, 0)
  end
end

function ExplorerTreasureManager:RefreshBubble()
  if IsNull(self.boxIconTrans) or IsNull(self.explorerAnim) then
    return
  end
  if not SceneUtils.GetIsInCity() then
    return
  end
  if not self:IsPlotShown() then
    self.emojiIconTrans.gameObject:SetActive(true)
    return
  else
    self.emojiIconTrans.gameObject:SetActive(false)
  end
  local nCurItemNum = self:GetTreasureHaveItemNum()
  local nOpenNeedNum = self:GetTreasureOpenNeedItemNum()
  self.boxIconTrans.gameObject:SetActive(nCurItemNum >= nOpenNeedNum)
  if nCurItemNum >= nOpenNeedNum then
    self.bubbleSimpleAnim:Play("Default")
    self:PlayExplorerAnim("reward")
  else
    self.bubbleSimpleAnim:Stop("Default")
    self:PlayExplorerAnim("Default")
  end
end

function ExplorerTreasureManager:OnTriggerClick()
  self:ShowExplorerTreasurePanel()
end

function ExplorerTreasureManager:OnBubbleClick()
  self:ShowExplorerTreasurePanel()
end

function ExplorerTreasureManager:ShowExplorerTreasurePanel()
  if not self:IsPlotShown() then
    EventManager:GetInstance():Broadcast(EventId.PlayPlotGroup, {plotGroupId = EXPLORER_PLOT_ID, hideMainUI = true})
    Setting:SetPrivateBool("ExplorerTreasurePlotShown", true)
    self.emojiIconTrans.gameObject:SetActive(false)
    return
  end
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIExplorerTreasure)
end

function ExplorerTreasureManager:DoMove()
  self:PlayExplorerAnim("walk")
  self.explorerTrans:Set_localPosition(60, 0, 47)
  self.sequence = CS.DG.Tweening.DOTween.Sequence()
  self.sequence:Append(self.explorerTrans:DOLocalMove(EXPLORER_MODEL_TARGET_POS, 6))
  self.sequence:OnComplete(function()
    self.sequence = nil
    self:OnArriveTargetPos()
  end)
end

function ExplorerTreasureManager:OnArriveTargetPos()
  self:PlayExplorerAnim("Default")
  self.modelSkinTrans:Set_localRotation(0, 180, 0)
  if self:IsPlotShown() then
    return
  end
  local param = {
    position = CS.CSUtils.WorldPositionToUISpacePosition(EXPLORER_MODEL_TARGET_POS),
    positionType = PositionType.Screen,
    useLiteAnim = true,
    arrowType = ArrowType.CityNpc
  }
  DataCenter.ArrowManager:ShowArrow(param)
end

function ExplorerTreasureManager:IsAutoShownDispatchTask()
  return Setting:GetPrivateBool("IsAutoShownDispatchTask", false)
end

function ExplorerTreasureManager:IsPlotShown()
  return Setting:GetPrivateBool("ExplorerTreasurePlotShown", false)
end

function ExplorerTreasureManager:IsGuideShown()
  return Setting:GetPrivateBool("ExplorerTreasureGuideShown", false)
end

function ExplorerTreasureManager:IsIntroduceShown()
  return Setting:GetPrivateBool("ExplorerTreasureIntroduceShown", false)
end

function ExplorerTreasureManager:PlayExplorerAnim(anim)
  if self.explorerAnim then
    self.explorerAnim:Play(anim)
  end
end

function ExplorerTreasureManager:GetTreasureOpenNeedItemNum()
  if not self.treasureNeedNum then
    self.treasureNeedNum = LuaEntry.DataConfig:TryGetNum("explorer_treasure_key", "k1")
  end
  return self.treasureNeedNum
end

function ExplorerTreasureManager:GetTreasureHaveItemNum()
  local nId = self:GetTreasureItemId()
  local tItemInfo = DataCenter.ItemData:GetItemById(nId)
  if not tItemInfo then
    return 0
  end
  return tItemInfo.count
end

function ExplorerTreasureManager:GetTreasureItemId()
  if not self.nTreasureItemId then
    self.nTreasureItemId = LuaEntry.DataConfig:TryGetNum("explorer_treasure_key", "k2")
  end
  return self.nTreasureItemId
end

function ExplorerTreasureManager:GetTreasureItemCfg()
  return DataCenter.ItemTemplateManager:GetItemTemplate(self:GetTreasureItemId())
end

function ExplorerTreasureManager:GetTreasureItemBoxId()
  if not self.nTreasureItemBoxId then
    self.nTreasureItemBoxId = LuaEntry.DataConfig:TryGetNum("explorer_treasure_key_box", "k1")
  end
  return self.nTreasureItemBoxId
end

function ExplorerTreasureManager:IsOpen()
  local tDataList = self:GetExplorerTreasureActivityData()
  if tDataList and tDataList[1] and DataCenter.ActivityListDataManager:CheckIsSend(tDataList[1]) then
    return true
  end
  return false
end

function ExplorerTreasureManager:GetExplorerTreasureActivityData()
  return DataCenter.ActivityListDataManager:GetActivityDataByType(EnumActivity.ExploreTreasure.Type)
end

function ExplorerTreasureManager:GetGuaranteedNeedTimes()
  local tBoxCfgList = self:GetTreasureBoxCfg()
  local nCurLevel = DataCenter.BuildManager.MainLv
  for i, v in ipairs(tBoxCfgList) do
    if nCurLevel >= v.nMinLv and nCurLevel <= v.nMaxLv then
      return v.nGuaranteedTimes or 0
    end
  end
  return 0
end

function ExplorerTreasureManager:GetTreasureBoxCfg()
  if self.tTreasureBoxCfg == nil then
    self.tTreasureBoxCfg = {}
    LocalController:instance():visitTable(TableName.ExplorerTreasure, function(id, lineData)
      if lineData.task_level ~= nil and lineData.task_level ~= "" then
        local arr = string.split(lineData.task_level, "-")
        if arr ~= nil and 0 < #arr then
          local tInfo = {}
          tInfo.nTaskId = tonumber(lineData.id)
          tInfo.nMinLv = tonumber(arr[1])
          tInfo.nMaxLv = tonumber(arr[2])
          local sTimes = lineData.reward_protect
          tInfo.nGuaranteedTimes = tonumber(sTimes)
          tInfo.sRewardShow = lineData.reward_show
          tInfo.sBoxShow = lineData.task_probability_show
          table.insert(self.tTreasureBoxCfg, tInfo)
        end
      end
    end)
  end
  return self.tTreasureBoxCfg
end

function ExplorerTreasureManager:GetPreviewReward(nBoxLevel)
  if not self.tPreviewRewardList then
    self.tPreviewRewardList = {}
  end
  local nTaskId = self:GetCurExplorerTreasureTaskIdByMainLevel()
  local tCurLevelReward = self.tPreviewRewardList[nTaskId]
  if not tCurLevelReward then
    self:InitPreviewReward(nTaskId)
  end
  return self.tPreviewRewardList[nTaskId][nBoxLevel]
end

function ExplorerTreasureManager:InitPreviewReward(nTaskID)
  self.tPreviewRewardList[nTaskID] = {}
  local tBoxCfgList = self:GetTreasureBoxCfg()
  local sRewardShow = tBoxCfgList[nTaskID].sRewardShow
  if sRewardShow then
    local arr = string.split(sRewardShow, "|")
    local totalWeight = 0
    for i, v in ipairs(arr) do
      local arr2 = string.split(v, ";")
      if arr2 and #arr2 == 3 then
        totalWeight = totalWeight + tonumber(arr2[2])
      end
    end
    for i, v in ipairs(arr) do
      local arr2 = string.split(v, ";")
      if arr2 and #arr2 == 3 then
        local tInfo = {}
        tInfo.nBoxQuality = tonumber(arr2[1])
        if tInfo.nBoxQuality == ExplorerTreasureRewardQuality.GREEN then
          tInfo.boxIconPath = string.format(LoadPath.UIDispatchTaskSpritePath, "FX_YMJDD_tanxiaanbaoxiang_baoxiang02")
        elseif tInfo.nBoxQuality == ExplorerTreasureRewardQuality.BLUE then
          tInfo.boxIconPath = string.format(LoadPath.UIDispatchTaskSpritePath, "FX_YMJDD_tanxiaanbaoxiang_baoxiang03")
        elseif tInfo.nBoxQuality == ExplorerTreasureRewardQuality.PURPLE then
          tInfo.boxIconPath = string.format(LoadPath.UIDispatchTaskSpritePath, "FX_YMJDD_tanxiaanbaoxiang_baoxiang06")
        elseif tInfo.nBoxQuality == ExplorerTreasureRewardQuality.ORANGE then
          tInfo.boxIconPath = string.format(LoadPath.UIDispatchTaskSpritePath, "FX_YMJDD_tanxiaanbaoxiang_baoxiang04")
        elseif tInfo.nBoxQuality == ExplorerTreasureRewardQuality.RED then
          tInfo.boxIconPath = string.format(LoadPath.UIDispatchTaskSpritePath, "FX_YMJDD_tanxiaanbaoxiang_baoxiang05")
        end
        tInfo.nameStrId = self:GetRewardBoxName(tInfo.nBoxQuality)
        tInfo.prob = tonumber(arr2[2]) / totalWeight
        tInfo.nRewardId = tonumber(arr2[3])
        if not string.IsNullOrEmpty(tInfo.nRewardId) then
          local showCfg = LocalController:instance():getLine(TableName.RewardConfig, tInfo.nRewardId)
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
          tInfo.rewardInfo = {}
          for j = 1, #propTab do
            local rewardItem = ActDispatchTreasureRewardItemTemplate.New()
            rewardItem:InitData(propTab[j] / allProp, itemTab[j], numTab[j])
            table.insert(tInfo.rewardInfo, rewardItem)
          end
        end
        self.tPreviewRewardList[nTaskID][i] = tInfo
      end
    end
  end
end

function ExplorerTreasureManager:GetRewardBoxName(nQuality)
  local sName = ""
  if nQuality == ExplorerTreasureRewardQuality.GREEN then
    sName = "explorer_treasure_reward_03"
  elseif nQuality == ExplorerTreasureRewardQuality.BLUE then
    sName = "explorer_treasure_reward_05"
  elseif nQuality == ExplorerTreasureRewardQuality.PURPLE then
    sName = "explorer_treasure_reward_06"
  elseif nQuality == ExplorerTreasureRewardQuality.ORANGE then
    sName = "explorer_treasure_reward_07"
  elseif nQuality == ExplorerTreasureRewardQuality.RED then
    sName = "explorer_treasure_reward_08"
  end
  return sName
end

function ExplorerTreasureManager:GetRewardBoxInfoByDispatchTask(nTaskQuality)
  if not self.tPreviewBoxList then
    self.tPreviewBoxList = {}
  end
  local nTaskId = self:GetCurExplorerTreasureTaskIdByMainLevel()
  local tCurLevelBox = self.tPreviewBoxList[nTaskId]
  if not tCurLevelBox then
    self:InitPreviewBox(nTaskId)
  end
  return self.tPreviewBoxList[nTaskId][nTaskQuality]
end

function ExplorerTreasureManager:InitPreviewBox(nTaskID)
  self.tPreviewBoxList[nTaskID] = {}
  local tBoxCfgList = self:GetTreasureBoxCfg()
  local sBoxShow = tBoxCfgList[nTaskID].sBoxShow
  if sBoxShow then
    local arr = string.split(sBoxShow, "|")
    for i, v in ipairs(arr) do
      local arr2 = string.split(v, ",")
      local nQuality = tonumber(arr2[1])
      if arr2 and #arr2 == 2 then
        self.tPreviewBoxList[nTaskID][nQuality] = arr2[2]
      end
    end
  end
end

function ExplorerTreasureManager:GetCurExplorerTreasureTaskIdByMainLevel()
  local nCurMainLv = DataCenter.BuildManager.MainLv
  local tBoxCfgList = self:GetTreasureBoxCfg()
  local nTaskId = 1
  for i, v in ipairs(tBoxCfgList) do
    if nCurMainLv >= v.nMinLv and nCurMainLv <= v.nMaxLv then
      nTaskId = v.nTaskId
      break
    end
  end
  return nTaskId
end

function ExplorerTreasureManager:InitData(message)
  if message and message.dispatch_explorer_treasure_guarantee then
    self:UpdateGuaranteedTimes(message.dispatch_explorer_treasure_guarantee)
  else
    self:UpdateGuaranteedTimes(0)
  end
end

function ExplorerTreasureManager:UpdateGuaranteedTimes(times)
  self.nGuaranteedTimes = times
end

function ExplorerTreasureManager:GetGuaranteedTimes()
  return self.nGuaranteedTimes or 0
end

function ExplorerTreasureManager:GetRedPointCount()
  if not self:IsOpen() then
    return 0
  end
  local nHave = self:GetTreasureHaveItemNum()
  local nNeed = self:GetTreasureOpenNeedItemNum()
  local nCanOpenNum = math.floor(nHave / nNeed)
  return nCanOpenNum
end

return ExplorerTreasureManager
