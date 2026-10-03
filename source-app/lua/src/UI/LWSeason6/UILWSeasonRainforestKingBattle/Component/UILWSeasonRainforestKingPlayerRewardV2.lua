local base = UIBaseContainer
local UILWSeasonRainforestKingPlayerRewardV2 = BaseClass("UILWSeasonRainforestKingPlayerRewardV2", base)
local UICommonScoreContent = require("UI.UICommonScore.UICommonScoreContent")
local KingRewardRoot = require("UI.LWSeason6.UILWSeasonRainforestKingBattle.Component.UILWSeasonRainforestKingRewardItem")
local title_path = "ScrollViewRoot/Viewport/Content/TitleRoot/title"
local box_view_path = "ScrollViewRoot/Viewport/Content/ScrollView/Viewport"
local box_content_path = "ScrollViewRoot/Viewport/Content/ScrollView/Viewport/Content"
local taskContent_path = "ScrollViewRoot/Viewport/Content/taskContent"
local taskTitleTxt_path = "ScrollViewRoot/Viewport/Content/taskContent/taskTitleTxt"
local scoreContent_path = "ScrollViewRoot/Viewport/Content/taskContent/UICommonScoreContent"
local box_list_path = "ScrollViewRoot/Viewport/Content/ScrollView/Viewport/Content/boxList"
local scrollView_path = "ScrollViewRoot/Viewport/Content/ScrollView"
local score_box_item_path = "ScrollViewRoot/Viewport/Content/ScrollView/Viewport/Content/boxList/scoreBoxItem"
local progress_bg_path = "ScrollViewRoot/Viewport/Content/ScrollView/Viewport/Content/progressBg"
local scoreProgressVal_path = "ScrollViewRoot/Viewport/Content/ScrollView/Viewport/Content/progressBg/scoreProgressVal"
local points_path = "ScrollViewRoot/Viewport/Content/ScrollView/Viewport/Content/progressBg/Points"
local point_path = "ScrollViewRoot/Viewport/Content/ScrollView/Viewport/Content/progressBg/Points/Point"
local score_num_path = "ScrollViewRoot/Viewport/Content/TitleRoot/ScoreInfo/ImageGold/goldNum"
local score_info_path = "ScrollViewRoot/Viewport/Content/TitleRoot/ScoreInfo"
local arrowLeft_path = "ScrollViewRoot/Viewport/Content/ScrollView/Arrow/ArrowLeft"
local arrowRight_path = "ScrollViewRoot/Viewport/Content/ScrollView/Arrow/ArrowRight"
local scrollViewRoot_path = "ScrollViewRoot"
local lockMask_path = "ScrollViewRoot/Viewport/Content/ScrollView/LockMask"

function UILWSeasonRainforestKingPlayerRewardV2:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
end

function UILWSeasonRainforestKingPlayerRewardV2:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UILWSeasonRainforestKingPlayerRewardV2:ComponentDefine()
  self.title = self:AddComponent(UIText, title_path)
  self.box_view = self:AddComponent(UIBaseContainer, box_view_path)
  self.box_content = self:AddComponent(UIBaseContainer, box_content_path)
  self.taskContent = self:AddComponent(UIBaseContainer, taskContent_path)
  self.taskTitleTxt = self:AddComponent(UIText, taskTitleTxt_path)
  self.scoreContent = self:AddComponent(UIBaseContainer, scoreContent_path)
  self.box_list = self:AddComponent(UIBaseContainer, box_list_path)
  self.scrollView = self:AddComponent(UIScrollRect, scrollView_path)
  self.score_box_item = self:AddComponent(UIBaseContainer, score_box_item_path)
  self.progress_bg = self:AddComponent(UIImage, progress_bg_path)
  self.scoreProgressVal = self:AddComponent(UIImage, scoreProgressVal_path)
  self.points = self:AddComponent(UIBaseContainer, points_path)
  self.point = self:AddComponent(UIImage, point_path)
  self.score_num = self:AddComponent(UIText, score_num_path)
  self.score_info = self:AddComponent(UIBaseContainer, score_info_path)
  self.arrowLeft = self:AddComponent(UIButton, arrowLeft_path)
  self.arrowRight = self:AddComponent(UIButton, arrowRight_path)
  self.scrollViewRoot = self:AddComponent(UIScrollRect, scrollViewRoot_path)
  self.lockMask = self:AddComponent(UIImage, lockMask_path)
  self.KingRewardRoot = self:AddComponent(KingRewardRoot, "ScrollViewRoot/Viewport/Content/ZoneRewardInfo")
  self.scrollViewRoot:SetVerticalNormalizedPosition(1)
  self.scrollView:AddValueChangeListener(function()
    self:OnScrollValueChanged()
  end)
  self.arrowLeft:SetOnClick(function()
    local horizontalPos = self.scrollView:GetHorizontalNormalizedPosition()
    self.scrollView:AnimHorizontalNormalizedPos(math.max(0, horizontalPos - 0.5), 0.2)
  end)
  self.arrowRight:SetOnClick(function()
    local horizontalPos = self.scrollView:GetHorizontalNormalizedPosition()
    self.scrollView:AnimHorizontalNormalizedPos(math.min(1, horizontalPos + 0.5), 0.2)
  end)
  self.theBoxItem = self.score_box_item.gameObject
  self.theBoxItem:GameObjectCreatePool()
  self.theBoxItemPoint = self.point.gameObject
  self.theBoxItemPoint:GameObjectCreatePool()
  self.theBoxItemPoint:SetActive(false)
  self.scoreBoxList = nil
  self.taskTitleTxt:SetLocalText(2000373)
  self.taskListContent = self:AddComponent(UICommonScoreContent, scoreContent_path)
  self.title:SetLocalText(801603)
  self.startTime = nil
  self:Update1000MS()
end

function UILWSeasonRainforestKingPlayerRewardV2:ComponentDestroy()
  self.scoreBoxList = nil
  self.theBoxItem:GameObjectRecycleAll()
  self.theBoxItemPoint:GameObjectRecycleAll()
  self.title = nil
  self.box_view = nil
  self.box_content = nil
  self.taskContent = nil
  self.taskTitleTxt = nil
  self.scoreContent = nil
  self.box_list = nil
  self.scrollView = nil
  self.score_box_item = nil
  self.progress_bg = nil
  self.scoreProgressVal = nil
  self.points = nil
  self.point = nil
  self.score_num = nil
  self.score_info = nil
  self.arrowLeft = nil
  self.arrowRight = nil
  self.scrollViewRoot = nil
  self.lockMask = nil
  self.showData = nil
end

function UILWSeasonRainforestKingPlayerRewardV2:ReInit(attackActData, fightInfo, userInfo, startTime)
  self.showData = nil
  self.attackActData = attackActData
  self.fightInfo = fightInfo
  self.userInfo = userInfo
  self.startTime = startTime
  self.destroyRewardId = tostring(attackActData.para_2)
  self:OnDataUpdate()
  self:Update1000MS()
  self:JumpToNextBox()
  self.KingRewardRoot:RefreshUI()
end

function UILWSeasonRainforestKingPlayerRewardV2:SetRewardDetail(rewardData, destroyRewardId)
  if destroyRewardId then
    self.destroyRewardId = destroyRewardId
  end
  if rewardData == nil or rewardData.type ~= 20260212 or self.destroyRewardId == nil then
    return
  end
  self.kingRewardData = rewardData[self.destroyRewardId]
  self.KingRewardRoot:ReInit(self.kingRewardData)
end

function UILWSeasonRainforestKingPlayerRewardV2:Update1000MS()
  if self.startTime then
    local curTime = UITimeManager:GetInstance():GetServerTime()
    local remainTime = self.startTime - curTime
    if 0 < remainTime then
      self.title:SetLocalText("season_ui_desc047", UITimeManager:GetInstance():MilliSecondToFmtString(remainTime))
    else
      self.startTime = nil
      self.title:SetLocalText(801603)
    end
  else
    self.title:SetLocalText(801603)
  end
end

function UILWSeasonRainforestKingPlayerRewardV2:OnDataUpdate()
  local userInfo = self.userInfo
  local fightInfo = self.fightInfo
  if fightInfo == nil then
    return
  end
  if userInfo then
    self.scoreRewardIndex = userInfo.scoreRewardIndex
  elseif self.scoreRewardIndex == nil then
    self.scoreRewardIndex = {}
  end
  self:GetShowDataAndRefreshView()
end

function UILWSeasonRainforestKingPlayerRewardV2:GetShowDataAndRefreshView()
  local fightInfo = self.fightInfo
  local userInfo = self.userInfo
  local scoreBox = fightInfo.scoreBox or userInfo.scoreBox
  local boxCount = #scoreBox
  self.showData = {
    sc = userInfo.score,
    score_reward_max = 236 * (boxCount - 0.5),
    count = boxCount,
    score_rewards = scoreBox
  }
  if self.showData then
    self.score_num:SetText(string.GetFormattedSeperatorNum(userInfo.score))
    self.scoreContent:SetActive(true)
    self.taskContent:SetActive(true)
    TimerManager:GetInstance():DelayInvoke(function()
      if self.showData then
        self:RefreshScoreView()
        self:RefreshTaskView()
      end
    end, 0.1)
  else
    self.scoreContent:SetActive(false)
    self.taskContent:SetActive(false)
  end
  self.scrollView:SetHorizontalNormalizedPosition(0)
  if boxCount <= 3 then
    self.scrollView:SetEnable(false)
    self.arrowLeft:SetActive(false)
    self.arrowRight:SetActive(false)
  else
    self.scrollView:SetEnable(true)
    self:OnScrollValueChanged()
  end
end

function UILWSeasonRainforestKingPlayerRewardV2:ShowScore(flag)
  if flag then
    self.score_info:SetActive(true)
    self.title:SetActive(false)
    self.lockMask:SetActive(false)
  else
    self.score_info:SetActive(false)
    self.title:SetActive(true)
    self.lockMask:SetActive(true)
  end
end

function UILWSeasonRainforestKingPlayerRewardV2:RefreshScoreView()
  if self.scoreBoxList == nil then
    self.scoreBoxList = {}
    self.scoreBoxShowData = {}
    local goItem, theItem, theItemPoint
    local boxListData = {
      [1] = {
        bgImg = "cfm_huodong_gerenjunbei_baoxiangbeijing_lan",
        closeImg = "LXY_s5_Baoxiang1_icon",
        openImg = "LXY_s5_Baoxiang2_icon"
      },
      [2] = {
        bgImg = "cfm_huodong_gerenjunbei_baoxiangbeijing_zi",
        closeImg = "LXY_s5_Baoxiang5_icon",
        openImg = "LXY_s5_Baoxiang6_icon"
      },
      [3] = {
        bgImg = "cfm_huodong_gerenjunbei_baoxiangbeijing_jin",
        closeImg = "LXY_s5_Baoxiang3_icon",
        openImg = "LXY_s5_Baoxiang4_icon"
      },
      [4] = {
        bgImg = "cfm_huodong_gerenjunbei_baoxiangbeijing_lan",
        closeImg = "LXY_s5_Baoxiang1_icon",
        openImg = "LXY_s5_Baoxiang2_icon"
      },
      [5] = {
        bgImg = "cfm_huodong_gerenjunbei_baoxiangbeijing_zi",
        closeImg = "LXY_s5_Baoxiang5_icon",
        openImg = "LXY_s5_Baoxiang6_icon"
      },
      [6] = {
        bgImg = "cfm_huodong_gerenjunbei_baoxiangbeijing_jin",
        closeImg = "LXY_s5_Baoxiang3_icon",
        openImg = "LXY_s5_Baoxiang4_icon"
      },
      [7] = {
        bgImg = "cfm_huodong_gerenjunbei_baoxiangbeijing_lan",
        closeImg = "LXY_s5_Baoxiang1_icon",
        openImg = "LXY_s5_Baoxiang2_icon"
      },
      [8] = {
        bgImg = "cfm_huodong_gerenjunbei_baoxiangbeijing_zi",
        closeImg = "LXY_s5_Baoxiang5_icon",
        openImg = "LXY_s5_Baoxiang6_icon"
      },
      [9] = {
        bgImg = "cfm_huodong_gerenjunbei_baoxiangbeijing_jin",
        closeImg = "LXY_s5_Baoxiang3_icon",
        openImg = "LXY_s5_Baoxiang4_icon"
      }
    }
    for i = 1, self.showData.count do
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
      table.insert(self.scoreBoxShowData, boxListData[3])
    end
  end
  local boxPath = "KingBattleS5/box/%s"
  local progressMax = 100 + (self.showData.count - 1) * 246
  local progressNum = self.showData.sc
  local progressLen = 0
  local preTarget = 0
  local skipCalc = false
  for i = 1, #self.scoreBoxList do
    local boxItem = self.scoreBoxList[i]
    local boxItemData = self.scoreBoxShowData[i]
    local boxItemServerData = self.showData.score_rewards[i]
    local boxState = DataCenter.SeasonNineKingManager:GetScoreBoxState(self.showData.score_rewards, self.showData.sc, i, self.scoreRewardIndex)
    if boxState == ActivityBoxState.CanOpen then
      local iconPath = string.format(LoadPath.UISeason5Path, string.format(boxPath, boxItemData.closeImg))
      boxItem.icon:LoadSprite(iconPath)
      boxItem.effect:SetActive(true)
    elseif boxState == ActivityBoxState.Open then
      local iconPath = string.format(LoadPath.UISeason5Path, string.format(boxPath, boxItemData.openImg))
      boxItem.icon:LoadSprite(iconPath)
      boxItem.effect:SetActive(false)
    else
      local iconPath = string.format(LoadPath.UISeason5Path, string.format(boxPath, boxItemData.closeImg))
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

function UILWSeasonRainforestKingPlayerRewardV2:RefreshTaskView()
  if self.taskListInitialized == true then
    return
  end
  local scoreIds = self.fightInfo.scoreIds or self.userInfo.scoreIds
  if type(scoreIds) == "string" then
    scoreIds = string.split_ii_array(scoreIds, ";")
  elseif #scoreIds == 1 then
    scoreIds = string.split_ii_array(scoreIds[1], ";")
  end
  self.taskListInitialized = true
  self.taskListContent:RefreshData(scoreIds, self.box_list.rectTransform, self.box_content.rectTransform, self.taskListContent.rectTransform, self.taskContent.rectTransform, self.rectTransform)
end

function UILWSeasonRainforestKingPlayerRewardV2:OnScoreBoxClick(index)
  local boxState = DataCenter.SeasonNineKingManager:GetScoreBoxState(self.showData.score_rewards, self.showData.sc, index, self.scoreRewardIndex)
  if boxState == ActivityBoxState.CanOpen then
    local userInfo = self.userInfo
    if userInfo and userInfo.uuid then
      SFSNetwork.SendMessage(MsgDefines.HeroEventClaimBoxReward, userInfo.uuid, index - 1)
    end
  else
    local data = self.showData.score_rewards[index]
    local position = self.scoreBoxList[index].root:GetPosition()
    UIUtil.ShowLootRewardList(position, data.reward, data.value)
  end
end

function UILWSeasonRainforestKingPlayerRewardV2:MoveContentByPages(pages)
  if not (self.box_view and self.box_view.rectTransform and self.box_content) or not self.box_content.rectTransform then
    return
  end
  local contentRT = self.box_content.rectTransform
  local viewRT = self.box_view.rectTransform
  local contentW = math.abs(contentRT.sizeDelta.x or 0)
  local viewW = math.abs(viewRT.sizeDelta.x or 0)
  if viewW <= 0 then
    return
  end
  local maxOffset = math.max(0, contentW - viewW)
  local lp = contentRT.localPosition
  local curX = lp.x or 0
  if CommonUtil.IsArabic() then
    curX = -curX
  end
  local step = viewW
  local targetX = curX - pages * step
  if 0 < maxOffset then
    if targetX < -maxOffset then
      targetX = -maxOffset
    end
    if 0 < targetX then
      targetX = 0
    end
  else
    targetX = 0
  end
  if CommonUtil.IsArabic() then
    targetX = -targetX
  end
  contentRT.localPosition = Vector3(targetX, lp.y, lp.z)
  self:OnScrollValueChanged()
end

function UILWSeasonRainforestKingPlayerRewardV2:OnScrollValueChanged()
  local horizontalPos = self.scrollView:GetHorizontalNormalizedPosition()
  self.arrowLeft:SetActive(0.02 < horizontalPos)
  self.arrowRight:SetActive(horizontalPos < 0.98)
end

function UILWSeasonRainforestKingPlayerRewardV2:JumpToNextBox()
  if self.scoreBoxList == nil then
    return
  end
  local jumpIndex
  for i = 1, #self.scoreBoxList do
    local boxState = DataCenter.SeasonNineKingManager:GetScoreBoxState(self.showData.score_rewards, self.showData.sc, i, self.scoreRewardIndex)
    if boxState == ActivityBoxState.CanOpen then
      jumpIndex = i
      break
    end
  end
  self:JumpToIndex(jumpIndex)
end

function UILWSeasonRainforestKingPlayerRewardV2:JumpToIndex(jumpIndex)
  if jumpIndex then
    local page = math.floor((jumpIndex - 1) / 3)
    local targetPos = page * 0.5
    self.scrollView:AnimHorizontalNormalizedPos(targetPos, 0.2)
  end
end

return UILWSeasonRainforestKingPlayerRewardV2
