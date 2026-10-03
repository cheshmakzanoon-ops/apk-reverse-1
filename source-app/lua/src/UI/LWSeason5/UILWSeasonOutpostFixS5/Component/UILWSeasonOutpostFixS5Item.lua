local UILWSeasonOutpostFixS5Item = BaseClass("UILWSeasonOutpostFixS5Item", UIBaseContainer)
local base = UIBaseContainer
local bg_path = "bg"
local alliance_flag_path = "allianceFlag"
local desc_path = "Desc"
local icon_path = "icon"
local num_txt_path = "icon/numTxt"
local point_text_path = "pointText"
local name_path = "Name"
local __RankIcon = {
  "Assets/Main/Sprites/UI/LWCommon/Sprite/FX_wordboss_paihangbang_icon_huizhang01.png",
  "Assets/Main/Sprites/UI/LWCommon/Sprite/FX_wordboss_paihangbang_icon_huizhang02.png",
  "Assets/Main/Sprites/UI/LWCommon/Sprite/FX_wordboss_paihangbang_icon_huizhang03.png"
}

function UILWSeasonOutpostFixS5Item:OnCreate()
  base.OnCreate(self)
  self.bg = self:AddComponent(UIButton, bg_path)
  self.alliance_flag = self:AddComponent(UIImage, alliance_flag_path)
  self.desc = self:AddComponent(UITextMeshProUGUIEx, desc_path)
  self.icon = self:AddComponent(UIImage, icon_path)
  self.num_txt = self:AddComponent(UITextMeshProUGUIEx, num_txt_path)
  self.point_text = self:AddComponent(UITextMeshProUGUIEx, point_text_path)
  self.name = self:AddComponent(UITextMeshProUGUIEx, name_path)
  self.bg:SetOnClick(function()
    if self.data then
      local serverId = self.data.serverId
      local allianceId = self.data.allianceId
      local allianceName = self.data.name
      if serverId and allianceId then
        UIUtil.TryShowAllianceInfo(serverId, allianceId, allianceName)
      end
    end
  end)
end

function UILWSeasonOutpostFixS5Item:OnDestroy()
  self.bg = nil
  self.alliance_flag = nil
  self.desc = nil
  self.icon = nil
  self.num_txt = nil
  self.point_text = nil
  self.name = nil
  base.OnDestroy(self)
end

function UILWSeasonOutpostFixS5Item:ReInit(index, data, dynamic)
  if data ~= nil and data.icon ~= nil then
    self:SetActive(true)
    self.data = data
    self.alliance_flag:LoadSprite(string.format(AL_FLAG_SPRITE_PATH, tostring(data.icon)))
    self.name:SetText(data.name)
    self.desc:SetText(UIUtil.FormatServerAllianceName(data.serverId, data.abbr, nil))
    self.point_text:SetText("+" .. data.score)
    if dynamic then
      local power_color = "#2A2830"
      local first_color = "#2A2830"
      local second_color = "#2A2830"
      local bgPath = "Assets/Main/Sprites/UI/UIRank/ljq_tongyong_paihangbang_4.png"
      if data.uid == LuaEntry.Player.uid then
        power_color = "#2A2830"
        first_color = "#2A2830"
        second_color = "#2A2830"
        bgPath = "Assets/Main/Sprites/UI/UIRank/ljq_tongyong_paihangbang_5.png"
      elseif data.rank == 1 then
        power_color = "#AB6130"
        first_color = "#AB6130"
        second_color = "#AB6130"
        bgPath = "Assets/Main/Sprites/UI/UIRank/ljq_tongyong_paihangbang_1.png"
      elseif data.rank == 2 then
        power_color = "#3D4D9B"
        first_color = "#3D4D9B"
        second_color = "#3D4D9B"
        bgPath = "Assets/Main/Sprites/UI/UIRank/ljq_tongyong_paihangbang_2.png"
      elseif data.rank == 3 then
        power_color = "#90624D"
        first_color = "#90624D"
        second_color = "#90624D"
        bgPath = "Assets/Main/Sprites/UI/UIRank/ljq_tongyong_paihangbang_3.png"
      end
      self.bg:LoadSprite(bgPath)
      if data.rank == 1 or data.rank == 2 or data.rank == 3 then
        self.icon:SetEnable(true)
        self.icon:LoadSprite(__RankIcon[data.rank])
      else
        self.icon:SetEnable(false)
      end
      self.num_txt:SetText(tostring(data.rank))
      self.name:SetColorHex(first_color)
      self.desc:SetColorHex(second_color)
      self.point_text:SetColorHex(power_color)
    end
  else
    self:SetActive(false)
  end
end

return UILWSeasonOutpostFixS5Item
