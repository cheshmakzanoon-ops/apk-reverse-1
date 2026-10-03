local UILWMailListItem = BaseClass("UILWMailListItem", UIBaseContainer)
local base = UIBaseContainer
local rapidjson = require("rapidjson")
local Localization = CS.GameEntry.Localization
local icon_img_path = "Icon"
local name_txt_path = "TitleTxt"
local time_txt_path = "TimeText"
local red_point_path = "RedPoint"
local head_icon_path = "Head/HeadIcon"
local desc_text_path = "DescText"

function UILWMailListItem:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UILWMailListItem:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UILWMailListItem:ComponentDefine()
  self.icon = self:AddComponent(UIImage, icon_img_path)
  self.nameText = self:AddComponent(UIText, name_txt_path)
  self.timeText = self:AddComponent(UIText, time_txt_path)
  self.redPoint = self:AddComponent(UIBaseContainer, red_point_path)
  self.head_icon = self:AddComponent(UIImage, head_icon_path)
  self.desc_text = self:AddComponent(UIText, desc_text_path)
end

function UILWMailListItem:ComponentDestroy()
  self.icon = nil
  self.nameText = nil
  self.timeText = nil
  self.redPoint = nil
  self.head_icon = nil
  self.desc_text = nil
end

function UILWMailListItem:DataDefine()
  self.mailDatas = {}
  self.mailUid = nil
end

function UILWMailListItem:DataDestroy()
  self.mailDatas = nil
  self.mailUid = nil
end

function UILWMailListItem:OnEnable()
  base.OnEnable(self)
end

function UILWMailListItem:OnDisable()
  base.OnDisable(self)
end

function UILWMailListItem:OnAddListener()
  base.OnAddListener(self)
end

function UILWMailListItem:OnRemoveListener()
  base.OnRemoveListener(self)
end

function UILWMailListItem:SetData(params)
  self.mailDatas = params.mail_data
  if not self.mailDatas then
    return
  end
  self.mailUid = self.mailDatas.uid
  if not self.mailUid then
    return
  end
  local reportData = rapidjson.decode(params.mail_data.contents)
  if reportData then
    local monsterData = reportData.obj
    local param
    if monsterData then
      local monsterId = monsterData.monsterId
      local pointId = monsterData.pointId
      param = monsterData.damage or ""
      local mainTitle, location = "", ""
      if monsterId and pointId then
        local monsterTemplate = DataCenter.MonsterTemplateManager:GetMonsterTemplate(monsterId)
        if monsterTemplate then
          mainTitle = Localization:GetString(monsterTemplate.name)
          local pos = SceneUtils.IndexToTilePos(pointId, ForceChangeScene.World)
          location = string.format("[%s,%s]", pos.x, pos.y)
          self.head_icon:LoadSpriteAuto(monsterTemplate:GetIcon())
        end
      end
      self.nameText:SetText(mainTitle .. " " .. location)
      local createTime = MailShowHelper.GetRelativeCreateTime(self.mailDatas)
      self.timeText:SetText(createTime)
    end
    if reportData.b and reportData.b.content and reportData.b.content.dialog and reportData.b.content.dialog.id then
      local dialogId = reportData.b.content.dialog.id
      self.desc_text:SetLocalText(dialogId, param)
    end
  end
end

function UILWMailListItem:RefreshRedPoint()
  local un_read = self.mailDatas.status ~= 1
  local icon_path = "Assets/Main/Sprites/UI/UILWMail/"
  self.icon:LoadSprite(icon_path .. (un_read and "lt_youjian_xin_guan.png" or "lt_youjian_xin_kai.png"))
  self.redPoint:SetActive(un_read)
end

return UILWMailListItem
