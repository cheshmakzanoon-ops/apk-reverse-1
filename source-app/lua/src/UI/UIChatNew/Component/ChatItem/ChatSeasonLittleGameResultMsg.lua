local base = require("UI.UIChatNewV2.Component.ChatItem.IChatItemPost")
local rapidjson = require("rapidjson")
local ChatSeasonLittleGameResultMsg = BaseClass("ChatSeasonLittleGameResultMsg", base)
local LWLittleGameResult = require("DataCenter.LWGGGo.LWGGGoResult")
local RESULT_ICONS = {
  "Assets/Main/Sprites/UI/LWChat_v2/DefaultSkin/ChatItems/zyf_youjian_victory.png",
  "Assets/Main/Sprites/UI/LWChat_v2/DefaultSkin/ChatItems/zyf_youjian_defeat.png",
  "Assets/Main/MiniGameRes/BiuBiu/Sprites/UI/zxl_chaoshi_wenben.png"
}
local TYPE_CONFIG = {
  [EnumActivity.GGGo.Type] = {
    title = "activity_1200118_name",
    resultTexts = {
      [1] = "season_s6_minigame_erro_tips_4",
      [2] = "season_s6_minigame_erro_tips_5",
      [3] = "season_s6_minigame_erro_tips_6"
    },
    icon = "Assets/Main/MiniGameRes/GGGo/Textures/ChatShared/zxl_100ceng_liaotian_huo.png"
  }
}
local txt_title_path = "Content/txt_title"
local txt_des_path = "Content/txt_des"
local btn_path = "Content/Btn"
local img_icon_path = "Content/img_icon"
local img_resullt_path = "Content/img_resullt"

function ChatSeasonLittleGameResultMsg:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
end

function ChatSeasonLittleGameResultMsg:OnDestroy()
  self.battleResult = nil
  self.activityType = nil
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function ChatSeasonLittleGameResultMsg:ComponentDefine()
  self.txt_title = self:AddComponent(UITextMeshProUGUIEx, txt_title_path)
  self.txt_des = self:AddComponent(UITextMeshProUGUIEx, txt_des_path)
  self.btn = self:AddComponent(UIButton, btn_path)
  self.img_icon = self:AddComponent(UIImage, img_icon_path)
  self.img_resullt = self:AddComponent(UIImage, img_resullt_path)
  self.btn:SetOnClick(BindCallback(self, self.BtnClick))
end

function ChatSeasonLittleGameResultMsg:ComponentDestroy()
  self.txt_title = nil
  self.txt_des = nil
  self.btn = nil
  self.img_icon = nil
  self.img_resullt = nil
end

function ChatSeasonLittleGameResultMsg:OnLoaded()
  self._chatData = self:ChatData()
  if self._chatData == nil then
    return
  end
  self:Refresh()
end

function ChatSeasonLittleGameResultMsg:OnRecycle()
  self.battleResult = nil
  self.activityType = nil
end

function ChatSeasonLittleGameResultMsg:GetActivityConfig()
  local activityType = self.activityType or EnumActivity.GGGo.Type
  return TYPE_CONFIG[activityType] or TYPE_CONFIG[EnumActivity.GGGo.Type]
end

function ChatSeasonLittleGameResultMsg:RefreshUI()
  if self.battleResult == nil then
    return
  end
  local result = self.battleResult:GetResult()
  local _, otherHead = self.battleResult:GetUserInfos()
  local config = self:GetActivityConfig()
  if config.title and self.txt_title then
    self.txt_title:SetLocalText(config.title)
  end
  if result and 1 <= result and result <= 3 then
    local resultIcon = RESULT_ICONS[result]
    if resultIcon and self.img_resullt then
      self.img_resullt:LoadSpriteAsync(resultIcon)
    end
    local resultText = config.resultTexts and config.resultTexts[result]
    if resultText and otherHead and otherHead.name and self.txt_des then
      self.txt_des:SetLocalText(resultText, otherHead.name)
    end
  end
  if config.icon and self.img_icon then
    self.img_icon:LoadSpriteAsync(config.icon)
  end
end

function ChatSeasonLittleGameResultMsg:Refresh()
  self:DecodeData()
  self:RefreshUI()
end

function ChatSeasonLittleGameResultMsg:DecodeData()
  if self.battleResult ~= nil then
    return
  end
  if self._chatData and self._chatData.extra ~= nil and self._chatData.extra.attachmentId ~= nil then
    local jsonObj = rapidjson.decode(self._chatData.extra.attachmentId)
    if jsonObj then
      self.activityType = jsonObj.activityType or EnumActivity.GGGo.Type
      local serverResult = jsonObj.serverResult
      local gameLiftResult = jsonObj.gameLiftResult
      self.battleResult = LWLittleGameResult.New()
      self.battleResult.data.serverResult = serverResult
      self.battleResult.data.gameLiftResult = gameLiftResult
      self.battleResult.type = 1
    end
  end
end

function ChatSeasonLittleGameResultMsg:BtnClick()
  UIManager:GetInstance():OpenWindow(UIWindowNames.UILWGGGoPvpResult, {anim = true}, self.battleResult)
end

return ChatSeasonLittleGameResultMsg
