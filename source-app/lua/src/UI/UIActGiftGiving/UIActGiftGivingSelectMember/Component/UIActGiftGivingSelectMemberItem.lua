local UIActGiftGivingSelectMemberItem = BaseClass("UIActGiftGivingSelectMemberItem", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local MulitMaxNum = 5
local player_path = "player"
local gender_icon1_path = "NameContent/GenderIcon1"
local gender_icon2_path = "NameContent/GenderIcon2"
local name_text_path = "NameContent/NameText"
local power_text_path = "PowerText"
local use_btn_path = "UseBtn"
local mult_use_content_path = "MultUseContent"
local mult_use_btn_path = "MultUseContent/MultUseBtn"
local mult_use_text_path = "MultUseContent/MultUseBtn/MultUseText"
local content_txt_path = "contentTxt"
local recommand_img_path = "recommandImg"
local recommand_bg_path = "RecommandBg"

function UIActGiftGivingSelectMemberItem:OnCreate()
  base.OnCreate(self)
  self.player = self:AddComponent(UICommonHead, player_path)
  self.gender_icon1 = self:AddComponent(UIImage, gender_icon1_path)
  self.gender_icon2 = self:AddComponent(UIImage, gender_icon2_path)
  self.name_text = self:AddComponent(UIText, name_text_path)
  self.power_text = self:AddComponent(UIText, power_text_path)
  self.king_icon = self:AddComponent(UIImage, "iconKing")
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
  self.content_txt = self:AddComponent(UITextMeshProUGUIEx, content_txt_path)
  self.recommand_img = self:AddComponent(UIImage, recommand_img_path)
  self.recommand_bg = self:AddComponent(UIRawImage, recommand_bg_path)
end

function UIActGiftGivingSelectMemberItem:OnDestroy()
  self.use_btn = nil
  self.mult_use_content = nil
  self.mult_use_btn = nil
  self.mult_use_text = nil
  self.content_txt = nil
  self.recommand_img = nil
  self.recommand_bg = nil
  base.OnDestroy(self)
end

function UIActGiftGivingSelectMemberItem:ReInit(showData, activityId, targetItemId, sendFunc, index)
  self.showData = showData
  self.data = showData.playerData
  local data = self.data
  self.activityId = activityId
  self.targetItemId = targetItemId
  self.sendFunc = sendFunc
  self.index = index
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
  self.power_text:SetLocalText(100392, string.GetFormattedSeperatorNum(data.power))
  local governmentInfo = DataCenter.GovernmentManager:GetPositionInfoByUID(data.uid)
  if governmentInfo ~= nil and governmentInfo.positionId ~= nil then
    local config = DataCenter.GovernmentTemplateManager:GetTemplate(governmentInfo.positionId)
    if config ~= nil then
      self.king_icon:SetActive(true)
      self.king_icon:LoadSprite(config.icon)
      self.king_icon:SetNativeSize()
    else
      self.king_icon:SetActive(false)
    end
  else
    self.king_icon:SetActive(false)
  end
  local isRecommand = not string.IsNullOrEmpty(self.data.recommendType)
  local recommandTxt = ""
  if isRecommand then
    local recommendType = tostring(self.data.recommendType)
    local recommendVal = tostring(self.data.recommendValue)
    local keyData = string.split(recommendType, ";")
    local valData = string.split(recommendVal, ";")
    for i = 1, #keyData do
      local keyId = tonumber(keyData[i]) or 0
      local val = valData[i]
      if 0 < keyId and val ~= nil and val ~= "" then
        local key
        local temp = LocalController:instance():getLine(TableName.Activity_Thanksgiving_Rec_Type, keyId)
        if temp ~= nil then
          key = temp.key
        end
        if not string.IsNullOrEmpty(key) then
          recommandTxt = recommandTxt .. Localization:GetString(key, val) .. "\n"
        end
      end
    end
  end
  self.recommand_img:SetActive(isRecommand)
  self.recommand_bg:SetActive(isRecommand)
  self.content_txt:SetText(recommandTxt)
  if isRecommand then
    self.name_text:SetColorRGBA255(198, 89, 0, 255)
    self.content_txt:SetColorRGBA255(161, 77, 39, 255)
  else
    self.name_text:SetColorRGBA255(42, 40, 48, 255)
    self.content_txt:SetColorRGBA255(115, 104, 99, 255)
  end
  self:RefreshBtnContent()
end

function UIActGiftGivingSelectMemberItem:RefreshBtnContent()
  local MulitNum = self:GetCurMulitNum()
  self.mult_use_content:SetActive(self.showData.isMult and 1 < MulitNum)
  self.mult_use_text:SetText("x" .. MulitNum)
end

function UIActGiftGivingSelectMemberItem:OnClickUseBtn()
  local playerUid = LuaEntry.Player.uid
  if playerUid == self.data.uid then
    UIUtil.ShowTipsId("thxgiv_GiveMyself")
    return
  end
  local curNum = DataCenter.ItemData:GetItemCount(self.targetItemId)
  if 0 < curNum then
    if self.sendFunc then
      self.sendFunc(self.activityId, self.data.uid, 1, self.index)
    end
  else
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIActGiftGivingDropPanel, {anim = true}, self.activityId)
  end
end

function UIActGiftGivingSelectMemberItem:OnClickMultUseBtn()
  local playerUid = LuaEntry.Player.uid
  if playerUid == self.data.uid then
    UIUtil.ShowTipsId("thxgiv_GiveMyself")
    return
  end
  local MulitNum = self:GetCurMulitNum()
  if 0 < MulitNum and self.sendFunc then
    self.sendFunc(self.activityId, self.data.uid, MulitNum, self.index)
  end
end

function UIActGiftGivingSelectMemberItem:GetCurMulitNum()
  local curNum = DataCenter.ItemData:GetItemCount(self.targetItemId)
  local multNum = MulitMaxNum
  return math.min(curNum, multNum)
end

return UIActGiftGivingSelectMemberItem
