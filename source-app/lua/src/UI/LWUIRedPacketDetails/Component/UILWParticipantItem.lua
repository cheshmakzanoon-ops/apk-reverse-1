local UILWParticipantItem = BaseClass("UILWParticipantItem", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local isMeColor = Color.New(0.984313725490196, 0.9019607843137255, 0.7058823529411765, 1)
local otherColor = Color.New(0.9411764705882353, 0.9098039215686274, 0.8980392156862745, 1)
local LuckyPacketBestIconPath = "Assets/Main/Sprites/UI/UIGetLucky/zxl_buff_haoyun_jianglin.png"
local NormalPacketBestIconPath = "Assets/Main/Sprites/UI/LWChat_v2/Common/FX_icon_HB_huangguan.png"
local LuckyPacketBestText = "luckyBuff_limit_bestLuck"
local NormalPacketBestText = "red_pocket_desc16"

function UILWParticipantItem:OnCreate()
  base.OnCreate(self)
  self:DataDefine()
  self:ComponentDefine()
end

function UILWParticipantItem:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UILWParticipantItem:ComponentDefine()
  self.playerHead = self:AddComponent(UICommonHead, "UIPlayerHead")
  self.serverId = self:AddComponent(UITextMeshProUGUIEx, "Layout/serverId")
  self.playerName = self:AddComponent(UITextMeshProUGUIEx, "Layout/playerName")
  self.bestIcon = self:AddComponent(UIImage, "best/bestIcon")
  self.bastCom = self:AddComponent(UIBaseContainer, "best")
  self.bestText = self:AddComponent(UITextMeshProUGUIEx, "best/bestText")
  self.rewardIcon = self:AddComponent(UIImage, "reward/icon")
  self.rewardText = self:AddComponent(UITextMeshProUGUIEx, "reward/rewardText")
  self.bg = self:AddComponent(UIImage, "")
end

function UILWParticipantItem:OnSendClick()
end

function UILWParticipantItem:ComponentDestroy()
  self.playerHead = nil
  self.playerName = nil
  self.bestIcon = nil
  self.bastCom = nil
  self.bestText = nil
  self.rewardIcon = nil
  self.rewardText = nil
end

function UILWParticipantItem:DataDefine()
end

function UILWParticipantItem:DataDestroy()
end

function UILWParticipantItem:Refresh(param)
  self.param = param
  if not self.param then
    return
  end
  if param.uid == LuaEntry.Player.uid then
    self.bg:SetColor(isMeColor)
  else
    self.bg:SetColor(otherColor)
  end
  self.bastCom:SetActive(self.param.isBest)
  if param.redPocketTemp.type == RedPacketType.LuckyBuff or param.redPocketTemp.type == RedPacketType.LuckyWithoutBuff then
    self.bestIcon:LoadSpriteAuto(LuckyPacketBestIconPath)
    self.bestText:SetLocalText(LuckyPacketBestText)
  else
    self.bestIcon:LoadSpriteAuto(NormalPacketBestIconPath)
    self.bestText:SetLocalText(NormalPacketBestText)
  end
  if self.param.uid and self.param.name then
    self.playerHead:SetHeadAndFrame(self.param.uid, self.param.pic, self.param.picVer, false, self.param.headSkinId, self.param.headSkinET)
    local showName = DataCenter.PlayerInfoDataManager:GetRemarkOrRealName(self.param.uid, self.param.name)
    self.playerName:SetText(showName)
  else
    local chatUserInfo = ChatManager2:GetInstance().User:getChatUserInfo(self.param.uid)
    self.playerHead:SetHeadAndFrame(chatUserInfo.uid, chatUserInfo.pic, chatUserInfo.picVer, false, chatUserInfo.headSkinId, chatUserInfo.headSkinET)
    local showName = DataCenter.PlayerInfoDataManager:GetRemarkOrRealName(chatUserInfo.uid, chatUserInfo.userName)
    self.playerName:SetText(showName)
  end
  self.rewardIcon:LoadSpriteAuto(self.param.redPocketTemp.reward.pic)
  self.rewardText:SetText(self.param.count)
  local showServerId = self.param.serverId ~= nil and self.param.serverId ~= LuaEntry.Player:GetSourceServerId()
  self.serverId:SetActive(showServerId)
  if showServerId then
    self.serverId:SetText("#" .. tostring(self.param.serverId))
  end
  if showServerId then
    self.playerName:SetColor(Color.red)
    self.serverId:SetColor(Color.red)
  else
    self.playerName:SetColor(Color.black)
    self.serverId:SetColor(Color.black)
  end
end

return UILWParticipantItem
