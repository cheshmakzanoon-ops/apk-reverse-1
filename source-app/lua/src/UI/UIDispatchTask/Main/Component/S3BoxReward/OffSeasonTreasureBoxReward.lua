local base = UIBaseContainer
local OffSeasonTreasureBoxReward = BaseClass("OffSeasonTreasureBoxReward", UIBaseContainer)
local Localization = CS.GameEntry.Localization
local BoxReward = require("UI.UIDispatchTask.Main.Component.S3BoxReward.boxRewardComponent")
local boxRewardAni = require("UI.UIDispatchTask.Main.Component.S3BoxReward.boxRewardAni")
local flyObjPath = "Assets/Main/Prefabs/UI/OffSeason3TreasureBoxReward/OffSeasonTreasureBoxRewardFlyIcon.prefab"
local textObjPath = "Assets/Main/Prefabs/UI/OffSeason3TreasureBoxReward/Effect/Eff_ui_cangbaotu_text_in.prefab"
local Canvas = CS.UnityEngine.Canvas
local position3 = {
  Vector3.New(-5, 10),
  Vector3.New(70, -10),
  Vector3.New(-40, -50),
  Vector3.New(-40, 60),
  Vector3.New(45, 70),
  Vector3.New(-100, 0),
  Vector3.New(30, -35),
  Vector3.New(95, 30),
  Vector3.New(-35, 5),
  Vector3.New(30, 45)
}

function OffSeasonTreasureBoxReward:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:InitTexts()
end

function OffSeasonTreasureBoxReward:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function OffSeasonTreasureBoxReward:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.btnScoreIcon = self.viewSkin:AddComponent(self, UIButton, 1)
  self.btnScoreIcon:SetOnClick(function()
    self:OnBtnClick(self.btnScoreIcon, 60, false, 15)
  end)
  self.Text_in = self:AddComponent(UIBaseContainer, "Text_in")
  self.effHit = self:AddComponent(UIBaseContainer, "scoreIcon/Eff_luopan")
  self.textScore = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 2)
  self.imgArrowRight = self.viewSkin:AddComponent(self, UIImage, 3)
  self.imgArrowleft = self.viewSkin:AddComponent(self, UIImage, 4)
  self.compBoxReward = self.viewSkin:AddComponent(self, UIBaseComponent, 5)
  self.targetList = self.viewSkin:AddComponent(self, UILoopListView2, 6)
  self.targetList:InitListView(0, function(loopView, index)
    return self:OnGetItemByIndex(loopView, index)
  end)
  self.content = self.viewSkin:AddComponent(self, UIBaseContainer, 7)
  self.slider = self.viewSkin:AddComponent(self, UISlider, 8)
  self.sliderEff = self:AddComponent(UIBaseContainer, "ScrollView/Viewport/Content/Slider/SldierProgress/Eff_saoguang")
  self.Text_in.gameObject:SetActive(true)
end

function OffSeasonTreasureBoxReward:ComponentDestroy()
  self.Text_in:RemoveAllComponentes()
  self.textList = nil
  self.viewSkin = nil
  self.btnScoreIcon = nil
  self.Text_in = nil
  self.effHit = nil
  self.textScore = nil
  self.imgArrowRight = nil
  self.imgArrowleft = nil
  self.compBoxReward = nil
  self.targetList = nil
  self.content = nil
  self.slider = nil
  self.sliderEff = nil
end

function OffSeasonTreasureBoxReward:DataDefine()
  self.itemIndex = 0
  self.nowScore = 0
  self.textList = {}
end

function OffSeasonTreasureBoxReward:StopTimer()
  if self.delay1 then
    self.delay1:Stop()
    self.delay1 = nil
  end
  if self.delay2 then
    self.delay2:Stop()
    self.delay2 = nil
  end
  if self.delay3 then
    self.delay3:Stop()
    self.delay3 = nil
  end
  if self.delay4 then
    self.delay4:Stop()
    self.delay4 = nil
  end
end

function OffSeasonTreasureBoxReward:DataDestroy()
  self:StopTimer()
  if self.slider then
    self.slider:SetValue(0)
  end
  self:ClearScroll()
  if self.questFlyEffs then
    for i = 1, #self.questFlyEffs do
      if self.questFlyEffs[i] then
        self.questFlyEffs[i]:Destroy()
        self.questFlyEffs[i] = nil
      end
    end
  end
  if self.questFlyEffTimers then
    for i = 1, #self.questFlyEffTimers do
      if self.questFlyEffTimers[i] then
        self.questFlyEffTimers[i]:Stop()
        self.questFlyEffTimers[i] = nil
      end
    end
  end
  self.initProgress = nil
  self.itemIndex = nil
  self.nowScore = nil
  self.textList = nil
  self.jumpIndex = nil
end

function OffSeasonTreasureBoxReward:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.TreasureBoxReward, self.ReInit)
  self:AddUIListener(EventId.TreasureBoxRewardAni, self.PlayIconFlyAni)
end

function OffSeasonTreasureBoxReward:OnRemoveListener()
  self:RemoveUIListener(EventId.TreasureBoxReward, self.ReInit)
  self:RemoveUIListener(EventId.TreasureBoxRewardAni, self.PlayIconFlyAni)
  base.OnRemoveListener(self)
end

function OffSeasonTreasureBoxReward:ClearScroll()
  self.content:RemoveComponents(BoxReward)
  self.targetList:ClearAllItems()
end

function OffSeasonTreasureBoxReward:ReInit(state, open)
  local openIt = DataCenter.DigTreasureBoxRewardManager:GetOpenState()
  if not openIt then
    self:OnBtnClick(self.btnScoreIcon, 60, false, 15)
    DataCenter.DigTreasureBoxRewardManager:SetOpenState()
  end
  if state then
    self.effHit.gameObject:SetActive(state)
    self.sliderEff.gameObject:SetActive(state)
  else
    self.effHit.gameObject:SetActive(false)
    self.sliderEff.gameObject:SetActive(false)
  end
  self.rewardList = DataCenter.DigTreasureBoxRewardManager:GetTreasureBoxRewardList()
  self.nowScore = DataCenter.DigTreasureBoxRewardManager:GetBoxRewardItemCount()
  if not table.IsNullOrEmpty(self.rewardList) then
    table.sort(self.rewardList, function(a, b)
      return a.target < b.target
    end)
    if not self.initProgress then
      self:InitProgress(#self.rewardList)
      self.initProgress = true
    end
    self:UpdateRewardList(true, open)
  end
end

function OffSeasonTreasureBoxReward:InitTexts()
  self.questFlyEffs = {}
  if self.textList and #self.textList < 10 then
    self.Text_in:RemoveAllComponentes()
    self.textList = {}
    for i = 1, 10 do
      self.questFlyEffs[i] = self:GameObjectInstantiateAsync(textObjPath, function(req2)
        local obj = req2.gameObject
        obj.name = "textEffIn" .. i
        local trans = obj.transform
        trans:SetParent(self.Text_in.transform)
        trans:Set_localScale(1, 1, 1)
        trans:Set_localPosition(0, 0, 0)
        local textComp = self.Text_in:AddComponent(boxRewardAni, "textEffIn" .. i)
        textComp.gameObject:SetActive(false)
        table.insert(self.textList, textComp)
      end)
    end
  end
end

function OffSeasonTreasureBoxReward:OnGetItemByIndex(loopScroll, index)
  index = index + 1
  if index < 1 or index > #self.rewardList then
    return nil
  end
  local packData = self.rewardList[index]
  local item = loopScroll:NewListViewItem("boxReward")
  local script = self.content:GetComponent(item.gameObject.name, BoxReward)
  if script == nil then
    local objectName = tostring(self.itemIndex)
    self.itemIndex = self.itemIndex + 1
    item.gameObject.name = objectName
    if not item.IsInitHandlerCalled then
      item.IsInitHandlerCalled = true
    end
    script = self.content:AddComponent(BoxReward, objectName)
  end
  script:SetActive(true)
  script:ReInit(packData, self.nowScore)
  return item
end

function OffSeasonTreasureBoxReward:RefreshRewardList(jump)
  if table.IsNullOrEmpty(self.rewardList) then
    self.targetList:SetActive(false)
  else
    self.targetList:SetActive(true)
    self.targetList:SetListItemCount(#self.rewardList, false, false)
    self.targetList:RefreshAllShownItem()
    if not self.initProgress then
      self:InitProgress(#self.rewardList)
      self.initProgress = true
    end
    if jump then
      local jumpIndex = 1
      local maxTarget = -math.huge
      local findIt = false
      for i, v in ipairs(self.rewardList) do
        if maxTarget < v.target and v.isReward == 0 and v.target <= self.nowScore then
          maxTarget = v.target
          jumpIndex = i
          findIt = true
        end
      end
      if not findIt then
        for i, v in ipairs(self.rewardList) do
          if maxTarget < v.target and v.isReward == 1 and v.target <= self.nowScore then
            maxTarget = v.target
            jumpIndex = i
          end
        end
      end
      if 3 < jumpIndex then
        jumpIndex = jumpIndex - 3
      elseif jumpIndex <= 3 then
        jumpIndex = 0
      end
      self.jumpIndex = jumpIndex
      self.targetList:MovePanelToItemIndex(jumpIndex)
    end
  end
end

function OffSeasonTreasureBoxReward:UpdateRewardList(jump, open)
  self:RefreshRewardList(jump)
  self:RefreshScore(open)
end

local itemLength = 128.5
local spacing = -8

function OffSeasonTreasureBoxReward:InitProgress(count)
  if self.slider then
    local length = count * itemLength + spacing * (count - 1) - 60
    length = length < 0 and 0 or length
    self.slider.transform:Set_sizeDelta(length, 36)
  end
end

function OffSeasonTreasureBoxReward:RefreshScore(open)
  local score = self.nowScore
  self.textScore:SetText(score)
  local progress = 0
  if not table.IsNullOrEmpty(self.rewardList) and self.targetList then
    local step = 1 / #self.rewardList
    local firstStep = step / 2
    local otherStep = (1 - firstStep) / (#self.rewardList - 1)
    local lastNeedScore = 0
    for i, v in ipairs(self.rewardList) do
      local curStageStep = i == 1 and firstStep or otherStep
      if v.isReward == 1 or score >= v.target then
        progress = progress + curStageStep
        lastNeedScore = v.target
      else
        progress = progress + curStageStep * (score - lastNeedScore) / (v.target - lastNeedScore)
        break
      end
    end
    progress = 1 < progress and 1 or progress
  end
  self.slider:SetValue(progress)
end

function OffSeasonTreasureBoxReward:PlayIconFlyAni(boxArray)
  local boxList = boxArray
  local times = #boxList
  local flyEff = flyObjPath
  if not flyEff then
    return
  end
  local mainui = UIManager:GetInstance():GetWindow(UIWindowNames.UIDispatchTaskMain)
  if not mainui then
    return
  end
  local view = mainui.View
  self.effHit.gameObject:SetActive(false)
  self.sliderEff.gameObject:SetActive(false)
  self:StopTimer()
  self.delay1 = TimerManager:GetInstance():DelayInvoke(function()
    if self.sliderEff then
      self.sliderEff.gameObject:SetActive(true)
      self:ReInit(true)
    end
  end, 0.8)
  self.questFlyEffTimers = {}
  for i = 1, times do
    local index = i
    self.delay2 = TimerManager:GetInstance():DelayInvoke(function()
      self:GameObjectInstantiateAsync(flyEff, function(req)
        local flyCoinObj = req.gameObject
        local trans = flyCoinObj.transform
        trans:SetParent(self.btnScoreIcon.transform, true)
        trans:Set_localScale(1, 1, 1)
        trans:Set_localPosition(0, 0, 0)
        trans:SetParent(view.transform, true)
        local tarPos = trans.localPosition
        trans:Set_localPosition(position3[index].x, position3[index].y, position3[index].z)
        trans:Set_localScale(1, 1, 1)
        local fly = flyCoinObj.gameObject:GetComponent(typeof(CS.UIGoodsFly))
        self.delay3 = TimerManager:GetInstance():DelayInvoke(function()
          if self.textList and self.textList[index] then
            self.textList[index]:SetActive(true)
            self.textList[index]:PlayTextAni(boxList[index])
            self.questFlyEffTimers[index] = TimerManager:GetInstance():DelayInvoke(function()
              self.questFlyEffTimers[index] = nil
              if self.textList and self.textList[index] then
                self.textList[index]:SetActive(false)
              end
            end, 0.75)
          end
        end, 0.7 + 0.08 * (i - 1))
        self.delay4 = TimerManager:GetInstance():DelayInvoke(function()
          if self.effHit then
            self.effHit.gameObject:SetActive(true)
          end
        end, fly.moveTime + 0.35)
        fly:DoParabolaAnimLocal(tarPos, trans.localPosition, function()
          req:Destroy()
        end)
      end)
    end, (i - 1) * 0.1)
  end
end

function OffSeasonTreasureBoxReward:OnBtnClick(btnInfo, yPox, preferTop, addX)
  local param = DataCenter.ArrowTipParamManager:Get(ArrowTipEnumtype.Type.TreasureBoxTimeTip)
  param.content = "Treasure_map_73"
  param.alignObject = btnInfo
  param.yPosFix = yPox
  param.addPosX = addX * CommonUtil.ArabicAutoMirrorFactor()
  param.showArrow = true
  param.preferTop = preferTop
  param.width = 200
  param.unEnableTouchThrough = true
  param.countDown = 3
  local nextWeek = UITimeManager:GetInstance():GetNextWeekDay(1)
  local curTime = UITimeManager:GetInstance():GetServerTime()
  param.time = nextWeek - curTime
  UIManager:GetInstance():OpenWindow(UIWindowNames.UICommonSimpleTipView, {anim = true}, param)
end

return OffSeasonTreasureBoxReward
