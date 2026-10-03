local IChatItem = require("UI.UIChatNew.Component.ChatItem.IChatItem")
local ChatItemSeasonDesert = BaseClass("ChatItemSeasonDesert", IChatItem)
local ChatHead = require("UI.UIChatNew.Component.ChatHead")
local ChatUserName = require("UI.UIChatNew.Component.ChatItem.ChatUserName")
local base = IChatItem
local UIGray = CS.UIGray
local Localization = CS.GameEntry.Localization
local des_path = "ChatAnchor/ChatShareNode/des"
local image_path = "ChatAnchor/ChatShareNode/Image"
local level_path = "ChatAnchor/ChatShareNode/level"
local btn_get_path = "ChatAnchor/ChatShareNode/BtnGet"
local btn_no_path = "ChatAnchor/ChatShareNode/BtnNO"
local status_path = "ChatAnchor/ChatShareNode/BtnNO/status"
local player_path = "ChatAnchor/ChatShareNode/player"
local ShareStatus_path = "ChatAnchor/ChatShareNode/ShareStatus"

function ChatItemSeasonDesert:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
end

function ChatItemSeasonDesert:ComponentDefine()
  self.chatHead = self:AddComponent(ChatHead, "ChatHead")
  self.chatUserName = self:AddComponent(ChatUserName, "ChatNameLayout")
  self.shareStatus = self:AddComponent(UIText, ShareStatus_path)
  self.des = self:AddComponent(UIText, des_path)
  self.icon = self:AddComponent(UIButton, image_path)
  self.icon:SetOnClick(function()
    self:OnGoToClick()
  end)
  self.level = self:AddComponent(UIText, level_path)
  self.btnGet = self:AddComponent(UIButton, btn_get_path)
  self.btnNo = self:AddComponent(UIBaseComponent, btn_no_path)
  self.status = self:AddComponent(UIText, status_path)
  self.player = self:AddComponent(UICommonHead, player_path)
  self.player:SetEnableClickShowInfo(true, true)
  self.btnGet:SetOnClick(function()
    self:OnBtnClick()
  end)
  self.btnNo:SetActive(false)
  self.btnGet:SetActive(false)
  self.player:SetActive(false)
  self.shareStatus:SetActive(false)
  self.status:SetLocalText("season_ui_desc041")
end

function ChatItemSeasonDesert:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.LWShareDesertStatusUpdate, self.OnDesertStatusUpdate)
end

function ChatItemSeasonDesert:OnRemoveListener()
  self:RemoveUIListener(EventId.LWShareDesertStatusUpdate, self.OnDesertStatusUpdate)
  base.OnRemoveListener(self)
end

function ChatItemSeasonDesert:Update1000MS()
  if self.isOver then
    return
  end
  if self.theOverTime then
    local curTime = UITimeManager:GetInstance():GetServerTime()
    local deltaTime = self.theOverTime - curTime
    if 0 < deltaTime then
      self.shareStatus:SetText(UITimeManager:GetInstance():MilliSecondToFmtString(deltaTime))
    else
      pcall(function()
        self:RefreshState()
      end)
    end
  end
end

function ChatItemSeasonDesert:OnGoToClick()
  if self.data and self.data.desertId and self.data.sid and self.data.pointId then
    local pos = SceneUtils.TileIndexToWorld(self.data.pointId, ForceChangeScene.World)
    local serverId = self.data.sid
    GoToUtil.CloseAllWindows()
    GoToUtil.GotoWorldPos(pos, nil, nil, function()
    end, serverId, 0)
  end
end

function ChatItemSeasonDesert:OnBtnClick()
  if self.data and self.data.desertId and self.data.sid then
    local desert_level = toInt(GetTableData(TableName.Desert, self.data.desertId, "desert_level"))
    local maxLevel = DataCenter.SeasonDataManager:GetDesertMaxLevel()
    if maxLevel and 0 <= maxLevel and desert_level > maxLevel + 1 then
      UIUtil.ShowTips(Localization:GetString("season_tips189", desert_level - 1))
      return
    end
    local selfServerId = LuaEntry.Player:GetSourceServerId()
    local maxNum = DataCenter.DesertDataManager:GetDesertMaxNum()
    local curNum = 0
    if self.data.sid == selfServerId then
      curNum = DataCenter.DesertDataManager:GetSelfSeverDesert()
    else
      curNum = DataCenter.DesertDataManager:GetOtherSeverDesert()
    end
    if maxNum <= curNum then
      UIUtil.ShowTipsId("season_tips190")
    else
      SFSNetwork.SendMessage(MsgDefines.RecvSeasonShareDesert, self.data.uuid)
    end
  end
end

function ChatItemSeasonDesert:UpdateItem(chatData)
  self.isOver = nil
  self.theOverTime = nil
  self.toUser = nil
  self.serverStatus = nil
  self._chatData = chatData
  self._seqId = chatData:getSeqId()
  self._roomId = chatData.roomId
  self._userInfo = ChatManager2:GetInstance().User:getChatUserInfo(self._chatData.senderUid, true)
  self.data = chatData:getMessageParam()
  self.meta = DataCenter.DesertTemplateManager:GetTemplate(self.data.desertId)
  if self.meta then
    self.icon:LoadSprite(string.format(LoadPath.SeasonDesert, self.meta.icon))
    self.level:SetLocalText("140002", self.meta.level)
    local msg = Localization:GetString("season_ui_desc039", tostring(self.data.sid) .. " ", self.meta.level, Localization:GetString(self.meta.name))
    self.des:SetText(msg)
  end
  self:RefreshView()
end

function ChatItemSeasonDesert:RefreshView()
  self.chatHead:UpdateHead(self._userInfo, self._chatData)
  self.chatUserName:UpdateName(self._userInfo, self._chatData)
  self.theOverTime = self.data.overTime or 0
  self:RefreshState()
end

function ChatItemSeasonDesert:OnDesertStatusUpdate()
  pcall(function()
    self:RefreshState()
  end)
end

function ChatItemSeasonDesert:RefreshState()
  local curTime = UITimeManager:GetInstance():GetServerTime()
  if self.data and self.data.uuid and self.serverStatus == nil then
    self.serverStatus = DataCenter.SeasonDataManager:GetShareDesertStatus(self.data.uuid, self.theOverTime, curTime)
  end
  if self.theOverTime and curTime >= self.theOverTime then
    self.isOver = true
  end
  if self.serverStatus then
    self.toUser = self.serverStatus.user
    if self.serverStatus.invalid == 1 then
      if self.isOver then
        self.status:SetLocalText("season_ui_desc041")
      else
        self.status:SetLocalText("season_ui_desc043")
      end
      self.isOver = true
    end
  end
  if self.toUser then
    self.btnNo:SetActive(false)
    self.btnGet:SetActive(false)
    self.player:SetActive(true)
    self.shareStatus:SetActive(false)
    self.player:ParseHeadInfo(self.toUser)
    local full_name = UIUtil.FormatAllianceAndName(self.toUser.abbr, self.toUser.name) .. " "
    local serverId = tostring(self.data.sid) .. " "
    local msg = Localization:GetString("season_ui_desc040", serverId, self.meta.level, Localization:GetString(self.meta.name), full_name)
    self.des:SetText(msg)
  elseif self.isOver then
    self.btnNo:SetActive(false)
    self.btnGet:SetActive(false)
    self.player:SetActive(false)
    self.shareStatus:SetActive(true)
    self.shareStatus:SetLocalText("season_ui_desc041")
    if self.meta then
      local msg = "[" .. Localization:GetString("110073") .. "] #" .. self.data.sid .. " Lv." .. self.meta.level .. " " .. Localization:GetString(self.meta.name)
      self.des:SetText(msg)
    end
  else
    if self._chatData.senderUid == LuaEntry.Player.uid then
      self.btnNo:SetActive(false)
      self.btnGet:SetActive(false)
      self.player:SetActive(false)
      self.shareStatus:SetActive(true)
    else
      self.btnNo:SetActive(false)
      self.btnGet:SetActive(true)
      self.player:SetActive(false)
      self.shareStatus:SetActive(false)
    end
    self:Update1000MS()
  end
end

return ChatItemSeasonDesert
