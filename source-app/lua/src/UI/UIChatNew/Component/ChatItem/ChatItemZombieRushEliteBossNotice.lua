local IChatItem = require("UI.UIChatNew.Component.ChatItem.IChatItem")
local ChatItemZombieRushEliteBossNotice = BaseClass("ChatItemZombieRushEliteBossNotice", IChatItem)
local base = IChatItem
local rapidjson = require("rapidjson")
local ChatItemZombieRushEliteBossItem = require("UI.UIChatNew.Component.ChatItem.ChatItemZombieRushEliteBossItem")
local assistant_path = "Assistant"
local pic_path = "Assistant/TitleRoot/Pic"
local title_text_path = "Assistant/TitleRoot/TitleText"
local tips_text_path = "Assistant/TitleRoot/TipsText"
local player_root_path = "Assistant/PlayerRoot"
local zombie_rush_elite_boss_player_item_path = "Assistant/PlayerRoot/ZombieRushEliteBossPlayerItem"

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

local function OnDestroy(self)
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

local function ComponentDefine(self)
  self.assistant = self:AddComponent(UIImage, assistant_path)
  self.pic = self:AddComponent(UIImage, pic_path)
  self.title_text = self:AddComponent(UITextMeshProUGUIEx, title_text_path)
  self.tips_text = self:AddComponent(UITextMeshProUGUIEx, tips_text_path)
  self.tips_text:SetLocalText("zombierush_eliteBoss_ReqReinforcement")
  self.player_root = self:AddComponent(UIBaseContainer, player_root_path)
  self.item = self.transform:Find(zombie_rush_elite_boss_player_item_path).gameObject
  self.item:GameObjectCreatePool()
end

local function ComponentDestroy(self)
  self.assistant = nil
  self.pic = nil
  self.title_text = nil
  self.tips_text = nil
  if self.player_root then
    self.player_root:RemoveComponents(ChatItemZombieRushEliteBossItem)
    self.player_root = nil
  end
  if self.item then
    self.item:GameObjectRecycleAll()
    self.item = nil
  end
  self.playerList = nil
end

local function DataDefine(self)
  self._chatData = nil
  self.seqId = nil
  self.roomId = nil
  self.playerList = {}
  self.data = nil
  self.numData = nil
  self.playersData = {}
end

local function DataDestroy(self)
  self._chatData = nil
  self.seqId = nil
  self.roomId = nil
  self.data = nil
  self.numData = nil
  self.playersData = nil
end

local function UpdateItem(self, chatData)
  self._chatData = chatData
  self.seqId = chatData:getSeqId()
  self.roomId = chatData.roomId
  if chatData and chatData.extra and chatData.extra.customJsonParam then
    self.data = rapidjson.decode(chatData.extra.customJsonParam)
  else
    return
  end
  self.numData = chatData.clientUpdateExtra
  if self.data == nil or self.numData == nil then
    return
  end
  self:InitMonsterPic()
  self:ParsePlayerData()
end

local function OnAddListener(self)
  base.OnAddListener(self)
  self:AddUIListener(ChatEventEnum.CHAT_ROOM_ONEMSG_UPDATA, self.OnUpdateMsg)
end

local function OnRemoveListener(self)
  self:RemoveUIListener(ChatEventEnum.CHAT_ROOM_ONEMSG_UPDATA, self.OnUpdateMsg)
  base.OnRemoveListener(self)
end

local function InitMonsterPic(self)
  if self.data then
    local monsterId = self.data.monsterId
    if monsterId then
      local line = LocalController:instance():getLine(TableName.Monster, monsterId)
      if line then
        local name = CS.GameEntry.Localization:GetString(line.name)
        self.title_text:SetLocalText("zombierush_eliteBoss_alarm", name)
        local pic = line.pic_name
        if not string.IsNullOrEmpty(pic) then
          self.pic:LoadSpriteAuto(UIUtil.GetFullPath(LoadPath.HeroIconsBigPath, pic))
        end
      end
    end
  end
end

local function InitPlayerList(self, list, container)
  if list ~= nil and container then
    for i, v in ipairs(list) do
      local goItem = self.item:GameObjectSpawn(self.player_root.transform)
      goItem.name = "item_" .. i
      goItem:SetActive(true)
      local item = self.player_root:AddComponent(ChatItemZombieRushEliteBossItem, goItem.name)
      item:SetData(v)
      self.playerList[i] = item
    end
  end
end

local function RefreshPlayerList(self, list, container)
  if list and container then
    local rebuild = false
    if self.playerList and #self.playerList > 0 then
      local itemCount = #self.playerList
      local index = 0
      local maxIndex = #list
      for i, v in ipairs(list) do
        if i > itemCount then
          local goItem = self.item:GameObjectSpawn(self.player_root.transform)
          goItem.name = "item_" .. i
          goItem:SetActive(true)
          local item = self.player_root:AddComponent(ChatItemZombieRushEliteBossItem, goItem.name)
          item:SetData(v)
          self.playerList[i] = item
          table.insert(self.playerList, item)
          rebuild = true
        else
          local item = self.playerList[i]
          if item then
            item:SetData(v)
            item:SetActive(true)
          end
        end
        index = i
      end
      if itemCount > index then
        for i = index + 1, itemCount do
          local item = self.playerList[i]
          if item then
            item:SetActive(false)
          end
        end
        rebuild = true
      end
    else
      self:InitPlayerList(list, container)
      rebuild = true
    end
    if rebuild then
      CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.assistant.rectTransform)
      CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.rectTransform)
    end
  end
end

local function ParsePlayerData(self)
  if self.data == nil or string.IsNullOrEmpty(self.numData) then
    return
  end
  local players = self.data.players
  self.playersData = self:ParseData(players)
  if self.playersData and #self.playersData > 0 then
    self:RefreshPlayerList(self.playersData, self.player_root)
  end
end

local function ParseData(self, players)
  if players == nil or #players == 0 then
    return
  end
  local list = self:ParseNumData(self.numData)
  if list == nil then
    return
  end
  local result = {}
  for i, v in ipairs(players) do
    if v and v.uid then
      local uid = tonumber(v.uid)
      result[i] = {
        player = v,
        uid = uid or 0,
        num = list[uid] or 0
      }
    end
  end
  return result
end

local function OnUpdateMsg(self, chatData)
  if chatData and chatData.seqId == self.seqId and chatData.roomid == self.roomId then
    local roomData = ChatManager2:GetInstance().Room:GetRoomData(self.roomId)
    if roomData then
      chatData = roomData:getChatDataBySeqId(self.seqId)
      if chatData and chatData.post == PostType.ZOMBIE_RUSH_ELITE_BOSS_ATTACK then
        self:RefreshItemNum(chatData)
      end
    end
  end
end

local function RefreshItemNum(self, chatData)
  if chatData then
    self._chatData = chatData
    self.data = rapidjson.decode(chatData.extra.customJsonParam)
    self.numData = rapidjson.decode(chatData.clientUpdateExtra)
    if self.playerList == nil or #self.playerList == 0 then
      self:ParsePlayerData()
      return
    end
    self:UpdateNumData(chatData)
  end
end

local function UpdateNumData(self, numData)
  local list = self:ParseNumData(numData)
  if list == nil or #list == 0 or self.playersData == nil or #self.playersData == 0 then
    return
  end
  for i, v in ipairs(self.playersData) do
    if v and v.uid then
      self.playersData[i].num = list[v.uid]
      self.playerList[i]:RefreshNum(list[v.uid])
    end
  end
end

local function ParseNumData(self, numData)
  if string.IsNullOrEmpty(numData) then
    return
  end
  local list = {}
  local arr = string.split(self.numData, "|")
  if arr and 0 < #arr then
    for i, v in ipairs(arr) do
      if v then
        local dArr = string.split(v, ";")
        if dArr and 2 <= #dArr then
          list[tonumber(dArr[1])] = tonumber(dArr[2])
        end
      end
    end
  end
  return list
end

ChatItemZombieRushEliteBossNotice.OnCreate = OnCreate
ChatItemZombieRushEliteBossNotice.OnDestroy = OnDestroy
ChatItemZombieRushEliteBossNotice.ComponentDefine = ComponentDefine
ChatItemZombieRushEliteBossNotice.ComponentDestroy = ComponentDestroy
ChatItemZombieRushEliteBossNotice.DataDefine = DataDefine
ChatItemZombieRushEliteBossNotice.DataDestroy = DataDestroy
ChatItemZombieRushEliteBossNotice.UpdateItem = UpdateItem
ChatItemZombieRushEliteBossNotice.OnAddListener = OnAddListener
ChatItemZombieRushEliteBossNotice.OnRemoveListener = OnRemoveListener
ChatItemZombieRushEliteBossNotice.OnUpdateMsg = OnUpdateMsg
ChatItemZombieRushEliteBossNotice.InitMonsterPic = InitMonsterPic
ChatItemZombieRushEliteBossNotice.InitPlayerList = InitPlayerList
ChatItemZombieRushEliteBossNotice.ParsePlayerData = ParsePlayerData
ChatItemZombieRushEliteBossNotice.ParseData = ParseData
ChatItemZombieRushEliteBossNotice.ParseNumData = ParseNumData
ChatItemZombieRushEliteBossNotice.RefreshItemNum = RefreshItemNum
ChatItemZombieRushEliteBossNotice.UpdateNumData = UpdateNumData
ChatItemZombieRushEliteBossNotice.RefreshPlayerList = RefreshPlayerList
return ChatItemZombieRushEliteBossNotice
