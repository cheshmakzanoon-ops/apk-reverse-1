local UIServerBattleLastKingPlayerReward = BaseClass("UIServerBattleLastKingPlayerReward", UIBaseContainer)
local base = UIBaseContainer
local UIRewardTipView = require("UI.UIRewardTip.View.UIRewardTipView")
local UICommonScoreContent = require("UI.UICommonScore.UICommonScoreContent")
local box_content_path = "ScrollView/Viewport/Content"
local box_list_path = "ScrollView/Viewport/Content/boxList"
local score_box_item_path = "ScrollView/Viewport/Content/boxList/scoreBoxItem"
local progress_bg_path = "ScrollView/Viewport/Content/progressBg"
local score_progress_val_path = "ScrollView/Viewport/Content/progressBg/scoreProgressVal"
local points_path = "ScrollView/Viewport/Content/progressBg/Points"
local point_path = "ScrollView/Viewport/Content/progressBg/Points/Point"
local gold_num_path = "ScoreInfo/ImageGold/goldNum"
local score_info_path = "ScoreInfo"

function UIServerBattleLastKingPlayerReward:OnCreate()
  base.OnCreate(self)
  self.scoreContent = self:AddComponent(UIBaseContainer, "ScrollView")
  self.box_content = self:AddComponent(UIBaseContainer, box_content_path)
  self.box_list = self:AddComponent(UIBaseContainer, box_list_path)
  self.score_box_item = self:AddComponent(UIImage, score_box_item_path)
  self.progress_bg = self:AddComponent(UIImage, progress_bg_path)
  self.scoreProgressVal = self:AddComponent(UIImage, score_progress_val_path)
  self.points = self:AddComponent(UIBaseContainer, points_path)
  self.point = self:AddComponent(UIImage, point_path)
  self.gold_num = self:AddComponent(UIText, gold_num_path)
  self.score_info = self:AddComponent(UIBaseContainer, score_info_path)
  self.title = self:AddComponent(UIText, "title")
  self.theBoxItem = self.score_box_item.gameObject
  self.theBoxItem:GameObjectCreatePool()
  self.theBoxItemPoint = self.point.gameObject
  self.theBoxItemPoint:GameObjectCreatePool()
  self.scoreBoxList = nil
  self.taskContent = self:AddComponent(UIBaseContainer, "taskContent")
  self.taskTitleTxt = self:AddComponent(UIText, "taskContent/taskTitleTxt")
  self.taskTitleTxt:SetLocalText(2000373)
  self.taskListContent = self:AddComponent(UICommonScoreContent, "taskContent/UICommonScoreContent")
  self.title:SetLocalText(801603)
  self.breakThroneProtectTime = nil
  local configSchedule = DataCenter.ZoneWarManager:GetCrossKingSchedule()
  if configSchedule ~= nil then
    local curTime = UITimeManager:GetInstance():GetServerTime()
    if curTime < configSchedule.breakThroneProtectTime then
      self.breakThroneProtectTime = configSchedule.breakThroneProtectTime
      self:Update1000MS()
    end
  end
end

function UIServerBattleLastKingPlayerReward:OnDestroy()
  self.scoreBoxList = nil
  self.theBoxItem:GameObjectRecycleAll()
  self.theBoxItemPoint:GameObjectRecycleAll()
  base.OnDestroy(self)
end

function UIServerBattleLastKingPlayerReward:OnEnable()
  base.OnEnable(self)
  self:AddUIListener(EventId.CrossKingFightInfoRefresh, self.OnDataUpdate)
end

function UIServerBattleLastKingPlayerReward:OnDisable()
  self:RemoveUIListener(EventId.CrossKingFightInfoRefresh, self.OnDataUpdate)
  base.OnDisable(self)
end

function UIServerBattleLastKingPlayerReward:OnDataUpdate()
  local fightInfo = DataCenter.ZoneWarManager:GetCrossKingFightInfo(true)
  local configSchedule = DataCenter.ZoneWarManager:GetCrossKingSchedule()
  if configSchedule == nil or fightInfo == nil then
    return
  end
  self.fightInfo = fightInfo
  self.configSchedule = configSchedule
  if fightInfo.user then
    self.scoreRewardIndex = fightInfo.user.scoreRewardIndex
  elseif self.scoreRewardIndex == nil then
    self.scoreRewardIndex = {}
  end
  self:GetShowDataAndRefreshView()
end

function UIServerBattleLastKingPlayerReward:GetShowDataAndRefreshView()
  local userInfo = self.fightInfo.user
  local boxCount = #userInfo.scoreBox
  self.showData = {
    sc = userInfo.score,
    score_reward_max = 236 * (boxCount - 0.5),
    count = boxCount,
    score_rewards = userInfo.scoreBox
  }
  if self.showData then
    self.gold_num:SetText(string.GetFormattedSeperatorNum(userInfo.score))
    self.scoreContent:SetActive(true)
    self.taskContent:SetActive(true)
    self.score_info:SetActive(userInfo.score > 0)
    self:RefreshScoreView()
    self:RefreshTaskView()
    CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.box_list.rectTransform)
    CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.box_content.rectTransform)
    CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.taskListContent.rectTransform)
    CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.taskContent.rectTransform)
    CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.rectTransform)
  else
    self.score_info:SetActive(false)
    self.gold_num:SetText(0)
    self.scoreContent:SetActive(false)
    self.taskContent:SetActive(false)
  end
end

function UIServerBattleLastKingPlayerReward:ReInit(configSchedule, fightInfo, config, serverBattleType, rootContent)
  self.showData = nil
  self.config = config
  self.serverBattleType = serverBattleType
  self.rootContent = rootContent
  self:OnDataUpdate()
end

function UIServerBattleLastKingPlayerReward:RefreshScoreView()
  if self.scoreBoxList == nil then
    self.scoreBoxList = {}
    self.scoreBoxShowData = {}
    local goItem, theItem, theItemPoint
    for i = 1, self.showData.count do
      local theName = "item_" .. i
      goItem = self.theBoxItem:GameObjectSpawn(self.box_list.transform)
      goItem.name = theName
      goItem:SetActive(true)
      theItem = self.box_list:AddComponent(UIBaseContainer, theName)
      local BoxItem = {
        index = i,
        root = theItem,
        bg = theItem:AddComponent(UIImage, "bg"),
        icon = theItem:AddComponent(UIImage, "Icon"),
        btnReward = theItem:AddComponent(UIButton, "BtnReward"),
        dimondBg = theItem:AddComponent(UIBaseContainer, "dimondBg"),
        dimondTxt = theItem:AddComponent(UIText, "dimondBg/dimondTxt"),
        targetNum = theItem:AddComponent(UIText, "targetNum"),
        effect = theItem:AddComponent(UIBaseContainer, "effect")
      }
      BoxItem.btnReward:SetOnClick(function()
        self:OnScoreBoxClick(BoxItem.index)
      end)
      table.insert(self.scoreBoxList, BoxItem)
      goItem = self.theBoxItemPoint:GameObjectSpawn(self.points.transform)
      goItem.name = theName
      goItem:SetActive(true)
      theItemPoint = self.points:AddComponent(UIImage, theName)
      table.insert(self.scoreBoxShowData, {
        bgImg = "cfm_huodong_gerenjunbei_baoxiangbeijing_jin",
        closeImg = "UIactivities_icon_box3",
        openImg = "UIactivities_icon_box3_1"
      })
    end
  end
  local progressMax = 100 + (self.showData.count - 1) * 246
  local progressNum = self.showData.sc
  local progressLen = 0
  local preTarget = 0
  local skipCalc = false
  for i = 1, #self.scoreBoxList do
    local boxItem = self.scoreBoxList[i]
    local boxItemData = self.scoreBoxShowData[i]
    local boxItemServerData = self.showData.score_rewards[i]
    local boxState = self:GetScoreBoxState(self.showData, i)
    if boxState == ActivityBoxState.Close then
      local iconPath = string.format(LoadPath.UIPersonalArms, boxItemData.closeImg)
      boxItem.icon:LoadSprite(iconPath)
      boxItem.effect:SetActive(false)
    elseif boxState == ActivityBoxState.CanOpen then
      local iconPath = string.format(LoadPath.UIPersonalArms, boxItemData.closeImg)
      boxItem.icon:LoadSprite(iconPath)
      boxItem.effect:SetActive(true)
    elseif boxState == ActivityBoxState.Open then
      local iconPath = string.format(LoadPath.UIPersonalArms, boxItemData.openImg)
      boxItem.icon:LoadSprite(iconPath)
      boxItem.effect:SetActive(false)
    end
    local boxNum = i * 10
    local iconPath = string.format(LoadPath.UIPersonalArms, boxItemData.bgImg)
    boxItem.bg:LoadSprite(iconPath)
    if boxItemServerData then
      boxNum = boxItemServerData.target
      boxItem.targetNum:SetText(boxNum)
      boxItem.dimondTxt:SetText(boxItemServerData.value)
      if skipCalc then
      elseif progressNum >= boxNum then
        progressLen = 100 + (i - 1) * 246
      elseif i == 1 then
        progressLen = 100 * (progressNum / boxNum)
        skipCalc = true
      else
        progressLen = 100 + (i - 2) * 246 + 246 * ((progressNum - preTarget) / (boxNum - preTarget))
        skipCalc = true
      end
    else
      boxItem.targetNum:SetText(boxNum)
      boxItem.dimondTxt:SetText(boxNum)
    end
    preTarget = boxNum
  end
  local sizeDelta = self.progress_bg.transform.sizeDelta
  self.progress_bg.transform.sizeDelta = Vector2(progressMax, sizeDelta.y)
  sizeDelta = self.scoreProgressVal.transform.sizeDelta
  self.scoreProgressVal.transform.sizeDelta = Vector2(progressLen, sizeDelta.y)
end

function UIServerBattleLastKingPlayerReward:RefreshTaskView()
  self.taskListContent:RefreshData(self.fightInfo.user.scoreIds, self.taskContent.rectTransform, self.rectTransform, self.rootContent.rectTransform)
end

function UIServerBattleLastKingPlayerReward:GetScoreBoxState(data, index)
  if data.score_rewards == nil then
    return ActivityBoxState.Close
  end
  local boxData = data.score_rewards[index]
  if boxData == nil then
    return ActivityBoxState.Close
  end
  local boxState = ActivityBoxState.Close
  local curNum = data.sc
  if curNum >= boxData.target then
    boxState = ActivityBoxState.CanOpen
  end
  if DataCenter.ZoneWarManager:HasZoneScoreRewardOpen(self.scoreRewardIndex, index) then
    boxState = ActivityBoxState.Open
  end
  return boxState
end

function UIServerBattleLastKingPlayerReward:OnScoreBoxClick(index)
  local boxState = self:GetScoreBoxState(self.showData, index)
  if boxState == ActivityBoxState.CanOpen then
    SFSNetwork.SendMessage(MsgDefines.CrossKingPersonScoreReward, index - 1)
  else
    local data = self.showData.score_rewards[index]
    local position = self.scoreBoxList[index].root:GetPosition()
    UIUtil.ShowLootRewardList(position, data.reward, data.value)
  end
end

function UIServerBattleLastKingPlayerReward:Update1000MS()
  if self.breakThroneProtectTime then
    local curTime = UITimeManager:GetInstance():GetServerTime()
    local remainTime = self.breakThroneProtectTime - curTime
    if 0 < remainTime then
      self.title:SetLocalText("season_ui_desc047", UITimeManager:GetInstance():MilliSecondToFmtString(remainTime))
    else
      self.breakThroneProtectTime = nil
      self.title:SetLocalText(801603)
    end
  end
end

return UIServerBattleLastKingPlayerReward
