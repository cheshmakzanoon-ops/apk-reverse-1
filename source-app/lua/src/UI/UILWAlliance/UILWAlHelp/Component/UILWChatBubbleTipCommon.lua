local UILWChatBubbleTipCommon = BaseClass("UILWChatBubbleTipCommon", UIBaseContainer)
local base = UIBaseContainer
local rapidjson = require("rapidjson")
local click_btn_path = "Btn"
local txt_path = "Btn/txt"
local icon_path = "Btn/Icon"

function UILWChatBubbleTipCommon:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
end

function UILWChatBubbleTipCommon:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UILWChatBubbleTipCommon:ComponentDefine()
  self.clickBtn = self:AddComponent(UIButton, click_btn_path)
  self.clickBtn:SetOnClick(function()
    self:OnClick()
  end)
  self.txt = self:AddComponent(UITextMeshProUGUIEx, txt_path)
  self.icon = self:AddComponent(UIImage, icon_path)
end

function UILWChatBubbleTipCommon:ComponentDestroy()
  self.clickBtn = nil
  self.txt = nil
  self.icon = nil
end

function UILWChatBubbleTipCommon:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.GetNewUserInfoSucc, self.OnGetUserInfoSuccess)
end

function UILWChatBubbleTipCommon:OnRemoveListener()
  self:RemoveUIListener(EventId.GetNewUserInfoSucc, self.OnGetUserInfoSuccess)
  base.OnRemoveListener(self)
end

function UILWChatBubbleTipCommon:RefreshView()
  local curShowData = DataCenter.ChatViewTipBubbleDataManager:GetCurShowTipBubbleData()
  if curShowData == nil then
    self.clickBtn:SetActive(false)
  else
    self.clickBtn:SetActive(true)
    self.txt:SetText("")
    if curShowData.type == ChatViewTipBubbleType.AlHelp then
      self.icon:LoadSprite("Assets/Main/Sprites/UI/UIMain/LWMainUI/zyf_zhujiemian_tongmeng_icon2.png")
      self.icon:SetNativeSize()
      self.icon:SetAnchoredPositionXY(0, 0)
    elseif curShowData.type == ChatViewTipBubbleType.TrainTip then
      self.icon:LoadSprite("Assets/Main/Sprites/UI/UILWRailway/zxl_huoche_yaoqing_tubiao.png")
      self.icon:SetNativeSize()
      self.icon:SetAnchoredPositionXY(-2, 2.7)
    elseif curShowData.type == ChatViewTipBubbleType.RedPackage then
      local redPackageIcon = "Assets/Main/Sprites/UI/UIMain/LWMainUI/zyf_liaotian_jindan_icon.png"
      if not table.IsNullOrEmpty(curShowData.extra.chatData) then
        local chatData = curShowData.extra.chatData
        if chatData.extra ~= nil and chatData.extra.customJsonParam ~= nil then
          local extraJson = rapidjson.decode(chatData.extra.customJsonParam)
          if extraJson and extraJson.luckSiphonId ~= nil then
            redPackageIcon = "Assets/Main/Sprites/UI/UIGetLucky/zxl_haoyun_qipao.png"
          end
        end
      end
      self.icon:LoadSprite(redPackageIcon)
      self.icon:SetNativeSize()
      self.icon:SetAnchoredPositionXY(0, 0)
    elseif curShowData.type == ChatViewTipBubbleType.Treasure then
      local spritePath = "Assets/Main/Sprites/UI/UIMain/LWMainUI/zyf_liaotian_wajueji_icon.png"
      if curShowData.extra.eventId and 0 < curShowData.extra.eventId then
        local eventId = curShowData.extra.eventId
        local template = DataCenter.DetectEventTemplateManager:GetDetectEventTemplate(tostring(eventId))
        if template ~= nil and template.icon then
          if template.icon == "zyf_leida_icon8" then
            spritePath = "Assets/Main/Sprites/UI/UIMain/LWMainUI/zyf_liaotian_wajueji_icon.png"
          elseif template.icon == "zyf_leida_icon10" then
            spritePath = "Assets/Main/Sprites/UI/UIMain/LWMainUI/zyf_liaotian_wurenji_icon.png"
          else
            spritePath = "Assets/Main/Sprites/UI/UIMain/LWMainUI/zyf_liaotian_paidui_icon.png"
          end
        end
      end
      self.icon:LoadSprite(spritePath)
      self.icon:SetNativeSize()
      self.icon:SetAnchoredPositionXY(0, 0)
    elseif curShowData.type == ChatViewTipBubbleType.HighFive or curShowData.type == ChatViewTipBubbleType.AllianceCongratulation then
      self.icon:LoadSprite("Assets/Main/Sprites/UI/LWChat_v2/DefaultSkin/ChatItems/mjc_lianmeng_jizhang_liaotian_bg03.png")
      self.icon:SetNativeSize()
      self.icon:SetAnchoredPositionXY(-2, 2.7)
    end
  end
end

function UILWChatBubbleTipCommon:OnClick()
  local curShowData = DataCenter.ChatViewTipBubbleDataManager:GetCurShowTipBubbleData()
  if curShowData == nil then
    return
  end
  local type = curShowData.type
  if type == ChatViewTipBubbleType.AlHelp then
    local curTime = UITimeManager:GetInstance():GetServerTime()
    SFSNetwork.SendMessage(MsgDefines.AlHelpAll, math.floor(curTime), self.clickBtn.transform.position, nil, true, true)
  elseif type == ChatViewTipBubbleType.TrainTip then
    local platform = DataCenter.LWAllyStationDataManager:GetPlatform(1)
    local trainData = DataCenter.LWAllyStationDataManager:GetTrainByPlatformId(1)
    if trainData and trainData.vipInfo then
      return
    elseif platform and platform.vipInvite and platform.vipInvite.vipId == LuaEntry.Player.uid then
      local curTime = UITimeManager:GetInstance():GetServerTime()
      if curTime < platform.vipInvite.endTime then
        local vipType = platform.vipInvite.vipType
        UIManager:GetInstance():OpenWindow(UIWindowNames.UITrainVIPBeInvitedPop, {anim = true}, vipType)
      end
    end
  elseif type == ChatViewTipBubbleType.RedPackage then
    local roomId = curShowData.extra.roomId
    local seqId = curShowData.extra.seqId
    DataCenter.ChatViewTipBubbleDataManager:ClearCurShowData()
    EventManager:GetInstance():Broadcast(EventId.ChatViewJumpToMsg, {
      roomId = roomId,
      seqId = seqId,
      jumpType = ChatJumpSeqIdType.TargetGotoCenterAndEffect
    })
  elseif type == ChatViewTipBubbleType.Treasure then
    local roomId = curShowData.extra.roomId
    local seqId = curShowData.extra.seqId
    DataCenter.ChatViewTipBubbleDataManager:ClearCurShowData()
    EventManager:GetInstance():Broadcast(EventId.ChatViewJumpToMsg, {
      roomId = roomId,
      seqId = seqId,
      jumpType = ChatJumpSeqIdType.TargetGotoCenterAndEffect
    })
  elseif type == ChatViewTipBubbleType.HighFive then
    DataCenter.ChatViewTipBubbleDataManager:ClearCurShowData()
    DataCenter.PlayerInfoDataManager:RequestHighFiveInfo()
  elseif type == ChatViewTipBubbleType.AllianceCongratulation then
    UIManager:GetInstance():OpenWindow(UIWindowNames.LWAllianceCongratulationPopView)
  end
end

function UILWChatBubbleTipCommon:OnGetUserInfoSuccess(uid)
  DataCenter.ChatViewTipBubbleDataManager:ClearCurShowData()
  if uid ~= LuaEntry.Player.uid then
    return
  end
  local curShowData = DataCenter.ChatViewTipBubbleDataManager:GetCurShowTipBubbleData()
  if curShowData and curShowData.extra and curShowData.extra.senderUid ~= uid then
    return
  end
end

return UILWChatBubbleTipCommon
