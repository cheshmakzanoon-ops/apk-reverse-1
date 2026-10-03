local ActCommunityLinkTemplate = BaseClass("ActCommunityLinkTemplate")

local function __init(self)
  self.iconPath = ""
  self.linkUrl = ""
  self.showType = nil
  self.needShowNew = nil
  self.needShowNewStr = nil
  self:AddListener()
end

local function __delete(self)
  self.iconPath = nil
  self.linkUrl = nil
  self.showType = nil
  self.needShowNew = nil
  self.needShowNewStr = nil
  self:RemoveListener()
end

local function AddListener(self)
end

local function RemoveListener(self)
end

local function GetNeedShowNewStr(self)
  if self.needShowNewStr == nil and not string.IsNullOrEmpty(self.linkUrl) then
    self.needShowNewStr = self.linkUrl .. "needShowNew" .. CS.GameEntry.Localization:GetLanguage()
  end
  return self.needShowNewStr
end

local function InitData(self, str)
  local data = string.split(str, ";")
  self.iconPath = string.format(UIAssets.CommunityLinkBtnIcon, data[1])
  self.linkUrl = data[2]
  self.showType = data[3]
  if not string.IsNullOrEmpty(self.showType) and self.showType == "1" then
    local needShowNewStr = self:GetNeedShowNewStr()
    if needShowNewStr then
      self.needShowNew = CommonUtil.PlayerPrefsGetBool(needShowNewStr, true)
    end
  end
end

local function SaveNeedShowNew(self)
  if self.needShowNew then
    local needShowNewStr = self:GetNeedShowNewStr()
    CommonUtil.PlayerPrefsSetBool(needShowNewStr, false)
    self.needShowNew = false
  end
end

ActCommunityLinkTemplate.__init = __init
ActCommunityLinkTemplate.__delete = __delete
ActCommunityLinkTemplate.AddListener = AddListener
ActCommunityLinkTemplate.RemoveListener = RemoveListener
ActCommunityLinkTemplate.InitData = InitData
ActCommunityLinkTemplate.GetNeedShowNewStr = GetNeedShowNewStr
ActCommunityLinkTemplate.SaveNeedShowNew = SaveNeedShowNew
return ActCommunityLinkTemplate
