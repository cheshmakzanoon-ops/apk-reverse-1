local base = UIBaseContainer
local LWUIActEasterEggMessageItem = BaseClass("LWUIActEasterEggMessageItem", UIBaseContainer)
local Localization = CS.GameEntry.Localization
local womenIconPath = "Assets/Main/Sprites/UI/LWPlayerInfo/Sprite/New/lrb_gerenxinxi_xingbie00.png"
local manIconPath = "Assets/Main/Sprites/UI/LWPlayerInfo/Sprite/New/lrb_gerenxinxi_xingbie01.png"

function LWUIActEasterEggMessageItem:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function LWUIActEasterEggMessageItem:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function LWUIActEasterEggMessageItem:ComponentDefine()
  self.textTime = self:AddComponent(UITextMeshProUGUIEx, "TimeText")
  self.imgCurAvatar = self:AddComponent(UIImage, "AvatarNode/CurAvatarImage")
  self.imgGender = self:AddComponent(UIImage, "PlayerInfo/Gender")
  self.textPlayerName = self:AddComponent(UITextMeshProUGUIEx, "PlayerInfo/PlayerName")
  self.textThumbUp = self:AddComponent(UITextMeshProUGUIEx, "ThumbUp/ThumbUpText")
  self.textMessage = self:AddComponent(UITextMeshProUGUIEx, "MessageNode/MessageText")
  self.compSelectNode = self:AddComponent(UIBaseContainer, "MessageNode/SelectNode")
  self.imgSelect = self:AddComponent(UIImage, "MessageNode/SelectNode/SelectImg")
  self.btn = self:AddComponent(UIButton, "Btn")
  self.btn:SetOnClick(function()
    self:OnBtnClick()
  end)
  self.btnSelect = self:AddComponent(UIButton, "MessageNode/SelectNode/SelectBtn")
  self.btnSelect:SetOnClick(function()
    self:OnBtnSelectClick()
  end)
end

function LWUIActEasterEggMessageItem:ComponentDestroy()
  self.textTime = nil
  self.imgCurAvatar = nil
  self.imgGender = nil
  self.textPlayerName = nil
  self.textThumbUp = nil
  self.textMessage = nil
  self.compSelectNode = nil
  self.imgSelect = nil
  self.btn = nil
  self.btnSelect = nil
end

function LWUIActEasterEggMessageItem:DataDefine()
  ChatInterface.SetEmojiTextProperty(self.textMessage)
  self.eggInfo = nil
end

function LWUIActEasterEggMessageItem:DataDestroy()
  self.eggInfo = nil
end

function LWUIActEasterEggMessageItem:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.EasterEggGetActivityMyEggsInfoEnterEdit, self.OnRecEnterEditMode)
  self:AddUIListener(EventId.EasterEggGetActivityMyEggsInfoExitEdit, self.OnRecExitEditMode)
  self:AddUIListener(EventId.EasterEggGetActivityEggsInfoSelectAll, self.OnRecSelectAll)
end

function LWUIActEasterEggMessageItem:OnRemoveListener()
  base.OnRemoveListener(self)
  self:RemoveUIListener(EventId.EasterEggGetActivityMyEggsInfoEnterEdit, self.OnRecEnterEditMode)
  self:RemoveUIListener(EventId.EasterEggGetActivityMyEggsInfoExitEdit, self.OnRecExitEditMode)
  self:RemoveUIListener(EventId.EasterEggGetActivityEggsInfoSelectAll, self.OnRecSelectAll)
end

function LWUIActEasterEggMessageItem:OnBtnClick()
  if not self.eggInfo or not self.eggInfo.eggUuid then
    Logger.LogError("eggUuid is nil")
    return
  end
  DataCenter.ActEasterEggManager:ViewEgg(self.eggInfo.eggUuid)
end

function LWUIActEasterEggMessageItem:RefreshByEggInfo(eggInfo, channel, ctrl)
  if not eggInfo then
    Logger.LogError("eggInfo is nil")
    return
  end
  self.eggInfo = eggInfo
  self.ctrl = ctrl
  local time = UITimeManager:GetInstance():TimeStampToTimeForLocal(eggInfo.createTime * 1000)
  self.textTime:SetText(time or "0")
  local headIconPath = HeroUtils.GetHeroIconPath(eggInfo.anonymousHeadIndex)
  self.imgCurAvatar:LoadSpriteAuto(headIconPath)
  local name = ""
  if channel == ActEasterMessageTab.Send then
    local postEggsInfo = DataCenter.ActEasterEggManager:GetMyPostEggsInfo()
    name = DataCenter.ActEasterEggManager:GetTranslateName(postEggsInfo.curAnonymousName)
  elseif channel == ActEasterMessageTab.Comment then
    name = DataCenter.ActEasterEggManager:GetTranslateName(eggInfo.curAnonymousName)
  end
  self.textPlayerName:SetText(name)
  self.textThumbUp:SetText(eggInfo.thumbsUp)
  self.textMessage:SetText(eggInfo.content)
  local gender
  if channel == ActEasterMessageTab.Send then
    gender = LuaEntry.Player:GetGender()
  elseif channel == ActEasterMessageTab.Comment then
    gender = eggInfo.playerInfo.gender
  end
  if gender == 1 then
    self.imgGender:LoadSprite(manIconPath)
  elseif gender == 2 then
    self.imgGender:LoadSprite(womenIconPath)
  end
  local isInEditMode = self.ctrl and self.ctrl:InEditMode()
  self.compSelectNode:SetActive(isInEditMode)
  local isSelect = eggInfo.selected
  self.imgSelect:SetActive(isSelect)
end

function LWUIActEasterEggMessageItem:OnRecEnterEditMode()
  self.compSelectNode:SetActive(true)
  self.imgSelect:SetActive(false)
end

function LWUIActEasterEggMessageItem:OnRecExitEditMode()
  self.compSelectNode:SetActive(false)
end

function LWUIActEasterEggMessageItem:OnRecSelectAll()
  if not self.eggInfo then
    return
  end
  local selected = self.eggInfo.selected
  self.imgSelect:SetActive(selected)
end

function LWUIActEasterEggMessageItem:OnBtnSelectClick()
  if not self.eggInfo then
    return
  end
  local select = self.eggInfo.selected
  local curSelect = not select
  self.eggInfo.selected = curSelect
  self.imgSelect:SetActive(curSelect)
  EventManager:GetInstance():Broadcast(EventId.EasterEggGetActivityEggsInfoSelect)
end

return LWUIActEasterEggMessageItem
