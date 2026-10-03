local IChatItemPost = require("UI.UIChatNewV2.Component.ChatItem.IChatItemPost")
local ChatItemPost_TacticalCardShare = BaseClass("ChatItemPost_TacticalCardShare", IChatItemPost)
local base = IChatItemPost
local rapidjson = require("rapidjson")
local Localization = CS.GameEntry.Localization
local _cp_shareNode = ""

function ChatItemPost_TacticalCardShare:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
end

function ChatItemPost_TacticalCardShare:ComponentDefine()
  self._shareNode = self:AddComponent(UIButton, _cp_shareNode)
  self._shareNode:SetOnClick(BindCallback(self, self.OnClickBg))
  self.title_txt = self:AddComponent(UIText, "banner/title")
  self.msg_txt = self:AddComponent(UIText, "msg")
end

function ChatItemPost_TacticalCardShare:OnClickBg()
  if not self.battleCards then
    return
  end
  local lifeTime = LuaEntry.DataConfig:TryGetNum("battle_card_param", "k1")
  local chatData = self:ChatData()
  if 0 < lifeTime then
    local senderTime = chatData.serverTime
    local now = UITimeManager:GetInstance():GetServerTime()
    if now - senderTime > lifeTime * 3600000 then
      UIUtil.ShowTipsId("battle_card_share_expired")
      return
    end
  end
  local postType = chatData.post
  if postType == PostType.TacticalCard then
    TacticalCardUtil:OpenViewCard(self.battleCards[1].cardId, self.battleCards[1].level, self.battleCards[1].star, self.battleCards[1].randomAttr)
  elseif postType == PostType.TacticalCard_Deck or postType == PostType.TacticalCard_EquipPlan then
    TacticalCardUtil:OpenViewCardDeck(chatData:getSenderNameWithAlliance(), self.battleCards)
  end
end

function ChatItemPost_TacticalCardShare:OnLoaded()
  local chatdata = self:ChatData()
  if chatdata == nil then
    return
  end
  if not chatdata.extra or not chatdata.extra.customJsonParam then
    return
  end
  local extraJson
  if type(chatdata.extra.customJsonParam) == "string" then
    extraJson = rapidjson.decode(chatdata.extra.customJsonParam)
  elseif type(chatdata.extra.customJsonParam) == "table" then
    extraJson = chatdata.extra.customJsonParam
  else
    return
  end
  local battleCards = extraJson.battleCards
  if not battleCards then
    return
  end
  self.battleCards = battleCards
  local postType = chatdata.post
  if postType == PostType.TacticalCard then
    self.title_txt:SetLocalText("battle_card_share_single_title")
    local cardId
    local cardName = ""
    if battleCards[1] then
      cardId = battleCards[1].cardId
    end
    if cardId then
      local cardTemplate = DataCenter.TacticalCardDataManager:GetTemplateData(cardId)
      if cardTemplate then
        cardName = Localization:GetString(cardTemplate.name)
      end
    end
    self.msg_txt:SetLocalText("battle_card_share_single_info", cardName)
  elseif postType == PostType.TacticalCard_Deck or postType == PostType.TacticalCard_EquipPlan then
    self.title_txt:SetLocalText("battle_card_share_title")
    self.msg_txt:SetLocalText("battle_card_share_im")
  end
end

function ChatItemPost_TacticalCardShare:GetPlayerName(player)
end

function ChatItemPost_TacticalCardShare:OnRecycle()
end

return ChatItemPost_TacticalCardShare
