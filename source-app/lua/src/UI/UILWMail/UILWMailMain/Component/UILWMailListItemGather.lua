local UILWMailListItemGather = BaseClass("UILWMailListItemGather", UIBaseContainer)
local base = UIBaseContainer
local rapidjson = require("rapidjson")
local UIGray = CS.UIGray
local Localization = CS.GameEntry.Localization
local read_img_path = "BgRead"
local icon_img_path = "Icon"
local name_txt_path = "TitleTxt"
local des_txt_path = "SubTitleTxt"
local time_txt_path = "TimeText"
local gift_img_path = "Gift"
local red_point_path = "RedPoint"
local btn_path = "ClickButton"

function UILWMailListItemGather:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UILWMailListItemGather:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UILWMailListItemGather:ComponentDefine()
  self.readBg = self:AddComponent(UIBaseContainer, read_img_path)
  self.icon = self:AddComponent(UIImage, icon_img_path)
  self.nameText = self:AddComponent(UIText, name_txt_path)
  self.desText = self:AddComponent(UIText, des_txt_path)
  self.timeText = self:AddComponent(UIText, time_txt_path)
  self.redPoint = self:AddComponent(UIBaseContainer, red_point_path)
  self.clickBtn = self:AddComponent(UIButton, btn_path)
  self.clickBtn:SetOnClick(function()
    self:OnMailClick()
  end)
  self.resIcon = self:AddComponent(UIImage, "Rewards/ResIcon")
  self.resNum = self:AddComponent(UIText, "Rewards/ResNum")
  self.resIcon2 = self:AddComponent(UIImage, "Rewards/ResIcon2")
  self.resNum2 = self:AddComponent(UIText, "Rewards/ResNum2")
end

function UILWMailListItemGather:ComponentDestroy()
  self.readBg = nil
  self.icon = nil
  self.nameText = nil
  self.desText = nil
  self.timeText = nil
  self.giftIcon = nil
  self.redPoint = nil
  self.clickBtn = nil
  self.resIcon = nil
  self.resNum = nil
  self.resIcon2 = nil
  self.resNum2 = nil
end

function UILWMailListItemGather:DataDefine()
  self.mailDatas = {}
  self.mailUid = nil
end

function UILWMailListItemGather:DataDestroy()
  self.mailDatas = nil
  self.mailUid = nil
end

function UILWMailListItemGather:OnEnable()
  base.OnEnable(self)
end

function UILWMailListItemGather:OnDisable()
  base.OnDisable(self)
end

function UILWMailListItemGather:OnAddListener()
  base.OnAddListener(self)
end

function UILWMailListItemGather:OnRemoveListener()
  base.OnRemoveListener(self)
end

function UILWMailListItemGather:SetData(params)
  self.mailDatas = params.mail_data
  if not self.mailDatas then
    return
  end
  self.mailUid = self.mailDatas.uid
  if not self.mailUid then
    return
  end
  self.reportData = rapidjson.decode(params.mail_data.contents)
  self.reportData = self.reportData.obj.collectReport[1]
  local location = SceneUtils.IndexToTilePos(tonumber(self.reportData.pointId), ForceChangeScene.World)
  location = string.format("[%s,%s]", location.x, location.y)
  local mainTitle = ""
  if self.reportData.allianceBuildId and self.reportData.allianceBuildId > 0 then
    local config = LocalController:instance():getLine(TableName.AllianceMine, self.reportData.allianceBuildId)
    mainTitle = Localization:GetString("104290", config.city_level, Localization:GetString(config.name))
  elseif self.reportData.gatherResourceId and 0 < self.reportData.gatherResourceId then
    if self.mailDatas.type == MailType.LW_METEORITE_COLLECT then
      local config = DataCenter.ActMeteoriteBattleManager:GetEntityConfigById(self.reportData.gatherResourceId)
      mainTitle = Localization:GetString(config ~= nil and config.name or "")
    else
      mainTitle = GetTableData(TableName.GatherResource, self.reportData.gatherResourceId, "name")
      mainTitle = Localization:GetString(mainTitle)
    end
  end
  self.nameText:SetText(mainTitle .. " " .. location)
  local createTime = MailShowHelper.GetRelativeCreateTime(self.mailDatas)
  self.timeText:SetText(createTime)
  if self.mailDatas.type == MailType.LW_METEORITE_COLLECT then
    local num = self.reportData.resourceValue or 0
    self.resNum2:SetActive(0 < num)
    self.resIcon2:SetActive(0 < num)
    if 0 < num then
      self.resNum2:SetText("\195\151" .. num)
      local iconName = GetTableData(TableName.Aps_Resource_Item, tonumber(self.reportData.resourceParam), "pic")
      local icon_full_path = GetTableData(TableName.Aps_Resource_Item, tonumber(self.reportData.resourceParam), "pic_new")
      if string.IsNullOrEmpty(icon_full_path) then
        self.resIcon2:LoadSprite(string.format(LoadPath.ItemPath, iconName))
      else
        self.resIcon2:LoadSprite(icon_full_path)
      end
    end
    self.resNum:SetText("\195\151" .. (self.reportData.score or 0))
    self.resIcon:LoadSprite(string.format(LoadPath.ItemPath, "lrb_zhouliuhuodong_jifen.png"))
  else
    self.resNum:SetText("\195\151" .. self.reportData.resourceValue)
    local spriteString = DataCenter.ResourceManager:GetResourceIconByType(self.reportData.resourceType)
    self.resIcon:LoadSprite(spriteString)
    self.resNum2:SetActive(false)
    self.resIcon2:SetActive(false)
  end
end

function UILWMailListItemGather:RefreshRedPoint()
  local un_read = self.mailDatas.status ~= 1
  local has_reward = self.mailDatas.rewardStatus == 0
  local icon_path = "Assets/Main/Sprites/UI/UILWMail/"
  self.icon:LoadSprite(icon_path .. (un_read and "lt_youjian_xin_guan.png" or "lt_youjian_xin_kai.png"))
  self.redPoint:SetActive(un_read)
end

function UILWMailListItemGather:OnMailClick()
  self.view.ctrl:SetCurrentView(3)
  self.view.ctrl:SetCurrentMail(self.mailUid)
  self.view.ctrl:ReadCurrentMail()
  self.view:ContentTrans()
end

return UILWMailListItemGather
