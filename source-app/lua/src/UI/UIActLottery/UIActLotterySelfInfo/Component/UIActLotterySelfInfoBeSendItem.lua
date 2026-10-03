local base = UIBaseContainer
local UIActLotterySelfInfoBeSendItem = BaseClass("UIActLotterySelfInfoBeSendItem", UIBaseContainer)
local Localization = CS.GameEntry.Localization
local MulitMaxNum = 5
local player_path = "cell/player"
local gender_icon1_path = "cell/NameContent/GenderIcon1"
local gender_icon2_path = "cell/NameContent/GenderIcon2"
local name_text_path = "cell/NameContent/NameText"
local use_btn_path = "cell/UseBtn"
local mult_use_content_path = "cell/MultUseContent"
local mult_use_btn_path = "cell/MultUseContent/MultUseBtn"
local mult_use_text_path = "cell/MultUseContent/MultUseBtn/MultUseText"
local msg_content_path = "msgContent"
local msg_txt_path = "msgContent/msgTxt"
local content_txt_path = "cell/contentTxt"

function UIActLotterySelfInfoBeSendItem:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UIActLotterySelfInfoBeSendItem:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIActLotterySelfInfoBeSendItem:ComponentDefine()
  self.root = self:AddComponent(UIBaseContainer, "")
  self.player = self:AddComponent(UICommonHead, player_path)
  self.gender_icon1 = self:AddComponent(UIImage, gender_icon1_path)
  self.gender_icon2 = self:AddComponent(UIImage, gender_icon2_path)
  self.name_text = self:AddComponent(UIText, name_text_path)
  self.player:SetEnableClickShowInfo(true)
  self.use_btn = self:AddComponent(UIButton, use_btn_path)
  self.mult_use_content = self:AddComponent(UIBaseContainer, mult_use_content_path)
  self.mult_use_btn = self:AddComponent(UIButton, mult_use_btn_path)
  self.mult_use_text = self:AddComponent(UITextMeshProUGUIEx, mult_use_text_path)
  self.use_btn:SetOnClick(function()
    self:OnClickUseBtn()
  end)
  self.mult_use_btn:SetOnClick(function()
    self:OnClickMultUseBtn()
  end)
  self.msg_content = self:AddComponent(UIBaseContainer, msg_content_path)
  self.msg_txt = self:AddComponent(UITextMeshProUGUIEx, msg_txt_path)
  self.content_txt = self:AddComponent(UITextMeshProUGUIEx, content_txt_path)
end

function UIActLotterySelfInfoBeSendItem:ComponentDestroy()
  self.content_txt = nil
end

function UIActLotterySelfInfoBeSendItem:DataDefine()
end

function UIActLotterySelfInfoBeSendItem:DataDestroy()
end

function UIActLotterySelfInfoBeSendItem:OnAddListener()
  base.OnAddListener(self)
end

function UIActLotterySelfInfoBeSendItem:OnRemoveListener()
  base.OnRemoveListener(self)
end

function UIActLotterySelfInfoBeSendItem:SetData(activityId, data, targetItemId, sendFunc, scroll_view, index, targetActId, nextOpenTimeReal)
  self.activityId = activityId
  self.data = data
  self.targetItemId = targetItemId
  self.sendFunc = sendFunc
  self.scroll_view = scroll_view
  self.index = index
  self.targetActId = targetActId
  self.nextOpenTimeReal = nextOpenTimeReal
  self:RefreshView()
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.root.transform)
  self.scroll_view:OnItemSizeChanged(self.index)
end

function UIActLotterySelfInfoBeSendItem:RefreshView()
  local data = self.data.shareInfo
  local presidentName
  local headBgImg = DataCenter.DecorationDataManager:GetHeadFrame(data.headSkinId, data.headSkinET)
  if not string.IsNullOrEmpty(data.abbr) then
    presidentName = "[" .. data.abbr .. "]" .. data.name
  else
    presidentName = data.name
  end
  self.name_text:SetText(presidentName)
  self.player:SetHead(data.uid, data.pic, data.picVer or data.picver, nil, headBgImg)
  self.gender_icon1:SetActive(data.gender == 1 or data.sex == 1)
  self.gender_icon2:SetActive(data.gender == 2 or data.sex == 2)
  self.content_txt:SetActive(self.data.returnGift and self.data.returnGift > 0)
  local message = self.data.leavingMessage
  if not string.IsNullOrEmpty(message) then
    self.msg_content:SetActive(true)
    self.msg_txt:SetText(message)
  else
    self.msg_content:SetActive(false)
  end
  self:RefreshBtnContent()
end

function UIActLotterySelfInfoBeSendItem:RefreshBtnContent()
  local isInEndTime = self.nextOpenTimeReal == 0
  self.use_btn:SetActive(not isInEndTime)
  local MulitNum = self:GetCurMulitNum()
  self.mult_use_content:SetActive(not isInEndTime and self.data.isMult and 1 < MulitNum)
  self.mult_use_text:SetText("x" .. MulitNum)
end

function UIActLotterySelfInfoBeSendItem:GetCurMulitNum()
  local curNum = DataCenter.ItemData:GetItemCount(self.targetItemId)
  local multNum = MulitMaxNum
  return math.min(curNum, multNum)
end

function UIActLotterySelfInfoBeSendItem:OnClickUseBtn()
  local isInEndTime = self.nextOpenTimeReal == 0
  if isInEndTime then
    return
  end
  local curNum = DataCenter.ItemData:GetItemCount(self.targetItemId)
  if 0 < curNum then
    if self.sendFunc then
      self.sendFunc(self.activityId, self.data.shareInfo.uid, 1, self.data.uuid)
    end
  else
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIActGiftGivingDropPanel, {anim = true}, self.targetActId)
  end
end

function UIActLotterySelfInfoBeSendItem:OnClickMultUseBtn()
  local isInEndTime = self.nextOpenTimeReal == 0
  if isInEndTime then
    return
  end
  local MulitNum = self:GetCurMulitNum()
  if 0 < MulitNum then
    if self.sendFunc then
      self.sendFunc(self.activityId, self.data.shareInfo.uid, MulitNum, self.data.uuid)
    end
  else
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIActGiftGivingDropPanel, {anim = true}, self.targetActId)
  end
end

return UIActLotterySelfInfoBeSendItem
