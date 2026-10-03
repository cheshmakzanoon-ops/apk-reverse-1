local LWUIRedPacketOperationView = BaseClass("LWUIRedPacketOperationView", UIBaseView)
local base = UIBaseView
local openKey = "red_pocket_desc22"
local mask_path = "RedPacket/mask"

function LWUIRedPacketOperationView:OnCreate()
  base.OnCreate(self)
  self:DataDefine()
  self:ComponentDefine()
  self:ReInit()
end

function LWUIRedPacketOperationView:ComponentDefine()
  self.playerHead = self:AddComponent(UICommonHead, "RedPacket/UIPlayerHead")
  self.timeText = self:AddComponent(UITextMeshProUGUIEx, "RedPacket/title/time")
  self.titleText = self:AddComponent(UITextMeshProUGUIEx, "RedPacket/title")
  self.openBtnText = self:AddComponent(UITextMeshProUGUIEx, "RedPacket/sendBtn/sendBtnText")
  self.detailsText = self:AddComponent(UITextMeshProUGUIEx, "RedPacket/detailsBtn/detailsText")
  self.contentText = self:AddComponent(UITextMeshProUGUIEx, "RedPacket/content")
  self.openBtn = self:AddComponent(UIButton, "RedPacket/sendBtn")
  self.closeBtn = self:AddComponent(UIButton, "Panel")
  self.detailsBtn = self:AddComponent(UIButton, "RedPacket/detailsBtn")
  self.playerName = self:AddComponent(UITextMeshProUGUIEx, "RedPacket/playerName")
  self.bgIcon = self:AddComponent(UIBaseContainer, "RedPacket")
  self.mask = self:AddComponent(UIBaseContainer, mask_path)
  self.bg1 = self:AddComponent(UIRawImage, "RedPacket/bg1")
  self.openBtn:SetOnClick(function()
    self:OnOpenClick()
  end)
  self.detailsBtn:SetOnClick(function()
    self:OnDetailsBtnClick()
  end)
  self.closeBtn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
end

function LWUIRedPacketOperationView:OnDetailsBtnClick()
  if not self:GetIsOverdue() then
    local channelType = 0
    if self.chatData.group == ChatGroupType.GROUP_ALLIANCE then
      channelType = DataCenter.RedPacketManager.ChannelType.Alliance
    elseif self.chatData.group == ChatGroupType.GROUP_SEASON_ROOM then
      channelType = DataCenter.RedPacketManager.ChannelType.Season
    elseif self.chatData.group == ChatGroupType.GROUP_COUNTRY then
      channelType = DataCenter.RedPacketManager.ChannelType.World
    elseif self.chatData.group == ChatGroupType.GROUP_ALLIANCE_FRIEND_ROOM then
      channelType = DataCenter.RedPacketManager.ChannelType.AliFriend
    end
    SFSNetwork.SendMessage(MsgDefines.RedPacketDetail, self.extraJson.uuid, self.extraJson.packetId, channelType, self.extraJson.serverId or 0)
  else
    UIUtil.ShowTipsId("red_pocket_desc6")
  end
end

function LWUIRedPacketOperationView:InitTimer()
  local curTime = UITimeManager:GetInstance():GetServerTime()
  self.expiredTime = tonumber(self.extraJson.expiredTime)
  self:RefreshTime()
  local time = self.expiredTime - curTime
  if 0 < time then
    self:StartTimer()
  end
end

function LWUIRedPacketOperationView:RefreshTime()
  if not self.timeText then
    return
  end
  local curTime = UITimeManager:GetInstance():GetServerTime()
  local time = self.expiredTime - curTime
  if time <= 0 then
    self:StopTimer()
    self:RefreshView()
  else
    self.timeText:SetText(UITimeManager:GetInstance():MilliSecondToFmtString(time))
  end
end

function LWUIRedPacketOperationView:StartTimer()
  function self.TimerAction()
    self:RefreshTime()
  end
  
  if self.timer == nil then
    self.timer = TimerManager:GetInstance():GetTimer(1, self.TimerAction, self, false, false, false)
  end
  self.timer:Start()
end

function LWUIRedPacketOperationView:StopTimer()
  if self.timer then
    self.timer:Stop()
    self.timer = nil
  end
end

function LWUIRedPacketOperationView:OnOpenClick()
  local channelType = 0
  if self.chatData.group == ChatGroupType.GROUP_ALLIANCE then
    channelType = DataCenter.RedPacketManager.ChannelType.Alliance
  elseif self.chatData.group == ChatGroupType.GROUP_SEASON_ROOM then
    channelType = DataCenter.RedPacketManager.ChannelType.Season
  elseif self.chatData.group == ChatGroupType.GROUP_COUNTRY then
    channelType = DataCenter.RedPacketManager.ChannelType.World
  elseif self.chatData.group == ChatGroupType.GROUP_ALLIANCE_FRIEND_ROOM then
    channelType = DataCenter.RedPacketManager.ChannelType.AliFriend
  end
  local serverId = self.extraJson.serverId or 0
  SFSNetwork.SendMessage(MsgDefines.OpenRedPacket, self.extraJson.uuid, self.extraJson.packetId, channelType, serverId)
  self.ctrl.CloseSelf()
end

function LWUIRedPacketOperationView:ComponentDestroy()
  self.playerHead = nil
  self.timeText = nil
  self.titleText = nil
  self.openBtnText = nil
  self.detailsText = nil
  self.contentText = nil
  self.openBtn = nil
  self.closeBtn = nil
  self.detailsBtn = nil
  self.playerName = nil
  self.bgIcon = nil
  self.mask = nil
  self.bg1 = nil
end

function LWUIRedPacketOperationView:GetIsReceive()
  if self.extraJson.hasRob and self.chatData.senderUid == LuaEntry.Player.uid then
    return true
  end
  for i = 1, #self.uids do
    if self.uids[i] == LuaEntry.Player.uid then
      return true
    end
  end
end

function LWUIRedPacketOperationView:GetIsOverdue()
  local curTime = UITimeManager:GetInstance():GetServerTime()
  self.expiredTime = tonumber(self.extraJson.expiredTime)
  local time = self.expiredTime - curTime
  if time <= 0 then
    return true
  end
end

function LWUIRedPacketOperationView:GetIsNone()
  if #self.uids >= self.redPocketTemp.num then
    return true
  end
end

function LWUIRedPacketOperationView:ShowNotRedPacket()
  self.detailsBtn:SetActive(true)
  self.contentText:SetActive(true)
  self.timeText:SetActive(false)
  self.openBtn:SetActive(false)
  self.detailsText:SetActive(true)
  self.detailsText:SetLocalText("red_pocket_desc9")
  self.mask:SetActive(true)
end

function LWUIRedPacketOperationView:RefreshView()
  self:StopTimer()
  local chatUserInfo = ChatManager2:GetInstance().User:getChatUserInfo(self.chatData.senderUid)
  self.playerHead:SetHeadAndFrame(chatUserInfo.uid, chatUserInfo.headPic, chatUserInfo.headPicVer, false, chatUserInfo.headSkinId, chatUserInfo.headSkinET)
  local showName = DataCenter.PlayerInfoDataManager:GetRemarkOrRealName(chatUserInfo.uid, chatUserInfo.userName)
  self.playerName:SetText(showName)
  local goods = DataCenter.ItemTemplateManager:GetItemTemplate(self.extraJson.goodsId)
  if goods then
    self.titleText:SetLocalText(goods.name)
  else
    self.titleText:SetText("")
  end
  self.bg1:LoadSpriteAuto(string.format(LoadPath.ChatRedPacketTexturePath, self.redPocketTemp.pic))
  if self:GetIsOverdue() then
    self.contentText:SetColor(RedColor)
    self.contentText:SetLocalText("red_pocket_desc6")
    self:ShowNotRedPacket()
  elseif self:GetIsReceive() then
    self:ShowNotRedPacket()
    self:InitTimer()
    self.timeText:SetActive(true)
    self.contentText:SetColor(LightGreenColor)
    self.contentText:SetLocalText("red_pocket_desc8")
  elseif self:GetIsNone() then
    self.contentText:SetColor(RedColor)
    self.contentText:SetLocalText("red_pocket_desc7")
    self:ShowNotRedPacket()
  else
    self.detailsBtn:SetActive(false)
    self.contentText:SetActive(false)
    self.timeText:SetActive(true)
    self.openBtn:SetActive(true)
    self.mask:SetActive(false)
    self:InitTimer()
    self.openBtnText:SetLocalText(openKey)
  end
end

function LWUIRedPacketOperationView:ReInit()
  self.param = self:GetUserData()
  self.extraJson = self.param.extraJson
  self.chatData = self.param.chatData
  if self.chatData.clientUpdateExtra then
    local temp = string.split(self.chatData.clientUpdateExtra, "|")
    if not string.IsNullOrEmpty(temp[2]) then
      self.uids = string.split(temp[2], ",")
      self.param.uids = self.uids
    end
  end
  if self.extraJson.packetId then
    self.redPocketTemp = DataCenter.RedPacketTemplateManager:GetTemplate(self.extraJson.packetId)
  else
    self.redPocketTemp = DataCenter.RedPacketTemplateManager:GetTemplateByGoodsId(self.extraJson.goodsId)
  end
  self.param.redPocketTemp = self.redPocketTemp
  self:RefreshView()
end

function LWUIRedPacketOperationView:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function LWUIRedPacketOperationView:OnEnable()
  base.OnEnable(self)
end

function LWUIRedPacketOperationView:OnDisable()
  base.OnDisable(self)
end

function LWUIRedPacketOperationView:DataDefine()
  self.uids = {}
end

function LWUIRedPacketOperationView:DataDestroy()
  self:StopTimer()
end

return LWUIRedPacketOperationView
