local UIShareLuckyBuffPopupView = BaseClass("UIShareLuckyBuffPopupView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization

function UIShareLuckyBuffPopupView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:InitPopup()
end

function UIShareLuckyBuffPopupView:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIShareLuckyBuffPopupView:OnEnable()
  base.OnEnable(self)
  self.openSound = DataCenter.LWSoundManager:PlaySound(92015, false)
end

function UIShareLuckyBuffPopupView:OnDisable()
  base.OnDisable(self)
  if self.openSound then
    DataCenter.LWSoundManager:StopSound(self.openSound)
    self.openSound = nil
  end
end

function UIShareLuckyBuffPopupView:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.btnMask = self.viewSkin:AddComponent(self, UIButton, 1)
  self.btnMask:SetOnClick(function()
    self:OnBtnMaskClick()
  end)
  self.textTitle = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 2)
  self.btnClose = self.viewSkin:AddComponent(self, UIButton, 3)
  self.btnClose:SetOnClick(function()
    self:OnBtnCloseClick()
  end)
  self.compMultipleGroup = self.viewSkin:AddComponent(self, UIBaseComponent, 4)
  self.btnLeftArrow = self.viewSkin:AddComponent(self, UIButton, 5)
  self.btnLeftArrow:SetOnClick(function()
    self:OnBtnLeftArrowClick()
  end)
  self.btnRightArrow = self.viewSkin:AddComponent(self, UIButton, 6)
  self.btnRightArrow:SetOnClick(function()
    self:OnBtnRightArrowClick()
  end)
  self.textMultipleTitle = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 7)
  self.btnShare = self.viewSkin:AddComponent(self, UIButton, 8)
  self.btnShare:SetOnClick(function()
    self:OnBtnShareClick()
  end)
  self.textShareBtn = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 9)
  self.textShareTime = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 10)
  self.textTip = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 11)
  self.compShownRewardItem = self.viewSkin:AddComponent(self, UICommonResItem, 12)
  self.btnJoin = self.viewSkin:AddComponent(self, UIButton, 13)
  self.btnJoin:SetOnClick(function()
    self:OnBtnJoinClick()
  end)
  self.textJoinBtn = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 14)
  self.textJoinTime = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 15)
  self.rawImgBG = self.viewSkin:AddComponent(self, UIRawImage, 16)
  if not IsNull(self.textTip.unity_tmpro) then
    function self.textTip.unity_tmpro.onPointerClick(eventData)
      self:OnPointerClick(eventData)
    end
  end
end

function UIShareLuckyBuffPopupView:ComponentDestroy()
  self.viewSkin = nil
  self.btnMask = nil
  self.textTitle = nil
  self.btnClose = nil
  self.compMultipleGroup = nil
  self.btnLeftArrow = nil
  self.btnRightArrow = nil
  self.textMultipleTitle = nil
  self.btnShare = nil
  self.textShareBtn = nil
  self.textShareTime = nil
  self.textTip = nil
  self.compShownRewardItem = nil
  self.btnJoin = nil
  self.textJoinBtn = nil
  self.textJoinTime = nil
  self.rawImgBG = nil
end

function UIShareLuckyBuffPopupView:DataDefine()
  self.curSelectedPacketIndex = 0
  self.curTotalPacketNum = 0
  self.curLuckyPacketList = {}
  self.isPlayerInAlliance = false
end

function UIShareLuckyBuffPopupView:DataDestroy()
  self.curSelectedPacketIndex = nil
  self.curTotalPacketNum = nil
  self.curLuckyPacketList = nil
  self.isPlayerInAlliance = nil
  self.openSound = nil
end

function UIShareLuckyBuffPopupView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.LUCKY_PACKET_SHARE_SUCCESS, self.RefreshLuckyPacket)
end

function UIShareLuckyBuffPopupView:OnRemoveListener()
  self:RemoveUIListener(EventId.LUCKY_PACKET_SHARE_SUCCESS, self.RefreshLuckyPacket)
  base.OnRemoveListener(self)
end

function UIShareLuckyBuffPopupView:OnBtnMaskClick()
end

function UIShareLuckyBuffPopupView:OnBtnCloseClick()
  self.ctrl:CloseSelf()
end

function UIShareLuckyBuffPopupView:OnBtnLeftArrowClick()
  if self.curSelectedPacketIndex == 1 or 1 >= self.curTotalPacketNum then
    return
  end
  self:SetLuckyPacketInfo(self.curSelectedPacketIndex - 1)
end

function UIShareLuckyBuffPopupView:OnBtnRightArrowClick()
  if self.curSelectedPacketIndex == self.curTotalPacketNum or self.curTotalPacketNum <= 1 then
    return
  end
  self:SetLuckyPacketInfo(self.curSelectedPacketIndex + 1)
end

function UIShareLuckyBuffPopupView:OnBtnShareClick()
  local lucky_packet_info = self:GetLuckyPacketInfo(self.curSelectedPacketIndex)
  if not lucky_packet_info then
    return
  end
  local lucky_packet_config = DataCenter.LuckyBuffManager:GetLuckyConfigById(lucky_packet_info.configId)
  if not lucky_packet_config then
    return
  end
  local lucky_packet_template = DataCenter.RedPacketTemplateManager:GetTemplate(lucky_packet_config.red_packet)
  if not lucky_packet_template then
    return
  end
  if CoppaUtil.IsCoppaLimitWithTips() then
    return
  end
  if CrossServerUtil:GetIsCrossServer() and not lucky_packet_template:IsCanCrossServer() then
    UIUtil.ShowTipsId("red_pocket_desc18")
    return
  end
  if not lucky_packet_template:Condition(true) then
    return
  end
  local share_param = {}
  share_param.post = PostType.RedPackge_New
  share_param.uid = lucky_packet_info.uid
  share_param.expireTime = lucky_packet_info.expireTime or 0
  share_param.redPocketId = lucky_packet_template.goodsId
  share_param.redPocketType = lucky_packet_template.type
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIPositionShare, {anim = true}, share_param)
end

function UIShareLuckyBuffPopupView:OnBtnJoinClick()
  UIManager:GetInstance():OpenWindow(UIWindowNames.UILWAlCreateJoin, {anim = true}, {guide = false})
  self.ctrl:CloseSelf()
end

function UIShareLuckyBuffPopupView:OnPointerClick(eventData)
  if not eventData then
    return
  end
  local clickPos = eventData.position
  local linkId = self.textTip:TryGetPointerClickLinkID(clickPos)
  if string.IsNullOrEmpty(linkId) then
    return
  end
  local status_config = DataCenter.StatusManager:GetTemplate(tonumber(linkId))
  if not (status_config and status_config.icon) or not status_config.description then
    return
  end
  local param = {}
  param.icon = status_config.icon
  param.descTip = Localization:GetString(status_config.description)
  param.screenPos = clickPos
  param.yPosFix = 40
  param.width = 460
  param.preferTop = false
  UIManager:GetInstance():OpenWindow(UIWindowNames.UILuckyBuffTips, {anim = true}, param)
end

function UIShareLuckyBuffPopupView:Update1000MS()
  local lucky_packet_info = self:GetLuckyPacketInfo(self.curSelectedPacketIndex)
  if not lucky_packet_info then
    return
  end
  self:UpdateCountDownText(lucky_packet_info.expireTime or 0)
end

function UIShareLuckyBuffPopupView:RefreshLuckyPacket()
  local lucky_packet_list = DataCenter.LuckyBuffManager:GetNotSharedLuckyPacketList()
  self:InitLuckyPocketList(lucky_packet_list)
  if self.curTotalPacketNum <= 0 then
    self.ctrl:CloseSelf()
    return
  end
  self:RefreshShareBtnState()
  self:RefreshMultipleGroup()
  if self.curSelectedPacketIndex >= self.curTotalPacketNum then
    self:SetLuckyPacketInfo(self.curTotalPacketNum, true)
  elseif self.curSelectedPacketIndex == 1 then
    self:SetLuckyPacketInfo(1, true)
  else
    self:SetLuckyPacketInfo(self.curSelectedPacketIndex, true)
  end
end

function UIShareLuckyBuffPopupView:InitPopup()
  self.textShareBtn:SetLocalText("luckyBuff_btn_share")
  self.textJoinBtn:SetLocalText(390079)
  local lucky_packet_list = DataCenter.LuckyBuffManager:GetNotSharedLuckyPacketList()
  self:InitLuckyPocketList(lucky_packet_list)
  if self.curTotalPacketNum <= 0 then
    self.ctrl:CloseSelf()
    return
  end
  self:RefreshShareBtnState()
  self:RefreshMultipleGroup()
  local initParam = self:GetUserData() or {}
  self:SetLuckyPacketInfo(initParam.ifShowNewest and self.curTotalPacketNum or 1)
end

function UIShareLuckyBuffPopupView:InitLuckyPocketList(packet_data_list)
  self.curLuckyPacketList = {}
  for _, packet_info in pairs(packet_data_list) do
    table.insert(self.curLuckyPacketList, packet_info)
  end
  table.sort(self.curLuckyPacketList, function(a, b)
    local a_end_time = a.expireTime or 0
    local b_end_time = b.expireTime or 0
    return a_end_time < b_end_time
  end)
  self.curTotalPacketNum = 0
  for _, packet_info in ipairs(self.curLuckyPacketList) do
    self.curTotalPacketNum = self.curTotalPacketNum + packet_info.count
  end
end

function UIShareLuckyBuffPopupView:GetLuckyPacketInfo(index)
  if not index or index <= 0 or index > self.curTotalPacketNum then
    return nil
  end
  for _, packet_info in ipairs(self.curLuckyPacketList) do
    index = index - packet_info.count
    if index <= 0 then
      return packet_info
    end
  end
  return nil
end

function UIShareLuckyBuffPopupView:SetLuckyPacketInfo(index, force)
  if not index or index <= 0 or index > self.curTotalPacketNum then
    if 0 < self.curTotalPacketNum and index ~= 1 then
      self:SetLuckyPacketInfo(1)
    end
    return
  end
  if not force and self.curSelectedPacketIndex == index then
    return
  end
  self.curSelectedPacketIndex = index
  local lucky_packet_info = self:GetLuckyPacketInfo(index)
  if not lucky_packet_info then
    return
  end
  self:SetLuckyShownConfig(lucky_packet_info.configId)
  self.textMultipleTitle:SetText(string.format("%d/%d", index, self.curTotalPacketNum))
  self:UpdateCountDownText(lucky_packet_info.expireTime or 0)
end

function UIShareLuckyBuffPopupView:SetLuckyShownConfig(lucky_id)
  local lucky_config = DataCenter.LuckyBuffManager:GetLuckyConfigById(lucky_id)
  local red_packet_id = lucky_config.red_packet or 0
  local red_packet_template = DataCenter.RedPacketTemplateManager:GetTemplate(red_packet_id)
  local lucky_type = tonumber(lucky_config.type)
  if not lucky_type or lucky_type <= 0 then
    return
  end
  if lucky_type == 1 then
    local reward_item_list = lucky_config.para1 or {}
    local select_item_id = reward_item_list[1]
    local reward_item_id = reward_item_list[2]
    local reward_item_count = reward_item_list[3]
    local title_text_key = lucky_config.share_title
    local bg_img_path = lucky_config.share_pic
    self.rawImgBG:LoadSpriteAuto(bg_img_path)
    if string.IsNullOrEmpty(title_text_key) then
      self.textTitle:SetText("")
    else
      self.textTitle:SetLocalText(title_text_key, DataCenter.ItemTemplateManager:GetName(select_item_id), DataCenter.ItemTemplateManager:GetName(reward_item_id))
    end
    self.compShownRewardItem:ReInit({
      rewardType = RewardType.GOODS,
      itemId = reward_item_id,
      count = reward_item_count
    })
    self.compShownRewardItem:SetImgQuailtyShow(true)
    local desc_text = Localization:GetString(lucky_config.share_desc)
    if red_packet_template.type == RedPacketType.LuckyBuff then
      self:SetLuckyBuffTipText(desc_text, lucky_config.lw_status)
    elseif red_packet_template.type == RedPacketType.LuckyWithoutBuff then
      self.textTip:SetText(desc_text)
    end
  end
end

function UIShareLuckyBuffPopupView:SetLuckyBuffTipText(desc_text, status_id)
  if not status_id then
    self.textTip:SetText("")
    return
  end
  local tip_text = desc_text
  local modifiedText = string.gsub(tip_text, "<color=", string.format("<link=%s><u><color=", status_id))
  modifiedText = string.gsub(modifiedText, "</color>", "</color></u></link>")
  self.textTip:SetText(modifiedText)
end

function UIShareLuckyBuffPopupView:UpdateCountDownText(expireTimeStamp)
  local diff_time = expireTimeStamp - UITimeManager:GetInstance():GetServerTime()
  if diff_time <= 0 then
    DataCenter.LuckyBuffManager:FilterExpiredLuckyPacket()
    local lucky_packet_list = DataCenter.LuckyBuffManager:GetNotSharedLuckyPacketList()
    self:InitLuckyPocketList(lucky_packet_list)
    if 0 >= self.curTotalPacketNum then
      self.ctrl:CloseSelf()
      return
    else
      self.curSelectedPacketIndex = 0
      self:SetLuckyPacketInfo(1)
    end
  elseif self.isPlayerInAlliance then
    self.textShareTime:SetText(UITimeManager:GetInstance():MilliSecondToFmtString(diff_time))
  else
    self.textJoinTime:SetText(UITimeManager:GetInstance():MilliSecondToFmtString(diff_time))
  end
end

function UIShareLuckyBuffPopupView:RefreshMultipleGroup()
  self.compMultipleGroup:SetActive(self.curTotalPacketNum > 1)
end

function UIShareLuckyBuffPopupView:RefreshShareBtnState()
  self.isPlayerInAlliance = LuaEntry.Player:IsInAlliance()
  self.btnShare:SetActive(self.isPlayerInAlliance)
  self.btnJoin:SetActive(not self.isPlayerInAlliance)
end

return UIShareLuckyBuffPopupView
