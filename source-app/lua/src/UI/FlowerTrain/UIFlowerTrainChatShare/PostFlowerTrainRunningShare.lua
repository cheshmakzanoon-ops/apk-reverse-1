local IChatItem = require("UI.UIChatNew.Component.ChatItem.IChatItem")
local base = IChatItem
local PostFlowerTrainRunningShare = BaseClass("PostFlowerTrainRunningShare", base)
local M = PostFlowerTrainRunningShare
local rapidjson = require("rapidjson")
local Localization = CS.GameEntry.Localization
local content_path = "Content"

function M:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
end

function M:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function M:ComponentDefine()
  self.compUIPlayerHead = self:AddComponent(UICommonHead, "Content/UIPlayerHead")
  self.textPlayerName = self:AddComponent(UITextMeshProUGUIEx, "Content/PlayerNameText")
  self.textDes = self:AddComponent(UITextMeshProUGUIEx, "Content/DesText")
  self.icon = self:AddComponent(UIImage, "Content/FlowerTrainIcon")
  self.clickBtn = self:AddComponent(UIButton, "Content")
  self.clickBtn:SetOnClick(function()
    self:OnBtnClick()
  end)
  self.bgImg = self:AddComponent(UIRawImage, content_path)
end

function M:ComponentDestroy()
  self.compUIPlayerHead = nil
  self.textPlayerName = nil
  self.textDes = nil
  self.icon = nil
end

function M:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.PlayerMessageInfo, self.UpdatePlayerHeadAndName)
end

function M:OnRemoveListener()
  base.OnRemoveListener(self)
  self:RemoveUIListener(EventId.PlayerMessageInfo, self.UpdatePlayerHeadAndName)
end

function M:UpdateItem(chatData, _index)
  if chatData == nil then
    return
  end
  self.chatData = chatData
  self.textPlayerName:SetText("")
  self.textDes:SetText("")
  if chatData.senderUid then
    self:UpdatePlayerHeadAndName(chatData.senderUid)
  end
  if chatData.extra and chatData.extra.customJsonParam then
    local jsonObj = rapidjson.decode(chatData.extra.customJsonParam)
    if jsonObj then
      local itemId = jsonObj.itemId
      local paraMeta = FlowerTrainUtils.GetFlowerTrainParaMetaByGoodsId(itemId)
      if paraMeta then
        self.textDes:SetLocalText(paraMeta.start_chat_text)
      end
      local showData = FlowerTrainUtils.GetFlowerTrainDisplayMetaByGoodsId(itemId)
      if showData then
        self.icon:LoadSprite(showData.pic5)
      end
      self.marchUuid = jsonObj.marchUuid
      self.trainUuid = jsonObj.trainUuid
      self:RefreshBGSkin(paraMeta)
    end
  end
end

function M:RefreshBGSkin(paraMeta)
  if not (paraMeta and paraMeta.chat_pos_share_cfg) or #paraMeta.chat_pos_share_cfg < 1 then
    return
  end
  local bgPath = paraMeta.chat_pos_share_cfg[1]
  self.bgImg:LoadSpriteAsync(bgPath)
end

function M:UpdatePlayerHeadAndName(uid)
  if uid == self.chatData.senderUid then
    local userinfo = ChatInterface.getUserData(uid, true)
    if userinfo ~= nil then
      local userPic = userinfo.headPic or ""
      local userPicVer = userinfo.headPicVer or 0
      local headSkinId = userinfo.headSkinId or 0
      local headSkinET = userinfo.headSkinET or 0
      self.compUIPlayerHead:ShowLoadingAinmation()
      self.compUIPlayerHead:SetCustomLoadCallback(function()
        self.compUIPlayerHead:HideLoadingAinmation()
      end)
      self.compUIPlayerHead:SetHeadAndFrame(uid, userPic, userPicVer, nil, headSkinId, headSkinET)
      local userName = userinfo.userName or ""
      local showName = DataCenter.PlayerInfoDataManager:GetRemarkOrRealName(self.chatData.senderUid, userName)
      self.textPlayerName:SetText(showName)
    end
  end
end

function M:OnBtnClick()
  if not self.marchUuid then
    return
  end
  if BattleFieldUtil.InBattleField() then
    UIUtil.ShowTipsId(458147)
    return
  end
  local marchUuid = self.marchUuid
  local serverId = LuaEntry.Player:GetSourceServerId()
  local worldId = LuaEntry.Player:GetCurWorldId()
  FlowerTrainUtils.JumpToFlowerTrainByMarchUuid(marchUuid, serverId, worldId)
end

function M:OnRecycle()
end

return M
