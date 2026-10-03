local base = UIBaseView
local LWUIGiftOperationView = BaseClass("LWUIGiftOperationView", base)
local LWUIGiftItemView = require("UI.LWPlayerInfo.UILWGiftSystem.GiftOperation.Component.LWUIGiftItemView")
local LWUIGiftLevelInfo = require("UI.LWPlayerInfo.UILWGiftSystem.Common.LWUIGiftLevelInfo")
local LWUIGiftShowItem = require("UI.LWPlayerInfo.UILWGiftSystem.Common.LWUIGiftShowItem")
local UILWGift = require("UI.LWPlayerInfo.UILWPlayerDetail.Component.Bottom.Gift.UILWGift")
local Localization = CS.GameEntry.Localization
local sendBtn_path = "BG/Bottom/SendBtn"
local sendBtnGray_path = "BG/Bottom/SendBtn/Gray"
local giftInfoGo_path = "BG/Top/GiftInfo"
local giftShowGo_path = "BG/Top/GiftList"
local giftLevelInfo_path = "BG/Top/GiftInfo/LWUIGiftLevelInfo"
local privilegeBtn_path = "BG/Top/GiftInfo/PrivilegeBtn"
local closeBtn_path = "btnClose"
local sendBtnTxt_path = "BG/Bottom/SendBtn/Normal/BtnText"
local sendBtnGrayTxt_path = "BG/Bottom/SendBtn/Gray/GrayBtnText"
local giftShowList_path = "BG/Top/GiftList/gift"
local shopBtn_path = "BG/Bottom/ShopBtn"
local expireText_path = "BG/Bottom/ExpireText"
local gift_item_list_path = "BG/Bottom/GiftArea/GiftItemList"
local content_path = "BG/Bottom/GiftArea/GiftItemList/Content"

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:RefreshView()
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
  self.sendBtn = self:AddComponent(UIButton, sendBtn_path)
  self.sendBtnGray = self:AddComponent(UIBaseContainer, sendBtnGray_path)
  self.giftInfoGo = self:AddComponent(UIBaseContainer, giftInfoGo_path)
  self.giftShowGo = self:AddComponent(UIBaseContainer, giftShowGo_path)
  self.giftLevelInfo = self:AddComponent(UIBaseContainer, giftLevelInfo_path)
  self.privilegeBtn = self:AddComponent(UIButton, privilegeBtn_path)
  self.closeBtn = self:AddComponent(UIButton, closeBtn_path)
  self.sendBtnTxt = self:AddComponent(UIText, sendBtnTxt_path)
  self.sendBtnGrayTxt = self:AddComponent(UIText, sendBtnGrayTxt_path)
  self.giftShowList = self:AddComponent(UIBaseContainer, giftShowList_path)
  self.shopBtn = self:AddComponent(UIButton, shopBtn_path)
  self.expireText = self:AddComponent(UIText, expireText_path)
  self.giftShowListComponent = self:AddComponent(UILWGift, giftShowList_path)
  self.giftLevelInfoComponent = self:AddComponent(LWUIGiftLevelInfo, giftLevelInfo_path)
  self.giftItemList = self:AddComponent(GridInfinityScrollView, content_path)
  self.giftItemListScroll = self:AddComponent(UIBaseContainer, gift_item_list_path)
  self.sendBtn:SetOnClick(function()
    self:OnSendBtnClick()
  end)
  self.privilegeBtn:SetOnClick(function()
    self:OnPrivilegeBtnClick()
  end)
  self.closeBtn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.shopBtn:SetOnClick(function()
    self:OnShopBtnClick()
  end)
  self.shopBtn:SetActive(CommonUtil.IsGrayServer())
end

local function ComponentDestroy(self)
  self.sendBtn = nil
  self.sendBtnGray = nil
  self.giftInfoGo = nil
  self.giftShowGo = nil
  self.giftLevelInfo = nil
  self.privilegeBtn = nil
  self.closeBtn = nil
  self.sendBtnTxt = nil
  self.sendBtnGrayTxt = nil
  self.giftShowList = nil
  self.shopBtn = nil
  self.expireText = nil
  self.giftLevelInfoComponent = nil
  if self.giftItemListScroll then
    self.giftItemListScroll:RemoveComponents(LWUIGiftItemView)
  end
  if self.giftItemList then
    self.giftItemList:DestroyChildNode()
  end
end

local function DataDefine(self)
  self.hasInitScroll = false
  self.giftCells = {}
  self.listGO = {}
  self.showDataList = {}
  self.selectingIndex = 1
  self.giftPosList = {}
  self.giftPosIndex = 1
  self.expireTime = 0
  self.showExpireTime = false
end

local function DataDestroy(self)
  self.hasInitScroll = false
  self.giftCells = {}
  self.listGO = {}
  self.showDataList = {}
  self.selectingIndex = 1
  self.giftPosList = {}
  self.giftPosIndex = 1
  self.expireTime = 0
  self.showExpireTime = false
end

local function OnInitScroll(self, go, index)
  local item = self.giftItemListScroll:AddComponent(LWUIGiftItemView, go)
  self.listGO[go] = item
end

local function OnSelectItem(self, data)
  local selectData = self.showDataList[self.selectingIndex]
  if selectData and selectData.id and self.giftCells[selectData.id] then
    self.giftCells[selectData.id]:SetSelect(false)
  end
  for i, v in ipairs(self.showDataList) do
    if v.id == data.id then
      self.selectingIndex = i
      break
    end
  end
  selectData = self.showDataList[self.selectingIndex]
  if selectData and selectData.id and self.giftCells[selectData.id] then
    self.giftCells[selectData.id]:SetSelect(true)
  end
end

local function OnUpdateScroll(self, go, index)
  local item = self.listGO[go]
  local uuid = self.showDataList[index + 1].id
  item:SetActive(uuid ~= nil)
  item:SetData(self.showDataList[index + 1])
  item:SetOnSelect(function(data)
    OnSelectItem(self, data)
    self:RefreshSendBtn()
  end)
  item:SetShowType(self.windowType)
  item:SetSelect(uuid == self.showDataList[self.selectingIndex].id)
  self.giftCells[uuid] = item
end

local function OnDestroyScrollItem(self, go, index)
  if self.showDataList[index + 1] == nil then
    return
  end
  self.giftCells[self.showDataList[index + 1].id] = nil
end

function LWUIGiftOperationView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.RefreshItems, self.RefreshView)
end

function LWUIGiftOperationView:OnRemoveListener()
  self:RemoveUIListener(EventId.RefreshItems, self.RefreshView)
  base.OnRemoveListener(self)
end

function LWUIGiftOperationView:RefreshView()
  local param = self:GetUserData()
  self.windowType = param.windowType
  self.targetUid = param.targetUid
  self.targetServerId = param.targetServerId
  self.isMoment = param.isMoment
  self:RefreshTop()
  self:RefreshBottom()
  self:RefreshSendBtn()
end

function LWUIGiftOperationView:RefreshTop()
  self.giftInfoGo:SetActive(self.windowType == GiftSystemConst.WindowType.Send)
  self.giftShowGo:SetActive(self.windowType == GiftSystemConst.WindowType.Show)
  if self.windowType == GiftSystemConst.WindowType.Send then
    self.giftLevelInfoComponent:SetData()
  else
    self:RefreshGiftShowArea()
  end
end

function LWUIGiftOperationView:RefreshGiftShowArea()
  local info = DataCenter.PlayerInfoDataManager.selfPlayerData
  if info == nil then
    SFSNetwork.SendMessage(MsgDefines.GetNewUserInfo, LuaEntry.Player.uid)
  end
  local giftDataList = info and info.giftDataList or {}
  self.giftShowListComponent:ReInit(giftDataList, GiftShowType.Edit, info.uid)
end

function LWUIGiftOperationView:RefreshBottom()
  self.showDataList = DataCenter.GiftSystemManager:GetGiftList(self.windowType)
  if not self.hasInitScroll then
    local bindFunc1 = BindCallback(self, self.OnInitScroll)
    local bindFunc2 = BindCallback(self, self.OnUpdateScroll)
    local bindFunc3 = BindCallback(self, self.OnDestroyScrollItem)
    self.giftItemList:Init(bindFunc1, bindFunc2, bindFunc3)
  end
  self.hasInitScroll = true
  local dataCount = table.count(self.showDataList)
  self.giftItemList:SetItemCount(dataCount)
  self.giftItemList:ForceUpdate()
end

function LWUIGiftOperationView:RefreshSendBtn()
  local isGray = false
  local selectData = self.showDataList[self.selectingIndex]
  local num = 0
  if selectData then
    num = DataCenter.GiftSystemManager:GetGiftNum(selectData.id)
    if num == 0 then
      isGray = true
    end
    self.showExpireTime = DataCenter.ItemExchangeManager:IsShowWillExpired(tonumber(selectData.id))
    local time = DataCenter.GiftSystemManager:GetGiftExpiredTime(selectData.id)
    local now = UITimeManager:GetInstance():GetServerSeconds()
    self.expireTime = time
    self.expireText:SetActive(self.showExpireTime and self.windowType == GiftSystemConst.WindowType.Send)
    self.expireText:SetText(UITimeManager:GetInstance():SecondToFmtString(time - now))
  else
    self.expireText:SetActive(false)
  end
  self.sendBtnGray:SetActive(isGray)
  if self.windowType == GiftSystemConst.WindowType.Send then
    if self.isMoment then
      self.sendBtnTxt:SetLocalText("moment_follow_special_btn")
      self.sendBtnGrayTxt:SetLocalText("moment_follow_special_btn")
    else
      local goods = DataCenter.GiftSystemManager:GetGiftGoods(selectData.id)
      if goods and goods.pay == 0 and num == 0 then
        self.sendBtnTxt:SetLocalText("2000631")
        self.sendBtnGrayTxt:SetLocalText("2000631")
      else
        self.sendBtnTxt:SetLocalText("gift_send_btn")
        self.sendBtnGrayTxt:SetLocalText("gift_send_btn")
      end
    end
  else
    self.sendBtnTxt:SetLocalText("btn_display")
    self.sendBtnGrayTxt:SetLocalText("btn_display")
  end
end

function LWUIGiftOperationView:Update1000MS()
  if self.showExpireTime == true then
    local now = UITimeManager:GetInstance():GetServerSeconds()
    if self.expireTime and self.expireTime - now > 0 then
      self.expireText:SetText(UITimeManager:GetInstance():SecondToFmtString(self.expireTime - now))
    else
      self.expireText:SetText("")
      self:RefreshView()
    end
  end
end

function LWUIGiftOperationView:OnSendBtnClick()
  if self.windowType == GiftSystemConst.WindowType.Show then
    self:DoShowGift()
  else
    if self.isMoment then
      self:DoFristFollowSendGift()
      return
    end
    self:DoSendGift()
  end
end

function LWUIGiftOperationView:DoFristFollowSendGift()
  local selectData = self.showDataList[self.selectingIndex]
  if selectData then
    local num = DataCenter.GiftSystemManager:GetGiftNum(selectData.id)
    if num == 0 then
      LWResourceLackUtil:GotoGoodsItemLack(selectData.id, 1)
      return
    end
  else
    return
  end
  local template = DataCenter.ItemTemplateManager:GetItemTemplate(self.showDataList[self.selectingIndex].id)
  if self.showDataList[self.selectingIndex].id == "990001" then
    UIUtil.ShowMessage(Localization:GetString("moment_follow_tips2"), 2, "moment_follow_special_btn", GameDialogDefine.CANCEL, function()
      SFSNetwork.SendMessage(MsgDefines.UserAddFollow, {
        targetUid = self.targetUid,
        itemId = self.showDataList[self.selectingIndex].id,
        num = 1,
        context = "",
        isAnonymous = false
      })
      self.ctrl:CloseSelf()
    end)
  else
    local param = {
      template = self.showDataList[self.selectingIndex],
      targetUid = self.targetUid,
      targetServerId = self.targetServerId,
      viewType = "moment"
    }
    DataCenter.GiftSystemManager:OpenDetailView(param, false)
  end
end

function LWUIGiftOperationView:DoSendGift()
  local selectData = self.showDataList[self.selectingIndex]
  if selectData then
    local num = DataCenter.GiftSystemManager:GetGiftNum(selectData.id)
    if num == 0 then
      LWResourceLackUtil:GotoGoodsItemLack(selectData.id, 1)
      return
    end
  else
    return
  end
  local param = {
    template = self.showDataList[self.selectingIndex],
    targetUid = self.targetUid,
    targetServerId = self.targetServerId
  }
  DataCenter.GiftSystemManager:OpenDetailView(param, false)
end

function LWUIGiftOperationView:DoShowGift()
  local selectData = self.showDataList[self.selectingIndex]
  if selectData == nil then
    return
  end
  local num = DataCenter.GiftSystemManager:GetGiftNum(selectData.id)
  if num == 0 then
    return
  end
  local info = DataCenter.PlayerInfoDataManager.selfPlayerData
  if info == nil then
    return
  end
  local posIndex = self.giftShowListComponent.selectIndex
  if posIndex == nil then
    return
  end
  local giftDataList = info and info.giftDataList or {}
  local find = false
  for i, v in pairs(giftDataList) do
    if v.itemId == tonumber(selectData.id) then
      table.remove(giftDataList, i)
      break
    end
  end
  for _, v in pairs(giftDataList) do
    if v.pos == posIndex then
      v.itemId = tonumber(selectData.id)
      find = true
      break
    end
  end
  if not find then
    table.insert(giftDataList, {
      pos = posIndex,
      itemId = tonumber(selectData.id),
      count = num
    })
  end
  DataCenter.GiftSystemManager:RequestSetGiftShow(giftDataList)
end

function LWUIGiftOperationView:OnPrivilegeBtnClick()
  UIManager:GetInstance():OpenWindow(UIWindowNames.LWUIGiftPrivilege, {anim = true})
end

function LWUIGiftOperationView:OnShopBtnClick()
  if LuaEntry.Player.level < DataCenter.GiftSystemManager.minSendGiftLevel and DataCenter.BuildManager.MainLv < DataCenter.GiftSystemManager.minSendGiftLevel then
    UIUtil.ShowTips(Localization:GetString("gift_sent_toast3", DataCenter.GiftSystemManager.minSendGiftLevel))
    return
  end
  UIManager:GetInstance():OpenWindow(UIWindowNames.LWUIGiftShop, {anim = true})
end

LWUIGiftOperationView.OnCreate = OnCreate
LWUIGiftOperationView.OnDestroy = OnDestroy
LWUIGiftOperationView.OnEnable = OnEnable
LWUIGiftOperationView.OnDisable = OnDisable
LWUIGiftOperationView.ComponentDefine = ComponentDefine
LWUIGiftOperationView.ComponentDestroy = ComponentDestroy
LWUIGiftOperationView.DataDefine = DataDefine
LWUIGiftOperationView.DataDestroy = DataDestroy
LWUIGiftOperationView.OnInitScroll = OnInitScroll
LWUIGiftOperationView.OnUpdateScroll = OnUpdateScroll
LWUIGiftOperationView.OnDestroyScrollItem = OnDestroyScrollItem
return LWUIGiftOperationView
