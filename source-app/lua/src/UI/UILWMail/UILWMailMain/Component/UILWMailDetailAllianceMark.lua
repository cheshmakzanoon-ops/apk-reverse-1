local UILWMailDetailAllianceMark = BaseClass("UILWMailDetailAllianceMark", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local rapidjson = require("rapidjson")

function UILWMailDetailAllianceMark:OnCreate()
  base.OnCreate(self)
  self.detail_title = self:AddComponent(UIText, "System/DetailTitle")
  self.detail_time = self:AddComponent(UIText, "System/DetailTimeBg/DetailTime")
  self.icon = self:AddComponent(UIImage, "System/Content/IconBg/Icon")
  self.tip1Text = self:AddComponent(UIText, "System/Content/Tip1Text")
  self.goBtn = self:AddComponent(UIButton, "System/Content/GoBtn")
  self.goBtnText = self:AddComponent(UIText, "System/Content/GoBtn/BtnText")
  self.goBtnText:SetLocalText("450004")
  self.goBtn:SetOnClick(function()
    if self.jumpLink then
      GoToUtil.TryJumpToWorld(self.jumpLink)
    end
  end)
end

function UILWMailDetailAllianceMark:OnDestroy()
  self.detail_title = nil
  self.detail_time = nil
  self.icon = nil
  self.tip1Text = nil
  self.goBtn = nil
  self.goBtnText = nil
  base.OnDestroy(self)
end

function UILWMailDetailAllianceMark:RefreshContent()
  self.mailUid = self.view.ctrl:GetCurrentMail()
  self.mailData = self.view.ctrl:GetCurrentMailData()
  self.detail_title:SetText(MailShowHelper.GetMainTitle(self.mailData))
  local _strTime = MailShowHelper.GetAbstractCreateTime(self.mailData)
  self.detail_time:SetText(_strTime)
  local contentData = rapidjson.decode(self.mailData.contents)
  local data = contentData.obj
  local markType = data.markType
  local markIcon = DataCenter.WorldFavoDataManager:GetBookMapMarkIconName(markType)
  self.icon:LoadSprite(string.format(LoadPath.AllianceMark, markIcon))
  local dialog_id = "390815"
  local markInfo = {}
  local pointId = SceneUtils.BigIndexToStandardIndex(data.pointId, ForceChangeScene.World)
  markInfo.server = data.server
  markInfo.pointId = pointId
  markInfo.markName = data.markName
  markInfo.markType = data.markType
  markInfo.name = data.name
  markInfo.rank = data.rank
  local param1 = markInfo.rank == 5 and Localization:GetString("390006") .. ": " or ""
  local param2 = markInfo.name
  local param3 = DataCenter.WorldFavoDataManager:GetBookMarkName(markInfo.markType, true)
  local param4 = ""
  if AllianceRallyType[markInfo.markType] then
    local vecPos = SceneUtils.IndexToTilePos(pointId, ForceChangeScene.World)
    param4 = ": " .. Localization:GetString(markInfo.markName) .. "\n" .. UIUtil.FormatServerPosition(data.server, vecPos.x, vecPos.y)
  elseif param3 ~= markInfo.markName then
    local tempMarkName = string.split(markInfo.markName, ";")
    if #tempMarkName == 1 then
      param4 = ": " .. markInfo.markName
    else
      param4 = ": " .. Localization:GetString(tempMarkName[2])
    end
  end
  local link = {
    action = "Jump",
    pointId = pointId,
    server = data.server,
    worldId = data.worldId
  }
  self.jumpLink = link
  self.tip1Text:SetLocalText(dialog_id, param1, param2, param3, param4)
end

return UILWMailDetailAllianceMark
