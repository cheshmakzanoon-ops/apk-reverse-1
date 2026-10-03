local LWUIActEasterThumbsUpGloryView = BaseClass("LWUIActEasterThumbsUpGloryView", UIBaseView)
local LWUIActEasterThumbsUpGloryHeadItem = require("UI.LWUIActEasterEgg.LWUIActEasterThumbsUpGlory.Component.LWUIActEasterThumbsUpGloryHeadItem")
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local M = LWUIActEasterThumbsUpGloryView

function M:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:RefreshAll()
end

function M:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function M:OnEnable()
  base.OnEnable(self)
end

function M:OnDisable()
  base.OnDisable(self)
end

function M:ComponentDefine()
  self.textTitle = self:AddComponent(UITextMeshProUGUIEx, "rewardPage/titleContent/mask_titlebg/titlebg/title")
  self.compRowOne = self:AddComponent(UIBaseContainer, "rewardPage/GiftContent/HeadNode/RowOne")
  self.compRowTwo = self:AddComponent(UIBaseContainer, "rewardPage/GiftContent/HeadNode/RowTwo")
  self.textThumbersUpName = self:AddComponent(UITextMeshProUGUIEx, "rewardPage/GiftContent/ThumbersUpName")
  self.textAwesomeNode = self:AddComponent(UITextMeshProUGUIEx, "rewardPage/GiftContent/AwesomeNode")
  self.textHeartNum = self:AddComponent(UITextMeshProUGUIEx, "rewardPage/GiftContent/Transfer/Heart/HeartNode/HeartNum")
  self.textMessageNum = self:AddComponent(UITextMeshProUGUIEx, "rewardPage/GiftContent/Transfer/Comment/MessageNode/MessageNum")
  self.textHeartTransNum = self:AddComponent(UITextMeshProUGUIEx, "rewardPage/GiftContent/Transfer/Heart/HeartTransNode/HeartTransNum")
  self.textMessageTransNum = self:AddComponent(UITextMeshProUGUIEx, "rewardPage/GiftContent/Transfer/Comment/MessageTransNode/MessageTransNum")
  self.btnClaim = self:AddComponent(UIButton, "rewardPage/ClaimBtn")
  self.btnClaim:SetOnClick(function()
    self:OnBtnClaimClick()
  end)
  self.textClaimBtn = self:AddComponent(UITextMeshProUGUIEx, "rewardPage/ClaimBtn/ClaimBtnText")
  self.headObjItem = self:AddComponent(UIBaseContainer, "rewardPage/LWUIActEasterThumbsUpGloryHead")
  self.textLimit = self:AddComponent(UITextMeshProUGUIEx, "rewardPage/LimitText")
  self.btnHeartTransIntro = self:AddComponent(UIButton, "rewardPage/GiftContent/Transfer/Heart/HeartTransNode/HeartTransIntroBtn")
  self.btnHeartTransIntro:SetOnClick(function()
    self:OnBtnHeartTransIntroClick()
  end)
  self.btnMessageTransIntro = self:AddComponent(UIButton, "rewardPage/GiftContent/Transfer/Comment/MessageTransNode/MessageTransIntroBtn")
  self.btnMessageTransIntro:SetOnClick(function()
    self:OnBtnMessageTransIntroClick()
  end)
  self.compHeart = self:AddComponent(UIBaseContainer, "rewardPage/GiftContent/Transfer/Heart")
  self.compComment = self:AddComponent(UIBaseContainer, "rewardPage/GiftContent/Transfer/Comment")
  self.headObjItem.gameObject:GameObjectCreatePool()
end

function M:ComponentDestroy()
  self.headObjItem.gameObject:GameObjectRecycleAll()
  self.textTitle = nil
  self.compRowOne = nil
  self.compRowTwo = nil
  self.textThumbersUpName = nil
  self.textAwesomeNode = nil
  self.textHeartNum = nil
  self.textMessageNum = nil
  self.textHeartTransNum = nil
  self.textMessageTransNum = nil
  self.btnClaim = nil
  self.textClaimBtn = nil
  self.headObjItem = nil
  self.textLimit = nil
  self.btnHeartTransIntro = nil
  self.btnMessageTransIntro = nil
  self.compHeart = nil
  self.compComment = nil
end

function M:DataDefine()
  self.fromLastReceiveData = nil
end

function M:DataDestroy()
  self.fromLastReceiveData = nil
end

function M:OnAddListener()
  base.OnAddListener(self)
end

function M:OnRemoveListener()
  base.OnRemoveListener(self)
end

function M:OnBtnClaimClick()
  self.ctrl:CloseSelf()
end

function M:RefreshAll()
  self:InitData()
  if not self.fromLastReceiveData then
    Logger.LogError("fromLastReceiveData is nil")
    return
  end
  self.textTitle:SetLocalText("activity_99144_ui_3")
  self.textClaimBtn:SetLocalText("activity_99144_ui_6a")
  self.textLimit:SetLocalText("activity_99144_ui_6")
  self:InitPlayerInfo()
  self:InitGiftNode()
end

function M:InitData()
  local activityData = DataCenter.ActEasterEggManager:GetActivityData()
  self.fromLastReceiveData = activityData and activityData.fromLastReceive
end

function M:InitPlayerInfo()
  self.headObjItem.gameObject:GameObjectRecycleAll()
  local playerListData = self.fromLastReceiveData.playerList
  if not playerListData or #playerListData <= 0 then
    return
  end
  self.compRowTwo:SetActive(table.length(playerListData) > 10)
  local playerNameStr = ""
  for k, v in ipairs(playerListData) do
    local parentNode
    if k <= 10 then
      parentNode = self.compRowOne
    else
      parentNode = self.compRowTwo
    end
    local gameObject = self.headObjItem.gameObject:GameObjectSpawn(parentNode.transform)
    local name = "item_" .. k
    gameObject.name = name
    local headItem = parentNode:AddComponent(LWUIActEasterThumbsUpGloryHeadItem, name)
    headItem:ReInit(v)
    local allianceName = string.IsNullOrEmpty(v.abbr) and "" or "[" .. v.abbr .. "]"
    local playerName = string.format("%s%s", allianceName, v.name)
    playerNameStr = playerNameStr .. playerName .. ","
  end
  self.textThumbersUpName:SetText(playerNameStr)
  local playerNum = #playerListData
  local node = Localization:GetString("activity_99144_ui_4", "<color=#FDC839>" .. playerNum .. "</color>")
  self.textAwesomeNode:SetText(node)
end

function M:InitGiftNode()
  local heartReachLimit, commitReachLimit = self.fromLastReceiveData:GetIfReachMax()
  if self.fromLastReceiveData.praise == 0 and self.fromLastReceiveData.praiseItemNum == 0 then
    self.compHeart:SetActive(false)
  else
    self.compHeart:SetActive(true)
    self.btnHeartTransIntro:SetActive(true)
    if heartReachLimit then
      self.textHeartTransNum:SetLocalText("activity_99144_ui_5")
    else
      self.textHeartTransNum:SetText(self.fromLastReceiveData.praiseItemNum)
    end
    self.textHeartNum:SetText(self.fromLastReceiveData.praise)
  end
  if self.fromLastReceiveData.comment == 0 and self.fromLastReceiveData.commentItemNum == 0 then
    self.compComment:SetActive(false)
  else
    self.btnMessageTransIntro:SetActive(true)
    self.compComment:SetActive(true)
    if commitReachLimit then
      self.textMessageTransNum:SetLocalText("activity_99144_ui_5")
    else
      self.textMessageTransNum:SetText(self.fromLastReceiveData.commentItemNum)
    end
    self.textMessageNum:SetText(self.fromLastReceiveData.comment)
  end
end

function M:OnBtnHeartTransIntroClick()
  if not self.fromLastReceiveData then
    return
  end
  self:ShowTips(self.fromLastReceiveData.historyPraiseObj, self.btnHeartTransIntro, 1)
end

function M:OnBtnMessageTransIntroClick()
  if not self.fromLastReceiveData then
    return
  end
  self:ShowTips(self.fromLastReceiveData.historyCommentObj, self.btnMessageTransIntro, 2)
end

function M:ShowTips(historyObj, parent, type)
  if not historyObj then
    return
  end
  local param = {}
  param.type = "desc"
  param.title = "activity_99144_ui_6b"
  local eggConfig = DataCenter.ActEasterEggManager:GetEggConfigData()
  local coinsThumbsGive = eggConfig.coinsThumbsLimit
  local coinsCommitGive = eggConfig.coinsCommitLimit
  local maxCoins = 0
  if type == 1 then
    maxCoins = coinsThumbsGive
  elseif type == 2 then
    maxCoins = coinsCommitGive
  end
  local desc = ""
  for k, v in pairs(historyObj) do
    desc = desc .. Localization:GetString("activity_99144_ui_6c", k, v, maxCoins) .. "\n"
  end
  param.desc = desc
  param.isLocal = true
  param.alignObject = parent
  param.isModify = {txtDescWidth = 190, rootWidth = 210}
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIItemTips, {anim = true}, param)
end

return LWUIActEasterThumbsUpGloryView
