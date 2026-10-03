local NpcTalkManager = BaseClass("NpcTalkManager", Singleton)

function NpcTalkManager:__init()
end

function NpcTalkManager:__delete()
end

function NpcTalkManager:SetUp()
  UIManager:GetInstance():OpenWindow(UIWindowNames.UINpcTalkLayer)
end

function NpcTalkManager:ShowNpcTalk(target, dialogId, offset)
  EventManager:GetInstance():Broadcast(EventId.ShowHeroTalk, {
    target = target,
    dialogId = dialogId,
    offset = offset
  })
end

function NpcTalkManager:ShowTalk(config)
  local guideType = config.type
  local dialogId = config.param2
  local request = CityNpcManager:GetInstance():GetModelObjByName(config.param1)
  if request == nil then
    Logger.LogError("#zlh#, NpcTalkManager:ShowTalk request is null! prefabName:" .. config.param1)
    return
  end
  local target = request.gameObject.transform
  local height = 2
  if guideType ~= GuideType.Wastelan_ShowNpcTalk or config.param4 == 1 then
  else
    UIManager:GetInstance():OpenWindow(UIWindowNames.UINpcTalk, {anim = false}, target, dialogId, Vector3.New(0, height, 0))
  end
end

function NpcTalkManager:ShowGuideTalk(config)
  self:HideTalk()
  local guideType = config.type
  local dialogId = config.param2
  local request = CityNpcManager:GetInstance():GetModelObjByName(config.param1)
  if request == nil then
    Logger.LogError("#zlh#, NpcTalkManager:ShowTalk request is null! prefabName:" .. config.param1)
    return
  end
  local target = request.gameObject.transform
  local height = 2
  UIManager:GetInstance():OpenWindow(UIWindowNames.UINpcTalk, {anim = false}, target, dialogId, Vector3.New(0, height, 0))
end

function NpcTalkManager:HideTalk()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UINpcTalk)
end

return NpcTalkManager
