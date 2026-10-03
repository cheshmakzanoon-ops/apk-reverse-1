local SelectAtPlayerPanelItem = BaseClass("SelectAtPlayerPanelItem", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local redTextStr = "<color=#f53037><size=26>%s</size></color>"
local greenTextStr = "<color=#099b4a><size=26>%s</size></color>"
local Colors = {
  {
    Bg1 = Color.FromHex("#E4E3EB"),
    Bg2 = Color.FromHex("#FFFFFF"),
    Text = Color.FromHex("#080808"),
    GreyTextStr = "<color=#515151><size=26>%s</size></color>",
    Alpha = 255
  },
  {
    Bg1 = Color.FromHex("#302F2F"),
    Bg2 = Color.FromHex("#222222"),
    Text = Color.FromHex("#E6E6E6"),
    GreyTextStr = "<color=#828282><size=26>%s</size></color>",
    Alpha = 150
  }
}
local compBook = {
  {
    path = "PlayerNameTxt",
    name = "playerNameTxt",
    type = UIText
  },
  {
    path = "UIPlayerHead",
    name = "playerHead",
    type = UICommonHead
  },
  {
    path = "UIPlayerHead",
    name = "playerHeadCanvasGroup",
    type = UICanvasGroup
  },
  {
    path = "Bg1",
    name = "bg1",
    type = UIImage
  },
  {
    path = "Bg2",
    name = "bg2",
    type = UIImage
  },
  {
    path = "allIcon",
    name = "allIcon",
    type = UIImage
  },
  {
    path = "allText",
    name = "allText",
    type = UITextMeshProUGUIEx
  },
  {
    path = "SelectBtn",
    name = "selectBtn",
    type = UIButton
  }
}

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

local function OnDestroy(self)
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function ComponentDefine(self)
  self:DefineCompsByBook(compBook)
  self.selectBtn:SetOnClick(function()
    if self.selectFunc then
      self.selectFunc(self.index)
    end
  end)
end

local function ComponentDestroy(self)
  self:ClearCompsByBook(compBook)
end

local function DataDefine(self)
end

local function DataDestroy(self)
  self.data = nil
end

local function OnAddListener(self)
  base.OnAddListener(self)
  self:AddUIListener(EventId.PlayerMessageInfo, self.UpdateUserInfo)
end

local function OnRemoveListener(self)
  self:RemoveUIListener(EventId.PlayerMessageInfo, self.UpdateUserInfo)
  base.OnRemoveListener(self)
end

function SelectAtPlayerPanelItem:UpdateItem(data, index, selectFunc)
  self.index = index
  self.selectFunc = selectFunc
  local usingColor = Colors[ChatInterface.GetChatTheme()]
  self.bg1:SetActive(index % 2 == 0)
  self.bg2:SetActive(index % 2 ~= 0)
  self.bg1:SetColor(usingColor.Bg1)
  self.bg2:SetColor(usingColor.Bg2)
  self.data = data
  self:UpdateViewComActive(data.atAll)
  if data.atAll then
    self:UpdateAtInfo(data.atAllCount)
  else
    self:UpdatePlayerInfo(data, index)
  end
end

function SelectAtPlayerPanelItem:UpdateAtInfo(count)
  count = count or 0
  local allCount
  local usingColor = Colors[ChatInterface.GetChatTheme()]
  if 0 < count then
    self.allIcon:LoadSprite("Assets/Main/Sprites/UI/LWChat_v2/DefaultSkin/ChatItems/zyf_@suoyouren_lvse_icon.png")
    allCount = string.format(usingColor.GreyTextStr, Localization:GetString("at_all_text2", string.format(greenTextStr, count)))
  else
    self.allIcon:LoadSprite("Assets/Main/Sprites/UI/LWChat_v2/DefaultSkin/ChatItems/zyf_@suoyouren_zhihui_icon.png")
    allCount = Localization:GetString("at_all_text2", string.format(redTextStr, count))
  end
  self.allIcon:SetAlpha(usingColor.Alpha)
  self.allText:SetColor(usingColor.Text)
  local allName = "@" .. Localization:GetString("at_all_text1")
  self.allText:SetText(allName .. string.format(usingColor.GreyTextStr, string.format("(%s)", allCount)))
end

function SelectAtPlayerPanelItem:UpdateAtAll(count)
  if self.data and self.data.atAll then
    self:UpdateAtInfo(count)
  end
end

function SelectAtPlayerPanelItem:UpdateViewComActive(isAtAll)
  self.playerHead:SetActive(not isAtAll)
  self.playerNameTxt:SetActive(not isAtAll)
  self.allText:SetActive(isAtAll)
  self.allIcon:SetActive(isAtAll)
end

function SelectAtPlayerPanelItem:UpdatePlayerInfo(data, index)
  self.playerHead:SetHeadAndFrame(data.uid, data.pic, data.picVer, false, data.headSkinId, data.headSkinET)
  local usingColor = Colors[ChatInterface.GetChatTheme()]
  self.playerNameTxt:SetColor(usingColor.Text)
  self.playerHeadCanvasGroup:SetAlpha(ChatUIThemeConfig.HeadAlpha[ChatInterface.GetChatTheme()])
  local player = DataCenter.PlayerInfoDataManager:GetPlayerDataByUid(data.uid)
  local name = data.name
  if player then
    name = player.name
  end
  local showName, hasRemark = DataCenter.PlayerInfoDataManager:GetRemarkOrRealName(data.uid, name)
  if hasRemark then
    self.playerNameTxt:SetText(showName)
  else
    self.playerNameTxt:SetText(name)
  end
end

function SelectAtPlayerPanelItem:UserInfoToAlInfo(userInfo)
  self.data.pic = userInfo.headPic
  self.data.picVer = userInfo.headPicVer
  self.data.headSkinId = userInfo.headSkinId
  self.data.headSkinET = userInfo.headSkinET
  self.data.name = userInfo.userName
end

function SelectAtPlayerPanelItem:UpdateUserInfo(uid)
  if not uid then
    return
  end
  if not self.data or self.data.uid ~= uid then
    return
  end
  local userInfo = ChatManager2:GetInstance().User:getChatUserInfo(uid)
  self:UserInfoToAlInfo(userInfo)
  self:UpdatePlayerInfo(self.data)
end

SelectAtPlayerPanelItem.OnCreate = OnCreate
SelectAtPlayerPanelItem.OnDestroy = OnDestroy
SelectAtPlayerPanelItem.OnEnable = OnEnable
SelectAtPlayerPanelItem.OnDisable = OnDisable
SelectAtPlayerPanelItem.ComponentDefine = ComponentDefine
SelectAtPlayerPanelItem.ComponentDestroy = ComponentDestroy
SelectAtPlayerPanelItem.DataDefine = DataDefine
SelectAtPlayerPanelItem.DataDestroy = DataDestroy
SelectAtPlayerPanelItem.OnAddListener = OnAddListener
SelectAtPlayerPanelItem.OnRemoveListener = OnRemoveListener
return SelectAtPlayerPanelItem
