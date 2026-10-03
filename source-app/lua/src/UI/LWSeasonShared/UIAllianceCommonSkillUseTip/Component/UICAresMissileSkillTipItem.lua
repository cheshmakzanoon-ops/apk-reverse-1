local base = UIBaseContainer
local UICAresMissileSkillTipItem = BaseClass("UICAresMissileSkillTipItem", base)
local txt_title_path = "title_real/txt_title"
local txt_pos_path = "title_real/city/go_pos/Pos/txt_pos"
local go_pos_path = "title_real/city/go_pos"
local go_city_path = "title_real/city/go_city"
local txt_name_path = "title_real/city/go_city/Pos/txt_name"
local img_icon_path = "title_real/city/go_city/img_icon"
local txt_city_pos_path = "title_real/city/go_city/Pos/txt_city_pos"
local img_desc_path = "desc"

function UICAresMissileSkillTipItem:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
end

function UICAresMissileSkillTipItem:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UICAresMissileSkillTipItem:ComponentDefine()
  self.txt_title = self:AddComponent(UIText, txt_title_path)
  self.txt_pos = self:AddComponent(UIText, txt_pos_path)
  self.go_pos = self:AddComponent(UIBaseContainer, go_pos_path)
  self.go_city = self:AddComponent(UIBaseContainer, go_city_path)
  self.txt_name = self:AddComponent(UIText, txt_name_path)
  self.img_icon = self:AddComponent(UIImage, img_icon_path)
  self.txt_city_pos = self:AddComponent(UIText, txt_city_pos_path)
  self.img_desc = self:AddComponent(UIImage, img_desc_path)
end

function UICAresMissileSkillTipItem:ComponentDestroy()
  self.txt_title = nil
  self.txt_pos = nil
  self.go_pos = nil
  self.go_city = nil
  self.txt_name = nil
  self.img_icon = nil
  self.txt_city_pos = nil
  self.img_desc = nil
end

function UICAresMissileSkillTipItem:ReInit(data, txtDesc)
  self.data = data
  local skillName = CS.GameEntry.Localization:GetString(self.data.scoreConfig.skill_name)
  txtDesc:SetLocalText("season_s6_government_skill_desc23", skillName)
  self.txt_title:SetLocalText("season_s6_government_skill_desc24")
  local pointId = self.data.logic.pointId
  local pos = SceneUtils.IndexToTilePos(pointId, ForceChangeScene.World)
  local serverId = LuaEntry.Player:GetSelfServerId()
  self.txt_pos:SetText(string.format("#%s X:%s Y:%s", serverId, pos.x, pos.y))
  self.txt_city_pos:SetText(string.format("#%s X:%s Y:%s", serverId, pos.x, pos.y))
  local isCityOrPlayerBuild = false
  local pointInfo = CS.SceneManager.World:GetPointInfo(pointId)
  if not IsNull(pointInfo) then
    if pointInfo.PointType == WorldPointType.WORLD_ALLIANCE_CITY then
      isCityOrPlayerBuild = true
      local meta = DataCenter.AllianceCityTemplateManager:GetTemplate(pointInfo.CityId, LuaEntry.Player:GetSelfServerId())
      self.txt_name:SetText(meta:GetName())
      self.img_icon:LoadSpriteAuto(meta:GetIconPath())
    elseif pointInfo.PointType == WorldPointType.WORLD_CITY_STRONGHOLD then
      isCityOrPlayerBuild = true
      local meta = DataCenter.AllianceCityTemplateManager:GetTemplate(pointInfo.CityId, LuaEntry.Player:GetSelfServerId())
      self.txt_name:SetText(meta:GetName())
      self.img_icon:LoadSpriteAuto(meta:GetIconPath())
    end
  end
  self.go_pos:SetActive(not isCityOrPlayerBuild)
  self.go_city:SetActive(isCityOrPlayerBuild)
  local desc_list = string.split(data.config.effect_desc, "|")
  local param_list = string.split(data.config.effect_desc_num, "|")
  for index = 1, 4 do
    local name = "item_" .. index
    local theItem = self:TryAddComponent(UITextMeshProUGUIEx, "desc/right/" .. name)
    if theItem then
      if index <= #desc_list then
        local desc = desc_list[index]
        local param = param_list[index]
        if string.IsNullOrEmpty(param) then
          theItem:SetLocalText(desc)
        else
          theItem:SetLocalText(desc, table.unpack(string.split(param, ";")))
        end
      end
      theItem:SetActive(index <= #desc_list)
    end
  end
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.img_desc.transform)
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.transform)
end

return UICAresMissileSkillTipItem
