local base = UIBaseContainer
local VoteOptionItem = BaseClass("VoteOptionItem", base)
local Localization = CS.GameEntry.Localization

function VoteOptionItem:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
end

function VoteOptionItem:ComponentDefine()
  self.title = self:AddComponent(UIText, "itemInfo/txtRaw")
  self.slider = self:AddComponent(UISlider, "itemInfo/ProcessPart/Slider")
  self.itemInfoCom = self:AddComponent(UIBaseContainer, "itemInfo")
  self.selectBtn = self:AddComponent(UIButton, "Common_duihao_kuang")
  self.selectImg = self:AddComponent(UIImage, "Common_duihao_kuang/Common_duihao")
  self.opText = self:AddComponent(UIText, "itemInfo/ProcessPart/opText")
  self.voteListBtn = self:AddComponent(UIButton, "itemInfo/ProcessPart/totalBtn")
  self.voteListBtn:SetOnClick(BindCallback(self, self.OnVoteListClick))
  self.selectBtn:SetOnClick(function()
    self.select = not self.select
    self:RefreshSelectBtn()
    if self.clickCallBack then
      self.clickCallBack(self.index, self.select)
    end
  end)
end

function VoteOptionItem:OnVoteListClick()
  if self.noticeData == nil or self.noticeData.uid == nil then
    return
  end
  local voteItemPlayerList = DataCenter.AllianceNoticeManager:GetVoteItemPlayerInfoList(self.noticeData.uid)
  if voteItemPlayerList == nil then
    Logger.LogError("OnVoteListClick  \230\138\149\231\165\168\228\191\161\230\129\175\228\184\141\229\173\152\229\156\168\239\188\140\230\149\176\230\141\174\229\143\175\232\131\189\229\183\178\231\187\143\232\162\171\229\136\160\233\153\164")
    return
  end
  local playerList = voteItemPlayerList[tostring(self.index)]
  UIManager:GetInstance():OpenWindow(UIWindowNames.LWUIVotePlayerList, {anim = true}, {
    index = self.index,
    playerList = playerList
  })
end

function VoteOptionItem:SetSelect(isOn)
  self.select = isOn
  self:RefreshSelectBtn()
end

function VoteOptionItem:RefreshSelectBtn()
  self.selectImg:SetActive(self.select)
  self.voteDetail:SetSelectCell(self.data.itemId, self.select)
end

function VoteOptionItem:ReInit(data, voteDetail, index, clickCallBack, noticeData)
  self.data = data
  self.noticeData = noticeData
  self.voteDetail = voteDetail
  self.index = index or 1
  self.clickCallBack = clickCallBack
  self:RefreshView()
end

function VoteOptionItem:RefreshView()
  local haveSendSelect = self:GetSelfHaveSendSelect()
  local isEnd = self:GetIsEnd()
  local isHideOtherSelect = not isEnd and not haveSendSelect
  self.title:SetText(self.index .. ". " .. (self.data.transText or self.data.item))
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.title.transform)
  local sliderVal = self.data.count / self.data.maxTotal
  if isHideOtherSelect then
    sliderVal = 0
  end
  self.slider:SetValue(sliderVal)
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.itemInfoCom.transform)
  local itemInfoSize = self.itemInfoCom:GetSizeDelta()
  self.opText:SetText(self.data.count or 0 .. Localization:GetString("poll_btn2"))
  self:SetSizeDeltaY(itemInfoSize.y)
  self.select = self.data.isTotal
  self:RefreshSelectBtn()
  self:GetAnchoredPosition()
  local isCryptonym = self.noticeData.voteData.voteInfo.isCryptonym
  self.voteListBtn:SetActive(not isCryptonym and not isHideOtherSelect)
  self.opText:SetActive(not isHideOtherSelect)
end

function VoteOptionItem:SetSelectBtnInteractable(isOn)
  self.selectBtn:SetInteractable(isOn)
end

function VoteOptionItem:SetSelectBtnSetActive(isOn)
  self.selectBtn:SetActive(isOn)
end

function VoteOptionItem:GetSelfHaveSendSelect()
  local haveSendSelect = false
  if self.noticeData then
    local optionDatas = self.noticeData.voteData.voteInfo.options
    if optionDatas then
      for i = 1, #optionDatas do
        if optionDatas[i].isTotal then
          haveSendSelect = true
          break
        end
      end
    end
  end
  return haveSendSelect
end

function VoteOptionItem:GetIsEnd()
  local curTime = UITimeManager:GetInstance():GetServerTime()
  local time = self.noticeData.voteData.endTime - curTime
  return time < 0
end

function VoteOptionItem:OnTimeEnd()
  self:RefreshView()
end

function VoteOptionItem:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function VoteOptionItem:DataDestroy()
end

function VoteOptionItem:ComponentDestroy()
  self.title = nil
  self.slider = nil
  self.itemInfoCom = nil
  self.selectBtn = nil
  self.selectImg = nil
  self.opText = nil
  self.voteListBtn = nil
end

return VoteOptionItem
