local base = require("UI.UIChatNewV2.Component.ChatItem.IChatItemPost")
local rapidjson = require("rapidjson")
local SurfingInviteAllyShare = BaseClass("SurfingInviteAllyShare", base)
local title_text_path = "Root/TitleText"
local slider_path = "Root/Slider"
local progress_text_path = "Root/Slider/ProgressText"
local content_text_path = "Root/ContentText"
local help_btn_path = "Root/HelpBtn"
local help_btn_text_path = "Root/HelpBtn/HelpBtnText"
local icon_path = "Root/IconBg/Icon"
local ICON_PATH = "Assets/Main/TextureEx/UISurfingBattle/zyf_zhuwei_jiayou_daoju_icon.png"

function SurfingInviteAllyShare:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function SurfingInviteAllyShare:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function SurfingInviteAllyShare:ComponentDefine()
  self.title_text = self:AddComponent(UITextMeshProUGUIEx, title_text_path)
  self.title_text:SetLocalText("parkour_help_title")
  self.slider = self:AddComponent(UISlider, slider_path)
  self.progress_text = self:AddComponent(UITextMeshProUGUIEx, progress_text_path)
  self.content_text = self:AddComponent(UITextMeshProUGUIEx, content_text_path)
  self.content_text:SetLocalText("parkour_help_desc")
  self.help_btn = self:AddComponent(UIButton, help_btn_path)
  self.help_btn:SetOnClick(BindCallback(self, self.OnHelpBtnClick))
  self.help_btn_text = self:AddComponent(UITextMeshProUGUIEx, help_btn_text_path)
  self.help_btn_text:SetLocalText("parkour_help_btn")
  self.icon = self:AddComponent(UIRawImage, icon_path)
  self.icon:LoadSpriteAsync(ICON_PATH)
end

function SurfingInviteAllyShare:ComponentDestroy()
  self.title_text = nil
  self.slider = nil
  self.progress_text = nil
  self.content_text = nil
  self.help_btn = nil
  self.help_btn_text = nil
  self.icon = nil
end

function SurfingInviteAllyShare:DataDefine()
  self._chatData = nil
  self.seqId = nil
  self.roomId = nil
end

function SurfingInviteAllyShare:OnRecycle()
  self._chatData = nil
  self.seqId = nil
  self.roomId = nil
end

function SurfingInviteAllyShare:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(ChatEventEnum.CHAT_ROOM_ONEMSG_UPDATA, self.OnUpdateMsg)
  self:AddUIListener(ChatEventEnum.CHAT_DEL_MSG, self.OnDeleteMsg)
  self:AddUIListener(EventId.OnPassDay, self.RefreshView)
  self:AddUIListener(EventId.SurfingInviteHelpSuccess, self.OnHelpSuccess)
end

function SurfingInviteAllyShare:OnRemoveListener()
  self:RemoveUIListener(ChatEventEnum.CHAT_ROOM_ONEMSG_UPDATA, self.OnUpdateMsg)
  self:RemoveUIListener(ChatEventEnum.CHAT_DEL_MSG, self.OnDeleteMsg)
  self:RemoveUIListener(EventId.OnPassDay, self.RefreshView)
  self:RemoveUIListener(EventId.SurfingInviteHelpSuccess, self.OnHelpSuccess)
  base.OnRemoveListener(self)
end

function SurfingInviteAllyShare:OnLoaded()
  local _chat_data = self:ChatData()
  self._chatData = _chat_data
  if _chat_data == nil then
    return
  end
  self.seqId = _chat_data:getSeqId()
  self.roomId = _chat_data.roomId
  self.maxTimes = rapidjson.decode(_chat_data.extra.customJsonParam).max or 0
  self:RefreshView()
end

function SurfingInviteAllyShare:RefreshView()
  if self._chatData and self._chatData.clientUpdateExtra ~= nil then
    self.uidList = string.split(self._chatData.clientUpdateExtra, ";")
  else
    self.uidList = {}
  end
  local helpNum = self:GetHelpNum()
  self.progress_text:SetText(string.format("%d/%d", helpNum, self.maxTimes))
  local progress = 0
  if self.maxTimes ~= 0 then
    progress = helpNum / self.maxTimes
  end
  self.slider:SetValue(progress)
  if self._chatData:isMyChat() then
    CS.UIGray.SetGray(self.help_btn.transform, true, false)
    self.help_btn_text:SetLocalText("parkour_help_btn_self")
  else
    local curTime = UITimeManager:GetInstance():GetServerTime()
    local isSameDay = UITimeManager:GetInstance():IsSameDayForServer(curTime // 1000, (self._chatData.serverTime or 0) // 1000)
    if isSameDay then
      if self:IsHelped() then
        CS.UIGray.SetGray(self.help_btn.transform, true, false)
        self.help_btn_text:SetLocalText("parkour_help_btn_gray")
      else
        CS.UIGray.SetGray(self.help_btn.transform, false, true)
        self.help_btn_text:SetLocalText("parkour_help_btn")
      end
    else
      CS.UIGray.SetGray(self.help_btn.transform, true, false)
      self.help_btn_text:SetLocalText("red_pocket_desc6")
    end
  end
end

function SurfingInviteAllyShare:GetHelpNum()
  if not self.uidList then
    return 0
  end
  local uidNum = #self.uidList
  return uidNum
end

function SurfingInviteAllyShare:IsHelped()
  if not self.uidList then
    return false
  end
  for _, v in ipairs(self.uidList) do
    if v == LuaEntry.Player.uid then
      return true
    end
  end
  return false
end

function SurfingInviteAllyShare:OnUpdateMsg(chatData)
  if chatData and chatData.seqId == self.seqId and chatData.roomId == self.roomId then
    self._chatData = chatData
    self:RefreshView()
  end
end

function SurfingInviteAllyShare:OnDeleteMsg(chatData)
  if chatData and chatData.seqId == self.seqId and chatData.roomid == self.roomId then
    CS.UIGray.SetGray(self.help_btn.transform, true, false)
  end
end

function SurfingInviteAllyShare:OnHelpSuccess(uid)
  if not self._chatData or uid == self._chatData.senderUid then
  end
end

function SurfingInviteAllyShare:OnHelpBtnClick()
  if self._chatData ~= nil then
    if self._chatData:isMyChat() then
      return
    end
    if self:GetHelpNum() >= self.maxTimes then
      return
    end
    local curTime = UITimeManager:GetInstance():GetServerTime()
    local isSameDay = UITimeManager:GetInstance():IsSameDayForServer(curTime // 1000, (self._chatData.serverTime or 0) // 1000)
    if not isSameDay then
      return
    end
    if self:IsHelped() then
      return
    end
    if not LuaEntry.Player:IsLoginSourceServer() then
      UIUtil.ShowTipsId("parkour_cross_server_error")
      return
    end
    SFSNetwork.SendMessage(MsgDefines.ParkourAcceptInvite, self._chatData.senderUid)
  end
end

return SurfingInviteAllyShare
