local UIParkourMysteryTreasureBattleLoseView = BaseClass("UIParkourMysteryTreasureBattleLoseView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local UIGrowthList = require("UI.UIParkour.LoseUI.Component.UIParkourBattleResultGrowthList")
local UIStatisticList = require("UI.UIParkour.WinUI.Component.UIParkourBattleStatisticHeroList")
local UIGrowthListZombieBattle = require("UI.UIZombieBattleLose.Component.UIZombieBattleResultGrowthList")
local UIStatisticListZombieBattle = require("UI.UIZombieBattleLose.Component.UIZombieBattleStatisticHeroList")

function UIParkourMysteryTreasureBattleLoseView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:RefreshView()
  self.waitingForMsg = false
end

function UIParkourMysteryTreasureBattleLoseView:OnDestroy()
  self:RevertBuffInfoPos()
  if self.delayCheck then
    self.delayCheck:Stop()
    self.delayCheck = nil
  end
  self:ClearAllDelayTimers()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

local failGuideLevels = {
  [13001] = true,
  [13002] = true,
  [13003] = true
}

function UIParkourMysteryTreasureBattleLoseView:ComponentDefine()
  self.canvasGroup = self.transform:Find("Root").gameObject:GetComponent(typeof(CS.UnityEngine.CanvasGroup))
  self.tryAgainBtn = self:AddComponent(UIButton, "Root/btnLayout/TryAgainBtn")
  self.tryAgainBtn:SetOnClick(function()
    self:OnTryAgainBtnClick()
  end)
  self.tryAgainBtnText = self:AddComponent(UIText, "Root/btnLayout/TryAgainBtn/TryAgainBtnText")
  self.tryAgainBtnText:SetText(Localization:GetString("134021"))
  self.backBtn = self:AddComponent(UIButton, "Root/btnLayout/BackBtn")
  self.backBtn:SetOnClick(function()
    self:OnBackBtnClick()
  end)
  self.backBtnText = self:AddComponent(UIText, "Root/btnLayout/BackBtn/BackBtnText")
  self.backBtnText:SetText(Localization:GetString("800306"))
  self.defeatText = self:AddComponent(UIText, "Root/Top/BattleDefeatPanel_ani/DefeatGo/DefeatText")
  self.defeatText:SetText(Localization:GetString("311106"))
  self.levelText = self:AddComponent(UIText, "Root/Top/LevelText")
  self.getObj = self.transform:Find("Root/Top/GetCoin").gameObject
  self.getIcon = self:AddComponent(UIImage, "Root/Top/GetCoin/GetCoinIcon")
  self.getCount = self:AddComponent(UITextMeshProUGUIEx, "Root/Top/GetCoin/Numbers/GetCoinCount")
  self.totalCount = self:AddComponent(UITextMeshProUGUIEx, "Root/Top/GetCoin/Numbers/TotalCoinCount")
  self.needObj = self.transform:Find("Root/Top/NeedCoin").gameObject
  self.needIcon = self:AddComponent(UIImage, "Root/Top/NeedCoin/NeedCoinIcon")
  self.needCount = self:AddComponent(UITextMeshProUGUIEx, "Root/Top/NeedCoin/NeedCoinCount")
  self.remainSolider = self:AddComponent(UIBaseContainer, "Root/Top/LevelRemainSolider")
  self.remainSoliderTitle = self:AddComponent(UIText, "Root/Top/LevelRemainSolider/LevelRemainTitle")
  self.remainSoliderTitle:SetText(Localization:GetString("activity_breakthrough_tips_24"))
  self.remainSoliderCount = self:AddComponent(UIText, "Root/Top/LevelRemainSolider/LevelRemainCount")
  self.totalRemainSolider = self:AddComponent(UIBaseContainer, "Root/Top/TotalRemainSolider")
  self.totalRemainSoliderTitle = self:AddComponent(UIText, "Root/Top/TotalRemainSolider/TotalRemainTitle")
  self.totalRemainSoliderTitle:SetText(Localization:GetString("activity_breakthrough_tips_25"))
  self.totalRemainSoliderCount = self:AddComponent(UIText, "Root/Top/TotalRemainSolider/TotalRemainCount")
  self.stillNeedSoldier = self:AddComponent(UIBaseContainer, "Root/Top/StillNeedSolider")
  self.stillNeedSoliderTxt = self:AddComponent(UIText, "Root/Top/StillNeedSolider/StillNeedTxt")
  self.space = self:AddComponent(UIBaseContainer, "Root/space")
  self.emptyGroupContainer = self:AddComponent(UIBaseContainer, "Root/emptyGroup")
  self.emptyGroupContainer:SetActive(false)
  self.tabRoot = self:AddComponent(UIBaseContainer, "Root/Tabs")
  self.tabBtns = {
    self:AddComponent(UIButton, "Root/Tabs/GuideBtn"),
    self:AddComponent(UIButton, "Root/Tabs/MakeBtn"),
    self:AddComponent(UIButton, "Root/Tabs/TakeBtn")
  }
  for i, tabBtn in ipairs(self.tabBtns) do
    local idx = i
    tabBtn:SetOnClick(function()
      self:OnTabBtnClick(idx)
    end)
  end
  local param = self:GetUserData()
  local feature = DataCenter.StageFeatureBuildingManager:GetStageFeatureBuildingTemplate(param.featureId)
  local index = 1
  if 1 < #feature.winType then
    index = table.indexof(feature.stages, param.stageId)
  end
  if feature.caty[index] == "0" then
    self.tabComps = {
      self:AddComponent(UIGrowthListZombieBattle, "Root/GrowGuideScroll", self.ctrl, self),
      self:AddComponent(UIStatisticListZombieBattle, "Root/MakeDmgScroll", "makeDmg"),
      self:AddComponent(UIStatisticListZombieBattle, "Root/TakeDmgScroll", "takeDmg")
    }
  else
    self.tabComps = {
      self:AddComponent(UIGrowthList, "Root/GrowGuideScroll", self.ctrl, self),
      self:AddComponent(UIStatisticList, "Root/MakeDmgScroll", "makeDmg"),
      self:AddComponent(UIStatisticList, "Root/TakeDmgScroll", "takeDmg")
    }
  end
  self.tabIdx = 1
  self.highlightMask = self:AddComponent(UIBaseContainer, "Root/Tabs/Highlight/Mask")
  self.highlightInner = self:AddComponent(UIBaseContainer, "Root/Tabs/Highlight/Mask/Inner")
  self.highlightMask:SetAnchoredPositionXY(0, -1)
  self.highlightInner:SetAnchoredPositionXY(0, 0)
  self.transform:Find("Root/Tabs/GuideBtn/BtnText"):GetComponent(typeof(CS.TextMeshProUGUIEx)).text = CS.GameEntry.Localization:GetString(800799)
  self.transform:Find("Root/Tabs/Highlight/Mask/Inner/GuideBtnHigh/BtnText"):GetComponent(typeof(CS.TextMeshProUGUIEx)).text = CS.GameEntry.Localization:GetString(800799)
  self.transform:Find("Root/Tabs/MakeBtn/BtnText"):GetComponent(typeof(CS.TextMeshProUGUIEx)).text = CS.GameEntry.Localization:GetString(800800)
  self.transform:Find("Root/Tabs/Highlight/Mask/Inner/MakeBtnHigh/BtnText"):GetComponent(typeof(CS.TextMeshProUGUIEx)).text = CS.GameEntry.Localization:GetString(800800)
  self.transform:Find("Root/Tabs/TakeBtn/BtnText"):GetComponent(typeof(CS.TextMeshProUGUIEx)).text = CS.GameEntry.Localization:GetString(800801)
  self.transform:Find("Root/Tabs/Highlight/Mask/Inner/TakeBtnHigh/BtnText"):GetComponent(typeof(CS.TextMeshProUGUIEx)).text = CS.GameEntry.Localization:GetString(800801)
  self.buffGoto = self:AddComponent(UIImage, "Root/BuffGoto")
  self.buffIcon = self:AddComponent(UIImage, "Root/BuffGoto/BuffIcon")
  self.buffName = self:AddComponent(UITextMeshProUGUIEx, "Root/BuffGoto/BuffName")
  self.buffDesc = self:AddComponent(UITextMeshProUGUIEx, "Root/BuffGoto/BuffDesc")
  self.buffNeed = self:AddComponent(UITextMeshProUGUIEx, "Root/BuffGoto/BuffNeed")
  self.buffGotoBtn = self:AddComponent(UIButton, "Root/BuffGoto/GotoBtn")
end

function UIParkourMysteryTreasureBattleLoseView:ComponentDestroy()
  self.backBtn = nil
  self.getObj = nil
  self.getIcon = nil
  self.getCount = nil
  self.needObj = nil
  self.needIcon = nil
  self.needCount = nil
  self.totalCount = nil
  self.remainSolider = nil
  self.remainSoliderTitle = nil
  self.remainSoliderCount = nil
  self.totalRemainSolider = nil
  self.totalRemainSoliderTitle = nil
  self.totalRemainSoliderCount = nil
  self.stillNeedSoldier = nil
  self.stillNeedSoliderTxt = nil
  self.space = nil
  self.emptyGroupContainer = nil
  self.tryAgainBtn = nil
  self.levelText = nil
  self.tryAgainBtnText = nil
  self.backBtnText = nil
  self.tabRoot = nil
  self.tabBtns = nil
  self.tabComps = nil
  self.highlightMask = nil
  self.highlightInner = nil
  self.buffGoto = nil
  self.buffIcon = nil
  self.buffName = nil
  self.buffDesc = nil
  self.buffNeed = nil
  self.buffGotoBtn:SetOnClick(nil)
  self.buffGotoBtn = nil
end

function UIParkourMysteryTreasureBattleLoseView:OnTabBtnClick(idx)
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
  end, (self.tabIdx - 1) * 223 * (CommonUtil.IsArabicAutoMirrorOpen() and -1 or 1), 0.5):SetEase(CS.DG.Tweening.Ease.OutQuint)
end

function UIParkourMysteryTreasureBattleLoseView:OnRefreshFirstPay()
  self:RefreshView()
end

function UIParkourMysteryTreasureBattleLoseView:RefreshView()
  local param = self:GetUserData()
  self.levelText.gameObject:SetActive(true)
  self.backBtn:SetActive(true)
  local feature = DataCenter.StageFeatureBuildingManager:GetStageFeatureBuildingTemplate(param.featureId)
  local index = 1
  if 1 < #feature.winType then
    index = table.indexof(feature.stages, param.stageId)
  end
  local stageIndex = table.indexof(feature.stages, param.stageId)
  if feature.winType[index] == 1 then
    self.tabRoot:SetActive(false)
    for i, tabComp in ipairs(self.tabComps) do
      tabComp:SetActive(false)
    end
    self.getObj:SetActive(true)
    self.needObj:SetActive(true)
    self.remainSolider.gameObject:SetActive(false)
    self.totalRemainSolider.gameObject:SetActive(false)
    self.stillNeedSoldier.gameObject:SetActive(false)
    self.getIcon:LoadSprite("Assets/Main/Sprites/ItemIcons/itemCoin.png")
    self.needIcon:LoadSprite("Assets/Main/Sprites/ItemIcons/itemCoin.png")
    local goldCount = self:GetGoldCount() or 0
    local needCount = feature.winNeedCount[index]
    if goldCount then
      self.getCount:SetText(goldCount)
      self.totalCount:SetText(tostring(needCount))
      if goldCount < needCount then
        local content = tostring(needCount - goldCount)
        self.needCount:SetText(content)
      else
        self.needCount:SetText("0")
      end
    end
    self.buffGoto.gameObject:SetActive(false)
    self.levelText:SetLocalText("newbies_fuben_title")
    PostEventLog.Track(PostEventLog.Defines.NewbiesMysteryTreasureBattleLose, {
      param1 = tostring(goldCount)
    })
  elseif feature.winType[index] == 2 then
    self.tabRoot:SetActive(false)
    for i, tabComp in ipairs(self.tabComps) do
      tabComp:SetActive(false)
    end
    if #feature.winType == 1 then
      if #feature.stages == 1 then
        self.levelText.gameObject:SetActive(true)
        self.levelText:SetLocalText("newbies_fuben_title")
        self.getObj:SetActive(true)
        self.needObj:SetActive(true)
        self.getIcon:LoadSprite("Assets/Main/Sprites/UI/UIBuildBubble/cfm_zhujiemian_qipao_zaobing.png")
        self.needIcon:LoadSprite("Assets/Main/Sprites/UI/UIBuildBubble/cfm_zhujiemian_qipao_zaobing.png")
        self.remainSolider.gameObject:SetActive(false)
        self.totalRemainSolider.gameObject:SetActive(false)
        local currentCount = param.remainNumber
        local needCount = feature.winNeedCount[index]
        self.getCount:SetText(currentCount)
        self.totalCount:SetText(tostring(needCount))
        if currentCount < needCount then
          local content = tostring(needCount - currentCount)
          self.needCount:SetText(content)
        else
          self.needCount:SetText("0")
        end
      else
        local content = Localization:GetString("newbies_fuben_title")
        self.levelText.gameObject:SetActive(true)
        self.levelText:SetText(string.format("%s %d/%d", content, stageIndex, #feature.stages))
        self.getObj:SetActive(false)
        self.needObj:SetActive(false)
        self.remainSolider.gameObject:SetActive(true)
        self.totalRemainSolider.gameObject:SetActive(true)
        self.stillNeedSoldier.gameObject:SetActive(true)
        self.remainSoliderCount:SetText(string.format("X %d", param.remainNumber or 0))
        self.totalRemainSoliderCount:SetText(string.format("%d", param.remainTotalNumber or 0) .. "/" .. tostring(param.needTotalNumber))
        if param.needTotalNumber > param.remainTotalNumber then
          local content = Localization:GetString("newbies_fuben_fail_tips1") .. tostring(param.needTotalNumber - param.remainTotalNumber)
          self.stillNeedSoliderTxt:SetText(content)
        else
          local content = Localization:GetString("newbies_fuben_fail_tips1") .. "0"
          self.stillNeedSoliderTxt:SetText(content)
        end
      end
    end
  elseif feature.winType[index] == 0 then
    self.levelText.gameObject:SetActive(true)
    self.getObj:SetActive(false)
    self.needObj:SetActive(false)
    self.remainSolider.gameObject:SetActive(false)
    self.totalRemainSolider.gameObject:SetActive(false)
    self.stillNeedSoldier.gameObject:SetActive(false)
    local showStatistic = param.showStatistic
    if showStatistic then
      self.tabRoot:SetActive(true)
      for i, tabComp in ipairs(self.tabComps) do
        if i == self.tabIdx then
          tabComp:SetActive(true)
          tabComp:RefreshView()
          tabComp:FadeIn()
        else
          tabComp:SetActive(false)
        end
      end
    else
      self.tabRoot:SetActive(false)
      for i, tabComp in ipairs(self.tabComps) do
        tabComp:SetActive(false)
      end
    end
    self.buffGoto.gameObject:SetActive(false)
    PostEventLog.Track(PostEventLog.Defines.NewbiesMysteryTreasureBattleLose)
  end
end

function UIParkourMysteryTreasureBattleLoseView:GetGoldCount()
  local logic = DataCenter.LWBattleManager.logic
  if logic and logic.GetGoods then
    local goods = logic:GetGoods()
    if goods and goods[2] then
      return goods[2]
    end
  end
end

function UIParkourMysteryTreasureBattleLoseView:OnBackBtnClick()
  if self.waitingForMsg then
    return
  end
  self.ctrl:CloseSelf()
  local param = self:GetUserData()
  local feature = DataCenter.StageFeatureBuildingManager:GetStageFeatureBuildingTemplate(param.featureId)
  local index = 1
  if 1 < #feature.winType then
    index = table.indexof(feature.stages, param.stageId)
  end
  if feature.caty[index] == "0" then
    DataCenter.ZombieBattleManager:Exit(nil, PveExitType.ExitBtn)
  else
    DataCenter.LWBattleManager:GetCurBattleLogic():NoticeLose()
    DataCenter.LWBattleManager:Exit(nil, "lose")
    DataCenter.StageFeatureBuildingManager:OnExitBattle(param.buildUuid)
  end
  PostEventLog.Track(PostEventLog.Defines.BattleParkourSkip, {
    stageId = myStageId,
    isSkip = 2
  })
end

function UIParkourMysteryTreasureBattleLoseView:RevertBuffInfoPos()
  local target = self.transform:Find("Root/TakeDmgScroll")
  if target and self.buffGoto.transform.parent ~= target.parent then
    self.buffGoto.transform:SetParent(target.parent)
    local index = target:GetSiblingIndex()
    self.buffGoto.transform:SetSiblingIndex(index + 1)
  end
end

function UIParkourMysteryTreasureBattleLoseView:SetBuffInfoToGrowGuideScroll()
  local parent = self.transform:Find("Root/GrowGuideScroll/Viewport/Content")
  if self.buffGoto.transform.parent ~= parent then
    self.buffGoto.transform:SetParent(parent)
    self.buffGoto.transform:SetAsFirstSibling()
  end
end

function UIParkourMysteryTreasureBattleLoseView:OnTryAgainBtnClick()
  if self.waitingForMsg then
    return
  end
  self.ctrl:CloseSelf()
  local battleLogic = DataCenter.LWBattleManager:GetCurBattleLogic()
  local stageId = battleLogic:GetStageId()
  local param = self:GetUserData()
  local feature = DataCenter.StageFeatureBuildingManager:GetStageFeatureBuildingTemplate(param.featureId)
  local index = 1
  if 1 < #feature.winType then
    index = table.indexof(feature.stages, param.stageId)
  end
  if feature.caty[index] == "0" then
    battleLogic:OnBattleLose()
  else
    battleLogic:NoticeLose()
  end
  DataCenter.StageFeatureBuildingManager:OnExitBattle(param.buildUuid)
  if #feature.winType == 1 then
    if #feature.stages == 1 then
      DataCenter.LWBattleManager:Restart()
    else
      DataCenter.StageFeatureBuildingManager:OnEnterBattle(param.buildUuid)
    end
  elseif feature.caty[index] == "0" then
    DataCenter.ZombieBattleManager:OnBattleLose()
    DataCenter.ZombieBattleManager:Destroy()
    DataCenter.ZombieBattleManager:Enter(param)
  else
    DataCenter.LWBattleManager:Restart()
  end
  PostEventLog.Track(PostEventLog.Defines.BattleParkourSkip, {
    stageId = tostring(stageId),
    isSkip = 1
  })
end

function UIParkourMysteryTreasureBattleLoseView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.OnKeyCodeEscape, self.OnKeyCodeEscape)
  self:AddUIListener(EventId.OnPackageInfoUpdated, self.OnRefreshFirstPay)
end

function UIParkourMysteryTreasureBattleLoseView:OnRemoveListener()
  self:RemoveUIListener(EventId.OnKeyCodeEscape, self.OnKeyCodeEscape)
  self:RemoveUIListener(EventId.OnPackageInfoUpdated, self.OnRefreshFirstPay)
  base.OnRemoveListener(self)
end

function UIParkourMysteryTreasureBattleLoseView:OnKeyCodeEscape()
  self:CreateDelayTimer(function()
    self:OnBackBtnClick()
  end, 1)
end

function UIParkourMysteryTreasureBattleLoseView:CreateDelayTimer(callback, delay, timerName)
  if self.delayTimers == nil then
    self.delayTimers = {}
  end
  timerName = timerName or "timer_" .. tostring(#self.delayTimers + 1)
  local timer = TimerManager:GetInstance():DelayInvoke(function()
    if self.delayTimers[timerName] then
      self.delayTimers[timerName] = nil
    end
    callback()
  end, delay)
  self.delayTimers[timerName] = timer
  return timer
end

function UIParkourMysteryTreasureBattleLoseView:ClearAllDelayTimers()
  if self.delayTimers then
    for name, timer in pairs(self.delayTimers) do
      if timer then
        timer:Stop()
      end
    end
    self.delayTimers = {}
  end
end

return UIParkourMysteryTreasureBattleLoseView
