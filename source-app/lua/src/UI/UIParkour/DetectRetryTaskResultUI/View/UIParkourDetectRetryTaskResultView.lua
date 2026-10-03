local UIParkourDetectRetryTaskResultView = BaseClass("UIParkourDetectRetryTaskResultView", UIBaseView)
local UISoldierItem = require("UI/UIBuildDispatching/Component/UISoldierItem")
local base = UIBaseView
local Localization = CS.GameEntry.Localization

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
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
  self.textTitle = self:AddComponent(UITextMeshProUGUIEx, "Layout/Title/VictoryGo/VictoryText")
  self.textClaimBtn = self:AddComponent(UITextMeshProUGUIEx, "Layout/BtnGroup/ClaimBtn/ClaimBtnText")
  self.btnClaim = self:AddComponent(UIButton, "Layout/BtnGroup/ClaimBtn")
  self.btnClaim:SetOnClick(function()
    self:OnBtnClaimClick()
  end)
  self.btnRetry = self:AddComponent(UIButton, "Layout/BtnGroup/RetryBtn")
  self.btnRetry:SetOnClick(function()
    self:OnBtnRetryClick()
  end)
  self.textRetryBtn = self:AddComponent(UITextMeshProUGUIEx, "Layout/BtnGroup/RetryBtn/RetryBtnText")
  self.textTip1 = self:AddComponent(UIText, "Layout/MidPanel/TipPanel/TipText1")
  self.icon1 = self:AddComponent(UIBaseComponent, "Layout/MidPanel/TipPanel/Icon1")
  self.textTip2 = self:AddComponent(UIText, "Layout/MidPanel/TipPanel/TipText2")
  self.textTip3 = self:AddComponent(UIText, "Layout/MidPanel/TipPanel/TipText3")
  self.resItem = self:AddComponent(UICommonResItem, "Layout/MidPanel/ResItem")
  self.soldierItem = self:AddComponent(UISoldierItem, "Layout/MidPanel/SoldierItem")
  self.textTitle:SetLocalText("monopoly_bonus_reward_01")
  self.textClaimBtn:SetLocalText("monopoly_bonus_reward_05")
  self.textRetryBtn:SetLocalText("monopoly_bonus_reward_06")
  self.btnBack = self:AddComponent(UIButton, "Layout/BackBtn")
  self.btnBack:SetOnClick(function()
    self:OnBtnBackClick()
  end)
end

local function ComponentDestroy(self)
  self.textTitle = nil
  self.textClaimBtn = nil
  self.btnClaim = nil
  self.btnRetry = nil
  self.textRetryBtn = nil
  self.textTip1 = nil
  self.icon1 = nil
  self.textTip2 = nil
  self.textTip3 = nil
  self.resItem = nil
  self.soldierItem = nil
  self.btnBack = nil
end

local function DataDefine(self)
  self.param = self:GetUserData()
  self.collectType = self.param.collectType
  self.resultCacheNum = self.param.resultCacheNum
  self.resultMaxNum = self.param.resultMaxNum
  self.resultRewardNum = self.param.resultRewardNum
  self:Refresh()
end

local function DataDestroy(self)
  self.param = nil
  self.collectType = nil
  self.resultCacheNum = nil
  self.resultMaxNum = nil
  self.resultRewardNum = nil
end

local function OnAddListener(self)
  base.OnAddListener(self)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
end

local function OnBtnClaimClick(self)
  local curTime = UITimeManager:GetInstance():GetServerTime()
  if curTime <= self.param.endTime then
    self.ctrl:CloseSelf()
    DataCenter.LWBattleManager:GetCurBattleLogic():NoticeWin()
    DataCenter.LWBattleManager:Exit(nil, "win")
  else
    self.ctrl:CloseSelf()
    DataCenter.LWBattleManager:GetCurBattleLogic():NoticeLose()
    DataCenter.LWBattleManager:Exit(nil, "quit")
    UIUtil.ShowTipsId("new_detect_tips_7")
  end
end

local function OnBtnRetryClick(self)
  local curTime = UITimeManager:GetInstance():GetServerTime()
  if self.param.endTime >= curTime + 30000 then
    self.ctrl:CloseSelf()
    DataCenter.LWBattleManager:GetCurBattleLogic():NoticeLose()
    DataCenter.LWBattleManager:Restart()
  else
    self.ctrl:CloseSelf()
    DataCenter.LWBattleManager:GetCurBattleLogic():NoticeLose()
    DataCenter.LWBattleManager:Exit(nil, "quit")
    UIUtil.ShowTipsId("new_detect_tips_7")
  end
end

local function OnBtnBackClick(self)
  self.ctrl:CloseSelf()
  DataCenter.LWBattleManager:GetCurBattleLogic():NoticeLose()
  DataCenter.LWBattleManager:Exit(nil, "quit")
end

local function Refresh(self)
  local titleId, metId, unMetId
  if self.collectType == DetectEventRetryTaskCollectType.Soldier then
    self.soldierItem:SetActive(true)
    self.resItem:SetActive(false)
    self.icon1:SetActive(true)
    local maxLevelSoldier = DataCenter.SoldierDataManager:GetCanTrainHighestLevelSoldier()
    local soldierId
    if maxLevelSoldier then
      soldierId = maxLevelSoldier.id
    else
      soldierId = DataCenter.SoldierDataManager:GetSoldierIdByLevel(1)
    end
    local soldierData = {}
    soldierData.id = soldierId
    soldierData.count = self.resultRewardNum
    self.soldierItem:SetData(soldierData, T11Util.GetSelfCurSoldierData())
    titleId = "new_detect_tips_1"
    metId = "new_detect_tips_2"
    unMetId = "new_detect_tips_3"
  else
    self.soldierItem:SetActive(false)
    self.resItem:SetActive(true)
    self.icon1:SetActive(false)
    local oneData = {}
    oneData.rewardType = RewardType.RESOURCE
    oneData.count = self.resultRewardNum
    oneData.itemId = DetectEventRetryTaskCollectType2ResourceType[self.collectType]
    self.resItem:ReInit(oneData)
    titleId = "new_detect_tips_4"
    metId = "new_detect_tips_5"
    unMetId = "new_detect_tips_6"
  end
  self.textTip1:SetLocalText(titleId)
  local str
  if self.resultCacheNum < self.resultMaxNum then
    str = "<color=#F97077>%s</color>/%s"
    self.textTip3:SetLocalText(unMetId)
    self.btnRetry:SetActive(true)
  else
    str = "%s/<size=80%%>%s</size>"
    self.textTip3:SetLocalText(metId)
    self.btnRetry:SetActive(false)
  end
  self.textTip2:SetText(string.format(str, self.resultCacheNum, self.resultMaxNum))
end

UIParkourDetectRetryTaskResultView.OnCreate = OnCreate
UIParkourDetectRetryTaskResultView.OnDestroy = OnDestroy
UIParkourDetectRetryTaskResultView.OnEnable = OnEnable
UIParkourDetectRetryTaskResultView.OnDisable = OnDisable
UIParkourDetectRetryTaskResultView.ComponentDefine = ComponentDefine
UIParkourDetectRetryTaskResultView.ComponentDestroy = ComponentDestroy
UIParkourDetectRetryTaskResultView.DataDefine = DataDefine
UIParkourDetectRetryTaskResultView.DataDestroy = DataDestroy
UIParkourDetectRetryTaskResultView.OnAddListener = OnAddListener
UIParkourDetectRetryTaskResultView.OnRemoveListener = OnRemoveListener
UIParkourDetectRetryTaskResultView.OnBtnClaimClick = OnBtnClaimClick
UIParkourDetectRetryTaskResultView.OnBtnRetryClick = OnBtnRetryClick
UIParkourDetectRetryTaskResultView.OnBtnBackClick = OnBtnBackClick
UIParkourDetectRetryTaskResultView.Refresh = Refresh
return UIParkourDetectRetryTaskResultView
