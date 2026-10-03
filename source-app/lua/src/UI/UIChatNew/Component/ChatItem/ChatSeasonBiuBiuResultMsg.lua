local base = require("UI.UIChatNewV2.Component.ChatItem.IChatItemPost")
local rapidjson = require("rapidjson")
local ChatSeasonBiuBiuResultMsg = BaseClass("ChatSeasonBiuBiuResultMsg", base)
local LWBiuBiuResult = require("DataCenter.LWBiuBiu.LWBiuBiuResult")
local RESULT_ICONS = {
  "Assets/Main/Sprites/UI/LWChat_v2/DefaultSkin/ChatItems/zyf_youjian_victory.png",
  "Assets/Main/Sprites/UI/LWChat_v2/DefaultSkin/ChatItems/zyf_youjian_defeat.png",
  "Assets/Main/MiniGameRes/BiuBiu/Sprites/UI/zxl_chaoshi_wenben.png"
}
local IMGICON = "Assets/Main/MiniGameRes/BiuBiu/Sprites/UI/zxl_zidan_fenxiang_tubiao.png"
local txt_des_path = "Content/txt_des"
local btn_path = "Content/Btn"
local img_icon_path = "Content/img_icon"
local img_resullt_path = "Content/img_resullt"

function ChatSeasonBiuBiuResultMsg:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
end

function ChatSeasonBiuBiuResultMsg:OnDestroy()
  self.battleResult = nil
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function ChatSeasonBiuBiuResultMsg:ComponentDefine()
  self.txt_des = self:AddComponent(UITextMeshProUGUIEx, txt_des_path)
  self.btn = self:AddComponent(UIButton, btn_path)
  self.img_icon = self:AddComponent(UIImage, img_icon_path)
  self.img_resullt = self:AddComponent(UIImage, img_resullt_path)
  self.btn:SetOnClick(BindCallback(self, self.BtnClick))
  self.img_icon:LoadSpriteAsync(IMGICON)
end

function ChatSeasonBiuBiuResultMsg:ComponentDestroy()
  self.txt_des = nil
  self.btn = nil
  self.img_icon = nil
  self.img_resullt = nil
end

function ChatSeasonBiuBiuResultMsg:OnLoaded()
  self._chatData = self:ChatData()
  if self._chatData == nil then
    return
  end
  self:Refresh()
end

function ChatSeasonBiuBiuResultMsg:OnRecycle()
  self.battleResult = nil
end

function ChatSeasonBiuBiuResultMsg:RefreshUI()
  if self.battleResult == nil then
    return
  end
  local result = self.battleResult:GetResult()
  local _, otherHead = self.battleResult:GetUserInfos()
  if result == 1 then
    self.img_resullt:LoadSpriteAsync(RESULT_ICONS[1])
    self.txt_des:SetLocalText("season_s5_activity_1200045_desc73", otherHead.name)
  elseif result == 2 then
    self.img_resullt:LoadSpriteAsync(RESULT_ICONS[2])
    self.txt_des:SetLocalText("season_s5_activity_1200045_desc74", otherHead.name)
  elseif result == 3 then
    self.img_resullt:LoadSpriteAsync(RESULT_ICONS[3])
    self.txt_des:SetLocalText("season_s5_activity_1200045_desc75", otherHead.name)
  end
end

function ChatSeasonBiuBiuResultMsg:Refresh()
  self:DecodeData()
  self:RefreshUI()
end

function ChatSeasonBiuBiuResultMsg:DecodeData()
  if self.battleResult ~= nil then
    return
  end
  if self._chatData and self._chatData.extra ~= nil and self._chatData.extra.attachmentId ~= nil then
    local jsonObj = rapidjson.decode(self._chatData.extra.attachmentId)
    if jsonObj then
      local serverResult = jsonObj.serverResult
      local gameLiftResult = jsonObj.gameLiftResult
      self.battleResult = LWBiuBiuResult.New()
      self.battleResult.data.serverResult = serverResult
      self.battleResult.data.gameLiftResult = gameLiftResult
      self.battleResult.type = 1
    end
  end
end

function ChatSeasonBiuBiuResultMsg:BtnClick()
  UIManager:GetInstance():OpenWindow(UIWindowNames.UILWBiuBiuPvpResult, {anim = true}, self.battleResult)
end

return ChatSeasonBiuBiuResultMsg
