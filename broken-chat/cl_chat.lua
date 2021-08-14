local chatInputActive = false
local chatInputActivating = false
local chatVisibilityToggle = false

RegisterNetEvent('chatMessage')
RegisterNetEvent('chat:addTemplate')
RegisterNetEvent('chat:addMessage')
RegisterNetEvent('chat:addSuggestion')
RegisterNetEvent('chat:removeSuggestion')
RegisterNetEvent('chat:clear')
RegisterNetEvent('chat:toggleChat')

-- internal events
RegisterNetEvent('__cfx_internal:serverPrint')

RegisterNetEvent('_chat:messageEntered')

--deprecated, use chat:addMessage
AddEventHandler('chatMessage', function(author, color, text)
  local args = { text }
  if author ~= "" then
    table.insert(args, 1, author)
  end
  SendNUIMessage({
    type = 'ON_MESSAGE',
    message = {
      color = color,
      multiline = true,
      args = args
    }
  })
end)

AddEventHandler('__cfx_internal:serverPrint', function(msg)
  print(msg)

  SendNUIMessage({
    type = 'ON_MESSAGE',
    message = {
      color = { 0, 0, 0 },
      multiline = true,
      args = { msg }
    }
  })
end)

AddEventHandler('chat:addMessage', function(message)
  SendNUIMessage({
    type = 'ON_MESSAGE',
    message = message
  })
end)

AddEventHandler('chat:addSuggestion', function(name, help, params)
  SendNUIMessage({
    type = 'ON_SUGGESTION_ADD',
    suggestion = {
      name = name,
      help = help,
      params = params or nil
    }
  })
end)

AddEventHandler('chat:removeSuggestion', function(name)
  SendNUIMessage({
    type = 'ON_SUGGESTION_REMOVE',
    name = name
  })
end)

AddEventHandler('chat:addTemplate', function(id, html)
  SendNUIMessage({
    type = 'ON_TEMPLATE_ADD',
    template = {
      id = id,
      html = html
    }
  })
end)

AddEventHandler('chat:clear', function(name)
  SendNUIMessage({
    type = 'ON_CLEAR'
  })
end)

AddEventHandler('chat:toggleChat',function(newState)
  if(newState == true or newState == false)then
    chatVisibilityToggle = not newState
  else
    chatVisibilityToggle = not chatVisibilityToggle
  end

  local state = (chatVisibilityToggle == true) and "^1disabled" or "^2enabled"

  SendNUIMessage({
    type = 'ON_TOGGLE_CHAT',
    toggle = chatVisibilityToggle
  })

  SendNUIMessage({
  type = 'ON_MESSAGE',
  message = {
    color = {255,255,255},
    multiline = true,
    args = {"Chat Visibility has been "..state}
    }
  })
end)

Citizen.CreateThread(function()
    TriggerEvent('chat:addSuggestion', '/me', 'Displays an in-character message to players in your proximity. Usage: /me [message]')
end)

Citizen.CreateThread(function()
    TriggerEvent('chat:addSuggestion', '/mer', 'Displays a red and bolded in-character message to players in your proximity. Usage: /mer [message]')
end)

Citizen.CreateThread(function()
    TriggerEvent('chat:addSuggestion', '/do', 'Displays an in-character message visible to all players. Usage: /do [message]')
end)

Citizen.CreateThread(function()
    TriggerEvent('chat:addSuggestion', '/twt', 'Displays an in-character tweet visible to all players. Usage: /twt [message]')
end)

Citizen.CreateThread(function()
    TriggerEvent('chat:addSuggestion', '/ooc', 'Displays an out of character message visible to players in your proximity. Usage: /ooc [message]')
end)

Citizen.CreateThread(function()
    TriggerEvent('chat:addSuggestion', '/gooc', 'Displays an out of character message visible to all players. Usage: /gooc [message]')
end)

Citizen.CreateThread(function()
    TriggerEvent('chat:addSuggestion', '/ad', 'Displays an advertisement visible to all players. Usage: /ad [message]')
end)

Citizen.CreateThread(function()
    TriggerEvent('chat:addSuggestion', '/dark', 'Displays an in-character dark web message visible to all players. Cannot be tracked by law enforcement! Usage: /dark [message]')
end)

Citizen.CreateThread(function()
    TriggerEvent('chat:addSuggestion', '/news', 'Displays a news message visible to all players. Usage: /news [message]')
end)

Citizen.CreateThread(function()
    TriggerEvent('chat:addSuggestion', '/tc', 'Toggles the chat on and off. Usage: /tc')
end)

Citizen.CreateThread(function()
    TriggerEvent('chat:addSuggestion', '/dv', 'Deletes the most nearest or seated vehice. Usage: /dv')
end)

Citizen.CreateThread(function()
    TriggerEvent('chat:addSuggestion', '/pip', 'Sets the priority timer to active. Usage: /pip')
end)

Citizen.CreateThread(function()
    TriggerEvent('chat:addSuggestion', '/povr', 'Ends the current active priority, and resets the timer to 20 minutes. Usage: /povr')
end)

Citizen.CreateThread(function()
    TriggerEvent('chat:addSuggestion', '/phold', 'Activates the priority hold option. Usage: /phold')
end)

Citizen.CreateThread(function()
    TriggerEvent('chat:addSuggestion', '/resetpcd', 'Sets priority timer to 0. Usage: /resetpcd')
end)

Citizen.CreateThread(function()
    TriggerEvent('chat:addSuggestion', '/postal', 'Draws a waypoint to the entered postal code. Usage: /postal [number]')
end)

Citizen.CreateThread(function()
    TriggerEvent('chat:addSuggestion', '/fuel', 'Get the current seated vehicles fuel economy. Usage: /fuel')
end)

Citizen.CreateThread(function()
    TriggerEvent('chat:addSuggestion', '/binoculars', 'Equip a pair of binoculars! Usage: /binoculars to enter, and /binoculars to exit.')
end)

Citizen.CreateThread(function()
    TriggerEvent('chat:addSuggestion', '/drag', 'Force drag a player with their server id. Usage: /drag')
end)

Citizen.CreateThread(function()
    TriggerEvent('chat:addSuggestion', '/jail', 'Put a player in jail. Usage: /jail [password] id time')
end)

Citizen.CreateThread(function()
    TriggerEvent('chat:addSuggestion', '/jailme', 'Put yourself in jail. Usage: /jailme')
end)

Citizen.CreateThread(function()
    TriggerEvent('chat:addSuggestion', '/hospital', 'Put a player in the hospital. Usage: /hospital [password] id time')
end)

Citizen.CreateThread(function()
    TriggerEvent('chat:addSuggestion', '/hospitalme', 'Put yourself in the hospital. Usage: /hospitalme')
end)

Citizen.CreateThread(function()
    TriggerEvent('chat:addSuggestion', '/eup', 'Open the EUP interaction menu. Usage: /eup')
end)

Citizen.CreateThread(function()
    TriggerEvent('chat:addSuggestion', '/showcad', 'Open the CAD System. Usage: /showcad')
end)

RegisterCommand("tc",function()
  TriggerEvent('chat:toggleChat')
end)

RegisterNUICallback('chatResult', function(data, cb)
  chatInputActive = false
  SetNuiFocus(false)

  if not data.canceled then
    local id = PlayerId()

    --deprecated
    local r, g, b = 0, 0x99, 255

    if data.message:sub(1, 1) == '/' or data.message:sub(1, 1) == '?' or data.message:sub(1, 1) == '!' or data.message:sub(1, 1) == '.' then -- ****TESTING****
      ExecuteCommand(data.message:sub(2))
    else
      TriggerServerEvent('_chat:messageEntered', GetPlayerName(id), { r, g, b }, data.message)
    end
  end

  cb('ok')
end)

RegisterNUICallback('loaded', function(data, cb)
  TriggerServerEvent('chat:init');

  cb('ok')
end)

Citizen.CreateThread(function()
  SetTextChatEnabled(false)
  SetNuiFocus(false)

  while true do
    Wait(0)

    if not chatInputActive then
      if IsControlPressed(0, 245) --[[ INPUT_MP_TEXT_CHAT_ALL ]] then
        chatInputActive = true
        chatInputActivating = true

        SendNUIMessage({
          type = 'ON_OPEN'
        })
      end
    end

    if chatInputActivating then
      if not IsControlPressed(0, 245) then
        SetNuiFocus(true)

        chatInputActivating = false
      end
    end
  end
end)

AddEventHandler("OFRP:IsChatActive", function(callback)
  callback(chatInputActive)
end)