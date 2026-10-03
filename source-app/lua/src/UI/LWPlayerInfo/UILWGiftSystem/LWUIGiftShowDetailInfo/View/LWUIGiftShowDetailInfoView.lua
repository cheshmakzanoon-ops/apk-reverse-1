local base = UIBaseView
local LWUIGiftShowDetailInfoView = BaseClass("LWUIGiftShowDetailInfoView", base)
local Localization = CS.GameEntry.Localization
local GiftShowMessageContent = require("UI.LWPlayerInfo.UILWGiftSystem.LWUIGiftShowDetailInfo.Component.GiftShowMessageContent")
local GiftShowModelContent = require("UI.LWPlayerInfo.UILWGiftSystem.LWUIGiftShowDetailInfo.Component.GiftShowModelContent")
local GiftShowSendMaxContent = require("UI.LWPlayerInfo.UILWGiftSystem.LWUIGiftShowDetailInfo.Component.GiftShowSendMaxContent")
local GiftNumMenuContent = require("UI.LWPlayerInfo.UILWGiftSystem.LWUIGiftShowDetailInfo.Component.GiftNumMenuContent")
local model_show_content_path = "Root/center/ModelShowContent"
local info_content_path = "Root/center/InfoContent"
local send_gift_btn_path = "Root/center/BtnContent/SendGiftBtn"
local record_btn_path = "Root/center/BtnContent/RecordBtn"
local btn_back_path = "Root/bottom/BtnBack"
local source_btn_path = "Root/center/BtnContent/SourceBtn"
local message_show_info_path = "Root/center/ModelShowContent/messageShowInfo"
local send_max_info_path = "Root/center/InfoContent/sendMaxInfo"
local select_menu_pos_set_path = "Root/SelectMenuPosSet"
local select_menu_path = "Root/SelectMenu"
local text_title_path = "Root/top/TextTitle"
local title_player_info_path = "Root/top/titlePlayerInfo"
local title_u_i_player_head_path = "Root/top/titlePlayerInfo/showContent/titleUIPlayerHead"
local title_player_desc_txt_path = "Root/top/titlePlayerInfo/showContent/titlePlayerDescTxt"
local bg_content_purple_path = "Root_bg/bgContent_purple"
local bg_content_gold_path = "Root_bg/bgContent_gold"
local gift_num_path = "Root/center/ModelShowContent/GiftIconContent/giftNum"
local sin15d = 0.2588
local cos15d = 0.9659
local PurpleColorQuality = 4
local viewStateType = {
  MoveInAni = 1,
  Idle = 2,
  ChangeIndexAni1 = 3,
  ChangeIndexAni2 = 4
}
local minChangeAniTImeScale = 1
local minChangeAniTImeScale2 = 0.5

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:InitData()
  self:RefreshView()
  self:RefreshBgContent()
  self:PlayMoveInAni()
  self:TryPostEventLog()
end

local function OnDestroy(self)
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function LWUIGiftShowDetailInfoView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.OnGetGiftDetailMsgBack, self.OnGetGiftDetailMsgBackFunc)
  self:AddUIListener(EventId.OnSetGiftDetailMsgBack, self.OnGetGiftDetailChangeMsgBackFunc)
  self:AddUIListener(EventId.OnGiftDetailDataDirty, self.OnGiftDetailDataDirtyFunc)
  self:AddUIListener(EventId.GetNewUserInfoSucc, self.OnPlayerDataCallBack)
  self:AddUIListener(EventId.OnGiftShowDeatilViewReopen, self.OnGiftShowDeatilViewReopen)
  self:AddUIListener(EventId.OnOtherPlayerGiftShowDataChange, self.OnOtherPlayerGiftShowDataChangeFunc)
end

function LWUIGiftShowDetailInfoView:OnRemoveListener()
  self:RemoveUIListener(EventId.OnGetGiftDetailMsgBack, self.OnGetGiftDetailMsgBackFunc)
  self:RemoveUIListener(EventId.OnSetGiftDetailMsgBack, self.OnGetGiftDetailChangeMsgBackFunc)
  self:RemoveUIListener(EventId.OnGiftDetailDataDirty, self.OnGiftDetailDataDirtyFunc)
  self:RemoveUIListener(EventId.GetNewUserInfoSucc, self.OnPlayerDataCallBack)
  self:RemoveUIListener(EventId.OnGiftShowDeatilViewReopen, self.OnGiftShowDeatilViewReopen)
  self:RemoveUIListener(EventId.OnOtherPlayerGiftShowDataChange, self.OnOtherPlayerGiftShowDataChangeFunc)
  base.OnRemoveListener(self)
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function ComponentDefine(self)
  self.model_show_content = self:AddComponent(GiftShowModelContent, model_show_content_path)
  self.info_content = self:AddComponent(UIBaseContainer, info_content_path)
  self.send_gift_btn = self:AddComponent(UIButton, send_gift_btn_path)
  self.record_btn = self:AddComponent(UIButton, record_btn_path)
  self.btn_back = self:AddComponent(UIButton, btn_back_path)
  self.btn_back:SetOnClick(BindCallback(self, self.OnBackBtnClick))
  self.send_gift_btn:SetOnClick(BindCallback(self, self.OnSendGiftBtnClick))
  self.record_btn:SetOnClick(BindCallback(self, self.OnRecordBtnClick))
  self.message_show_info = self:AddComponent(GiftShowMessageContent, message_show_info_path)
  self.send_max_info = self:AddComponent(GiftShowSendMaxContent, send_max_info_path)
  self.model_show_content:SetChangeFunc(function(offset)
    self:OnChangeIndexBtnClick(offset)
  end)
  self.message_show_info:SetInfoDataSetFunc(function(isContentStateSet, isMaxStateSet, isFirstStateSet)
    self:OnInfoDataSet(isContentStateSet, isMaxStateSet, isFirstStateSet)
  end)
  self.send_max_info:SetInfoDataSetFunc(function(isContentStateSet, isMaxStateSet, isFirstStateSet)
    self:OnInfoDataSet(isContentStateSet, isMaxStateSet, isFirstStateSet)
  end)
  self.select_menu_pos_set = self:AddComponent(UIBaseContainer, select_menu_pos_set_path)
  self.select_menu = self:AddComponent(GiftNumMenuContent, select_menu_path)
  self.source_btn = self:AddComponent(UIButton, source_btn_path)
  self.source_btn:SetOnClick(function()
    self:OnSourceBtnClick()
  end)
  self.text_title = self:AddComponent(UITextMeshProUGUIEx, text_title_path)
  self.title_player_info = self:AddComponent(UIImage, title_player_info_path)
  self.title_u_i_player_head = self:AddComponent(UICommonHead, title_u_i_player_head_path)
  self.title_player_desc_txt = self:AddComponent(UITextMeshProUGUIEx, title_player_desc_txt_path)
  self.bg_content_purple = self:AddComponent(UIBaseContainer, bg_content_purple_path)
  self.bg_content_gold = self:AddComponent(UICanvasGroup, bg_content_gold_path)
  self.rootAni = self:AddComponent(UISimpleAnimation, "")
  self.gift_num = self:AddComponent(UITextMeshProUGUIEx, gift_num_path)
end

local function ComponentDestroy(self)
  self.model_show_content = nil
  self.info_content = nil
  self.send_gift_btn = nil
  self.record_btn = nil
  self.btn_back = nil
  self.message_show_info = nil
  self.send_max_info = nil
  self.select_menu_pos_set = nil
  self.select_menu = nil
  self.source_btn = nil
  self.text_title = nil
  self.title_player_info = nil
  self.title_u_i_player_head = nil
  self.title_player_desc_txt = nil
  self.bg_content_purple = nil
  self.bg_content_gold = nil
  self.rootAni = nil
  self.gift_num = nil
end

local function DataDefine(self)
  self.targetUid = nil
  self.targetServerId = nil
  self.originIdList = {}
  self.originIdIndex = 1
  self.curOriginId = nil
  self.showData = nil
  self.giftGoodsTemp = nil
  self.goodsTemp = nil
  self.curViewState = viewStateType.Idle
  self.curViewStateFinTime = nil
  self.curViewAni = nil
  self.bgAniSeq = nil
end

local function DataDestroy(self)
  self.targetUid = nil
  self.targetServerId = nil
  self.originIdList = nil
  self.originIdIndex = nil
  self.curOriginId = nil
  self.showData = nil
  self.giftGoodsTemp = nil
  self.goodsTemp = nil
  self.curViewState = nil
  self.curViewStateFinTime = nil
  self.curViewAni = nil
  self.bgAniSeq = nil
end

function LWUIGiftShowDetailInfoView:OnGiftShowDeatilViewReopen(data)
  if data == nil then
    return
  end
  local param = data
  self.targetUid = param.targetUid
  self.targetServerId = param.targetServerId
  self.originIdList = param.originIdList
  self.originIdIndex = param.originIdIndex
  self.isEditorType = self.targetUid == LuaEntry.Player.uid
  self:RefreshData()
  self:RefreshView()
  self:RefreshBgContent()
  self:PlayMoveInAni()
  self:TryPostEventLog()
end

local function InitData(self)
  local param = self:GetUserData()
  self.targetUid = param.targetUid
  self.targetServerId = param.targetServerId
  self.originIdList = param.originIdList
  self.originIdIndex = param.originIdIndex
  self.isEditorType = self.targetUid == LuaEntry.Player.uid
  self:RefreshData()
end

local function RefreshData(self)
  if self.originIdList and self.originIdIndex and self.originIdList[self.originIdIndex] then
    self.curOriginId = self.originIdList[self.originIdIndex]
  end
  if self.curOriginId and self.curOriginId > 0 then
    self.showData = DataCenter.GiftDetailShowDataManager:GetDataWithoutCheckExpired(self.targetUid, self.curOriginId)
    local isNeedRefreshData = DataCenter.GiftDetailShowDataManager:CheckDataNeedUpdate(self.targetUid, self.curOriginId)
    if isNeedRefreshData then
      SFSNetwork.SendMessage(MsgDefines.GetGiftDetail, self.curOriginId, self.targetUid)
    end
  else
    self.showData = nil
  end
  self:TryGetOtherGiftData()
  if self.curOriginId and self.curOriginId > 0 then
    self.giftGoodsTemp = DataCenter.GiftSystemManager:GetGiftGoods(self.curOriginId)
    if self.giftGoodsTemp then
      local goodsId = self.giftGoodsTemp.convert_item
      if goodsId and 0 < goodsId then
        self.goodsTemp = DataCenter.ItemTemplateManager:GetItemTemplate(goodsId)
      end
    end
  end
end

function LWUIGiftShowDetailInfoView:TryGetOtherGiftData()
  local listNum = #self.originIdList
  local needOriginIdDict = {}
  local preOriginIdIndex = self.originIdIndex - 1
  local preOriginIdIndexS0 = preOriginIdIndex - 1
  if preOriginIdIndexS0 < 0 then
    local dataNum = math.modf(-1 * preOriginIdIndexS0 / listNum)
    preOriginIdIndexS0 = preOriginIdIndexS0 + (dataNum + 1) * listNum
  end
  if listNum <= preOriginIdIndexS0 then
    preOriginIdIndexS0 = preOriginIdIndexS0 % listNum
  end
  preOriginIdIndex = preOriginIdIndexS0 + 1
  local preOriginId = self.originIdList[preOriginIdIndex]
  needOriginIdDict[preOriginId] = true
  local nextOriginIdIndex = self.originIdIndex + 1
  local nextOriginIdIndexS0 = nextOriginIdIndex - 1
  if nextOriginIdIndexS0 < 0 then
    local dataNum = math.modf(-1 * nextOriginIdIndexS0 / listNum)
    nextOriginIdIndexS0 = nextOriginIdIndexS0 + (dataNum + 1) * listNum
  end
  if listNum <= nextOriginIdIndexS0 then
    nextOriginIdIndexS0 = nextOriginIdIndexS0 % listNum
  end
  nextOriginIdIndex = nextOriginIdIndexS0 + 1
  local nextOriginId = self.originIdList[nextOriginIdIndex]
  needOriginIdDict[nextOriginId] = true
  needOriginIdDict[self.curOriginId] = nil
  for originId, v in pairs(needOriginIdDict) do
    local showData = DataCenter.GiftDetailShowDataManager:GetDataWithoutCheckExpired(self.targetUid, originId)
    if showData == nil then
      SFSNetwork.SendMessage(MsgDefines.GetGiftDetail, originId, self.targetUid)
    end
  end
end

local function RefreshView(self)
  self.send_gift_btn:SetActive(not self.isEditorType)
  self.record_btn:SetActive(self.isEditorType)
  self.model_show_content:SetData(self.targetUid, self.originIdList, self.curOriginId, self.showData, self.giftGoodsTemp, self.goodsTemp)
  self:RefreshInfoContentView()
  self.select_menu:SetActive(false)
  self:RefreshTopContent()
end

function LWUIGiftShowDetailInfoView:RefreshBgContent()
  if self.goodsTemp.color <= PurpleColorQuality then
    self.bg_content_purple:SetActive(true)
    self.bg_content_gold:SetActive(false)
  else
    self.bg_content_purple:SetActive(false)
    self.bg_content_gold:SetActive(true)
    self.bg_content_gold:SetAlpha(1)
  end
end

function LWUIGiftShowDetailInfoView:PlayMoveInAni()
  local curTime = UITimeManager:GetInstance():GetServerTime()
  self.rootAni:Stop()
  local state, time = self.rootAni:PlayAnimationReturnTime("MoveIn")
  if state then
    self.curViewStateFinTime = curTime + time * 1000
    self.curViewState = viewStateType.MoveInAni
  end
end

function LWUIGiftShowDetailInfoView:RefreshInfoContentView()
  self.message_show_info:SetData(self.targetUid, self.originIdList, self.curOriginId, self.showData, self.giftGoodsTemp, self.goodsTemp)
  self.send_max_info:SetData(self.targetUid, self.originIdList, self.curOriginId, self.showData, self.giftGoodsTemp, self.goodsTemp)
end

function LWUIGiftShowDetailInfoView:RefreshTopContent()
  if self.isEditorType then
    self.text_title:SetActive(true)
    self.title_player_info:SetActive(false)
  else
    self.text_title:SetActive(false)
    self.title_player_info:SetActive(true)
    local info = ChatInterface.getMoment():GetMomentFollowInfo(self.targetUid)
    if not info then
      ChatManager2:GetInstance().Net:SendMessage(ChatMsgDefines.MomentFollowState, self.targetUid)
    end
    local userInfo = UIUtil.GetPlayerInfoShowByUid(self.targetUid)
    if userInfo then
      local name = UIUtil.FormatServerAllianceName(userInfo.serverId, userInfo.alAbbr, userInfo.name)
      self.title_u_i_player_head:ParseHeadInfo(userInfo)
      self.title_player_desc_txt:SetLocalText("gift_detail_desc_1", name)
    end
  end
  self:RefreshGiftNumContent()
end

function LWUIGiftShowDetailInfoView:RefreshGiftNumContent()
  local num = 0
  if self.targetUid == LuaEntry.Player.uid then
    local goods = DataCenter.GiftSystemManager:GetGiftGoods(self.curOriginId)
    if goods then
      num = DataCenter.GiftSystemManager:GetGiftNum(goods.convert_item)
    end
  else
    local userInfo = UIUtil.GetPlayerInfoShowByUid(self.targetUid)
    if userInfo and userInfo.giftDataList then
      for i = 1, #userInfo.giftDataList do
        local data = userInfo.giftDataList[i]
        local itemId = data.itemId
        local itemNum = data.count
        local originId = DataCenter.GiftSystemManager:GetOriginId(itemId)
        if self.curOriginId == originId then
          num = itemNum
          break
        end
      end
    end
  end
  if 0 < num then
    self.gift_num:SetText("\195\151" .. num)
  else
    self.gift_num:SetText("")
  end
end

function LWUIGiftShowDetailInfoView:OnPlayerDataCallBack()
  self:RefreshTopContent()
end

function LWUIGiftShowDetailInfoView:OnOtherPlayerGiftShowDataChangeFunc(info)
  if info and self.targetUid == info.uid then
    self:RefreshGiftNumContent()
  end
end

function LWUIGiftShowDetailInfoView:OnMenuHideMsg()
  self.select_menu:SetActive(false)
  self.model_show_content.menuShow = false
  self.model_show_content:RefreshMenuShowBtn()
end

function LWUIGiftShowDetailInfoView:OnSetMenuShow(targetContainer, dataList, selectKey, selectFunc)
  local targetSizeDelta = targetContainer:GetSizeDelta()
  self.select_menu_pos_set:SetSizeDeltaXY(targetSizeDelta.x, targetSizeDelta.y)
  self.select_menu_pos_set:SetPosition(targetContainer:GetPosition())
  local posSetPos = self.select_menu_pos_set:GetAnchoredPosition()
  self.select_menu:SetActive(true)
  self.select_menu:SetAnchoredPositionXY(posSetPos.x, posSetPos.y - targetSizeDelta.y / 2)
  self.select_menu:SetData(targetContainer, dataList, selectKey, selectFunc)
end

function LWUIGiftShowDetailInfoView:OnBackBtnClick()
  self.ctrl:CloseSelf()
end

function LWUIGiftShowDetailInfoView:OnSendGiftBtnClick()
  DataCenter.GiftSystemManager:OpenOperationView({
    windowType = GiftSystemConst.WindowType.Send,
    targetUid = self.targetUid,
    targetServerId = self.targetServerId,
    defaultSelectId = self.curOriginId
  })
end

function LWUIGiftShowDetailInfoView:OnRecordBtnClick()
  UIManager:GetInstance():OpenWindow(UIWindowNames.LWUIGiftHistory, {anim = true}, {
    targetUid = self.targetUid,
    itemId = self.curOriginId
  })
end

function LWUIGiftShowDetailInfoView:OnSourceBtnClick()
  local goodsId = self.curOriginId
  LWResourceLackUtil:GotoGoodsItemLack(goodsId, 1)
end

function LWUIGiftShowDetailInfoView:Update()
  if self.curViewStateFinTime == nil then
    return
  end
  local curTime = UITimeManager:GetInstance():GetServerTime()
  if curTime > self.curViewStateFinTime then
    self:OnViewStateFinChange()
  end
end

function LWUIGiftShowDetailInfoView:OnViewStateFinChange()
  local curTime = UITimeManager:GetInstance():GetServerTime()
  if self.curViewState == viewStateType.Idle then
  elseif self.curViewState == viewStateType.MoveInAni then
    self.curViewState = viewStateType.Idle
    self.curViewStateFinTime = nil
  elseif self.curViewState == viewStateType.ChangeIndexAni1 then
    self.curViewState = viewStateType.ChangeIndexAni2
    local aniName = "ToLeft2"
    if self.curViewAni == "ToLeft" then
      aniName = "ToLeft2"
    elseif self.curViewAni == "ToRight" then
      aniName = "ToRight2"
    end
    self.rootAni:Stop()
    local state, time = self.rootAni:PlayAnimationReturnTime(aniName)
    local stateTime = self.changeAniTime * 1000 * minChangeAniTImeScale2
    self.curViewStateFinTime = curTime + stateTime
    self:RefreshView()
    local curBgIsPurple = self.goodsTemp.color <= PurpleColorQuality
    if curBgIsPurple ~= self.preBgIsPurple then
      self.bg_content_purple:SetActive(true)
      self.bg_content_gold:SetActive(true)
      if curBgIsPurple then
        self.bg_content_gold:SetAlpha(1)
        self:PlayBgChangeAni(false, stateTime / 1000)
      else
        self.bg_content_gold:SetAlpha(0)
        self:PlayBgChangeAni(true, stateTime / 1000)
      end
    end
  elseif self.curViewState == viewStateType.ChangeIndexAni2 then
    self:StopBgChangeAni()
    self:RefreshBgContent()
    self.curViewState = viewStateType.Idle
    self.curViewStateFinTime = nil
  end
end

function LWUIGiftShowDetailInfoView:PlayBgChangeAni(isShowAni, time)
  self:StopBgChangeAni()
  self.bgAniSeq = CS.DG.Tweening.DOTween.Sequence()
  if isShowAni then
    self.bgAniSeq:Append(self.bg_content_gold:FadeIn(time))
  else
    self.bgAniSeq:Append(self.bg_content_gold:FadeOut(time))
  end
end

function LWUIGiftShowDetailInfoView:StopBgChangeAni()
  if self.bgAniSeq then
    self.bgAniSeq:Kill()
    self.bgAniSeq = nil
  end
end

function LWUIGiftShowDetailInfoView:OnChangeIndexBtnClick(offset)
  if self.curViewState ~= viewStateType.Idle then
    return
  end
  self.originIdIndex = self.originIdIndex + offset
  local listNum = #self.originIdList
  local s0Index = self.originIdIndex - 1
  if s0Index < 0 then
    local dataNum = math.modf(-1 * s0Index / listNum)
    s0Index = s0Index + (dataNum + 1) * listNum
  end
  if listNum <= s0Index then
    s0Index = s0Index % listNum
  end
  self.originIdIndex = s0Index + 1
  local oldCurOriginId = self.curOriginId
  self.preBgIsPurple = self.goodsTemp.color <= PurpleColorQuality
  self:RefreshData()
  if oldCurOriginId ~= self.curOriginId then
    local aniName
    if 0 < offset then
      aniName = "ToRight"
    else
      aniName = "ToLeft"
    end
    self.rootAni:Stop()
    local state, time = self.rootAni:PlayAnimationReturnTime(aniName)
    if state then
      self.changeAniTime = time
      local curTime = UITimeManager:GetInstance():GetServerTime()
      local stateTime = self.changeAniTime * 1000 * minChangeAniTImeScale
      self.curViewState = viewStateType.ChangeIndexAni1
      self.curViewStateFinTime = curTime + stateTime
      self.curViewAni = aniName
    else
      self:RefreshView()
      self:RefreshBgContent()
    end
  end
end

function LWUIGiftShowDetailInfoView:OnInfoDataSet(isContentStateSet, isMaxStateSet, isFirstStateSet)
  if self.showData == nil then
    return
  end
  self.showData:SendSetDataMsg(isContentStateSet, isMaxStateSet, isFirstStateSet)
end

function LWUIGiftShowDetailInfoView:OnGetGiftDetailMsgBackFunc(msg)
  local targetUid = msg.targetUid
  if targetUid == nil then
    targetUid = LuaEntry.Player.uid
  end
  local itemId = msg.itemId
  if targetUid == self.targetUid and itemId == self.curOriginId then
    self.showData = DataCenter.GiftDetailShowDataManager:GetDataWithoutCheckExpired(self.targetUid, self.curOriginId)
    if self.curViewState == viewStateType.Idle or self.curViewState == viewStateType.MoveInAni or self.curViewState == viewStateType.ChangeIndexAni2 then
      self.model_show_content:SetData(self.targetUid, self.originIdList, self.curOriginId, self.showData, self.giftGoodsTemp, self.goodsTemp)
      self:RefreshInfoContentView()
    end
  end
end

function LWUIGiftShowDetailInfoView:OnGetGiftDetailChangeMsgBackFunc(msg)
  local targetUid = msg.targetUid
  if targetUid == nil then
    targetUid = LuaEntry.Player.uid
  end
  local itemId = msg.params.itemId
  if targetUid == self.targetUid and itemId == self.curOriginId then
    self.showData = DataCenter.GiftDetailShowDataManager:GetDataWithoutCheckExpired(self.targetUid, self.curOriginId)
    self.model_show_content:SetData(self.targetUid, self.originIdList, self.curOriginId, self.showData, self.giftGoodsTemp, self.goodsTemp)
    self:RefreshInfoContentView()
  end
end

function LWUIGiftShowDetailInfoView:OnGiftDetailDataDirtyFunc(msg)
  local targetUid = msg.targetUid
  local itemId = msg.itemId
  if targetUid == self.targetUid and itemId == self.curOriginId then
    local isNeedRefreshData = DataCenter.GiftDetailShowDataManager:CheckDataNeedUpdate(self.targetUid, self.curOriginId)
    if isNeedRefreshData then
      SFSNetwork.SendMessage(MsgDefines.GetGiftDetail, self.curOriginId, self.targetUid)
    end
  end
end

function LWUIGiftShowDetailInfoView:TryPostEventLog()
  if self.curOriginId and self.curOriginId > 0 then
    if self.targetUid == LuaEntry.Player.uid then
      PostEventLog.Track(PostEventLog.Defines.C_PLAYERGIFTSHOW_SELF, {
        id = self.curOriginId
      })
    else
      PostEventLog.Track(PostEventLog.Defines.C_PLAYERGIFTSHOW_OTHERS, {
        id = self.curOriginId
      })
    end
  end
end

LWUIGiftShowDetailInfoView.OnCreate = OnCreate
LWUIGiftShowDetailInfoView.OnDestroy = OnDestroy
LWUIGiftShowDetailInfoView.OnEnable = OnEnable
LWUIGiftShowDetailInfoView.OnDisable = OnDisable
LWUIGiftShowDetailInfoView.ComponentDefine = ComponentDefine
LWUIGiftShowDetailInfoView.ComponentDestroy = ComponentDestroy
LWUIGiftShowDetailInfoView.DataDefine = DataDefine
LWUIGiftShowDetailInfoView.DataDestroy = DataDestroy
LWUIGiftShowDetailInfoView.InitData = InitData
LWUIGiftShowDetailInfoView.RefreshData = RefreshData
LWUIGiftShowDetailInfoView.RefreshView = RefreshView
return LWUIGiftShowDetailInfoView
