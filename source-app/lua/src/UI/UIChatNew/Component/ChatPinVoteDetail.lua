local base = require("UI.UIChatNew.Component.ChatPinVote")
local ChatPinVoteDetail = BaseClass("ChatPinVoteDetail", base)
local OptionCell = require("UI.UIChatNew.Component.VoteOptionItem")
local UIGray = CS.UIGray

function ChatPinVoteDetail:ComponentDefine()
  self.title = self:AddComponent(UIText, "layout/title")
  self.layout = self:AddComponent(UIBaseContainer, "layout")
  self.countText = self:AddComponent(UIText, "countText")
  self.endTimeText = self:AddComponent(UIText, "endTimeText")
  self.item = self.transform:Find("optionItem").gameObject
  self.optionList = self:AddComponent(UIBaseContainer, "optionList")
  self.sendBtn = self:AddComponent(UIButton, "ConfirmButton")
  self.sendBtnText = self:AddComponent(UIText, "ConfirmButton/ConfirmTitleTxt")
  self.imgTranslated = self:AddComponent(UIImage, "layout/title/bottom/imgTranslated")
  self.nodeTranslating = self:AddComponent(UIBaseContainer, "layout/title/bottom/nodeTranslating")
  self.txtTranslating = self:AddComponent(UITextMeshProUGUIEx, "layout/title/bottom/nodeTranslating/txtTranslating")
  self.btnTranslate = self:AddComponent(UIButton, "layout/title/bottom/btnTranslate")
  self.btnTranslate:SetOnClick(function()
    self:OnClickTranslate()
  end)
  self.sendBtn:SetOnClick(function()
    self:SendMessage()
  end)
  self.item:GameObjectCreatePool()
end

function ChatPinVoteDetail:OnTimeEnd()
  self:SetAllOptionBtnInteractable(false)
  self:SetAllOptionBtnOnTimeEnd()
end

function ChatPinVoteDetail:SetAllOptionBtnInteractable(isOn)
  if not self.optionCellList then
    return
  end
  for i = 1, #self.optionCellList do
    if self.optionCellList[i] and self.optionCellList[i].SetSelectBtnInteractable then
      self.optionCellList[i]:SetSelectBtnInteractable(isOn)
    end
  end
end

function ChatPinVoteDetail:SetAllOptionBtnOnTimeEnd()
  if not self.optionCellList then
    return
  end
  for i = 1, #self.optionCellList do
    if self.optionCellList[i] and self.optionCellList[i].OnTimeEnd then
      self.optionCellList[i]:OnTimeEnd()
    end
  end
end

function ChatPinVoteDetail:SetAllOptionBtnActive(isOn)
  if not self.optionCellList then
    return
  end
  for i = 1, #self.optionCellList do
    if self.optionCellList[i] and self.optionCellList[i].SetSelectBtnSetActive then
      self.optionCellList[i]:SetSelectBtnSetActive(isOn)
    end
  end
end

function ChatPinVoteDetail:ReInit(data, updateItemAfterTranslateRecv)
  base.ReInit(self, data)
  self.data = data
  self.optionCellList = {}
  self.updateCallBack = updateItemAfterTranslateRecv
  self.item:GameObjectRecycleAll()
  self.optionList:RemoveComponents(OptionCell)
  self.optionDatas = data.voteData.voteInfo.options
  self.sendBtn:SetActive(not self:GetIsEnd())
  local isShowSendBtn = true
  for i = 1, #self.optionDatas do
    local item = self.item.gameObject:GameObjectSpawn(self.item.transform)
    item.name = "item_" .. i
    item.transform:SetParent(self.optionList.transform)
    local optionCell = self.optionList:AddComponent(OptionCell, item.name)
    self.optionDatas[i].voteId = self.data.voteData.voteId
    optionCell:ReInit(self.optionDatas[i], self, i, function(index, isOn)
      self:OnOptionCellClick(index, isOn)
    end, self.data)
    table.insert(self.optionCellList, optionCell)
    if self.optionDatas[i].isTotal then
      isShowSendBtn = false
    end
    optionCell:SetSelectBtnSetActive(not self:GetIsEnd())
  end
  if not isShowSendBtn then
    UIGray.SetGray(self.sendBtn.transform, true, false)
    self.sendBtnText:SetLocalText("poll_btn2")
  else
    UIGray.SetGray(self.sendBtn.transform, false, true)
    self.sendBtnText:SetLocalText("poll_btn1")
  end
  self.imgTranslated:SetActive(self.data:IsTrans())
  self.nodeTranslating:SetActive(false)
  self.btnTranslate:SetActive(not self.data:IsTrans())
  self:SetAllOptionBtnInteractable(isShowSendBtn)
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.transform)
end

function ChatPinVoteDetail:OnClickTranslate()
  if not self.data then
    return
  end
  if self.beTransCount and self.beTransCount > 0 then
    return
  end
  self.beTransCount = 0
  self.btnTranslate:SetActive(false)
  self.nodeTranslating:SetActive(true)
  for i = 1, #self.optionDatas do
    if not self.optionDatas[i].transText then
      self.beTransCount = self.beTransCount + 1
      self:GoTrans(self.optionDatas[i].item, i)
    end
  end
  if not self.data.voteData.voteInfo.titleTrans then
    self.beTransCount = self.beTransCount + 1
    self:GoTrans(self.data.voteData.voteInfo.title)
  end
end

function ChatPinVoteDetail:GoTrans(text, index)
  self.btnTranslate:SetActive(false)
  self.nodeTranslating:SetActive(true)
  ChatManager2:GetInstance().Translate:Translate(text, nil, nil, function(ok, rtnTbl)
    self.beTransCount = self.beTransCount - 1
    if ok then
      DataCenter.AllianceNoticeManager:SaveTranslatedContentById(self.data.uid, rtnTbl.translateMsg, index)
      self.data = DataCenter.AllianceNoticeManager:GetNoticeDataById(self.data.uid)
    else
      self.btnTranslate:SetActive(true)
      self.nodeTranslating:SetActive(false)
      UIUtil.ShowTipsId(rtnTbl.code)
    end
    if self.beTransCount == 0 then
      self:ReInit(self.data, self.updateCallBack)
      self.updateCallBack()
    end
  end)
end

function ChatPinVoteDetail:OnOptionCellClick(index, isOn)
  if self.data.voteData.voteInfo.type == VoteType.radio and isOn and isOn then
    for i = 1, #self.optionCellList do
      if self.optionCellList[i].index ~= index then
        self.optionCellList[i]:SetSelect(false)
      end
    end
  end
end

function ChatPinVoteDetail:SetSelectCell(itemId, isOn)
end

function ChatPinVoteDetail:SendMessage()
  self.selectDic = {}
  for i = 1, #self.optionCellList do
    if self.optionCellList[i].select then
      self.selectDic[self.optionCellList[i].data.itemId] = true
    end
  end
  if table.count(self.selectDic) > 0 then
    SFSNetwork.SendMessage(MsgDefines.VoteSubmit, self.data.voteData.voteId, self.selectDic, self.data.uid)
  end
end

function ChatPinVoteDetail:OnDestroy()
  if not IsNull(self.item) then
    self.item:GameObjectRecycleAll()
  end
  base.OnDestroy(self)
end

function ChatPinVoteDetail:DataDestroy()
end

function ChatPinVoteDetail:ComponentDestroy()
  self.optionList:RemoveComponents(OptionCell)
  self.title = nil
  self.countText = nil
  self.endTimeText = nil
  self.item = nil
  self.optionList = nil
  self.sendBtn = nil
  self.sendBtnText = nil
  self.imgTranslated = nil
  self.nodeTranslating = nil
  self.txtTranslating = nil
  self.btnTranslate = nil
end

return ChatPinVoteDetail
