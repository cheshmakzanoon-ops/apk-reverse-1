local UILWMailDetailMeteoriteMoveNoticeSmall = BaseClass("UILWMailDetailMeteoriteMoveNoticeSmall", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local MailRewardItem = require("UI.UIMailNew.UIMailMainPanel.Component.MailRewardItem")
local rapidjson = require("rapidjson")
local base64 = require("Framework.Common.base64")
local title_txt_path = "System/DetailTitle"
local message_txt_path = "System/DScroll/DViewport/DContent/DMessage"
local message_richtxt_path = "System/DScroll/DViewport/DContent/DMessageRichText"
local reward_content_path = "System/DScroll/DViewport/DContent/DReward"
local reward_item_path = "System/DScroll/DViewport/DContent/MailRewardItem"
local coordinate_text_path = "System/DScroll/DViewport/DContent/top/CoordinateText"
local time_text_path = "System/DScroll/DViewport/DContent/top/TimeText"
local player_name_path = "System/DScroll/DViewport/DContent/top/PlayerName"
local head_path = "System/DScroll/DViewport/DContent/top/head"

function UILWMailDetailMeteoriteMoveNoticeSmall:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UILWMailDetailMeteoriteMoveNoticeSmall:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UILWMailDetailMeteoriteMoveNoticeSmall:ComponentDefine()
  self.titleTxt = self:AddComponent(UIText, title_txt_path)
  self.messageTxt = self:AddComponent(UIText, message_txt_path)
  self.messageRichTxt = self:AddComponent(UITextMeshProUGUIEx, message_richtxt_path)
  self.messageRichTxt:OnPointerClick(function(eventData)
    self:OnPointerClick(eventData.position)
  end)
  self.rewardContent = self:AddComponent(UIBaseContainer, reward_content_path)
  self.rewarditem = self.transform:Find(reward_item_path).gameObject
  self.rewarditem:GameObjectCreatePool()
  self.coordinate_text = self:AddComponent(UITextMeshProUGUIEx, coordinate_text_path)
  self.coordinateBtn = self:AddComponent(UIButton, coordinate_text_path)
  self.coordinateBtn:SetOnClick(function()
    if self.location ~= nil then
      self.view.ctrl:OnJumpClick(self.location.x, self.location.y, self.serverId)
    end
  end)
  self.time_text = self:AddComponent(UITextMeshProUGUIEx, time_text_path)
  self.player_name = self:AddComponent(UITextMeshProUGUIEx, player_name_path)
  self.head = self:AddComponent(UICommonHead, head_path)
  self.head:SetEnableClickShowInfo(true, true)
end

function UILWMailDetailMeteoriteMoveNoticeSmall:ComponentDestroy()
  self:RemoveRewards()
  self.titleTxt = nil
  self.messageTxt = nil
  self.messageRichTxt = nil
  self.timeTxt = nil
  self.rewardContent = nil
  self.rewarditem = nil
  self.coordinate_text = nil
  self.time_text = nil
  self.player_name = nil
  self.head = nil
end

function UILWMailDetailMeteoriteMoveNoticeSmall:DataDefine()
  self.mailUid = {}
  self.mailData = {}
end

function UILWMailDetailMeteoriteMoveNoticeSmall:DataDestroy()
  self.mailUid = nil
  self.mailData = nil
end

function UILWMailDetailMeteoriteMoveNoticeSmall:RefreshContent()
  self.mailUid = self.view.ctrl:GetCurrentMail()
  self.mailData = self.view.ctrl:GetCurrentMailData()
  local _strTitle = MailShowHelper.GetMainTitle(self.mailData)
  self.titleTxt:SetText(_strTitle)
  local _strContents = self.mailData:GetMailMessage()
  self:setMailText(_strContents)
  self:RemoveRewards()
  local data = rapidjson.decode(self.mailData.contents)
  local obj = {}
  if data then
    obj = data.obj or {}
  end
  self.coordinate_text:SetText()
  local pointId = toInt(obj.point)
  if 0 < pointId then
    self.location = SceneUtils.IndexToTilePos(pointId, ForceChangeScene.World)
    self.serverId = obj.server
    local posStr = self.view.ctrl:FormatCoordinateText(self.location, self.serverId)
    if string.IsNullOrEmpty(posStr) then
      self.coordinate_text:SetText("")
    else
      self.coordinate_text:SetLocalText("mail_tips_10001", posStr)
    end
  else
    self.coordinate_text:SetText("")
  end
  local _strTime = MailShowHelper.GetAbstractCreateTime(self.mailData)
  self.time_text:SetText(_strTime)
  local myInfo = LuaEntry.Player
  self.player_name:SetText("#" .. myInfo:GetSelfServerId() .. " " .. myInfo:GetFullName())
  local uid = myInfo:GetUid()
  local pic = myInfo:GetPic()
  local picVer = myInfo.picVer
  local headSkinPath = myInfo:GetHeadBgImg()
  self.head:SetData(uid, pic, picVer, nil, headSkinPath)
  local totalCnt = self:ShowReward(obj.data)
  self.rewardContent:SetActive(0 < totalCnt)
end

function UILWMailDetailMeteoriteMoveNoticeSmall:RemoveRewards()
  self.rewardContent:RemoveComponents(MailRewardItem)
  self.rewarditem.gameObject:GameObjectRecycleAll()
end

function UILWMailDetailMeteoriteMoveNoticeSmall:ShowReward(rewards)
  local totalCnt = 0
  if rewards ~= nil and 0 < table.count(rewards) then
    local tabReward = rewards
    for _, info in pairs(tabReward) do
      local itemId = info.id
      if itemId == 101 then
        itemId = ResourceType.MeteoriteCrystallization
      elseif itemId == 102 then
        itemId = ResourceType.MeteoriteNucleusOfStar
      end
      local param = {
        rewardType = RewardType.RESOURCE_ITEM,
        itemId = itemId,
        count = info.value,
        isDelete = true
      }
      totalCnt = totalCnt + 1
      self:ShowRewardItem(param)
    end
  end
  return totalCnt
end

function UILWMailDetailMeteoriteMoveNoticeSmall:ShowRewardItem(rewardData)
  NameCount = NameCount + 1
  local objName = rewardData.rewardType .. NameCount
  local item = self.rewarditem:GameObjectSpawn(self.rewardContent.transform)
  item.name = objName
  local obj = self.rewardContent:AddComponent(UICommonResItem, item.name)
  obj:ReInit(rewardData)
end

function UILWMailDetailMeteoriteMoveNoticeSmall:setMailText(txt)
  local hasLinkData = txt:find("<link") ~= nil and txt:find("</link>") ~= nil
  if not hasLinkData and txt:find("X:") ~= nil and txt:find("Y:") ~= nil then
    txt = FindAndAppendLinkInfo(txt)
  end
  if hasLinkData or txt:find("<u>") ~= nil and txt:find("</u>") ~= nil then
    self.messageRichTxt:SetText(txt)
    self.messageTxt:SetActive(false)
    self.messageRichTxt:SetActive(true)
  else
    self.messageTxt:SetText(txt)
    self.messageTxt:SetActive(true)
    self.messageRichTxt:SetActive(false)
  end
end

function UILWMailDetailMeteoriteMoveNoticeSmall:OnPointerClick(clickPos)
  if self.messageRichTxt == nil then
    return
  end
  local linkId = self.messageRichTxt:TryGetPointerClickLinkID(clickPos)
  if string.IsNullOrEmpty(linkId) then
    return
  end
  if string.find(linkId, "http:") or string.find(linkId, "https:") then
    CS.SDKManager.OpenURL(linkId)
  else
    local linkMsg = base64.decode(linkId)
    linkMsg = rapidjson.decode(linkMsg)
    GoToUtil.TryJumpToWorld(linkMsg)
  end
end

return UILWMailDetailMeteoriteMoveNoticeSmall
