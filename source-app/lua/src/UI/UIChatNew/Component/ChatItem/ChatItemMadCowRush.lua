local IChatItem = require("UI.UIChatNew.Component.ChatItem.IChatItem")
local ChatItemMadCowRush = BaseClass("ChatItemMadCowRush", IChatItem)
local base = IChatItem
local rapidjson = require("rapidjson")
local mad_name_path = "Assistant/MadCow/MadName"
local mad_number_path = "Assistant/MadCow/MadNumber"
local leisure_name_path = "Assistant/LeisureCow/LeisureName"
local leisure_number_path = "Assistant/LeisureCow/LeisureNumber"
local help_btn_path = "Assistant/HelpBtn"
local night_path = "Assistant/Night"
local title_text_path = "Assistant/TitleRoot/TitleText"
local desc_text_path = "Assistant/TitleRoot/DescText"
local tip_btn_path = "Assistant/TitleRoot/TipBtn"
local mad_cow_image_path = "Assistant/MadCow/MadCowImage"
local leisure_cow_image_path = "Assistant/LeisureCow/LeisureCowImage"
local leisure_cow_path = "Assistant/LeisureCow"

function ChatItemMadCowRush:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function ChatItemMadCowRush:OnDestroy()
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

function ChatItemMadCowRush:ComponentDefine()
  self.leisure_cow = self:AddComponent(UIImage, leisure_cow_path)
  self.mad_cow_image = self:AddComponent(UIImage, mad_cow_image_path)
  self.leisure_cow_image = self:AddComponent(UIImage, leisure_cow_image_path)
  self.mad_name = self:AddComponent(UITextMeshProUGUIEx, mad_name_path)
  self.mad_number = self:AddComponent(UITextMeshProUGUIEx, mad_number_path)
  self.leisure_name = self:AddComponent(UITextMeshProUGUIEx, leisure_name_path)
  self.leisure_name:SetLocalText("monster_calm_bull_name")
  self.leisure_number = self:AddComponent(UITextMeshProUGUIEx, leisure_number_path)
  self.help_btn = self:AddComponent(UIButton, help_btn_path)
  self.help_btn:SetOnClick(function()
    AllyDrillUtil.TryJumpToMyAllyDrillBase()
  end)
  self.night = self:AddComponent(UIImage, night_path)
  self.title_text = self:AddComponent(UITextMeshProUGUIEx, title_text_path)
  self.title_text:SetLocalText("activity_military_exercises_bull_title")
  self.desc_text = self:AddComponent(UITextMeshProUGUIEx, desc_text_path)
  self.desc_text:SetLocalText("activity_military_exercises_limit_23")
  self.tip_btn = self:AddComponent(UIButton, tip_btn_path)
  self.tip_btn:SetOnClick(function()
    local content = CS.GameEntry.Localization:GetString("activity_military_exercises_bull_rule")
    UIUtil.ShowBubbleTips(content, self.tip_btn.transform.position, -33, -44, 0)
  end)
end

function ChatItemMadCowRush:ComponentDestroy()
  self.mad_name = nil
  self.mad_number = nil
  self.leisure_name = nil
  self.leisure_number = nil
  self.help_btn = nil
  self.night = nil
  self.title_text = nil
  self.desc_text = nil
  self.tip_btn = nil
end

function ChatItemMadCowRush:DataDefine()
  self._chatData = nil
  self.seqId = nil
  self.roomId = nil
  self.data = nil
end

function ChatItemMadCowRush:DataDestroy()
  self._chatData = nil
  self.seqId = nil
  self.roomId = nil
  self.data = nil
end

function ChatItemMadCowRush:UpdateItem(chatData)
  self.night:SetActive(ChatInterface.GetChatTheme() == ChatUIThemeConfig.ChatMode.Night)
  self._chatData = chatData
  self.seqId = chatData:getSeqId()
  self.roomId = chatData.roomId
  if chatData and chatData.extra and chatData.extra.customJsonParam then
    self.data = rapidjson.decode(chatData.extra.customJsonParam)
  else
    return
  end
  if self.data == nil then
    return
  end
  local monsterArray = self.data.monsterArray
  local madCow = monsterArray[1]
  local madCowMeta = DataCenter.MonsterTemplateManager:GetMonsterTemplate(madCow.monsterId)
  self.mad_name:SetLocalText(madCowMeta.name)
  self.mad_cow_image:LoadSpriteAsync("Assets/Main/SeasonRes/Shared/Sprites/UI/MadCow/" .. madCowMeta.pic)
  self.mad_number:SetLocalText("activity_military_exercises_limit_4", madCow.num)
  local leisureCow = monsterArray[2]
  self.leisure_cow:SetActive(leisureCow)
  if leisureCow then
    local leisureCowMeta = DataCenter.MonsterTemplateManager:GetMonsterTemplate(leisureCow.monsterId)
    self.leisure_name:SetLocalText(leisureCowMeta.name)
    self.leisure_cow_image:LoadSpriteAsync("Assets/Main/SeasonRes/Shared/Sprites/UI/MadCow/" .. leisureCowMeta.pic)
    self.leisure_number:SetLocalText("activity_military_exercises_limit_4", leisureCow.num)
  end
end

function ChatItemMadCowRush:OnAddListener()
  base.OnAddListener(self)
end

function ChatItemMadCowRush:OnRemoveListener()
  base.OnRemoveListener(self)
end

function ChatItemMadCowRush:OnUpdateMsg(chatData)
end

function ChatItemMadCowRush:RefreshItemNum(chatData)
end

return ChatItemMadCowRush
