local UIVip18HistoryView = BaseClass("UIVip18HistoryView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local UIVip18HistoryItem = require("UI.UIVipExtend.UIVip18History.UIVip18HistoryItemComponent")
local HistoryItemHeight = 300
local HistorySpaceHeight = 20

function UIVip18HistoryView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:RefreshNoneHistory()
  self:loadInitialHistory()
end

function UIVip18HistoryView:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIVip18HistoryView:OnEnable()
  base.OnEnable(self)
end

function UIVip18HistoryView:OnDisable()
  base.OnDisable(self)
end

function UIVip18HistoryView:ComponentDefine()
  self.topRoot = self:AddComponent(UIBaseContainer, "Root/MiddleContentContainer/ChannelHolder/gTop")
  self.topRoot:SetActive(true)
  self.compCContent = self:AddComponent(UIBaseContainer, "Root/MiddleContentContainer/ChannelHolder/CScroll/CViewport/CContent")
  self.historyItemPrefab = self.transform:Find("Root/MiddleContentContainer/ChannelHolder/UIVip18HistoryItem").gameObject
  self.historyItemPrefab:GameObjectCreatePool()
  self.textStage = self:AddComponent(UITextMeshProUGUIEx, "Root/MiddleContentContainer/ChannelHolder/gTop/textStage")
  self.imageStage = self:AddComponent(UIImage, "Root/MiddleContentContainer/ChannelHolder/gTop/Image")
  self.btnClose = self:AddComponent(UIButton, "Root/BottomBar/BtnClose")
  self.btnClose:SetOnClick(function()
    self:OnBtnCloseClick()
  end)
  self.btnTop = self:AddComponent(UIButton, "Root/MiddleContentContainer/ChannelHolder/gTop")
  self.btnTop:SetOnClick(function()
    self:OnBtnTopClick()
  end)
  self.btnDown = self:AddComponent(UIButton, "Root/MiddleContentContainer/ChannelHolder/gRightBottom")
  self.btnDown:SetOnClick(function()
    self:OnBtnDownClick()
  end)
  self.btn_vip_service = self:AddComponent(UIButton, "Root/BottomBar/BtnVipService")
  self.btn_vip_service:SetOnClick(function()
    DataCenter.LWCustomerServiceManager:OpenMessage("E018", "vip18_extend_design_aihelp_msg")
  end)
  self.facebookIcon = self:AddComponent(UIImage, "Root/BottomBar/BtnFacebook/Icon")
  self.btn_facebook = self:AddComponent(UIButton, "Root/BottomBar/BtnFacebook")
  self.btn_facebook:SetOnClick(function()
    DataCenter.VipExtendManager:ContactUsByLanguage()
  end)
  self.text_none = self:AddComponent(UITextMeshProUGUIEx, "Root/MiddleContentContainer/ChannelHolder/textNone")
  self.c_scroll = self:AddComponent(UIScrollRect, "Root/MiddleContentContainer/ChannelHolder/CScroll")
end

function UIVip18HistoryView:ComponentDestroy()
  self.compCContent:RemoveComponents(UIVip18HistoryItem)
  self.compCContent = nil
  self.historyItemPrefab:GameObjectRecycleAll()
  self.historyItemPrefab = nil
  self.btnClose = nil
  self.btnTop = nil
  self.textStage = nil
  self.btnDown = nil
  self.facebookIcon = nil
  self.imageStage = nil
  self.c_scroll = nil
end

function UIVip18HistoryView:DataDefine()
  self.previousItemCount = 0
  self.previousOffsetY = 0
  self.previousSizeDeltaY = 0
  self.pageTimer = TimerManager:GetInstance():GetTimer(0.1, self.CheckRequestPage, self, false, false, false)
  self.pageTimer:Start()
  self.historyRecords = {}
  self.isLoading = false
  self.hasMoreRecords = true
  self.oldestTimestamp = 0
  self.recordIdSet = {}
end

function UIVip18HistoryView:DataDestroy()
  if self.pageTimer then
    self.pageTimer:Stop()
    self.pageTimer = nil
  end
end

function UIVip18HistoryView:OnAddListener()
  base.OnAddListener(self)
end

function UIVip18HistoryView:OnRemoveListener()
  base.OnRemoveListener(self)
end

function UIVip18HistoryView:OnBtnCloseClick()
  self.ctrl:CloseSelf()
end

function UIVip18HistoryView:OnBtnTopClick()
  if self.currentItemCount == nil then
    return
  end
  if self.currentItemCount < 1 then
    return
  end
  if self.isLoading then
    return
  end
  self.topRoot:SetActive(false)
  local stage = DataCenter.VipExtendManager:GetVipExtendDesignData().stage
  local index = 0
  for i, v in ipairs(self.historyRecords) do
    if v.stage == stage then
      index = i
      break
    end
  end
  self.compCContent:SetAnchoredPositionXY(0, index * HistoryItemHeight)
end

function UIVip18HistoryView:OnBtnDownClick()
  if self.currentItemCount == nil then
    return
  end
  if self.currentItemCount < 1 then
    return
  end
  self.compCContent:SetAnchoredPositionXY(0, 0)
end

function UIVip18HistoryView:generateRecordId(record)
  return record.sendTime
end

function UIVip18HistoryView:LockScroll()
  self.isLoading = true
  self.speed = self.c_scroll:GetScrollRect().velocity
  self.c_scroll:SetEnable(false)
end

function UIVip18HistoryView:UnlockScroll()
  self.isLoading = false
  self.c_scroll:SetEnable(true)
  self.c_scroll:GetScrollRect().velocity = self.speed
end

function UIVip18HistoryView:fetchHistoryRecords(endTime)
  if self.isLoading then
    return
  end
  self:LockScroll()
  SFSNetwork.SendMessage(MsgDefines.Vip18ProductionHistory, endTime)
end

function UIVip18HistoryView:HistoryRecordsCallback(message)
  if message.historyInfo == nil then
    Logger.Log("historyInfo is nil")
    self:UnlockScroll()
    return
  end
  local newRecords = message.historyInfo or {}
  if #newRecords == 0 then
    self:UnlockScroll()
    self.hasMoreRecords = false
    return
  end
  local addedCount = 0
  for _, record in ipairs(newRecords) do
    local recordId = self:generateRecordId(record)
    if not self.recordIdSet[recordId] then
      self.recordIdSet[recordId] = true
      table.insert(self.historyRecords, record)
      addedCount = addedCount + 1
      if self.oldestTimestamp == 0 or record.sendTime < self.oldestTimestamp then
        self.oldestTimestamp = record.sendTime
      end
    end
  end
  table.sort(self.historyRecords, function(a, b)
    return a.sendTime < b.sendTime
  end)
  self.hasMoreRecords = #newRecords == 20 and 0 < addedCount
  self:RefreshContent()
end

function UIVip18HistoryView:loadInitialHistory()
  self.historyRecords = {}
  self.recordIdSet = {}
  self.oldestTimestamp = 0
  self.hasMoreRecords = true
  self:fetchHistoryRecords(0)
end

function UIVip18HistoryView:loadMoreHistory()
  if not self.hasMoreRecords or self.isLoading or self.oldestTimestamp == 0 then
    return
  end
  self:fetchHistoryRecords(self.oldestTimestamp)
end

function UIVip18HistoryView:ClearContent()
  self.compCContent:RemoveComponents(UIVip18HistoryItem)
  self.historyItemPrefab:GameObjectRecycleAll()
end

function UIVip18HistoryView:RefreshNoneHistory()
  self.currentItemCount = #self.historyRecords
  if self.currentItemCount < 1 then
    self.text_none:SetActive(true)
    self.btnTop:SetActive(false)
    self.btnDown:SetActive(false)
  else
    self.text_none:SetActive(false)
    self.btnTop:SetActive(true)
    self.btnDown:SetActive(true)
  end
end

function UIVip18HistoryView:RefreshContent()
  self.facebookIcon:LoadSpriteAuto(DataCenter.VipExtendManager:GetContactUsIcon())
  local currentStage = DataCenter.VipExtendManager:GetVipExtendDesignData().stage
  if currentStage ~= nil and currentStage < 5 then
    self.textStage:SetLocalText("vip18_extend_history_step" .. currentStage + 1)
    self.imageStage:LoadSpriteAuto("Assets/Main/Sprites/UI/UIVipExtend18/lrb_vip18_timeline_0" .. currentStage + 1 .. ".png")
  end
  self:ClearContent()
  self:RefreshNoneHistory()
  self.currentItemCount = #self.historyRecords
  for i = 1, #self.historyRecords do
    local item = self.historyItemPrefab:GameObjectSpawn(self.compCContent.transform)
    item.name = "history_item" .. i
    local cell = self.compCContent:AddComponent(UIVip18HistoryItem, item.name)
    cell:SetData(self.historyRecords[i])
  end
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.compCContent.rectTransform)
  if self.previousSizeDeltaY == 0 then
    self.compCContent:SetAnchoredPositionXY(0, 99999)
  end
  TimerManager:GetInstance():DelayInvoke(function()
    if IsNull(self.gameObject) then
      return
    end
    self:ResetCompCContentAnchoredPositionY()
    self:UnlockScroll()
  end, 0.3)
end

function UIVip18HistoryView:ResetCompCContentAnchoredPositionY()
  local x, y = self.compCContent:GetSizeDeltaXY()
  if y > self.previousSizeDeltaY + 10 then
    self.compCContent:SetAnchoredPositionXY(0, y - self.previousSizeDeltaY + self.previousOffsetY)
    self.previousSizeDeltaY = y
  end
end

function UIVip18HistoryView:CheckRequestPage()
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.compCContent.rectTransform)
  self:ResetCompCContentAnchoredPositionY()
  self.previousOffsetY = self.compCContent:GetAnchoredPositionY()
  if self.previousOffsetY < 300 then
    self:loadMoreHistory()
  end
end

return UIVip18HistoryView
