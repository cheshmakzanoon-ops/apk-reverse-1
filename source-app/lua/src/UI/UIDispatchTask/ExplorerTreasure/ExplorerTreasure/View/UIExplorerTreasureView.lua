local UIExplorerTreasureView = BaseClass("UIExplorerTreasureView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local Setting = CS.GameEntry.Setting
local UICommonTipsView = require("UI.UICommonTips.View.UICommonTipsView")

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:InitView()
  PostEventLog.Track(PostEventLog.Defines.OpenExplorerTreasureView, {})
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
  self.btnPanel = self:AddComponent(UIButton, "panel")
  self.btnPanel:SetOnClick(function()
    self:OnBtnPanelClick()
  end)
  self.itemTemplate = self:AddComponent(UIBaseContainer, "content/ItemScroll/item")
  self.textCurItemNum = self:AddComponent(UITextMeshProUGUIEx, "top/textLeftNum")
  self.textDes1 = self:AddComponent(UITextMeshProUGUIEx, "content/mid/textDes1")
  self.textDes2 = self:AddComponent(UITextMeshProUGUIEx, "content/mid/textDes2")
  self.textCountDown = self:AddComponent(UITextMeshProUGUIEx, "content/mid/textCountDown")
  self.textBtnDes = self:AddComponent(UITextMeshProUGUIEx, "content/bottom/OpenBtn/des")
  self.textNeedNum = self:AddComponent(UITextMeshProUGUIEx, "content/bottom/OpenBtn/num")
  self.compContent = self:AddComponent(UIBaseContainer, "content/ItemScroll/Viewport/Content")
  self.textBoxPercentTxt = self:AddComponent(UITextMeshProUGUIEx, "content/boxInfo/Content/boxPercentTxt")
  self.textOneClickDes = self:AddComponent(UITextMeshProUGUIEx, "content/bottom/backToggle/Text")
  self.toggle = self:AddComponent(UIToggle, "content/bottom/backToggle")
  self.btnOpen = self:AddComponent(UIButton, "content/bottom/OpenBtn")
  self.btnOpen:SetOnClick(function()
    self:OnBtnOpenClick()
  end)
  self.btnBoxInfo = self:AddComponent(UIButton, "content/boxInfo/Content/boxImage")
  self.btnBoxInfo:SetOnClick(function()
    self:OnBtnBoxInfoClick()
  end)
  self.btnPreviewReward = self:AddComponent(UIButton, "content/btnPreviewReward")
  self.btnPreviewReward:SetOnClick(function()
    self:OnBtnPreviewRewardClick()
  end)
  self.sliderBox = self:AddComponent(UISlider, "content/boxInfo/Content/boxSlider")
  self.btnClose = self:AddComponent(UIButton, "content/CloseBtn")
  self.btnClose:SetOnClick(function()
    self:OnBtnCloseClick()
  end)
  self.objRedDot = self:AddComponent(UIBaseContainer, "content/bottom/OpenBtn/RedDot")
  self.textDes1:SetLocalText("explorer_treasure_activity_name_01")
  self.textDes2:SetLocalText(130340)
  self.textBtnDes:SetLocalText("explorer_treasure_activity_des_02")
  self.textOneClickDes:SetLocalText("explorer_treasure_activity_des_03")
  self.itemTemplate.gameObject:GameObjectCreatePool()
  self.toggle:SetOnValueChanged(function(tf)
    self.bIsOneClick = tf
    Setting:SetBool("ExplorerTreasureAutoOpen", self.bIsOneClick)
  end)
end

local function InitView(self)
  self:InitItem()
  self:UpdateTimeText()
  self:Refresh()
  self.toggle:SetIsOn(self.bIsOneClick)
  self.textNeedNum:SetText(self.nNeedItemNum)
end

local function InitItem(self)
  self.itemTemplate.gameObject:GameObjectRecycleAll()
  self.tItemList = {}
  for i = 1, self.nNeedItemNum do
    local item = self.itemTemplate.gameObject:GameObjectSpawn(self.compContent.transform)
    item.gameObject:SetActive(true)
    item.name = i
    self.tItemList[i] = {}
    self.tItemList[i].trans = item.transform
    self.tItemList[i].img = item.transform:Find("imgkey"):GetComponent(typeof(CS.UnityEngine.UI.Image))
  end
end

local function Refresh(self)
  local nHaveNum = DataCenter.ExplorerTreasureManager:GetTreasureHaveItemNum()
  self.textCurItemNum:SetText(nHaveNum)
  for i = 1, self.nNeedItemNum do
    self.tItemList[i].img.gameObject:SetActive(false)
  end
  local nGuaranteedNeedTimes = DataCenter.ExplorerTreasureManager:GetGuaranteedNeedTimes()
  local nCurTimes = DataCenter.ExplorerTreasureManager:GetGuaranteedTimes()
  local nPercent = Mathf.Clamp01(nCurTimes / nGuaranteedNeedTimes)
  self.sliderBox:SetValue(nPercent)
  local sColorStr = nCurTimes == nGuaranteedNeedTimes and "5FEF87" or "FFFFFF"
  self.textBoxPercentTxt:SetText(string.format("<color=#%s>%s</color>/%s", sColorStr, nCurTimes, nGuaranteedNeedTimes))
  local nRedCount = DataCenter.ExplorerTreasureManager:GetRedPointCount()
  self.objRedDot:SetActive(0 < nRedCount)
end

local function Update1000MS(self)
end

local function UpdateTimeText(self)
  if self.nEndTime <= 0 then
    return
  end
  local nCurTime = UITimeManager:GetInstance():GetServerTime()
  local nLeftTime = self.nEndTime - nCurTime
  self.textCountDown:SetText(UITimeManager:GetInstance():MilliSecondToFmtString(nLeftTime))
end

local function ComponentDestroy(self)
  self.itemTemplate.gameObject:GameObjectRecycleAll()
  self.btnPanel = nil
  self.itemTemplate = nil
  self.textCurItemNum = nil
  self.textDes1 = nil
  self.textDes2 = nil
  self.textCountDown = nil
  self.textBtnDes = nil
  self.textNeedNum = nil
  self.compContent = nil
  self.textBoxPercentTxt = nil
  self.textOneClickDes = nil
  self.toggle = nil
  self.btnOpen = nil
  self.btnBoxInfo = nil
  self.btnPreviewReward = nil
  self.sliderBox = nil
  self.btnClose = nil
  self.objRedDot = nil
end

local function DataDefine(self)
  local tActivityData = DataCenter.ExplorerTreasureManager:GetExplorerTreasureActivityData()
  self.nEndTime = tActivityData[1].endTime or 0
  self.nNeedItemNum = DataCenter.ExplorerTreasureManager:GetTreasureOpenNeedItemNum()
  self.nItemId = DataCenter.ExplorerTreasureManager:GetTreasureItemId()
  self.bIsOneClick = Setting:GetBool("ExplorerTreasureAutoOpen", false)
  self.nSendMsgTime = 0
end

local function DataDestroy(self)
  self.nEndTime = nil
  self.nNeedItemNum = nil
  self.nItemId = nil
  self.nSendMsgTime = nil
  self.bIsOneClick = nil
end

local function OnAddListener(self)
  base.OnAddListener(self)
  self:AddUIListener(EventId.OnGetExplorerTreasureSuccess, self.OnGetExplorerTreasureSuccess)
  self:AddUIListener(EventId.RefreshItems, self.OnGetExplorerTreasureSuccess)
end

local function OnRemoveListener(self)
  self:RemoveUIListener(EventId.OnGetExplorerTreasureSuccess, self.OnGetExplorerTreasureSuccess)
  self:RemoveUIListener(EventId.RefreshItems, self.OnGetExplorerTreasureSuccess)
  base.OnRemoveListener(self)
end

local function OnBtnPanelClick(self)
  self.ctrl.CloseSelf()
end

local function OnBtnCloseClick(self)
  self.ctrl:CloseSelf()
end

local function OnBtnOpenClick(self)
  local nHaveNum = DataCenter.ExplorerTreasureManager:GetTreasureHaveItemNum()
  if nHaveNum < self.nNeedItemNum then
    LWResourceLackUtil:GotoGoodsItemLack(self.nItemId, self.nNeedItemNum - nHaveNum)
    return
  end
  local bIsOpen = DataCenter.ExplorerTreasureManager:IsOpen()
  if not bIsOpen then
    UIUtil.ShowTipsId("370100")
    return
  end
  local nCurTime = UITimeManager:GetInstance():GetServerTime()
  if nCurTime < self.nSendMsgTime + 1000 then
    return
  end
  self.nSendMsgTime = nCurTime
  SFSNetwork.SendMessage(MsgDefines.ExplorerTreasureOpen)
end

local function OnBtnBoxInfoClick(self)
  local tParam = UICommonTipsView.ParamDataClass.New()
  local nNeedNum = DataCenter.ExplorerTreasureManager:GetGuaranteedNeedTimes()
  tParam.content = Localization:GetString("explorer_treasure_activity_des_04", nNeedNum, nNeedNum + 1)
  tParam.position = self.sliderBox:GetPosition()
  tParam.deltaY = 50
  tParam.contentX = -20
  tParam.exe = {}
  tParam.exe.reversal = true
  UIManager:GetInstance():OpenWindow(UIWindowNames.UICommonTips, {anim = false}, tParam)
end

local function OnGetExplorerTreasureSuccess(self)
  self:Refresh()
end

local function OnBtnPreviewRewardClick(self)
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIDispatchTreasureGetBoxReward, {anim = true}, TreasureRewardType.ExplorerTreasure)
end

UIExplorerTreasureView.OnCreate = OnCreate
UIExplorerTreasureView.OnDestroy = OnDestroy
UIExplorerTreasureView.OnEnable = OnEnable
UIExplorerTreasureView.OnDisable = OnDisable
UIExplorerTreasureView.ComponentDefine = ComponentDefine
UIExplorerTreasureView.ComponentDestroy = ComponentDestroy
UIExplorerTreasureView.DataDefine = DataDefine
UIExplorerTreasureView.DataDestroy = DataDestroy
UIExplorerTreasureView.OnAddListener = OnAddListener
UIExplorerTreasureView.OnRemoveListener = OnRemoveListener
UIExplorerTreasureView.OnBtnPanelClick = OnBtnPanelClick
UIExplorerTreasureView.Update1000MS = Update1000MS
UIExplorerTreasureView.UpdateTimeText = UpdateTimeText
UIExplorerTreasureView.Refresh = Refresh
UIExplorerTreasureView.InitView = InitView
UIExplorerTreasureView.OnBtnOpenClick = OnBtnOpenClick
UIExplorerTreasureView.OnBtnBoxInfoClick = OnBtnBoxInfoClick
UIExplorerTreasureView.InitItem = InitItem
UIExplorerTreasureView.Refresh = Refresh
UIExplorerTreasureView.OnGetExplorerTreasureSuccess = OnGetExplorerTreasureSuccess
UIExplorerTreasureView.OnBtnPreviewRewardClick = OnBtnPreviewRewardClick
UIExplorerTreasureView.OnBtnCloseClick = OnBtnCloseClick
return UIExplorerTreasureView
