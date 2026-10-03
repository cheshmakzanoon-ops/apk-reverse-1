local base = UIBaseView
local LWUIGiftOperationView = BaseClass("LWUIGiftOperationView", base)
local LWUIGiftItemView = require("UI.LWPlayerInfo.UILWGiftSystem.GiftOperation_v2.Component.LWUIGiftItemView")
local LWUIGiftLevelInfo = require("UI.LWPlayerInfo.UILWGiftSystem.Common.LWUIGiftLevelInfo")
local UILWGift = require("UI.LWPlayerInfo.UILWPlayerDetail.Component.Bottom.Gift.UILWGift")
local UITopItem = require("UI.UIActivityCenterTable.Component.UILuckyRoll.UITopItem")
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
local itemBar_path = "ItemBar"
local expireText_path = "BG/Bottom/ExpireText"
local gift_item_list_path = "BG/Bottom/GiftArea/GiftItemList"
local content_path = "BG/Bottom/GiftArea/GiftItemList/Content"
local b_g_path = "BG"
local extra_send_content_path = "BG/Bottom/extraSendContent"
local extra_send_txt_path = "BG/Bottom/extraSendContent/extraSendTxt"
local extra_send_icon_content_path = "BG/Bottom/extraSendContent/extraSendTxt/extraSendIconContent"
local extra_send_icon_path = "BG/Bottom/extraSendContent/extraSendTxt/extraSendIconContent/extraSendIcon"
local extra_send_num_path = "BG/Bottom/extraSendContent/extraSendNum"
local top_path = "BG/Top"
local bottom_path = "BG/Bottom"
local send_tip_btn_path = "BG/Bottom/sendTipBtn"
local set_auto_ani_content_path = "BG/Bottom/SetAutoAniContent"
local auto_ani_select_img_path = "BG/Bottom/SetAutoAniContent/autoAniSelectBg/autoAniSelectImg"
local auto_ani_tip_path = "BG/Bottom/SetAutoAniContent/AutoAniTip"
local bottomContetnNoramlH = 832
local topNormalH = 120
local bgDiff = 30
local bottomTipNormalH = 44
local GiftInfoH = 100
local GiftListH = 168
local NotSelectIndex = -1

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
  self.itemBar = self:AddComponent(UIBaseContainer, itemBar_path)
  self.expireText = self:AddComponent(UIText, expireText_path)
  self.giftShowListComponent = self:AddComponent(UILWGift, giftShowList_path)
  self.giftLevelInfoComponent = self:AddComponent(LWUIGiftLevelInfo, giftLevelInfo_path)
  self.giftItemList = self:AddComponent(GridInfinityScrollView, content_path)
  self.giftItemListScroll = self:AddComponent(UIBaseContainer, gift_item_list_path)
  self.item_bar = self:AddComponent(UITopItem, itemBar_path)
  self.extra_send_content = self:AddComponent(UIBaseContainer, extra_send_content_path)
  self.extra_send_txt = self:AddComponent(UITextMeshProUGUIEx, extra_send_txt_path)
  self.extra_send_icon_content = self:AddComponent(UIImage, extra_send_icon_content_path)
  self.extra_send_icon = self:AddComponent(UIImage, extra_send_icon_path)
  self.extra_send_num = self:AddComponent(UITextMeshProUGUIEx, extra_send_num_path)
  self.top = self:AddComponent(UIImage, top_path)
  self.bottom = self:AddComponent(UIImage, bottom_path)
  self.itemBarList = {
    self.item_bar
  }
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
  self.shopBtn:SetActive(false)
  self.b_g = self:AddComponent(UIImage, b_g_path)
  self.extra_send_txt:OnPointerClick(function(eventData)
    self:OnPointerClick(eventData.position)
  end)
  self.send_tip_btn = self:AddComponent(UIButton, send_tip_btn_path)
  self.send_tip_btn:SetOnClick(function()
    self:OnSendTipBtnClick()
  end)
  self.set_auto_ani_content = self:AddComponent(UIButton, set_auto_ani_content_path)
  self.auto_ani_select_img = self:AddComponent(UIImage, auto_ani_select_img_path)
  self.auto_ani_tip = self:AddComponent(UITextMeshProUGUIEx, auto_ani_tip_path)
  self.auto_ani_tip:SetLocalText("gift_scrollshow")
  self.set_auto_ani_content:SetOnClick(function()
    self:OnSetAutoAniContentClick()
  end)
  self.set_auto_ani_content:SetSafeClickMode(true)
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
  self.itemBar = nil
  self.expireText = nil
  self.b_g = nil
  self.giftLevelInfoComponent = nil
  if self.giftItemListScroll then
    self.giftItemListScroll:RemoveComponents(LWUIGiftItemView)
  end
  if self.giftItemList then
    self.giftItemList:DestroyChildNode()
  end
  self.extra_send_content = nil
  self.extra_send_txt = nil
  self.extra_send_icon_content = nil
  self.extra_send_icon = nil
  self.extra_send_num = nil
  self.top = nil
  self.bottom = nil
  self.send_tip_btn = nil
  self.set_auto_ani_content = nil
  self.auto_ani_select_img = nil
  self.auto_ani_tip = nil
end

local function DataDefine(self)
  self.hasInitScroll = false
  self.giftCells = {}
  self.listGO = {}
  self.showDataList = {}
  self.selectingIndex = NotSelectIndex
  self.giftPosList = {}
  self.giftPosIndex = 1
  self.expireTime = 0
  self.showExpireTime = false
  local param = self:GetUserData()
  self.defaultSelectId = param.defaultSelectId
  self.showTypeJumpPosIndex = param.showTypeJumpPosIndex
  self.showTypeItemContentPosX = param.showTypeItemContentPosX
  self.extraSendContentShow = false
end

local function DataDestroy(self)
  self.hasInitScroll = false
  self.giftCells = {}
  self.listGO = {}
  self.showDataList = {}
  self.selectingIndex = NotSelectIndex
  self.giftPosList = {}
  self.giftPosIndex = 1
  self.expireTime = 0
  self.showExpireTime = false
  self.fromType = nil
  self.extraSendContentShow = nil
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
  if selectData and selectData.isLockGift then
    return
  end
  if selectData and selectData.id and self.giftCells[selectData.id] then
    if self.windowType == GiftSystemConst.WindowType.Show then
      EventManager:GetInstance():Broadcast(EventId.OnGiftOperationEditorTypeSelectChange)
    else
      self.giftCells[selectData.id]:SetSelect(true)
    end
  end
end

local function OnUpdateScroll(self, go, index)
  local item = self.listGO[go]
  local uuid = self.showDataList[index + 1].id
  item:SetActive(uuid ~= nil)
  item:SetData(self.showDataList[index + 1], self.showDataList, index + 1)
  item:SetOnSelect(function(data)
    OnSelectItem(self, data)
    self:RefreshSendBtn()
    self:RefreshBgSize()
  end)
  item:SetShowType(self.windowType)
  local selectData = self.showDataList[self.selectingIndex]
  if selectData then
    item:SetSelect(uuid == selectData.id)
  else
    item:SetSelect(false)
  end
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
  self:AddUIListener(EventId.OnSendUserGiftMsgBack, self.RefreshTop)
  self:AddUIListener(EventId.OnGiftOperationEditorTypeSelectChange, self.OnEditorTypeSelectChange)
  self:AddUIListener(EventId.UpdateOneCommonShop, self.OnShopDataGet)
  self:AddUIListener(EventId.TypeGiftShowAutoAniGuidServerRecord, self.GetAutoAniSetChangeMsg)
end

function LWUIGiftOperationView:OnRemoveListener()
  self:RemoveUIListener(EventId.RefreshItems, self.RefreshView)
  self:RemoveUIListener(EventId.OnSendUserGiftMsgBack, self.RefreshTop)
  self:RemoveUIListener(EventId.OnGiftOperationEditorTypeSelectChange, self.OnEditorTypeSelectChange)
  self:RemoveUIListener(EventId.UpdateOneCommonShop, self.OnShopDataGet)
  self:RemoveUIListener(EventId.TypeGiftShowAutoAniGuidServerRecord, self.GetAutoAniSetChangeMsg)
  base.OnRemoveListener(self)
end

function LWUIGiftOperationView:RefreshView()
  local param = self:GetUserData()
  self.windowType = param.windowType
  self.targetUid = param.targetUid
  self.targetServerId = param.targetServerId
  self.isMoment = param.isMoment
  self.fromType = param.fromType
  self:RefreshTop()
  self:RefreshBottom()
  self:RefreshGoods()
  self.item_bar:SetData(GiftSystemConst.ShopItemId, nil, function()
    UIManager:GetInstance():OpenWindow(UIWindowNames.UILuckyRollShop, {anim = true}, nil, GiftSystemConst.ShopGroupId, GiftSystemConst.ShopItemId)
  end)
  self:RefreshSendBtn()
  self:RefreshSetAutoAniContent()
  self:RefreshBgSize()
end

function LWUIGiftOperationView:RefreshSetAutoAniContent()
  if self.windowType == GiftSystemConst.WindowType.Show then
    self.set_auto_ani_content:SetActive(true)
    local selfSet = DataCenter.GiftSystemManager:GetSelfIsGiftShowAutoAni()
    self.auto_ani_select_img:SetActive(selfSet)
  else
    self.set_auto_ani_content:SetActive(false)
  end
end

function LWUIGiftOperationView:GetAutoAniSetChangeMsg()
  self:RefreshSetAutoAniContent()
end

function LWUIGiftOperationView:RefreshGoods()
  for i = 1, #self.itemBarList do
    self.itemBarList[i]:RefreshData()
  end
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

function LWUIGiftOperationView:OnEditorTypeSelectChange()
  if self.windowType == GiftSystemConst.WindowType.Show then
    self:OnSendBtnClick()
  end
end

function LWUIGiftOperationView:OnShopDataGet(type)
  if type == CommonShopType.GiftShop then
    self:RefreshView()
  end
end

function LWUIGiftOperationView:RefreshGiftShowArea()
  local info = DataCenter.PlayerInfoDataManager.selfPlayerData
  if info == nil then
    SFSNetwork.SendMessage(MsgDefines.GetNewUserInfo, LuaEntry.Player.uid)
  end
  local giftDataList = info and info.giftDataList or {}
  if self.showTypeJumpPosIndex then
    self.giftShowListComponent.selectIndex = self.showTypeJumpPosIndex
    self.showTypeJumpPosIndex = nil
  end
  self.giftShowListComponent:ReInit(giftDataList, GiftShowType.Edit, info.uid)
  if self.showTypeItemContentPosX then
    self.giftShowListComponent:SetItemContentPosX(self.showTypeItemContentPosX)
    self.showTypeItemContentPosX = nil
  end
end

function LWUIGiftOperationView:RefreshBottom()
  if not self.hasInitScroll then
    local bindFunc1 = BindCallback(self, self.OnInitScroll)
    local bindFunc2 = BindCallback(self, self.OnUpdateScroll)
    local bindFunc3 = BindCallback(self, self.OnDestroyScrollItem)
    self.giftItemList:Init(bindFunc1, bindFunc2, bindFunc3)
  end
  self.hasInitScroll = true
  self.showDataList = DataCenter.GiftSystemManager:GetGiftList(self.windowType)
  if self.windowType == GiftSystemConst.WindowType.Show then
    local showDict = DataCenter.GiftSystemManager:GetCurMustShowGiftDict()
    local showList = {}
    for _, v in ipairs(self.showDataList) do
      local goods = DataCenter.GiftSystemManager:GetGiftGoods(v.id)
      if goods and showDict[goods.id] then
        showDict[goods.id] = nil
      end
    end
    for k, v in pairs(showDict) do
      table.insert(showList, v)
    end
    table.sort(showList, function(a, b)
      if a.add_exp ~= b.add_exp then
        return a.add_exp > b.add_exp
      end
      return tonumber(a.id) < tonumber(b.id)
    end)
    for _, v in ipairs(showList) do
      local lockData = {
        isLockGift = true,
        temp = v,
        id = v.id
      }
      table.insert(self.showDataList, lockData)
    end
  end
  if self.defaultSelectId then
    for i, v in ipairs(self.showDataList) do
      if not v.isLockGift and tonumber(v.id) == tonumber(self.defaultSelectId) then
        self.selectingIndex = i
        break
      end
    end
    self.defaultSelectId = nil
  end
  local dataCount = table.count(self.showDataList)
  self.giftItemList:SetItemCount(dataCount)
  self.giftItemList:ForceUpdate()
end

function LWUIGiftOperationView:RefreshBgSize()
  local curTopH = topNormalH
  local curBottomH = bottomContetnNoramlH
  if self.windowType == GiftSystemConst.WindowType.Send then
  elseif self.windowType == GiftSystemConst.WindowType.Show then
    curTopH = topNormalH + (GiftListH - GiftInfoH)
  end
  if self.extraSendContentShow then
    local sizeX, sizeY = self.extra_send_content:GetSizeDeltaXY()
    if sizeY > bottomTipNormalH then
      curBottomH = bottomContetnNoramlH + (sizeY - bottomTipNormalH)
    end
  end
  local curBgH = curTopH + curBottomH + bgDiff
  self.top:SetSizeDeltaY(curTopH)
  self.bottom:SetSizeDeltaY(curBottomH)
  self.b_g:SetSizeDeltaY(curBgH)
end

function LWUIGiftOperationView:RefreshSendBtn()
  self.extraSendContentShow = false
  local isGray = false
  local selectData = self.showDataList[self.selectingIndex]
  local num = 0
  if selectData then
    num = DataCenter.GiftSystemManager:GetGiftNum(selectData.id)
    if num == 0 then
      isGray = true
    end
    local time = DataCenter.GiftSystemManager:GetGiftExpiredTime(selectData.id)
    local now = UITimeManager:GetInstance():GetServerSeconds()
    self.showExpireTime = DataCenter.ItemExchangeManager:IsShowWillExpired(tonumber(selectData.id))
    self.expireTime = time
    self.expireText:SetActive(false)
    self.expireText:SetText(UITimeManager:GetInstance():SecondToFmtString(time - now))
    local goods = DataCenter.GiftSystemManager:GetGiftGoods(selectData.id)
    local isSettingOpen = LuaEntry.DataConfig:CheckSwitch("gift_coupon")
    if goods and #goods.gift_coupon == 2 and self.windowType == GiftSystemConst.WindowType.Send and isSettingOpen then
      self.extra_send_content:SetActive(true)
      self.extraSendContentShow = true
      self:RefreshExtraSendContent(goods)
    else
      self.extra_send_content:SetActive(false)
    end
  else
    self.expireText:SetActive(false)
    self.extra_send_content:SetActive(false)
  end
  self.sendBtnGray:SetActive(false)
  if self.windowType == GiftSystemConst.WindowType.Send then
    if self.isMoment then
      self.sendBtnTxt:SetLocalText("moment_follow_special_btn")
      self.sendBtnGrayTxt:SetLocalText("moment_follow_special_btn")
    else
      local goods
      if selectData then
        goods = DataCenter.GiftSystemManager:GetGiftGoods(selectData.id)
      end
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
  local goods
  if selectData then
    goods = DataCenter.GiftSystemManager:GetGiftGoods(selectData.id)
  end
  self.sendBtn:SetActive(self.windowType == GiftSystemConst.WindowType.Send)
  self.send_tip_btn:SetActive(self.windowType == GiftSystemConst.WindowType.Send and DataCenter.GiftSystemManager:CheckGiftOrderActPass(goods))
end

function LWUIGiftOperationView:RefreshExtraSendContent(goods)
  local goodsId = goods.gift_coupon[1]
  local goodsTemp = DataCenter.ItemTemplateManager:GetItemTemplate(goodsId)
  if goodsTemp then
    local iconPath = string.format(LoadPath.ItemPath, goodsTemp.icon)
    self.extra_send_icon:LoadSpriteAsyncWithCallback(iconPath, function()
      if self.extra_send_icon then
        self.extra_send_icon:SetNativeSize()
        local contentX, contentY = self.extra_send_icon_content:GetSizeDeltaXY()
        local iconX, iconY = self.extra_send_icon:GetSizeDeltaXY()
        local iconScale = contentX / iconX
        self.extra_send_icon:SetLocalScaleXYZ(iconScale, iconScale, iconScale)
      end
    end)
  end
  local msg1 = Localization:GetString("gift_coupon_limit1")
  local msg2 = "\195\151" .. goods.gift_coupon[2]
  local txt2WordCount = string.word_count(msg2)
  local lineContentW, lineContentH = self.extra_send_icon_content:GetSizeDeltaXY()
  local spaceNum = 0
  local oneSpaceW = 5.8335
  local oneSpaceW2 = 5
  if 0 < lineContentW then
    if lineContentW > oneSpaceW * 2 then
      spaceNum = 2 + math.ceil((lineContentW - oneSpaceW * 2) / oneSpaceW2)
    else
      spaceNum = math.ceil(lineContentW / oneSpaceW)
    end
  end
  local spaceStr = ""
  if 2 < spaceNum then
    spaceStr = string.rep("\194\160", spaceNum - 2)
    spaceStr = " " .. spaceStr .. " "
  else
    spaceStr = " " .. "\194\160"
  end
  self.extra_send_txt:SetText(msg1 .. "<link=" .. goodsId .. ">" .. "<u>" .. spaceStr .. msg2 .. "</u></link>")
  local txtSizeX = self.extra_send_txt:GetSizeDelta().x
  local txtPrefabSize = self.extra_send_txt.unity_tmpro:GetPreferredValues(txtSizeX, 0)
  local txtPrefabH = txtPrefabSize.y
  self.extra_send_txt:SetSizeDeltaXY(txtSizeX, txtPrefabH)
  self.extra_send_content:SetSizeDeltaXY(txtSizeX, txtPrefabH)
  self.extra_send_txt.unity_tmpro:ForceMeshUpdate()
  local textInfo = self.extra_send_txt.unity_tmpro.textInfo
  local lineCount = textInfo.lineCount
  if textInfo.characterCount >= spaceNum + txt2WordCount then
    local charInfo1 = textInfo.characterInfo[textInfo.characterCount - spaceNum - txt2WordCount]
    local charInfo2 = textInfo.characterInfo[textInfo.characterCount - 1 - txt2WordCount]
    local position1 = charInfo1.bottomLeft
    local position2 = charInfo2.bottomRight
    self.extra_send_icon_content:SetLocalPosition((position1 + position2) / 2, true)
    local lineH = textInfo.lineInfo[lineCount - 1].lineHeight
    local aPosX = self.extra_send_icon_content:GetAnchoredPositionX()
    local aPosY = self.extra_send_icon_content:GetAnchoredPositionY()
    aPosX = CommonUtil.ArabicAutoMirrorFactor() * aPosX
    self.extra_send_icon_content:SetAnchoredPositionXY(aPosX, aPosY + lineH / 4, true)
  end
end

function LWUIGiftOperationView:OnPointerClick(clickPos)
  local linkId = self.extra_send_txt:TryGetPointerClickLinkID(clickPos)
  if string.IsNullOrEmpty(linkId) then
    return
  end
  local goodsId = tonumber(linkId) or 0
  if 0 < goodsId then
    local des_txt = DataCenter.ItemTemplateManager:GetDes(goodsId)
    UIUtil.ShowBubbleTips(des_txt, self.extra_send_icon.transform.position, 0, 20, 0, nil, nil, {reversal = true})
  end
end

function LWUIGiftOperationView:OnSendTipBtnClick()
  local des_txt = Localization:GetString("activity_gift1")
  UIUtil.ShowBubbleTips(des_txt, self.send_tip_btn.transform.position, 0, 20, 0, nil, nil, {reversal = true})
end

function LWUIGiftOperationView:OnSetAutoAniContentClick()
  local selfSet = DataCenter.GiftSystemManager:GetSelfIsGiftShowAutoAni()
  DataCenter.GiftSystemManager:SetSelfIsGiftShowAutoAni(not selfSet)
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
    self.selectingIndex = NotSelectIndex
  elseif self.isMoment then
    self:DoFristFollowSendGift()
  else
    self:DoSendGift()
  end
end

function LWUIGiftOperationView:DoFristFollowSendGift()
  local selectData = self.showDataList[self.selectingIndex]
  if selectData then
    local num = DataCenter.GiftSystemManager:GetGiftNum(selectData.id)
    local showDataList = DataCenter.CommonShopManager:GetGoodsListByShopType(CommonShopType.GiftShop)
    local shopItem
    for _, v in ipairs(showDataList) do
      if v.itemId == selectData.id then
        shopItem = v
        break
      end
    end
    if num == 0 and shopItem == nil then
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
    DataCenter.GiftSystemManager:OpenDetailView(param, true)
  end
end

function LWUIGiftOperationView:DoSendGift()
  local selectData = self.showDataList[self.selectingIndex]
  if selectData then
    local num = DataCenter.GiftSystemManager:GetGiftNum(selectData.id)
    local showDataList = DataCenter.CommonShopManager:GetGoodsListByShopType(CommonShopType.GiftShop)
    local shopItem
    for _, v in ipairs(showDataList) do
      if v.itemId == selectData.id then
        shopItem = v
        break
      end
    end
    if num == 0 and shopItem == nil then
      LWResourceLackUtil:GotoGoodsItemLack(selectData.id, 1)
      return
    end
  else
    return
  end
  local param = {
    template = self.showDataList[self.selectingIndex],
    targetUid = self.targetUid,
    targetServerId = self.targetServerId,
    fromType = self.fromType
  }
  DataCenter.GiftSystemManager:OpenDetailView(param, true)
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
  self.giftShowListComponent:TrySetCurSelectPlayTargetAni()
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
