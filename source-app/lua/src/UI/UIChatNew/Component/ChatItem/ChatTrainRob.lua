local base = require("UI.UIChatNew.Component.ChatItem.IChatItem")
local ChatTrainRob = BaseClass("ChatTrainRob", base)
local rapidjson = require("rapidjson")

function ChatTrainRob:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
end

function ChatTrainRob:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function ChatTrainRob:ComponentDefine()
  self.title = self:AddComponent(UITextMeshProUGUIEx, "title")
  self.win = self:AddComponent(UIBaseComponent, "win")
  self.lose = self:AddComponent(UIBaseComponent, "lose")
  self.quality = self:AddComponent(UIImage, "quality")
  self.qualityBg = self:AddComponent(UIRawImage, "qualityBg")
  self.name = self:AddComponent(UITextMeshProUGUIEx, "name")
  self.level = self:AddComponent(UITextMeshProUGUIEx, "level")
  self.power = self:AddComponent(UITextMeshProUGUIEx, "power")
  self.head = self:AddComponent(UICommonHead, "DriverHead")
  self.head:SetEnableClickShowInfo(true, true)
  self.noReward = self:AddComponent(UITextMeshProUGUIEx, "NoReward")
  self.rewardContent = self:AddComponent(UIBaseContainer, "ScrollRect/ViewPort/Content")
  self.rewardBg = self:AddComponent(UIImage, "ScrollRect")
  self.rewardBg:SetColor(ChatUIThemeConfig.TrainRobRewardColor[ChatInterface.GetChatTheme()])
  self.btn = self:AddComponent(UIButton, "bg")
  self.btn:SetOnClick(function()
    self:OnClick()
  end)
  self.icon = self:AddComponent(UIRawImage, "RawImage")
end

function ChatTrainRob:ComponentDestroy()
  self:ClearReward()
  self.data = nil
end

function ChatTrainRob:UpdateItem(chatData)
  self._chatData = chatData
  self.seqId = chatData:getSeqId()
  self:RefreshView(chatData)
end

function ChatTrainRob:RefreshView(chatData)
  local data = rapidjson.decode(chatData.extra.customJsonParam)
  self.data = data
  local user = data.user
  local meta = DataCenter.LWTrainDataManager:GetMeta(data.trainId)
  self.title:SetText("")
  self.quality:LoadSprite(QualityImagePath[meta.quality])
  self.head:SetHeadAndFrame(user.uid, user.headPic, user.headPicVer, false, user.headSkinId, user.headSkinET)
  local showName = DataCenter.PlayerInfoDataManager:GetRemarkOrRealName(user.uid, user.name)
  self.name:SetText(UIUtil.FormatAllianceAndName(user.abbr, showName))
  self.level:SetText("Lv." .. user.level)
  self.power:SetText(string.GetFormattedSeparatorNum(user.power))
  local qualityBgPath = QualityTrainBgPath[meta.quality]
  if UIUtil.CheckAssetDownloaded(qualityBgPath) then
    self.qualityBg:LoadSprite(qualityBgPath)
  else
    self.qualityBg:LoadSpriteAsync(qualityBgPath)
  end
  self.win:SetActive(not data.result)
  self.lose:SetActive(data.result)
  self:RefreshReward(data.plunder)
  local iconPath
  local isUR = RailwayUtil.IsUR(data.trainId)
  if isUR then
    iconPath = "Assets/Main/TextureEx/UILWRailway/zxl_huoche_xitong_jin.png"
  else
    iconPath = "Assets/Main/TextureEx/UILWRailway/cfm_chengjimaoyi_huocheyunxingshikebiao_huoche.png"
  end
  self.icon:LoadSprite(iconPath)
  if not data.result then
    local isVip = data.isVip
    local key = isVip and "alliance_train_063" or "alliance_train_051"
    self.noReward:SetLocalText(key, data.defenderName or "")
  end
end

function ChatTrainRob:ClearReward()
  self.rewardContent:RemoveComponents(UICommonResItem)
  if self.rewardReqs then
    for _, req in pairs(self.rewardReqs) do
      req:Destroy()
    end
  end
  self.rewardReqs = {}
end

function ChatTrainRob:RefreshReward(rewardList)
  self:ClearReward()
  rewardList = rewardList or {}
  self.noReward:SetActive(#rewardList <= 0)
  for i, data in ipairs(rewardList) do
    self:AddOneReward(i, data)
  end
end

function ChatTrainRob:AddOneReward(i, data, isLost)
  self.rewardReqs[i] = self:GameObjectInstantiateAsync(UIAssets.UICommonResItem, function(req)
    if IsNull(req.gameObject) then
      return
    end
    local go = req.gameObject
    local index = i
    local nameStr = "UICommonResItem" .. index
    go.name = nameStr
    go:SetActive(true)
    local transform = go.transform
    transform:SetParent(self.rewardContent.transform)
    transform:Set_sizeDelta(150, 150)
    transform:Set_localScale(0.75, 0.75, 1)
    transform:Set_pivot(0, 1)
    local item = self.rewardContent:AddComponent(UICommonResItem, nameStr)
    local param = UICommonResItem.Param.New()
    param.rewardType = data.type
    if type(data.value) == "table" then
      param.itemId = data.value.id
      param.count = data.value.num
    else
      param.itemId = data.type
      param.count = data.value
    end
    param.rewardType = data.type
    param.heroUuid = data.heroUuid
    param.isHeroBox = data.isHeroBox
    param.isDelete = isLost
    item:ReInit(param)
  end)
end

function ChatTrainRob:OnClick()
  if self.data.serverId then
    RailwayUtil.JumpToTrainByMarchUuid(self.data.marchUuid, self.data.serverId, self.data.worldId)
  end
end

return ChatTrainRob
