local base = UIBaseContainer
local LWSeasonFactionSelectionItem = BaseClass("LWSeasonFactionSelectionItem", UIBaseContainer)
local Localization = CS.GameEntry.Localization
local home_icon_empty_path = "homeIconEmpty"
local home_icon_path = "homeIcon"
local server_txt_path = "ServerBg/ServerTxt"
local server_bg_path = "ServerBg"
local show_it_path = "showIt"

function LWSeasonFactionSelectionItem:OnCreate()
  base.OnCreate(self)
  self.show_it = self:AddComponent(UIButton, show_it_path)
  self.home_icon_empty = self:AddComponent(UIButton, home_icon_empty_path)
  self.home_icon = self:AddComponent(UIButton, home_icon_path)
  self.server_bg = self:AddComponent(UIButton, server_bg_path)
  self.server_txt = self:AddComponent(UIText, server_txt_path)
  self.home_icon:SetActive(false)
  self.server_bg:SetActive(false)
  self.home_icon_empty:SetActive(true)
  self.show_it:SetOnClick(function()
    local res = DataCenter.ResourceManager:GetResourceNameByType(ResourceType.Gold)
    local msg1 = Localization:GetString("season_s2_camp_choose_24")
    local msg2 = Localization:GetString("season_s2_camp_choose_25", "<color=#e64141>" .. res .. "x500</color>")
    local msg = string.format([[
%s
<color=#0e9500>%s</color>]], msg1, msg2)
    UIUtil.ShowMessage(msg, 2, GameDialogDefine.CONFIRM, GameDialogDefine.CANCEL, function()
      if self.show_it then
        self.show_it:SetActive(false)
      end
      SFSNetwork.SendMessage(MsgDefines.EnableShowCampInfoToALL)
    end, nil, nil, "season_s2_camp_choose_23")
  end)
  self.show_it:SetActive(false)
end

function LWSeasonFactionSelectionItem:OnDestroy()
  self.show_it = nil
  self.home_icon_empty = nil
  self.home_icon = nil
  self.server_txt = nil
  base.OnDestroy(self)
end

function LWSeasonFactionSelectionItem:SetEmpty(campId)
  self.data = nil
  self.show_it:SetActive(false)
  self.home_icon:SetActive(false)
  self.server_bg:SetActive(false)
  self.home_icon_empty:SetActive(true)
  self.server_txt:SetLocalText("372138")
  self.server_bg:LoadSprite("Assets/Main/Sprites/UI/UIGovernment/Sprites/ServerBattle/lrb_zhanqvduijue_fuwuqibg01.png")
end

function LWSeasonFactionSelectionItem:SetData(data)
  if data then
    self.data = data
    self.home_icon:SetActive(true)
    self.server_bg:SetActive(true)
    self.home_icon_empty:SetActive(false)
    if data.serverId == LuaEntry.Player:GetSourceServerId() then
      local itemCfg = DataCenter.ItemTemplateManager:GetItemTemplate(data.cfgId or 511001)
      if itemCfg ~= nil then
        self.home_icon:LoadSprite(string.format(LoadPath.ItemPath, itemCfg.icon))
      else
        self.home_icon:LoadSprite("Assets/Main/Sprites/ItemIcons/lrb_zhanqvduijue_tubiao_fuwuqi01.png")
      end
      self.server_txt:SetText("#" .. data.serverId)
      if data.campId == SeasonFactionType.Gendarmerie then
        self.server_bg:LoadSprite("Assets/Main/Sprites/UI/UIGovernment/Sprites/ServerBattle/lrb_zhanqvduijue_fuwuqibg02.png")
      else
        self.server_bg:LoadSprite("Assets/Main/Sprites/UI/UIGovernment/Sprites/ServerBattle/lrb_zhanqvduijue_difang_fuwuqibg.png")
      end
      self.show_it:SetActive(data.showSelect ~= 1 and LuaEntry.Player:IsPresident() and not Setting:GetPrivateBool("EnableShowSnowCampInfoToALL"))
    else
      self.server_bg:LoadSprite("Assets/Main/Sprites/UI/UIGovernment/Sprites/ServerBattle/lrb_zhanqvduijue_fuwuqibg01.png")
      self.home_icon:LoadSprite("Assets/Main/Sprites/ItemIcons/lrb_zhanqvduijue_tubiao_fuwuqi01.png")
      if data.serverId == 0 then
        self.server_txt:SetText("???")
      else
        self.server_txt:SetText("#" .. data.serverId)
      end
      self.show_it:SetActive(false)
    end
  else
    self:SetEmpty()
  end
end

return LWSeasonFactionSelectionItem
