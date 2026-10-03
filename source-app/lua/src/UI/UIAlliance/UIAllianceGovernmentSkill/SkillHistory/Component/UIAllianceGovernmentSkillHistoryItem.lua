local UIAllianceGovernmentSkillHistoryItem = BaseClass("UIAllianceGovernmentSkillHistoryItem", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local rapidjson = require("rapidjson")
local base64 = require("Framework.Common.base64")

function UIAllianceGovernmentSkillHistoryItem:OnCreate()
  base.OnCreate(self)
  self.bg = self:AddComponent(UIImage, "bg")
  self.title = self:AddComponent(UITextMeshProUGUIEx, "title")
  self.playerHead = self:AddComponent(UICommonHead, "UIPlayerHead")
  self.link = self:AddComponent(UITextMeshProUGUIEx, "icon/link")
  self.time = self:AddComponent(UITextMeshProUGUIEx, "time")
  self.name_txt = self:AddComponent(UITextMeshProUGUIEx, "List/NameTxt")
  self.skill_info = self:AddComponent(UITextMeshProUGUIEx, "List/Skill_Info")
  self.link:OnPointerClick(function(eventData)
    self:GotoBattleArea()
  end)
end

function UIAllianceGovernmentSkillHistoryItem:OnDestroy()
  self.bg = nil
  self.title = nil
  self.playerHead = nil
  self.link = nil
  self.time = nil
  self.name_txt = nil
  self.skill_info = nil
  base.OnDestroy(self)
end

function UIAllianceGovernmentSkillHistoryItem:ReInit(index, data)
  self.data = data
  if data.result == 1 then
    self.bg:LoadSprite("Assets/Main/Sprites/UI/UISeasonReward/Mjc_saijijiangli_list.png")
    self.title:SetColorRGBA255(255, 230, 180, 255)
    self.title:SetLocalText("140057", "")
  else
    self.bg:LoadSprite("Assets/Main/Sprites/UI/UISeason/UISeason2/AresMissile/mjc_guanzhijineng_list_01.png")
    self.title:SetColorRGBA255(205, 230, 255, 255)
    self.title:SetLocalText("140058", "")
  end
  self.playerHead:ParseHeadInfo(data.user)
  self.link:SetText(UIUtil.MakeJumpLink(data.targetPointId, data.targetServerId, 0))
  self.time:SetText(UITimeManager:GetInstance():TimeStampToTimeForServer(data.eventTime))
  local skill_use = Localization:GetString("151117")
  local skillConf = DataCenter.AllianceGovernmentSkillManager:GetTemplatesById(data.skillId)
  local officialType = skillConf.type
  self.name_txt:SetText(UIUtil.FormatAllianceAndName(Localization:GetString(LWAlMemberOffcialParam[officialType].Text), data.user.name))
  local skill_name = Localization:GetString(skillConf.name)
  self.skill_info:SetText(skill_use .. " " .. skill_name)
end

function UIAllianceGovernmentSkillHistoryItem:GotoBattleArea()
  if self.data then
    local v3 = SceneUtils.TileIndexToWorld(self.data.targetPointId, ForceChangeScene.World)
    local serverId = self.data.targetServerId
    GoToUtil.CloseAllWindows()
    GoToUtil.GotoWorldPos(v3, CS.SceneManager.World.InitZoom, LookAtFocusTime, function()
    end, serverId, 0)
  end
end

return UIAllianceGovernmentSkillHistoryItem
