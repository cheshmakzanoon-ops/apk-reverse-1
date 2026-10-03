local UnlockBtnManager = BaseClass("UnlockBtnManager")

local function __init(self)
end

local function __delete(self)
end

local function IsShowBtn(self, btnType)
  local template = DataCenter.UnlockBtnTemplateManager:GetUnlockBtnTemplate(btnType)
  if template ~= nil then
    for k, v in ipairs(template.unlock_noviceboot) do
      if DataCenter.GuideManager:IsDoneThisGuide(v) then
        return true
      end
    end
    for k, v in ipairs(template.unlock_building) do
      if CommonUtil.CheckIsBuildEnough(CommonUtil.GetBuildBaseType(v), CommonUtil.GetBuildLv(v)) then
        return true
      end
    end
  end
  return false
end

local function StartUnlockBtn(self, title, intro, btnType)
  UIUtil.ShowGuideBtnUnlockWindow(title, intro, btnType)
end

local function UnlockEffectComplete(self, btnType)
  local template = DataCenter.GuideManager:GetCurTemplate()
  if template ~= nil and template.type == GuideType.UnlockBtn then
    DataCenter.GuideManager:DoNext()
  end
  EventManager:GetInstance():Broadcast(EventId.ShowUnlockBtn, btnType)
end

local function GetUnlockBtnPosition(self, btnType)
  if btnType == UnlockBtnType.Quest then
    return UIUtil.GetUIMainSavePos(UIMainSavePosType.Quest)
  elseif btnType == UnlockBtnType.Build then
    return UIUtil.GetUIMainSavePos(UIMainSavePosType.Build)
  elseif btnType == UnlockBtnType.CityTroop then
    return UIUtil.GetUIMainSavePos(UIMainSavePosType.CityTroop)
  elseif btnType == UnlockBtnType.FastBuild then
    return UIUtil.GetUIMainSavePos(UIMainSavePosType.FastBuild)
  elseif btnType == UnlockBtnType.Tool_Goods or btnType == UnlockBtnType.Tool_Resource or btnType == UnlockBtnType.Tool_ResourceItem then
    return UIUtil.GetUIMainSavePos(UIMainSavePosType.Goods)
  elseif btnType == UnlockBtnType.Search then
    return UIUtil.GetUIMainSavePos(UIMainSavePosType.Search)
  end
end

UnlockBtnManager.__init = __init
UnlockBtnManager.__delete = __delete
UnlockBtnManager.IsShowBtn = IsShowBtn
UnlockBtnManager.UnlockEffectComplete = UnlockEffectComplete
UnlockBtnManager.StartUnlockBtn = StartUnlockBtn
UnlockBtnManager.GetUnlockBtnPosition = GetUnlockBtnPosition
return UnlockBtnManager
