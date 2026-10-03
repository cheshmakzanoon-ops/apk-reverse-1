local base = UIBaseView
local UIDetectCaveExplorationView = BaseClass("UIDetectCaveExplorationView", base)
local Localization = CS.GameEntry.Localization
local CaveExplorationReward = require("UI.UILWRadarCenter.CaveExploration.Component.CaveExplorationReward")
local CaveExplorationEntranceItem = require("UI.UILWRadarCenter.CaveExploration.Component.CaveExplorationEntranceItem")
local mask_path = "mask"
local tipBtn_path = "safeArea/root/area1/title/tipBtn"
local closeBtn_path = "safeArea/root/closeBtn"
local title_path = "safeArea/root/area1/title"
local des_path = "safeArea/root/area1/des"
local loopGridViewItemHolder_path = "safeArea/root/reward/rewardGrid"
local compItemContent_path = "safeArea/root/reward/rewardGrid/Viewport/ItemContent"
local emptyDes_path = "safeArea/root/reward/emptyDes"
local totalDes_path = "safeArea/root/bg/Image/totalDes"
local caveBg_path = "safeArea/caveBg"
local area1_path = "safeArea/root/area1"
local lostArea_path = "safeArea/root/reward/lost"
local nextBg1_path = "safeArea/caveBg_1"
local nextBg2_path = "safeArea/caveBg_1/caveBg_scale"
local animatorCom_path = ""
local normalEffectEntrance_path = "safeArea/Eff_ui_S3_Cavemain_enviroment"
local normalEffectTreasure_path = "safeArea/Eff_ui_S3_Cave_treasure_enviroment"
local normalEffectTrap_path = "safeArea/Eff_ui_S3_Cave_ trap_enviroment"
local bgAni1_path = "safeArea/caveBg_1/caveBg_scale/treasure_chest (1)"
local bgAni_path = "safeArea/box_open/treasure_chest"
local entranceItem_path = {
  "safeArea/root/area1/Entrance/EntranceItem1",
  "safeArea/root/area1/Entrance/EntranceItem2"
}

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  if ComponentIsValid(self.animatorCom) and ComponentIsValid(self.normalEffectEntrance) then
    self:RefreshView()
    self.animatorCom:Play("V_ui_UIDetectCaveExploration_in", 0, 0)
    local tempData = DataCenter.CaveExplorationManager:GetTempData(self.configId)
    if tempData then
      self.normalEffectEntrance:SetActive(tempData.lineType == CaveExplorationNodeType.Entrance)
      self.normalEffectTreasure:SetActive(tempData.lineType == CaveExplorationNodeType.Regular)
      self.normalEffectTrap:SetActive(tempData.lineType == CaveExplorationNodeType.Trap)
    else
      self.normalEffectEntrance:SetActive(false)
    end
  end
end

local function OnDestroy(self)
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function ComponentDefine(self)
  self.mask = self:AddComponent(UIButton, mask_path)
  self.tipBtn = self:AddComponent(UIButton, tipBtn_path)
  self.closeBtn = self:AddComponent(UIButton, closeBtn_path)
  self.title = self:AddComponent(UIText, title_path)
  self.des = self:AddComponent(UIText, des_path)
  self.loopGridViewItemHolder = self:AddComponent(UILoopGridView, loopGridViewItemHolder_path)
  self.compItemContent = self:AddComponent(UIBaseContainer, compItemContent_path)
  self.emptyDes = self:AddComponent(UIBaseContainer, emptyDes_path)
  self.totalDes = self:AddComponent(UIText, totalDes_path)
  self.caveBg = self:AddComponent(UIRawImage, caveBg_path)
  self.area1 = self:AddComponent(UIBaseContainer, area1_path)
  self.lostArea = self:AddComponent(UIBaseContainer, lostArea_path)
  self.nextBg1 = self:AddComponent(UIRawImage, nextBg1_path)
  self.nextBg2 = self:AddComponent(UIRawImage, nextBg2_path)
  self.animatorCom = self:AddComponent(UIAnimator, animatorCom_path)
  self.normalEffectEntrance = self:AddComponent(UIBaseContainer, normalEffectEntrance_path)
  self.normalEffectTreasure = self:AddComponent(UIBaseContainer, normalEffectTreasure_path)
  self.normalEffectTrap = self:AddComponent(UIBaseContainer, normalEffectTrap_path)
  self.bgAni1 = self:AddComponent(UIImage, bgAni1_path)
  self.bgAni = self:AddComponent(UIImage, bgAni_path)
  self.entranceItem = {
    self:AddComponent(CaveExplorationEntranceItem, entranceItem_path[1]),
    self:AddComponent(CaveExplorationEntranceItem, entranceItem_path[2])
  }
  self.mask:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.closeBtn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.tipBtn:SetOnClick(function()
    self:ClickTipBtn()
  end)
  self.loopGridViewItemHolder:InitGridView(0, function(loopScroll, index, item)
    return self:OnGetItemByRowColumn(loopScroll, index)
  end)
end

local function ComponentDestroy(self)
  if self.compItemContent then
    self.compItemContent:RemoveComponents(CaveExplorationReward)
  end
  if self.loopGridViewItemHolder then
    self.loopGridViewItemHolder:ClearAllItems()
  end
  if self.refreshTimer then
    self.refreshTimer:Stop()
    self.refreshTimer = nil
  end
  if self.finishTimer then
    self.finishTimer:Stop()
    self.finishTimer = nil
  end
  if self.openBoxTimer then
    self.openBoxTimer:Stop()
    self.openBoxTimer = nil
  end
  self.mask = nil
  self.tipBtn = nil
  self.closeBtn = nil
  self.title = nil
  self.des = nil
  self.loopGridViewItemHolder = nil
  self.compItemContent = nil
  self.emptyDes = nil
  self.totalDes = nil
  self.caveBg = nil
  self.area1 = nil
  self.lostArea = nil
  self.nextBg1 = nil
  self.nextBg2 = nil
  self.animatorCom = nil
  self.normalEffectEntrance = nil
  self.normalEffectTreasure = nil
  self.normalEffectTrap = nil
  self.bgAni1 = nil
  self.bgAni = nil
  self.entranceItem = nil
end

local function DataDefine(self)
  self.uuid, self.worldPos = self:GetUserData()
  self.event = nil
  self.configId = nil
end

local function DataDestroy(self)
  self.uuid = nil
  self.worldPos = nil
  self.event = nil
  self.configId = nil
end

function UIDetectCaveExplorationView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.DetectCaveExplorationFinish, self.FinishEvent)
  self:AddUIListener(EventId.UIDetectCaveExploreViewRefresh, self.RefreshViewByEvent)
end

function UIDetectCaveExplorationView:OnRemoveListener()
  self:RemoveUIListener(EventId.DetectCaveExplorationFinish, self.FinishEvent)
  self:RemoveUIListener(EventId.UIDetectCaveExploreViewRefresh, self.RefreshViewByEvent)
  base.OnRemoveListener(self)
end

function UIDetectCaveExplorationView:FinishEvent()
  self.ctrl:CloseSelf()
end

function UIDetectCaveExplorationView:SetupView()
  if not self.configId then
    return
  end
  local tempData = DataCenter.CaveExplorationManager:GetTempData(self.configId)
  self.tempData = tempData
  if tempData then
    self.isReduce = tempData.reward_deduction == -1
    self.lostArea:SetActive(self.isReduce)
    self.caveBg:LoadSprite(tempData.image)
    local titleName = Localization:GetString(tempData.name)
    if GMUtils.GetBool(GMConst.DebugDisplayGameID, false) then
      titleName = string.format("%s[%s]", titleName, self.configId)
    end
    self.title:SetText(titleName)
    self.des:SetLocalText(tempData.description)
    local areaPosY = 720
    local itemCount = 0
    if 0 >= tempData.entranceType1 then
      self.entranceItem[1]:SetActive(false)
    else
      self.entranceItem[1]:SetActive(true)
      itemCount = itemCount + 1
      self.entranceItem[1]:SetData(self.configId, 1, self.uuid, self.worldPos, self.event)
    end
    if 0 >= tempData.entranceType2 then
      self.entranceItem[2]:SetActive(false)
    else
      self.entranceItem[2]:SetActive(true)
      itemCount = itemCount + 1
      self.entranceItem[2]:SetData(self.configId, 2, self.uuid, self.worldPos)
    end
    if itemCount == 1 then
      self.area1:SetAnchoredPositionXY(0, 570)
    else
      self.area1:SetAnchoredPositionXY(0, 720)
    end
  else
    Logger.LogError("UIDetectCaveExplorationView.SetupView failed. Missing template " .. self.configId)
    self.ctrl:CloseSelf()
  end
end

function UIDetectCaveExplorationView:ClickTipBtn()
  local tempData = DataCenter.CaveExplorationManager:GetTempData(self.configId)
  if tempData and not string.IsNullOrEmpty(tempData.help) then
    local param = {}
    param.activityRulesStr = Localization:GetString(tempData.help)
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIActivityDetailPopup, {anim = true}, param)
  end
end

function UIDetectCaveExplorationView:RefreshViewByConfigId(configId)
  self.configId = configId
  self:SetupView()
  self:RefreshRewardView()
end

function UIDetectCaveExplorationView:RefreshView()
  if not self.uuid then
    Logger.LogError("Refresh UIDetectCaveExplorationView exception! uuid is null.")
    self.ctrl:CloseSelf()
    return
  end
  self.event = DataCenter.RadarCenterDataManager:GetDetectEventInfo(self.uuid)
  if self.event == nil then
    Logger.LogError("Refresh UIDetectCaveExplorationView exception! GetDetectEventInfo from mgr failed.")
    self.ctrl:CloseSelf()
    return
  end
  local path = self.event.cavePath
  if not path or #path <= 0 then
    Logger.LogError("Refresh UIDetectCaveExplorationView exception! Path attr exception!")
    self.ctrl:CloseSelf()
    return
  end
  local currentConfigId = path[#path]
  local rewardsCount = 0
  for k, v in ipairs(path) do
    if v ~= currentConfigId then
      local tempData = DataCenter.CaveExplorationManager:GetTempData(v)
      if tempData and 0 < tempData.level_reward then
        rewardsCount = rewardsCount + 1
      end
    end
  end
  self:RefreshViewByConfigId(currentConfigId)
end

function UIDetectCaveExplorationView:RefreshViewByEvent(msg)
  if not msg or not msg.uuid then
    return
  end
  if msg.uuid == self.uuid then
    self:RefreshWithAnimation()
  end
end

function UIDetectCaveExplorationView:Description()
  local sb = StringBuilder.New()
  sb:AppendLine("---\229\164\186\229\174\157\229\165\135\229\133\181\231\149\140\233\157\162\228\191\161\230\129\175---")
  sb:AppendFormatLine("\229\189\147\229\137\141\233\155\183\232\190\190\228\186\139\228\187\182id:%s", self.uuid)
  sb:AppendFormatLine("\229\189\147\229\137\141\233\155\183\232\190\190\228\186\139\228\187\182state:%s", self.event and self.event.state or "NULL")
  sb:AppendFormatLine("\229\189\147\229\137\141\229\129\156\231\149\153\231\154\132\230\173\165\233\170\164:%s(%s)", self.configId, self.tempData and "\226\136\154" or "\195\151")
  if self.tempData then
    if self.tempData.entranceType1 > 0 then
      sb:AppendFormatLine("\231\172\172\228\184\128\228\184\170\233\128\137\233\161\185\239\188\140\231\177\187\229\158\139: %s, param: %s", self.tempData.entranceType1, self.tempData.entranceParam1)
    end
    if 0 < self.tempData.entranceType2 then
      sb:AppendFormatLine("\231\172\172\228\184\128\228\184\170\233\128\137\233\161\185\239\188\140\231\177\187\229\158\139: %s, param: %s", self.tempData.entranceType2, self.tempData.entranceParam2)
    end
  end
  return sb:ToString()
end

function UIDetectCaveExplorationView:RefreshRewardView()
  self.isShowRewardEffect = false
  if self.isReduce then
    if self.event.caveInfo.losePathRewardArr then
      self.isShowRewardEffect = false
      self.rewardListData = self:MergeForShow(self.event.caveInfo.losePathRewardArr)
    else
      self.rewardListData = {}
    end
  elseif self.event.caveInfo.pathRewardArr then
    self.isShowRewardEffect = true
    self.rewardListData = self:MergeForShow(self.event.caveInfo.pathRewardArr)
  else
    self.rewardListData = {}
  end
  local dataCount = #self.rewardListData
  local flag = 0 < dataCount
  local showTotal = false
  if flag and self.event.caveInfo.levelRewardTotalValue then
    showTotal = true
    self.totalDes:SetLocalText("cave_exploration_UI_9", self.event.caveInfo.levelRewardTotalValue)
  end
  self.totalDes:SetActive(showTotal)
  self.emptyDes:SetActive(not flag)
  self.loopGridViewItemHolder:SetActive(flag)
  self.loopGridViewItemHolder:SetListItemCount(dataCount)
  self.loopGridViewItemHolder:RefreshAllShownItem()
end

function UIDetectCaveExplorationView:MergeForShow(data)
  local tmpList = {}
  local dataCount = #data
  if 0 < dataCount then
    for i = 1, dataCount - 1 do
      local commonRewardList = DataCenter.RewardManager:ReturnRewardParamForView(data[i].pathReward)
      if commonRewardList then
        for ii, vv in ipairs(commonRewardList) do
          local key = vv.rewardType .. "_" .. vv.itemId
          local rewardData = tmpList[key]
          if rewardData == nil then
            rewardData = {}
            tmpList[key] = rewardData
            rewardData.rewardType = vv.rewardType
            rewardData.itemId = vv.itemId
            rewardData.count = 0
          end
          rewardData.count = rewardData.count + vv.count
        end
      end
    end
    local commonRewardList = DataCenter.RewardManager:ReturnRewardParamForView(data[dataCount].pathReward)
    if commonRewardList then
      for ii, vv in ipairs(commonRewardList) do
        local key = vv.rewardType .. "_" .. vv.itemId
        local rewardData = tmpList[key]
        if rewardData == nil then
          rewardData = {}
          tmpList[key] = rewardData
          rewardData.rewardType = vv.rewardType
          rewardData.itemId = vv.itemId
          rewardData.count = 0
        end
        rewardData.count = rewardData.count + vv.count
        rewardData.isNew = true
      end
    end
  end
  local result = {}
  local tmpList2 = {}
  for k, v in pairs(tmpList) do
    table.insert(tmpList2, v)
  end
  local tmpCount = #tmpList2
  if tmpCount < 10 and 0 < tmpCount then
    tmpCount = 10
  end
  for i = 1, tmpCount do
    local resultData = {}
    local rewardData = tmpList2[i]
    if rewardData then
      resultData.rewardData = rewardData
    else
      resultData.isEmpty = true
    end
    table.insert(result, resultData)
  end
  return result
end

function UIDetectCaveExplorationView:OnGetItemByRowColumn(loopScroll, index)
  if self.rewardListData ~= nil then
    local count = #self.rewardListData
    index = index + 1
    if index < 1 or count < index then
      return nil
    end
    local item = loopScroll:NewListViewItem("CaveExplorationReward")
    local script = self.compItemContent:GetComponent(item.gameObject.name, CaveExplorationReward)
    if script == nil then
      local name = "item_" .. UIUtil.GetLoopListItemIndex()
      item.gameObject.name = name
      script = self.compItemContent:AddComponent(CaveExplorationReward, name)
    end
    script:SetActive(true)
    local data = self.rewardListData[index]
    script:ReInit(data, self.isShowRewardEffect)
    return item
  end
end

function UIDetectCaveExplorationView:RefreshWithAnimation()
  self.event = DataCenter.RadarCenterDataManager:GetDetectEventInfo(self.uuid)
  if self.event == nil then
    Logger.LogError("Refresh UIDetectCaveExplorationView exception! GetDetectEventInfo from mgr failed.")
    self.ctrl:CloseSelf()
    return
  end
  local path = self.event.cavePath
  if not path or #path <= 0 then
    Logger.LogError("Refresh UIDetectCaveExplorationView exception! Path attr exception!")
    self.ctrl:CloseSelf()
    return
  end
  if self.refreshTimer then
    self.refreshTimer:Stop()
    self.refreshTimer = nil
  end
  if self.finishTimer then
    self.finishTimer:Stop()
    self.finishTimer = nil
  end
  if self.openBoxTimer then
    self.openBoxTimer:Stop()
    self.openBoxTimer = nil
  end
  local pathCount = #path
  if 1 < pathCount then
    local currentConfigId = path[pathCount]
    local preConfigId = path[pathCount - 1]
    local rewardsCount = 0
    for k, v in ipairs(path) do
      if v ~= currentConfigId then
        local tempData = DataCenter.CaveExplorationManager:GetTempData(v)
        if tempData and 0 < tempData.level_reward then
          rewardsCount = rewardsCount + 1
        end
      end
    end
    local tempData = DataCenter.CaveExplorationManager:GetTempData(currentConfigId)
    if tempData then
      self.nextBg1:LoadSprite(tempData.image)
      self.nextBg2:LoadSprite(tempData.image)
    end
    self.lockForAnimation = true
    local ani1 = "V_ui_UIDetectCaveExploration_switch"
    local regularFlag = false
    local lineType = tempData.lineType
    if lineType == CaveExplorationNodeType.Trap then
      ani1 = "V_ui_UIDetectCaveExploration_trap_in"
    elseif lineType == CaveExplorationNodeType.Regular then
      regularFlag = true
    end
    if string.IsNullOrEmpty(tempData.icon1Path) then
    else
      self.bgAni1:LoadSprite(tempData.icon1Path)
      self.bgAni:LoadSprite(tempData.icon1Path)
    end
    local flag, duration = self.animatorCom:PlayAnimationReturnTime(ani1)
    if flag then
      self.refreshTimer = TimerManager:GetInstance():DelayInvoke(function()
        self.configId = currentConfigId
        self:SetupView()
        self.normalEffectEntrance:SetActive(false)
        self.normalEffectTreasure:SetActive(lineType == CaveExplorationNodeType.Regular)
        self.normalEffectTrap:SetActive(lineType == CaveExplorationNodeType.Trap)
        self.bgAni1:SetActive(lineType == CaveExplorationNodeType.Regular)
      end, 0.4)
      self.finishTimer = TimerManager:GetInstance():DelayInvoke(function()
        if regularFlag then
          self.bgAni1:SetActive(false)
          local boxFlag, boxOpen = self.animatorCom:PlayAnimationReturnTime("V_ui_UIDetectCaveExploration_box_open")
          if boxFlag then
            self.openBoxTimer = TimerManager:GetInstance():DelayInvoke(function()
              self:RefreshRewardView()
              self.lockForAnimation = false
            end, boxOpen)
          else
            self:RefreshRewardView()
            self.lockForAnimation = false
          end
        else
          self:RefreshRewardView()
          self.lockForAnimation = false
        end
      end, duration)
    else
      self:RefreshRewardView()
      self.lockForAnimation = false
    end
  else
    Logger.LogError("[RefreshWithAnimation] path count error; pathCount : " .. pathCount)
  end
end

UIDetectCaveExplorationView.OnCreate = OnCreate
UIDetectCaveExplorationView.OnDestroy = OnDestroy
UIDetectCaveExplorationView.OnEnable = OnEnable
UIDetectCaveExplorationView.OnDisable = OnDisable
UIDetectCaveExplorationView.ComponentDefine = ComponentDefine
UIDetectCaveExplorationView.ComponentDestroy = ComponentDestroy
UIDetectCaveExplorationView.DataDefine = DataDefine
UIDetectCaveExplorationView.DataDestroy = DataDestroy
return UIDetectCaveExplorationView
