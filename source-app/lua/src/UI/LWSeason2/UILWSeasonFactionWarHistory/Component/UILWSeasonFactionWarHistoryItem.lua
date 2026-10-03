local UILWSeasonFactionWarHistoryItem = BaseClass("UILWSeasonFactionWarHistoryItem", UIBaseContainer)
local base = UIBaseContainer
local SeasonFactionWarAliList = require("UI.LWSeason2.Activity.Component.SeasonFactionWar.SeasonFactionWarAliList")
local UIGray = CS.UIGray
local Localization = CS.GameEntry.Localization
local UnityLayoutElement = typeof(CS.UnityEngine.UI.LayoutElement)
local txt_time_path = "Txt_Time"
local icon1_path = "VsRoot/icon1"
local score1_path = "VsRoot/icon1/score1"
local win_lost1_path = "VsRoot/icon1/winLost1"
local icon2_path = "VsRoot/icon2"
local score2_path = "VsRoot/icon2/score2"
local win_lost2_path = "VsRoot/icon2/winLost2"
local ali_list_path = "AliList"

function UILWSeasonFactionWarHistoryItem:OnCreate()
  base.OnCreate(self)
  self.unity_LayoutElement = self.gameObject:GetComponent(UnityLayoutElement)
  self.txt_time = self:AddComponent(UITextMeshProUGUIEx, txt_time_path)
  self.icon1 = self:AddComponent(UIImage, icon1_path)
  self.score1 = self:AddComponent(UIImage, score1_path)
  self.win_lost1 = self:AddComponent(UIImage, win_lost1_path)
  self.icon2 = self:AddComponent(UIImage, icon2_path)
  self.score2 = self:AddComponent(UIImage, score2_path)
  self.win_lost2 = self:AddComponent(UIImage, win_lost2_path)
  self.ali_list = self:AddComponent(SeasonFactionWarAliList, ali_list_path)
end

function UILWSeasonFactionWarHistoryItem:OnDestroy()
  self.unity_LayoutElement = nil
  self.txt_time = nil
  self.icon1 = nil
  self.score1 = nil
  self.win_lost1 = nil
  self.icon2 = nil
  self.score2 = nil
  self.win_lost2 = nil
  self.ali_list = nil
  base.OnDestroy(self)
end

function UILWSeasonFactionWarHistoryItem:ReInit(index, data)
  self.txt_time:SetText(UITimeManager:GetInstance():TimeStampToTimeForServer(data.startTime))
  self.ali_list:SetAutoSizeEnable(true)
  self.ali_list:CanShowInviteWhenEmpty(false)
  self.ali_list:ShowEmptyIcon(false)
  self.ali_list:ReInit(data.vsInfo.defence, data.vsInfo.attack, "NotExist", "NotExist")
  self.ali_list:UpdateResChangeInfo(data.alResChangeInfo)
  self.ali_list:HideEmpty()
  local theHeight = 240 + self.ali_list:GetPreferredHeight()
  self.unity_LayoutElement.minHeight = theHeight
  self.unity_LayoutElement.preferredHeight = theHeight
  self:SetSizeDeltaXY(700, theHeight)
  for k, v in ipairs(data.vsInfo.defence) do
    local mgr = DataCenter.SeasonFactionWarDataManager
    local campId = mgr:GetCampIdByServerId(v.serverId)
    if campId == SeasonFactionType.Rebels then
      self.icon1:LoadSprite(mgr:GetCampIcon(SeasonFactionType.Rebels))
      self.icon2:LoadSprite(mgr:GetCampIcon(SeasonFactionType.Gendarmerie))
      break
    end
    self.icon1:LoadSprite(mgr:GetCampIcon(SeasonFactionType.Gendarmerie))
    self.icon2:LoadSprite(mgr:GetCampIcon(SeasonFactionType.Rebels))
    break
  end
  if data.result == 1 then
    self.win_lost1:SetActive(true)
    self.win_lost2:SetActive(true)
    self.win_lost1:LoadSprite("Assets/Main/Sprites/UI/UISeason/UISeason2/FactionDeclareWar/mjc_xituzhengdui_jiesuan_shengli.png")
    self.win_lost2:LoadSprite("Assets/Main/Sprites/UI/UISeason/UISeason2/FactionDeclareWar/mjc_xituzhengdui_jiesuan_shibai.png")
  elseif data.result == 2 then
    self.win_lost1:SetActive(true)
    self.win_lost2:SetActive(true)
    self.win_lost1:LoadSprite("Assets/Main/Sprites/UI/UISeason/UISeason2/FactionDeclareWar/mjc_xituzhengdui_jiesuan_shibai.png")
    self.win_lost2:LoadSprite("Assets/Main/Sprites/UI/UISeason/UISeason2/FactionDeclareWar/mjc_xituzhengdui_jiesuan_shengli.png")
  else
    self.win_lost1:SetActive(false)
    self.win_lost2:SetActive(false)
  end
end

return UILWSeasonFactionWarHistoryItem
