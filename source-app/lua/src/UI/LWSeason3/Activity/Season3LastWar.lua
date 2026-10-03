local base = require("UI.UIActivityCenterTable.Component.ActivityContentBase")
local Season3LastWar = BaseClass("Season3LastWar", base)
local Season3LastWarItem = require("UI.LWSeason3.Activity.Season3LastWarItem")
local Localization = CS.GameEntry.Localization
local intro_btn_path = "IntroBtn"
local content_path = "Content"
local top_path = "Top"
local title_path = "Top/title"
local desc_path = "Top/desc"
local time_text_path = "Top/TimeContent/TimeText"
local time_content_path = "Top/TimeContent"
local item1_path = "Content/Item1"
local item2_path = "Content/Item2"
local item3_path = "Content/Item3"
local item4_path = "Content/Item4"
local image_lock_path = "bg/ImageMask/ImageLock"
local image_bg_path = "bg/ImageBg"

function Season3LastWar:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
end

function Season3LastWar:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function Season3LastWar:ComponentDefine()
  self.animRoot = self:AddComponent(UIAnimator, "")
  self.image_bg = self:AddComponent(UIRawImage, image_bg_path)
  self.image_lock = self:AddComponent(UIButton, image_lock_path)
  self.image_canvas = self:AddComponent(UICanvasGroup, image_lock_path)
  self.intro_btn = self:AddComponent(UIButton, intro_btn_path)
  self.content = self:AddComponent(UICanvasGroup, content_path)
  self.top = self:AddComponent(UIBaseContainer, top_path)
  self.title = self:AddComponent(UITextMeshProUGUIEx, title_path)
  self.desc = self:AddComponent(UITextMeshProUGUIEx, desc_path)
  self.time_text = self:AddComponent(UITextMeshProUGUIEx, time_text_path)
  self.time_content = self:AddComponent(UIBaseContainer, time_content_path)
  self.item1 = self:AddComponent(Season3LastWarItem, item1_path)
  self.item2 = self:AddComponent(Season3LastWarItem, item2_path)
  self.item3 = self:AddComponent(Season3LastWarItem, item3_path)
  self.item4 = self:AddComponent(Season3LastWarItem, item4_path)
  self.intro_btn:SetOnClick(function()
    local param = {}
    param.activityId = self.activityId
    param.activityRulesStr = Localization:GetString("season_activity_1000086_tips06")
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIActivityDetailPopup, {anim = true}, param)
  end)
  self.image_lock:SetOnClick(function()
    Setting:SetPrivateBool("Season3.EveWar.Open", true)
    local sequence = DOTween.Sequence()
    self.content:SetActive(true)
    self.content:SetAlpha(1)
    sequence:Append(self.content:FadeIn(0.24))
    sequence:Join(self.image_canvas:FadeOut(0.24))
    sequence:AppendInterval(0.3)
    sequence:AppendCallback(function()
      self.content:SetActive(true)
      self.content:SetAlpha(1)
      if self.image_lock then
        self.image_lock:SetActive(false)
      end
    end)
    self.animRoot:Play("Season3LastWarChange")
  end)
  local ScreenSize = CS.UnityEngine.Screen
  local offsetMax = self.image_bg.transform.offsetMax
  if ScreenSize and ScreenSize.height < 1800 then
    local delta = 1800 - ScreenSize.height
    self.image_bg.transform.offsetMax = Vector2.New(offsetMax.x, delta * 0.36)
  else
    self.image_bg.transform.offsetMax = Vector2.New(offsetMax.x, 0)
  end
end

function Season3LastWar:ComponentDestroy()
  self.animRoot = nil
  self.intro_btn = nil
  self.image_bg = nil
  self.image_lock = nil
  self.content = nil
  self.top = nil
  self.title = nil
  self.desc = nil
  self.time_text = nil
  self.time_content = nil
  self.item1 = nil
  self.item2 = nil
  self.item3 = nil
  self.item4 = nil
end

function Season3LastWar:SetData(activityId)
  base.SetData(self, activityId)
  local data = DataCenter.ActivityListDataManager:GetActivityDataById(self.activityId)
  if data == nil then
    self.title:SetText("")
    self.desc:SetText("")
    self.time_content:SetActive(false)
    self.content:SetActive(false)
    return
  end
  self.activityData = data
  self.title:SetLocalText(data.name)
  self.desc:SetLocalText(data.desc_info)
  self.time_content:SetActive(true)
  self.content:SetActive(true)
  self.item2:SetData(self, data.para_2 or 704001, "Assets/Main/SeasonRes/S3/Sprites/UI/LWCommon/mjc_S3_juezhanqianxi_icon_1.png")
  self.item3:SetData(self, data.para_3 or 704002, "Assets/Main/Sprites/UI/UIRadarCenter/mjc_S3_leidaduobao_leida_icon.png")
  self.item1:SetData(self, data.para_4 or 610010001, "Assets/Main/SeasonRes/S3/Sprites/UI/LWCommon/mjc_S3_juezhanqianxi_icon_3.png")
  self.item4:SetData(self, "Jump", "Assets/Main/SeasonRes/S3/Sprites/UI/LWCommon/mjc_S3_juezhanqianxi_icon_4.png")
  self:RefreshView()
  self:Update1000MS()
end

function Season3LastWar:RefreshView()
  if self.activityData == nil then
    self.image_lock:SetActive(true)
    self.content:SetActive(false)
    self.content:SetAlpha(0)
    return
  end
  local hasOpened = Setting:GetPrivateBool("Season3.EveWar.Open", false)
  if hasOpened then
    self.image_lock:SetActive(false)
    self.content:SetActive(true)
    self.content:SetAlpha(1)
    self.animRoot:Play("Season3LastWarChange")
  else
    self.image_lock:SetActive(true)
    self.image_canvas:SetAlpha(1)
    self.content:SetActive(false)
    self.content:SetAlpha(0)
    self.animRoot:Play("Season3LastWarIn")
  end
end

function Season3LastWar:OpenAll()
end

function Season3LastWar:Update1000MS()
  if self.activityData ~= nil then
    local curTime = UITimeManager:GetInstance():GetServerTime()
    local remainTime = self.activityData.endTime - curTime
    if 0 < remainTime then
      self.time_text:SetText(UITimeManager:GetInstance():MilliSecondToFmtString(remainTime))
    else
      self.time_text:SetText("00:00:00")
      self.time_content:SetActive(false)
    end
  end
end

return Season3LastWar
