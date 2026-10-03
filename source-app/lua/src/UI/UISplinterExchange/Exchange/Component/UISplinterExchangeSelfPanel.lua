local base = UIBaseContainer
local UISplinterExchangeSelfPanel = BaseClass("UISplinterExchangeSelfPanel", base)
local UISplinterExchangeItem = require("UI.UISplinterExchange.Component.UISplinterExchangeItem")
local string_IsNullOrEmpty = string.IsNullOrEmpty
local DispathTreasureExchangeTopItemType = _ENV.DispathTreasureExchangeTopItemType
local ReceiveItem_path = "TopBgImg/ReceiveItem"
local LoseItem_path = "TopBgImg/LoseItem"
local TipText_path = "TipText"
local LogBtn_path = "LogBtn"
local ExchangeBtn_path = "ExchangeBtn"
local ExchangeText_path = "ExchangeBtn/ExchangeBtnText"
local FragItem1_path = "OwnFragPanel1/FragItem1"
local CancelPanel_path = "CancelPanel"
local UseTipText_path = "UseTipText"
local CancellBtn_path = "CancelPanel/CancelBtn"
local CancellBtnText_path = "CancelPanel/CancelBtn/CancelBtnText"
local ShareBtn_path = "ShareBtn"
local LogRedPoint_path = "LogBtn/LogRedPoint"
local ExchangeLineImg_path = "ExchangeLineImg"
local HelpPlayerPanel_path = "HelpPlayerPanel"
local HelpPlayerNameText_path = "HelpPlayerPanel/HelpPlayerNameText"
local HelpPlayerTipText_path = "HelpPlayerPanel/HelpPlayerTipText"
local ThankBtn_path = "HelpPlayerPanel/ThankBtn"
local ReturnBtn_path = "HelpPlayerPanel/ReturnBtn"
local ThankBtnText_path = "HelpPlayerPanel/ThankBtn/ThankBtnText"
local ReturnBtnText_path = "HelpPlayerPanel/ReturnBtn/ReturnBtnText"
local HelpPlayerHead_Path = "HelpPlayerPanel/HelpPlayerHead/UIHelpPlayerHead"
local FragItemPath = "Assets/Main/Prefabs/UI/SplinterExchange/UISplinterExchangeItem.prefab"

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
end

local function OnDestroy(self)
  self:ComponentDestroy()
  base.OnDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
  self:DataDefine()
end

local function OnDisable(self)
  self:DataDestroy()
  base.OnDisable(self)
end

local function ComponentDefine(self)
  self.ReceiveItem = self:AddComponent(UISplinterExchangeItem, ReceiveItem_path)
  self.LoseItem = self:AddComponent(UISplinterExchangeItem, LoseItem_path)
  self.TipText = self:AddComponent(UIText, TipText_path)
  self.LogBtn = self:AddComponent(UIButton, LogBtn_path)
  self.ExchangeBtn = self:AddComponent(UIButton, ExchangeBtn_path)
  self.ExchangeText = self:AddComponent(UIText, ExchangeText_path)
  self.FragItem1 = self:AddComponent(UISplinterExchangeItem, FragItem1_path)
  self.CancelPanel = self:AddComponent(UIBaseContainer, CancelPanel_path)
  self.UseTipText = self:AddComponent(UIText, UseTipText_path)
  self.CancellBtn = self:AddComponent(UIButton, CancellBtn_path)
  self.CancellBtnText = self:AddComponent(UIText, CancellBtnText_path)
  self.ShareBtn = self:AddComponent(UIButton, ShareBtn_path)
  self.LogRedPoint = self:AddComponent(UIBaseContainer, LogRedPoint_path)
  self.ExchangeLineImg = self:AddComponent(UIImage, ExchangeLineImg_path)
  self.HelpPlayerPanel = self:AddComponent(UIBaseContainer, HelpPlayerPanel_path)
  self.HelpPlayerNameText = self:AddComponent(UIText, HelpPlayerNameText_path)
  self.HelpPlayerTipText = self:AddComponent(UIText, HelpPlayerTipText_path)
  self.ThankBtn = self:AddComponent(UIButton, ThankBtn_path)
  self.ReturnBtn = self:AddComponent(UIButton, ReturnBtn_path)
  self.ThankBtnText = self:AddComponent(UIText, ThankBtnText_path)
  self.ReturnBtnText = self:AddComponent(UIText, ReturnBtnText_path)
  self.OwnFragPanel1 = self:AddComponent(UIBaseContainer, "OwnFragPanel1")
  self.OwnFragPanel2 = self:AddComponent(UIBaseContainer, "OwnFragPanel2")
  self.HelpPlayerHead = self:AddComponent(UICommonHead, HelpPlayerHead_Path)
  self.HelpPlayerHead:SetEnableClickShowInfo(true, true)
  self.LogBtn:SetOnClick(function()
    local param = {}
    param.type = self.view.type
    self.view.ctrl:OpenTreasureExchangeLogView(param)
  end)
  self.ReceiveItem:SetClickCallback(function(index)
    self:OnClickTopItem(index)
  end, DispathTreasureExchangeTopItemType.Receive)
  self.LoseItem:SetClickCallback(function(index)
    self:OnClickTopItem(index)
  end, DispathTreasureExchangeTopItemType.Lose)
  self.ExchangeBtn:SetOnClick(function()
    if self.receiveFragId == self.loseFragId then
      UIUtil.ShowTipsId("Treasure_map_31")
    elseif self.receiveFragId and self.loseFragId then
      local param = {}
      param.receiveFragId = self.receiveFragId
      param.loseFragId = self.loseFragId
      param.titleDialogId = "Treasure_map_06"
      param.type = self.view.type
      
      function param.callback()
        local msgParam = {}
        msgParam.type = self.view.type
        msgParam.needFragment = self.receiveFragId
        msgParam.costFragment = self.loseFragId
        self.view.ctrl:SendCallExchangeMsg(msgParam)
      end
      
      UIManager:GetInstance():OpenWindow(UIWindowNames.UISplinterExchangeConfirm, {anim = true}, param)
    end
  end)
  self.CancellBtn:SetOnClick(function()
    if self.ownExchangeData and self.ownExchangeData.uuid then
      local param = {}
      param.uuid = self.ownExchangeData.uuid
      self.view.ctrl:SendCancelExchangeMsg(param)
    end
  end)
  self.ShareBtn:SetOnClick(function()
    self:OnClickShareBtn()
  end)
  self.ThankBtnText:SetLocalText("Treasure_map_36")
  self.ThankBtn:SetOnClick(function()
    if self.ownExchangeData and self.ownExchangeData.recordShow and self.ownExchangeData.recordShow and self.ownExchangeData.recordShow.isLike == 0 then
      self.view.ctrl:SendLikeMsg(self.ownExchangeData.recordShow)
    else
      UIUtil.ShowTipsId("Treasure_map_43")
    end
  end)
  self.ReturnBtnText:SetLocalText("Treasure_map_37")
  self.ReturnBtn:SetOnClick(function()
    self.view.ctrl:SendRemoveExchangeShowMessage({
      type = self.view.type
    })
  end)
  self.fragItemReqList = {}
end

local function ComponentDestroy(self)
  self.ReceiveItem = nil
  self.LoseItem = nil
  self.TipText = nil
  self.LogBtn = nil
  self.ExchangeBtn = nil
  self.ExchangeText = nil
  self.FragItem1 = nil
  self.CancelPanel = nil
  self.UseTipText = nil
  self.CancellBtn = nil
  self.CancellBtnText = nil
  self.ShareBtn = nil
  self.LogRedPoint = nil
  self.ExchangeLineImg = nil
  self.HelpPlayerPanel = nil
  self.HelpPlayerNameText = nil
  self.HelpPlayerTipText = nil
  self.ThankBtn = nil
  self.ReturnBtn = nil
  self.ThankBtnText = nil
  self.ReturnBtnText = nil
  self.FragItems = nil
  self.OwnFragPanel1 = nil
  self.OwnFragPanel2 = nil
  self.HelpPlayerHead = nil
  if self.fragItemReqList ~= nil then
    for k, v in pairs(self.fragItemReqList) do
      if v ~= nil then
        self:GameObjectDestroy(v)
      end
    end
  end
  self.fragItemReqList = nil
  self.fragGoodsIdList = nil
end

local function DataDefine(self)
end

local function DataDestroy(self)
  self.selectTopIndex = nil
  self.selectDownIndex = nil
  self.receiveFragId = nil
  self.loseFragId = nil
  self.ownExchangeData = nil
  self.openReceiveFragId = nil
end

local function OnAddListener(self)
  base.OnAddListener(self)
  self:AddUIListener(EventId.SplinterRefreshSelf, self.Refresh)
  self:AddUIListener(EventId.SplinterRefreshExchangeRedPoint, self.RefreshExchangeRedPoint)
end

local function OnRemoveListener(self)
  self:RemoveUIListener(EventId.SplinterRefreshSelf, self.Refresh)
  self:RemoveUIListener(EventId.SplinterRefreshExchangeRedPoint, self.RefreshExchangeRedPoint)
  base.OnAddListener(self)
end

local function SetOpenFragId(self, receiveFragId)
  if not self:GetSelfIsExchange() and not self:GetIsFinshExchange() and receiveFragId then
    self.openReceiveFragId = tostring(receiveFragId)
  end
end

local function Refresh(self, type)
  if type ~= self.view.type then
    return
  end
  self.fragGoodsIdList = DataCenter.SplinterExchangeManager:GetFragGoodsIdList(self.view.type)
  self.ownExchangeData = self.view.ctrl:GetSelfExchangeData(self.view.type)
  local receiveTitleStr = "Treasure_map_09"
  local loseTitleStr = "Treasure_map_08"
  local showReceiveEffect = true
  local defaultSelectIndex = DispathTreasureExchangeTopItemType.Receive
  if self:GetSelfIsExchange() then
    self.receiveFragId = self.ownExchangeData.needFragment
    self.loseFragId = self.ownExchangeData.costFragment
    self.TipText:SetActive(true)
    self.TipText:SetLocalText("Treasure_map_35")
    self.ShareBtn:SetActive(true)
    self.OwnFragPanel1:SetActive(true)
    self.OwnFragPanel2:SetActive(true)
    self.HelpPlayerPanel:SetActive(false)
    self.ExchangeLineImg:SetActive(true)
    self:RefreshDownItems()
  elseif self:GetIsFinshExchange() then
    self.TipText:SetActive(true)
    local name1 = DataCenter.ItemTemplateManager:GetName(self.ownExchangeData.recordShow.costFragment)
    local name2 = DataCenter.ItemTemplateManager:GetName(self.ownExchangeData.recordShow.getFragment)
    self.TipText:SetLocalText("Treasure_map_41", name2)
    self.ShareBtn:SetActive(false)
    self.OwnFragPanel1:SetActive(false)
    self.OwnFragPanel2:SetActive(false)
    self.HelpPlayerPanel:SetActive(true)
    self.ExchangeLineImg:SetActive(true)
    self:RefreshHelpPlayerPanel()
    self.receiveFragId = self.ownExchangeData.recordShow.getFragment
    self.loseFragId = self.ownExchangeData.recordShow.costFragment
    receiveTitleStr = "Treasure_map_46"
    loseTitleStr = "Treasure_map_47"
    showReceiveEffect = false
  else
    if not string_IsNullOrEmpty(self.openReceiveFragId) then
      defaultSelectIndex = DispathTreasureExchangeTopItemType.Lose
    end
    self.receiveFragId = self.openReceiveFragId
    self.loseFragId = nil
    self.TipText:SetActive(true)
    self.ShareBtn:SetActive(false)
    self.OwnFragPanel1:SetActive(true)
    self.OwnFragPanel2:SetActive(true)
    self.HelpPlayerPanel:SetActive(false)
    self.ExchangeLineImg:SetActive(false)
    self:RefreshDownItems()
  end
  self.ReceiveItem:SetData(self.receiveFragId, DispathTreasureExchangeItemType.Top, DataCenter.SplinterExchangeManager:GetIndexStrByGoodsId(self.view.type, self.receiveFragId))
  self.ReceiveItem:SetTitleText(receiveTitleStr)
  self.ReceiveItem:PlayNoItemImgAnim(showReceiveEffect)
  self.LoseItem:SetData(self.loseFragId, DispathTreasureExchangeItemType.Top, DataCenter.SplinterExchangeManager:GetIndexStrByGoodsId(self.view.type, self.loseFragId))
  self.LoseItem:SetTitleText(loseTitleStr)
  self:RefreshBtnState()
  self:OnClickTopItem(defaultSelectIndex)
  self:RefreshExchangeRedPoint()
  if self.view.type == SplinterExchangeType.DispatchTreasure.Id or self.view.type == SplinterExchangeType.DigTreasure.Id then
    self.ReceiveItem:ShowIdTextBg()
    self.LoseItem:ShowIdTextBg()
  else
    self.ReceiveItem:HideOwnNumText()
    self.LoseItem:HideOwnNumText()
  end
end

local function RefreshDownItems(self)
  local goodsList = self.fragGoodsIdList
  if self.FragItems == nil then
    self.FragItems = {}
    self.OwnFragPanel1:RemoveAllComponentes(UISplinterExchangeItem)
    self.OwnFragPanel2:RemoveAllComponentes(UISplinterExchangeItem)
    local count1 = math.ceil(#goodsList / 2)
    for i = 1, #goodsList do
      if i <= count1 then
        self:CreateDownItem(i, self.OwnFragPanel1)
      else
        self:CreateDownItem(i, self.OwnFragPanel2)
      end
    end
  elseif #self.FragItems == #goodsList then
    self:OnFragItemLoadFinish()
  end
end

local function CreateDownItem(self, i, parent)
  self.fragItemReqList[i] = self:GameObjectInstantiateAsync(FragItemPath, function(request)
    if request.isError then
      return
    end
    local go = request.gameObject
    go.gameObject:SetActive(true)
    go.transform:SetParent(parent.transform)
    go.transform:Set_localScale(1.25, 1.25, 1.25)
    go.name = i
    local fragItem = parent:AddComponent(UISplinterExchangeItem, go.name)
    fragItem:SetData(self.fragGoodsIdList[i], DispathTreasureExchangeItemType.Down, DataCenter.SplinterExchangeManager:GetIndexStrByIndex(self.view.type, i))
    fragItem:HideOwnNumText()
    local itemData = DataCenter.ItemData:GetItemByItemId(tonumber(self.fragGoodsIdList[i]))
    local num = itemData and itemData.count or 0
    fragItem:SetNumText(num)
    fragItem:SetClickCallback(function(index)
      self:OnClickDownItem(index)
    end, i)
    table.insert(self.FragItems, fragItem)
    if table.count(self.FragItems) == #self.fragGoodsIdList then
      self:OnFragItemLoadFinish()
    end
  end)
end

local function RefreshBtnState(self)
  if self:GetSelfIsExchange() then
    self.CancelPanel:SetActive(true)
    self.ExchangeBtn:SetActive(false)
    self.UseTipText:SetActive(false)
  elseif self:GetIsFinshExchange() then
    self.CancelPanel:SetActive(false)
    self.ExchangeBtn:SetActive(false)
    self.UseTipText:SetActive(false)
  else
    self.CancelPanel:SetActive(false)
    self.ExchangeBtn:SetActive(true)
    if self.receiveFragId and self.loseFragId then
      CS.UIGray.SetGray(self.ExchangeBtn.transform, false, true)
    else
      CS.UIGray.SetGray(self.ExchangeBtn.transform, true, false)
    end
    if self.receiveFragId and self.loseFragId then
      self.UseTipText:SetActive(true)
      local name1 = DataCenter.ItemTemplateManager:GetName(self.loseFragId)
      local name2 = DataCenter.ItemTemplateManager:GetName(self.receiveFragId)
      self.UseTipText:SetLocalText("Treasure_map_12", name1, name2)
    else
      self.UseTipText:SetActive(false)
    end
  end
end

local function OnClickTopItem(self, index)
  Logger.Log("OnClickTopItem" .. index)
  if self.FragItems == nil or self:GetSelfIsExchange() or self:GetIsFinshExchange() then
    return
  end
  self.selectTopIndex = index
  if index == DispathTreasureExchangeTopItemType.Receive then
    self.ReceiveItem:SetSelect(true)
    self.LoseItem:SetSelect(false)
    self.TipText:SetLocalText("Treasure_map_11")
  else
    self.ReceiveItem:SetSelect(false)
    self.LoseItem:SetSelect(true)
    self.TipText:SetLocalText("Treasure_map_10")
  end
  for i = 1, #self.FragItems do
    self.FragItems[i]:SetSelect(false)
  end
end

local function OnClickDownItem(self, index)
  Logger.Log("OnClickDownItem" .. index)
  if self:GetSelfIsExchange() then
    return
  end
  if self.selectTopIndex == nil then
    return
  elseif self.selectTopIndex == DispathTreasureExchangeTopItemType.Lose and not self.FragItems[index]:HaveFrag() then
    UIUtil.ShowTipsId("Treasure_map_25")
    return
  else
    self.selectDownIndex = index
    for i = 1, #self.FragItems do
      self.FragItems[i]:SetSelect(i == index)
    end
    if self.selectTopIndex == DispathTreasureExchangeTopItemType.Receive then
      self.receiveFragId = self.fragGoodsIdList[index]
      self.ReceiveItem:SetFragId(self.receiveFragId, DataCenter.SplinterExchangeManager:GetIndexStrByGoodsId(self.view.type, self.receiveFragId))
      self.ReceiveItem:HideOwnNumText()
    else
      self.loseFragId = self.fragGoodsIdList[index]
      self.LoseItem:SetFragId(self.loseFragId, DataCenter.SplinterExchangeManager:GetIndexStrByGoodsId(self.view.type, self.loseFragId))
      self.LoseItem:HideOwnNumText()
    end
    self:RefreshBtnState()
  end
end

local function RefreshHelpPlayerPanel(self)
  local framePath = DataCenter.DecorationDataManager:GetHeadFrame(self.ownExchangeData.recordShow.headSkinId, self.ownExchangeData.recordShow.headSkinET, false)
  self.HelpPlayerHead:SetData(self.ownExchangeData.recordShow.uid, self.ownExchangeData.recordShow.headPic, self.ownExchangeData.recordShow.headPicVer, nil, framePath)
  local showName = DataCenter.PlayerInfoDataManager:GetRemarkOrRealName(self.ownExchangeData.recordShow.uid, self.ownExchangeData.recordShow.name)
  self.HelpPlayerNameText:SetText(showName)
  self.HelpPlayerTipText:SetLocalText("Treasure_map_42")
  self.ThankBtn:SetActive(self.ownExchangeData.recordShow.isLike ~= 1)
end

local function GetSelfIsExchange(self)
  return self.ownExchangeData ~= nil and self.ownExchangeData.uuid ~= -1
end

local function OnClickShareBtn(self)
  if self.ownExchangeData and self.ownExchangeData.updateTime and self.ownExchangeData.uuid then
    local curTime = UITimeManager:GetInstance():GetServerTime()
    local diffTime = curTime - self.ownExchangeData.updateTime
    local cfgTime = LuaEntry.DataConfig:TryGetNum("Treasure_map_others", "k2") * 1000
    local chat_channel = ChatInterface.getRoomData(ChatInterface.getAllianceRoomId())
    if diffTime > cfgTime and chat_channel then
      UIManager:GetInstance():OpenWindow(UIWindowNames.UISplinterExchangeShareConfirm, {anim = true}, chat_channel, self.ownExchangeData)
    else
      UIUtil.ShowTipsId(100381)
    end
  end
end

local function RefreshExchangeRedPoint(self)
  self.LogRedPoint:SetActive(DataCenter.SplinterExchangeManager:GetExchangeLogRedPoint(self.view.type))
end

local function OnFragItemLoadFinish(self)
  local goodsList = self.fragGoodsIdList
  for i = 1, #goodsList do
    self.FragItems[i]:SetData(self.fragGoodsIdList[i], DispathTreasureExchangeItemType.Down, DataCenter.SplinterExchangeManager:GetIndexStrByIndex(self.view.type, i))
    self.FragItems[i]:HideOwnNumText()
    local itemData = DataCenter.ItemData:GetItemByItemId(tonumber(goodsList[i]))
    local num = itemData and itemData.count or 0
    self.FragItems[i]:SetNumText(num)
  end
end

local function GetIsFinshExchange(self)
  local isFinsh = false
  if self.ownExchangeData and self.ownExchangeData.recordShow ~= nil and self.ownExchangeData.recordShow.uuid ~= nil then
    isFinsh = true
  end
  return isFinsh
end

UISplinterExchangeSelfPanel.OnCreate = OnCreate
UISplinterExchangeSelfPanel.OnDestroy = OnDestroy
UISplinterExchangeSelfPanel.OnEnable = OnEnable
UISplinterExchangeSelfPanel.OnDisable = OnDisable
UISplinterExchangeSelfPanel.ComponentDefine = ComponentDefine
UISplinterExchangeSelfPanel.ComponentDestroy = ComponentDestroy
UISplinterExchangeSelfPanel.DataDefine = DataDefine
UISplinterExchangeSelfPanel.DataDestroy = DataDestroy
UISplinterExchangeSelfPanel.SetOpenFragId = SetOpenFragId
UISplinterExchangeSelfPanel.Refresh = Refresh
UISplinterExchangeSelfPanel.RefreshDownItems = RefreshDownItems
UISplinterExchangeSelfPanel.CreateDownItem = CreateDownItem
UISplinterExchangeSelfPanel.OnClickTopItem = OnClickTopItem
UISplinterExchangeSelfPanel.OnClickDownItem = OnClickDownItem
UISplinterExchangeSelfPanel.OnAddListener = OnAddListener
UISplinterExchangeSelfPanel.OnRemoveListener = OnRemoveListener
UISplinterExchangeSelfPanel.RefreshBtnState = RefreshBtnState
UISplinterExchangeSelfPanel.GetSelfIsExchange = GetSelfIsExchange
UISplinterExchangeSelfPanel.GetIsFinshExchange = GetIsFinshExchange
UISplinterExchangeSelfPanel.OnClickShareBtn = OnClickShareBtn
UISplinterExchangeSelfPanel.RefreshExchangeRedPoint = RefreshExchangeRedPoint
UISplinterExchangeSelfPanel.OnFragItemLoadFinish = OnFragItemLoadFinish
UISplinterExchangeSelfPanel.RefreshHelpPlayerPanel = RefreshHelpPlayerPanel
return UISplinterExchangeSelfPanel
