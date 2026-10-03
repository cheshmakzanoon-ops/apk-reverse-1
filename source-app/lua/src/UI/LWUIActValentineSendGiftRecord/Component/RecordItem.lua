local base = UIBaseContainer
local RecordItem = BaseClass("RecordItem", UIBaseContainer)
local Localization = CS.GameEntry.Localization
local MulitMaxNum = 5
local player_path = "cell/player"
local gender_icon1_path = "cell/NameContent/GenderIcon1"
local gender_icon2_path = "cell/NameContent/GenderIcon2"
local name_text_path = "cell/NameContent/NameText"
local msg_content_path = "msgContent"
local msg_txt_path = "msgContent/msgTxt"
local content_txt_path = "cell/contentTxt"
local u_i_common_res_item_path = "cell/UICommonResItem"
local time_path = "cell/time"

function RecordItem:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function RecordItem:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function RecordItem:ComponentDefine()
  self.root = self:AddComponent(UIBaseContainer, "")
  self.player = self:AddComponent(UICommonHead, player_path)
  self.gender_icon1 = self:AddComponent(UIImage, gender_icon1_path)
  self.gender_icon2 = self:AddComponent(UIImage, gender_icon2_path)
  self.name_text = self:AddComponent(UIText, name_text_path)
  self.player:SetEnableClickShowInfo(true)
  self.msg_content = self:AddComponent(UIBaseContainer, msg_content_path)
  self.msg_txt = self:AddComponent(UITextMeshProUGUIEx, msg_txt_path)
  self.content_txt = self:AddComponent(UITextMeshProUGUIEx, content_txt_path)
  self.u_i_common_res_item = self:AddComponent(UICommonResItem, u_i_common_res_item_path)
  self.time = self:AddComponent(UITextMeshProUGUIEx, time_path)
end

function RecordItem:ComponentDestroy()
  self.content_txt = nil
  self.u_i_common_res_item = nil
  self.time = nil
end

function RecordItem:DataDefine()
end

function RecordItem:DataDestroy()
end

function RecordItem:OnAddListener()
  base.OnAddListener(self)
end

function RecordItem:OnRemoveListener()
  base.OnRemoveListener(self)
end

function RecordItem:SetData(activityId, data, targetItemId, sendFunc, scroll_view, index, targetActId, nextOpenTimeReal)
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

function RecordItem:RefreshView()
  local data = self.data.userInfo
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
  self.msg_content:SetActive(false)
  local param = {
    rewardType = RewardType.GOODS,
    itemId = self.data.itemId,
    count = self.data.num
  }
  self.u_i_common_res_item:ReInit(param)
  self.time:SetText(UITimeManager:GetInstance():TimeStampToTimeForServer(self.data.sendTime * 1000))
end

return RecordItem
