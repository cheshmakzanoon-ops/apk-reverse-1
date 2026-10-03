local IChatItem = require("UI.UIChatNew.Component.ChatItem.IChatItem")
local ChatTrainDeparture = BaseClass("ChatTrainDeparture", IChatItem)
local base = IChatItem
local rapidjson = require("rapidjson")

function ChatTrainDeparture:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
end

function ChatTrainDeparture:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function ChatTrainDeparture:ComponentDefine()
  self.title = self:AddComponent(UITextMeshProUGUIEx, "title")
  self.qualityBg = self:AddComponent(UIRawImage, "qualityBg")
  self.name = self:AddComponent(UITextMeshProUGUIEx, "name")
  self.level = self:AddComponent(UITextMeshProUGUIEx, "level")
  self.power = self:AddComponent(UITextMeshProUGUIEx, "power")
  self.head = self:AddComponent(UICommonHead, "DriverHead")
  self.btn = self:AddComponent(UIButton, "bg")
  self.btn:SetOnClick(function()
    self:OnClick()
  end)
  self.icon = self:AddComponent(UIRawImage, "RawImage")
end

function ChatTrainDeparture:ComponentDestroy()
  self.data = nil
  self.chatData = nil
end

function ChatTrainDeparture:UpdateItem(chatData)
  self._chatData = chatData
  self.seqId = chatData:getSeqId()
  self:RefreshView(chatData)
end

function ChatTrainDeparture:RefreshView(chatData)
  local data = rapidjson.decode(chatData.extra.customJsonParam)
  self.data = data
  self.chatData = chatData
  local user = data.user
  local meta = DataCenter.LWTrainDataManager:GetMeta(data.trainId)
  local showName = DataCenter.PlayerInfoDataManager:GetRemarkOrRealName(user.uid, user.name)
  if chatData.post == PostType.Train_Departure then
    self.title:SetLocalText(458546)
  elseif chatData.post == PostType.Train_Driver then
    if data.buyFlag and data.buyFlag == 1 then
      self.title:SetLocalText(458511, UIUtil.FormatAllianceAndName(user.abbr, showName))
    else
      self.title:SetLocalText(458510, UIUtil.FormatAllianceAndName(user.abbr, showName))
    end
  end
  self.head:SetHeadAndFrame(user.uid, user.headPic, user.headPicVer, false, user.headSkinId, user.headSkinET)
  self.name:SetText(UIUtil.FormatAllianceAndName(user.abbr, showName))
  self.level:SetText("Lv." .. user.level)
  self.power:SetText(string.GetFormattedSeparatorNum(user.power))
  local qualityBgPath = QualityTrainBgPath[meta.quality]
  if UIUtil.CheckAssetDownloaded(qualityBgPath) then
    self.qualityBg:LoadSprite(qualityBgPath)
  else
    self.qualityBg:LoadSpriteAsync(qualityBgPath)
  end
  local iconPath
  local isUR = RailwayUtil.IsUR(data.trainId)
  if isUR then
    iconPath = "Assets/Main/TextureEx/UILWRailway/zxl_huoche_xitong_jin.png"
  else
    iconPath = "Assets/Main/TextureEx/UILWRailway/cfm_chengjimaoyi_huocheyunxingshikebiao_huoche.png"
  end
  self.icon:LoadSprite(iconPath)
end

function ChatTrainDeparture:OnClick()
  if self.chatData.post == PostType.Train_Departure and self.data.serverId then
    RailwayUtil.JumpToTrainByMarchUuid(self.data.marchUuid, self.data.serverId, self.data.worldId)
  elseif self.chatData.post == PostType.Train_Driver then
    if not SeasonUtil.IsInSeasonNineNationMode() and not LuaEntry.DataConfig:CheckSwitch("train_cross_server_alliance") and not LuaEntry.Player:AtHomeNow() then
      GoToUtil.CloseAllWindows()
      EventManager:GetInstance():Broadcast(EventId.ShowCrossServerBubbleTips, 500020)
      return
    end
    if DataCenter.LWAllyStationDataManager:IsTrainFunctionLock() then
      UIUtil.ShowTipsId(458636)
      return
    end
    local trainData = DataCenter.LWAllyStationDataManager:GetAllyTrainByUuid(self.data.trainUuid)
    if trainData and trainData:GetTrainState() == TrainState.BeforeDeparture then
      GoToUtil.GotoCityByBuildId(BuildingTypes.LW_BUILD_RAILWAY_STATION, WorldTileBtnType.TrainList)
    else
      UIUtil.ShowTipsId(458546)
    end
  end
end

return ChatTrainDeparture
