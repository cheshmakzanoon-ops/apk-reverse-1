local IChatItemPost = require("UI.UIChatNewV2.Component.ChatItem.IChatItemPost")
local ElectricianGather = BaseClass("ElectricianGather", IChatItemPost)
local base = IChatItemPost
local rapidjson = require("rapidjson")
local Localization = CS.GameEntry.Localization
local icon_path = "icon"
local icon_bg_path = "iconBg"
local title_path = "title"
local btn_tip_path = "BtnTip"
local desc_path = "desc"
local image_path = "image"
local num_path = "num"
local btn_join_path = "BtnJoin"
local MailBattleParseHelper = require("DataCenter.MailData.MailBattleParseHelper")

function ElectricianGather:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
end

function ElectricianGather:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function ElectricianGather:ComponentDefine()
  self.icon = self:AddComponent(UIImage, icon_path)
  self.iconBg = self:AddComponent(UIImage, icon_bg_path)
  self.title = self:AddComponent(UITextMeshProUGUIEx, title_path)
  self.btn_tip = self:AddComponent(UIButton, btn_tip_path)
  self.btn_tip:SetOnClick(function()
    local content = Localization:GetString("season_mastery_s4_tips_19")
    UIUtil.ShowBubbleTips(content, self.btn_tip.transform.position, -25, -50, 0)
  end)
  self.desc = self:AddComponent(UITextMeshProUGUIEx, desc_path)
  self.desc:SetLocalText("season_mastery_s4_text_8_tips")
  self.image = self:AddComponent(UIImage, image_path)
  self.image:LoadSprite("Assets/Main/SeasonRes/S4/Sprites/Common/PowerHouseIcon/ljq_saijis4_rukou_dianliang_09.png")
  self.num = self:AddComponent(UITextMeshProUGUIEx, num_path)
  self.btn_join = self:AddComponent(UIButton, btn_join_path)
  self.btn_join:SetOnClick(function()
    self:OnClickJoinBtn()
  end)
end

function ElectricianGather:ComponentDestroy()
  self.icon = nil
  self.title = nil
  self.btn_tip = nil
  self.desc = nil
  self.image = nil
  self.num = nil
  self.btn_join = nil
  self.inited = nil
  self.iconBg = nil
end

function ElectricianGather:OnClickBg()
  if self.mailId then
    DataCenter.MailDataManager:OpenShareMail(self.mailId, self.toUser)
  end
end

function ElectricianGather:OnLoaded()
  local chatData = self:ChatData()
  if not chatData then
    return
  end
  self.seqId = chatData.seqId
  self.senderUid = chatData.senderUid
  self.pointId = nil
  self.buildUuid = nil
  if chatData.extra and chatData.extra.customJsonParam then
    local jsonObj = rapidjson.decode(chatData.extra.customJsonParam)
    if jsonObj then
      local cur = jsonObj.curWorkerNum or 0
      local max = jsonObj.maxWorkerNum or 0
      local brightnessLevel = jsonObj.brightnessLevel or 0
      self.num:SetText(string.format("Lv.%d %d/%d", brightnessLevel, cur, max))
      self.pointId = jsonObj.pointId
      self.buildUuid = jsonObj.uuid
      if LightIconByLevel[brightnessLevel] then
        self.image:LoadSprite(LightIconByLevel[brightnessLevel])
      end
    end
  end
  local skillTemplate = DataCenter.MasteryManager:GetSkillTemplateByType(MasterySkill.ElectricianGather)
  if skillTemplate then
    self.icon:LoadSpriteAsync(skillTemplate:GetIconFullPath())
    self.iconBg:LoadSpriteAsync(string.format(LoadPath.LWMasterySpritePath, "Mjc_zhiyezhuanjing_icon_bg02"))
    self.title:SetLocalText(skillTemplate.name)
  end
  if not self.inited then
    self.inited = true
    self:Update1000MS()
  end
end

function ElectricianGather:GetPlayerName()
end

function ElectricianGather:OnRecycle()
end

function ElectricianGather:OnClickJoinBtn()
  if self.senderUid then
    if self.senderUid == LuaEntry.Player:GetUid() then
      UIUtil.ShowTipsId("season_mastery_s4_tips_20")
      return
    end
    if not self.buildUuid then
      Logger.LogError("\231\148\181\229\183\165\229\143\172\233\155\134\230\178\161\230\156\137\229\164\167\230\156\172uuid")
      return
    end
    if not self.pointId then
      UIUtil.ShowTipsId("season_mastery_s4_tips_14")
      return
    end
    DataCenter.SeasonPowerWorkerManager:SendElectricianToAlly(self.senderUid, self.pointId, self.buildUuid)
  end
end

function ElectricianGather:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.ElectricianGatherRefresh, self.OnElectricianGatherRefresh)
end

function ElectricianGather:OnRemoveListener()
  base.OnRemoveListener(self)
  self:RemoveUIListener(EventId.ElectricianGatherRefresh, self.OnElectricianGatherRefresh)
end

function ElectricianGather:OnElectricianGatherRefresh(seqId)
  if seqId == self.seqId then
    self:OnLoaded()
  end
end

function ElectricianGather:Update1000MS()
  if self.senderUid and self.seqId then
    SFSNetwork.SendMessage(MsgDefines.GainAllianceShareSkillMsg, self.senderUid, self.seqId)
  end
end

return ElectricianGather
