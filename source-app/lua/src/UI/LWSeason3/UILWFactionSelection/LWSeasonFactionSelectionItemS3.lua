local base = UIBaseContainer
local LWSeasonFactionSelectionItemS3 = BaseClass("LWSeasonFactionSelectionItemS3", UIBaseContainer)
local Localization = CS.GameEntry.Localization

function LWSeasonFactionSelectionItemS3:OnCreate()
  base.OnCreate(self)
  self.show_it = self:AddComponent(UIButton, "showIt")
  self.home_icon_empty = self:AddComponent(UIButton, "homeIconEmpty")
  self.home_icon = self:AddComponent(UIButton, "homeIcon")
  self.server_bg = self:AddComponent(UIButton, "ServerBg")
  self.server_txt = self:AddComponent(UIText, "ServerBg/ServerTxt")
  self.king_mark = self:TryAddComponent(UIImage, "kingMark")
  self.home_icon:SetActive(false)
  self.server_bg:SetActive(false)
  self.home_icon_empty:SetActive(true)
  if self.king_mark then
    self.king_mark:SetActive(false)
  end
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

function LWSeasonFactionSelectionItemS3:OnDestroy()
  self.show_it = nil
  self.home_icon_empty = nil
  self.home_icon = nil
  self.server_txt = nil
  self.king_mark = nil
  base.OnDestroy(self)
end

function LWSeasonFactionSelectionItemS3:SetEmpty(campId)
  self.data = nil
  if self.king_mark then
    self.king_mark:SetActive(false)
  end
  self.show_it:SetActive(false)
  self.home_icon:SetActive(false)
  self.server_bg:SetActive(false)
  self.home_icon_empty:SetActive(true)
  self.server_txt:SetLocalText("372138")
  self.server_bg:LoadSprite("Assets/Main/Sprites/UI/UIGovernment/Sprites/ServerBattle/lrb_zhanqvduijue_fuwuqibg01.png")
end

function LWSeasonFactionSelectionItemS3:SetData(data, skipEmpty)
  local seasonConfig = DataCenter.SeasonDataManager:GetServerCurrentSeasonConfig()
  if data then
    self.data = data
    if self.king_mark then
      if seasonConfig and seasonConfig.camp_sever then
        local king1, king2 = string.split_ii(seasonConfig.camp_sever, "|")
        if data.serverId == king1 or data.serverId == king2 then
          if data.campId == SeasonFactionType.Rebels then
            self.king_mark:SetActive(true)
            self.king_mark:LoadSprite("Assets/Main/SeasonRes/Shared/Sprites/UI/FactionSelection/zxl_s3_fuwuqi_hong.png")
          elseif data.campId == SeasonFactionType.Gendarmerie then
            self.king_mark:SetActive(true)
            self.king_mark:LoadSprite("Assets/Main/SeasonRes/Shared/Sprites/UI/FactionSelection/zxl_s3_fuwuqi_lan.png")
          else
            self.king_mark:SetActive(false)
          end
        else
          self.king_mark:SetActive(false)
        end
      else
        self.king_mark:SetActive(false)
      end
    end
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
      elseif data.campId ~= nil then
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
  elseif skipEmpty then
    self.show_it:SetActive(false)
    self.home_icon:SetActive(true)
    self.server_bg:SetActive(true)
    self.home_icon_empty:SetActive(false)
    self.server_txt:SetText("???")
    if self.king_mark then
      self.king_mark:SetActive(false)
    end
  else
    self:SetEmpty()
  end
end

return LWSeasonFactionSelectionItemS3
