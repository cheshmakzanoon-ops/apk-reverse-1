local UIAllyDuelPopupView = BaseClass("UIAllyDuelPopupView", UIBaseView)
local base = UIBaseView
local UIAllyDuelPopupItem = require("UI.LWUIAllyDuel.UIAllyDuelPopup.Component.UIAllyDuelPopupItem")
local panel_path = "panel"
local bg_path = "bg"
local title_path = "bg/title"
local flag1_path = "bg/flag1"
local flag2_path = "bg/flag2"
local server1_path = "bg/server1"
local p1_path = "bg/point1"
local p11_path = "bg/point1/p11"
local p12_path = "bg/point1/p12"
local server2_path = "bg/server2"
local p2_path = "bg/point2"
local p21_path = "bg/point2/p21"
local p22_path = "bg/point2/p22"
local redRatTxt_path = "bg/progressGo/redRatTxt"
local blueRatTxt_path = "bg/progressGo/blueRatTxt"
local redSlider_path = "bg/progressGo/mask/redSlider"
local blueSlider_path = "bg/progressGo/mask/blueSlider"
local mission_content_path = "bg/MissionScroll/Viewport/MissionContent"
local item_path = "bg/MissionScroll/Viewport/MissionContent/Item"
local reward_scroll_path = "bg/RewardScroll"
local reward_content_path = "bg/RewardScroll/Viewport/RewardContent"
local reward_item_path = "bg/RewardScroll/Viewport/RewardContent/RewardItem"
local sliderSign_path = "bg/progressGo/mask/blueSlider/Handle Slide Area/GameObject/blueSliderHandle"
local eff1_path = "bg/progressGo/mask/blueSlider/Handle Slide Area/GameObject/Eff_Eff_UIAllyDuelPopupNew_behindfire"
local eff2_path = "bg/progressGo/mask/blueSlider/Handle Slide Area/GameObject/Eff_UIAllyDuelPopupNew_frontfire"
local toggle_check_path = "bg/CheckToggle"
local NUM_PATH = "Assets/Main/Sprites/UI/UIAllyDuel/number/%s%d.png"

function UIAllyDuelPopupView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:Init()
end

function UIAllyDuelPopupView:ComponentDefine()
  self.animator = self:AddComponent(UIAnimator, "")
  self.animator:Enable(false)
  self.panel = self:AddComponent(UIButton, panel_path)
  self.panel:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.bg = self:AddComponent(UIBaseContainer, bg_path)
  self.title = self:AddComponent(UIText, title_path)
  self.flag1 = self:AddComponent(UIImage, flag1_path)
  self.flag2 = self:AddComponent(UIImage, flag2_path)
  self.server1 = self:AddComponent(UIText, server1_path)
  self.p1 = self:AddComponent(UIAnimator, p1_path)
  self.p1:Enable(false)
  self.p11 = self:AddComponent(UIImage, p11_path)
  self.p12 = self:AddComponent(UIImage, p12_path)
  self.server2 = self:AddComponent(UIText, server2_path)
  self.p2 = self:AddComponent(UIAnimator, p2_path)
  self.p2:Enable(false)
  self.p21 = self:AddComponent(UIImage, p21_path)
  self.p22 = self:AddComponent(UIImage, p22_path)
  self.redRatTxt = self:AddComponent(UIText, redRatTxt_path)
  self.blueRatTxt = self:AddComponent(UIText, blueRatTxt_path)
  self.redSlider = self:AddComponent(UISlider, redSlider_path)
  self.blueSlider = self:AddComponent(UISlider, blueSlider_path)
  self.mission_content = self:AddComponent(UIBaseContainer, mission_content_path)
  self.reward_scroll = self:AddComponent(UIScrollRect, reward_scroll_path)
  self.reward_content = self:AddComponent(UIBaseContainer, reward_content_path)
  self.sliderSign = self:AddComponent(UIBaseComponent, sliderSign_path)
  self.sliderSign:SetActive(false)
  self.eff1 = self:AddComponent(UIBaseComponent, eff1_path)
  self.eff1:SetActive(false)
  self.eff2 = self:AddComponent(UIBaseComponent, eff2_path)
  self.eff2:SetActive(false)
  self.toggle_check = self:AddComponent(UIToggle, toggle_check_path)
  self.toggle_check:SetIsOn(false)
  DataCenter.LWSoundManager:PlaySound(62286, false)
end

function UIAllyDuelPopupView:OnDestroy()
  if self.sparkEff then
    self:GameObjectDestroy(self.sparkEff)
    self.sparkEff = nil
  end
  if self.toggle_check:GetIsOn() then
    local now = UITimeManager:GetInstance():GetServerTime()
    CommonUtil.PlayerPrefsSetLong("ALLY_DUEL_POPUP_WEEK_TIMESTAMP", now)
  end
  if self.sliderAnimSeq then
    for _, v in ipairs(self.sliderAnimSeq) do
      if v then
        v:Kill()
      end
    end
    self.sliderAnimSeq = nil
  end
  if self.baseTimer then
    self.baseTimer:Stop()
    self.baseTimer = nil
  end
  if self.p1Timer then
    self.p1Timer:Stop()
    self.p1Timer = nil
  end
  if self.p2Timer then
    self.p2Timer:Stop()
    self.p2Timer = nil
  end
  self:RemoveUIAllyDuelPopupItems()
  self:ClearReward()
  base.OnDestroy(self)
end

function UIAllyDuelPopupView:SetScore(num, bLeft)
  local n = num
  local p1 = bLeft and self.p11 or self.p21
  local p2 = bLeft and self.p12 or self.p22
  local color = bLeft and "blue" or "red"
  p2:SetActive(10 <= num)
  if 10 <= num then
    local n1 = math.floor(num / 10)
    p1:LoadSprite(string.format(NUM_PATH, color, n1))
    local n2 = num % 10
    p2:LoadSprite(string.format(NUM_PATH, color, n2))
  else
    p1:LoadSprite(string.format(NUM_PATH, color, n))
  end
end

function UIAllyDuelPopupView:PlayScoreChange()
  local flag = false
  if self.myPoint ~= self.myLastPoint then
    flag = true
    self.p1:Enable(true)
    local result, time = self.p1:PlayAnimationReturnTime("UIAllyDuelPopupNewPoint1")
    if result then
      self.p1Timer = TimerManager:GetInstance():DelayInvoke(function()
        self.p1Timer = nil
        self:SetScore(self.myPoint, true)
      end, time * 0.2833333333333333)
    else
      self:SetScore(self.myPoint, true)
    end
  end
  if self.otherPoint ~= self.otherLastPoint then
    flag = true
    self.p2:Enable(true)
    local result, time = self.p2:PlayAnimationReturnTime("UIAllyDuelPopupNewPoint2")
    if result then
      self.p2Timer = TimerManager:GetInstance():DelayInvoke(function()
        self.p2Timer = nil
        self:SetScore(self.otherPoint, false)
      end, time * 0.2833333333333333)
    else
      self:SetScore(self.otherPoint, false)
    end
  end
  self.baseTimer = TimerManager:GetInstance():DelayInvoke(function()
    self.baseTimer = nil
    self:PlayProgressEff()
  end, 0.4)
end

function UIAllyDuelPopupView:PlayProgressEff()
  self.sliderAnimSeq = {}
  local blueRate = self.blueRate / 100
  local sTxtBlue = DOTween.To(function(x)
    self.blueRatTxt:SetText(math.floor(x) .. "%")
  end, 0, self.blueRate, 0.3333333333333333):OnComplete(function()
    self.blueRatTxt:SetText(math.floor(self.blueRate) .. "%")
  end)
  table.insert(self.sliderAnimSeq, sTxtBlue)
  local sBlue = DOTween.Sequence()
  sBlue:Append(self.blueSlider:DOValue(blueRate * 0.78, 0.16666666666666666))
  sBlue:Append(self.blueSlider:DOValue(blueRate * 0.85, 0.05))
  sBlue:Append(self.blueSlider:DOValue(blueRate * 0.95, 0.05))
  sBlue:Append(self.blueSlider:DOValue(blueRate, 0.06666666666666667))
  table.insert(self.sliderAnimSeq, sBlue)
  local redRate = self.redRate / 100
  local sTxtRed = DOTween.To(function(x)
    self.redRatTxt:SetText(math.floor(x) .. "%")
  end, 0, self.redRate, 0.3333333333333333):OnComplete(function()
    self.redRatTxt:SetText(math.floor(self.redRate) .. "%")
  end)
  table.insert(self.sliderAnimSeq, sTxtRed)
  local sRed = DOTween.Sequence()
  sRed:Append(self.redSlider:DOValue(redRate * 0.78, 0.16666666666666666))
  sRed:Append(self.redSlider:DOValue(redRate * 0.85, 0.05))
  sRed:Append(self.redSlider:DOValue(redRate * 0.95, 0.05))
  sRed:Append(self.redSlider:DOValue(redRate, 0.06666666666666667))
  table.insert(self.sliderAnimSeq, sRed)
  local sequence = DOTween.Sequence()
  sequence:AppendInterval(0.11666666666666667)
  sequence:AppendCallback(function()
    self.sliderSign:SetActive(true)
    self.eff1:SetActive(true)
    self.eff2:SetActive(true)
  end)
  sequence:Append(self.sliderSign.transform:DOScale(1.5, 0.03333333333333333))
  sequence:Append(self.sliderSign.transform:DOScale(0.9, 0.35))
  table.insert(self.sliderAnimSeq, sequence)
end

function UIAllyDuelPopupView:Init()
  local actInfo = DataCenter.ActivityListDataManager:GetActivityDataById(EnumActivity.AllianceCompete.ActId)
  if not actInfo or not actInfo:GetEventInfo() then
    self.ctrl:CloseSelf()
    return
  end
  local now = UITimeManager:GetInstance():GetServerTime()
  CommonUtil.PlayerPrefsSetLong("ALLY_DUEL_POPUP_TIMESTAMP", now)
  local eventInfo = actInfo:GetEventInfo()
  local myScore, otherScore = 0, 0
  self.myPoint = 0
  self.otherPoint = 0
  self.myLastPoint = 0
  self.otherLastPoint = 0
  local vsAlList = eventInfo ~= nil and eventInfo.vsAllianceList or {}
  for k, v in pairs(vsAlList) do
    local winTimes = (v.winScore == 0 or v.winScore == nil) and 0 or v.winScore
    local bLeft = k == LuaEntry.Player:GetAllianceUid()
    if bLeft then
      self.server1:SetText(UIUtil.FormatServerAllianceName(v.serverId, v.abbr))
      self.flag1:LoadSprite(string.format(AL_FLAG_SPRITE_PATH, v.icon))
      myScore = toInt(v.alScore)
      self.myPoint = winTimes
    else
      local empty = string.IsNullOrEmpty(v.alName)
      if empty then
        self.server2:SetLocalText(372814)
        self.flag2:LoadSprite(string.format(AL_FLAG_SPRITE_PATH, 1))
      else
        self.server2:SetText(UIUtil.FormatServerAllianceName(v.serverId, v.abbr))
        self.flag2:LoadSprite(string.format(AL_FLAG_SPRITE_PATH, v.icon))
      end
      otherScore = toInt(v.alScore)
      self.otherPoint = winTimes
    end
    self:SetScore(0, bLeft)
  end
  local myRateScore = myScore
  if myScore < 0 then
    myRateScore = 0
  end
  local otherRateScore = otherScore
  if otherScore < 0 then
    otherRateScore = 0
  end
  self.blueSlider:SetValue(0)
  self.redSlider:SetValue(0)
  self.redRatTxt:SetText("0%")
  self.blueRatTxt:SetText("0%")
  self.redRate = 50
  self.blueRate = 50
  if myRateScore == otherRateScore then
  else
    local total = myRateScore + otherRateScore
    local rate = tonumber(myRateScore / total)
    self.blueRate = rate * 100 + 0.5
    self.redRate = (1 - rate) * 100 + 0.5
  end
  local heroEventCfg = LocalController:instance():getLine(TableName.HeroEvent, eventInfo.eventId)
  local mission = DataCenter.LeagueMatchManager:GetMissions(heroEventCfg)
  self:RemoveUIAllyDuelPopupItems()
  for i = 1, #mission do
    local item = self.mission_content:LoadComponentAsync(UIAllyDuelPopupItem, "Assets/Main/Prefabs/UI/UIAllyDuel/AllyDuelMissionItem.prefab")
    self.missionItems[i] = item
    item:SetData(mission[i])
  end
  local rewardHisStr = CommonUtil.PlayerPrefsGetString("UIAllyDuelPopupViewReward", "")
  local rewardHistory = string.split(rewardHisStr, ",")
  local rewardHisDic = {}
  for _, v in pairs(rewardHistory) do
    rewardHisDic[v] = true
  end
  local reward = {}
  local score_way_reward = string.split(heroEventCfg.score_way_reward, ",")
  for i, v in ipairs(score_way_reward) do
    reward[i] = {itemId = v, new = 0}
  end
  local openServerDay = UITimeManager:GetInstance():GetOpenServerDay()
  local seasonNum = SeasonUtil.GetSeason()
  local seasonDay = SeasonUtil.GetSeasonDay()
  local openServerWeek = UITimeManager:GetInstance():GetOpenServerWeek()
  local score_way_reward_addition = string.split(heroEventCfg.score_way_reward_addition, "|")
  for _, v in ipairs(score_way_reward_addition) do
    local spl = string.split(v, ",")
    if #spl == 3 then
      local condi = tonumber(spl[1])
      local param
      if condi == 2 then
        param = string.split(spl[2], "#")
        param[1] = tonumber(param[1])
        if param[2] then
          param[2] = tonumber(param[2])
        else
          param[2] = 1
        end
      else
        param = tonumber(spl[2])
      end
      local itemId = spl[3]
      if condi == 1 and openServerDay >= param or condi == 2 and (seasonNum > param[1] or param[1] == seasonNum and seasonDay >= param[2]) or condi == 3 and openServerWeek >= param then
        if rewardHisDic[itemId] then
          table.insert(reward, {itemId = itemId, new = 1})
        else
          rewardHisStr = rewardHisStr .. "," .. itemId
          table.insert(reward, {itemId = itemId, new = 2})
        end
      end
    end
  end
  CommonUtil.PlayerPrefsSetString("UIAllyDuelPopupViewReward", rewardHisStr)
  table.sort(reward, function(a, b)
    return a.new > b.new
  end)
  self:ClearReward()
  for i, v in ipairs(reward) do
    self.rewardItems[i] = self:GameObjectInstantiateAsync("Assets/Main/Prefabs/UI/Common/UICommonResItemAllyDuel.prefab", function(request)
      if request.isError then
        return
      end
      local go = request.gameObject
      go.name = "UICommonResItemAllyDuel" .. i
      local transform = go.transform
      transform:SetParent(self.reward_content.transform)
      transform:Set_localScale(0.8, 0.8, 1)
      transform:Set_sizeDelta(150, 150)
      transform:Find("New").gameObject:SetActive(v.new == 2)
      local item = self.reward_content:AddComponent(UICommonResItem, go.name)
      local param = UICommonResItem.Param.New()
      param.rewardType = RewardType.GOODS
      param.itemId = v.itemId
      item:ReInit(param)
    end)
  end
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.reward_content.rectTransform)
  self.animator:Enable(true)
  local result, time = self.animator:PlayAnimationReturnTime("UIAllyDuelPopupNewIn")
  if result then
    self.baseTimer = TimerManager:GetInstance():DelayInvoke(function()
      self.baseTimer = nil
      self:PlayScoreChange()
    end, time * 0.3933333333333333)
  else
    self:PlayScoreChange()
  end
  TimerManager:GetInstance():DelayFrameInvoke(function()
    self.reward_scroll:AnimHorizontalNormalizedPos(0, 0.1)
  end, 1)
  self.sparkEff = self:GameObjectInstantiateAsync("Assets/Main/Prefabs/UI/UIAllyDuel/Eff_ui_allyDuelSpark.prefab", function(request)
    if request.isError then
      return
    end
    local transform = request.gameObject.transform
    transform:SetParent(self.bg.transform)
    transform:Set_sizeDelta(100, 100)
    transform:Set_localScale(1, 1, 1)
    transform:Set_localPosition(0, 0, 0)
  end)
end

function UIAllyDuelPopupView:RemoveUIAllyDuelPopupItems()
  if self.missionItems then
    for _, v in pairs(self.missionItems) do
      self.mission_content:RemoveAsyncComponent(v)
    end
  end
  self.missionItems = {}
end

function UIAllyDuelPopupView:ClearReward()
  self.reward_content:RemoveComponents(UICommonResItem)
  if self.rewardItems then
    for k, v in pairs(self.rewardItems) do
      if v then
        self:GameObjectDestroy(v)
      end
    end
  end
  self.rewardItems = {}
end

return UIAllyDuelPopupView
