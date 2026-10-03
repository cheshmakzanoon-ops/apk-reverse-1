local UILWMailDetailLandmine = BaseClass("UILWMailDetailLandmine", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local MailKillItem = require("UI.UILWMail.UILWMailMain.Component.MailKillItem")

function UILWMailDetailLandmine:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UILWMailDetailLandmine:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UILWMailDetailLandmine:DataDefine()
  self.mailUid = {}
  self.mailData = {}
end

function UILWMailDetailLandmine:DataDestroy()
  self.mailUid = nil
  self.mailData = nil
end

function UILWMailDetailLandmine:OnEnable()
  base.OnEnable(self)
end

function UILWMailDetailLandmine:OnDisable()
  base.OnDisable(self)
end

function UILWMailDetailLandmine:OnAddListener()
  base.OnAddListener(self)
end

function UILWMailDetailLandmine:OnRemoveListener()
  base.OnRemoveListener(self)
end

function UILWMailDetailLandmine:ComponentDefine()
  self.coordinateText = self:AddComponent(UIText, "top/CoordinateText")
  self.coordinateBtn = self:AddComponent(UIButton, "top/CoordinateText")
  self.coordinateBtn:SetOnClick(function()
    self:OnJumpClick2()
  end)
  self.coordinateText2 = self:AddComponent(UIText, "top/CoordinateText2")
  self.coordinateBtn2 = self:AddComponent(UIButton, "top/CoordinateText2")
  self.coordinateBtn2:SetOnClick(function()
    self:OnJumpClick2()
  end)
  self.timeText = self:AddComponent(UIText, "top/TimeText")
  self.head1 = self:AddComponent(UICommonHead, "top/head1")
  self.head1:SetEnableClickShowInfo(true, true)
  self.head2 = self:AddComponent(UICommonHead, "top/head2")
  self.head2:SetEnableClickShowInfo(true, true)
  self.playerName1 = self:AddComponent(UIText, "top/PlayerName1")
  self.playerName2 = self:AddComponent(UIText, "top/PlayerName2")
  self.hunterText = self:AddComponent(UIText, "top/ScoutText2")
  self.hunterText:SetLocalText("season_mastery_s2_UI_3")
  self.preyText = self:AddComponent(UIText, "top/BeScoutText2")
  self.preyText:SetLocalText("season_mastery_s2_UI_4")
  self.mineIcon = self:AddComponent(UIImage, "top/mineIcon")
  self.tip = self:AddComponent(UIText, "top/Tip2")
  self.tip:SetLocalText("season_mastery_s2_UI_2")
  self.desc = self:AddComponent(UIText, "top/desc")
  self.bottom = self:AddComponent(UIBaseComponent, "bottom")
  self.killTitle = self:AddComponent(UIText, "bottom/killTitle")
  self.killTitle:SetLocalText("season_mastery_s2_UI_23")
  self.killContent = self:AddComponent(UIBaseContainer, "bottom/ScrollView/Viewport/kill")
end

function UILWMailDetailLandmine:ComponentDestroy()
end

function UILWMailDetailLandmine:RefreshContent()
  self.mailUid = self.view.ctrl:GetCurrentMail()
  self.mailData = self.view.ctrl:GetCurrentMailData()
  local data = self.mailData:GetMailExt()
  local isPassive = data:IsPassive()
  local _strTime = MailShowHelper.GetAbstractCreateTime(self.mailData)
  self.timeText:SetText(_strTime)
  self.location2 = SceneUtils.IndexToTilePos(data.pointId, ForceChangeScene.World)
  self.serverId2 = data.hunter.serverId
  self.coordinateText:SetText(self:FormatCoordinateText(self.location2, self.serverId2))
  self.coordinateText2:SetText(self:FormatCoordinateText(self.location2, self.serverId2))
  local hunter = data.hunter
  self.head1:SetHeadAndFrame(hunter.uid, hunter.headPic, hunter.headPicVer, nil, hunter.headSkinId, hunter.headSkinET)
  self.playerName1:SetText(UIUtil.FormatServerAllianceName(hunter.serverId, hunter.abbr, hunter.name))
  local prey = data.prey
  self.head2:SetHeadAndFrame(prey.uid, prey.headPic, prey.headPicVer, nil, prey.headSkinId, prey.headSkinET)
  self.playerName2:SetText(UIUtil.FormatServerAllianceName(prey.serverId, prey.abbr, prey.name))
  local meta = DataCenter.WorldTriggerTemplateManager:GetMeta(data.cfgId)
  self.mineIcon:LoadSprite(meta.icon)
  self.tip:SetColor(isPassive and Color(0.96, 0.24, 0.24, 1) or Color(0.03, 0.6, 0.29, 1))
  local landmineName = meta:GetName()
  local descString
  if meta.type == 1 then
    if isPassive then
      if data:IsFrozen() then
        descString = Localization:GetString("season_mastery_s2_UI_11", landmineName, meta.desc_more_para)
      else
        descString = Localization:GetString("season_mastery_s2_UI_10", landmineName, meta.desc_more_para)
      end
    elseif data:IsFrozen() then
      descString = Localization:GetString("season_mastery_s2_UI_9", landmineName, meta.desc_more_para)
    else
      descString = Localization:GetString("season_mastery_s2_UI_8", landmineName, meta.desc_more_para)
    end
  elseif meta.type == 2 then
    if isPassive then
      descString = Localization:GetString("season_mastery_s2_UI_13", landmineName, data:GetKillCount())
    else
      descString = Localization:GetString("season_mastery_s2_UI_12", landmineName, data:GetKillCount())
    end
  elseif meta.type == 3 then
    if isPassive then
      if data:IsFire() then
        if data:IsFly() then
          descString = Localization:GetString("season_mastery_s2_UI_21", landmineName, meta.desc_more_para)
        else
          descString = Localization:GetString("season_mastery_s2_UI_18", landmineName, meta.desc_more_para)
        end
      elseif data:IsFly() then
        descString = Localization:GetString("season_mastery_s2_UI_20", landmineName, meta.desc_more_para)
      else
        descString = Localization:GetString("season_mastery_s2_UI_19", landmineName, meta.desc_more_para)
      end
    elseif data:IsFire() then
      if data:IsFly() then
        descString = Localization:GetString("season_mastery_s2_UI_17", landmineName, meta.desc_more_para)
      else
        descString = Localization:GetString("season_mastery_s2_UI_15", landmineName, meta.desc_more_para)
      end
    elseif data:IsFly() then
      descString = Localization:GetString("season_mastery_s2_UI_16", landmineName, meta.desc_more_para)
    else
      descString = Localization:GetString("season_mastery_s2_UI_14", landmineName, meta.desc_more_para)
    end
  elseif meta.type == 4 then
    if isPassive then
      descString = Localization:GetString("season_mastery_s3_landmine_1_report_2", landmineName)
    else
      descString = Localization:GetString("season_mastery_s3_landmine_1_report_1", landmineName)
    end
  elseif meta.type == 6 then
    if isPassive then
      descString = Localization:GetString("season_mastery_s4_tips_6", landmineName)
    else
      descString = Localization:GetString("season_mastery_s4_tips_7", landmineName)
    end
  end
  self.desc:SetText(descString)
  local killData = data:GetKillData()
  if table.IsEmpty(killData) then
    self.bottom:SetActive(false)
  else
    self.bottom:SetActive(true)
    self:RefreshKillCells(killData)
  end
end

function UILWMailDetailLandmine:RefreshKillCells(killData)
  self.killContent:RemoveComponents(MailKillItem)
  if self.reqs then
    for _, v in pairs(self.reqs) do
      v:Destroy()
    end
  end
  self.reqs = {}
  for k, v in pairs(killData) do
    self.reqs[k] = self:GameObjectInstantiateAsync(UIAssets.KillItem, function(req)
      if IsNull(req.gameObject) then
        return
      end
      local item = req.gameObject
      item.name = "KillItem" .. k
      item.transform:SetParent(self.killContent.transform)
      item.transform:Set_localScale(1, 1, 1)
      local obj = self.killContent:AddComponent(MailKillItem, item.name)
      obj:SetData(tonumber(k), v)
    end)
  end
end

function UILWMailDetailLandmine:OnJumpClick2()
  if self.location2 ~= nil then
    self.view.ctrl:OnJumpClick(self.location2.x, self.location2.y, self.serverId2)
  end
end

function UILWMailDetailLandmine:FormatCoordinateText(pos, serverId)
  if serverId and 0 < serverId then
    return string.format("#%s X:%s,Y:%s", serverId, pos.x, pos.y)
  else
    return string.format("X:%s,Y:%s", pos.x, pos.y)
  end
end

return UILWMailDetailLandmine
