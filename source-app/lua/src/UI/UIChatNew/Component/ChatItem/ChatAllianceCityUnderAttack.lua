local IChatItem = require("UI.UIChatNew.Component.ChatItem.IChatItem")
local ChatAllianceCityUnderAttack = BaseClass("ChatAllianceCityUnderAttack", IChatItem)
local base = IChatItem
local Localization = CS.GameEntry.Localization
local rapidjson = require("rapidjson")
local title_path = "title"
local alliance_name_txt_path = "Left/LeftName"
local city_name_txt_path = "Right/CityName"
local city_icon_path = "Right/CityIcon"
local upBtn_path = "UpBtn"
local upBtn_text_path = "UpBtn/UpBtnText"
local alliance_flag_path = "Left/AllianceFlag"
local coord_text_path = "Right/Coord"
local city_lv_text_path = "Right/CityLv"
local city_lv_bg_path = "Right/Img"
local coord_btn_path = "Right/CoordBtn"

function ChatAllianceCityUnderAttack:ComponentDefine()
  self.title = self:AddComponent(UIText, title_path)
  self.alliance_name = self:AddComponent(UIText, alliance_name_txt_path)
  self.city_name = self:AddComponent(UIText, city_name_txt_path)
  self.city_icon = self:AddComponent(UIImage, city_icon_path)
  self.up_text = self:AddComponent(UIText, upBtn_text_path)
  self.flag = self:AddComponent(UIImage, alliance_flag_path)
  self.playerInfo = self:AddComponent(UICommonHead, "Left/UIPlayerHead")
  if self.playerInfo then
    self.playerInfo:SetActive(false)
  end
  self.coord_text = self:AddComponent(UIText, coord_text_path)
  self.city_lv_text = self:AddComponent(UIText, city_lv_text_path)
  self.city_lv_bg = self:AddComponent(UIBaseComponent, city_lv_bg_path)
  self.coordBtn = self:AddComponent(UIButton, coord_btn_path)
  self.coordBtn:SetOnClick(function()
    self:OnCoordBtnClick()
  end)
  self.upBtn = self:AddComponent(UIButton, upBtn_path)
  self.upBtn:SetOnClick(function()
    self:OnUpBtnClick()
  end)
end

function ChatAllianceCityUnderAttack:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
end

function ChatAllianceCityUnderAttack:UpdateItem(chatData)
  self._chatData = chatData
  self.seqId = chatData:getSeqId()
  self:RefreshView(chatData)
end

function ChatAllianceCityUnderAttack:RefreshView(chatData)
  local jsonObj = rapidjson.decode(chatData.extra.customJsonParam)
  if jsonObj then
    self.serverId = jsonObj.serverId or LuaEntry.Player:GetSelfServerId()
    if jsonObj.cityId then
      local cityTemplate = DataCenter.AllianceCityTemplateManager:GetTemplate(jsonObj.cityId, self.serverId)
      local tabPos = cityTemplate.pos
      self.city_lv_text:SetText(cityTemplate.level)
      self.city_name:SetText(cityTemplate:GetName())
      self.coord_text:SetText(UIUtil.FormatServerPosition(jsonObj.serverId, tabPos.x, tabPos.y))
      local v2 = CS.UnityEngine.Vector2Int(toInt(tabPos.x), toInt(tabPos.y))
      local posIndex = SceneUtils.TilePosToIndex(v2, ForceChangeScene.World)
      self.cityPosIndex = posIndex
      if self.city_lv_bg then
        self.city_lv_bg:SetActive(true)
      end
      if jsonObj.isAtkMonster then
        self.city_icon:LoadSprite("Assets/Main/Sprites/HeroIconsSmall/zyf_sangshitiaozhan_tanke_icon.png")
        self.title:SetLocalText("season_alliance_system_notification_1")
      else
        self.city_icon:LoadSprite(cityTemplate:GetIconPath(false))
        if cityTemplate.type == WorldAllianceCityType.Stronghold then
          self.title:SetLocalText("season_alliance_system_notification_2")
        else
          self.title:SetLocalText(393098)
        end
      end
    elseif jsonObj.buildingId then
      if self.city_lv_bg then
        self.city_lv_bg:SetActive(false)
      end
      self.city_lv_text:SetText("")
      self.cityPosIndex = jsonObj.pointId or 1
      local tilePos = SceneUtils.IndexToTilePos(self.cityPosIndex, ForceChangeScene.World)
      self.coord_text:SetText(UIUtil.FormatServerPosition(jsonObj.serverId, tilePos.x, tilePos.y))
      local template = DataCenter.AllianceMineManager:GetAllianceMineTemplate(jsonObj.buildingId)
      if template ~= nil then
        local nameStr = Localization:GetString(template.name)
        self.city_name:SetText(nameStr)
        self.city_icon:LoadSprite(template:GetCircleIconPath())
      else
        self.city_name:SetLocalText("803031")
        self.city_icon:LoadSprite("Assets/Main/Sprites/UI/UIAllianceNew/pic_Union_flag.png")
      end
      self.title:SetLocalText("season_alliance_system_notification_3")
    end
    if jsonObj.atkAlName then
      if jsonObj.atkAlIcon then
        self.flag:LoadSprite(string.format(AL_FLAG_SPRITE_PATH, jsonObj.atkAlIcon))
      end
      self.alliance_name:SetText(UIUtil.FormatAllianceAndName(jsonObj.atkAlAbbr, jsonObj.atkAlName))
      if self.playerInfo then
        self.playerInfo:SetActive(false)
      end
    elseif self.playerInfo then
      if jsonObj.atkUser then
        self.playerInfo:ParseHeadInfo(jsonObj.atkUser)
        self.playerInfo:SetEnableClickShowInfo(true, false)
        self.playerInfo:SetActive(true)
      else
        self.playerInfo:SetActive(false)
      end
    end
  end
  self:RefreshUp(chatData)
end

function ChatAllianceCityUnderAttack:RefreshUp(chatData)
  local upNum = chatData.interactLike or 0
  self.up_text:SetText("+" .. upNum)
end

function ChatAllianceCityUnderAttack:OnCoordBtnClick()
  if not SceneUtils.CheckCanGotoWorld() then
    return
  end
  if self.cityPosIndex and self.cityPosIndex > 0 then
    local serverId = self.serverId
    local pos = SceneUtils.TileIndexToWorld(self.cityPosIndex, ForceChangeScene.World)
    self.view.ctrl:CloseSelf()
    GoToUtil.GotoWorldPos(pos, CS.SceneManager.World.InitZoom, LookAtFocusTime, function()
    end, serverId, 0)
  end
end

function ChatAllianceCityUnderAttack:OnUpBtnClick()
  local deltaTime = ChatManager2:GetInstance():GetGiveLikeMsgTime(self.seqId, 1)
  local k1 = LuaEntry.DataConfig:TryGetNum("thumbs_up", "k1")
  local realLeftTime = deltaTime + k1
  if 0 < realLeftTime then
    local delta = UITimeManager:GetInstance():MilliSecondToFmtString(realLeftTime * 1000)
    UIUtil.ShowTips(Localization:GetString("121068", delta))
    return
  end
  local _roomId = self._chatData.roomId
  local msgTable = {
    roomId = _roomId,
    msgSeq = self.seqId,
    interactLike = 1
  }
  ChatManager2:GetInstance():SetGiveLikeMsgTime(self.seqId, 1)
  ChatManager2:GetInstance():SetGiveLikeAnim(self.seqId, 1)
  EventManager:GetInstance():Broadcast(ChatEventEnum.CHAT_SEND_ROOM_MSG_UP_COMMAND, msgTable)
end

return ChatAllianceCityUnderAttack
