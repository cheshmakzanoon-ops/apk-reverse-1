local UILWSeasonFactionWarDeclareHistoryItem = BaseClass("UILWSeasonFactionWarDeclareHistoryItem", UIBaseContainer)
local base = UIBaseContainer
local UIGray = CS.UIGray
local Localization = CS.GameEntry.Localization
local bg_path = "bg"
local txt_time_path = "Txt_Time"
local txt_title_path = "Txt_Title"
local title1_path = "title1"
local icon1_path = "title1/icon1"
local name1_path = "title1/icon1/name1"
local res1_path = "title1/resIcon1/Res1"
local power1_path = "title1/powerIcon/Power1"
local title2_path = "title2"
local icon2_path = "title2/icon2"
local name2_path = "title2/icon2/name2"
local res2_path = "title2/resIcon2/Res2"
local power2_path = "title2/powerIcon/Power2"
local res_icon1_path = "title1/resIcon1"
local res_icon2_path = "title2/resIcon2"

function UILWSeasonFactionWarDeclareHistoryItem:OnCreate()
  base.OnCreate(self)
  self.res_icon1 = self:AddComponent(UIImage, res_icon1_path)
  self.res_icon2 = self:AddComponent(UIImage, res_icon2_path)
  self.bg = self:AddComponent(UIRawImage, bg_path)
  self.txt_time = self:AddComponent(UITextMeshProUGUIEx, txt_time_path)
  self.txt_title = self:AddComponent(UITextMeshProUGUIEx, txt_title_path)
  self.title1 = self:AddComponent(UITextMeshProUGUIEx, title1_path)
  self.icon1 = self:AddComponent(UIImage, icon1_path)
  self.name1 = self:AddComponent(UITextMeshProUGUIEx, name1_path)
  self.res1 = self:AddComponent(UITextMeshProUGUIEx, res1_path)
  self.power1 = self:AddComponent(UITextMeshProUGUIEx, power1_path)
  self.title2 = self:AddComponent(UITextMeshProUGUIEx, title2_path)
  self.icon2 = self:AddComponent(UIImage, icon2_path)
  self.name2 = self:AddComponent(UITextMeshProUGUIEx, name2_path)
  self.res2 = self:AddComponent(UITextMeshProUGUIEx, res2_path)
  self.power2 = self:AddComponent(UITextMeshProUGUIEx, power2_path)
end

function UILWSeasonFactionWarDeclareHistoryItem:OnDestroy()
  self.bg = nil
  self.txt_time = nil
  self.txt_title = nil
  self.title1 = nil
  self.icon1 = nil
  self.name1 = nil
  self.res1 = nil
  self.power1 = nil
  self.title2 = nil
  self.icon2 = nil
  self.name2 = nil
  self.res2 = nil
  self.power2 = nil
  base.OnDestroy(self)
end

function UILWSeasonFactionWarDeclareHistoryItem:ReInit(index, data)
  self.res_icon1:LoadSprite(DataCenter.ResourceManager:GetResourceIconByType(ResourceType.AllianceStone))
  self.res_icon2:LoadSprite(DataCenter.ResourceManager:GetResourceIconByType(ResourceType.AllianceStone))
  self.txt_time:SetText(UITimeManager:GetInstance():TimeStampToTimeForServer(data.time))
  local serverId = data.src.serverId
  local abbr = data.src.abbr
  local compId = DataCenter.SeasonFactionWarDataManager:GetCampIdByServerId(serverId)
  local userInfo = UIUtil.FormatServerAllianceName(data.serverId, data.abbr, data.name)
  if data.opType == 1 then
    self.txt_title:SetLocalText("season_s2_faction_war_27", userInfo)
    if compId == 1 then
      self.txt_title:SetColorRGBA255(89, 24, 24)
      self.bg:LoadSprite("Assets/Main/TextureEx/Season/FactionDeclareWar/mjc_xituzhengdui_jilu_list_3.png")
    else
      self.txt_title:SetColorRGBA255(40, 70, 120)
      self.bg:LoadSprite("Assets/Main/TextureEx/Season/FactionDeclareWar/mjc_xituzhengdui_jilu_list_2.png")
    end
  else
    self.txt_title:SetColorRGBA255(55, 50, 50)
    self.txt_title:SetLocalText("season_s2_faction_war_28", userInfo)
    self.bg:LoadSprite("Assets/Main/TextureEx/Season/FactionDeclareWar/mjc_xituzhengdui_jilu_list_1.png")
  end
  self.title1:SetLocalText("801140", data.target.rank)
  self.icon1:LoadSprite("Assets/Main/Sprites/UI/UISeason/UISeason2/FactionDeclareWar/defence.png")
  self.name1:SetText(UIUtil.FormatServerAllianceName(data.target.serverId, data.target.abbr, data.target.name))
  self.res1:SetText(string.GetFormattedStr(data.target.resourceNum))
  self.power1:SetText(string.GetFormattedStr(data.target.power))
  self.title2:SetLocalText("801140", data.src.rank)
  self.icon2:LoadSprite("Assets/Main/Sprites/UI/UISeason/UISeason2/FactionDeclareWar/attack.png")
  self.name2:SetText(UIUtil.FormatServerAllianceName(data.src.serverId, data.src.abbr, data.src.name))
  self.res2:SetText(string.GetFormattedStr(data.src.resourceNum))
  self.power2:SetText(string.GetFormattedStr(data.src.power))
end

return UILWSeasonFactionWarDeclareHistoryItem
