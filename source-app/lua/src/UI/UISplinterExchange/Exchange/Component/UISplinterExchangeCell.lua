local base = UIBaseContainer
local UISplinterExchangeCell = BaseClass("UISplinterExchangeCell", base)
local Localization = CS.GameEntry.Localization
local UIManager = _ENV.UIManager
local UIWindowNames = _ENV.UIWindowNames
local UISplinterExchangeItem = require("UI.UISplinterExchange.Component.UISplinterExchangeItem")
local LoseExchangeItem_path = "RightPanel/LoseExchangeItem"
local ReceiveExchangeItem_path = "LeftPanel/ReceiveExchangeItem"
local ExchangeBtn_path = "ExchangeBtn"
local left_name_text_path = "Bg/LeftHead/TextGroup/LeftNameText"
local LeftPlayerHead_Path = "Bg/LeftHead/UILeftPlayerHead"
local change_require_tips_text_path = "Bg/LeftHead/TextGroup/ChangeRequireTipsText"
local left_head_path = "Bg/LeftHead"
local chat_tips_text_path = "Bg/ChatTipsText"
local disable_exchange_path = "DisableExchange"
local dialogIdNormal = "Treasure_map_20"
local dialogIdInvalid = "Treasure_map_19"

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

local function OnDestroy(self)
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function ComponentDefine(self)
  self.LoseExchangeItem = self:AddComponent(UISplinterExchangeItem, LoseExchangeItem_path)
  self.ReceiveExchangeItem = self:AddComponent(UISplinterExchangeItem, ReceiveExchangeItem_path)
  self.ExchangeBtn = self:AddComponent(UIButton, ExchangeBtn_path)
  self.left_name_text = self:AddComponent(UITextMeshProUGUIEx, left_name_text_path)
  self.ExchangeBtn:SetOnClick(BindCallback(self, self.OnExchangeBtnClick))
  self.LeftPlayerHead = self:AddComponent(UICommonHead, LeftPlayerHead_Path)
  self.LeftPlayerHead:SetEnableClickShowInfo(true, true)
  self.change_require_tips_text = self:AddComponent(UITextMeshProUGUIEx, change_require_tips_text_path)
  self.left_head = self:AddComponent(UIBaseContainer, left_head_path)
  self.chat_tips_text = self:AddComponent(UITextMeshProUGUIEx, chat_tips_text_path)
  self.disable_exchange = self:AddComponent(UIImage, disable_exchange_path)
end

local function ComponentDestroy(self)
  self.LoseExchangeItem = nil
  self.ReceiveExchangeItem = nil
  self.ExchangeBtn = nil
  self.left_name_text = nil
  self.LeftPlayerHead = nil
  self.change_require_tips_text = nil
  self.left_head = nil
  self.chat_tips_text = nil
  self.disable_exchange = nil
  self.disable_exchange = nil
end

local function DataDefine(self)
  self.data = nil
  self.receiveFragId = 0
  self.loseFragId = 0
  self.loseFragNum = 0
  self.changeBtnTipsId = dialogIdNormal
  self.isChangeBtnGray = false
end

local function DataDestroy(self)
  self.data = nil
  self.receiveFragId = nil
  self.loseFragId = nil
  self.loseFragNum = nil
  self.changeBtnTipsId = nil
  self.isChangeBtnGray = nil
end

local function SetData(self, data)
  self.data = data
  if data.ownerId == LuaEntry.Player.uid then
    self.receiveFragId = self.data.needFragment
    self.loseFragId = self.data.costFragment
  else
    self.receiveFragId = self.data.costFragment
    self.loseFragId = self.data.needFragment
  end
  self.ReceiveExchangeItem:SetData(self.receiveFragId, DispathTreasureExchangeItemType.None, DataCenter.SplinterExchangeManager:GetIndexStrByGoodsId(self.data.type, self.receiveFragId))
  self.ReceiveExchangeItem:SetTitleText("Treasure_map_51")
  self.LoseExchangeItem:SetData(self.loseFragId, DispathTreasureExchangeItemType.None, DataCenter.SplinterExchangeManager:GetIndexStrByGoodsId(self.data.type, self.loseFragId))
  self.LoseExchangeItem:SetTitleText("Treasure_map_52")
  self.loseFragNum = DataCenter.ItemData:GetItemCount(self.loseFragId)
  CS.UIGray.SetGray(self.ExchangeBtn.transform, self.loseFragNum == 0, true)
  self.isChangeBtnGray = false
  self.changeBtnTipsId = dialogIdNormal
  if self.left_head:GetActive() then
    if self.data.uid then
      local framePath = DataCenter.DecorationDataManager:GetHeadFrame(self.data.headSkinId, self.data.headSkinET, false)
      self.LeftPlayerHead:SetData(self.data.uid, self.data.headPic, self.data.headPicVer, nil, framePath)
      self.LeftPlayerHead:SetActive(true)
      local showName = DataCenter.PlayerInfoDataManager:GetRemarkOrRealName(self.data.uid, self.data.name)
      self.left_name_text:SetText(showName)
      self.left_name_text:SetActive(true)
    else
      self.LeftPlayerHead:SetActive(false)
      self.left_name_text:SetActive(false)
    end
    self.change_require_tips_text:SetText(Localization:GetString("Treasure_map_53"))
  end
end

local function SetChatItemDataInit(self, dialogId)
  self.left_head:SetActive(false)
  self.chat_tips_text:SetLocalText(dialogId)
  self.chat_tips_text:SetActive(true)
end

local function SetChangeBtnUninteractable(self)
  self.ExchangeBtn:SetInteractable(false)
  self.disable_exchange:SetActive(true)
end

local function SetChangeBtnInteractable(self)
  self.ExchangeBtn:SetInteractable(true)
  self.disable_exchange:SetActive(false)
end

local function RefreshChangeBtnChanged(self, exchanged)
  CS.UIGray.SetGray(self.ExchangeBtn.transform, exchanged, true)
  self.isChangeBtnGray = exchanged
  self.changeBtnTipsId = exchanged and dialogIdInvalid or dialogIdNormal
end

local function OnExchangeBtnClick(self)
  if self.loseFragNum > 0 then
    if self.isChangeBtnGray then
      UIUtil.ShowTipsId(self.changeBtnTipsId)
      return
    end
    local param = {}
    param.receiveFragId = self.receiveFragId
    param.loseFragId = self.loseFragId
    param.titleDialogId = "Treasure_map_07"
    param.type = self.data.type
    
    function param.callback()
      if self.data then
        local msgParam = {}
        msgParam.uuid = self.data.uuid
        SFSNetwork.SendMessage(MsgDefines.DispatchTreasureALExchange, msgParam)
      else
        UIUtil.ShowTipsId(dialogIdInvalid)
      end
    end
    
    UIManager:GetInstance():OpenWindow(UIWindowNames.UISplinterExchangeConfirm, {anim = true}, param)
  else
    UIUtil.ShowTipsId(self.changeBtnTipsId or dialogIdNormal)
  end
end

UISplinterExchangeCell.OnCreate = OnCreate
UISplinterExchangeCell.OnDestroy = OnDestroy
UISplinterExchangeCell.OnEnable = OnEnable
UISplinterExchangeCell.OnDisable = OnDisable
UISplinterExchangeCell.ComponentDefine = ComponentDefine
UISplinterExchangeCell.ComponentDestroy = ComponentDestroy
UISplinterExchangeCell.DataDefine = DataDefine
UISplinterExchangeCell.DataDestroy = DataDestroy
UISplinterExchangeCell.SetData = SetData
UISplinterExchangeCell.SetChatItemDataInit = SetChatItemDataInit
UISplinterExchangeCell.SetChangeBtnUninteractable = SetChangeBtnUninteractable
UISplinterExchangeCell.SetChangeBtnInteractable = SetChangeBtnInteractable
UISplinterExchangeCell.RefreshChangeBtnChanged = RefreshChangeBtnChanged
UISplinterExchangeCell.OnExchangeBtnClick = OnExchangeBtnClick
return UISplinterExchangeCell
