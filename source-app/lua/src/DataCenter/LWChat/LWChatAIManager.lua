local LWChatAICharacterTemplate = require("DataCenter.LWChat.LWChatAICharacterTemplate")
local LWChatAISwitchTemplate = require("DataCenter.LWChat.LWChatAISwitchTemplate")
local LWChatAICharRoomTemplate = require("DataCenter.LWChat.LWChatAICharRoomTemplate")
local LWChatAIFaqTemplate = require("DataCenter.LWChat.LWChatAIFaqTemplate")
local LWChatAIManager = BaseClass("LWChatAIManager")

function LWChatAIManager:__init()
end

function LWChatAIManager:__delete()
  self.TemplateDicCharacter = nil
  self.TemplateDicSwitch = nil
  self.TemplateDicSwitchRecv = nil
  self.TemplateDicSwitchPush = nil
  self.TemplateDicEmojiList = nil
  self.TemplateDicEmojiKeyValues = nil
  self.TemplateDicChatRoom = nil
  self.TemplateDicFaq = nil
end

function LWChatAIManager:InitAllTemplate()
  self.TemplateDicCharacter = {}
  self.TemplateDicSwitch = {}
  self.TemplateDicSwitchRecv = {}
  self.TemplateDicSwitchPush = {}
  self.TemplateDicEmojiKeyValues = {}
  self.TemplateDicEmojiList = {}
  self.TemplateDicChatRoom = {}
  self.TemplateDicFaq = {}
  LocalController:instance():visitTable(TableName.ai_chat_chatroom, function(id, lineData)
    local roomInfo = LWChatAICharRoomTemplate.New()
    roomInfo:InitData(lineData)
    if roomInfo.id ~= nil then
      self.TemplateDicChatRoom[roomInfo.id] = roomInfo
    end
  end)
  LocalController:instance():visitTable(TableName.ai_chat_character, function(id, lineData)
    local itemCharacter = LWChatAICharacterTemplate.New()
    itemCharacter:InitData(lineData)
    if itemCharacter.id ~= nil then
      self.TemplateDicCharacter[itemCharacter.id] = itemCharacter
    end
  end)
  LocalController:instance():visitTable(TableName.ai_chat_feedback_emo, function(id, lineData)
    local icon = lineData:getValue("icon")
    if icon ~= nil then
      local tblId = lineData:getIntValue("id")
      local iconPath = string.format("Assets/Main/Sprites/UI/UIChatAI/emoji/%s.png", icon)
      table.insert(self.TemplateDicEmojiList, {
        id = tblId,
        icon = name,
        path = iconPath
      })
      self.TemplateDicEmojiKeyValues[tblId] = {
        icon = name,
        path = iconPath
      }
    end
  end)
  LocalController:instance():visitTable(TableName.ai_chat_switch, function(id, lineData)
    local itemSwitch = LWChatAISwitchTemplate.New()
    itemSwitch:InitData(lineData)
    if itemSwitch.id ~= nil then
      self.TemplateDicSwitch[itemSwitch.id] = itemSwitch
      if itemSwitch:GetType() == 1 then
        self.TemplateDicSwitchRecv[itemSwitch.id] = itemSwitch
      else
        self.TemplateDicSwitchPush[itemSwitch.id] = itemSwitch
      end
    end
  end)
  LocalController:instance():visitTable(TableName.ai_chat_faq, function(id, lineData)
    local ui_key = lineData:getValue("key")
    local ui_name = lineData:getValue("ui_name")
    local ui_para = lineData:getValue("ui_para")
    local error_tips = lineData:getValue("tips")
    local switch_on = lineData:getIntValue("switch", 0)
    if ui_key ~= nil and ui_name ~= nil and switch_on == 1 then
      if type(ui_key) == "number" then
        local FAQ = LWChatAIFaqTemplate.New()
        FAQ:InitData(ui_key, ui_name, ui_para, error_tips, true)
        self.TemplateDicFaq[ui_key] = FAQ
      elseif type(ui_key) == "string" then
        local vec = string.split_ss_array(ui_key, "|")
        for _, v in ipairs(vec) do
          if v ~= nil and v ~= "" then
            local FAQ = LWChatAIFaqTemplate.New()
            FAQ:InitData(v, ui_name, ui_para, error_tips, true)
            self.TemplateDicFaq[tonumber(v)] = FAQ
          end
        end
      end
    end
  end)
end

function LWChatAIManager:GetChatRoomConfigById(room_id)
  if room_id == nil then
    return nil
  end
  if self.TemplateDicChatRoom == nil then
    self:InitAllTemplate()
  end
  local roomInfo = self.TemplateDicChatRoom[tonumber(room_id)]
  if roomInfo ~= nil then
    roomInfo:SetCharacterData(self:GetChatAICharacterData(roomInfo:GetCharacterId()))
  end
  return roomInfo
end

function LWChatAIManager:GetSwitchList()
  if self.TemplateDicSwitch == nil then
    self:InitAllTemplate()
  end
  return self.TemplateDicSwitch
end

function LWChatAIManager:GetSwitchPush()
  if self.TemplateDicSwitchPush == nil then
    self:InitAllTemplate()
  end
  return self.TemplateDicSwitchPush
end

function LWChatAIManager:GetSwitchPushById(theId)
  if self.TemplateDicSwitchPush == nil then
    self:InitAllTemplate()
  end
  return self.TemplateDicSwitchPush[tonumber(theId)]
end

function LWChatAIManager:GetSwitchRecv()
  if self.TemplateDicSwitchRecv == nil then
    self:InitAllTemplate()
  end
  return self.TemplateDicSwitchRecv
end

function LWChatAIManager:GetSwitchRecvById(theId)
  if self.TemplateDicSwitchRecv == nil then
    self:InitAllTemplate()
  end
  return self.TemplateDicSwitchRecv[tonumber(theId)]
end

function LWChatAIManager:GetChatAICharacterData(character_id)
  if character_id == nil then
    return nil
  end
  if self.TemplateDicCharacter == nil then
    self:InitAllTemplate()
  end
  return self.TemplateDicCharacter[tonumber(character_id)]
end

function LWChatAIManager:GetEmojiList()
  if self.TemplateDicEmojiList == nil then
    self:InitAllTemplate()
  end
  return self.TemplateDicEmojiList
end

function LWChatAIManager:GetEmojiKeyValues()
  if self.TemplateDicEmojiKeyValues == nil then
    self:InitAllTemplate()
  end
  return self.TemplateDicEmojiKeyValues
end

function LWChatAIManager:GetPushSwitchStatus()
  local dataList = self:GetSwitchPush()
  local ret = SFSObject.New()
  for push_id, _ in pairs(dataList) do
    local status = Setting:GetBool("ai.chat.push." .. push_id, true)
    ret:PutBool(tostring(push_id), status)
  end
  return ret
end

function LWChatAIManager:GetFaqList()
  if self.TemplateDicFaq == nil then
    self:InitAllTemplate()
  end
  return self.TemplateDicFaq
end

function LWChatAIManager:GetFaqByKey(key)
  if self.TemplateDicFaq == nil then
    self:InitAllTemplate()
  end
  return self.TemplateDicFaq[tonumber(key)]
end

function LWChatAIManager:DoJump(ui_name, ui_para, error_tips)
  local win_name = UIWindowNames[ui_name]
  if win_name ~= nil then
    if win_name == UIWindowNames.UILWScienceMain then
      GoToUtil.GotoScience()
      return true
    end
    if win_name == UIWindowNames.UILWResourceInfo then
      if ui_para ~= nil then
        local resourceType = tonumber(ui_para)
        UIManager:GetInstance():OpenWindow(UIWindowNames.UILWResourceInfo, {anim = true}, resourceType)
        return true
      end
      if error_tips ~= nil then
        UIUtil.ShowTipsId(error_tips)
      end
      return false
    end
    if win_name == UIWindowNames.UIAllianceScience then
      local hasAlliance = LuaEntry.Player:IsInAlliance()
      if hasAlliance then
        UIManager:GetInstance():OpenWindow(UIWindowNames.UIAllianceScience, {
          anim = true,
          UIMainAnim = UIMainAnimType.LeftRightBottomHide
        })
        return true
      end
      if error_tips ~= nil then
        UIUtil.ShowTipsId(error_tips)
      end
      return false
    end
    if win_name == UIWindowNames.UIAllianceMemberDetail then
      local allianceId = LuaEntry.Player:GetAllianceUid()
      if string.IsNullOrEmpty(allianceId) then
        if error_tips ~= nil then
          UIUtil.ShowTipsId(error_tips)
        end
        return false
      end
      UIManager:GetInstance():OpenWindow(UIWindowNames.UIAllianceMemberDetail, {anim = true, hideTop = false}, allianceId, AllianceMemberOpenType.AllianceMember)
      return true
    end
    if win_name == UIWindowNames.UIGiftPackage then
      return false
    end
    if win_name == UIWindowNames.LWBuyDiamond then
      local tagType = WelfareTagType.Unknown
      if ui_para == "MonthCard" then
        tagType = WelfareTagType.MonthCard
      elseif ui_para == "WeekCard" then
        tagType = WelfareTagType.WeekCard
      elseif ui_para == "DiamondShop" then
        tagType = WelfareTagType.DiamondShop
      else
        tagType = WelfareTagType[ui_para]
      end
      if tagType ~= nil and tagType ~= WelfareTagType.Unknown then
        local tabs = WelfareController.getShowTagInfos()
        for i, v in ipairs(tabs) do
          local type = v:getType()
          if type == tagType then
            UIManager:GetInstance():OpenWindow(UIWindowNames.LWBuyDiamond, {anim = true}, tagType)
            return true
          end
        end
      end
      if error_tips ~= nil then
        UIUtil.ShowTipsId(error_tips)
      end
      return false
    end
    if win_name == UIWindowNames.UIHeroRecruit then
      local unlock, _ = DataCenter.LWFunctionUnlockManager:CheckCanShow(LWFunctionUnlockType.HeroPanel_Require)
      if unlock then
        UIManager:GetInstance():OpenWindow(win_name, {anim = true})
        return true
      end
      if error_tips ~= nil then
        UIUtil.ShowTipsId(error_tips)
      end
      return false
    end
    if win_name == UIWindowNames.UILWAlMain then
      local hasAlliance = LuaEntry.Player:IsInAlliance()
      if hasAlliance then
        UIManager:GetInstance():OpenWindow(win_name, {anim = true})
        return true
      end
      if error_tips ~= nil then
        UIUtil.ShowTipsId(error_tips)
      end
      return false
    end
    if win_name == UIWindowNames.UIHeroListPanel or win_name == UIWindowNames.UIHeroDetailPanel then
      if string.IsNullOrEmpty(ui_para) then
        UIManager:GetInstance():OpenWindow(win_name, {anim = true})
        return true
      elseif IsNumber(ui_para) then
        local heroId = tonumber(ui_para)
        local hero_data = DataCenter.HeroDataManager:GetHeroByHeroId(heroId)
        if hero_data ~= nil then
          UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeroDetailPanel, {anim = false}, hero_data.uuid, {
            hero_data.uuid
          })
          return true
        end
        local meta = DataCenter.HeroTemplateManager:GetTemplate(heroId)
        if meta ~= nil and meta.fragId > 0 then
          UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeroDetailPanel, {anim = false}, meta.fragId, {
            meta.fragId
          })
          return true
        end
        return false
      else
        return false
      end
    end
    if win_name == UIWindowNames.UIAllianceWarMainTable or win_name == "UIAllianceBattle" or win_name == "UIAllianceWar" then
      local hasAlliance = LuaEntry.Player:IsInAlliance()
      if hasAlliance then
        local num_ui_para = tonumber(ui_para) or 2
        DataCenter.AllianceWarDataManager:OpenALWarMain(true, num_ui_para)
        return true
      end
      if error_tips ~= nil then
        UIUtil.ShowTipsId(error_tips)
      end
      return false
    end
    UIManager:GetInstance():OpenWindow(win_name, {anim = true})
    return true
  end
  return false
end

return LWChatAIManager
