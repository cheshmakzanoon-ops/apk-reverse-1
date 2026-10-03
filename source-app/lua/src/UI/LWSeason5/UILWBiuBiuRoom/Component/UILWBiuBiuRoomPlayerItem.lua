local base = UIBaseContainer
local UILWBiuBiuRoomPlayerItem = BaseClass("UILWBiuBiuRoomPlayerItem", base)
local Localization = CS.GameEntry.Localization
local go_search_path = "go_search"
local go_ready_path = "go_ready"
local player_name_path = "go_ready/player/playerName"
local server_txt_path = "go_ready/player/serverTxt"
local player_path = "go_ready/player/player"
local txt_state_path = "txt_state"
local btn_add_path = "go_search/btn_add"
local img_ready_path = "go_ready/img_ready"

function UILWBiuBiuRoomPlayerItem:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self.configWaitTime = toInt(GetTableData(TableName.DataConfig, "season_shoot_game_pvp", "k2"))
  self.opTime = -1
end

function UILWBiuBiuRoomPlayerItem:OnDestroy()
  self.configWaitTime = nil
  self.opTime = nil
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UILWBiuBiuRoomPlayerItem:ComponentDefine()
  self.go_search = self:AddComponent(UIBaseContainer, go_search_path)
  self.go_ready = self:AddComponent(UIBaseContainer, go_ready_path)
  self.player_name = self:AddComponent(UITextMeshProUGUIEx, player_name_path)
  self.server_txt = self:AddComponent(UITextMeshProUGUIEx, server_txt_path)
  self.player_flag = self:AddComponent(UICommonHead, player_path)
  self.txt_state = self:AddComponent(UITextMeshProUGUIEx, txt_state_path)
  self.btn_add = self:AddComponent(UIButton, btn_add_path)
  self.img_ready = self:AddComponent(UIImage, img_ready_path)
  self.btn_add:SetOnClick(BindCallback(self, self.OnAddClick))
end

function UILWBiuBiuRoomPlayerItem:ComponentDestroy()
  self.go_search = nil
  self.go_ready = nil
  self.player_name = nil
  self.server_txt = nil
  self.player_flag = nil
  self.txt_state = nil
  self.btn_add = nil
  self.img_ready = nil
end

function UILWBiuBiuRoomPlayerItem:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.SeasonBiuBiuChatShared, self.SeasonBiuBiuChatSharedHandle)
end

function UILWBiuBiuRoomPlayerItem:OnRemoveListener()
  self:RemoveUIListener(EventId.SeasonBiuBiuChatShared, self.SeasonBiuBiuChatSharedRoomHandle)
  base.OnRemoveListener(self)
end

function UILWBiuBiuRoomPlayerItem:SeasonBiuBiuChatSharedHandle()
  self.opTime = self.configWaitTime or 10
end

function UILWBiuBiuRoomPlayerItem:OnAddClick()
  local _chatRoomManager = ChatInterface.getRoomMgr()
  local chatRooms = _chatRoomManager:GetShareRoom()
  local hasRoom = true
  local room = DataCenter.LWBiuBiuDataManager:GetRoom()
  if room:GetBetNum() <= 0 then
    local op = false
    for _, chatItem in pairs(chatRooms) do
      if chatItem:isAllianceRoom() or chatItem:isPrivateChat() then
        op = true
        break
      end
    end
    hasRoom = op
  end
  if not hasRoom then
    UIUtil.ShowTipsId(300707)
    return
  end
  if 0 < self.opTime then
    UIUtil.ShowTips(Localization:GetString("season_s5_activity_1200045_desc86", tostring(math.ceil(self.opTime))))
    return
  end
  local share_param = {}
  share_param.postType = PostType.Season_BiuBiuInvite
  local betData = DataCenter.LWBiuBiuDataManager:GetBetData()
  share_param.post = PostType.Season_BiuBiuInvite
  share_param.param = {
    uuid = room:GetRoomUUid(),
    uid = room:GetRoomUid(),
    sid = room:GetSid(),
    speak = room:GetSpeak(),
    betNum = room:GetBetNum(),
    betId = betData.id
  }
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIPositionShare, {anim = true}, share_param)
end

function UILWBiuBiuRoomPlayerItem:SetData(playerHead, room)
  self.go_search:SetActive(playerHead == nil)
  self.go_ready:SetActive(playerHead ~= nil)
  if playerHead ~= nil then
    local headFrame = DataCenter.DecorationDataManager:GetHeadFrame(playerHead.headSkinId, playerHead.headSkinET, false)
    self.player_flag:SetHead(playerHead.uid, playerHead.pic, playerHead.picVer, nil, headFrame)
    self.player_name:SetText(playerHead.name)
    if string.IsNullOrEmpty(playerHead.abbr) then
      self.server_txt:SetText("#" .. tostring(playerHead.serverId))
    else
      self.server_txt:SetLocalText("season_s5_activity_1200045_desc38", playerHead.serverId, playerHead.abbr)
    end
    self.img_ready:SetActive(room:GetReady(playerHead.uid))
  else
    self.img_ready:SetActive(false)
  end
end

function UILWBiuBiuRoomPlayerItem:Update1000MS()
  if self.opTime ~= nil and self.opTime > 0 then
    self.opTime = self.opTime - 1
  end
end

return UILWBiuBiuRoomPlayerItem
