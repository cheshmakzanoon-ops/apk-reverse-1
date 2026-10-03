local base = require("UI.UIChatNewV2.Component.ChatItem.IChatItemPost")
local rapidjson = require("rapidjson")
local ChatItemClientPlayerShare = BaseClass("ChatItemClientPlayerShare", base)
local content_path = "Content"
local des_text_path = "Content/DesText"
local btn_path = "Content/Btn"
local ICON_PATH = {
  [PostType.SurfingBattleResultShare] = "Assets/Main/TextureEx/UISurfingBattle/lrb_paoku_liaotianfenxiang.png",
  [PostType.GhostBattleResultShare] = "Assets/Main/TextureEx/UIGhostParkour/mjc_ghost_paoku_liaotianfenxiang.png"
}

function ChatItemClientPlayerShare:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function ChatItemClientPlayerShare:OnDestroy()
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

function ChatItemClientPlayerShare:ComponentDefine()
  self.content = self:AddComponent(UIRawImage, content_path)
  self.des_text = self:AddComponent(UITextMeshProUGUIEx, des_text_path)
  self.btn = self:AddComponent(UIButton, btn_path)
  self.btn:SetOnClick(BindCallback(self, self.OnItemClick))
end

function ChatItemClientPlayerShare:ComponentDestroy()
  self.content = nil
  self.des_text = nil
  self.btn = nil
end

function ChatItemClientPlayerShare:DataDefine()
  self._chatData = nil
  self.param = nil
end

function ChatItemClientPlayerShare:DataDestroy()
  self._chatData = nil
  self.param = nil
end

function ChatItemClientPlayerShare:OnLoaded()
  local _chat_data = self:ChatData()
  self._chatData = _chat_data
  local param
  if _chat_data then
    self.content:LoadSpriteAsync(ICON_PATH[_chat_data.post])
    local attachmentId = _chat_data.attachmentId
    if not string.IsNullOrEmpty(attachmentId) then
      param = rapidjson.decode(attachmentId)
      if param then
        local context = param.context
        if context == nil or context == "" then
          local contextId = param.contextId
          if contextId == nil or contextId == "" then
            self.des_text:SetText("")
          else
            local para = param.para or ""
            local paraArr = string.split(para, "|")
            self.des_text:SetLocalText(contextId, table.unpack(paraArr))
          end
        else
          self.des_text:SetText(context)
        end
      end
    end
  end
  self.param = param
end

function ChatItemClientPlayerShare:OnItemClick()
  if self._chatData ~= nil and self.param ~= nil then
    local param = self.param
    if param then
      local endTs = param.endTs
      local curTs = UITimeManager:GetInstance():GetServerTime()
      if endTs == nil or endTs == 0 or endTs < curTs then
        UIUtil.ShowTipsId("challenge_zombie_share_expired_tips")
        return
      end
      local activityId = param.activityId
      local activityData = DataCenter.ActivityListDataManager:GetActivityDataById(activityId)
      if activityData ~= nil then
        GoToUtil.GotoOpenView(UIWindowNames.UIActivityCenterTable, activityId)
      else
        UIUtil.ShowTipsId("E100172")
      end
    end
  end
end

return ChatItemClientPlayerShare
