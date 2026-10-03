local IChatItemPost = require("UI.UIChatNewV2.Component.ChatItem.IChatItemPost")
local PostFlowerTrainPositionShare = BaseClass("PostFlowerTrainPositionShare", IChatItemPost)
local base = IChatItemPost
local rapidjson = require("rapidjson")
local bg_path = "bg"
local fire_img_path = "Layout/FireRoot/FireImg"
local fire_text_path = "Layout/FireText"
local lv_img_path = "LvImg"
local lv_text_path = "Layout/LvText"
local desc_text_path = "DescText"

function PostFlowerTrainPositionShare:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
end

function PostFlowerTrainPositionShare:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function PostFlowerTrainPositionShare:ComponentDefine()
  self.bgImg = self:AddComponent(UIRawImage, bg_path)
  self.title = self:AddComponent(UITextMeshProUGUIEx, "title")
  self.position = self:AddComponent(UITextMeshProUGUIEx, "position")
  self.btn = self:AddComponent(UIButton, "bg")
  self.btn:SetOnClick(function()
    self:OnClick()
  end)
  self.icon = self:AddComponent(UIRawImage, "RawImage")
  self.fireImg = self:AddComponent(UIImage, fire_img_path)
  self.fireText = self:AddComponent(UITextMeshProUGUIEx, fire_text_path)
  self.lvImg = self:AddComponent(UIImage, lv_img_path)
  self.lv_text_path = self:AddComponent(UIText, lv_text_path)
  self.descText = self:AddComponent(UIText, desc_text_path)
end

function PostFlowerTrainPositionShare:ComponentDestroy()
  self.data = nil
  self.chatData = nil
end

function PostFlowerTrainPositionShare:OnLoaded()
  self._chatData = self:ChatData()
  self.seqId = self._chatData:getSeqId()
  self:RefreshView(self._chatData)
end

function PostFlowerTrainPositionShare:RefreshView(chatData)
  local data = rapidjson.decode(chatData.attachmentId) or {}
  self.data = data
  self.chatData = chatData
  self:RefreshBaseInfo()
  self.position:SetText(data.posStr)
end

function PostFlowerTrainPositionShare:RefreshBaseInfo()
  local goodsId = self.data.goodsId
  if goodsId == nil then
    return
  end
  local lv = self.data.lv or 1
  local showData = FlowerTrainUtils.GetFlowerTrainDisplayMetaByGoodsId(goodsId, lv)
  if showData then
    local iconPath = showData.pic3
    self.icon:LoadSpriteAsync(iconPath, function()
      self.icon:SetNativeSize()
    end)
    local lvIconPath = showData.level_icon
    self.lvImg:LoadSpriteAsync(lvIconPath)
  end
  local fireImgPath = FlowerTrainUtils.GetFlowerTrainFireImgPathByGoodsId(goodsId, self.data.exp or 0)
  if not string.IsNullOrEmpty(fireImgPath) then
    self.fireImg:LoadSpriteAsync(fireImgPath)
    self.fireText:SetText(self.data.exp or 0)
  end
  local paraMeta = FlowerTrainUtils.GetFlowerTrainParaMetaByGoodsId(goodsId)
  local itemName = DataCenter.RewardManager:GetNameByType(RewardType.GOODS, goodsId)
  if not string.IsNullOrEmpty(itemName) then
    self.descText:SetText(itemName)
  elseif showData then
    self.descText:SetLocalText(showData.name)
  else
    self.descText:SetText("")
  end
  self:RefreshBGSkin(paraMeta)
end

function PostFlowerTrainPositionShare:RefreshBGSkin(paraMeta)
  if not (paraMeta and paraMeta.chat_pos_share_cfg) or #paraMeta.chat_pos_share_cfg < 2 then
    return
  end
  local bgPath = paraMeta.chat_pos_share_cfg[2]
  self.bgImg:LoadSpriteAsync(bgPath)
end

function PostFlowerTrainPositionShare:OnClick()
  if self.data.serverId then
    if not SceneUtils.CheckCanGotoWorld() then
      return
    end
    local marchUuid = self.data.marchUuid
    local worldId = self.data.worldId
    local serverId = self.data.serverId
    if marchUuid and type(marchUuid) == "number" and 0 < marchUuid then
      SFSNetwork.SendMessage(MsgDefines.GetMarchPos, serverId, worldId, marchUuid, NewMarchType.FLOWER_TRAIN)
    end
  end
end

function PostFlowerTrainPositionShare:RefreshUserInfo(uid)
  if self.data == nil then
    return
  end
  if uid ~= self.data.uid then
    return
  end
  local user = UIUtil.GetPlayerInfoShowByUid(uid)
  if user == nil then
    return
  end
  local showName = DataCenter.PlayerInfoDataManager:GetRemarkOrRealName(user.uid, user.name)
  self.title:SetText(UIUtil.FormatAllianceAndName(user.allianceName, showName))
end

return PostFlowerTrainPositionShare
