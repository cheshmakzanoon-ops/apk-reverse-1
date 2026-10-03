local T11IdleGameTaskEventBattleWinView = BaseClass("T11IdleGameTaskEventBattleWinView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local LayoutLayer = "Layout/"
local UIStatisticList = require("UI.UIJeepAdventure.UITowerupBattleLose.Component.UITowerupBattleStatisticHeroList")
local UIBattleRewardList = require("UI.UIJeepAdventure.UITowerupBattleWin.Component.UIBattleRewardList")
local UILWTrainBattleEndScienceContainer = require("UI.UILWRailway.UILWTrainBattleEnd.UILWTrainBattleEndScienceContainer")
local back_toggle_path = "Layout/backToggle"
local checkbox_text = "Layout/backToggle/Text"
local share_btn_path = "Layout/Btns/ShareBtn"
local share_btn_text_path = "Layout/Btns/ShareBtn/ShareBtnText"
local autoWaitTime = 5000
local DynamicAssetName = {
  RewardScroll = "RewardScroll",
  MakeDmgScroll = "MakeDmgScroll",
  TakeDmgScroll = "TakeDmgScroll",
  TrainBattleEndScienceContainer = "TrainBattleEndScienceContainer"
}
local DynamicAsset = {
  [DynamicAssetName.RewardScroll] = {
    prefabPath = "Assets/Main/Prefabs/UI/UIJeepAdventure/LWTowerupBattleRewardScroll.prefab",
    class = UIBattleRewardList,
    parentPath = "Layout"
  },
  [DynamicAssetName.MakeDmgScroll] = {
    prefabPath = "Assets/Main/Prefabs/UI/UIJeepAdventure/LWTowerupBattleMakeDmgScroll.prefab",
    class = UIStatisticList,
    parentPath = "Layout"
  },
  [DynamicAssetName.TakeDmgScroll] = {
    prefabPath = "Assets/Main/Prefabs/UI/UIJeepAdventure/LWTowerupBattleTakeDmgScroll.prefab",
    class = UIStatisticList,
    parentPath = "Layout"
  },
  [DynamicAssetName.TrainBattleEndScienceContainer] = {
    prefabPath = "Assets/Main/Prefabs/UI/UILWRailway/UILWTrainBattleEndScienceContainer.prefab",
    class = UILWTrainBattleEndScienceContainer,
    parentPath = "Layout"
  }
}

function T11IdleGameTaskEventBattleWinView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:Show()
end

function T11IdleGameTaskEventBattleWinView:OnDestroy()
  self:DeleteTimer()
  if not IsNull(self.tabTween) then
    self.tabTween:Kill()
    self.tabTween = nil
  end
  if self.showRewardAnimCo then
    self.showRewardAnimCo = nil
  end
  if self.dynamicReqs then
    for k, v in pairs(self.dynamicReqs) do
      v:Destroy()
    end
    self.dynamicReqs = nil
  end
  self.tabIdx = nil
  self.rewardParam = nil
  self:ComponentDestroy()
  self.tabComps = nil
  base.OnDestroy(self)
end

function T11IdleGameTaskEventBattleWinView:ComponentDefine()
  self.backBtn = self:AddComponent(UIButton, LayoutLayer .. "Btns/BackBtn")
  self.backBtn:SetOnClick(function()
    self:OnBackBtnClick()
  end)
  self.nextBtn = self:AddComponent(UIButton, LayoutLayer .. "Btns/NextBtn")
  self.nextBtn:SetOnClick(function()
    self:OnNextBtnClick()
  end)
  self.share_btn = self:AddComponent(UIButton, share_btn_path)
  self.share_btn:SetOnClick(function()
    self:ShareBtnClick()
  end)
  self.share_btn_text = self:AddComponent(UITextMeshProUGUIEx, share_btn_text_path)
  self.share_btn_text:SetLocalText("truck_btn001")
  self.layout = self:AddComponent(UIBaseContainer, LayoutLayer)
  self.canvasGroup = self.transform:Find(LayoutLayer).gameObject:GetComponent(typeof(CS.UnityEngine.CanvasGroup))
  self.canvasGroup.alpha = 0
  self.victoryText = self:AddComponent(UIText, LayoutLayer .. "Title/VictoryGo/VictoryText")
  self.victoryText:SetText(Localization:GetString("311105"))
  self.levelText = self:AddComponent(UIText, LayoutLayer .. "LevelText")
  self.levelText:SetActive(false)
  self.backBtnText = self:AddComponent(UIText, LayoutLayer .. "Btns/BackBtn/BackBtnText")
  self.backBtnText:SetLocalText("300520")
  self.nextBtnText = self:AddComponent(UIText, LayoutLayer .. "Btns/NextBtn/BtnText")
  local param, battleManagerParam = self:GetUserData()
  self.battleManagerParam = battleManagerParam
  self.nextBtn:SetActive(false)
  self.tabBtns = {
    self:AddComponent(UIButton, "Layout/Tabs/RewardBtn"),
    self:AddComponent(UIButton, "Layout/Tabs/MakeBtn"),
    self:AddComponent(UIButton, "Layout/Tabs/TakeBtn")
  }
  for i, tabBtn in ipairs(self.tabBtns) do
    local idx = i
    tabBtn:SetOnClick(function()
      self:OnTabBtnClick(idx)
    end)
  end
  local rewardScroll = self:AddComponent(DynamicAsset[DynamicAssetName.RewardScroll].class, "Layout/RewardScroll")
  self.tabComps = {
    [1] = {
      assetName = DynamicAssetName.RewardScroll,
      comp = rewardScroll,
      param1 = "reward"
    },
    [2] = {
      assetName = DynamicAssetName.MakeDmgScroll,
      comp = nil,
      param1 = "makeDmg"
    },
    [3] = {
      assetName = DynamicAssetName.TakeDmgScroll,
      comp = nil,
      param1 = "takeDmg"
    }
  }
  self.tabIdx = 1
  self.highlightMask = self:AddComponent(UIBaseContainer, "Layout/Tabs/Highlight/Mask")
  self.highlightInner = self:AddComponent(UIBaseContainer, "Layout/Tabs/Highlight/Mask/Inner")
  self.highlightMask:SetAnchoredPositionXY(0, -1)
  self.highlightInner:SetAnchoredPositionXY(0, 0)
  self.transform:Find("Layout/Tabs/MakeBtn/BtnText"):GetComponent(typeof(CS.TextMeshProUGUIEx)).text = CS.GameEntry.Localization:GetString(800800)
  self.transform:Find("Layout/Tabs/Highlight/Mask/Inner/MakeBtnHigh/BtnText"):GetComponent(typeof(CS.TextMeshProUGUIEx)).text = CS.GameEntry.Localization:GetString(800800)
  self.transform:Find("Layout/Tabs/TakeBtn/BtnText"):GetComponent(typeof(CS.TextMeshProUGUIEx)).text = CS.GameEntry.Localization:GetString(800801)
  self.transform:Find("Layout/Tabs/Highlight/Mask/Inner/TakeBtnHigh/BtnText"):GetComponent(typeof(CS.TextMeshProUGUIEx)).text = CS.GameEntry.Localization:GetString(800801)
  self.transform:Find("Layout/Tabs/RewardBtn/BtnText"):GetComponent(typeof(CS.TextMeshProUGUIEx)).text = CS.GameEntry.Localization:GetString(456808)
  self.transform:Find("Layout/Tabs/Highlight/Mask/Inner/RewardBtnHigh/BtnText"):GetComponent(typeof(CS.TextMeshProUGUIEx)).text = CS.GameEntry.Localization:GetString(456808)
  self.checkbox_text = self:AddComponent(UIText, checkbox_text)
  self.checkbox_text:SetLocalText(456810)
  self.back_toggle = self:AddComponent(UIToggle, back_toggle_path)
  self.back_toggle:SetIsOn(false)
  self.back_toggle:SetOnValueChanged(function(value)
    self:OnToggerChangeFunc(value)
  end)
  self.autoNextStageStartTime = -1
end

function T11IdleGameTaskEventBattleWinView:Show()
  DataCenter.LWSoundManager:PlaySound(10027)
  self.showTimer = TimerManager:GetInstance():DelayInvoke(function()
    if UIManager:GetInstance():IsWindowOpen(UIWindowNames.UIIdleGameTaskEventBattleWin) then
      self.canvasGroup:DOFade(1, 0.2)
    end
  end, 1.5)
  self:OnTabBtnClick(2)
  self:OnGetReward(DataCenter.TowerUpSaveDataManager.saveData)
  self:RefreshAutoNextStageToggerView()
  self:AddTimer()
  self.share_btn:SetActive(false)
end

function T11IdleGameTaskEventBattleWinView:OnTabBtnClick(idx)
  if self.tabIdx == idx then
    return
  end
  self.tabIdx = idx
  self:RefreshView()
  if not IsNull(self.tabTween) then
    self.tabTween:Kill()
    self.tabTween = nil
  end
  self.tabTween = CS.DG.Tweening.DOTween.To(function()
    return self.highlightMask:GetAnchoredPositionX()
  end, function(value)
    self.highlightMask:SetAnchoredPositionXY(value, -1)
    self.highlightInner:SetAnchoredPositionXY(-value, 0)
  end, (self.tabIdx - 1) * 204, 0.5):SetEase(CS.DG.Tweening.Ease.OutQuint)
end

function T11IdleGameTaskEventBattleWinView:DataDefine()
  self.heroId = nil
  self.dynamicReqs = {}
end

function T11IdleGameTaskEventBattleWinView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.TowerupBattleReward, self.OnGetReward)
  self:AddUIListener(EventId.OnKeyCodeEscape, self.OnKeyCodeEscape)
end

function T11IdleGameTaskEventBattleWinView:OnRemoveListener()
  self:RemoveUIListener(EventId.TowerupBattleReward, self.OnGetReward)
  self:RemoveUIListener(EventId.OnKeyCodeEscape, self.OnKeyCodeEscape)
  base.OnRemoveListener(self)
end

function T11IdleGameTaskEventBattleWinView:OnKeyCodeEscape()
  TimerManager:GetInstance():DelayFrameInvoke(function()
    self:OnBackBtnClick()
  end, 1)
end

function T11IdleGameTaskEventBattleWinView:ComponentDestroy()
  self.back_btn = nil
  self.nextBtn = nil
  self.layout = nil
  self.canvasGroup = nil
  self.victoryText = nil
  self.levelText = nil
  self.backBtnText = nil
  self.nextBtnText = nil
  self.battleManagerParam = nil
  self.tabBtns = nil
  self.tabComps = nil
  self.highlightMask = nil
  self.highlightInner = nil
  self.checkbox_text = nil
  self.back_toggle = nil
  self.autoNextStageStartTime = nil
  self.share_btn = nil
  self.share_btn_text = nil
end

function T11IdleGameTaskEventBattleWinView:RefreshView()
  for i, v in ipairs(self.tabComps) do
    local assetName = v.assetName
    local tabComp = v.comp
    if i == self.tabIdx then
      if i == 1 then
        tabComp:SetActive(true)
        tabComp:RefreshView()
        tabComp:FadeIn()
      elseif self.dynamicReqs[assetName] ~= nil then
        if tabComp then
          tabComp:SetActive(true)
          tabComp:FadeIn()
        end
      else
        local req = self:GameObjectInstantiateAsync(DynamicAsset[assetName].prefabPath, function(request)
          if self.tabIdx == nil then
            request:Destroy()
            return
          end
          local go = request.gameObject
          go.name = assetName
          local parentPath = DynamicAsset[assetName].parentPath
          go.transform.parent = self.transform:Find(parentPath)
          local comp = self:AddComponent(DynamicAsset[assetName].class, parentPath .. "/" .. assetName, v.param1, self.battleManagerParam)
          self.tabComps[i].comp = comp
          comp:SetLocalScale(Vector3.one)
          comp:SetAnchorMinXY(0.5, 0)
          comp:SetAnchorMaxXY(0.5, 1)
          comp:SetAnchoredPositionXY(0, -528.06)
          comp:SetSizeDeltaXY(616, -781.66)
          comp:RefreshView()
          if self.tabIdx == i then
            comp:SetActive(true)
            comp:FadeIn()
          else
            comp:SetActive(false)
          end
        end)
        self.dynamicReqs[assetName] = req
      end
    elseif tabComp then
      tabComp:SetActive(false)
    end
  end
  if self.trainBattleEndScienceContainer then
    self.trainBattleEndScienceContainer:SetActive(false)
  end
end

function T11IdleGameTaskEventBattleWinView:OnBackBtnClick()
  local battleManagerParam = self.battleManagerParam
  DataCenter.TowerUpSaveDataManager:SetAutoNextStage(false)
  if battleManagerParam.enterType == PVEEnterType.T11IdleGameBattleEvent then
    if battleManagerParam.type == PVEType.FakePVP then
      self.ctrl:CloseSelf()
      DataCenter.LWBattleManager:Exit(function()
      end)
    end
  else
    self.ctrl:CloseSelf()
    DataCenter.LWBattleManager:Exit()
  end
end

function T11IdleGameTaskEventBattleWinView:OnNextBtnClick()
end

function T11IdleGameTaskEventBattleWinView:OnGetReward(param)
  param = DataCenter.RewardManager:ReturnRewardParamForMessage(param)
  if param == nil then
    return
  end
  self.rewardParam = param
  if self.tabComps[1].comp then
    self.tabComps[1].comp:RefreshView()
  end
end

function T11IdleGameTaskEventBattleWinView:OnToggerChangeFunc(state)
end

function T11IdleGameTaskEventBattleWinView:RefreshAutoNextStageToggerView()
  if self.battleManagerParam.enterType == PVEEnterType.T11IdleGameBattleEvent then
    self.back_toggle:SetActive(false)
  end
end

function T11IdleGameTaskEventBattleWinView:AddTimer()
  if self.timer == nil then
    self.timer = TimerManager:GetInstance():GetTimer(0.5, self.CheckAutoNext, self, false, false, false)
  end
  self.timer:Start()
end

function T11IdleGameTaskEventBattleWinView:DeleteTimer()
  if self.timer ~= nil then
    self.timer:Stop()
    self.timer = nil
  end
  if self.showTimer then
    self.showTimer:Stop()
    self.showTimer = nil
  end
end

function T11IdleGameTaskEventBattleWinView:CheckAutoNext()
  if self.autoNextStageStartTime == nil or self.autoNextStageStartTime <= 0 then
    self.nextBtnText:SetLocalText(456809)
    return
  else
    local curTime = UITimeManager:GetInstance():GetServerTime()
    if curTime > self.autoNextStageStartTime + autoWaitTime then
      self:OnNextBtnClick()
      self.autoNextStageStartTime = -1
    else
      local btnStr = Localization:GetString(456809)
      local showTime = math.floor((self.autoNextStageStartTime + autoWaitTime - curTime) / 1000)
      local btnTimeStr = btnStr .. string.format(" (%s)", showTime)
      self.nextBtnText:SetText(btnTimeStr)
    end
  end
end

function T11IdleGameTaskEventBattleWinView:ShareBtnClick()
end

return T11IdleGameTaskEventBattleWinView
