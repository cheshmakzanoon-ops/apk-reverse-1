local UITrainPrepareThanksRecordItem = BaseClass("UITrainPrepareThanksRecordItem", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local bg_path = "bg"
local bg_icon_path = "bgIcon"
local txt_time_path = "Txt_Time"
local head_icon_path = "PlayerBtn/UIPlayerHead"
local txt_name_path = "Txt_Name"
local txt_desc_path = "Txt_Desc"
local u_i_common_res_item_path = "UICommonResItem"
local emoji_path = "emoji"
local emoji_img_path = "emoji/emojiImg"

function UITrainPrepareThanksRecordItem:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UITrainPrepareThanksRecordItem:OnDestroy()
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

function UITrainPrepareThanksRecordItem:ComponentDefine()
  self.bg = self:AddComponent(UIButton, bg_path)
  self.bg_icon = self:AddComponent(UIImage, bg_icon_path)
  self.txt_time = self:AddComponent(UIText, txt_time_path)
  self.player_btn = self:AddComponent(UIButton, head_icon_path)
  self.head_icon = self:AddComponent(UICommonHead, head_icon_path)
  self.head_icon:SetEnableClickShowInfo(true, true)
  self.txt_name = self:AddComponent(UITextMeshProUGUIEx, txt_name_path)
  self.txt_desc = self:AddComponent(UITextMeshProUGUIEx, txt_desc_path)
  self.u_i_common_res_item = self:AddComponent(UICommonResItem, u_i_common_res_item_path)
  self.emoji = self:AddComponent(UIImage, emoji_path)
  self.emoji_img = self:AddComponent(UIImage, emoji_img_path)
end

function UITrainPrepareThanksRecordItem:ComponentDestroy()
  self.bg = nil
  self.bg_icon = nil
  self.txt_time = nil
  self.player_btn = nil
  self.head_icon = nil
  self.txt_name = nil
  self.txt_desc = nil
  self.u_i_common_res_item = nil
  self.emoji = nil
  self.emoji_img = nil
end

function UITrainPrepareThanksRecordItem:DataDefine()
end

function UITrainPrepareThanksRecordItem:DataDestroy()
end

function UITrainPrepareThanksRecordItem:OnAddListener()
  base.OnAddListener(self)
end

function UITrainPrepareThanksRecordItem:OnRemoveListener()
  base.OnRemoveListener(self)
end

function UITrainPrepareThanksRecordItem:SetItem(logInfo)
  self.playerUid = nil
  if logInfo == nil then
    return
  end
  local name = UIUtil.FormatAllianceAndName(logInfo.abbr, logInfo.name)
  self.txt_name:SetText(name)
  self.txt_time:SetText(UITimeManager:GetInstance():TimeStampToMDHSForLocalMinute(logInfo.time))
  local logInfoUid = logInfo.uid
  self.playerUid = logInfoUid
  self.head_icon:SetHeadAndFrame(logInfo.uid, logInfo.headPic, logInfo.headPicVer, false, logInfo.headSkinId, logInfo.headSkinET)
  local index = logInfo.index
  local lang = DataCenter.LWAllyStationDataManager:GetThanksLang(index)
  if string.IsNullOrEmpty(lang) then
    self.txt_desc:SetText("")
  else
    self.txt_desc:SetText(Localization:GetString(lang))
  end
  local num = logInfo.num
  if num < 1 then
    self.u_i_common_res_item:SetActive(false)
    return
  end
  self.u_i_common_res_item:SetActive(true)
  local itemId = DataCenter.LWAllyStationDataManager.CHANGE_TRAIN_COST_ITEM
  local iconData = {}
  iconData.rewardType = RewardType.GOODS
  iconData.itemId = itemId
  iconData.count = num
  self.u_i_common_res_item:ReInit(iconData)
  local emojiId = DataCenter.LWAllyStationDataManager:GetEmoji(index)
  self:ShowEmoji(emojiId)
end

function UITrainPrepareThanksRecordItem:ShowEmoji(emojiId)
  if emojiId and 0 < emojiId then
    local data = LocalController:instance():getLine(TableName.LW_EMOJI, emojiId)
    if data then
      local path = "Assets/Main/Sprites/UI/LWChatEmoji/Default/" .. data.path .. ".png"
      self.emoji_img:LoadSprite(path)
      self.emoji:SetActive(true)
      return
    end
  end
  self.emoji:SetActive(false)
end

return UITrainPrepareThanksRecordItem
