local base = require("UI.UIChatNewV2.Component.ChatItem.IChatItemPost")
local rapidjson = require("rapidjson")
local KillZombieBoxShare = BaseClass("KillZombieBoxShare", base)
local BoxIcon = {
  "Assets/Main/TextureEx/UIActivityKillZombie/wxy_jiangjunshilian_box01.png",
  "Assets/Main/TextureEx/UIActivityKillZombie/wxy_jiangjunshilian_lvbox01.png",
  "Assets/Main/TextureEx/UIActivityKillZombie/wxy_jiangjunshilian_lanbox01.png",
  "Assets/Main/TextureEx/UIActivityKillZombie/wxy_jiangjunshilian_zibox01.png",
  "Assets/Main/TextureEx/UIActivityKillZombie/wxy_jiangjunshilian_chengbox01.png"
}
local content_text_path = "Root/ContentText"
local box_icon_path = "Root/BoxIcon"
local click_path = "Root/Click"

function KillZombieBoxShare:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function KillZombieBoxShare:OnDestroy()
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

function KillZombieBoxShare:ComponentDefine()
  self.content_text = self:AddComponent(UITextMeshProUGUIEx, content_text_path)
  self.box_icon = self:AddComponent(UIRawImage, box_icon_path)
  self.click = self:AddComponent(UIButton, click_path)
  self.click:SetOnClick(BindCallback(self, self.OnItemClick))
end

function KillZombieBoxShare:ComponentDestroy()
  self.content_text = nil
  self.box_icon = nil
  self.click = nil
end

function KillZombieBoxShare:DataDefine()
  self._chatData = nil
  self.param = nil
end

function KillZombieBoxShare:DataDestroy()
  self._chatData = nil
  self.param = nil
end

function KillZombieBoxShare:OnLoaded()
  local _chat_data = self:ChatData()
  self._chatData = _chat_data
  local param
  if _chat_data then
    local attachmentId = _chat_data.attachmentId
    if not string.IsNullOrEmpty(attachmentId) then
      param = rapidjson.decode(attachmentId)
      if param then
        local context = CS.GameEntry.Localization:GetString("challenge_zombie_alliance_reward_share", param.rewardCount)
        self.content_text:SetText(context)
        local quality = param.quality
        if 0 < quality and quality <= #BoxIcon then
          self.box_icon:LoadSprite(BoxIcon[quality])
        end
      end
    end
  end
  self.param = param
end

function KillZombieBoxShare:OnItemClick()
  if self._chatData ~= nil and self.param ~= nil then
    local param = self.param
    if param then
      local endTs = param.endTs
      local curTs = UITimeManager:GetInstance():GetServerTime()
      if endTs == nil or endTs == 0 or endTs < curTs then
        UIUtil.ShowTipsId("challenge_zombie_share_expired_tips")
        return
      end
      local p = {}
      p.uid = self._chatData.senderUid
      p.bossId = param.bossId
      UIManager:GetInstance():OpenWindow(UIWindowNames.KillZombieBoxUpgrade, {anim = true}, p)
    end
  end
end

return KillZombieBoxShare
