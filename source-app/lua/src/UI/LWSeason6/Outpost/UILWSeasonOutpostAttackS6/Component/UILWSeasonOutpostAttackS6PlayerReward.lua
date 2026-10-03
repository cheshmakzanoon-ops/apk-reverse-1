local UILWSeasonOutpostAttackS6PlayerReward = BaseClass("UILWSeasonOutpostAttackS6PlayerReward", UIScrollRect)
local base = UIScrollRect
local UICommonScoreContent = require("UI.UICommonScore.UICommonScoreContent")
local box_content_path = "Viewport/Content/PlayerRewardInfo/Viewport/Content"
local box_list_path = "Viewport/Content/PlayerRewardInfo/Viewport/Content/boxList"
local score_box_item_path = "Viewport/Content/PlayerRewardInfo/Viewport/Content/boxList/scoreBoxItem"
local progress_bg_path = "Viewport/Content/PlayerRewardInfo/Viewport/Content/progressBg"
local score_progress_val_path = "Viewport/Content/PlayerRewardInfo/Viewport/Content/progressBg/scoreProgressVal"
local points_path = "Viewport/Content/PlayerRewardInfo/Viewport/Content/progressBg/Points"
local point_path = "Viewport/Content/PlayerRewardInfo/Viewport/Content/progressBg/Points/Point"
local score_num_path = "Viewport/Content/ScoreInfo/ImageGold/scoreNum"
local score_info_path = "Viewport/Content/ScoreInfo"

function UILWSeasonOutpostAttackS6PlayerReward:OnCreate()
  base.OnCreate(self)
  self.title = self:AddComponent(UIText, "Viewport/Content/title")
  self.scoreContent = self:AddComponent(UIBaseContainer, "Viewport/Content/PlayerRewardInfo")
  self.box_content = self:AddComponent(UIBaseContainer, box_content_path)
  self.box_list = self:AddComponent(UIBaseContainer, box_list_path)
  self.score_box_item = self:AddComponent(UIImage, score_box_item_path)
  self.progress_bg = self:AddComponent(UIImage, progress_bg_path)
  self.scoreProgressVal = self:AddComponent(UIImage, score_progress_val_path)
  self.points = self:AddComponent(UIBaseContainer, points_path)
  self.point = self:AddComponent(UIImage, point_path)
  self.score_num = self:AddComponent(UIText, score_num_path)
  self.score_info = self:AddComponent(UIBaseContainer, score_info_path)
  self.theBoxItem = self.score_box_item.gameObject
  self.theBoxItem:GameObjectCreatePool()
  self.theBoxItemPoint = self.point.gameObject
  self.theBoxItemPoint:GameObjectCreatePool()
  self.scoreBoxList = nil
  self.taskContent = self:AddComponent(UIBaseContainer, "Viewport/Content/taskContent")
  self.taskTitleTxt = self:AddComponent(UIText, "Viewport/Content/taskContent/taskTitleTxt")
  self.taskTitleTxt:SetLocalText(2000373)
  self.taskListContent = self:AddComponent(UICommonScoreContent, "Viewport/Content/taskContent/UICommonScoreContent")
  self.title:SetLocalText(801603)
  self.battleStartTime = nil
  self:Update1000MS()
end

function UILWSeasonOutpostAttackS6PlayerReward:OnDestroy()
  self.scoreBoxList = nil
  self.theBoxItem:GameObjectRecycleAll()
  self.theBoxItemPoint:GameObjectRecycleAll()
  base.OnDestroy(self)
end

function UILWSeasonOutpostAttackS6PlayerReward:OnDataUpdate()
  local fightInfo = self.fightInfo
  if fightInfo == nil then
    return
  end
  if fightInfo.user then
    self.scoreRewardIndex = fightInfo.user.scoreRewardIndex
  elseif self.scoreRewardIndex == nil then
    self.scoreRewardIndex = {}
  end
  self:GetShowDataAndRefreshView()
end

function UILWSeasonOutpostAttackS6PlayerReward:GetShowDataAndRefreshView()
  local userInfo = self.fightInfo.user
  local boxCount = #userInfo.scoreBox
  self.showData = {
    sc = userInfo.score,
    score_reward_max = 236 * (boxCount - 0.5),
    count = boxCount,
    score_rewards = userInfo.scoreBox
  }
  if self.showData then
    self.score_num:SetText(string.GetFormattedSeperatorNum(userInfo.score))
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
    self.score_num:SetText(0)
    self.scoreContent:SetActive(false)
    self.taskContent:SetActive(false)
  end
end

function UILWSeasonOutpostAttackS6PlayerReward:ReInit(rootContent, fightInfo, battleStartTime)
  self.showData = nil
  self.rootContent = rootContent
  self.fightInfo = fightInfo
  self.battleStartTime = battleStartTime
  self:OnDataUpdate()
  self:Update1000MS()
end

function UILWSeasonOutpostAttackS6PlayerReward:RefreshScoreView()
  if self.scoreBoxList == nil then
    self.scoreBoxList = {}
    self.scoreBoxShowData = {}
    local goItem, theItem, theItemPoint
    local boxListData = {
      [1] = {
        perPos = 0,
        valPos = 75,
        bgImg = "cfm_huodong_baoxiangbeijing_lan",
        closeImg = "UIAllianceArmament_img_reward01",
        openImg = "UIAllianceArmament_img_reward02"
      },
      [2] = {
        perPos = 75,
        valPos = 340,
        bgImg = "cfm_huodong_baoxiangbeijing_zi",
        closeImg = "UIAllianceArmament_img_reward03",
        openImg = "UIAllianceArmament_img_reward04"
      },
      [3] = {
        perPos = 340,
        valPos = 590,
        bgImg = "cfm_huodong_baoxiangbeijing_jin",
        closeImg = "UIAllianceArmament_img_reward05",
        openImg = "UIAllianceArmament_img_reward06"
      }
    }
    for i = 1, self.showData.count do
      if boxListData[i] == nil then
        break
      end
      local theName = "item_" .. UIUtil.GetLoopListItemIndex()
      goItem = self.theBoxItem:GameObjectSpawn(self.box_list.transform)
      goItem.name = theName
      goItem:SetActive(true)
      theItem = self.box_list:AddComponent(UIBaseContainer, theName)
      local BoxItem = {
        index = i,
        root = theItem,
        bg = theItem:AddComponent(UIImage, "bg"),
        icon = theItem:AddComponent(UIImage, "Icon"),
        iconAnim = theItem:AddComponent(UIAnimator, "Icon"),
        btnReward = theItem:AddComponent(UIButton, "BtnReward"),
        dimondBg = theItem:AddComponent(UIBaseContainer, "dimondBg"),
        dimondTxt = theItem:AddComponent(UIText, "dimondBg/dimondTxt"),
        targetNum = theItem:AddComponent(UIText, "targetNum"),
        effect = theItem:AddComponent(UIBaseContainer, "effect"),
        effect2 = theItem:AddComponent(UIBaseContainer, "effect2")
      }
      BoxItem.btnReward:SetOnClick(function()
        self:OnScoreBoxClick(BoxItem.index)
      end)
      table.insert(self.scoreBoxList, BoxItem)
      goItem = self.theBoxItemPoint:GameObjectSpawn(self.points.transform)
      goItem.name = theName
      goItem:SetActive(true)
      theItemPoint = self.points:AddComponent(UIImage, theName)
      table.insert(self.scoreBoxShowData, boxListData[i])
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
      local iconPath = string.format("Assets/Main/Sprites/UI/ActRewardCommon/%s.png", boxItemData.closeImg)
      boxItem.icon:LoadSprite(iconPath)
      boxItem.effect:SetActive(false)
      boxItem.effect2:SetActive(false)
      boxItem.iconAnim:Play("box_unOpen")
    elseif boxState == ActivityBoxState.CanOpen then
      local iconPath = string.format("Assets/Main/Sprites/UI/ActRewardCommon/%s.png", boxItemData.closeImg)
      boxItem.icon:LoadSprite(iconPath)
      boxItem.effect:SetActive(true)
      boxItem.effect2:SetActive(true)
      boxItem.iconAnim:Play("box_open")
    elseif boxState == ActivityBoxState.Open then
      local iconPath = string.format("Assets/Main/Sprites/UI/ActRewardCommon/%s.png", boxItemData.openImg)
      boxItem.icon:LoadSprite(iconPath)
      boxItem.effect:SetActive(false)
      boxItem.effect2:SetActive(false)
      boxItem.iconAnim:Play("box_unOpen")
    end
    local boxNum = i * 10
    boxItem.bg:LoadSprite("Assets/Main/SeasonRes/S6/Sprites/OutpostS6/mjc_S6_QSZ_jiangli_taizi.png")
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

function UILWSeasonOutpostAttackS6PlayerReward:RefreshTaskView()
  if self.taskListInitialized == true then
    return
  end
  local scoreIds = self.fightInfo.user.scoreIds
  if type(scoreIds) == "string" then
    scoreIds = string.split_ii_array(scoreIds, ";")
  elseif #scoreIds == 1 then
    scoreIds = string.split_ii_array(scoreIds[1], ";")
  end
  self.taskListInitialized = true
  self.taskListContent:RefreshData(scoreIds, self.taskContent.rectTransform, self.rectTransform, self.rootContent.rectTransform)
end

function UILWSeasonOutpostAttackS6PlayerReward:GetScoreBoxState(data, index)
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

function UILWSeasonOutpostAttackS6PlayerReward:OnScoreBoxClick(index)
  local boxState = self:GetScoreBoxState(self.showData, index)
  if boxState == ActivityBoxState.CanOpen then
    SFSNetwork.SendMessage(MsgDefines.FetchOutpostBattleReward, index - 1)
  else
    local data = self.showData.score_rewards[index]
    local position = self.scoreBoxList[index].root:GetPosition()
    UIUtil.ShowLootRewardList(position, data.reward, data.value)
  end
end

function UILWSeasonOutpostAttackS6PlayerReward:Update1000MS()
  if self.battleStartTime then
    local curTime = UITimeManager:GetInstance():GetServerTime()
    local remainTime = self.battleStartTime - curTime
    if 0 < remainTime then
      self.title:SetLocalText("outpost_start_time_title", UITimeManager:GetInstance():MilliSecondToFmtString(remainTime))
    else
      self.battleStartTime = nil
      self.title:SetLocalText(801603)
    end
  else
    self.title:SetLocalText(801603)
  end
end

return UILWSeasonOutpostAttackS6PlayerReward
